package com.example.np_casse

import com.stripe.stripeterminal.external.callable.TerminalListener
import com.stripe.stripeterminal.external.models.ConnectionStatus
import com.stripe.stripeterminal.external.models.PaymentStatus

class TerminalEventListener : TerminalListener {
    override fun onConnectionStatusChange(status: ConnectionStatus) { }

    override fun onPaymentStatusChange(status: PaymentStatus) { }
}