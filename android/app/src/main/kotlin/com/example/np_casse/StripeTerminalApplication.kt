package com.example.np_casse

import android.app.Application
import androidx.lifecycle.ProcessLifecycleOwner
import com.stripe.stripeterminal.TerminalApplicationDelegate

class StripeTerminalApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // If you already have a class that extends 'Application',
        // put whatever code you had in the 'onCreate' method here.

        TerminalApplicationDelegate.onCreate(this)
    }
}