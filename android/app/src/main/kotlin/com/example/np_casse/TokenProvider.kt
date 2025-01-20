package com.example.np_casse

import android.util.Log
import com.stripe.stripeterminal.external.callable.ConnectionTokenCallback
import com.stripe.stripeterminal.external.callable.ConnectionTokenProvider
import com.stripe.stripeterminal.external.models.ConnectionTokenException
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

// Your original TokenProvider that fetches the connection token
class TokenProvider(private val idUserAppInstitution: Int) : ConnectionTokenProvider {

    override fun fetchConnectionToken(callback: ConnectionTokenCallback) {
        val backendService = ApiClient.service

        // Call to the backend to get the connection token
        backendService.getConnectionToken(idUserAppInstitution).enqueue(object : Callback<ConnectionToken> {
            override fun onResponse(call: Call<ConnectionToken>, response: Response<ConnectionToken>) {
                if (response.isSuccessful) {
                    val connectionToken = response.body()
                    if (connectionToken != null && connectionToken.secret != null) {
                        Log.d("TokenProvider", "Successfully fetched connection token: ${connectionToken.secret}")
                        callback.onSuccess(connectionToken.secret)
                    } else {
                        val errorMessage = "Response body or secret is null"
                        Log.e("TokenProvider", "$errorMessage. Response body: $connectionToken")
                        callback.onFailure(ConnectionTokenException(errorMessage))
                    }
                } else {
                    val errorMessage = response.errorBody()?.string() ?: "Unknown error"
                    val statusCode = response.code()
                    Log.e("TokenProvider", "Error fetching connection token. Status: $statusCode, Error: $errorMessage")
                    callback.onFailure(ConnectionTokenException("Failed to fetch connection token: Status: $statusCode, Error: $errorMessage"))
                }
            }

            override fun onFailure(call: Call<ConnectionToken>, t: Throwable) {
                Log.e("TokenProvider", "Network failure: ${t.message}", t)
                callback.onFailure(ConnectionTokenException("Failed to fetch connection token: ${t.message}"))
            }
        })
    }
}

// This is a wrapper class that allows dynamic changes to the provider
class VariableConnectionTokenProvider(var provider: ConnectionTokenProvider) : ConnectionTokenProvider {
    override fun fetchConnectionToken(callback: ConnectionTokenCallback) {
        provider.fetchConnectionToken(callback)
    }
}