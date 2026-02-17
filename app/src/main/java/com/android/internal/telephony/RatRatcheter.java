package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.PersistableBundle;
import android.os.UserHandle;
import android.telephony.CarrierConfigManager;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.ServiceState;
import android.util.SparseArray;
import android.util.SparseIntArray;
import com.android.telephony.Rlog;
import java.util.Arrays;

public class RatRatcheter {
    private static final String LOG_TAG = "RilRatcheter";
    private BroadcastReceiver mConfigChangedReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if ("android.telephony.action.CARRIER_CONFIG_CHANGED".equals(intent.getAction())) {
                RatRatcheter.this.resetRatFamilyMap();
            }
        }
    };
    private final Phone mPhone;
    private final SparseArray<SparseIntArray> mRatFamilyMap = new SparseArray<>();

    public static boolean updateBandwidths(int[] iArr, ServiceState serviceState) {
        if (iArr == null || Arrays.stream(iArr).sum() <= Arrays.stream(serviceState.getCellBandwidths()).sum()) {
            return false;
        }
        serviceState.setCellBandwidths(iArr);
        return true;
    }

    public RatRatcheter(Phone phone) {
        this.mPhone = phone;
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        try {
            phone.getContext().createPackageContextAsUser(phone.getContext().getPackageName(), 0, UserHandle.ALL).registerReceiver(this.mConfigChangedReceiver, intentFilter, (String) null, (Handler) null);
        } catch (PackageManager.NameNotFoundException e) {
            Rlog.e(LOG_TAG, "Package name not found: " + e.getMessage());
        }
        resetRatFamilyMap();
    }

    private int ratchetRat(int i, int i2) {
        int networkTypeToRilRadioTechnology = ServiceState.networkTypeToRilRadioTechnology(i);
        int networkTypeToRilRadioTechnology2 = ServiceState.networkTypeToRilRadioTechnology(i2);
        synchronized (this.mRatFamilyMap) {
            SparseIntArray sparseIntArray = this.mRatFamilyMap.get(networkTypeToRilRadioTechnology);
            if (sparseIntArray == null) {
                return i2;
            }
            SparseIntArray sparseIntArray2 = this.mRatFamilyMap.get(networkTypeToRilRadioTechnology2);
            if (sparseIntArray2 != sparseIntArray) {
                return i2;
            }
            if (sparseIntArray2.get(networkTypeToRilRadioTechnology, -1) <= sparseIntArray2.get(networkTypeToRilRadioTechnology2, -1)) {
                networkTypeToRilRadioTechnology = networkTypeToRilRadioTechnology2;
            }
            int rilRadioTechnologyToNetworkType = ServiceState.rilRadioTechnologyToNetworkType(networkTypeToRilRadioTechnology);
            return rilRadioTechnologyToNetworkType;
        }
    }

    public void ratchet(ServiceState serviceState, ServiceState serviceState2) {
        if (!isSameRatFamily(serviceState, serviceState2)) {
            Rlog.e(LOG_TAG, "Same cell cannot have different RAT Families. Likely bug.");
            return;
        }
        int[] iArr = {1, 2};
        for (int i = 0; i < 2; i++) {
            int i2 = iArr[i];
            NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(i2, 1);
            NetworkRegistrationInfo networkRegistrationInfo2 = serviceState2.getNetworkRegistrationInfo(i2, 1);
            networkRegistrationInfo2.setAccessNetworkTechnology(ratchetRat(networkRegistrationInfo.getAccessNetworkTechnology(), networkRegistrationInfo2.getAccessNetworkTechnology()));
            if (networkRegistrationInfo.isUsingCarrierAggregation()) {
                networkRegistrationInfo2.setIsUsingCarrierAggregation(true);
            }
            serviceState2.addNetworkRegistrationInfo(networkRegistrationInfo2);
        }
        updateBandwidths(serviceState.getCellBandwidths(), serviceState2);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:25:0x0053, code lost:
        return r2;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isSameRatFamily(android.telephony.ServiceState r7, android.telephony.ServiceState r8) {
        /*
            r6 = this;
            android.util.SparseArray<android.util.SparseIntArray> r0 = r6.mRatFamilyMap
            monitor-enter(r0)
            r1 = 2
            r2 = 1
            android.telephony.NetworkRegistrationInfo r3 = r7.getNetworkRegistrationInfo(r1, r2)     // Catch:{ all -> 0x0054 }
            int r3 = r3.getAccessNetworkTechnology()     // Catch:{ all -> 0x0054 }
            int r3 = android.telephony.ServiceState.networkTypeToRilRadioTechnology(r3)     // Catch:{ all -> 0x0054 }
            android.telephony.NetworkRegistrationInfo r1 = r8.getNetworkRegistrationInfo(r1, r2)     // Catch:{ all -> 0x0054 }
            int r1 = r1.getAccessNetworkTechnology()     // Catch:{ all -> 0x0054 }
            int r1 = android.telephony.ServiceState.networkTypeToRilRadioTechnology(r1)     // Catch:{ all -> 0x0054 }
            r4 = 19
            r5 = 14
            if (r3 != r5) goto L_0x002a
            boolean r7 = r7.isUsingCarrierAggregation()     // Catch:{ all -> 0x0054 }
            if (r7 == 0) goto L_0x002a
            r3 = r4
        L_0x002a:
            if (r1 != r5) goto L_0x0033
            boolean r7 = r8.isUsingCarrierAggregation()     // Catch:{ all -> 0x0054 }
            if (r7 == 0) goto L_0x0033
            r1 = r4
        L_0x0033:
            if (r3 != r1) goto L_0x0037
            monitor-exit(r0)     // Catch:{ all -> 0x0054 }
            return r2
        L_0x0037:
            android.util.SparseArray<android.util.SparseIntArray> r7 = r6.mRatFamilyMap     // Catch:{ all -> 0x0054 }
            java.lang.Object r7 = r7.get(r3)     // Catch:{ all -> 0x0054 }
            r8 = 0
            if (r7 != 0) goto L_0x0042
            monitor-exit(r0)     // Catch:{ all -> 0x0054 }
            return r8
        L_0x0042:
            android.util.SparseArray<android.util.SparseIntArray> r7 = r6.mRatFamilyMap     // Catch:{ all -> 0x0054 }
            java.lang.Object r7 = r7.get(r3)     // Catch:{ all -> 0x0054 }
            android.util.SparseArray<android.util.SparseIntArray> r6 = r6.mRatFamilyMap     // Catch:{ all -> 0x0054 }
            java.lang.Object r6 = r6.get(r1)     // Catch:{ all -> 0x0054 }
            if (r7 != r6) goto L_0x0051
            goto L_0x0052
        L_0x0051:
            r2 = r8
        L_0x0052:
            monitor-exit(r0)     // Catch:{ all -> 0x0054 }
            return r2
        L_0x0054:
            r6 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0054 }
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RatRatcheter.isSameRatFamily(android.telephony.ServiceState, android.telephony.ServiceState):boolean");
    }

    /* access modifiers changed from: private */
    public void resetRatFamilyMap() {
        synchronized (this.mRatFamilyMap) {
            this.mRatFamilyMap.clear();
            CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
            if (carrierConfigManager != null) {
                PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId());
                if (configForSubId != null) {
                    String[] stringArray = configForSubId.getStringArray("ratchet_rat_families");
                    if (stringArray != null) {
                        for (String split : stringArray) {
                            String[] split2 = split.split(",");
                            if (split2.length >= 2) {
                                SparseIntArray sparseIntArray = new SparseIntArray(split2.length);
                                int length = split2.length;
                                int i = 0;
                                int i2 = 0;
                                while (true) {
                                    if (i >= length) {
                                        continue;
                                        break;
                                    }
                                    String str = split2[i];
                                    try {
                                        int parseInt = Integer.parseInt(str.trim());
                                        if (this.mRatFamilyMap.get(parseInt) != null) {
                                            Rlog.e(LOG_TAG, "RAT listed twice: " + str);
                                            break;
                                        }
                                        sparseIntArray.put(parseInt, i2);
                                        this.mRatFamilyMap.put(parseInt, sparseIntArray);
                                        i++;
                                        i2++;
                                    } catch (NumberFormatException unused) {
                                        Rlog.e(LOG_TAG, "NumberFormatException on " + str);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
