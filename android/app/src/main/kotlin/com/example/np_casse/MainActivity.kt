package com.example.np_casse

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.stripe.stripeterminal.Terminal
import com.stripe.stripeterminal.external.callable.*
import com.stripe.stripeterminal.external.models.*
import com.stripe.stripeterminal.log.LogLevel
import com.stripe.stripeterminal.external.models.PaymentIntentParameters
import com.stripe.stripeterminal.external.models.CaptureMethod
import android.bluetooth.BluetoothAdapter
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import java.io.IOException
import android.os.Build
import android.provider.Settings
import android.content.Intent
import android.location.LocationManager
import android.app.Activity

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.npcasse/stripe"
    private var terminalInitialized = false
    private lateinit var methodChannel: MethodChannel
    // Create your token provider.
    var tokenProvider: TokenProvider? = null
    private var variableConnectionTokenProvider: VariableConnectionTokenProvider? = null // No default initialization
    private var casseURL: String? = null // Store casseURL globally
    private var permissionsRequested = false
    private var isDiscoveryInProgress = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeStripe" -> {
                    val idUserAppInstitution = call.argument<Int>("idUserAppInstitution")
                    val token = call.argument<String>("token")  // Extract token from Flutter side
                    val casseUrl = call.argument<String>("casseURL") // Extract casseURL
                    isDiscoveryInProgress = false

                    if (idUserAppInstitution != null && token != null  && casseUrl != null) {
                        // Store casseURL globally
                        casseURL = casseUrl
                        // Pass both idUserAppInstitution and token to the method that initializes Stripe
                        initializeTerminal(idUserAppInstitution, token, result, casseURL!!)
                    } else {
                        result.error("MISSING_PARAM", "idUserAppInstitution and token are required", null)
                    }
                }
                "uninitializeStripe" -> {
                    isDiscoveryInProgress = false
                    uninitializeTerminal(result)
                }
                "discoverReaders" -> {
                    permissionsRequested = false    
                    if (terminalInitialized) {
                        val idUserAppInstitution = call.argument<Int>("idUserAppInstitution")
                        val token = call.argument<String>("token")  // Extract token from Flutter side
                        
                        if (idUserAppInstitution != null && token != null) {
                            // Pass both idUserAppInstitution and token to the method that initializes Stripe
                            discoverReaders(idUserAppInstitution, token, result)                    
                        } else {
                            result.error("MISSING_PARAM", "idUserAppInstitution and token are required", null)
                        } 
                    } 
                    else result.error("TERMINAL_NOT_INITIALIZED", "Terminal must be initialized first", null)
                }
                "isReaderConnected" -> {
                    val isConnected = Terminal.getInstance().connectedReader != null
                    result.success(isConnected)
                }
                "getConnectedDeviceInfo" -> getConnectedDeviceInfo(result)
                "disconnectReader" -> {
                    isDiscoveryInProgress = false
                    disconnectReader(result) // Native method to disconnect the reader
                }
                "processPayment" -> {
                    // Extract amount and currency from Flutter arguments
                    val amount = (call.argument<Int>("amount") ?: 0) // Default to 0 if not provided
                    val currency = call.argument<String>("currency") ?: "EUR" // Default to EUR if not provided

                    // Convert amount to Long, as required by the Stripe terminal API
                    val amountInLong: Long = amount.toLong()

                    // Pass the amount and currency to the processPayment method
                    processPayment(amountInLong, currency, result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initializeTerminal(idUserAppInstitution: Int, token: String, result: MethodChannel.Result, casseURL: String) {
        // Set the token globally in ApiClient
        ApiClient.setToken(token)
        ApiClient.initialize(casseURL)  // Initialize your ApiClient here with the provided URL
        val tokenProvider = TokenProvider(idUserAppInstitution)

        if (!Terminal.isInitialized()) {
            try {
                variableConnectionTokenProvider = VariableConnectionTokenProvider(tokenProvider)
                // Initialize the terminal, passing the idUserAppInstitution to TokenProvider
                Terminal.initTerminal(applicationContext, LogLevel.VERBOSE, variableConnectionTokenProvider!!, TerminalEventListener())
                terminalInitialized = true
                result.success("Stripe Initialized")
            } catch (e: TerminalException) {
                terminalInitialized = false
                result.error("INITIALIZATION_ERROR", "${e.message}", null)
            }
        } else { 
            if (variableConnectionTokenProvider != null) {
                // Safely update the provider
                variableConnectionTokenProvider!!.provider = tokenProvider
                terminalInitialized = true
                result.success("Stripe Already Initialized")
            } else {
                // Handle the rare case where the provider is null unexpectedly
                result.error(
                    "PROVIDER_ERROR", 
                    "Connection token provider is not initialized.", 
                    null
                )
            }          
        }
    }

    // Uninitialize the terminal and clear cached credentials
    private fun uninitializeTerminal(result: MethodChannel.Result) {
        if (terminalInitialized) {
            try {
                // Clear any cached credentials
                Terminal.getInstance().clearCachedCredentials()

                // Disconnect from the current reader if any
                val connectedReader = Terminal.getInstance().connectedReader
                if (connectedReader != null) {
                    Terminal.getInstance().disconnectReader(object : Callback {
                        override fun onSuccess() {
                            Log.d("StripeTerminal", "Successfully disconnected from the reader.")
                            terminalInitialized = false
                            result.success("Stripe Terminal Uninitialized and Reader Disconnected.")
                        }

                        override fun onFailure(e: TerminalException) {
                            Log.e("StripeTerminal", "Failed to disconnect: ${e.message}")
                            result.error("DISCONNECT_ERROR", "${e.message}", null)
                        }
                    })
                } else {
                    result.success("Stripe Terminal Uninitialized.")
                }

                terminalInitialized = false
            } catch (e: Exception) {
                Log.e("StripeTerminal", "Error uninitializing terminal: ${e.message}")
                result.error("UNINITIALIZATION_ERROR", "${e.message}", null)
            }
        } else {
            result.success("Stripe Terminal Not Initialized.")
        }
    }

    private fun isLocationEnabled(context: Context): Boolean {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val gpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
        val networkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        return gpsEnabled || networkEnabled
    }

    // Function to prompt the user to enable location services
    private fun promptEnableLocationServices(context: Context) {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        // Ensure that the context is an activity or set the FLAG_ACTIVITY_NEW_TASK flag
        if (context is Activity) {
            context.startActivity(intent)
        } else {
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(intent)
        }
    }


    private fun disconnectReader(result: MethodChannel.Result) {
    val connectedReader = Terminal.getInstance().connectedReader
    if (connectedReader != null) {
        Terminal.getInstance().disconnectReader(object : Callback {
            override fun onSuccess() {
                Log.d("StripeTerminal", "Successfully disconnected the reader.")
                result.success("Reader disconnected successfully.")
            }

            override fun onFailure(e: TerminalException) {
                Log.e("StripeTerminal", "Failed to disconnect: ${e.message}")
                result.error("DISCONNECT_ERROR", "${e.message}", null)
            }
        })
    } else {
        result.error("NO_READER_CONNECTED", "No reader is currently connected.", null)
    }
}


private fun discoverReaders(idUserAppInstitution: Int, token: String, result: MethodChannel.Result) {
    Log.d("StripeTerminal", "Starting discoverReaders function")

    // Check if discovery is already in progress
    if (isDiscoveryInProgress) {
        Log.e("StripeTerminal", "A discovery operation is already in progress.")
        result.error("DISCOVERY_IN_PROGRESS", "A discovery operation is already in progress.", null)
        return
    }

    // Mark discovery as in progress
    isDiscoveryInProgress = true

    // Check if location services are enabled
    if (!isLocationEnabled(applicationContext)) {
        Log.e("StripeTerminal", "Location services are disabled. Please enable them.")
        promptEnableLocationServices(applicationContext)
        result.error("LOCATION_ERROR", "Location services must be enabled.", null)
        // Reset the flag once the function ends
        isDiscoveryInProgress = false
        return
    }

    // Check permissions
    if (checkPermissions()) {
        Log.d("StripeTerminal", "Permissions are granted. Proceeding with GPS and Bluetooth checks.")

        // Ensure Bluetooth is enabled
        if (BluetoothAdapter.getDefaultAdapter()?.isEnabled == false) {
            Log.d("StripeTerminal", "Bluetooth is disabled. Enabling Bluetooth...")
            BluetoothAdapter.getDefaultAdapter().enable()
        }

        // Check if terminal is already connected to a reader
        if (Terminal.getInstance().connectedReader != null) {
            Log.d("StripeTerminal", "Already connected to a reader. Attempting to disconnect.")

            // Disconnect from the current reader before discovering new ones
            Terminal.getInstance().disconnectReader(object : Callback {
                override fun onSuccess() {
                    Log.d("StripeTerminal", "Successfully disconnected from the reader.")
                    startDiscoveringReaders(idUserAppInstitution, token, result)
                }

                override fun onFailure(e: TerminalException) {
                    Log.e("StripeTerminal", "Failed to disconnect from the reader: ${e.message}")
                    result.error("DISCONNECT_ERROR", "${e.message}", null)
                    // Reset the flag after failure
                    isDiscoveryInProgress = false
                }
            })
        } else {
            Log.d("StripeTerminal", "No connected reader. Starting discovery of new readers.")
            startDiscoveringReaders(idUserAppInstitution, token, result)
        }
    } else {
        if (!permissionsRequested) {
            // Only request permissions once to prevent a loop
            permissionsRequested = true
            isDiscoveryInProgress = false
            requestPermissions()
            discoverReaders(idUserAppInstitution, token, result)
        } else {
            // If permissions were requested, and still not granted, return an error
            Log.d("StripeTerminal", "Permissions still not granted, please grant permissions.")
            result.error("PERMISSION_ERROR", "Permissions not granted.", null)
            // Reset the flag after failure
            isDiscoveryInProgress = false
        }
    }
}

private fun startDiscoveringReaders(idUserAppInstitution: Int, token: String, result: MethodChannel.Result) {
    val discoveryConfig = DiscoveryConfiguration.BluetoothDiscoveryConfiguration(isSimulated = false)
    val discoveredReaders = mutableListOf<Reader>()

    val discoveryListener = object : DiscoveryListener {
        override fun onUpdateDiscoveredReaders(readers: List<Reader>) {
            if (readers.isNotEmpty()) {
                val readerToConnect = readers.firstOrNull()
                if (readerToConnect != null) {
                    connectToReader(idUserAppInstitution, token, readerToConnect, result)
                }
                val firstReader = readers.first()

                // Sending the first reader's details
                val readerInfo = mapOf(
                    "serialNumber" to (firstReader.serialNumber ?: "Unknown"),
                    "deviceType" to (firstReader.deviceType.name ?: "Unknown")
                )
                
                // Send the first reader to Flutter
                result.success(readerInfo)
            } else {
                result.success(null) // Send null if no readers are found
            }
        }
    }

    Terminal.getInstance().discoverReaders(discoveryConfig, discoveryListener, object : Callback {
        override fun onSuccess() {
            Log.d("StripeTerminal", "Reader discovery completed")
            // Reset the flag once discovery is successful
            isDiscoveryInProgress = false
        }

        override fun onFailure(e: TerminalException) {
            Log.e("StripeTerminal", "Discovery failed: ${e.message}")
            result.error("DISCOVERY_ERROR", "${e.message}", null)
            // Reset the flag after failure
            isDiscoveryInProgress = false
        }
    })
}

private fun connectToReader(idUserAppInstitution: Int, token: String?, reader: Reader, result: MethodChannel.Result) {
    if (token == null) {
        // Token is null, return an error
        Log.e("StripeTerminal", "Error: Token is null")
        result.error("TOKEN_ERROR", "Token is null and cannot be used.", null)
        return
    }

    val apiUrl = "$casseURL/api/StripeTerminal/Get-location-id-by-iuai"

    // Fetch location ID asynchronously
    fetchLocationId(idUserAppInstitution, token, apiUrl) { locationId, error ->
        if (error != null || locationId.isNullOrBlank() || locationId == null) {
            val errorMessage = error ?: "Location ID is blank or null"
            Log.e("StripeTerminal", "Error fetching location ID: $errorMessage")
            result.error("LOCATION_ID_FETCH_ERROR", "$errorMessage", null)
            return@fetchLocationId  // Exit the function after handling the error
        }

        // If we successfully got the location ID, proceed with the reader connection
        val bluetoothReaderListener = TerminalBluetoothReaderListener()
        val connectionConfig = ConnectionConfiguration.BluetoothConnectionConfiguration(
            locationId = locationId,
            autoReconnectOnUnexpectedDisconnect = true,
            bluetoothReaderListener = bluetoothReaderListener
        )

        // Try to connect to the reader
        Terminal.getInstance().connectReader(reader, connectionConfig, object : ReaderCallback {
            override fun onSuccess(connectedReader: Reader) {
                Log.d("StripeTerminal", "Reader connected: ${connectedReader.serialNumber}")
                notifyFlutterReaderConnection(true)
                val successMessage = mapOf("message" to "Reader connected successfully: ${connectedReader.serialNumber}")
                result.success(successMessage)  // Return success result
            }

            override fun onFailure(e: TerminalException) {
                Log.e("StripeTerminal", "Error connecting to reader: ${e.message}")
                notifyFlutterReaderConnection(false)
                val errorMessage = mapOf("message" to "Error connecting to reader: ${e.message}")
                result.error("CONNECT_ERROR", errorMessage["message"], null)  // Return failure result
            }
        })
    }
}


private fun getConnectedDeviceInfo(result: MethodChannel.Result) {
    val reader = Terminal.getInstance().connectedReader
    if (reader != null) {
        val locationId = reader.location?.id ?: "Unknown"
        
        // Explicitly cast the map to Map<String, Any?> to avoid type mismatch issues
        val deviceInfo: Map<String, Any?> = mapOf(
            "label" to (reader.label ?: "Unknown"),  // Ensure label is not null
            "serialNumber" to (reader.serialNumber ?: "Unknown"), // Ensure serialNumber is not null
            "locationId" to locationId
        )
        result.success(deviceInfo)  // Send the device information to Flutter
    } else {
        // Handle the case where no reader is connected
        result.error("NO_READER_CONNECTED", "No reader connected", null)  // Sending an error response to Flutter
    }
}

private fun fetchLocationId(
    idUserAppInstitution: Int,
    token: String,
    apiUrl: String,
    callback: (locationId: String?, error: String?) -> Unit
) {
    val urlWithParams = "$apiUrl?idUserAppInstitution=$idUserAppInstitution"
    val client = OkHttpClient()
    val request = Request.Builder()
        .url(urlWithParams)
        .addHeader("Authorization", "Bearer $token")
        .post(RequestBody.create(null, ""))  // Assuming the body is empty
        .build()

    var callbackInvoked = false

    client.newCall(request).enqueue(object : okhttp3.Callback {
        override fun onFailure(call: okhttp3.Call, e: IOException) {
            if (callbackInvoked) return
            callbackInvoked = true
            // Call the callback with error message
            callback(null, e.message ?: "Unknown error")
        }

        override fun onResponse(call: okhttp3.Call, response: okhttp3.Response) {
            if (callbackInvoked) return
            callbackInvoked = true

            try {
                // If the response is not successful, return an error
                if (!response.isSuccessful) {
                    callback("Location Id is null", "Failed with HTTP status ${response.code}")
                    return
                }

                // Read response body
                val responseBody = response.body?.string()
                if (responseBody.isNullOrBlank()) {
                    callback("Location Id is null", "Empty response body")
                    return
                }

                try {
                    // Parse JSON response
                    val jsonObject = org.json.JSONObject(responseBody)
                    val locationId = jsonObject.optString("locationID", null)

                    if (locationId.isNullOrBlank()) {
                        callback("Location Id is null", "Received blank or invalid locationID")
                    } else {
                        callback(locationId, null)
                    }
                } catch (e: org.json.JSONException) {
                    // JSON parsing error
                    callback("Location Id is null", "Error parsing response: ${e.message}")
                }
            } catch (e: Exception) {
                // Any other unexpected error

            }
        }
    })
}



    private fun notifyFlutterReaderConnection(isConnected: Boolean) {
        runOnUiThread {
            methodChannel.invokeMethod("updateReaderConnection", isConnected)
        }
    }


private fun processPayment(amount: Long, currency: String, result: MethodChannel.Result) {
    val terminalInstance = Terminal.getInstance()
    val reader = terminalInstance.connectedReader

    if (reader != null) {
        val paymentIntentParams = PaymentIntentParameters.Builder()
            .setAmount(amount) // Amount in cents
            .setCurrency(currency) // Currency
            .setCaptureMethod(CaptureMethod.Automatic) // Set to automatic capture
            .build()

        terminalInstance.createPaymentIntent(paymentIntentParams, object : PaymentIntentCallback {
            override fun onSuccess(paymentIntent: PaymentIntent) {
                terminalInstance.collectPaymentMethod(paymentIntent, object : PaymentIntentCallback {
                    override fun onSuccess(collectedIntent: PaymentIntent) {
                        terminalInstance.confirmPaymentIntent(collectedIntent, object : PaymentIntentCallback {
                            override fun onSuccess(confirmedIntent: PaymentIntent) {
                                if (confirmedIntent.status == PaymentIntentStatus.SUCCEEDED) {
                                    val transactionId = confirmedIntent.id
                                    val paymentResult = mapOf(
                                        "status" to "Payment Successful",
                                        "transactionId" to transactionId
                                    )
                                    result.success(paymentResult)
                                } else {
                                    Log.e("PAYMENT_UNEXPECTED_STATUS",
                                        "${confirmedIntent.status}")
                                    result.error(
                                        "PAYMENT_UNEXPECTED_STATUS",
                                        "${confirmedIntent.status}",
                                        null
                                    )
                                }
                            }

                            override fun onFailure(e: TerminalException) {
                                Log.e("StripeTerminal", "Error confirming payment: ${e.message}")
                                result.error("PAYMENT_CONFIRM_ERROR", "${e.message}", null)
                            }
                        })
                    }

                    override fun onFailure(e: TerminalException) {
                        Log.e("StripeTerminal", "Error collecting payment method: ${e.message}")
                        result.error("PAYMENT_METHOD_ERROR", "${e.message}", null)
                    }
                })
            }

            override fun onFailure(e: TerminalException) {
                Log.e("StripeTerminal", "Error creating PaymentIntent: ${e.message}")
                result.error("PAYMENT_INTENT_ERROR", "${e.message}", null)
            }
        })
    } else {
        Log.e("StripeTerminal", "No connected reader available.")
        result.error("NO_READER", "No reader connected", null)
    }
}

    private fun getBatteryLevel(result: MethodChannel.Result) {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        result.success(batteryLevel)
    }


private fun checkPermissions(): Boolean {
    val missingPermissions = mutableListOf<String>()

    // Check for different permission sets based on Android version
    when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            listOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT
            ).forEach {
                if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                    missingPermissions.add(it)
                }
            }
        }
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
            listOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_ADMIN,
            ).forEach {
                if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                    missingPermissions.add(it)
                }
            }
        }
        else -> {
            listOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ).forEach {
                if (ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED) {
                    missingPermissions.add(it)
                }
            }
        }
    }

    // If there are missing permissions, log them
    if (missingPermissions.isNotEmpty()) {
        Log.d("StripeTerminal", "Missing permissions: ${missingPermissions.joinToString(", ")}")
    }

    return missingPermissions.isEmpty()
}

// Request permissions
private fun requestPermissions() {
    val permissions = mutableListOf<String>()

    when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            permissions.addAll(
                listOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            )
        }
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
            permissions.addAll(
                listOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.BLUETOOTH,
                    Manifest.permission.BLUETOOTH_ADMIN
                )
            )
        }
        else -> {
            permissions.addAll(
                listOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                )
            )
        }
    }

    if (permissions.isNotEmpty()) {
        Log.d("StripeTerminal", "Requesting permissions: ${permissions.joinToString(", ")}")
        ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 1)
    }
}

}
