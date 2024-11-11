package com.example.np_casse

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.flutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel ="ro-fe.com/native-code-example";

    override fun configureFlutterEngine(flutterEngine: flutterEngine){
        super.configureFlutterEngine(flutterEngine)
        val method = MethodChannel(flutterEngine.dartExecutor.binaryMessanger, channel)
            method.setMethodCallHandler {
            call, result =>
            if (call.method == "getMessageFromNativeCode")
            {
                val message = getMessage()

                if (message.isNotEmpty())
                {
                    result.success(message)
                }
                else
                {
                    result.error(errorCode: "UNAVAILABLE", errorMessage: "Message from Kotlin code is empty", errorDetails: null)
                }
            } else
            {
                result.notImplemented()
            }   
        }
}
private fun getMessage() : String {return "message from Kotlin code"}}