package com.android.internal.telephony;

import android.app.UiModeManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.display.DisplayManager;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkRequest;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.provider.Settings;
import android.view.Display;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.util.ConnectivitySettingsUtils;
import com.mediatek.boostfwk.utils.Config;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import kotlin.time.DurationKt;

public class DeviceStateMonitor extends Handler {
    @VisibleForTesting
    static final int CELL_INFO_INTERVAL_LONG_MS = 10000;
    @VisibleForTesting
    static final int CELL_INFO_INTERVAL_SHORT_MS = 2000;
    protected static final boolean DBG = false;
    static final int EVENT_AUTOMOTIVE_PROJECTION_STATE_CHANGED = 1;
    @VisibleForTesting
    static final int EVENT_CHARGING_STATE_CHANGED = 4;
    static final int EVENT_POWER_SAVE_MODE_CHANGED = 3;
    static final int EVENT_RADIO_AVAILABLE = 6;
    static final int EVENT_RADIO_OFF_OR_NOT_AVAILABLE = 10;
    static final int EVENT_RADIO_ON = 9;
    static final int EVENT_RIL_CONNECTED = 0;
    @VisibleForTesting
    static final int EVENT_SCREEN_STATE_CHANGED = 2;
    static final int EVENT_TETHERING_STATE_CHANGED = 5;
    static final int EVENT_UPDATE_ALWAYS_REPORT_SIGNAL_STRENGTH = 8;
    @VisibleForTesting
    static final int EVENT_WIFI_CONNECTION_CHANGED = 7;
    private static final int[] LINK_CAPACITY_DOWNLINK_THRESHOLDS = {100, Config.SCROLLING_FING_HORIZONTAL_HINT_DURATION, 1000, GbaManager.REQUEST_TIMEOUT_MS, CELL_INFO_INTERVAL_LONG_MS, 20000, 50000, 75000, 100000, 200000, 500000, DurationKt.NANOS_IN_MILLIS, 1500000, 2000000};
    private static final int[] LINK_CAPACITY_UPLINK_THRESHOLDS = {100, Config.SCROLLING_FING_HORIZONTAL_HINT_DURATION, 1000, GbaManager.REQUEST_TIMEOUT_MS, CELL_INFO_INTERVAL_LONG_MS, 20000, 50000, 75000, 100000, 200000, 500000};
    private static final int NR_NSA_TRACKING_INDICATIONS_ALWAYS_ON = 2;
    private static final int NR_NSA_TRACKING_INDICATIONS_EXTENDED = 1;
    private static final int NR_NSA_TRACKING_INDICATIONS_OFF = 0;
    protected static final String TAG = DeviceStateMonitor.class.getSimpleName();
    private static final int WIFI_AVAILABLE = 1;
    private static final int WIFI_UNAVAILABLE = 0;
    private final BroadcastReceiver mBroadcastReceiver;
    private int mCellInfoMinInterval;
    private final DisplayManager.DisplayListener mDisplayListener;
    private boolean mIsAlwaysSignalStrengthReportingEnabled;
    private boolean mIsAutomotiveProjectionActive;
    protected boolean mIsCharging;
    protected boolean mIsLowDataExpected;
    private boolean mIsPowerSaveOn;
    private boolean mIsRadioOn;
    protected boolean mIsScreenOn;
    protected boolean mIsTetheringOn;
    private boolean mIsWifiConnected;
    private final LocalLog mLocalLog = new LocalLog(64);
    private final ConnectivityManager.NetworkCallback mNetworkCallback;
    protected final Phone mPhone;
    private final RegistrantList mPhysicalChannelConfigRegistrants = new RegistrantList();
    private int mUnsolicitedResponseFilter;
    private final NetworkRequest mWifiNetworkRequest;

    private String deviceTypeToString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? "UNKNOWN" : "LOW_DATA_EXPECTED" : "CHARGING_STATE" : "POWER_SAVE_MODE";
    }

    public DeviceStateMonitor(Phone phone) {
        NetworkRequest build = new NetworkRequest.Builder().addTransportType(1).addCapability(12).removeCapability(13).build();
        this.mWifiNetworkRequest = build;
        AnonymousClass1 r2 = new ConnectivityManager.NetworkCallback() {
            Set<Network> mWifiNetworks = new HashSet();

            public void onAvailable(Network network) {
                synchronized (this.mWifiNetworks) {
                    if (this.mWifiNetworks.size() == 0) {
                        DeviceStateMonitor.this.obtainMessage(7, 1, 0).sendToTarget();
                        DeviceStateMonitor.this.log("Wifi (default) connected", true);
                    }
                    this.mWifiNetworks.add(network);
                }
            }

            public void onLost(Network network) {
                synchronized (this.mWifiNetworks) {
                    this.mWifiNetworks.remove(network);
                    if (this.mWifiNetworks.size() == 0) {
                        DeviceStateMonitor.this.obtainMessage(7, 0, 0).sendToTarget();
                        DeviceStateMonitor.this.log("Wifi (default) disconnected", true);
                    }
                }
            }
        };
        this.mNetworkCallback = r2;
        this.mCellInfoMinInterval = 2000;
        this.mUnsolicitedResponseFilter = -1;
        AnonymousClass2 r3 = new DisplayManager.DisplayListener() {
            public void onDisplayAdded(int i) {
            }

            public void onDisplayRemoved(int i) {
            }

            public void onDisplayChanged(int i) {
                boolean r3 = DeviceStateMonitor.this.isScreenOn();
                Message obtainMessage = DeviceStateMonitor.this.obtainMessage(2);
                obtainMessage.arg1 = r3 ? 1 : 0;
                DeviceStateMonitor.this.sendMessage(obtainMessage);
            }
        };
        this.mDisplayListener = r3;
        AnonymousClass3 r4 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                Message message;
                DeviceStateMonitor.this.log("received: " + intent, true);
                String action = intent.getAction();
                action.hashCode();
                int i = 0;
                char c = 65535;
                switch (action.hashCode()) {
                    case -1754841973:
                        if (action.equals("android.net.conn.TETHER_STATE_CHANGED")) {
                            c = 0;
                            break;
                        }
                        break;
                    case -54942926:
                        if (action.equals("android.os.action.DISCHARGING")) {
                            c = 1;
                            break;
                        }
                        break;
                    case 948344062:
                        if (action.equals("android.os.action.CHARGING")) {
                            c = 2;
                            break;
                        }
                        break;
                    case 1779291251:
                        if (action.equals("android.os.action.POWER_SAVE_MODE_CHANGED")) {
                            c = 3;
                            break;
                        }
                        break;
                }
                String str = "on";
                switch (c) {
                    case 0:
                        ArrayList<String> stringArrayListExtra = intent.getStringArrayListExtra("tetherArray");
                        if (stringArrayListExtra != null && stringArrayListExtra.size() > 0) {
                            i = 1;
                        }
                        DeviceStateMonitor deviceStateMonitor = DeviceStateMonitor.this;
                        StringBuilder sb = new StringBuilder();
                        sb.append("Tethering ");
                        if (i == 0) {
                            str = ConnectivitySettingsUtils.PRIVATE_DNS_MODE_OFF_STRING;
                        }
                        sb.append(str);
                        deviceStateMonitor.log(sb.toString(), true);
                        message = DeviceStateMonitor.this.obtainMessage(5);
                        message.arg1 = i;
                        break;
                    case 1:
                        message = DeviceStateMonitor.this.obtainMessage(4);
                        message.arg1 = 0;
                        break;
                    case 2:
                        message = DeviceStateMonitor.this.obtainMessage(4);
                        message.arg1 = 1;
                        break;
                    case 3:
                        message = DeviceStateMonitor.this.obtainMessage(3);
                        message.arg1 = DeviceStateMonitor.this.isPowerSaveModeOn() ? 1 : 0;
                        DeviceStateMonitor deviceStateMonitor2 = DeviceStateMonitor.this;
                        StringBuilder sb2 = new StringBuilder();
                        sb2.append("Power Save mode ");
                        if (message.arg1 != 1) {
                            str = ConnectivitySettingsUtils.PRIVATE_DNS_MODE_OFF_STRING;
                        }
                        sb2.append(str);
                        deviceStateMonitor2.log(sb2.toString(), true);
                        break;
                    default:
                        DeviceStateMonitor.this.log("Unexpected broadcast intent: " + intent, false);
                        return;
                }
                DeviceStateMonitor.this.sendMessage(message);
            }
        };
        this.mBroadcastReceiver = r4;
        this.mPhone = phone;
        ((DisplayManager) phone.getContext().getSystemService("display")).registerDisplayListener(r3, (Handler) null);
        this.mIsPowerSaveOn = isPowerSaveModeOn();
        this.mIsCharging = isDeviceCharging();
        this.mIsScreenOn = isScreenOn();
        this.mIsRadioOn = isRadioOn();
        this.mIsAutomotiveProjectionActive = isAutomotiveProjectionActive();
        this.mIsTetheringOn = false;
        this.mIsLowDataExpected = false;
        log("DeviceStateMonitor mIsTetheringOn=" + this.mIsTetheringOn + ", mIsScreenOn=" + this.mIsScreenOn + ", mIsCharging=" + this.mIsCharging + ", mIsPowerSaveOn=" + this.mIsPowerSaveOn + ", mIsLowDataExpected=" + this.mIsLowDataExpected + ", mIsAutomotiveProjectionActive=" + this.mIsAutomotiveProjectionActive + ", mIsWifiConnected=" + this.mIsWifiConnected + ", mIsAlwaysSignalStrengthReportingEnabled=" + this.mIsAlwaysSignalStrengthReportingEnabled + ", mIsRadioOn=" + this.mIsRadioOn, false);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.os.action.POWER_SAVE_MODE_CHANGED");
        intentFilter.addAction("android.os.action.CHARGING");
        intentFilter.addAction("android.os.action.DISCHARGING");
        intentFilter.addAction("android.net.conn.TETHER_STATE_CHANGED");
        phone.getContext().registerReceiver(r4, intentFilter, (String) null, phone);
        phone.mCi.registerForRilConnected(this, 0, (Object) null);
        phone.mCi.registerForAvailable(this, 6, (Object) null);
        phone.mCi.registerForOn(this, 9, (Object) null);
        phone.mCi.registerForOffOrNotAvailable(this, 10, (Object) null);
        ((ConnectivityManager) phone.getContext().getSystemService("connectivity")).registerNetworkCallback(build, r2);
        ((UiModeManager) phone.getContext().getSystemService("uimode")).addOnProjectionStateChangedListener(1, phone.getContext().getMainExecutor(), new DeviceStateMonitor$$ExternalSyntheticLambda0(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$0(int i, Set set) {
        Message obtainMessage = obtainMessage(1);
        obtainMessage.arg1 = Math.min(set.size(), 1);
        sendMessage(obtainMessage);
    }

    /* access modifiers changed from: protected */
    public boolean isLowDataExpected() {
        return (!this.mIsCharging && !this.mIsTetheringOn && !this.mIsScreenOn) || !this.mIsRadioOn;
    }

    @VisibleForTesting
    public int computeCellInfoMinInterval() {
        boolean z = this.mIsScreenOn;
        if (z && !this.mIsWifiConnected) {
            return 2000;
        }
        if (!z || !this.mIsCharging) {
            return CELL_INFO_INTERVAL_LONG_MS;
        }
        return 2000;
    }

    private boolean shouldEnableSignalStrengthReports() {
        return shouldEnableHighPowerConsumptionIndications() || (this.mIsAlwaysSignalStrengthReportingEnabled && this.mIsRadioOn);
    }

    private boolean shouldEnableFullNetworkStateReports() {
        return shouldEnableNrTrackingIndications();
    }

    private boolean shouldEnableDataCallDormancyChangedReports() {
        return shouldEnableNrTrackingIndications();
    }

    private boolean shouldEnableLinkCapacityEstimateReports() {
        return shouldEnableHighPowerConsumptionIndications();
    }

    private boolean shouldEnablePhysicalChannelConfigReports() {
        return shouldEnableNrTrackingIndications();
    }

    private boolean shouldEnableBarringInfoReports() {
        return shouldEnableHighPowerConsumptionIndications();
    }

    public boolean shouldEnableHighPowerConsumptionIndications() {
        return (this.mIsCharging || this.mIsScreenOn || this.mIsTetheringOn || this.mIsAutomotiveProjectionActive) && this.mIsRadioOn;
    }

    private boolean shouldEnableNrTrackingIndications() {
        int i = Settings.Global.getInt(this.mPhone.getContext().getContentResolver(), "nr_nsa_tracking_screen_off_mode", 0);
        if (i != 0) {
            if (i != 1) {
                if (i != 2) {
                    return shouldEnableHighPowerConsumptionIndications();
                }
                return true;
            } else if (this.mPhone.getServiceState().getNrState() == 3) {
                return true;
            }
        }
        return shouldEnableHighPowerConsumptionIndications();
    }

    public void setAlwaysReportSignalStrength(boolean z) {
        Message obtainMessage = obtainMessage(8);
        obtainMessage.arg1 = z ? 1 : 0;
        sendMessage(obtainMessage);
    }

    public void handleMessage(Message message) {
        boolean z = false;
        log("handleMessage msg=" + message, false);
        int i = message.what;
        switch (i) {
            case 0:
            case 6:
                onReset();
                return;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 8:
                if (message.arg1 != 0) {
                    z = true;
                }
                onUpdateDeviceState(i, z);
                return;
            case 7:
                if (message.arg1 != 0) {
                    z = true;
                }
                onUpdateDeviceState(i, z);
                return;
            case 9:
                onUpdateDeviceState(i, true);
                return;
            case 10:
                onUpdateDeviceState(i, false);
                return;
            default:
                throw new IllegalStateException("Unexpected message arrives. msg = " + message.what);
        }
    }

    private void onUpdateDeviceState(int i, boolean z) {
        boolean shouldEnableBarringInfoReports = shouldEnableBarringInfoReports();
        boolean shouldEnableHighPowerConsumptionIndications = shouldEnableHighPowerConsumptionIndications();
        boolean z2 = true;
        switch (i) {
            case 1:
                if (this.mIsAutomotiveProjectionActive != z) {
                    this.mIsAutomotiveProjectionActive = z;
                    break;
                } else {
                    return;
                }
            case 2:
                if (this.mIsScreenOn != z) {
                    this.mIsScreenOn = z;
                    break;
                } else {
                    return;
                }
            case 3:
                if (this.mIsPowerSaveOn != z) {
                    this.mIsPowerSaveOn = z;
                    sendDeviceState(0, z);
                    break;
                } else {
                    return;
                }
            case 4:
                if (this.mIsCharging != z) {
                    this.mIsCharging = z;
                    sendDeviceState(1, z);
                    break;
                } else {
                    return;
                }
            case 5:
                if (this.mIsTetheringOn != z) {
                    this.mIsTetheringOn = z;
                    break;
                } else {
                    return;
                }
            case 7:
                if (this.mIsWifiConnected != z) {
                    this.mIsWifiConnected = z;
                    break;
                } else {
                    return;
                }
            case 8:
                if (this.mIsAlwaysSignalStrengthReportingEnabled != z) {
                    this.mIsAlwaysSignalStrengthReportingEnabled = z;
                    break;
                } else {
                    return;
                }
            case 9:
            case 10:
                if (this.mIsRadioOn != z) {
                    this.mIsRadioOn = z;
                    break;
                } else {
                    return;
                }
            default:
                return;
        }
        boolean shouldEnableHighPowerConsumptionIndications2 = shouldEnableHighPowerConsumptionIndications();
        if (shouldEnableHighPowerConsumptionIndications != shouldEnableHighPowerConsumptionIndications2) {
            this.mPhone.notifyDeviceIdleStateChanged(!shouldEnableHighPowerConsumptionIndications2);
        }
        int computeCellInfoMinInterval = computeCellInfoMinInterval();
        if (this.mCellInfoMinInterval != computeCellInfoMinInterval) {
            this.mCellInfoMinInterval = computeCellInfoMinInterval;
            setCellInfoMinInterval(computeCellInfoMinInterval);
            log("CellInfo Min Interval Updated to " + computeCellInfoMinInterval, true);
        }
        if (this.mIsLowDataExpected != isLowDataExpected()) {
            boolean z3 = !this.mIsLowDataExpected;
            this.mIsLowDataExpected = z3;
            sendDeviceState(2, z3);
        }
        int i2 = 32;
        if (shouldEnableSignalStrengthReports()) {
            i2 = 33;
        }
        if (shouldEnableFullNetworkStateReports()) {
            i2 |= 2;
        }
        if (shouldEnableDataCallDormancyChangedReports()) {
            i2 |= 4;
        }
        if (shouldEnableLinkCapacityEstimateReports()) {
            i2 |= 8;
        }
        if (shouldEnablePhysicalChannelConfigReports()) {
            i2 |= 16;
        }
        boolean shouldEnableBarringInfoReports2 = shouldEnableBarringInfoReports();
        if (shouldEnableBarringInfoReports2) {
            i2 |= 64;
        }
        int i3 = i2 & 16;
        if (i3 != (this.mUnsolicitedResponseFilter & 16)) {
            RegistrantList registrantList = this.mPhysicalChannelConfigRegistrants;
            if (i3 == 0) {
                z2 = false;
            }
            registrantList.notifyResult(Boolean.valueOf(z2));
        }
        setUnsolResponseFilter(i2, false);
        if (shouldEnableBarringInfoReports2 && !shouldEnableBarringInfoReports) {
            this.mPhone.mCi.getBarringInfo((Message) null);
        }
    }

    private void onReset() {
        log("onReset.", true);
        sendDeviceState(1, this.mIsCharging);
        sendDeviceState(2, this.mIsLowDataExpected);
        sendDeviceState(0, this.mIsPowerSaveOn);
        setUnsolResponseFilter(this.mUnsolicitedResponseFilter, true);
        setLinkCapacityReportingCriteria();
        setCellInfoMinInterval(this.mCellInfoMinInterval);
    }

    private void sendDeviceState(int i, boolean z) {
        log("send type: " + deviceTypeToString(i) + ", state=" + z, true);
        this.mPhone.mCi.sendDeviceState(i, z, (Message) null);
    }

    private void setUnsolResponseFilter(int i, boolean z) {
        if (z || i != this.mUnsolicitedResponseFilter) {
            log("old filter: " + this.mUnsolicitedResponseFilter + ", new filter: " + i, true);
            this.mPhone.mCi.setUnsolResponseFilter(i, (Message) null);
            this.mUnsolicitedResponseFilter = i;
        }
    }

    private void setLinkCapacityReportingCriteria() {
        Phone phone = this.mPhone;
        int[] iArr = LINK_CAPACITY_DOWNLINK_THRESHOLDS;
        int[] iArr2 = LINK_CAPACITY_UPLINK_THRESHOLDS;
        phone.setLinkCapacityReportingCriteria(iArr, iArr2, 1);
        this.mPhone.setLinkCapacityReportingCriteria(iArr, iArr2, 2);
        this.mPhone.setLinkCapacityReportingCriteria(iArr, iArr2, 3);
        this.mPhone.setLinkCapacityReportingCriteria(iArr, iArr2, 4);
        if (this.mPhone.getHalVersion().greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
            this.mPhone.setLinkCapacityReportingCriteria(iArr, iArr2, 6);
        }
    }

    private void setCellInfoMinInterval(int i) {
        this.mPhone.setCellInfoMinInterval(i);
    }

    /* access modifiers changed from: private */
    public boolean isPowerSaveModeOn() {
        boolean isPowerSaveMode = ((PowerManager) this.mPhone.getContext().getSystemService(XmlTagConst.TAG_POWER)).isPowerSaveMode();
        log("isPowerSaveModeOn=" + isPowerSaveMode, true);
        return isPowerSaveMode;
    }

    private boolean isDeviceCharging() {
        boolean isCharging = ((BatteryManager) this.mPhone.getContext().getSystemService("batterymanager")).isCharging();
        log("isDeviceCharging=" + isCharging, true);
        return isCharging;
    }

    /* access modifiers changed from: private */
    public boolean isScreenOn() {
        Display[] displays = ((DisplayManager) this.mPhone.getContext().getSystemService("display")).getDisplays();
        if (displays != null) {
            for (Display display : displays) {
                if (display.getState() == 2) {
                    log("Screen on for display=" + display, true);
                    return true;
                }
            }
            log("Screens all off", true);
            return false;
        }
        log("No displays found", true);
        return false;
    }

    private boolean isRadioOn() {
        return this.mPhone.isRadioOn();
    }

    private boolean isAutomotiveProjectionActive() {
        UiModeManager uiModeManager = (UiModeManager) this.mPhone.getContext().getSystemService("uimode");
        boolean z = false;
        if (uiModeManager == null) {
            return false;
        }
        if ((uiModeManager.getActiveProjectionTypes() & 1) != 0) {
            z = true;
        }
        log("isAutomotiveProjectionActive=" + z, true);
        return z;
    }

    public void registerForPhysicalChannelConfigNotifChanged(Handler handler, int i, Object obj) {
        this.mPhysicalChannelConfigRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForPhysicalChannelConfigNotifChanged(Handler handler) {
        this.mPhysicalChannelConfigRegistrants.remove(handler);
    }

    /* access modifiers changed from: private */
    public void log(String str, boolean z) {
        if (z) {
            this.mLocalLog.log(str);
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("mIsTetheringOn=" + this.mIsTetheringOn);
        indentingPrintWriter.println("mIsScreenOn=" + this.mIsScreenOn);
        indentingPrintWriter.println("mIsCharging=" + this.mIsCharging);
        indentingPrintWriter.println("mIsPowerSaveOn=" + this.mIsPowerSaveOn);
        indentingPrintWriter.println("mIsLowDataExpected=" + this.mIsLowDataExpected);
        indentingPrintWriter.println("mIsAutomotiveProjectionActive=" + this.mIsAutomotiveProjectionActive);
        indentingPrintWriter.println("mUnsolicitedResponseFilter=" + this.mUnsolicitedResponseFilter);
        indentingPrintWriter.println("mIsWifiConnected=" + this.mIsWifiConnected);
        indentingPrintWriter.println("mIsAlwaysSignalStrengthReportingEnabled=" + this.mIsAlwaysSignalStrengthReportingEnabled);
        indentingPrintWriter.println("mIsRadioOn=" + this.mIsRadioOn);
        indentingPrintWriter.println("Local logs:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.flush();
    }
}
