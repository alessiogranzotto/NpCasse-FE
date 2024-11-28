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

override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    methodChannel.setMethodCallHandler { call, result ->
        when (call.method) {
            "initializeStripe" -> initializeTerminal(result)
            "discoverReaders" -> {
                if (terminalInitialized) discoverReaders(result)
                else result.error("TERMINAL_NOT_INITIALIZED", "Terminal must be initialized first", null)
            }
            "getConnectedDeviceInfo" -> getConnectedDeviceInfo(result)
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



    private fun initializeTerminal(result: MethodChannel.Result) {
        if (!Terminal.isInitialized()) {
            try {
                Terminal.initTerminal(applicationContext, LogLevel.VERBOSE, TokenProvider(), TerminalEventListener())
                terminalInitialized = true
                result.success("Stripe Initialized")
            } catch (e: TerminalException) {
                terminalInitialized = false
                result.error("INITIALIZATION_ERROR", "Error initializing Terminal: ${e.message}", null)
            }
        } else {
            terminalInitialized = true
            result.success("Stripe Already Initialized")
        }
    }

    private fun discoverReaders(result: MethodChannel.Result) {
        if (checkPermissions()) {
            if (BluetoothAdapter.getDefaultAdapter()?.isEnabled == false) {
                BluetoothAdapter.getDefaultAdapter().enable()
            }

            val discoveryConfig = DiscoveryConfiguration.BluetoothDiscoveryConfiguration(isSimulated = false)
            val discoveredReaders = mutableListOf<Reader>()

            val discoveryListener = object : DiscoveryListener {
    override fun onUpdateDiscoveredReaders(readers: List<Reader>) {
        if (readers.isNotEmpty()) {
             val readerToConnect = readers.firstOrNull()
        if (readerToConnect != null) {
            connectToReader(readerToConnect, result)
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
        } else {
            requestPermissions()
        }
    }

    private fun connectToReader(reader: Reader, result: MethodChannel.Result) {
    val apiUrl = "https://apicasse.giveapp.it/api/StripeTerminal/Get-location-id"

    fetchLocationId(apiUrl) { locationId, error ->
        if (error != null) {
            Log.e("StripeTerminal", "Error fetching location ID: $error")
            result.error("LOCATION_ID_FETCH_ERROR", "Failed to fetch location ID: $error", null)
            return@fetchLocationId
        }

        if (locationId.isNullOrBlank()) {
            Log.e("StripeTerminal", "Received blank location ID")
            result.error("INVALID_LOCATION_ID", "Location ID is blank or null", null)
            return@fetchLocationId
        }

        val bluetoothReaderListener = TerminalBluetoothReaderListener()

        val connectionConfig = ConnectionConfiguration.BluetoothConnectionConfiguration(
            locationId = locationId,
            autoReconnectOnUnexpectedDisconnect = true,
            bluetoothReaderListener = bluetoothReaderListener
        )

        Terminal.getInstance().connectReader(reader, connectionConfig, object : ReaderCallback {
            override fun onSuccess(connectedReader: Reader) {
                Log.d("StripeTerminal", "Reader connected: ${connectedReader.serialNumber}")
                notifyFlutterReaderConnection(true)
                // Send the success message to Flutter
                val successMessage = mapOf("message" to "Reader connected successfully: ${connectedReader.serialNumber}")
                result.success(successMessage)
            }

            override fun onFailure(e: TerminalException) {
                Log.e("StripeTerminal", "Error connecting to reader: ${e.message}")
                notifyFlutterReaderConnection(false)
                // Send the error message to Flutter
                val errorMessage = mapOf("message" to "Error connecting to reader: ${e.message}")
                result.error("CONNECT_ERROR", errorMessage["message"], null)
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

    private fun fetchLocationId(apiUrl: String, callback: (locationId: String?, error: String?) -> Unit) {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url(apiUrl)
            .post(RequestBody.create(null, ""))
            .build()

        client.newCall(request).enqueue(object : okhttp3.Callback {
            override fun onFailure(call: okhttp3.Call, e: IOException) {
                callback(null, e.message)
            }

            override fun onResponse(call: okhttp3.Call, response: okhttp3.Response) {
                if (!response.isSuccessful) {
                    callback(null, "Failed with HTTP status ${response.code}")
                    return
                }

                val responseBody = response.body?.string()
                if (responseBody != null) {
                    try {
                        val jsonObject = org.json.JSONObject(responseBody)
                        val locationId = jsonObject.optString("locationID", null)
                        callback(locationId, null)
                    } catch (e: org.json.JSONException) {
                        callback(null, "Error parsing response: ${e.message}")
                    }
                } else {
                    callback(null, "Empty response body")
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
