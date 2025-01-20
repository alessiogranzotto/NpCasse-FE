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
import android.bluetooth.BluetoothAdapter
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.npcasse/stripe"
    private var terminalInitialized = false
    private lateinit var methodChannel: MethodChannel
    // Create your token provider.
    var tokenProvider: TokenProvider? = null
    private var variableConnectionTokenProvider: VariableConnectionTokenProvider? = null // No default initialization

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeStripe" -> {
                    val idUserAppInstitution = call.argument<Int>("idUserAppInstitution")
                    val token = call.argument<String>("token")  // Extract token from Flutter side
                    
                    if (idUserAppInstitution != null && token != null) {
                        // Pass both idUserAppInstitution and token to the method that initializes Stripe
                        initializeTerminal(idUserAppInstitution, token, result)
                    } else {
                        result.error("MISSING_PARAM", "idUserAppInstitution and token are required", null)
                    }
                }
                "uninitializeStripe" -> {
                    uninitializeTerminal(result)
                }
                "discoverReaders" -> {
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

    private fun initializeTerminal(idUserAppInstitution: Int, token: String, result: MethodChannel.Result) {
        // Set the token globally in ApiClient
        ApiClient.setToken(token)
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
                result.error("INITIALIZATION_ERROR", "Error initializing Terminal: ${e.message}", null)
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
                            result.error("DISCONNECT_ERROR", "Failed to disconnect reader: ${e.message}", null)
                        }
                    })
                } else {
                    result.success("Stripe Terminal Uninitialized.")
                }

                terminalInitialized = false
            } catch (e: Exception) {
                Log.e("StripeTerminal", "Error uninitializing terminal: ${e.message}")
                result.error("UNINITIALIZATION_ERROR", "Error uninitializing terminal: ${e.message}", null)
            }
        } else {
            result.success("Stripe Terminal Not Initialized.")
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
                result.error("DISCONNECT_ERROR", "Failed to disconnect reader: ${e.message}", null)
            }
        })
    } else {
        result.error("NO_READER_CONNECTED", "No reader is currently connected.", null)
    }
}


private fun discoverReaders(idUserAppInstitution: Int, token: String, result: MethodChannel.Result) {
    if (checkPermissions()) {
        if (BluetoothAdapter.getDefaultAdapter()?.isEnabled == false) {
            BluetoothAdapter.getDefaultAdapter().enable()
        }

        // Check if terminal is already connected to a reader
        if (Terminal.getInstance().connectedReader != null) {
            // Disconnect from the current reader before discovering new ones
            Terminal.getInstance().disconnectReader(object : Callback {
                override fun onSuccess() {
                    Log.d("StripeTerminal", "Successfully disconnected from the reader.")
                    startDiscoveringReaders(idUserAppInstitution, token, result)
                }

                override fun onFailure(e: TerminalException) {
                    result.error("DISCONNECT_ERROR", "Failed to disconnect: ${e.message}", null)
                }
            })
        } else {
            startDiscoveringReaders(idUserAppInstitution, token, result)
        }
    } else {
        requestPermissions()
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
        }

        override fun onFailure(e: TerminalException) {
            result.error("DISCOVERY_ERROR", "Failed to discover readers: ${e.message}", null)
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

    val apiUrl = "https://apicasse.giveapp.it/api/StripeTerminal/Get-location-id"

    // Fetch location ID asynchronously
    fetchLocationId(idUserAppInstitution, token, apiUrl) { locationId, error ->
        if (error != null || locationId.isNullOrBlank() || locationId == null) {
            val errorMessage = error ?: "Location ID is blank or null"
            Log.e("StripeTerminal", "Error fetching location ID: $errorMessage")
            result.error("LOCATION_ID_FETCH_ERROR", "Failed to fetch location ID: $errorMessage", null)
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
        methodChannel.invokeMethod("updateReaderConnection", isConnected)
    }


   private fun processPayment(amount: Long, currency: String, result: MethodChannel.Result) {
    val reader = Terminal.getInstance().connectedReader

    if (reader != null) {
        val paymentIntentParams = PaymentIntentParameters.Builder(listOf(PaymentMethodType.CARD_PRESENT))
            .setAmount(amount) // Amount in cents as Long
            .setCurrency(currency) // Currency passed from Flutter
            .build()

        Terminal.getInstance().createPaymentIntent(paymentIntentParams, object : PaymentIntentCallback {
            override fun onSuccess(paymentIntent: PaymentIntent) {
                Terminal.getInstance().collectPaymentMethod(paymentIntent, object : PaymentIntentCallback {
                    override fun onSuccess(paymentIntent: PaymentIntent) {
                        Terminal.getInstance().confirmPaymentIntent(paymentIntent, object : PaymentIntentCallback {
                            override fun onSuccess(paymentIntent: PaymentIntent) {
                                result.success("Payment Successful")
                            }

                            override fun onFailure(e: TerminalException) {
                                Log.e("StripeTerminal", "Payment confirmation error: ${e.message}")
                                result.error("PAYMENT_CONFIRM_ERROR", "Error confirming payment: ${e.message}", null)
                            }
                        })
                    }

                    override fun onFailure(e: TerminalException) {
                        Log.e("StripeTerminal", "Payment method collection error: ${e.message}")
                        result.error("PAYMENT_METHOD_ERROR", "Error collecting payment method: ${e.message}", null)
                    }
                })
            }

            override fun onFailure(e: TerminalException) {
                Log.e("StripeTerminal", "Payment intent creation error: ${e.message}")
                result.error("PAYMENT_INTENT_ERROR", "Error creating payment intent: ${e.message}", null)
            }
        })
    } else {
        result.error("NO_READER", "No reader connected", null)
    }
}



    private fun getBatteryLevel(result: MethodChannel.Result) {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        result.success(batteryLevel)
    }


    private fun checkPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED &&
               ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED &&
               ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.BLUETOOTH_SCAN,
                Manifest.permission.BLUETOOTH_CONNECT
            ),
            1
        )
    }
}
