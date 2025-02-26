package com.example.np_casse

import com.facebook.stetho.okhttp3.StethoInterceptor
import com.stripe.stripeterminal.external.models.ConnectionTokenException
import okhttp3.OkHttpClient
import okhttp3.Request
import retrofit2.Callback
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException

// The 'ApiClient' is a singleton object used to make calls to our backend and return their results
object ApiClient {
    // Variable to store the token that will be added to each request
    private var token: String? = null

    // OkHttpClient builder to add the token dynamically to the headers of each request
    private val client = OkHttpClient.Builder()
        .addNetworkInterceptor(StethoInterceptor())  // Optional, for debugging
        .addInterceptor { chain ->
            val originalRequest: Request = chain.request()

            // If token is set, add Authorization header with Bearer token
            val requestWithHeaders = originalRequest.newBuilder().apply {
                token?.let {
                    header("Authorization", "Bearer $it")
                }
                header("Content-Type", "application/json")
                header("Accept", "application/json")
                header("Access-Control-Allow-Origin", "*")  // You might want to handle CORS more specifically
            }.build()

            // Proceed with the modified request
            chain.proceed(requestWithHeaders)
        }
        .build()

     // Retrofit instance, will be initialized with the provided casseURL
    private var retrofit: Retrofit? = null

    // The service used to call backend endpoints
    internal lateinit var service: BackendService

    // Method to initialize ApiClient with a base URL (casseURL) + '/api/StripeTerminal/'
    fun initialize(casseURL: String) {
        val fullUrl = "$casseURL/api/StripeTerminal/"  // Concatenate the base URL with '/api/StripeTerminal/'

        retrofit = Retrofit.Builder()
            .baseUrl(fullUrl)
            .client(client)  // Attach the custom client
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        service = retrofit!!.create(BackendService::class.java)
    }   

    // Method to set the token for subsequent API calls
    fun setToken(newToken: String) {
        token = newToken
    }

    // Method to create a connection token using the idUserAppInstitution
    @Throws(ConnectionTokenException::class)
    internal fun createConnectionToken(idUserAppInstitution: Int): String {
        try {
            // Call the backend to create a connection token
            val result = service.getConnectionToken(idUserAppInstitution).execute()

            // Check if the response was successful
            if (result.isSuccessful && result.body() != null) {
                return result.body()!!.secret  // Return the secret from the connection token response
            } else {
                throw ConnectionTokenException("Creating connection token failed: ${result.errorBody()?.string()}")
            }
        } catch (e: IOException) {
            throw ConnectionTokenException("Creating connection token failed", e)
        }
    }

    // Method to capture a payment intent on the backend
    internal fun capturePaymentIntent(id: String) {
        try {
            // Execute the payment intent capture API call
            service.capturePaymentIntent(id).execute()
        } catch (e: IOException) {
            // Handle any IOExceptions that may occur during the network call
            throw ConnectionTokenException("Failed to capture payment intent", e)
        }
    }
}
