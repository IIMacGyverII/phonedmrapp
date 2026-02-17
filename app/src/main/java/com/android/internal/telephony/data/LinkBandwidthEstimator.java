package com.android.internal.telephony.data;

import android.content.SharedPreferences;
import android.hardware.display.DisplayManager;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerExecutor;
import android.os.Message;
import android.os.OutcomeReceiver;
import android.preference.PreferenceManager;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityGsm;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityNr;
import android.telephony.CellIdentityTdscdma;
import android.telephony.CellIdentityWcdma;
import android.telephony.ModemActivityInfo;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.SignalStrength;
import android.telephony.TelephonyCallback;
import android.telephony.TelephonyManager;
import android.util.ArrayMap;
import android.util.ArraySet;
import android.util.Pair;
import android.view.Display;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.GbaManager;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.TelephonyFacade;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.Executor;

public class LinkBandwidthEstimator extends Handler {
    private static final String[] AVG_BW_PER_RAT = {"GPRS:24,24", "EDGE:70,18", "UMTS:115,115", "CDMA:14,14", "CDMA - 1xRTT:30,30", "CDMA - EvDo rev. 0:750,48", "CDMA - EvDo rev. A:950,550", "HSDPA:4300,620", "HSUPA:4300,1800", "HSPA:4300,1800", "CDMA - EvDo rev. B:1500,550", "CDMA - eHRPD:750,48", "HSPA+:13000,3400", "TD_SCDMA:115,115", "LTE:30000,15000", "NR_NSA:47000,18000", "NR_NSA_MMWAVE:145000,60000", "NR:145000,60000", "NR_MMWAVE:145000,60000"};
    private static final Map<String, Pair<Integer, Integer>> AVG_BW_PER_RAT_MAP = new ArrayMap();
    public static final int BW_STATS_COUNT_THRESHOLD = 5;
    private static final int BW_UPDATE_THRESHOLD_PERCENT = 15;
    private static final int BYTE_DELTA_ACC_THRESHOLD_MAX_KB = 8000;
    /* access modifiers changed from: private */
    public static final int[][] BYTE_DELTA_THRESHOLD_KB = {new int[]{200, 300, 400, 600, 1000}, new int[]{400, 600, 800, 1000, 1000}};
    private static final int BYTE_DELTA_THRESHOLD_MIN_KB = 10;
    private static final boolean DBG = false;
    private static final int DEFAULT_LINK_BAND_WIDTH_KBPS = 14;
    private static final int FILTER_SCALE = 128;
    private static final int FILTER_UPDATE_MAX_INTERVAL_MS = 5100;
    private static final int HIGH_BANDWIDTH_THRESHOLD_KBPS = 5000;
    private static final int LARGE_TIME_DECAY_RATIO = 4;
    public static final int LINK_RX = 1;
    public static final int LINK_TX = 0;
    private static final int LOW_BW_TO_AVG_BW_RATIO_DEN = 8;
    private static final int LOW_BW_TO_AVG_BW_RATIO_NUM = 3;
    private static final int MAX_BW_TO_STATIC_BW_RATIO = 15;
    private static final int MAX_ERROR_PERCENT = 10000;
    private static final int MODEM_POLL_MIN_INTERVAL_MS = 5000;
    private static final int MODEM_POLL_TIME_DELTA_MAX_MS = 10000;
    @VisibleForTesting
    static final int MSG_ACTIVE_PHONE_CHANGED = 8;
    @VisibleForTesting
    static final int MSG_DATA_REG_STATE_OR_RAT_CHANGED = 9;
    @VisibleForTesting
    static final int MSG_DEFAULT_NETWORK_CHANGED = 4;
    @VisibleForTesting
    static final int MSG_MODEM_ACTIVITY_RETURNED = 3;
    @VisibleForTesting
    static final int MSG_NR_FREQUENCY_CHANGED = 6;
    @VisibleForTesting
    static final int MSG_NR_STATE_CHANGED = 7;
    @VisibleForTesting
    static final int MSG_SCREEN_STATE_CHANGED = 1;
    @VisibleForTesting
    static final int MSG_SIGNAL_STRENGTH_CHANGED = 5;
    @VisibleForTesting
    static final int MSG_TRAFFIC_STATS_POLL = 2;
    public static final int NUM_LINK_DIRECTION = 2;
    public static final int NUM_SIGNAL_LEVEL = 5;
    private static final int RSSI_DELTA_THRESHOLD_DB = 6;
    /* access modifiers changed from: private */
    public static final String TAG = LinkBandwidthEstimator.class.getSimpleName();
    private static final int TIME_CONSTANT_LARGE_SEC = 6;
    private static final int TIME_CONSTANT_SMALL_SEC = 6;
    private static final int TRAFFIC_MODEM_POLL_BYTE_RATIO = 8;
    private static final int TRAFFIC_POLL_BYTE_THRESHOLD_MAX = 20000;
    private static final int TRAFFIC_STATS_POLL_INTERVAL_MS = 1000;
    private static final int TX_OVER_RX_TIME_RATIO_THRESHOLD_DEN = 2;
    private static final int TX_OVER_RX_TIME_RATIO_THRESHOLD_NUM = 3;
    private static final int TX_RX_TIME_MIN_MS = 200;
    private static final String UNKNOWN_PLMN = "";
    @VisibleForTesting
    static final int UNKNOWN_TAC = -1;
    private RegistrantList mBandwidthChangedRegistrants;
    /* access modifiers changed from: private */
    public int mBandwidthUpdateDataRat;
    /* access modifiers changed from: private */
    public String mBandwidthUpdatePlmn;
    /* access modifiers changed from: private */
    public int mBandwidthUpdateSignalDbm;
    private int mBandwidthUpdateSignalLevel;
    private final ConnectivityManager mConnectivityManager;
    private int mDataActivity;
    /* access modifiers changed from: private */
    public int mDataRat;
    private final ConnectivityManager.NetworkCallback mDefaultNetworkCallback;
    private final DisplayManager.DisplayListener mDisplayListener;
    private long mFilterUpdateTimeMs;
    private boolean mIsOnActiveData = false;
    private boolean mIsOnDefaultRoute = false;
    private long mLastDrsOrRatChangeTimeMs;
    private long mLastMobileRxBytes;
    private long mLastMobileTxBytes;
    private ModemActivityInfo mLastModemActivityInfo = null;
    private long mLastModemPollTimeMs;
    private long mLastPlmnOrRatChangeTimeMs;
    private boolean mLastTrafficValid = true;
    private final Set<LinkBandwidthEstimatorCallback> mLinkBandwidthEstimatorCallbacks;
    private final LocalLog mLocalLog = new LocalLog(512);
    private NetworkCapabilities mNetworkCapabilities;
    private final Map<NetworkKey, NetworkBandwidth> mNetworkMap;
    private final OutcomeReceiver<ModemActivityInfo, TelephonyManager.ModemActivityInfoException> mOutcomeReceiver;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private NetworkBandwidth mPlaceholderNetwork;
    /* access modifiers changed from: private */
    public String mPlmn;
    private long mRxBytesDeltaAcc;
    private BandwidthState mRxState;
    private boolean mScreenOn = false;
    /* access modifiers changed from: private */
    public int mSignalLevel;
    /* access modifiers changed from: private */
    public int mSignalStrengthDbm;
    /* access modifiers changed from: private */
    public int mTac;
    private final TelephonyCallback mTelephonyCallback;
    /* access modifiers changed from: private */
    public final TelephonyFacade mTelephonyFacade;
    private final TelephonyManager mTelephonyManager;
    private long mTxBytesDeltaAcc;
    private BandwidthState mTxState;

    /* access modifiers changed from: package-private */
    public void logv(String str) {
    }

    public static class LinkBandwidthEstimatorCallback extends DataCallback {
        public void onBandwidthChanged(int i, int i2) {
        }

        public void onDataActivityChanged(int i) {
        }

        public LinkBandwidthEstimatorCallback(Executor executor) {
            super(executor);
        }
    }

    private static void initAvgBwPerRatTable() {
        int i;
        int i2;
        for (String split : AVG_BW_PER_RAT) {
            String[] split2 = split.split(":");
            if (split2.length == 2) {
                String[] split3 = split2[1].split(",");
                int i3 = 14;
                if (split3.length == 2) {
                    try {
                        i2 = Integer.parseInt(split3[0]);
                        try {
                            i3 = Integer.parseInt(split3[1]);
                        } catch (NumberFormatException unused) {
                        }
                    } catch (NumberFormatException unused2) {
                        i2 = 14;
                    }
                    i = i3;
                    i3 = i2;
                } else {
                    i = 14;
                }
                AVG_BW_PER_RAT_MAP.put(split2[0], new Pair(Integer.valueOf(i3), Integer.valueOf(i)));
            }
        }
    }

    public LinkBandwidthEstimator(Phone phone, TelephonyFacade telephonyFacade) {
        TelephonyCallbackImpl telephonyCallbackImpl = new TelephonyCallbackImpl();
        this.mTelephonyCallback = telephonyCallbackImpl;
        this.mDataRat = 0;
        this.mPlmn = "";
        this.mBandwidthUpdateSignalDbm = -1;
        this.mBandwidthUpdateSignalLevel = -1;
        this.mBandwidthUpdateDataRat = 0;
        this.mBandwidthUpdatePlmn = "";
        this.mTxState = new BandwidthState(0);
        this.mRxState = new BandwidthState(1);
        this.mBandwidthChangedRegistrants = new RegistrantList();
        this.mDataActivity = 0;
        this.mLinkBandwidthEstimatorCallbacks = new ArraySet();
        AnonymousClass1 r0 = new DisplayManager.DisplayListener() {
            public void onDisplayAdded(int i) {
            }

            public void onDisplayRemoved(int i) {
            }

            public void onDisplayChanged(int i) {
                LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
                linkBandwidthEstimator.obtainMessage(1, Boolean.valueOf(linkBandwidthEstimator.isScreenOn())).sendToTarget();
            }
        };
        this.mDisplayListener = r0;
        this.mOutcomeReceiver = new OutcomeReceiver<ModemActivityInfo, TelephonyManager.ModemActivityInfoException>() {
            public void onResult(ModemActivityInfo modemActivityInfo) {
                LinkBandwidthEstimator.this.obtainMessage(3, modemActivityInfo).sendToTarget();
            }

            public void onError(TelephonyManager.ModemActivityInfoException modemActivityInfoException) {
                String r0 = LinkBandwidthEstimator.TAG;
                Rlog.e(r0, "error reading modem stats:" + modemActivityInfoException);
                LinkBandwidthEstimator.this.obtainMessage(3, (Object) null).sendToTarget();
            }
        };
        AnonymousClass3 r5 = new ConnectivityManager.NetworkCallback() {
            public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
                LinkBandwidthEstimator.this.obtainMessage(4, networkCapabilities).sendToTarget();
            }

            public void onLost(Network network) {
                LinkBandwidthEstimator.this.obtainMessage(4, (Object) null).sendToTarget();
            }
        };
        this.mDefaultNetworkCallback = r5;
        this.mNetworkMap = new ArrayMap();
        this.mPhone = phone;
        this.mTelephonyFacade = telephonyFacade;
        TelephonyManager createForSubscriptionId = ((TelephonyManager) phone.getContext().getSystemService(TelephonyManager.class)).createForSubscriptionId(phone.getSubId());
        this.mTelephonyManager = createForSubscriptionId;
        ConnectivityManager connectivityManager = (ConnectivityManager) phone.getContext().getSystemService(ConnectivityManager.class);
        this.mConnectivityManager = connectivityManager;
        ((DisplayManager) phone.getContext().getSystemService("display")).registerDisplayListener(r0, (Handler) null);
        handleScreenStateChanged(isScreenOn());
        connectivityManager.registerDefaultNetworkCallback(r5, this);
        createForSubscriptionId.registerTelephonyCallback(new HandlerExecutor(this), telephonyCallbackImpl);
        this.mPlaceholderNetwork = new NetworkBandwidth("");
        initAvgBwPerRatTable();
        registerNrStateFrequencyChange();
        phone.getServiceStateTracker().registerForDataRegStateOrRatChanged(1, this, 9, (Object) null);
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                handleScreenStateChanged(((Boolean) message.obj).booleanValue());
                return;
            case 2:
                handleTrafficStatsPoll();
                return;
            case 3:
                handleModemActivityReturned((ModemActivityInfo) message.obj);
                return;
            case 4:
                handleDefaultNetworkChanged((NetworkCapabilities) message.obj);
                return;
            case 5:
                handleSignalStrengthChanged((SignalStrength) message.obj);
                return;
            case 6:
            case 7:
                updateStaticBwValueResetFilter();
                return;
            case 8:
                handleActivePhoneChanged(((Integer) message.obj).intValue());
                return;
            case 9:
                handleDrsOrRatChanged((AsyncResult) message.obj);
                return;
            default:
                String str = TAG;
                Rlog.e(str, "invalid message " + message.what);
                return;
        }
    }

    @Deprecated
    public void registerForBandwidthChanged(Handler handler, int i, Object obj) {
        this.mBandwidthChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    @Deprecated
    public void unregisterForBandwidthChanged(Handler handler) {
        this.mBandwidthChangedRegistrants.remove(handler);
    }

    public void registerCallback(LinkBandwidthEstimatorCallback linkBandwidthEstimatorCallback) {
        this.mLinkBandwidthEstimatorCallbacks.add(linkBandwidthEstimatorCallback);
    }

    public void unregisterCallback(LinkBandwidthEstimatorCallback linkBandwidthEstimatorCallback) {
        this.mLinkBandwidthEstimatorCallbacks.remove(linkBandwidthEstimatorCallback);
    }

    /* access modifiers changed from: private */
    public boolean isScreenOn() {
        Display[] displays = ((DisplayManager) this.mPhone.getContext().getSystemService("display")).getDisplays();
        if (displays != null) {
            for (Display state : displays) {
                if (state.getState() == 2) {
                    return true;
                }
            }
        }
        return false;
    }

    private void handleScreenStateChanged(boolean z) {
        if (this.mScreenOn != z) {
            this.mScreenOn = z;
            handleTrafficStatsPollConditionChanged();
        }
    }

    private void handleDefaultNetworkChanged(NetworkCapabilities networkCapabilities) {
        this.mNetworkCapabilities = networkCapabilities;
        boolean z = false;
        if (networkCapabilities != null) {
            z = networkCapabilities.hasTransport(0);
        }
        if (this.mIsOnDefaultRoute != z) {
            this.mIsOnDefaultRoute = z;
            handleTrafficStatsPollConditionChanged();
        }
    }

    private void handleActivePhoneChanged(int i) {
        boolean z = i == this.mPhone.getSubId();
        if (this.mIsOnActiveData != z) {
            this.mIsOnActiveData = z;
            logd("mIsOnActiveData " + this.mIsOnActiveData + " activeDataSubId " + i);
            handleTrafficStatsPollConditionChanged();
        }
    }

    private void handleDrsOrRatChanged(AsyncResult asyncResult) {
        Pair pair = (Pair) asyncResult.result;
        logd("DrsOrRatChanged dataRegState " + pair.first + " rilRat " + pair.second);
        this.mLastDrsOrRatChangeTimeMs = this.mTelephonyFacade.getElapsedSinceBootMillis();
    }

    private void handleTrafficStatsPollConditionChanged() {
        removeMessages(2);
        if (!this.mScreenOn || !this.mIsOnDefaultRoute || !this.mIsOnActiveData) {
            this.mDataActivity = 0;
            this.mLinkBandwidthEstimatorCallbacks.forEach(new LinkBandwidthEstimator$$ExternalSyntheticLambda3());
            return;
        }
        updateDataRatCellIdentityBandwidth();
        handleTrafficStatsPoll();
    }

    private void handleTrafficStatsPoll() {
        invalidateTxRxSamples();
        long mobileTxBytes = this.mTelephonyFacade.getMobileTxBytes();
        long mobileRxBytes = this.mTelephonyFacade.getMobileRxBytes();
        long j = mobileTxBytes - this.mLastMobileTxBytes;
        long j2 = mobileRxBytes - this.mLastMobileRxBytes;
        int i = (j > 0 ? 1 : (j == 0 ? 0 : -1));
        int i2 = (i <= 0 || j2 <= 0) ? j2 > 0 ? 1 : i > 0 ? 2 : 0 : 3;
        if (this.mDataActivity != i2) {
            this.mDataActivity = i2;
            this.mLinkBandwidthEstimatorCallbacks.forEach(new LinkBandwidthEstimator$$ExternalSyntheticLambda0(i2));
        }
        sendEmptyMessageDelayed(2, 1000);
        this.mLastMobileTxBytes = mobileTxBytes;
        this.mLastMobileRxBytes = mobileRxBytes;
        boolean z = i >= 0 && j2 >= 0;
        if (!this.mLastTrafficValid || !z) {
            this.mLastTrafficValid = z;
            Rlog.e(TAG, " run into invalid traffic count");
            return;
        }
        this.mTxBytesDeltaAcc += j;
        this.mRxBytesDeltaAcc += j2;
        boolean z2 = j >= ((long) Math.min(this.mTxState.mByteDeltaAccThr / 8, TRAFFIC_POLL_BYTE_THRESHOLD_MAX)) || j2 >= ((long) Math.min(this.mRxState.mByteDeltaAccThr / 8, TRAFFIC_POLL_BYTE_THRESHOLD_MAX)) || this.mTxBytesDeltaAcc >= ((long) this.mTxState.mByteDeltaAccThr) || this.mRxBytesDeltaAcc >= ((long) this.mRxState.mByteDeltaAccThr);
        long elapsedSinceBootMillis = this.mTelephonyFacade.getElapsedSinceBootMillis();
        if (elapsedSinceBootMillis - this.mLastModemPollTimeMs < 5000 ? false : z2) {
            logd("txByteDelta " + j + " rxByteDelta " + j2 + " txByteDeltaAcc " + this.mTxBytesDeltaAcc + " rxByteDeltaAcc " + this.mRxBytesDeltaAcc + " trigger modem activity request");
            updateDataRatCellIdentityBandwidth();
            makeRequestModemActivity();
        } else if (elapsedSinceBootMillis - this.mFilterUpdateTimeMs >= 5100 && !updateDataRatCellIdentityBandwidth()) {
            updateTxRxBandwidthFilterSendToDataConnection();
        }
    }

    private void makeRequestModemActivity() {
        this.mLastModemPollTimeMs = this.mTelephonyFacade.getElapsedSinceBootMillis();
        this.mTelephonyManager.requestModemActivityInfo(new DataServiceManager$$ExternalSyntheticLambda0(), this.mOutcomeReceiver);
    }

    private void handleModemActivityReturned(ModemActivityInfo modemActivityInfo) {
        updateBandwidthTxRxSamples(modemActivityInfo);
        updateTxRxBandwidthFilterSendToDataConnection();
        this.mLastModemActivityInfo = modemActivityInfo;
        resetByteDeltaAcc();
    }

    private void resetByteDeltaAcc() {
        this.mTxBytesDeltaAcc = 0;
        this.mRxBytesDeltaAcc = 0;
    }

    private void invalidateTxRxSamples() {
        this.mTxState.mBwSampleValid = false;
        this.mRxState.mBwSampleValid = false;
    }

    private void updateBandwidthTxRxSamples(ModemActivityInfo modemActivityInfo) {
        if (this.mLastModemActivityInfo != null && modemActivityInfo != null && this.mNetworkCapabilities != null && !hasRecentDataRegStatePlmnOrRatChange()) {
            long timestampMillis = modemActivityInfo.getTimestampMillis() - this.mLastModemActivityInfo.getTimestampMillis();
            if (timestampMillis <= 10000 && timestampMillis > 0) {
                ModemActivityInfo delta = this.mLastModemActivityInfo.getDelta(modemActivityInfo);
                long modemTxTimeMs = getModemTxTimeMs(delta);
                long receiveTimeMillis = delta.getReceiveTimeMillis();
                long j = ((2 * modemTxTimeMs) > (3 * receiveTimeMillis) ? 1 : ((2 * modemTxTimeMs) == (3 * receiveTimeMillis) ? 0 : -1)) > 0 ? modemTxTimeMs + receiveTimeMillis : receiveTimeMillis;
                this.mTxState.updateBandwidthSample(this.mTxBytesDeltaAcc, modemTxTimeMs);
                this.mRxState.updateBandwidthSample(this.mRxBytesDeltaAcc, j);
                int linkUpstreamBandwidthKbps = this.mNetworkCapabilities.getLinkUpstreamBandwidthKbps();
                int linkDownstreamBandwidthKbps = this.mNetworkCapabilities.getLinkDownstreamBandwidthKbps();
                logd("UpdateBwSample" + " dBm " + this.mSignalStrengthDbm + " level " + this.mSignalLevel + " rat " + getDataRatName(this.mDataRat) + " plmn " + this.mPlmn + " tac " + this.mTac + " reportedTxKbps " + linkUpstreamBandwidthKbps + " reportedRxKbps " + linkDownstreamBandwidthKbps + " txMs " + modemTxTimeMs + " rxMs " + receiveTimeMillis + " txKB " + (this.mTxBytesDeltaAcc / 1024) + " rxKB " + (this.mRxBytesDeltaAcc / 1024) + " txKBThr " + (this.mTxState.mByteDeltaAccThr / 1024) + " rxKBThr " + (this.mRxState.mByteDeltaAccThr / 1024));
            }
        }
    }

    private boolean hasRecentDataRegStatePlmnOrRatChange() {
        ModemActivityInfo modemActivityInfo = this.mLastModemActivityInfo;
        if (modemActivityInfo == null) {
            return false;
        }
        if (this.mLastDrsOrRatChangeTimeMs > modemActivityInfo.getTimestampMillis() || this.mLastPlmnOrRatChangeTimeMs > this.mLastModemActivityInfo.getTimestampMillis()) {
            return true;
        }
        return false;
    }

    private long getModemTxTimeMs(ModemActivityInfo modemActivityInfo) {
        long j = 0;
        for (int i = 0; i < ModemActivityInfo.getNumTxPowerLevels(); i++) {
            j += modemActivityInfo.getTransmitDurationMillisAtPowerLevel(i);
        }
        return j;
    }

    private void updateTxRxBandwidthFilterSendToDataConnection() {
        this.mFilterUpdateTimeMs = this.mTelephonyFacade.getElapsedSinceBootMillis();
        this.mTxState.updateBandwidthFilter();
        this.mRxState.updateBandwidthFilter();
        boolean z = this.mTxState.hasLargeBwChange() || this.mRxState.hasLargeBwChange() || this.mBandwidthUpdateDataRat != this.mDataRat || this.mBandwidthUpdateSignalLevel != this.mSignalLevel || !this.mBandwidthUpdatePlmn.equals(this.mPlmn);
        if (isValidNetwork() && z) {
            BandwidthState bandwidthState = this.mTxState;
            int i = -1;
            bandwidthState.mLastReportedBwKbps = bandwidthState.mAvgUsedKbps < 0 ? -1 : bandwidthState.mFilterKbps;
            BandwidthState bandwidthState2 = this.mRxState;
            if (bandwidthState2.mAvgUsedKbps >= 0) {
                i = bandwidthState2.mFilterKbps;
            }
            bandwidthState2.mLastReportedBwKbps = i;
            sendLinkBandwidthToDataConnection(bandwidthState.mLastReportedBwKbps, i);
        }
        this.mBandwidthUpdateSignalDbm = this.mSignalStrengthDbm;
        this.mBandwidthUpdateSignalLevel = this.mSignalLevel;
        this.mBandwidthUpdateDataRat = this.mDataRat;
        this.mBandwidthUpdatePlmn = this.mPlmn;
        this.mTxState.calculateError();
        this.mRxState.calculateError();
    }

    private boolean isValidNetwork() {
        return !this.mPlmn.equals("") && this.mDataRat != 0;
    }

    private class BandwidthState {
        int mAvgUsedKbps;
        int mBwSampleKbps;
        boolean mBwSampleValid;
        long mBwSampleValidTimeMs;
        int mByteDeltaAccThr = LinkBandwidthEstimator.BYTE_DELTA_THRESHOLD_KB[0][0];
        int mFilterKbps;
        int mLastReportedBwKbps;
        private final int mLink;
        int mStaticBwKbps;

        BandwidthState(int i) {
            this.mLink = i;
        }

        /* access modifiers changed from: private */
        public void updateBandwidthSample(long j, long j2) {
            updateByteCountThr();
            if (j >= ((long) this.mByteDeltaAccThr) && j2 >= 200) {
                long j3 = (((j * 8) / j2) * 1000) / 1024;
                if (j3 <= ((long) this.mStaticBwKbps) * 15 && j3 >= 0) {
                    int i = (int) j3;
                    this.mBwSampleValid = true;
                    this.mBwSampleKbps = i;
                    LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
                    String dataRatName = linkBandwidthEstimator.getDataRatName(linkBandwidthEstimator.mDataRat);
                    LinkBandwidthEstimator linkBandwidthEstimator2 = LinkBandwidthEstimator.this;
                    long j4 = (long) i;
                    linkBandwidthEstimator2.lookupNetwork(linkBandwidthEstimator2.mPlmn, dataRatName).update(j4, this.mLink, LinkBandwidthEstimator.this.mSignalLevel);
                    LinkBandwidthEstimator linkBandwidthEstimator3 = LinkBandwidthEstimator.this;
                    linkBandwidthEstimator3.lookupNetwork(linkBandwidthEstimator3.mPlmn, LinkBandwidthEstimator.this.mTac, dataRatName).update(j4, this.mLink, LinkBandwidthEstimator.this.mSignalLevel);
                }
            }
        }

        /* access modifiers changed from: private */
        public void updateBandwidthFilter() {
            int i;
            int avgLinkBandwidthKbps = getAvgLinkBandwidthKbps();
            int i2 = this.mBwSampleValid ? this.mBwSampleKbps : avgLinkBandwidthKbps;
            long elapsedSinceBootMillis = LinkBandwidthEstimator.this.mTelephonyFacade.getElapsedSinceBootMillis();
            int i3 = ((int) (elapsedSinceBootMillis - this.mBwSampleValidTimeMs)) / 1000;
            if (Math.abs(LinkBandwidthEstimator.this.mBandwidthUpdateSignalDbm - LinkBandwidthEstimator.this.mSignalStrengthDbm) <= 6 && LinkBandwidthEstimator.this.mBandwidthUpdatePlmn.equals(LinkBandwidthEstimator.this.mPlmn) && LinkBandwidthEstimator.this.mBandwidthUpdateDataRat == LinkBandwidthEstimator.this.mDataRat) {
                boolean z = this.mBwSampleValid;
            }
            if (this.mBwSampleValid) {
                this.mBwSampleValidTimeMs = elapsedSinceBootMillis;
            }
            if (i2 != this.mFilterKbps) {
                if (i3 > 24) {
                    i = 0;
                } else {
                    i = (int) (Math.exp((((double) i3) * -1.0d) / ((double) 6)) * 128.0d);
                }
                if (i == 0) {
                    this.mFilterKbps = i2;
                    return;
                }
                this.mFilterKbps = (int) Math.min((((((long) this.mFilterKbps) * ((long) i)) + ((long) (i2 * 128))) - ((long) (i2 * i))) / 128, 2147483647L);
                StringBuilder sb = new StringBuilder();
                LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
                sb.append(this.mLink);
                sb.append(" lastSampleWeight=");
                sb.append(i);
                sb.append("/");
                sb.append(128);
                sb.append(" filterInKbps=");
                sb.append(i2);
                sb.append(" avgKbps=");
                sb.append(avgLinkBandwidthKbps);
                sb.append(" filterOutKbps=");
                sb.append(this.mFilterKbps);
                linkBandwidthEstimator.logv(sb.toString());
            }
        }

        private int getAvgUsedLinkBandwidthKbps() {
            LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
            String dataRatName = linkBandwidthEstimator.getDataRatName(linkBandwidthEstimator.mDataRat);
            LinkBandwidthEstimator linkBandwidthEstimator2 = LinkBandwidthEstimator.this;
            NetworkBandwidth lookupNetwork = linkBandwidthEstimator2.lookupNetwork(linkBandwidthEstimator2.mPlmn, LinkBandwidthEstimator.this.mTac, dataRatName);
            int count = lookupNetwork.getCount(this.mLink, LinkBandwidthEstimator.this.mSignalLevel);
            if (count >= 5) {
                return (int) (lookupNetwork.getValue(this.mLink, LinkBandwidthEstimator.this.mSignalLevel) / ((long) count));
            }
            LinkBandwidthEstimator linkBandwidthEstimator3 = LinkBandwidthEstimator.this;
            NetworkBandwidth r0 = linkBandwidthEstimator3.lookupNetwork(linkBandwidthEstimator3.mPlmn, dataRatName);
            int count2 = r0.getCount(this.mLink, LinkBandwidthEstimator.this.mSignalLevel);
            if (count2 >= 5) {
                return (int) (r0.getValue(this.mLink, LinkBandwidthEstimator.this.mSignalLevel) / ((long) count2));
            }
            return -1;
        }

        private int getAvgUsedBandwidthAdjacentThreeLevelKbps() {
            LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
            String dataRatName = linkBandwidthEstimator.getDataRatName(linkBandwidthEstimator.mDataRat);
            LinkBandwidthEstimator linkBandwidthEstimator2 = LinkBandwidthEstimator.this;
            NetworkBandwidth r0 = linkBandwidthEstimator2.lookupNetwork(linkBandwidthEstimator2.mPlmn, dataRatName);
            int avgUsedBandwidthAtLevel = getAvgUsedBandwidthAtLevel(r0, LinkBandwidthEstimator.this.mSignalLevel - 1);
            int avgUsedBandwidthAtLevel2 = getAvgUsedBandwidthAtLevel(r0, LinkBandwidthEstimator.this.mSignalLevel + 1);
            if (avgUsedBandwidthAtLevel > 0 && avgUsedBandwidthAtLevel2 > 0) {
                return (avgUsedBandwidthAtLevel + avgUsedBandwidthAtLevel2) / 2;
            }
            int i = 0;
            long j = 0;
            for (int i2 = -1; i2 <= 1; i2++) {
                int r8 = LinkBandwidthEstimator.this.mSignalLevel + i2;
                if (r8 >= 0 && r8 < 5) {
                    i += r0.getCount(this.mLink, r8);
                    j += r0.getValue(this.mLink, r8);
                }
            }
            if (i >= 5) {
                return (int) (j / ((long) i));
            }
            return -1;
        }

        private int getAvgUsedBandwidthAtLevel(NetworkBandwidth networkBandwidth, int i) {
            int count;
            if (i < 0 || i >= 5 || (count = networkBandwidth.getCount(this.mLink, i)) < 5) {
                return -1;
            }
            return (int) (networkBandwidth.getValue(this.mLink, i) / ((long) count));
        }

        private int getCurrentCount() {
            LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
            String dataRatName = linkBandwidthEstimator.getDataRatName(linkBandwidthEstimator.mDataRat);
            LinkBandwidthEstimator linkBandwidthEstimator2 = LinkBandwidthEstimator.this;
            return linkBandwidthEstimator2.lookupNetwork(linkBandwidthEstimator2.mPlmn, dataRatName).getCount(this.mLink, LinkBandwidthEstimator.this.mSignalLevel);
        }

        private int getAvgLinkBandwidthKbps() {
            int avgUsedLinkBandwidthKbps = getAvgUsedLinkBandwidthKbps();
            this.mAvgUsedKbps = avgUsedLinkBandwidthKbps;
            if (avgUsedLinkBandwidthKbps > 0) {
                return avgUsedLinkBandwidthKbps;
            }
            int avgUsedBandwidthAdjacentThreeLevelKbps = getAvgUsedBandwidthAdjacentThreeLevelKbps();
            this.mAvgUsedKbps = avgUsedBandwidthAdjacentThreeLevelKbps;
            if (avgUsedBandwidthAdjacentThreeLevelKbps > 0) {
                return avgUsedBandwidthAdjacentThreeLevelKbps;
            }
            return this.mStaticBwKbps;
        }

        /* access modifiers changed from: private */
        public void resetBandwidthFilter() {
            this.mBwSampleValid = false;
            this.mFilterKbps = getAvgLinkBandwidthKbps();
        }

        /* access modifiers changed from: private */
        public void updateByteCountThr() {
            int i = this.mStaticBwKbps;
            if (i > 5000) {
                int calculateByteCountThreshold = calculateByteCountThreshold(getAvgUsedLinkBandwidthKbps(), GbaManager.REQUEST_TIMEOUT_MS);
                int i2 = LinkBandwidthEstimator.BYTE_DELTA_THRESHOLD_KB[this.mLink][LinkBandwidthEstimator.this.mSignalLevel] * 1024;
                this.mByteDeltaAccThr = i2;
                if (calculateByteCountThreshold > 0) {
                    int max = Math.max(calculateByteCountThreshold, i2);
                    this.mByteDeltaAccThr = max;
                    this.mByteDeltaAccThr = Math.min(max, 8192000);
                    return;
                }
                return;
            }
            int calculateByteCountThreshold2 = calculateByteCountThreshold(i, GbaManager.REQUEST_TIMEOUT_MS);
            this.mByteDeltaAccThr = calculateByteCountThreshold2;
            int max2 = Math.max(calculateByteCountThreshold2, 10240);
            this.mByteDeltaAccThr = max2;
            this.mByteDeltaAccThr = Math.min(max2, LinkBandwidthEstimator.BYTE_DELTA_THRESHOLD_KB[this.mLink][0] * 1024);
        }

        private int calculateByteCountThreshold(int i, int i2) {
            return (int) Math.min((((((long) i) / 8) * ((long) i2)) * 3) / 8, 2147483647L);
        }

        public boolean hasLargeBwChange() {
            return this.mAvgUsedKbps > 0 && Math.abs(this.mLastReportedBwKbps - this.mFilterKbps) * 100 > this.mLastReportedBwKbps * 15;
        }

        public void calculateError() {
            if (this.mBwSampleValid && getCurrentCount() > 6 && this.mAvgUsedKbps > 0) {
                int calculateErrorPercent = calculateErrorPercent(this.mLastReportedBwKbps, this.mBwSampleKbps);
                int calculateErrorPercent2 = calculateErrorPercent(this.mAvgUsedKbps, this.mBwSampleKbps);
                int calculateErrorPercent3 = calculateErrorPercent(this.mFilterKbps, this.mBwSampleKbps);
                int calculateErrorPercent4 = calculateErrorPercent(this.mStaticBwKbps, this.mBwSampleKbps);
                TelephonyMetrics instance = TelephonyMetrics.getInstance();
                int i = this.mLink;
                int r4 = LinkBandwidthEstimator.this.mDataRat;
                LinkBandwidthEstimator linkBandwidthEstimator = LinkBandwidthEstimator.this;
                instance.writeBandwidthStats(i, r4, linkBandwidthEstimator.getNrMode(linkBandwidthEstimator.mDataRat), LinkBandwidthEstimator.this.mSignalLevel, calculateErrorPercent, calculateErrorPercent4, this.mBwSampleKbps);
                StringBuilder sb = new StringBuilder();
                LinkBandwidthEstimator linkBandwidthEstimator2 = LinkBandwidthEstimator.this;
                sb.append(this.mLink);
                sb.append(" sampKbps ");
                sb.append(this.mBwSampleKbps);
                sb.append(" filtKbps ");
                sb.append(this.mFilterKbps);
                sb.append(" reportKbps ");
                sb.append(this.mLastReportedBwKbps);
                sb.append(" avgUsedKbps ");
                sb.append(this.mAvgUsedKbps);
                sb.append(" csKbps ");
                sb.append(this.mStaticBwKbps);
                sb.append(" intErrPercent ");
                sb.append(calculateErrorPercent3);
                sb.append(" avgErrPercent ");
                sb.append(calculateErrorPercent2);
                sb.append(" extErrPercent ");
                sb.append(calculateErrorPercent);
                sb.append(" csErrPercent ");
                sb.append(calculateErrorPercent4);
                linkBandwidthEstimator2.logd(sb.toString());
            }
        }

        private int calculateErrorPercent(int i, int i2) {
            return (int) Math.max(-10000, Math.min((((long) (i - i2)) * 100) / ((long) i2), 10000));
        }
    }

    private void updateByteCountThr() {
        this.mTxState.updateByteCountThr();
        this.mRxState.updateByteCountThr();
    }

    private void resetBandwidthFilter() {
        this.mTxState.resetBandwidthFilter();
        this.mRxState.resetBandwidthFilter();
    }

    private void sendLinkBandwidthToDataConnection(int i, int i2) {
        logv("send to DC tx " + i + " rx " + i2);
        this.mBandwidthChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, new Pair(Integer.valueOf(i), Integer.valueOf(i2)), (Throwable) null));
        this.mLinkBandwidthEstimatorCallbacks.forEach(new LinkBandwidthEstimator$$ExternalSyntheticLambda2(i, i2));
    }

    private void handleSignalStrengthChanged(SignalStrength signalStrength) {
        if (signalStrength != null) {
            this.mSignalStrengthDbm = signalStrength.getDbm();
            this.mSignalLevel = signalStrength.getLevel();
            updateByteCountThr();
            if (!updateDataRatCellIdentityBandwidth() && Math.abs(this.mBandwidthUpdateSignalDbm - this.mSignalStrengthDbm) > 6) {
                updateTxRxBandwidthFilterSendToDataConnection();
            }
        }
    }

    private void registerNrStateFrequencyChange() {
        this.mPhone.getServiceStateTracker().registerForNrStateChanged(this, 7, (Object) null);
        this.mPhone.getServiceStateTracker().registerForNrFrequencyChanged(this, 6, (Object) null);
    }

    public int getDataActivity() {
        return this.mDataActivity;
    }

    public String getDataRatName(int i) {
        return getDataRatName(i, getNrMode(i));
    }

    /* access modifiers changed from: private */
    public int getNrMode(int i) {
        if (i == 13 && isNrNsaConnected()) {
            return this.mPhone.getServiceState().getNrFrequencyRange() == 4 ? 3 : 2;
        }
        if (i != 20) {
            return 1;
        }
        if (this.mPhone.getServiceState().getNrFrequencyRange() == 4) {
            return 5;
        }
        return 4;
    }

    public static String getDataRatName(int i, int i2) {
        if (i == 13 && (i2 == 2 || i2 == 3)) {
            return i2 == 2 ? DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA : DataConfigManager.DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE;
        }
        if (i == 20) {
            return i2 == 4 ? TelephonyManager.getNetworkTypeName(i) : "NR_MMWAVE";
        }
        return TelephonyManager.getNetworkTypeName(i);
    }

    private boolean isNrNsaConnected() {
        return this.mPhone.getServiceState().getNrState() == 3;
    }

    private boolean updateStaticBwValue(int i) {
        Pair<Integer, Integer> staticAvgBw = getStaticAvgBw(i);
        if (staticAvgBw == null) {
            this.mTxState.mStaticBwKbps = 14;
            this.mRxState.mStaticBwKbps = 14;
            return true;
        } else if (this.mTxState.mStaticBwKbps == ((Integer) staticAvgBw.second).intValue() && this.mRxState.mStaticBwKbps == ((Integer) staticAvgBw.first).intValue()) {
            return false;
        } else {
            this.mTxState.mStaticBwKbps = ((Integer) staticAvgBw.second).intValue();
            this.mRxState.mStaticBwKbps = ((Integer) staticAvgBw.first).intValue();
            return true;
        }
    }

    public Pair<Integer, Integer> getStaticAvgBw(int i) {
        String dataRatName = getDataRatName(i);
        Pair<Integer, Integer> pair = AVG_BW_PER_RAT_MAP.get(dataRatName);
        if (pair == null) {
            String str = TAG;
            Rlog.e(str, dataRatName + " is not found in Avg BW table");
        }
        return pair;
    }

    private void updateStaticBwValueResetFilter() {
        if (updateStaticBwValue(this.mDataRat)) {
            updateByteCountThr();
            resetBandwidthFilter();
            updateTxRxBandwidthFilterSendToDataConnection();
        }
    }

    private NetworkRegistrationInfo getDataNri() {
        return this.mPhone.getServiceState().getNetworkRegistrationInfo(2, 1);
    }

    private boolean updateDataRatCellIdentityBandwidth() {
        String str;
        boolean z;
        boolean z2;
        int accessNetworkTechnology;
        CellIdentity currentCellIdentity = this.mPhone.getCurrentCellIdentity();
        this.mTac = getTac(currentCellIdentity);
        if (this.mPhone.getServiceState().getOperatorNumeric() != null) {
            str = this.mPhone.getServiceState().getOperatorNumeric();
        } else {
            str = currentCellIdentity.getPlmn() != null ? currentCellIdentity.getPlmn() : "";
        }
        String str2 = this.mPlmn;
        boolean z3 = true;
        if (str2 == null || !str.equals(str2)) {
            this.mPlmn = str;
            z = true;
        } else {
            z = false;
        }
        NetworkRegistrationInfo dataNri = getDataNri();
        if (dataNri == null || (accessNetworkTechnology = dataNri.getAccessNetworkTechnology()) == this.mDataRat) {
            z2 = false;
        } else {
            this.mDataRat = accessNetworkTechnology;
            updateStaticBwValue(accessNetworkTechnology);
            updateByteCountThr();
            z2 = true;
        }
        if (!z && !z2) {
            z3 = false;
        }
        if (z3) {
            resetBandwidthFilter();
            updateTxRxBandwidthFilterSendToDataConnection();
            this.mLastPlmnOrRatChangeTimeMs = this.mTelephonyFacade.getElapsedSinceBootMillis();
        }
        return z3;
    }

    private int getTac(CellIdentity cellIdentity) {
        if (cellIdentity instanceof CellIdentityLte) {
            return ((CellIdentityLte) cellIdentity).getTac();
        }
        if (cellIdentity instanceof CellIdentityNr) {
            return ((CellIdentityNr) cellIdentity).getTac();
        }
        if (cellIdentity instanceof CellIdentityWcdma) {
            return ((CellIdentityWcdma) cellIdentity).getLac();
        }
        if (cellIdentity instanceof CellIdentityTdscdma) {
            return ((CellIdentityTdscdma) cellIdentity).getLac();
        }
        if (cellIdentity instanceof CellIdentityGsm) {
            return ((CellIdentityGsm) cellIdentity).getLac();
        }
        return 0;
    }

    private class TelephonyCallbackImpl extends TelephonyCallback implements TelephonyCallback.SignalStrengthsListener, TelephonyCallback.ActiveDataSubscriptionIdListener {
        private TelephonyCallbackImpl() {
        }

        public void onSignalStrengthsChanged(SignalStrength signalStrength) {
            LinkBandwidthEstimator.this.obtainMessage(5, signalStrength).sendToTarget();
        }

        public void onActiveDataSubscriptionIdChanged(int i) {
            LinkBandwidthEstimator.this.obtainMessage(8, Integer.valueOf(i)).sendToTarget();
        }
    }

    /* access modifiers changed from: package-private */
    public void logd(String str) {
        this.mLocalLog.log(str);
    }

    private static class NetworkKey {
        private final String mDataRat;
        private final String mPlmn;
        private final int mTac;

        NetworkKey(String str, int i, String str2) {
            this.mPlmn = str;
            this.mTac = i;
            this.mDataRat = str2;
        }

        public boolean equals(Object obj) {
            if (obj == null || !(obj instanceof NetworkKey) || hashCode() != obj.hashCode()) {
                return false;
            }
            if (this == obj) {
                return true;
            }
            NetworkKey networkKey = (NetworkKey) obj;
            if (!this.mPlmn.equals(networkKey.mPlmn) || this.mTac != networkKey.mTac || !this.mDataRat.equals(networkKey.mDataRat)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.mPlmn, this.mDataRat, Integer.valueOf(this.mTac)});
        }

        public String toString() {
            return "Plmn" + this.mPlmn + "Rat" + this.mDataRat + "Tac" + this.mTac;
        }
    }

    /* access modifiers changed from: private */
    public NetworkBandwidth lookupNetwork(String str, String str2) {
        return lookupNetwork(str, -1, str2);
    }

    @VisibleForTesting
    public NetworkBandwidth lookupNetwork(String str, int i, String str2) {
        if (str == null || str2.equals(TelephonyManager.getNetworkTypeName(0))) {
            return this.mPlaceholderNetwork;
        }
        NetworkKey networkKey = new NetworkKey(str, i, str2);
        NetworkBandwidth networkBandwidth = this.mNetworkMap.get(networkKey);
        if (networkBandwidth != null) {
            return networkBandwidth;
        }
        NetworkBandwidth networkBandwidth2 = new NetworkBandwidth(networkKey.toString());
        this.mNetworkMap.put(networkKey, networkBandwidth2);
        return networkBandwidth2;
    }

    @VisibleForTesting
    public class NetworkBandwidth {
        private final String mKey;

        NetworkBandwidth(String str) {
            this.mKey = str;
        }

        public void update(long j, int i, int i2) {
            SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(LinkBandwidthEstimator.this.mPhone.getContext());
            String valueKey = getValueKey(i, i2);
            String countKey = getCountKey(i, i2);
            SharedPreferences.Editor edit = defaultSharedPreferences.edit();
            long j2 = defaultSharedPreferences.getLong(valueKey, 0);
            int i3 = defaultSharedPreferences.getInt(countKey, 0);
            edit.putLong(valueKey, j2 + j);
            edit.putInt(countKey, i3 + 1);
            edit.apply();
        }

        private String getValueKey(int i, int i2) {
            return getDataKey(i, i2) + "Data";
        }

        private String getCountKey(int i, int i2) {
            return getDataKey(i, i2) + "Count";
        }

        private String getDataKey(int i, int i2) {
            return this.mKey + "Link" + i + "Level" + i2;
        }

        public long getValue(int i, int i2) {
            return PreferenceManager.getDefaultSharedPreferences(LinkBandwidthEstimator.this.mPhone.getContext()).getLong(getValueKey(i, i2), 0);
        }

        public int getCount(int i, int i2) {
            return PreferenceManager.getDefaultSharedPreferences(LinkBandwidthEstimator.this.mPhone.getContext()).getInt(getCountKey(i, i2), 0);
        }

        public String toString() {
            int i;
            StringBuilder sb = new StringBuilder();
            sb.append(this.mKey);
            sb.append("\n");
            int i2 = 0;
            while (i2 < 2) {
                sb.append(i2 == 0 ? "tx" : "rx");
                sb.append("\n avgKbps");
                for (int i3 = 0; i3 < 5; i3++) {
                    int count = getCount(i2, i3);
                    if (count == 0) {
                        i = 0;
                    } else {
                        i = (int) (getValue(i2, i3) / ((long) count));
                    }
                    sb.append(" ");
                    sb.append(i);
                }
                sb.append("\n count");
                for (int i4 = 0; i4 < 5; i4++) {
                    int count2 = getCount(i2, i4);
                    sb.append(" ");
                    sb.append(count2);
                }
                sb.append("\n");
                i2++;
            }
            return sb.toString();
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, " ");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("current PLMN " + this.mPlmn + " TAC " + this.mTac + " RAT " + getDataRatName(this.mDataRat));
        indentingPrintWriter.println("all networks visited since device boot");
        for (NetworkBandwidth networkBandwidth : this.mNetworkMap.values()) {
            indentingPrintWriter.println(networkBandwidth.toString());
        }
        try {
            this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println();
        indentingPrintWriter.flush();
    }
}
