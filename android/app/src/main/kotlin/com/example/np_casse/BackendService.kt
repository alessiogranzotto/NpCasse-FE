package com.example.np_casse

import retrofit2.Call
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.POST

/**
 * The 'BackendService' interface handles the two simple calls we need to make to our backend.
 * This represents YOUR backend, so feel free to change the routes accordingly.
 */
interface BackendService {

    /**
     * Get a connection token string from the backend
     */
    @POST("Create-connection-token")
    fun getConnectionToken(): Call<ConnectionToken>


    /**
     * Capture a specific payment intent on our backend
     */
    @FormUrlEncoded
    @POST("capture_payment_intent")
    fun capturePaymentIntent(@Field("payment_intent_id") id: String): Call<Void>
}
data class ConnectionToken(
    val secret: String
)
