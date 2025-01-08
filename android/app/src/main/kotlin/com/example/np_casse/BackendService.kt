package com.example.np_casse

import retrofit2.Call
import retrofit2.http.FormUrlEncoded
import retrofit2.http.Field
import retrofit2.http.POST
import retrofit2.http.Query

/**
 * The 'BackendService' interface handles the two simple calls we need to make to our backend.
 * This represents YOUR backend, so feel free to change the routes accordingly.
 */
interface BackendService {

    /**
     * Get a connection token string from the backend, with idUserAppInstitution as a query parameter
     */
    @POST("Create-connection-token")
    fun getConnectionToken(@Query("idUserAppInstitution") idUserAppInstitution: Int): Call<ConnectionToken>

    /**
     * Capture a specific payment intent on our backend
     */
    @FormUrlEncoded
    @POST("capture_payment_intent")
    fun capturePaymentIntent(@Field("payment_intent_id") id: String): Call<Void>
}

// ConnectionToken data class that represents the structure of the response
data class ConnectionToken(
    val secret: String
)
