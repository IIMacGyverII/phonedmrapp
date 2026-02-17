package com.android.internal.telephony;

import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothMapClient;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.net.Uri;
import android.telephony.Rlog;
import android.telephony.SubscriptionInfo;
import android.util.Log;
import java.util.Collection;
import java.util.Collections;

public class BtSmsInterfaceManager {
    private static final String LOG_TAG = "BtSmsInterfaceManager";

    public void sendText(Context context, String str, String str2, PendingIntent pendingIntent, PendingIntent pendingIntent2, SubscriptionInfo subscriptionInfo) {
        BluetoothAdapter defaultAdapter = BluetoothAdapter.getDefaultAdapter();
        if (defaultAdapter == null) {
            sendErrorInPendingIntent(pendingIntent, 25);
            return;
        }
        BluetoothDevice remoteDevice = defaultAdapter.getRemoteDevice(subscriptionInfo.getIccId());
        if (remoteDevice == null) {
            Log.d(LOG_TAG, "Bluetooth device addr invalid: " + Rlog.pii(LOG_TAG, subscriptionInfo.getIccId()));
            sendErrorInPendingIntent(pendingIntent, 26);
        } else if (!defaultAdapter.getProfileProxy(context.getApplicationContext(), new MapMessageSender(str, str2, remoteDevice, pendingIntent, pendingIntent2), 18)) {
            throw new RuntimeException("Can't send message through BluetoothMapClient");
        }
    }

    /* access modifiers changed from: private */
    public void sendErrorInPendingIntent(PendingIntent pendingIntent, int i) {
        if (pendingIntent != null) {
            try {
                pendingIntent.send(i);
            } catch (PendingIntent.CanceledException e) {
                Log.d(LOG_TAG, "PendingIntent.CanceledException: " + e.getMessage());
            }
        }
    }

    private class MapMessageSender implements BluetoothProfile.ServiceListener {
        final PendingIntent mDeliveryIntent;
        final Collection<Uri> mDestAddr;
        final BluetoothDevice mDevice;
        private String mMessage;
        final PendingIntent mSentIntent;

        MapMessageSender(String str, String str2, BluetoothDevice bluetoothDevice, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
            this.mDestAddr = Collections.singleton(new Uri.Builder().appendPath(str).scheme("tel").build());
            this.mMessage = str2;
            this.mDevice = bluetoothDevice;
            this.mSentIntent = pendingIntent;
            this.mDeliveryIntent = pendingIntent2;
        }

        public void onServiceConnected(int i, BluetoothProfile bluetoothProfile) {
            Log.d(BtSmsInterfaceManager.LOG_TAG, "Service connected");
            if (i == 18) {
                BluetoothMapClient bluetoothMapClient = (BluetoothMapClient) bluetoothProfile;
                if (this.mMessage != null) {
                    Log.d(BtSmsInterfaceManager.LOG_TAG, "Sending message thru bluetooth");
                    bluetoothMapClient.sendMessage(this.mDevice, this.mDestAddr, this.mMessage, this.mSentIntent, this.mDeliveryIntent);
                    this.mMessage = null;
                }
                BluetoothAdapter.getDefaultAdapter().closeProfileProxy(18, bluetoothMapClient);
            }
        }

        public void onServiceDisconnected(int i) {
            if (this.mMessage != null) {
                Log.d(BtSmsInterfaceManager.LOG_TAG, "Bluetooth disconnected before sending the message");
                BtSmsInterfaceManager.this.sendErrorInPendingIntent(this.mSentIntent, 27);
                this.mMessage = null;
            }
        }
    }
}
