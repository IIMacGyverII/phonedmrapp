package com.android.internal.telephony;

import android.app.AppOpsManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.provider.Telephony;
import android.telephony.SmsMessage;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Base64;
import android.util.Log;
import com.android.internal.annotations.GuardedBy;
import java.security.SecureRandom;
import java.util.Iterator;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

public class AppSmsManager {
    private static final String LOG_TAG = "AppSmsManager";
    private static final long TIMEOUT_MILLIS = TimeUnit.MINUTES.toMillis(5);
    private final Context mContext;
    private final Object mLock = new Object();
    @GuardedBy({"mLock"})
    private final Map<String, AppRequestInfo> mPackageMap = new ArrayMap();
    private final SecureRandom mRandom = new SecureRandom();
    @GuardedBy({"mLock"})
    private final Map<String, AppRequestInfo> mTokenMap = new ArrayMap();

    public AppSmsManager(Context context) {
        this.mContext = context;
    }

    public String createAppSpecificSmsToken(String str, PendingIntent pendingIntent) {
        ((AppOpsManager) this.mContext.getSystemService("appops")).checkPackage(Binder.getCallingUid(), str);
        String generateNonce = generateNonce();
        synchronized (this.mLock) {
            if (this.mPackageMap.containsKey(str)) {
                removeRequestLocked(this.mPackageMap.get(str));
            }
            addRequestLocked(new AppRequestInfo(this, str, pendingIntent, generateNonce));
        }
        return generateNonce;
    }

    public String createAppSpecificSmsTokenWithPackageInfo(int i, String str, String str2, PendingIntent pendingIntent) {
        if (!TextUtils.isEmpty(str)) {
            Objects.requireNonNull(pendingIntent, "intent cannot be null");
            ((AppOpsManager) this.mContext.getSystemService("appops")).checkPackage(Binder.getCallingUid(), str);
            String generateToken = PackageBasedTokenUtil.generateToken(this.mContext, str);
            if (generateToken != null) {
                synchronized (this.mLock) {
                    if (this.mPackageMap.containsKey(str)) {
                        removeRequestLocked(this.mPackageMap.get(str));
                    }
                    addRequestLocked(new AppRequestInfo(str, pendingIntent, generateToken, str2, i, true));
                }
            }
            return generateToken;
        }
        throw new IllegalArgumentException("callingPackageName cannot be null or empty.");
    }

    public boolean handleSmsReceivedIntent(Intent intent) {
        if (intent.getAction() != "android.provider.Telephony.SMS_DELIVER") {
            Log.wtf(LOG_TAG, "Got intent with incorrect action: " + intent.getAction());
            return false;
        }
        synchronized (this.mLock) {
            removeExpiredTokenLocked();
            String extractMessage = extractMessage(intent);
            if (TextUtils.isEmpty(extractMessage)) {
                return false;
            }
            AppRequestInfo findAppRequestInfoSmsIntentLocked = findAppRequestInfoSmsIntentLocked(extractMessage);
            if (findAppRequestInfoSmsIntentLocked == null) {
                return false;
            }
            try {
                findAppRequestInfoSmsIntentLocked.pendingIntent.send(this.mContext, 0, new Intent().putExtras(intent.getExtras()).putExtra("android.telephony.extra.STATUS", 0).putExtra("android.telephony.extra.SMS_MESSAGE", extractMessage).putExtra("android.telephony.extra.SIM_SUBSCRIPTION_ID", findAppRequestInfoSmsIntentLocked.subId).addFlags(2097152));
                removeRequestLocked(findAppRequestInfoSmsIntentLocked);
                return true;
            } catch (PendingIntent.CanceledException unused) {
                removeRequestLocked(findAppRequestInfoSmsIntentLocked);
                return false;
            }
        }
    }

    private void removeExpiredTokenLocked() {
        long currentTimeMillis = System.currentTimeMillis();
        Iterator<Map.Entry<String, AppRequestInfo>> it = this.mTokenMap.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry next = it.next();
            AppRequestInfo appRequestInfo = (AppRequestInfo) next.getValue();
            if (appRequestInfo.packageBasedToken && currentTimeMillis - TIMEOUT_MILLIS > appRequestInfo.timestamp) {
                try {
                    appRequestInfo.pendingIntent.send(this.mContext, 0, new Intent().putExtra("android.telephony.extra.STATUS", 1).addFlags(2097152));
                } catch (PendingIntent.CanceledException unused) {
                }
                this.mPackageMap.remove(((AppRequestInfo) next.getValue()).packageName);
                it.remove();
            }
        }
    }

    private String extractMessage(Intent intent) {
        SmsMessage[] messagesFromIntent = Telephony.Sms.Intents.getMessagesFromIntent(intent);
        if (messagesFromIntent == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (SmsMessage smsMessage : messagesFromIntent) {
            if (!(smsMessage == null || smsMessage.getMessageBody() == null)) {
                sb.append(smsMessage.getMessageBody());
            }
        }
        return sb.toString();
    }

    private AppRequestInfo findAppRequestInfoSmsIntentLocked(String str) {
        for (String next : this.mTokenMap.keySet()) {
            if (str.trim().contains(next) && hasPrefix(next, str)) {
                return this.mTokenMap.get(next);
            }
        }
        return null;
    }

    private String generateNonce() {
        byte[] bArr = new byte[8];
        this.mRandom.nextBytes(bArr);
        return Base64.encodeToString(bArr, 11);
    }

    private boolean hasPrefix(String str, String str2) {
        AppRequestInfo appRequestInfo = this.mTokenMap.get(str);
        if (TextUtils.isEmpty(appRequestInfo.prefixes)) {
            return true;
        }
        for (String startsWith : appRequestInfo.prefixes.split(",")) {
            if (str2.startsWith(startsWith)) {
                return true;
            }
        }
        return false;
    }

    private void removeRequestLocked(AppRequestInfo appRequestInfo) {
        this.mTokenMap.remove(appRequestInfo.token);
        this.mPackageMap.remove(appRequestInfo.packageName);
    }

    private void addRequestLocked(AppRequestInfo appRequestInfo) {
        this.mTokenMap.put(appRequestInfo.token, appRequestInfo);
        this.mPackageMap.put(appRequestInfo.packageName, appRequestInfo);
    }

    private final class AppRequestInfo {
        public final boolean packageBasedToken;
        public final String packageName;
        public final PendingIntent pendingIntent;
        public final String prefixes;
        public final int subId;
        public final long timestamp;
        public final String token;

        AppRequestInfo(AppSmsManager appSmsManager, String str, PendingIntent pendingIntent2, String str2) {
            this(str, pendingIntent2, str2, (String) null, -1, false);
        }

        AppRequestInfo(String str, PendingIntent pendingIntent2, String str2, String str3, int i, boolean z) {
            this.packageName = str;
            this.pendingIntent = pendingIntent2;
            this.token = str2;
            this.timestamp = System.currentTimeMillis();
            this.prefixes = str3;
            this.subId = i;
            this.packageBasedToken = z;
        }
    }
}
