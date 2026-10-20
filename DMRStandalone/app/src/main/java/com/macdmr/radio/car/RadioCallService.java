package com.macdmr.radio.car;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.telecom.CallAudioState;
import android.telecom.Connection;
import android.telecom.ConnectionRequest;
import android.telecom.ConnectionService;
import android.telecom.DisconnectCause;
import android.telecom.PhoneAccount;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.util.Log;

import com.macdmr.radio.RadioService;

/**
 * A steering-wheel transmission as a self-managed call, so it can use the car's microphone and still be stopped from
 * the wheel: while the hands-free link is open the car treats the wheel as call controls and sends no media keys, but
 * it does send hang-up, which Android delivers here as {@link Connection#onDisconnect}. The call carries no audio of
 * its own; it only makes Android open the hands-free link (car microphone) and route the car's End and hang-up to us.
 */
public final class RadioCallService extends ConnectionService {
    private static final String TAG = "RadioCall";
    public static final String ACCOUNT = "dmr-radio-talk";
    private static volatile Talk current;

    public static PhoneAccountHandle handle(Context c) { return new PhoneAccountHandle(new ComponentName(c, RadioCallService.class), ACCOUNT); }

    /** Register the calling account (self-managed: no dialer, no call log). False when Telecom refuses. */
    public static boolean register(Context c) {
        try {
            TelecomManager tm = (TelecomManager) c.getSystemService(Context.TELECOM_SERVICE);
            PhoneAccount pa = PhoneAccount.builder(handle(c), "DMR Radio Talk").setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED).addSupportedUriScheme("radio").build();
            tm.registerPhoneAccount(pa);
            return true;
        } catch (Throwable t) { Log.w(TAG, "register: " + t); return false; }
    }

    /** Start a talk "call"; the radio keys when the car's audio route is up. Error text or null. */
    public static String start(Context c) {
        try {
            if (current != null) return "already in a talk call";
            TelecomManager tm = (TelecomManager) c.getSystemService(Context.TELECOM_SERVICE);
            Bundle extras = new Bundle(); extras.putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, handle(c));
            if (!tm.isOutgoingCallPermitted(handle(c))) return "Android does not permit a call now";
            tm.placeCall(Uri.fromParts("radio", "talk", null), extras);
            return null;
        } catch (Throwable t) { Log.w(TAG, "start: " + t); return String.valueOf(t.getMessage()); }
    }

    /** End the talk call (the transmission stopped by other means). */
    public static void end() { Talk t = current; if (t != null) t.finish(DisconnectCause.LOCAL); }
    public static boolean active() { return current != null; }

    @Override public Connection onCreateOutgoingConnection(PhoneAccountHandle acct, ConnectionRequest req) {
        Talk t = new Talk();
        t.setConnectionProperties(Connection.PROPERTY_SELF_MANAGED);
        t.setAudioModeIsVoip(true);
        t.setAddress(Uri.fromParts("radio", "talk", null), TelecomManager.PRESENTATION_ALLOWED);
        t.setCallerDisplayName("DMR Radio: talking", TelecomManager.PRESENTATION_ALLOWED);
        t.setInitializing();
        t.setActive();
        current = t;
        Log.i(TAG, "talk call created");
        return t;
    }

    @Override public void onCreateOutgoingConnectionFailed(PhoneAccountHandle acct, ConnectionRequest req) {
        Log.w(TAG, "talk call refused by Telecom");
        RadioService s = RadioService.running; if (s != null) s.talkCallFailed();
    }

    static final class Talk extends Connection {
        private boolean keyed, done;
        @Override public void onCallAudioStateChanged(CallAudioState st) {
            Log.i(TAG, "audio route " + CallAudioState.audioRouteToString(st.getRoute()));
            if ((st.getSupportedRouteMask() & CallAudioState.ROUTE_BLUETOOTH) != 0 && st.getRoute() != CallAudioState.ROUTE_BLUETOOTH) setAudioRoute(CallAudioState.ROUTE_BLUETOOTH);
            if (!keyed && (st.getRoute() == CallAudioState.ROUTE_BLUETOOTH || (st.getSupportedRouteMask() & CallAudioState.ROUTE_BLUETOOTH) == 0)) {
                keyed = true;
                RadioService s = RadioService.running; if (s != null) s.talkCallReady(st.getRoute() == CallAudioState.ROUTE_BLUETOOTH);
            }
        }
        @Override public void onDisconnect() { Log.i(TAG, "hung up from the car"); RadioService s = RadioService.running; if (s != null) s.talkCallHungUp(); finish(DisconnectCause.LOCAL); }
        @Override public void onAbort() { finish(DisconnectCause.CANCELED); }
        @Override public void onReject() { finish(DisconnectCause.REJECTED); }
        void finish(int cause) {
            if (done) return; done = true;
            if (current == this) current = null;
            setDisconnected(new DisconnectCause(cause)); destroy();
        }
    }
}
