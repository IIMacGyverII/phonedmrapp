package com.android.internal.telephony;

import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.Network;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.UserHandle;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.text.TextUtils;
import com.android.internal.telephony.util.ArrayUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class CarrierSignalAgent extends Handler {
    private static final String CARRIER_SIGNAL_DELIMITER = "\\s*,\\s*";
    private static final Map<String, String> COMPAT_ACTION_TO_NEW_MAP;
    private static final String COMPONENT_NAME_DELIMITER = "\\s*:\\s*";
    private static final boolean DBG = true;
    private static final int EVENT_REGISTER_DEFAULT_NETWORK_AVAIL = 0;
    private static final String LOG_TAG;
    private static final Map<String, String> NEW_ACTION_TO_COMPAT_MAP;
    private static final boolean NO_WAKE = false;
    private static final Set<String> VALID_CARRIER_SIGNAL_ACTIONS = new HashSet(Arrays.asList(new String[]{"android.telephony.action.CARRIER_SIGNAL_PCO_VALUE", "android.telephony.action.CARRIER_SIGNAL_REDIRECTED", "android.telephony.action.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED", "android.telephony.action.CARRIER_SIGNAL_RESET", "android.telephony.action.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE"}));
    private static final boolean VDBG;
    private static final boolean WAKE = true;
    private Map<String, Set<ComponentName>> mCachedNoWakeSignalConfigs = new HashMap();
    private Map<String, Set<ComponentName>> mCachedWakeSignalConfigs = new HashMap();
    /* access modifiers changed from: private */
    public boolean mDefaultNetworkAvail;
    private final LocalLog mErrorLocalLog = new LocalLog(16);
    private ConnectivityManager.NetworkCallback mNetworkCallback;
    private final Phone mPhone;
    private final BroadcastReceiver mReceiver;

    static {
        String simpleName = CarrierSignalAgent.class.getSimpleName();
        LOG_TAG = simpleName;
        VDBG = Rlog.isLoggable(simpleName, 2);
        AnonymousClass1 r0 = new HashMap<String, String>() {
            {
                put("android.telephony.action.CARRIER_SIGNAL_PCO_VALUE", "com.android.internal.telephony.CARRIER_SIGNAL_PCO_VALUE");
                put("android.telephony.action.CARRIER_SIGNAL_REDIRECTED", "com.android.internal.telephony.CARRIER_SIGNAL_REDIRECTED");
                put("android.telephony.action.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED", "com.android.internal.telephony.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED");
                put("android.telephony.action.CARRIER_SIGNAL_RESET", "com.android.internal.telephony.CARRIER_SIGNAL_RESET");
                put("android.telephony.action.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE", "com.android.internal.telephony.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE");
            }
        };
        NEW_ACTION_TO_COMPAT_MAP = r0;
        COMPAT_ACTION_TO_NEW_MAP = (Map) r0.entrySet().stream().collect(Collectors.toMap(new CarrierSignalAgent$$ExternalSyntheticLambda0(), new CarrierSignalAgent$$ExternalSyntheticLambda1()));
    }

    public CarrierSignalAgent(Phone phone) {
        AnonymousClass2 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                CarrierSignalAgent carrierSignalAgent = CarrierSignalAgent.this;
                carrierSignalAgent.log("CarrierSignalAgent receiver action: " + action);
                if (action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED")) {
                    CarrierSignalAgent.this.loadCarrierConfig();
                }
            }
        };
        this.mReceiver = r0;
        this.mPhone = phone;
        loadCarrierConfig();
        phone.getContext().registerReceiver(r0, new IntentFilter("android.telephony.action.CARRIER_CONFIG_CHANGED"));
        phone.getCarrierActionAgent().registerForCarrierAction(3, this, 0, (Object) null, false);
    }

    public void handleMessage(Message message) {
        if (message.what == 0) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult.exception != null) {
                String str = LOG_TAG;
                Rlog.e(str, "Register default network exception: " + asyncResult.exception);
                return;
            }
            ConnectivityManager connectivityManager = (ConnectivityManager) this.mPhone.getContext().getSystemService(ConnectivityManager.class);
            if (((Boolean) asyncResult.result).booleanValue()) {
                AnonymousClass3 r3 = new ConnectivityManager.NetworkCallback() {
                    public void onAvailable(Network network) {
                        if (!CarrierSignalAgent.this.mDefaultNetworkAvail) {
                            CarrierSignalAgent carrierSignalAgent = CarrierSignalAgent.this;
                            carrierSignalAgent.log("Default network available: " + network);
                            Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE");
                            intent.putExtra("android.telephony.extra.DEFAULT_NETWORK_AVAILABLE", true);
                            CarrierSignalAgent.this.notifyCarrierSignalReceivers(intent);
                            CarrierSignalAgent.this.mDefaultNetworkAvail = true;
                        }
                    }

                    public void onLost(Network network) {
                        CarrierSignalAgent carrierSignalAgent = CarrierSignalAgent.this;
                        carrierSignalAgent.log("Default network lost: " + network);
                        Intent intent = new Intent("android.telephony.action.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE");
                        intent.putExtra("android.telephony.extra.DEFAULT_NETWORK_AVAILABLE", false);
                        CarrierSignalAgent.this.notifyCarrierSignalReceivers(intent);
                        CarrierSignalAgent.this.mDefaultNetworkAvail = false;
                    }
                };
                this.mNetworkCallback = r3;
                connectivityManager.registerDefaultNetworkCallback(r3, this.mPhone);
                log("Register default network");
                return;
            }
            ConnectivityManager.NetworkCallback networkCallback = this.mNetworkCallback;
            if (networkCallback != null) {
                connectivityManager.unregisterNetworkCallback(networkCallback);
                this.mNetworkCallback = null;
                this.mDefaultNetworkAvail = false;
                log("unregister default network");
            }
        }
    }

    /* access modifiers changed from: private */
    public void loadCarrierConfig() {
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        PersistableBundle configForSubId = carrierConfigManager != null ? carrierConfigManager.getConfigForSubId(this.mPhone.getSubId()) : null;
        if (configForSubId != null) {
            synchronized (this.mCachedWakeSignalConfigs) {
                log("Loading carrier config: carrier_app_wake_signal_config");
                Map<String, Set<ComponentName>> parseAndCache = parseAndCache(configForSubId.getStringArray("carrier_app_wake_signal_config"));
                if (!this.mCachedWakeSignalConfigs.isEmpty() && !parseAndCache.equals(this.mCachedWakeSignalConfigs)) {
                    if (VDBG) {
                        log("carrier config changed, reset receivers from old config");
                    }
                    this.mPhone.getCarrierActionAgent().sendEmptyMessage(2);
                }
                this.mCachedWakeSignalConfigs = parseAndCache;
            }
            synchronized (this.mCachedNoWakeSignalConfigs) {
                log("Loading carrier config: carrier_app_no_wake_signal_config");
                Map<String, Set<ComponentName>> parseAndCache2 = parseAndCache(configForSubId.getStringArray("carrier_app_no_wake_signal_config"));
                if (!this.mCachedNoWakeSignalConfigs.isEmpty() && !parseAndCache2.equals(this.mCachedNoWakeSignalConfigs)) {
                    if (VDBG) {
                        log("carrier config changed, reset receivers from old config");
                    }
                    this.mPhone.getCarrierActionAgent().sendEmptyMessage(2);
                }
                this.mCachedNoWakeSignalConfigs = parseAndCache2;
            }
        }
    }

    private Map<String, Set<ComponentName>> parseAndCache(String[] strArr) {
        HashMap hashMap = new HashMap();
        if (!ArrayUtils.isEmpty(strArr)) {
            for (String str : strArr) {
                if (!TextUtils.isEmpty(str)) {
                    String[] split = str.trim().split(COMPONENT_NAME_DELIMITER, 2);
                    if (split.length == 2) {
                        ComponentName unflattenFromString = ComponentName.unflattenFromString(split[0]);
                        if (unflattenFromString == null) {
                            loge("Invalid component name: " + split[0]);
                        } else {
                            for (String str2 : split[1].split(CARRIER_SIGNAL_DELIMITER)) {
                                if (!VALID_CARRIER_SIGNAL_ACTIONS.contains(str2)) {
                                    Map<String, String> map = COMPAT_ACTION_TO_NEW_MAP;
                                    if (map.containsKey(str2)) {
                                        str2 = map.get(str2);
                                    } else {
                                        loge("Invalid signal name: " + str2);
                                    }
                                }
                                Set set = (Set) hashMap.get(str2);
                                if (set == null) {
                                    set = new HashSet();
                                    hashMap.put(str2, set);
                                }
                                set.add(unflattenFromString);
                                if (VDBG) {
                                    logv("Add config {signal: " + str2 + " componentName: " + unflattenFromString + "}");
                                }
                            }
                        }
                    } else {
                        loge("invalid config format: " + str);
                    }
                }
            }
        }
        return hashMap;
    }

    public boolean hasRegisteredReceivers(String str) {
        return this.mCachedWakeSignalConfigs.containsKey(str) || this.mCachedNoWakeSignalConfigs.containsKey(str);
    }

    private void broadcast(Intent intent, Set<ComponentName> set, boolean z) {
        PackageManager packageManager = this.mPhone.getContext().getPackageManager();
        for (ComponentName next : set) {
            Intent intent2 = new Intent(intent);
            if (z) {
                intent2.setComponent(next);
            } else {
                intent2.setPackage(next.getPackageName());
            }
            if (z && packageManager.queryBroadcastReceivers(intent2, 65536).isEmpty()) {
                loge("Carrier signal receivers are configured but unavailable: " + intent2.getComponent());
            } else if (z || packageManager.queryBroadcastReceivers(intent2, 65536).isEmpty()) {
                SubscriptionManager.putSubscriptionIdExtra(intent2, this.mPhone.getSubId());
                intent2.addFlags(268435456);
                if (!z) {
                    intent2.setFlags(16);
                }
                Intent intent3 = null;
                try {
                    if (this.mPhone.getContext().getPackageManager().getApplicationInfo(next.getPackageName(), 0).targetSdkVersion <= 30) {
                        intent3 = createCompatIntent(intent2);
                    }
                } catch (PackageManager.NameNotFoundException unused) {
                }
                if (intent3 != null) {
                    intent2 = intent3;
                }
                try {
                    this.mPhone.getContext().sendBroadcastAsUser(intent2, UserHandle.ALL);
                    log("Sending signal " + intent2.getAction() + " to the carrier signal receiver: " + intent2.getComponent());
                } catch (ActivityNotFoundException e) {
                    loge("Send broadcast failed: " + e);
                }
            } else {
                loge("Runtime signals shouldn't be configured in Manifest: " + intent2.getComponent());
            }
        }
    }

    public void notifyCarrierSignalReceivers(Intent intent) {
        synchronized (this.mCachedWakeSignalConfigs) {
            Set set = this.mCachedWakeSignalConfigs.get(intent.getAction());
            if (!ArrayUtils.isEmpty(set)) {
                broadcast(intent, set, true);
            }
        }
        synchronized (this.mCachedNoWakeSignalConfigs) {
            Set set2 = this.mCachedNoWakeSignalConfigs.get(intent.getAction());
            if (!ArrayUtils.isEmpty(set2)) {
                broadcast(intent, set2, false);
            }
        }
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private static android.content.Intent createCompatIntent(android.content.Intent r13) {
        /*
            java.util.Map<java.lang.String, java.lang.String> r0 = NEW_ACTION_TO_COMPAT_MAP
            java.lang.String r1 = r13.getAction()
            java.lang.Object r0 = r0.get(r1)
            java.lang.String r0 = (java.lang.String) r0
            if (r0 != 0) goto L_0x0036
            java.lang.String r0 = LOG_TAG
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "intent action "
            r1.append(r2)
            java.lang.String r2 = r13.getAction()
            r1.append(r2)
            java.lang.String r2 = " does not have a compat alternative for component "
            r1.append(r2)
            android.content.ComponentName r13 = r13.getComponent()
            r1.append(r13)
            java.lang.String r13 = r1.toString()
            com.android.telephony.Rlog.i(r0, r13)
            r13 = 0
            return r13
        L_0x0036:
            android.content.Intent r1 = new android.content.Intent
            r1.<init>(r13)
            r1.setAction(r0)
            android.os.Bundle r0 = r13.getExtras()
            java.util.Set r0 = r0.keySet()
            java.util.Iterator r0 = r0.iterator()
        L_0x004a:
            boolean r2 = r0.hasNext()
            if (r2 == 0) goto L_0x0113
            java.lang.Object r2 = r0.next()
            java.lang.String r2 = (java.lang.String) r2
            r2.hashCode()
            int r3 = r2.hashCode()
            java.lang.String r4 = "android.telephony.extra.PCO_VALUE"
            java.lang.String r5 = "android.telephony.extra.REDIRECTION_URL"
            java.lang.String r6 = "android.telephony.extra.DATA_FAIL_CAUSE"
            java.lang.String r7 = "android.telephony.extra.PCO_ID"
            java.lang.String r8 = "android.telephony.extra.DEFAULT_NETWORK_AVAILABLE"
            java.lang.String r9 = "android.telephony.extra.APN_TYPE"
            r10 = 0
            java.lang.String r11 = "android.telephony.extra.APN_PROTOCOL"
            r12 = -1
            switch(r3) {
                case -1619711317: goto L_0x00a8;
                case -1150077747: goto L_0x009f;
                case -835597273: goto L_0x0096;
                case -263064687: goto L_0x008d;
                case 160882922: goto L_0x0084;
                case 845302377: goto L_0x007b;
                case 1367216923: goto L_0x0072;
                default: goto L_0x0070;
            }
        L_0x0070:
            r2 = r12
            goto L_0x00b0
        L_0x0072:
            boolean r2 = r2.equals(r4)
            if (r2 != 0) goto L_0x0079
            goto L_0x0070
        L_0x0079:
            r2 = 6
            goto L_0x00b0
        L_0x007b:
            boolean r2 = r2.equals(r5)
            if (r2 != 0) goto L_0x0082
            goto L_0x0070
        L_0x0082:
            r2 = 5
            goto L_0x00b0
        L_0x0084:
            boolean r2 = r2.equals(r6)
            if (r2 != 0) goto L_0x008b
            goto L_0x0070
        L_0x008b:
            r2 = 4
            goto L_0x00b0
        L_0x008d:
            boolean r2 = r2.equals(r7)
            if (r2 != 0) goto L_0x0094
            goto L_0x0070
        L_0x0094:
            r2 = 3
            goto L_0x00b0
        L_0x0096:
            boolean r2 = r2.equals(r8)
            if (r2 != 0) goto L_0x009d
            goto L_0x0070
        L_0x009d:
            r2 = 2
            goto L_0x00b0
        L_0x009f:
            boolean r2 = r2.equals(r9)
            if (r2 != 0) goto L_0x00a6
            goto L_0x0070
        L_0x00a6:
            r2 = 1
            goto L_0x00b0
        L_0x00a8:
            boolean r2 = r2.equals(r11)
            if (r2 != 0) goto L_0x00af
            goto L_0x0070
        L_0x00af:
            r2 = r10
        L_0x00b0:
            switch(r2) {
                case 0: goto L_0x00ff;
                case 1: goto L_0x00e9;
                case 2: goto L_0x00de;
                case 3: goto L_0x00d3;
                case 4: goto L_0x00c8;
                case 5: goto L_0x00be;
                case 6: goto L_0x00b4;
                default: goto L_0x00b3;
            }
        L_0x00b3:
            goto L_0x004a
        L_0x00b4:
            byte[] r2 = r13.getByteArrayExtra(r4)
            java.lang.String r3 = "pcoValue"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00be:
            java.lang.String r2 = r13.getStringExtra(r5)
            java.lang.String r3 = "redirectionUrl"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00c8:
            int r2 = r13.getIntExtra(r6, r12)
            java.lang.String r3 = "errorCode"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00d3:
            int r2 = r13.getIntExtra(r7, r12)
            java.lang.String r3 = "pcoId"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00de:
            boolean r2 = r13.getBooleanExtra(r8, r10)
            java.lang.String r3 = "defaultNetworkAvailable"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00e9:
            r2 = 17
            int r2 = r13.getIntExtra(r9, r2)
            java.lang.String r3 = "apnTypeInt"
            r1.putExtra(r3, r2)
            java.lang.String r2 = android.telephony.data.ApnSetting.getApnTypesStringFromBitmask(r2)
            java.lang.String r3 = "apnType"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x00ff:
            int r2 = r13.getIntExtra(r11, r12)
            java.lang.String r3 = "apnProtoInt"
            r1.putExtra(r3, r2)
            java.lang.String r2 = android.telephony.data.ApnSetting.getProtocolStringFromInt(r2)
            java.lang.String r3 = "apnProto"
            r1.putExtra(r3, r2)
            goto L_0x004a
        L_0x0113:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CarrierSignalAgent.createCompatIntent(android.content.Intent):android.content.Intent");
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        String str2 = LOG_TAG;
        Rlog.d(str2, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    private void loge(String str) {
        this.mErrorLocalLog.log(str);
        String str2 = LOG_TAG;
        Rlog.e(str2, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    private void logv(String str) {
        String str2 = LOG_TAG;
        Rlog.v(str2, "[" + this.mPhone.getPhoneId() + "]" + str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        printWriter.println("mCachedWakeSignalConfigs:");
        indentingPrintWriter.increaseIndent();
        for (Map.Entry next : this.mCachedWakeSignalConfigs.entrySet()) {
            printWriter.println("signal: " + ((String) next.getKey()) + " componentName list: " + next.getValue());
        }
        indentingPrintWriter.decreaseIndent();
        printWriter.println("mCachedNoWakeSignalConfigs:");
        indentingPrintWriter.increaseIndent();
        for (Map.Entry next2 : this.mCachedNoWakeSignalConfigs.entrySet()) {
            printWriter.println("signal: " + ((String) next2.getKey()) + " componentName list: " + next2.getValue());
        }
        indentingPrintWriter.decreaseIndent();
        printWriter.println("mDefaultNetworkAvail: " + this.mDefaultNetworkAvail);
        printWriter.println("error log:");
        indentingPrintWriter.increaseIndent();
        this.mErrorLocalLog.dump(fileDescriptor, printWriter, strArr);
        indentingPrintWriter.decreaseIndent();
    }
}
