package com.android.internal.telephony.imsphone;

import android.net.Uri;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.RegistrationManager;
import android.telephony.ims.aidl.IImsRegistrationCallback;
import android.util.Log;
import java.util.concurrent.Executor;

public class ImsRegistrationCallbackHelper {
    private static final String TAG = "ImsRegCallbackHelper";
    private final RegistrationManager.RegistrationCallback mImsRegistrationCallback;
    /* access modifiers changed from: private */
    public ImsRegistrationUpdate mImsRegistrationUpdate;
    private final Object mLock = new Object();
    private int mRegistrationState = 0;

    public interface ImsRegistrationUpdate {
        void handleImsRegistered(int i);

        void handleImsRegistering(int i);

        void handleImsSubscriberAssociatedUriChanged(Uri[] uriArr);

        void handleImsUnregistered(ImsReasonInfo imsReasonInfo);
    }

    public ImsRegistrationCallbackHelper(ImsRegistrationUpdate imsRegistrationUpdate, Executor executor) {
        AnonymousClass1 r0 = new RegistrationManager.RegistrationCallback() {
            public void onRegistered(int i) {
                ImsRegistrationCallbackHelper.this.updateRegistrationState(2);
                ImsRegistrationCallbackHelper.this.mImsRegistrationUpdate.handleImsRegistered(i);
            }

            public void onRegistering(int i) {
                ImsRegistrationCallbackHelper.this.updateRegistrationState(1);
                ImsRegistrationCallbackHelper.this.mImsRegistrationUpdate.handleImsRegistering(i);
            }

            public void onUnregistered(ImsReasonInfo imsReasonInfo) {
                ImsRegistrationCallbackHelper.this.updateRegistrationState(0);
                ImsRegistrationCallbackHelper.this.mImsRegistrationUpdate.handleImsUnregistered(imsReasonInfo);
            }

            public void onSubscriberAssociatedUriChanged(Uri[] uriArr) {
                ImsRegistrationCallbackHelper.this.mImsRegistrationUpdate.handleImsSubscriberAssociatedUriChanged(uriArr);
            }
        };
        this.mImsRegistrationCallback = r0;
        r0.setExecutor(executor);
        this.mImsRegistrationUpdate = imsRegistrationUpdate;
    }

    public void reset() {
        Log.d(TAG, "reset");
        updateRegistrationState(0);
    }

    public synchronized void updateRegistrationState(int i) {
        synchronized (this.mLock) {
            Log.d(TAG, "updateRegistrationState: registration state from " + RegistrationManager.registrationStateToString(this.mRegistrationState) + " to " + RegistrationManager.registrationStateToString(i));
            this.mRegistrationState = i;
        }
    }

    public int getImsRegistrationState() {
        int i;
        synchronized (this.mLock) {
            i = this.mRegistrationState;
        }
        return i;
    }

    public boolean isImsRegistered() {
        return getImsRegistrationState() == 2;
    }

    public RegistrationManager.RegistrationCallback getCallback() {
        return this.mImsRegistrationCallback;
    }

    public IImsRegistrationCallback getCallbackBinder() {
        return this.mImsRegistrationCallback.getBinder();
    }
}
