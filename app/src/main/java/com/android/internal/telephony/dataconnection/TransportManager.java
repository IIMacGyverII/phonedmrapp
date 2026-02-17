package com.android.internal.telephony.dataconnection;

import android.os.Handler;
import android.os.Message;
import android.telephony.AccessNetworkConstants;
import android.telephony.data.ApnSetting;
import android.util.SparseIntArray;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.data.AccessNetworksManager;
import com.android.telephony.Rlog;
import java.util.concurrent.TimeUnit;

public class TransportManager extends Handler {
    private static final int EVENT_EVALUATE_TRANSPORT_PREFERENCE = 2;
    private static final int EVENT_QUALIFIED_NETWORKS_CHANGED = 1;
    private static final long FALL_BACK_REEVALUATE_DELAY_MILLIS = TimeUnit.SECONDS.toMillis(3);
    private AccessNetworksManager mAccessNetworksManager;
    private final RegistrantList mHandoverNeededEventRegistrants;
    private final LocalLog mLocalLog = new LocalLog(64);
    private final String mLogTag;
    private final SparseIntArray mPendingHandoverApns;
    private final Phone mPhone;

    @VisibleForTesting
    public static final class HandoverParams {
        public final int apnType;
        public final HandoverCallback callback;
        public final int targetTransport;

        public interface HandoverCallback {
            void onCompleted(boolean z, boolean z2);
        }

        @VisibleForTesting
        public HandoverParams(int i, int i2, HandoverCallback handoverCallback) {
            this.apnType = i;
            this.targetTransport = i2;
            this.callback = handoverCallback;
        }
    }

    public TransportManager(Phone phone) {
        this.mPhone = phone;
        this.mPendingHandoverApns = new SparseIntArray();
        this.mHandoverNeededEventRegistrants = new RegistrantList();
        this.mLogTag = TransportManager.class.getSimpleName() + "-" + phone.getPhoneId();
        AccessNetworksManager accessNetworksManager = phone.getAccessNetworksManager();
        this.mAccessNetworksManager = accessNetworksManager;
        accessNetworksManager.registerForQualifiedNetworksChanged(this, 1);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i != 1) {
            if (i != 2) {
                loge("Unexpected event " + message.what);
                return;
            }
            evaluateTransportPreference();
        } else if (!hasMessages(2)) {
            sendEmptyMessage(2);
        }
    }

    private synchronized void setCurrentTransport(int i, int i2) {
        this.mAccessNetworksManager.setCurrentTransport(i, i2);
    }

    private boolean isHandoverPending() {
        return this.mPendingHandoverApns.size() > 0;
    }

    private void evaluateTransportPreference() {
        if (!isHandoverPending()) {
            logl("evaluateTransportPreference");
            for (int i : AccessNetworksManager.SUPPORTED_APN_TYPES) {
                int preferredTransport = this.mAccessNetworksManager.getPreferredTransport(i);
                if (preferredTransport != this.mAccessNetworksManager.getCurrentTransport(i)) {
                    logl("Handover started for APN type: " + ApnSetting.getApnTypeString(i) + ", target transport: " + AccessNetworkConstants.transportTypeToString(preferredTransport));
                    this.mPendingHandoverApns.put(i, preferredTransport);
                    this.mHandoverNeededEventRegistrants.notifyResult(new HandoverParams(i, preferredTransport, new TransportManager$$ExternalSyntheticLambda0(this, i, preferredTransport)));
                    return;
                }
            }
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$evaluateTransportPreference$0(int i, int i2, boolean z, boolean z2) {
        if (z) {
            logl("Handover succeeded for APN type " + ApnSetting.getApnTypeString(i));
        } else {
            logl("APN type " + ApnSetting.getApnTypeString(i) + " handover to " + AccessNetworkConstants.transportTypeToString(i2) + " failed, fallback=" + z2);
        }
        long j = 0;
        if (z2) {
            j = FALL_BACK_REEVALUATE_DELAY_MILLIS;
        } else {
            setCurrentTransport(i, i2);
        }
        this.mPendingHandoverApns.delete(i);
        sendEmptyMessageDelayed(2, j);
    }

    public void registerForHandoverNeededEvent(Handler handler, int i) {
        if (handler != null) {
            this.mHandoverNeededEventRegistrants.addUnique(handler, i, (Object) null);
        }
    }

    public void unregisterForHandoverNeededEvent(Handler handler) {
        this.mHandoverNeededEventRegistrants.remove(handler);
    }

    public void registerDataThrottler(DataThrottler dataThrottler) {
        AccessNetworksManager accessNetworksManager = this.mAccessNetworksManager;
        if (accessNetworksManager != null) {
            accessNetworksManager.registerDataThrottler(dataThrottler);
        }
    }

    private void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }
}
