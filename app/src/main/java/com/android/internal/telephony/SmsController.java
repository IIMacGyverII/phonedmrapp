package com.android.internal.telephony;

import android.app.ActivityManager;
import android.app.AppOpsManager;
import android.app.PendingIntent;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.net.Uri;
import android.os.BaseBundle;
import android.os.Binder;
import android.os.Bundle;
import android.os.TelephonyServiceManager;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyFrameworkInitializer;
import android.telephony.TelephonyManager;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class SmsController extends ISmsImplBase {
    static final String LOG_TAG = "SmsController";
    private final Context mContext;

    /* JADX WARNING: type inference failed for: r1v0, types: [com.android.internal.telephony.SmsController, android.os.IBinder] */
    protected SmsController(Context context) {
        this.mContext = context;
        TelephonyServiceManager.ServiceRegisterer smsServiceRegisterer = TelephonyFrameworkInitializer.getTelephonyServiceManager().getSmsServiceRegisterer();
        if (smsServiceRegisterer.get() == null) {
            smsServiceRegisterer.register(this);
        }
    }

    private Phone getPhone(int i) {
        Phone phone = PhoneFactory.getPhone(SubscriptionManager.getPhoneId(i));
        return phone == null ? PhoneFactory.getDefaultPhone() : phone;
    }

    private SmsPermissions getSmsPermissions(int i) {
        Phone phone = getPhone(i);
        Context context = this.mContext;
        return new SmsPermissions(phone, context, (AppOpsManager) context.getSystemService("appops"));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean updateMessageOnIccEfForSubscriber(int i, String str, int i2, int i3, byte[] bArr) {
        if (str == null) {
            str = getCallingPackage();
        }
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.updateMessageOnIccEf(str, i2, i3, bArr);
        }
        Rlog.e(LOG_TAG, "updateMessageOnIccEfForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean copyMessageToIccEfForSubscriber(int i, String str, int i2, byte[] bArr, byte[] bArr2) {
        if (str == null) {
            str = getCallingPackage();
        }
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.copyMessageToIccEf(str, i2, bArr, bArr2);
        }
        Rlog.e(LOG_TAG, "copyMessageToIccEfForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<SmsRawData> getAllMessagesFromIccEfForSubscriber(int i, String str) {
        if (str == null) {
            str = getCallingPackage();
        }
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.getAllMessagesFromIccEf(str);
        }
        Rlog.e(LOG_TAG, "getAllMessagesFromIccEfForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public void sendDataForSubscriber(int i, String str, String str2, String str3, int i2, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        sendDataForSubscriber(i, str, (String) null, str2, str3, i2, bArr, pendingIntent, pendingIntent2);
    }

    public void sendDataForSubscriber(int i, String str, String str2, String str3, String str4, int i2, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        String callingPackage = str == null ? getCallingPackage() : str;
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendData(callingPackage, str2, str3, str4, i2, bArr, pendingIntent, pendingIntent2);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("sendDataForSubscriber iccSmsIntMgr is null for Subscription: ");
        int i3 = i;
        sb.append(i);
        Rlog.e(LOG_TAG, sb.toString());
        sendErrorInPendingIntent(pendingIntent, 1);
    }

    private void sendDataForSubscriberWithSelfPermissionsInternal(int i, String str, String str2, String str3, String str4, int i2, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendDataWithSelfPermissions(str, str2, str3, str4, i2, bArr, pendingIntent, pendingIntent2, z);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("sendText iccSmsIntMgr is null for Subscription: ");
        int i3 = i;
        sb.append(i);
        Rlog.e(LOG_TAG, sb.toString());
        sendErrorInPendingIntent(pendingIntent, 1);
    }

    private String getCallingPackage() {
        return this.mContext.getPackageManager().getPackagesForUid(Binder.getCallingUid())[0];
    }

    public void sendTextForSubscriber(int i, String str, String str2, String str3, String str4, String str5, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, long j) {
        String callingPackage = str == null ? getCallingPackage() : str;
        String str6 = str2;
        if (!getSmsPermissions(i).checkCallingCanSendText(z, callingPackage, str2, "Sending SMS message")) {
            sendErrorInPendingIntent(pendingIntent, 1);
            return;
        }
        PendingIntent pendingIntent3 = pendingIntent;
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            SubscriptionInfo subscriptionInfo = getSubscriptionInfo(i);
            Binder.restoreCallingIdentity(clearCallingIdentity);
            if (isBluetoothSubscription(subscriptionInfo)) {
                sendBluetoothText(subscriptionInfo, str3, str5, pendingIntent, pendingIntent2);
            } else {
                sendIccText(i, callingPackage, str3, str4, str5, pendingIntent, pendingIntent2, z, j);
            }
        } catch (Throwable th) {
            Throwable th2 = th;
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th2;
        }
    }

    private boolean isBluetoothSubscription(SubscriptionInfo subscriptionInfo) {
        return subscriptionInfo != null && subscriptionInfo.getSubscriptionType() == 1;
    }

    private void sendBluetoothText(SubscriptionInfo subscriptionInfo, String str, String str2, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        new BtSmsInterfaceManager().sendText(this.mContext, str, str2, pendingIntent, pendingIntent2, subscriptionInfo);
    }

    private void sendIccText(int i, String str, String str2, String str3, String str4, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, long j) {
        int i2 = i;
        long j2 = j;
        Rlog.d(LOG_TAG, "sendTextForSubscriber iccSmsIntMgr Subscription: " + i + " id: " + j2);
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendText(str, str2, str3, str4, pendingIntent, pendingIntent2, z, j);
            return;
        }
        Rlog.e(LOG_TAG, "sendTextForSubscriber iccSmsIntMgr is null for Subscription: " + i + " id: " + j2);
        sendErrorInPendingIntent(pendingIntent, 1);
    }

    private void sendTextForSubscriberWithSelfPermissionsInternal(int i, String str, String str2, String str3, String str4, String str5, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, boolean z2) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendTextWithSelfPermissions(str, str2, str3, str4, str5, pendingIntent, pendingIntent2, z, z2);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("sendText iccSmsIntMgr is null for Subscription: ");
        int i2 = i;
        sb.append(i);
        Rlog.e(LOG_TAG, sb.toString());
        sendErrorInPendingIntent(pendingIntent, 1);
    }

    public void sendTextForSubscriberWithOptions(int i, String str, String str2, String str3, String str4, String str5, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, int i2, boolean z2, int i3) {
        String callingPackage = str == null ? getCallingPackage() : str;
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendTextWithOptions(callingPackage, str2, str3, str4, str5, pendingIntent, pendingIntent2, z, i2, z2, i3);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("sendTextWithOptions iccSmsIntMgr is null for Subscription: ");
        int i4 = i;
        sb.append(i);
        Rlog.e(LOG_TAG, sb.toString());
        sendErrorInPendingIntent(pendingIntent, 1);
    }

    public void sendMultipartTextForSubscriber(int i, String str, String str2, String str3, String str4, List<String> list, List<PendingIntent> list2, List<PendingIntent> list3, boolean z, long j) {
        String callingPackage = getCallingPackage() != null ? getCallingPackage() : str;
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendMultipartText(callingPackage, str2, str3, str4, list, list2, list3, z, j);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("sendMultipartTextForSubscriber iccSmsIntMgr is null for Subscription: ");
        int i2 = i;
        sb.append(i);
        sb.append(" id: ");
        sb.append(j);
        Rlog.e(LOG_TAG, sb.toString());
        sendErrorInPendingIntents(list2, 1);
    }

    public void sendMultipartTextForSubscriberWithOptions(int i, String str, String str2, String str3, String str4, List<String> list, List<PendingIntent> list2, List<PendingIntent> list3, boolean z, int i2, boolean z2, int i3) {
        String callingPackage = str == null ? getCallingPackage() : str;
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendMultipartTextWithOptions(callingPackage, str2, str3, str4, list, list2, list3, z, i2, z2, i3, 0);
            return;
        }
        Rlog.e(LOG_TAG, "sendMultipartTextWithOptions iccSmsIntMgr is null for Subscription: " + i);
        sendErrorInPendingIntents(list2, 1);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean enableCellBroadcastForSubscriber(int i, int i2, int i3) {
        return enableCellBroadcastRangeForSubscriber(i, i2, i2, i3);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean enableCellBroadcastRangeForSubscriber(int i, int i2, int i3, int i4) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.enableCellBroadcastRange(i2, i3, i4);
        }
        Rlog.e(LOG_TAG, "enableCellBroadcastRangeForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean disableCellBroadcastForSubscriber(int i, int i2, int i3) {
        return disableCellBroadcastRangeForSubscriber(i, i2, i2, i3);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean disableCellBroadcastRangeForSubscriber(int i, int i2, int i3, int i4) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.disableCellBroadcastRange(i2, i3, i4);
        }
        Rlog.e(LOG_TAG, "disableCellBroadcastRangeForSubscriber iccSmsIntMgr is null for Subscription:" + i);
        return false;
    }

    public int getPremiumSmsPermission(String str) {
        return getPremiumSmsPermissionForSubscriber(getPreferredSmsSubscription(), str);
    }

    public int getPremiumSmsPermissionForSubscriber(int i, String str) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.getPremiumSmsPermission(str);
        }
        Rlog.e(LOG_TAG, "getPremiumSmsPermissionForSubscriber iccSmsIntMgr is null");
        return 0;
    }

    public void setPremiumSmsPermission(String str, int i) {
        setPremiumSmsPermissionForSubscriber(getPreferredSmsSubscription(), str, i);
    }

    public void setPremiumSmsPermissionForSubscriber(int i, String str, int i2) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.setPremiumSmsPermission(str, i2);
        } else {
            Rlog.e(LOG_TAG, "setPremiumSmsPermissionForSubscriber iccSmsIntMgr is null");
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isImsSmsSupportedForSubscriber(int i) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.isImsSmsSupported();
        }
        Rlog.e(LOG_TAG, "isImsSmsSupportedForSubscriber iccSmsIntMgr is null");
        return false;
    }

    public boolean isSmsSimPickActivityNeeded(int i) {
        Context applicationContext = this.mContext.getApplicationContext();
        ActivityManager activityManager = (ActivityManager) applicationContext.getSystemService(ActivityManager.class);
        if (!(activityManager != null && activityManager.getUidImportance(Binder.getCallingUid()) == 100)) {
            Rlog.d(LOG_TAG, "isSmsSimPickActivityNeeded: calling process not foreground. Suppressing activity.");
            return false;
        }
        TelephonyManager telephonyManager = (TelephonyManager) applicationContext.getSystemService("phone");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<SubscriptionInfo> activeSubscriptionInfoList = SubscriptionManager.from(applicationContext).getActiveSubscriptionInfoList();
            if (activeSubscriptionInfoList != null) {
                int size = activeSubscriptionInfoList.size();
                for (int i2 = 0; i2 < size; i2++) {
                    SubscriptionInfo subscriptionInfo = activeSubscriptionInfoList.get(i2);
                    if (subscriptionInfo != null && subscriptionInfo.getSubscriptionId() == i) {
                        return false;
                    }
                }
                return size > 1 && telephonyManager.getSimCount() > 1;
            }
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getImsSmsFormatForSubscriber(int i) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.getImsSmsFormat();
        }
        Rlog.e(LOG_TAG, "getImsSmsFormatForSubscriber iccSmsIntMgr is null");
        return null;
    }

    public void injectSmsPduForSubscriber(int i, byte[] bArr, String str, PendingIntent pendingIntent) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.injectSmsPdu(bArr, str, pendingIntent);
            return;
        }
        Rlog.e(LOG_TAG, "injectSmsPduForSubscriber iccSmsIntMgr is null");
        sendErrorInPendingIntent(pendingIntent, 2);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPreferredSmsSubscription() {
        int defaultSmsSubId = SubscriptionController.getInstance().getDefaultSmsSubId();
        if (SubscriptionManager.isValidSubscriptionId(defaultSmsSubId)) {
            return defaultSmsSubId;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            int[] activeSubIdList = SubscriptionController.getInstance().getActiveSubIdList(true);
            if (activeSubIdList.length == 1) {
                return activeSubIdList[0];
            }
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return -1;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public boolean isSMSPromptEnabled() {
        return PhoneFactory.isSMSPromptEnabled();
    }

    public void sendStoredText(int i, String str, String str2, Uri uri, String str3, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (!getCallingPackage().equals(str)) {
            throw new SecurityException("sendStoredText: Package " + str + "does not belong to " + Binder.getCallingUid());
        } else if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendStoredText(str, str2, uri, str3, pendingIntent, pendingIntent2);
        } else {
            Rlog.e(LOG_TAG, "sendStoredText iccSmsIntMgr is null for subscription: " + i);
            sendErrorInPendingIntent(pendingIntent, 1);
        }
    }

    public void sendStoredMultipartText(int i, String str, String str2, Uri uri, String str3, List<PendingIntent> list, List<PendingIntent> list2) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (!getCallingPackage().equals(str)) {
            throw new SecurityException("sendStoredMultipartText: Package " + str + " does not belong to " + Binder.getCallingUid());
        } else if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.sendStoredMultipartText(str, str2, uri, str3, list, list2);
        } else {
            Rlog.e(LOG_TAG, "sendStoredMultipartText iccSmsIntMgr is null for subscription: " + i);
            sendErrorInPendingIntents(list, 1);
        }
    }

    public Bundle getCarrierConfigValuesForSubscriber(int i) {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return getMmsConfig(((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(i));
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    private static Bundle getMmsConfig(BaseBundle baseBundle) {
        Bundle bundle = new Bundle();
        bundle.putBoolean("enabledTransID", baseBundle.getBoolean("enabledTransID"));
        bundle.putBoolean("enabledMMS", baseBundle.getBoolean("enabledMMS"));
        bundle.putBoolean("enableGroupMms", baseBundle.getBoolean("enableGroupMms"));
        bundle.putBoolean("enabledNotifyWapMMSC", baseBundle.getBoolean("enabledNotifyWapMMSC"));
        bundle.putBoolean("aliasEnabled", baseBundle.getBoolean("aliasEnabled"));
        bundle.putBoolean("allowAttachAudio", baseBundle.getBoolean("allowAttachAudio"));
        bundle.putBoolean("enableMultipartSMS", baseBundle.getBoolean("enableMultipartSMS"));
        bundle.putBoolean("enableSMSDeliveryReports", baseBundle.getBoolean("enableSMSDeliveryReports"));
        bundle.putBoolean("supportMmsContentDisposition", baseBundle.getBoolean("supportMmsContentDisposition"));
        bundle.putBoolean("sendMultipartSmsAsSeparateMessages", baseBundle.getBoolean("sendMultipartSmsAsSeparateMessages"));
        bundle.putBoolean("enableMMSReadReports", baseBundle.getBoolean("enableMMSReadReports"));
        bundle.putBoolean("enableMMSDeliveryReports", baseBundle.getBoolean("enableMMSDeliveryReports"));
        bundle.putBoolean("mmsCloseConnection", baseBundle.getBoolean("mmsCloseConnection"));
        bundle.putInt("maxMessageSize", baseBundle.getInt("maxMessageSize"));
        bundle.putInt("maxImageWidth", baseBundle.getInt("maxImageWidth"));
        bundle.putInt("maxImageHeight", baseBundle.getInt("maxImageHeight"));
        bundle.putInt("recipientLimit", baseBundle.getInt("recipientLimit"));
        bundle.putInt("aliasMinChars", baseBundle.getInt("aliasMinChars"));
        bundle.putInt("aliasMaxChars", baseBundle.getInt("aliasMaxChars"));
        bundle.putInt("smsToMmsTextThreshold", baseBundle.getInt("smsToMmsTextThreshold"));
        bundle.putInt("smsToMmsTextLengthThreshold", baseBundle.getInt("smsToMmsTextLengthThreshold"));
        bundle.putInt("maxMessageTextSize", baseBundle.getInt("maxMessageTextSize"));
        bundle.putInt("maxSubjectLength", baseBundle.getInt("maxSubjectLength"));
        bundle.putInt("httpSocketTimeout", baseBundle.getInt("httpSocketTimeout"));
        bundle.putString("uaProfTagName", baseBundle.getString("uaProfTagName"));
        bundle.putString("userAgent", baseBundle.getString("userAgent"));
        bundle.putString("uaProfUrl", baseBundle.getString("uaProfUrl"));
        bundle.putString("httpParams", baseBundle.getString("httpParams"));
        bundle.putString("emailGatewayNumber", baseBundle.getString("emailGatewayNumber"));
        bundle.putString("naiSuffix", baseBundle.getString("naiSuffix"));
        bundle.putBoolean("config_cellBroadcastAppLinks", baseBundle.getBoolean("config_cellBroadcastAppLinks"));
        bundle.putBoolean("supportHttpCharsetHeader", baseBundle.getBoolean("supportHttpCharsetHeader"));
        return bundle;
    }

    public String createAppSpecificSmsTokenWithPackageInfo(int i, String str, String str2, PendingIntent pendingIntent) {
        if (str == null) {
            str = getCallingPackage();
        }
        return getPhone(i).getAppSmsManager().createAppSpecificSmsTokenWithPackageInfo(i, str, str2, pendingIntent);
    }

    public String createAppSpecificSmsToken(int i, String str, PendingIntent pendingIntent) {
        if (str == null) {
            str = getCallingPackage();
        }
        return getPhone(i).getAppSmsManager().createAppSpecificSmsToken(str, pendingIntent);
    }

    public int checkSmsShortCodeDestination(int i, String str, String str2, String str3, String str4) {
        if (str == null) {
            str = getCallingPackage();
        }
        if (!TelephonyPermissions.checkCallingOrSelfReadPhoneState(getPhone(i).getContext(), i, str, str2, "checkSmsShortCodeDestination")) {
            return 0;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return getPhone(i).mSmsUsageMonitor.checkDestination(str3, str4);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void sendVisualVoicemailSmsForSubscriber(String str, String str2, int i, String str3, int i2, String str4, PendingIntent pendingIntent) {
        int i3 = i2;
        if (i3 == 0) {
            sendTextForSubscriberWithSelfPermissionsInternal(i, str, str2, str3, (String) null, str4, pendingIntent, (PendingIntent) null, false, true);
            return;
        }
        byte[] bytes = str4.getBytes(StandardCharsets.UTF_8);
        sendDataForSubscriberWithSelfPermissionsInternal(i, str, str2, str3, (String) null, (short) i3, bytes, pendingIntent, (PendingIntent) null, true);
    }

    public String getSmscAddressFromIccEfForSubscriber(int i, String str) {
        if (str == null) {
            str = getCallingPackage();
        }
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.getSmscAddressFromIccEf(str);
        }
        Rlog.e(LOG_TAG, "getSmscAddressFromIccEfForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return null;
    }

    public boolean setSmscAddressOnIccEfForSubscriber(String str, int i, String str2) {
        if (str2 == null) {
            str2 = getCallingPackage();
        }
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.setSmscAddressOnIccEf(str2, str);
        }
        Rlog.e(LOG_TAG, "setSmscAddressOnIccEfForSubscriber iccSmsIntMgr is null for Subscription: " + i);
        return false;
    }

    /* access modifiers changed from: protected */
    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        if (TelephonyUtils.checkDumpPermission(this.mContext, LOG_TAG, printWriter)) {
            IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "    ");
            for (Phone subId : PhoneFactory.getPhones()) {
                int subId2 = subId.getSubId();
                indentingPrintWriter.println(String.format("SmsManager for subId = %d:", new Object[]{Integer.valueOf(subId2)}));
                indentingPrintWriter.increaseIndent();
                if (getIccSmsInterfaceManager(subId2) != null) {
                    getIccSmsInterfaceManager(subId2).dump(fileDescriptor, indentingPrintWriter, strArr);
                }
                indentingPrintWriter.decreaseIndent();
            }
            indentingPrintWriter.flush();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void sendErrorInPendingIntent(PendingIntent pendingIntent, int i) {
        if (pendingIntent != null) {
            try {
                pendingIntent.send(i);
            } catch (PendingIntent.CanceledException unused) {
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void sendErrorInPendingIntents(List<PendingIntent> list, int i) {
        if (list != null) {
            for (PendingIntent sendErrorInPendingIntent : list) {
                sendErrorInPendingIntent(sendErrorInPendingIntent, i);
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private IccSmsInterfaceManager getIccSmsInterfaceManager(int i) {
        return getPhone(i).getIccSmsInterfaceManager();
    }

    private SubscriptionInfo getSubscriptionInfo(int i) {
        return ((SubscriptionManager) this.mContext.getSystemService("telephony_subscription_service")).getActiveSubscriptionInfo(i);
    }

    public int getSmsCapacityOnIccForSubscriber(int i) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            return iccSmsInterfaceManager.getSmsCapacityOnIcc(getCallingPackage(), (String) null);
        }
        Rlog.e(LOG_TAG, "iccSmsIntMgr is null for  subId: " + i);
        return 0;
    }

    public boolean resetAllCellBroadcastRanges(int i) {
        IccSmsInterfaceManager iccSmsInterfaceManager = getIccSmsInterfaceManager(i);
        if (iccSmsInterfaceManager != null) {
            iccSmsInterfaceManager.resetAllCellBroadcastRanges();
            return true;
        }
        Rlog.e(LOG_TAG, "iccSmsIntMgr is null for  subId: " + i);
        return false;
    }

    public static String formatCrossStackMessageId(long j) {
        return "{x-message-id:" + j + "}";
    }
}
