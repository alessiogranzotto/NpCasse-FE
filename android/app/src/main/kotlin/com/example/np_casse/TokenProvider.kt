package com.example.np_casse

import android.util.Log  // Import the Log class for debugging purposes
import com.stripe.stripeterminal.external.callable.ConnectionTokenCallback
import com.stripe.stripeterminal.external.callable.ConnectionTokenProvider
import com.stripe.stripeterminal.external.models.ConnectionTokenException
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class TokenProvider(private val idUserAppInstitution: Int) : ConnectionTokenProvider {

    // Override the fetchConnectionToken method
    override fun fetchConnectionToken(callback: ConnectionTokenCallback) {
        // Use ApiClient directly to get the service
        val backendService = ApiClient.service

        // Call the getConnectionToken method from the BackendService
        backendService.getConnectionToken(idUserAppInstitution).enqueue(object : Callback<ConnectionToken> {
            override fun onResponse(call: Call<ConnectionToken>, response: Response<ConnectionToken>) {
                if (response.isSuccessful) {
                    val connectionToken = response.body()
                    if (connectionToken != null) {
                        // Log the response for debugging
                        Log.d("TokenProvider", "Successfully fetched connection token: ${connectionToken.secret}")
                        callback.onSuccess(connectionToken.secret)
                    } else {
                        val errorMessage = "Response body is null"
                        Log.e("TokenProvider", errorMessage)
                        callback.onFailure(ConnectionTokenException(errorMessage))
                    }
                } else {
                    // Capture detailed error info from the response
                    val errorMessage = response.errorBody()?.string() ?: "Unknown error"
                    val statusCode = response.code()
                    Log.e("TokenProvider", "Error fetching connection token. Status: $statusCode, Error: $errorMessage")
                    callback.onFailure(ConnectionTokenException("Failed to fetch connection token: $errorMessage"))
                }
            }

            override fun onFailure(call: Call<ConnectionToken>, t: Throwable) {
                // Handle network or other failures
                Log.e("TokenProvider", "Network failure: ${t.message}", t)
                callback.onFailure(ConnectionTokenException("Failed to fetch connection token: ${t.message}"))
            }
        })
    }
}
