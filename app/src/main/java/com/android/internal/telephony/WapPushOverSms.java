package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.os.Bundle;
import android.os.IBinder;
import android.os.PowerWhitelistManager;
import android.os.UserManager;
import android.telephony.SmsManager;
import android.telephony.SubscriptionManager;
import com.android.internal.telephony.IWapPushManager;
import com.android.telephony.Rlog;
import com.google.android.mms.pdu.GenericPdu;
import com.google.android.mms.pdu.NotificationInd;
import com.google.android.mms.pdu.PduParser;
import java.util.HashMap;
import java.util.List;
import kotlin.UByte;

public class WapPushOverSms implements ServiceConnection {
    private static final boolean DBG = false;
    private static final String TAG = "WAP PUSH";
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final Context mContext;
    PowerWhitelistManager mPowerWhitelistManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected volatile IWapPushManager mWapPushManager;
    protected String mWapPushManagerPackage;

    private void bindWapPushManagerService(Context context) {
        Intent intent = new Intent(IWapPushManager.class.getName());
        ComponentName resolveSystemService = resolveSystemService(context.getPackageManager(), intent);
        intent.setComponent(resolveSystemService);
        if (resolveSystemService == null || !context.bindService(intent, this, 1)) {
            Rlog.e(TAG, "bindService() for wappush manager failed");
            return;
        }
        synchronized (this) {
            this.mWapPushManagerPackage = resolveSystemService.getPackageName();
        }
    }

    private static ComponentName resolveSystemService(PackageManager packageManager, Intent intent) {
        List<ResolveInfo> queryIntentServices = packageManager.queryIntentServices(intent, 1048576);
        ComponentName componentName = null;
        if (queryIntentServices == null) {
            return null;
        }
        int i = 0;
        while (i < queryIntentServices.size()) {
            ServiceInfo serviceInfo = queryIntentServices.get(i).serviceInfo;
            ComponentName componentName2 = new ComponentName(serviceInfo.applicationInfo.packageName, serviceInfo.name);
            if (componentName == null) {
                i++;
                componentName = componentName2;
            } else {
                throw new IllegalStateException("Multiple system services handle " + intent + ": " + componentName + ", " + componentName2);
            }
        }
        return componentName;
    }

    public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        this.mWapPushManager = IWapPushManager.Stub.asInterface(iBinder);
    }

    public void onServiceDisconnected(ComponentName componentName) {
        this.mWapPushManager = null;
    }

    public WapPushOverSms(Context context) {
        this.mContext = context;
        this.mPowerWhitelistManager = (PowerWhitelistManager) context.getSystemService(PowerWhitelistManager.class);
        UserManager userManager = (UserManager) context.getSystemService("user");
        bindWapPushManagerService(context);
    }

    public void dispose() {
        if (this.mWapPushManager != null) {
            this.mContext.unbindService(this);
        } else {
            Rlog.e(TAG, "dispose: not bound to a wappush manager");
        }
    }

    private DecodedResult decodeWapPdu(byte[] bArr, InboundSmsHandler inboundSmsHandler) {
        int i;
        byte[] bArr2;
        int i2;
        GenericPdu genericPdu;
        byte[] bArr3 = bArr;
        DecodedResult decodedResult = new DecodedResult();
        try {
            byte b = bArr3[0] & UByte.MAX_VALUE;
            byte b2 = bArr3[1] & UByte.MAX_VALUE;
            int phoneId = inboundSmsHandler.getPhone().getPhoneId();
            if (b2 == 6 || b2 == 7) {
                i = 2;
            } else {
                int integer = this.mContext.getResources().getInteger(17694965);
                if (integer != -1) {
                    int i3 = integer + 1;
                    b = bArr3[integer] & UByte.MAX_VALUE;
                    i = i3 + 1;
                    b2 = bArr3[i3] & UByte.MAX_VALUE;
                    if (!(b2 == 6 || b2 == 7)) {
                        decodedResult.statusCode = 1;
                        return decodedResult;
                    }
                } else {
                    decodedResult.statusCode = 1;
                    return decodedResult;
                }
            }
            WspTypeDecoder makeWspTypeDecoder = TelephonyComponentFactory.getInstance().inject(WspTypeDecoder.class.getName()).makeWspTypeDecoder(bArr3);
            if (!makeWspTypeDecoder.decodeUintvarInteger(i)) {
                decodedResult.statusCode = 2;
                return decodedResult;
            }
            byte b3 = b2;
            int value32 = (int) makeWspTypeDecoder.getValue32();
            int decodedDataLength = i + makeWspTypeDecoder.getDecodedDataLength();
            if (!makeWspTypeDecoder.decodeContentType(decodedDataLength)) {
                decodedResult.statusCode = 2;
                return decodedResult;
            }
            String valueString = makeWspTypeDecoder.getValueString();
            long value322 = makeWspTypeDecoder.getValue32();
            int decodedDataLength2 = decodedDataLength + makeWspTypeDecoder.getDecodedDataLength();
            byte[] bArr4 = new byte[value32];
            System.arraycopy(bArr3, decodedDataLength, bArr4, 0, value32);
            if (valueString == null || !valueString.equals(WspTypeDecoder.CONTENT_TYPE_B_PUSH_CO)) {
                int i4 = decodedDataLength + value32;
                int length = bArr3.length - i4;
                bArr2 = new byte[length];
                System.arraycopy(bArr3, i4, bArr2, 0, length);
            } else {
                bArr2 = bArr3;
            }
            int[] subId = SubscriptionManager.getSubId(phoneId);
            if (subId == null || subId.length <= 0) {
                i2 = SmsManager.getDefaultSmsSubscriptionId();
            } else {
                i2 = subId[0];
            }
            int i5 = i2;
            try {
                genericPdu = new PduParser(bArr2, shouldParseContentDisposition(i5)).parse();
            } catch (Exception e) {
                Rlog.e(TAG, "Unable to parse PDU: " + e.toString());
                genericPdu = null;
            }
            if (genericPdu != null && genericPdu.getMessageType() == 130) {
                NotificationInd notificationInd = (NotificationInd) genericPdu;
                if (notificationInd.getFrom() != null && BlockChecker.isBlocked(this.mContext, notificationInd.getFrom().getString(), (Bundle) null)) {
                    decodedResult.statusCode = 1;
                    return decodedResult;
                }
            }
            if (makeWspTypeDecoder.seekXWapApplicationId(decodedDataLength2, (value32 + decodedDataLength2) - 1)) {
                makeWspTypeDecoder.decodeXWapApplicationId((int) makeWspTypeDecoder.getValue32());
                String valueString2 = makeWspTypeDecoder.getValueString();
                if (valueString2 == null) {
                    valueString2 = Integer.toString((int) makeWspTypeDecoder.getValue32());
                }
                decodedResult.wapAppId = valueString2;
                decodedResult.contentType = valueString == null ? Long.toString(value322) : valueString;
            }
            decodedResult.subId = i5;
            decodedResult.phoneId = phoneId;
            decodedResult.parsedPdu = genericPdu;
            decodedResult.mimeType = valueString;
            decodedResult.transactionId = b;
            decodedResult.pduType = b3;
            decodedResult.header = bArr4;
            decodedResult.intentData = bArr2;
            decodedResult.contentTypeParameters = makeWspTypeDecoder.getContentParameters();
            decodedResult.statusCode = -1;
            return decodedResult;
        } catch (ArrayIndexOutOfBoundsException e2) {
            Rlog.e(TAG, "ignoring dispatchWapPdu() array index exception: " + e2);
            decodedResult.statusCode = 2;
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:25:0x007c A[RETURN] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int dispatchWapPdu(byte[] r19, com.android.internal.telephony.InboundSmsHandler.SmsBroadcastReceiver r20, com.android.internal.telephony.InboundSmsHandler r21, java.lang.String r22, int r23, long r24) {
        /*
            r18 = this;
            r1 = r18
            r2 = r22
            r0 = r19
            r3 = r21
            r4 = r24
            com.android.internal.telephony.WapPushOverSms$DecodedResult r6 = r1.decodeWapPdu(r0, r3)
            int r0 = r6.statusCode
            r8 = -1
            if (r0 == r8) goto L_0x0014
            return r0
        L_0x0014:
            java.lang.String r0 = r6.wapAppId
            r7 = 315(0x13b, float:4.41E-43)
            r9 = 2
            r10 = 1
            if (r0 == 0) goto L_0x0080
            com.android.internal.telephony.IWapPushManager r0 = r1.mWapPushManager     // Catch:{ RemoteException -> 0x0080 }
            if (r0 != 0) goto L_0x0021
            goto L_0x0079
        L_0x0021:
            monitor-enter(r18)     // Catch:{ RemoteException -> 0x0080 }
            android.os.PowerWhitelistManager r11 = r1.mPowerWhitelistManager     // Catch:{ all -> 0x007d }
            java.lang.String r12 = r1.mWapPushManagerPackage     // Catch:{ all -> 0x007d }
            java.lang.String r13 = "mms-mgr"
            r11.whitelistAppTemporarilyForEvent(r12, r9, r7, r13)     // Catch:{ all -> 0x007d }
            monitor-exit(r18)     // Catch:{ all -> 0x007d }
            android.content.Intent r11 = new android.content.Intent     // Catch:{ RemoteException -> 0x0080 }
            r11.<init>()     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r12 = "transactionId"
            int r13 = r6.transactionId     // Catch:{ RemoteException -> 0x0080 }
            r11.putExtra(r12, r13)     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r12 = "pduType"
            int r13 = r6.pduType     // Catch:{ RemoteException -> 0x0080 }
            r11.putExtra(r12, r13)     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r12 = "header"
            byte[] r13 = r6.header     // Catch:{ RemoteException -> 0x0080 }
            r11.putExtra(r12, r13)     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r12 = "data"
            byte[] r13 = r6.intentData     // Catch:{ RemoteException -> 0x0080 }
            r11.putExtra(r12, r13)     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r12 = "contentTypeParameters"
            java.util.HashMap<java.lang.String, java.lang.String> r13 = r6.contentTypeParameters     // Catch:{ RemoteException -> 0x0080 }
            r11.putExtra(r12, r13)     // Catch:{ RemoteException -> 0x0080 }
            int r12 = r6.phoneId     // Catch:{ RemoteException -> 0x0080 }
            android.telephony.SubscriptionManager.putPhoneIdAndSubIdExtra(r11, r12)     // Catch:{ RemoteException -> 0x0080 }
            boolean r12 = android.text.TextUtils.isEmpty(r22)     // Catch:{ RemoteException -> 0x0080 }
            if (r12 != 0) goto L_0x0065
            java.lang.String r12 = "address"
            r11.putExtra(r12, r2)     // Catch:{ RemoteException -> 0x0080 }
        L_0x0065:
            java.lang.String r12 = r6.wapAppId     // Catch:{ RemoteException -> 0x0080 }
            java.lang.String r13 = r6.contentType     // Catch:{ RemoteException -> 0x0080 }
            int r0 = r0.processMessage(r12, r13, r11)     // Catch:{ RemoteException -> 0x0080 }
            r11 = r0 & 1
            if (r11 <= 0) goto L_0x0079
            r11 = 32768(0x8000, float:4.5918E-41)
            r0 = r0 & r11
            if (r0 != 0) goto L_0x0079
            r0 = 0
            goto L_0x007a
        L_0x0079:
            r0 = r10
        L_0x007a:
            if (r0 != 0) goto L_0x0080
            return r10
        L_0x007d:
            r0 = move-exception
            monitor-exit(r18)     // Catch:{ all -> 0x007d }
            throw r0     // Catch:{ RemoteException -> 0x0080 }
        L_0x0080:
            java.lang.String r0 = r6.mimeType
            if (r0 != 0) goto L_0x0085
            return r9
        L_0x0085:
            android.content.Intent r11 = new android.content.Intent
            java.lang.String r0 = "android.provider.Telephony.WAP_PUSH_DELIVER"
            r11.<init>(r0)
            java.lang.String r0 = r6.mimeType
            r11.setType(r0)
            java.lang.String r0 = "transactionId"
            int r12 = r6.transactionId
            r11.putExtra(r0, r12)
            java.lang.String r0 = "pduType"
            int r12 = r6.pduType
            r11.putExtra(r0, r12)
            java.lang.String r0 = "header"
            byte[] r12 = r6.header
            r11.putExtra(r0, r12)
            java.lang.String r0 = "data"
            byte[] r12 = r6.intentData
            r11.putExtra(r0, r12)
            java.lang.String r0 = "contentTypeParameters"
            java.util.HashMap<java.lang.String, java.lang.String> r12 = r6.contentTypeParameters
            r11.putExtra(r0, r12)
            boolean r0 = android.text.TextUtils.isEmpty(r22)
            if (r0 != 0) goto L_0x00c0
            java.lang.String r0 = "address"
            r11.putExtra(r0, r2)
        L_0x00c0:
            r12 = 0
            int r0 = (r4 > r12 ? 1 : (r4 == r12 ? 0 : -1))
            if (r0 == 0) goto L_0x00cb
            java.lang.String r0 = "messageId"
            r11.putExtra(r0, r4)
        L_0x00cb:
            android.content.Context r0 = r1.mContext
            android.content.ComponentName r0 = com.android.internal.telephony.SmsApplication.getDefaultMmsApplication(r0, r10)
            r2 = 0
            if (r0 == 0) goto L_0x00f6
            r11.setComponent(r0)
            android.os.PowerWhitelistManager r1 = r1.mPowerWhitelistManager
            java.lang.String r0 = r0.getPackageName()
            java.lang.String r2 = "mms-app"
            long r13 = r1.whitelistAppTemporarilyForEvent(r0, r9, r7, r2)
            android.app.BroadcastOptions r0 = android.app.BroadcastOptions.makeBasic()
            r15 = 0
            r16 = 315(0x13b, float:4.41E-43)
            java.lang.String r17 = ""
            r12 = r0
            r12.setTemporaryAppAllowlist(r13, r15, r16, r17)
            android.os.Bundle r0 = r0.toBundle()
            r4 = r0
            goto L_0x00f7
        L_0x00f6:
            r4 = r2
        L_0x00f7:
            java.lang.String r0 = r6.mimeType
            java.lang.String r2 = getPermissionForType(r0)
            java.lang.String r0 = r6.mimeType
            java.lang.String r5 = getAppOpsStringPermissionForIntent(r0)
            android.os.UserHandle r6 = android.os.UserHandle.SYSTEM
            r0 = r21
            r1 = r11
            r3 = r5
            r5 = r20
            r7 = r23
            r0.dispatchIntent(r1, r2, r3, r4, r5, r6, r7)
            return r8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.WapPushOverSms.dispatchWapPdu(byte[], com.android.internal.telephony.InboundSmsHandler$SmsBroadcastReceiver, com.android.internal.telephony.InboundSmsHandler, java.lang.String, int, long):int");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isWapPushForMms(byte[] bArr, InboundSmsHandler inboundSmsHandler) {
        DecodedResult decodeWapPdu = decodeWapPdu(bArr, inboundSmsHandler);
        return decodeWapPdu.statusCode == -1 && WspTypeDecoder.CONTENT_TYPE_B_MMS.equals(decodeWapPdu.mimeType);
    }

    protected static boolean shouldParseContentDisposition(int i) {
        return SmsManager.getSmsManagerForSubscriptionId(i).getCarrierConfigValues().getBoolean("supportMmsContentDisposition", true);
    }

    public static String getPermissionForType(String str) {
        return WspTypeDecoder.CONTENT_TYPE_B_MMS.equals(str) ? "android.permission.RECEIVE_MMS" : "android.permission.RECEIVE_WAP_PUSH";
    }

    public static String getAppOpsStringPermissionForIntent(String str) {
        return WspTypeDecoder.CONTENT_TYPE_B_MMS.equals(str) ? "android:receive_mms" : "android:receive_wap_push";
    }

    private final class DecodedResult {
        String contentType;
        HashMap<String, String> contentTypeParameters;
        byte[] header;
        byte[] intentData;
        String mimeType;
        GenericPdu parsedPdu;
        int pduType;
        int phoneId;
        int statusCode;
        int subId;
        int transactionId;
        String wapAppId;

        private DecodedResult() {
        }
    }
}
