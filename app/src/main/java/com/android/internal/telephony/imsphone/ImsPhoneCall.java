package com.android.internal.telephony.imsphone;

import android.compat.annotation.UnsupportedAppUsage;
import android.telephony.ims.ImsStreamMediaProfile;
import com.android.ims.ImsCall;
import com.android.ims.ImsException;
import com.android.ims.internal.ConferenceParticipant;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CallStateException;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ImsPhoneCall extends Call {
    public static final String CONTEXT_BACKGROUND = "BG";
    public static final String CONTEXT_FOREGROUND = "FG";
    public static final String CONTEXT_HANDOVER = "HO";
    public static final String CONTEXT_RINGING = "RG";
    public static final String CONTEXT_UNKNOWN = "UK";
    private static final boolean DBG = Rlog.isLoggable(LOG_TAG, 3);
    private static final boolean FORCE_DEBUG = false;
    private static final String LOG_TAG = "ImsPhoneCall";
    private static final boolean VDBG = Rlog.isLoggable(LOG_TAG, 2);
    private final String mCallContext;
    protected boolean mIsRingbackTonePlaying;
    protected ImsPhoneCallTracker mOwner;

    protected ImsPhoneCall() {
        this.mIsRingbackTonePlaying = false;
        this.mCallContext = CONTEXT_UNKNOWN;
    }

    public ImsPhoneCall(ImsPhoneCallTracker imsPhoneCallTracker, String str) {
        this.mIsRingbackTonePlaying = false;
        this.mOwner = imsPhoneCallTracker;
        this.mCallContext = str;
    }

    /*  JADX ERROR: StackOverflow in pass: MarkFinallyVisitor
        jadx.core.utils.exceptions.JadxOverflowException: 
        	at jadx.core.utils.ErrorsCounter.addError(ErrorsCounter.java:47)
        	at jadx.core.utils.ErrorsCounter.methodError(ErrorsCounter.java:81)
        */
    public void dispose() {
        /*
            r3 = this;
            r0 = 14
            com.android.internal.telephony.imsphone.ImsPhoneCallTracker r1 = r3.mOwner     // Catch:{ CallStateException -> 0x0039, all -> 0x001f }
            r1.hangup((com.android.internal.telephony.imsphone.ImsPhoneCall) r3)     // Catch:{ CallStateException -> 0x0039, all -> 0x001f }
            java.util.ArrayList r3 = r3.getConnections()
            java.util.Iterator r3 = r3.iterator()
        L_0x000f:
            boolean r1 = r3.hasNext()
            if (r1 == 0) goto L_0x0051
            java.lang.Object r1 = r3.next()
            com.android.internal.telephony.Connection r1 = (com.android.internal.telephony.Connection) r1
            r1.onDisconnect(r0)
            goto L_0x000f
        L_0x001f:
            r1 = move-exception
            java.util.ArrayList r3 = r3.getConnections()
            java.util.Iterator r3 = r3.iterator()
        L_0x0028:
            boolean r2 = r3.hasNext()
            if (r2 == 0) goto L_0x0038
            java.lang.Object r2 = r3.next()
            com.android.internal.telephony.Connection r2 = (com.android.internal.telephony.Connection) r2
            r2.onDisconnect(r0)
            goto L_0x0028
        L_0x0038:
            throw r1
        L_0x0039:
            java.util.ArrayList r3 = r3.getConnections()
            java.util.Iterator r3 = r3.iterator()
        L_0x0041:
            boolean r1 = r3.hasNext()
            if (r1 == 0) goto L_0x0051
            java.lang.Object r1 = r3.next()
            com.android.internal.telephony.Connection r1 = (com.android.internal.telephony.Connection) r1
            r1.onDisconnect(r0)
            goto L_0x0041
        L_0x0051:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.imsphone.ImsPhoneCall.dispose():void");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ArrayList<Connection> getConnections() {
        return super.getConnections();
    }

    public Phone getPhone() {
        return this.mOwner.getPhone();
    }

    public boolean isMultiparty() {
        ImsCall imsCall = getImsCall();
        if (imsCall == null) {
            return false;
        }
        return imsCall.isMultiparty();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void hangup() throws CallStateException {
        this.mOwner.hangup(this);
    }

    public void hangup(int i) throws CallStateException {
        this.mOwner.hangup(this, i);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        ArrayList<Connection> connections = getConnections();
        sb.append("[ImsPhoneCall ");
        sb.append(this.mCallContext);
        sb.append(" state: ");
        sb.append(this.mState.toString());
        sb.append(" ");
        if (connections.size() > 1) {
            sb.append(" ERROR_MULTIPLE ");
        }
        for (Connection append : connections) {
            sb.append(append);
            sb.append(" ");
        }
        sb.append("]");
        return sb.toString();
    }

    public List<ConferenceParticipant> getConferenceParticipants() {
        ImsCall imsCall;
        if (this.mOwner.isConferenceEventPackageEnabled() && (imsCall = getImsCall()) != null) {
            return imsCall.getConferenceParticipants();
        }
        return null;
    }

    public void attach(Connection connection) {
        if (VDBG) {
            Rlog.v(LOG_TAG, "attach : " + this.mCallContext + " conn = " + connection);
        }
        clearDisconnected();
        addConnection(connection);
        this.mOwner.logState();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void attach(Connection connection, Call.State state) {
        if (VDBG) {
            Rlog.v(LOG_TAG, "attach : " + this.mCallContext + " state = " + state.toString());
        }
        attach(connection);
        this.mState = state;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void attachFake(Connection connection, Call.State state) {
        attach(connection, state);
    }

    public boolean connectionDisconnected(ImsPhoneConnection imsPhoneConnection) {
        boolean z;
        if (this.mState != Call.State.DISCONNECTED) {
            Iterator<Connection> it = getConnections().iterator();
            while (true) {
                if (it.hasNext()) {
                    if (it.next().getState() != Call.State.DISCONNECTED) {
                        z = false;
                        break;
                    }
                } else {
                    z = true;
                    break;
                }
            }
            if (z) {
                synchronized (this) {
                    this.mState = Call.State.DISCONNECTED;
                }
                if (VDBG) {
                    Rlog.v(LOG_TAG, "connectionDisconnected : " + this.mCallContext + " state = " + this.mState);
                }
                return true;
            }
        }
        return false;
    }

    public void detach(ImsPhoneConnection imsPhoneConnection) {
        if (VDBG) {
            Rlog.v(LOG_TAG, "detach : " + this.mCallContext + " conn = " + imsPhoneConnection);
        }
        removeConnection(imsPhoneConnection);
        clearDisconnected();
        this.mOwner.logState();
    }

    /* access modifiers changed from: package-private */
    public boolean isFull() {
        return getConnectionsCount() == 5;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public void onHangupLocal() {
        Iterator<Connection> it = getConnections().iterator();
        while (it.hasNext()) {
            ((ImsPhoneConnection) it.next()).onHangupLocal();
        }
        synchronized (this) {
            if (this.mState.isAlive()) {
                this.mState = Call.State.DISCONNECTING;
            }
        }
        if (VDBG) {
            Rlog.v(LOG_TAG, "onHangupLocal : " + this.mCallContext + " state = " + this.mState);
        }
    }

    @VisibleForTesting
    public ImsPhoneConnection getFirstConnection() {
        ArrayList<Connection> connections = getConnections();
        if (connections.size() == 0) {
            return null;
        }
        return (ImsPhoneConnection) connections.get(0);
    }

    @VisibleForTesting
    public void setMute(boolean z) {
        ImsCall imsCall;
        ImsPhoneConnection firstConnection = getFirstConnection();
        if (firstConnection == null) {
            imsCall = null;
        } else {
            imsCall = firstConnection.getImsCall();
        }
        if (imsCall != null) {
            try {
                imsCall.setMute(z);
            } catch (ImsException e) {
                Rlog.e(LOG_TAG, "setMute failed : " + e.getMessage());
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void merge(ImsPhoneCall imsPhoneCall, Call.State state) {
        ImsPhoneConnection firstConnection = getFirstConnection();
        if (firstConnection != null) {
            long conferenceConnectTime = firstConnection.getConferenceConnectTime();
            if (conferenceConnectTime > 0) {
                firstConnection.setConnectTime(conferenceConnectTime);
                firstConnection.setConnectTimeReal(firstConnection.getConnectTimeReal());
            } else if (DBG) {
                Rlog.d(LOG_TAG, "merge: conference connect time is 0");
            }
        }
        if (DBG) {
            Rlog.d(LOG_TAG, "merge(" + this.mCallContext + "): " + imsPhoneCall + "state = " + state);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @VisibleForTesting
    public ImsCall getImsCall() {
        ImsPhoneConnection firstConnection = getFirstConnection();
        if (firstConnection == null) {
            return null;
        }
        return firstConnection.getImsCall();
    }

    public static boolean isLocalTone(ImsCall imsCall) {
        boolean z = false;
        if (!(imsCall == null || imsCall.getCallProfile() == null || imsCall.getCallProfile().mMediaProfile == null)) {
            ImsStreamMediaProfile imsStreamMediaProfile = imsCall.getCallProfile().mMediaProfile;
            if (imsStreamMediaProfile.mAudioDirection == 0) {
                z = true;
            }
            Rlog.i(LOG_TAG, "isLocalTone: audioDirection=" + imsStreamMediaProfile.mAudioDirection + ", playRingback=" + z);
        }
        return z;
    }

    public boolean update(ImsPhoneConnection imsPhoneConnection, ImsCall imsCall, Call.State state) {
        Call.State state2 = this.mState;
        maybeChangeRingbackState(imsCall, state);
        boolean z = true;
        if (state != this.mState && state != Call.State.DISCONNECTED) {
            this.mState = state;
        } else if (state != Call.State.DISCONNECTED) {
            z = false;
        }
        if (VDBG) {
            Rlog.v(LOG_TAG, "update : " + this.mCallContext + " state: " + state2 + " --> " + this.mState);
        }
        return z;
    }

    public void maybeChangeRingbackState(ImsCall imsCall) {
        maybeChangeRingbackState(imsCall, this.mState);
    }

    private void maybeChangeRingbackState(ImsCall imsCall, Call.State state) {
        Rlog.i(LOG_TAG, "maybeChangeRingbackState: state=" + state);
        if (state == Call.State.ALERTING) {
            if (this.mIsRingbackTonePlaying && !isLocalTone(imsCall)) {
                Rlog.i(LOG_TAG, "maybeChangeRingbackState: stop ringback");
                getPhone().stopRingbackTone();
                this.mIsRingbackTonePlaying = false;
            } else if (!this.mIsRingbackTonePlaying && isLocalTone(imsCall)) {
                Rlog.i(LOG_TAG, "maybeChangeRingbackState: start ringback");
                getPhone().startRingbackTone();
                this.mIsRingbackTonePlaying = true;
            }
        } else if (this.mIsRingbackTonePlaying) {
            Rlog.i(LOG_TAG, "maybeChangeRingbackState: stop ringback");
            getPhone().stopRingbackTone();
            this.mIsRingbackTonePlaying = false;
        }
    }

    /* access modifiers changed from: package-private */
    public ImsPhoneConnection getHandoverConnection() {
        return (ImsPhoneConnection) getEarliestConnection();
    }

    public void switchWith(ImsPhoneCall imsPhoneCall) {
        if (VDBG) {
            Rlog.v(LOG_TAG, "switchWith : switchCall = " + this + " withCall = " + imsPhoneCall);
        }
        synchronized (ImsPhoneCall.class) {
            ImsPhoneCall makeTempImsPhoneCall = makeTempImsPhoneCall();
            makeTempImsPhoneCall.takeOver(this);
            takeOver(imsPhoneCall);
            imsPhoneCall.takeOver(makeTempImsPhoneCall);
        }
        this.mOwner.logState();
    }

    public void maybeStopRingback() {
        if (this.mIsRingbackTonePlaying) {
            getPhone().stopRingbackTone();
            this.mIsRingbackTonePlaying = false;
        }
    }

    public boolean isRingbackTonePlaying() {
        return this.mIsRingbackTonePlaying;
    }

    public void takeOver(ImsPhoneCall imsPhoneCall) {
        copyConnectionFrom(imsPhoneCall);
        this.mState = imsPhoneCall.mState;
        Iterator<Connection> it = getConnections().iterator();
        while (it.hasNext()) {
            ((ImsPhoneConnection) it.next()).changeParent(this);
        }
    }

    /* access modifiers changed from: protected */
    public ImsPhoneCall makeTempImsPhoneCall() {
        return new ImsPhoneCall();
    }
}
