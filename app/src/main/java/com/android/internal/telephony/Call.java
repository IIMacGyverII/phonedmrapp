package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.ims.internal.ConferenceParticipant;
import com.android.internal.telephony.DriverCall;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

public abstract class Call {
    protected final String LOG_TAG = "Call";
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ArrayList<Connection> mConnections = new ArrayList<>();
    private Object mLock = new Object();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public State mState = State.IDLE;

    public enum SrvccState {
        NONE,
        STARTED,
        COMPLETED,
        FAILED,
        CANCELED
    }

    public List<ConferenceParticipant> getConferenceParticipants() {
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract Phone getPhone();

    @UnsupportedAppUsage
    public abstract void hangup() throws CallStateException;

    public abstract void hangup(int i) throws CallStateException;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract boolean isMultiparty();

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/Call$State;")
    public enum State {
        IDLE,
        ACTIVE,
        HOLDING,
        DIALING,
        ALERTING,
        INCOMING,
        WAITING,
        DISCONNECTED,
        DISCONNECTING;

        @UnsupportedAppUsage
        public boolean isAlive() {
            return (this == IDLE || this == DISCONNECTED || this == DISCONNECTING) ? false : true;
        }

        @UnsupportedAppUsage
        public boolean isRinging() {
            return this == INCOMING || this == WAITING;
        }

        public boolean isDialing() {
            return this == DIALING || this == ALERTING;
        }
    }

    /* renamed from: com.android.internal.telephony.Call$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$DriverCall$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(14:0|1|2|3|4|5|6|7|8|9|10|11|12|14) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.DriverCall$State[] r0 = com.android.internal.telephony.DriverCall.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$DriverCall$State = r0
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.ACTIVE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.HOLDING     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.DIALING     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.ALERTING     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.INCOMING     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$DriverCall$State     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.DriverCall$State r1 = com.android.internal.telephony.DriverCall.State.WAITING     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.Call.AnonymousClass1.<clinit>():void");
        }
    }

    public static State stateFromDCState(DriverCall.State state) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$DriverCall$State[state.ordinal()]) {
            case 1:
                return State.ACTIVE;
            case 2:
                return State.HOLDING;
            case 3:
                return State.DIALING;
            case 4:
                return State.ALERTING;
            case 5:
                return State.INCOMING;
            case 6:
                return State.WAITING;
            default:
                throw new RuntimeException("illegal call state:" + state);
        }
    }

    @UnsupportedAppUsage
    public ArrayList<Connection> getConnections() {
        ArrayList<Connection> arrayList;
        synchronized (this.mLock) {
            arrayList = (ArrayList) this.mConnections.clone();
        }
        return arrayList;
    }

    public void copyConnectionFrom(Call call) {
        this.mConnections = call.getConnections();
    }

    public int getConnectionsCount() {
        int size;
        synchronized (this.mLock) {
            size = this.mConnections.size();
        }
        return size;
    }

    public String getConnectionSummary() {
        String str;
        synchronized (this.mLock) {
            str = (String) this.mConnections.stream().map(new Call$$ExternalSyntheticLambda0()).collect(Collectors.joining(", "));
        }
        return str;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String lambda$getConnectionSummary$0(Connection connection) {
        return connection.getTelecomCallId() + "/objId:" + System.identityHashCode(connection);
    }

    public boolean hasConnection(Connection connection) {
        return connection.getCall() == this;
    }

    public boolean hasConnections() {
        ArrayList<Connection> connections = getConnections();
        if (connections != null && connections.size() > 0) {
            return true;
        }
        return false;
    }

    public void removeConnection(Connection connection) {
        synchronized (this.mLock) {
            this.mConnections.remove(connection);
        }
    }

    public void addConnection(Connection connection) {
        synchronized (this.mLock) {
            this.mConnections.add(connection);
        }
    }

    public void clearConnections() {
        synchronized (this.mLock) {
            this.mConnections.clear();
        }
    }

    @UnsupportedAppUsage
    public State getState() {
        return this.mState;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isIdle() {
        return !getState().isAlive();
    }

    @UnsupportedAppUsage
    public Connection getEarliestConnection() {
        ArrayList<Connection> connections = getConnections();
        Connection connection = null;
        if (connections.size() == 0) {
            return null;
        }
        int size = connections.size();
        long j = Long.MAX_VALUE;
        for (int i = 0; i < size; i++) {
            Connection connection2 = connections.get(i);
            long createTime = connection2.getCreateTime();
            if (createTime < j) {
                connection = connection2;
                j = createTime;
            }
        }
        return connection;
    }

    public long getEarliestCreateTime() {
        ArrayList<Connection> connections = getConnections();
        if (connections.size() == 0) {
            return 0;
        }
        int size = connections.size();
        long j = Long.MAX_VALUE;
        for (int i = 0; i < size; i++) {
            long createTime = connections.get(i).getCreateTime();
            if (createTime < j) {
                j = createTime;
            }
        }
        return j;
    }

    public long getEarliestConnectTime() {
        ArrayList<Connection> connections = getConnections();
        if (connections.size() == 0) {
            return 0;
        }
        int size = connections.size();
        long j = Long.MAX_VALUE;
        for (int i = 0; i < size; i++) {
            long connectTime = connections.get(i).getConnectTime();
            if (connectTime < j) {
                j = connectTime;
            }
        }
        return j;
    }

    public boolean isDialingOrAlerting() {
        return getState().isDialing();
    }

    public boolean isRinging() {
        return getState().isRinging();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Connection getLatestConnection() {
        ArrayList<Connection> connections = getConnections();
        Connection connection = null;
        if (connections.size() == 0) {
            return null;
        }
        long j = 0;
        int size = connections.size();
        for (int i = 0; i < size; i++) {
            Connection connection2 = connections.get(i);
            long createTime = connection2.getCreateTime();
            if (createTime > j) {
                connection = connection2;
                j = createTime;
            }
        }
        return connection;
    }

    public void hangupIfAlive() {
        if (getState().isAlive()) {
            try {
                hangup();
            } catch (CallStateException e) {
                Rlog.w("Call", " hangupIfActive: caught " + e);
            }
        }
    }

    public void clearDisconnected() {
        Iterator<Connection> it = getConnections().iterator();
        while (it.hasNext()) {
            Connection next = it.next();
            if (next.getState() == State.DISCONNECTED) {
                removeConnection(next);
            }
        }
        if (getConnectionsCount() == 0) {
            setState(State.IDLE);
        }
    }

    /* access modifiers changed from: protected */
    public void setState(State state) {
        this.mState = state;
    }
}
