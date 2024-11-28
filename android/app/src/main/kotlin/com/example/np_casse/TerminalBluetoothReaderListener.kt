package com.example.np_casse

import com.stripe.stripeterminal.external.callable.Cancelable
import com.stripe.stripeterminal.external.callable.MobileReaderListener
import com.stripe.stripeterminal.external.models.BatteryStatus
import com.stripe.stripeterminal.external.models.DisconnectReason
import com.stripe.stripeterminal.external.models.Reader
import com.stripe.stripeterminal.external.models.ReaderEvent
import com.stripe.stripeterminal.external.models.ReaderDisplayMessage
import com.stripe.stripeterminal.external.models.ReaderInputOptions
import com.stripe.stripeterminal.external.models.ReaderSoftwareUpdate
import com.stripe.stripeterminal.external.models.TerminalException

/**
 * Use the [MobileReaderListener] interface for the entire duration of your connection to a reader.
 * It receives events related to the reader's status and provides opportunities for you to update
 * the reader's software.
 */
class TerminalBluetoothReaderListener : MobileReaderListener {

    override fun onDisconnect(reason: DisconnectReason) {
        // Show the UI that indicates your reader has disconnected
    }

    override fun onReportAvailableUpdate(update: ReaderSoftwareUpdate) {
        // Check if an update is available
    }

    override fun onStartInstallingUpdate(update: ReaderSoftwareUpdate, cancelable: Cancelable?) {
        // Show the UI indicating that the required update has started installing
    }

    override fun onReportReaderSoftwareUpdateProgress(progress: Float) {
        // Update the progress of the install
    }

    override fun onFinishInstallingUpdate(update: ReaderSoftwareUpdate?, e: TerminalException?) {
        // Report success or failure of the update
    }

    override fun onRequestReaderInput(options: ReaderInputOptions) { }

    override fun onRequestReaderDisplayMessage(message: ReaderDisplayMessage) { }

    override fun onReportLowBatteryWarning() { }

    override fun onBatteryLevelUpdate(batteryLevel: Float, batteryStatus: BatteryStatus, isCharging: Boolean) { }

    override fun onReportReaderEvent(event: ReaderEvent) { }

    override fun onReaderReconnectStarted(reader: Reader, cancelReconnect: Cancelable, reason: DisconnectReason) { }

    override fun onReaderReconnectSucceeded(reader: Reader) { }

    override fun onReaderReconnectFailed(reader: Reader) { }
}