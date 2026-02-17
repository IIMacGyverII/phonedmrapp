package com.android.internal.telephony.imsphone;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.net.Uri;
import android.telephony.PhoneNumberUtils;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.UUSInfo;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ImsExternalConnection extends Connection {
    private static final String CONFERENCE_PREFIX = "conf";
    private ImsExternalCall mCall;
    private int mCallId;
    private final Context mContext;
    private boolean mIsPullable;
    private final Set<Listener> mListeners = Collections.newSetFromMap(new ConcurrentHashMap(8, 0.9f, 1));
    private Uri mOriginalAddress;

    public interface Listener {
        void onPullExternalCall(ImsExternalConnection imsExternalConnection);
    }

    public void cancelPostDial() {
    }

    public long getDisconnectTime() {
        return 0;
    }

    public long getHoldDurationMillis() {
        return 0;
    }

    public int getPreciseDisconnectCause() {
        return 0;
    }

    public UUSInfo getUUSInfo() {
        return null;
    }

    public String getVendorDisconnectCause() {
        return null;
    }

    public void hangup() throws CallStateException {
    }

    public boolean isMultiparty() {
        return false;
    }

    public void proceedAfterWaitChar() {
    }

    public void proceedAfterWildChar(String str) {
    }

    public void separate() throws CallStateException {
    }

    protected ImsExternalConnection(Phone phone, int i, Uri uri, boolean z) {
        super(phone.getPhoneType());
        this.mContext = phone.getContext();
        this.mCall = new ImsExternalCall(phone, this);
        this.mCallId = i;
        setExternalConnectionAddress(uri);
        this.mNumberPresentation = 1;
        this.mIsPullable = z;
        rebuildCapabilities();
        setActive();
    }

    public int getCallId() {
        return this.mCallId;
    }

    public Call getCall() {
        return this.mCall;
    }

    public void deflect(String str) throws CallStateException {
        throw new CallStateException("Deflect is not supported for external calls");
    }

    public void transfer(String str, boolean z) throws CallStateException {
        throw new CallStateException("Transfer is not supported for external calls");
    }

    public void consultativeTransfer(Connection connection) throws CallStateException {
        throw new CallStateException("Transfer is not supported for external calls");
    }

    public int getNumberPresentation() {
        return this.mNumberPresentation;
    }

    public void pullExternalCall() {
        for (Listener onPullExternalCall : this.mListeners) {
            onPullExternalCall.onPullExternalCall(this);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setActive() {
        ImsExternalCall imsExternalCall = this.mCall;
        if (imsExternalCall != null) {
            imsExternalCall.setActive();
        }
    }

    public void setTerminated() {
        ImsExternalCall imsExternalCall = this.mCall;
        if (imsExternalCall != null) {
            imsExternalCall.setTerminated();
        }
    }

    public void setIsPullable(boolean z) {
        this.mIsPullable = z;
        rebuildCapabilities();
    }

    public void setExternalConnectionAddress(Uri uri) {
        this.mOriginalAddress = uri;
        if (!"sip".equals(uri.getScheme()) || !uri.getSchemeSpecificPart().startsWith(CONFERENCE_PREFIX)) {
            this.mAddress = PhoneNumberUtils.convertSipUriToTelUri(uri).getSchemeSpecificPart();
            return;
        }
        this.mCnapName = this.mContext.getString(17039880);
        this.mCnapNamePresentation = 1;
        this.mAddress = "";
        this.mNumberPresentation = 2;
    }

    public void addListener(Listener listener) {
        this.mListeners.add(listener);
    }

    public void removeListener(Listener listener) {
        this.mListeners.remove(listener);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder(128);
        sb.append("[ImsExternalConnection dialogCallId:");
        sb.append(this.mCallId);
        sb.append(" state:");
        if (this.mCall.getState() == Call.State.ACTIVE) {
            sb.append("Active");
        } else if (this.mCall.getState() == Call.State.DISCONNECTED) {
            sb.append("Disconnected");
        }
        sb.append("]");
        return sb.toString();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void rebuildCapabilities() {
        setConnectionCapabilities(this.mIsPullable ? 48 : 16);
    }
}
