package com.example.np_casse

import com.facebook.stetho.okhttp3.StethoInterceptor
import com.stripe.stripeterminal.external.models.ConnectionTokenException
import okhttp3.OkHttpClient
import retrofit2.Callback
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException

// The 'ApiClient' is a singleton object used to make calls to our backend and return their results
object ApiClient {

    const val BACKEND_URL = "https://apicasse.giveapp.it/api/StripeTerminal/"

    private val client = OkHttpClient.Builder()
        .addNetworkInterceptor(StethoInterceptor())
        .build()
    private val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(BACKEND_URL)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
    private val service: BackendService = retrofit.create(BackendService::class.java)

    @Throws(ConnectionTokenException::class)
internal fun createConnectionToken(): String {
    try {
        val result = service.getConnectionToken().execute()
        if (result.isSuccessful && result.body() != null) {
            return result.body()!!.secret  // Use 'secret' based on backend response
        } else {
            throw ConnectionTokenException("Creating connection token failed: ${result.errorBody()?.string()}")
        }
    } catch (e: IOException) {
        throw ConnectionTokenException("Creating connection token failed", e)
    }
}


    internal fun capturePaymentIntent(id: String) {
        service.capturePaymentIntent(id).execute()
    }
}
