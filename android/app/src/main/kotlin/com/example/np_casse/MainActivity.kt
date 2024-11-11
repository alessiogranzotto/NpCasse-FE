// package com.example.np_casse

// import android.content.Context
// import android.content.ContextWrapper
// import android.content.Intent
// import android.content.IntentFilter
// import android.os.BatteryManager
// import android.os.Build.VERSION
// import android.os.Build.VERSION_CODES

// import android.widget.Toast
// import androidx.annotation.NonNull
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// class MainActivity: FlutterActivity() {
//     private val CHANNEL = "com.example.npcasse/stripe"

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         val method = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)


//         method.setMethodCallHandler {
//             // This method is invoked on the main thread.
//                 call, result ->
//                 when (call.method) 
//                 { 
//                 "getBatteryLevel" -> {
//                     val batteryLevel = getBatteryLevel()

//                     if (batteryLevel != -1) {
//                         result.success(batteryLevel)
//                     } else {
//                         result.error("UNAVAILABLE", "Battery level not available.", null)
//                     }
//                 } 
//                 "userName" -> {
//                     val userName = call.argument<String>("username")
//                     Toast.makeText(this, userName, Toast.LENGTH_LONG).show()
//                     result.success(userName)
//                 } 

//                 "initializeStripe" -> {
//                     val publishableKey = call.arguments as String
//                     initializeStripe(publishableKey)
//                     result.success("Stripe Initialized")
//                 }
//                 "createPaymentIntent" -> {
//                     val amount = call.arguments as Double
//                     createPaymentIntent(amount, result)
//                 }
//                 "presentPaymentSheet" -> {
//                     val amount = call.arguments as Double
//                     presentPaymentSheet()
//                 }
//                 else -> result.notImplemented()
//             } 
//         }
//     }



//     private fun initializeStripe(publishableKey: String) {
//         PaymentConfiguration.init(applicationContext, publishableKey)
//         paymentSheet = PaymentSheet(this, ::onPaymentSheetResult)
//     }

//     private fun createPaymentIntent(amount: Double, result: MethodChannel.Result) {
//         // Call your backend here to create a PaymentIntent and get clientSecret
//         // For example, you might use Retrofit or OkHttp to call your server
//         // Here, we're assuming you've obtained a `clientSecret` after creating PaymentIntent on server
//         clientSecret = "YOUR_CLIENT_SECRET_FROM_SERVER"
//         result.success(clientSecret)
//     }

//     private fun onPaymentSheetResult(paymentSheetResult: PaymentSheetResult) {
//         when (paymentSheetResult) {
//             is PaymentSheetResult.Completed -> {
//                 // Payment successful
//             }
//             is PaymentSheetResult.Canceled -> {
//                 // Payment was canceled by the user
//             }
//             is PaymentSheetResult.Failed -> {
//                 // Handle the failure case
//             }
//         }
//     }

//     private fun presentPaymentSheet() {
//         clientSecret?.let {
//             paymentSheet.presentWithPaymentIntent(
//                 it,
//                 PaymentSheet.Configuration("Your Merchant Name")
//             )
//         }
//     }
    

//     override fun onRequestPermissionsResult(
//     requestCode: Int,
//     permissions: Array<String>,
//     grantResults: IntArray
//     ) {
//     super.onRequestPermissionsResult(requestCode, permissions, grantResults)

//     if (requestCode == REQUEST_CODE_LOCATION && grantResults.isNotEmpty()
//         && grantResults[0] != PackageManager.PERMISSION_GRANTED
//     ) 
//         {
//             throw RuntimeException("Location services are required in order to " + "connect to a reader.")
//         }
//         else
//         {
//             Toast.makeText(this, "onRequestPermissionsResult", Toast.LENGTH_LONG).show()
//         }
//     }




//     private fun getBatteryLevel(): Int {
//         val batteryLevel: Int
//         if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//             val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//             batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//         } else {
//             val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//             batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
//         }

//         return batteryLevel
//     }

//     private fun scan(): Int {
//         val result: Int
//         result=0
//          if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) 
//          {
//                 val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
//                 // Define the REQUEST_CODE_LOCATION on your app level
//                 ActivityCompat.requestPermissions(this, permissions, REQUEST_CODE_LOCATION)
//                 result=1
//         }
//         return result
//     }
// }


package com.stripe.example

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.ContextThemeWrapper
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.stripe.stripeterminal.Terminal
import com.stripe.stripeterminal.external.callable.*
import com.stripe.stripeterminal.external.models.DiscoveryConfiguration
import com.stripe.stripeterminal.log.LogLevel
import com.stripe.stripeterminal.external.models.*
import retrofit2.Call
import retrofit2.Response
import java.lang.ref.WeakReference

class MainActivity : AppCompatActivity() {

    // Register the permissions callback to handles the response to the system permissions dialog.
    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions(),
        ::onPermissionResult
    )

    companion object {
        // The code that denotes the request for location permissions
        private const val REQUEST_CODE_LOCATION = 1

        private val paymentIntentParams =
            PaymentIntentParameters.Builder(listOf(PaymentMethodType.CARD_PRESENT))
            .setAmount(500)
            .setCurrency("eur")
            .build()

        private val discoveryConfig =
            DiscoveryConfiguration.BluetoothDiscoveryConfiguration(isSimulated = true)
        /*** Payment processing callbacks ***/

        // (Step 1 found below in the startPayment function)
        // Step 2 - once we've created the payment intent, it's time to read the card
        private val createPaymentIntentCallback by lazy {
            object : PaymentIntentCallback {
                override fun onSuccess(paymentIntent: PaymentIntent) {
                    Terminal.getInstance()
                        .collectPaymentMethod(paymentIntent, collectPaymentMethodCallback)
                }

                override fun onFailure(e: TerminalException) {
                    // Update UI w/ failure
                }
            }
        }

        // Step 3 - we've collected the payment method, so it's time to confirm the payment
        private val collectPaymentMethodCallback by lazy {
            object : PaymentIntentCallback {
                override fun onSuccess(paymentIntent: PaymentIntent) {
                    Terminal.getInstance().confirmPaymentIntent(paymentIntent, confirmPaymentIntentCallback)
                }

                override fun onFailure(e: TerminalException) {
                    // Update UI w/ failure
                }
            }
        }

        // Step 4 - we've confirmed the payment! Show a success screen
        private val confirmPaymentIntentCallback by lazy {
            object : PaymentIntentCallback {
                override fun onSuccess(paymentIntent: PaymentIntent) {
                    ApiClient.capturePaymentIntent(paymentIntent.id)
                }

                override fun onFailure(e: TerminalException) {
                    // Update UI w/ failure
                }
            }
        }
    }

    private val readerClickListener = ReaderClickListener(WeakReference(this))
    private val readerAdapter = ReaderAdapter(readerClickListener)

    /**
     * Upon starting, we should verify we have the permissions we need, then start the app
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        if (BluetoothAdapter.getDefaultAdapter()?.isEnabled == false) {
            BluetoothAdapter.getDefaultAdapter().enable()
        }

        findViewById<RecyclerView>(R.id.reader_recycler_view).apply {
            adapter = readerAdapter
        }

        findViewById<View>(R.id.discover_button).setOnClickListener {
            discoverReaders()
        }

        findViewById<View>(R.id.collect_payment_button).setOnClickListener {
            startPayment()
        }
    }

    override fun onResume() {
        super.onResume()
        requestPermissionsIfNecessary()
    }

    private fun isGranted(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissionsIfNecessary() {
        if (Build.VERSION.SDK_INT >= 31) {
            requestPermissionsIfNecessarySdk31()
        } else {
            requestPermissionsIfNecessarySdkBelow31()
        }
    }

    private fun requestPermissionsIfNecessarySdkBelow31() {
        // Check for location permissions
        if (!isGranted(Manifest.permission.ACCESS_FINE_LOCATION)) {
            // If we don't have them yet, request them before doing anything else
            requestPermissionLauncher.launch(arrayOf(Manifest.permission.ACCESS_FINE_LOCATION))
        } else if (!Terminal.isInitialized() && verifyGpsEnabled()) {
            initialize()
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun requestPermissionsIfNecessarySdk31() {
        // Check for location and bluetooth permissions
        val deniedPermissions = mutableListOf<String>().apply {
            if (!isGranted(Manifest.permission.ACCESS_FINE_LOCATION)) add(Manifest.permission.ACCESS_FINE_LOCATION)
            if (!isGranted(Manifest.permission.BLUETOOTH_CONNECT)) add(Manifest.permission.BLUETOOTH_CONNECT)
            if (!isGranted(Manifest.permission.BLUETOOTH_SCAN)) add(Manifest.permission.BLUETOOTH_SCAN)
        }.toTypedArray()

        if (deniedPermissions.isNotEmpty()) {
            // If we don't have them yet, request them before doing anything else
            requestPermissionLauncher.launch(deniedPermissions)
        } else if (!Terminal.isInitialized() && verifyGpsEnabled()) {
            initialize()
        }
    }

    /**
     * Receive the result of our permissions check, and initialize if we can
     */
    private fun onPermissionResult(result: Map<String, Boolean>) {
        val deniedPermissions: List<String> = result
            .filter { !it.value }
            .map { it.key }

        // If we receive a response to our permission check, initialize
        if (deniedPermissions.isEmpty() && !Terminal.isInitialized() && verifyGpsEnabled()) {
            initialize()
        }
    }

    fun updateReaderConnection(isConnected: Boolean) {
        val recyclerView = findViewById<RecyclerView>(R.id.reader_recycler_view)
        findViewById<View>(R.id.collect_payment_button).visibility =
            if (isConnected) View.VISIBLE else View.INVISIBLE
        findViewById<View>(R.id.discover_button).visibility =
            if (isConnected) View.INVISIBLE else View.VISIBLE
        recyclerView.visibility = if (isConnected) View.INVISIBLE else View.VISIBLE

        if (!isConnected) {
            recyclerView.layoutManager = LinearLayoutManager(this)
            recyclerView.adapter = readerAdapter
        }
    }

    private fun initialize() {
        // Initialize the Terminal as soon as possible
        try {
            Terminal.initTerminal(
                applicationContext, LogLevel.VERBOSE, TokenProvider(), TerminalEventListener()
            )
        } catch (e: TerminalException) {
            throw RuntimeException(
                "Location services are required in order to initialize " +
                        "the Terminal.",
                e
            )
        }

        val isConnectedToReader = Terminal.getInstance().connectedReader != null
        updateReaderConnection(isConnectedToReader)
    }

    private fun discoverReaders() {
        val discoveryCallback = object : Callback {
            override fun onSuccess() {
                // Update your UI
            }

            override fun onFailure(e: TerminalException) {
                // Update your UI
            }
        }

        val discoveryListener = object : DiscoveryListener {
            override fun onUpdateDiscoveredReaders(readers: List<Reader>) {
                runOnUiThread {
                    readerAdapter.updateReaders(readers)
                }
            }
        }

        Terminal.getInstance().discoverReaders(discoveryConfig, discoveryListener, discoveryCallback)
    }

    private fun startPayment() {
        // Step 1: create payment intent
        Terminal.getInstance().createPaymentIntent(paymentIntentParams, createPaymentIntentCallback)
    }

    private fun verifyGpsEnabled(): Boolean {
        val locationManager: LocationManager? =
            applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager?
        var gpsEnabled = false

        try {
            gpsEnabled = locationManager?.isProviderEnabled(LocationManager.GPS_PROVIDER) ?: false
        } catch (exception: Exception) {}

        if (!gpsEnabled) {
            // notify user
            AlertDialog.Builder(ContextThemeWrapper(this, R.style.Theme_MaterialComponents_DayNight_DarkActionBar))
                .setMessage("Please enable location services")
                .setCancelable(false)
                .setPositiveButton("Open location settings") { param, paramInt ->
                    this.startActivity(Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS))
                }
                .create()
                .show()
        }

        return gpsEnabled
    }
}