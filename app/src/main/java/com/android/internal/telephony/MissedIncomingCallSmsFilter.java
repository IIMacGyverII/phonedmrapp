package com.android.internal.telephony;

import android.content.ComponentName;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.telephony.CarrierConfigManager;
import android.telephony.SmsMessage;
import android.text.TextUtils;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

public class MissedIncomingCallSmsFilter {
    private static final ComponentName PSTN_CONNECTION_SERVICE_COMPONENT = new ComponentName("com.android.phone", "com.android.services.telephony.TelephonyConnectionService");
    private static final String SMS_CALLER_ID_TAG = "callerId";
    private static final String SMS_DAY_TAG = "day";
    private static final String SMS_HOUR_TAG = "hour";
    private static final String SMS_MINUTE_TAG = "minute";
    private static final String SMS_MONTH_TAG = "month";
    private static final String SMS_YEAR_TAG = "year";
    private static final String TAG = "MissedIncomingCallSmsFilter";
    private static final boolean VDBG = false;
    private PersistableBundle mCarrierConfig;
    private final Phone mPhone;

    public MissedIncomingCallSmsFilter(Phone phone) {
        this.mPhone = phone;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) phone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager != null) {
            this.mCarrierConfig = carrierConfigManager.getConfigForSubId(phone.getSubId());
        }
    }

    public boolean filter(byte[][] bArr, String str) {
        PersistableBundle persistableBundle;
        String[] stringArray;
        SmsMessage createFromPdu;
        if (bArr.length == 1 && (persistableBundle = this.mCarrierConfig) != null && (stringArray = persistableBundle.getStringArray("missed_incoming_call_sms_originator_string_array")) != null && (createFromPdu = SmsMessage.createFromPdu(bArr[0], str)) != null && !TextUtils.isEmpty(createFromPdu.getOriginatingAddress()) && Arrays.asList(stringArray).contains(createFromPdu.getOriginatingAddress())) {
            return processSms(createFromPdu);
        }
        return false;
    }

    private long getEpochTime(String str, String str2, String str3, String str4, String str5) {
        LocalDateTime parse;
        LocalDateTime now = LocalDateTime.now();
        if (TextUtils.isEmpty(str)) {
            str = Integer.toString(now.getYear());
        }
        do {
            DateTimeFormatter ofPattern = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
            parse = LocalDateTime.parse(str + str2 + str3 + str4 + str5, ofPattern);
            str = Integer.toString(Integer.parseInt(str) + -1);
        } while (parse.isAfter(now));
        return parse.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
    }

    /* JADX WARNING: Removed duplicated region for block: B:41:0x0068  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean processSms(android.telephony.SmsMessage r15) {
        /*
            r14 = this;
            android.os.PersistableBundle r0 = r14.mCarrierConfig
            java.lang.String r1 = "missed_incoming_call_sms_pattern_string_array"
            java.lang.String[] r0 = r0.getStringArray(r1)
            r1 = 0
            if (r0 == 0) goto L_0x00c2
            int r2 = r0.length
            if (r2 != 0) goto L_0x0010
            goto L_0x00c2
        L_0x0010:
            int r2 = r0.length
            r3 = r1
        L_0x0012:
            if (r3 >= r2) goto L_0x00ba
            r4 = r0[r3]
            r5 = 33
            java.util.regex.Pattern r4 = java.util.regex.Pattern.compile(r4, r5)     // Catch:{ PatternSyntaxException -> 0x0097 }
            java.lang.String r5 = r15.getMessageBody()
            java.util.regex.Matcher r4 = r4.matcher(r5)
            boolean r5 = r4.find()
            if (r5 == 0) goto L_0x00b6
            r0 = 0
            r15 = 0
            java.lang.String r2 = "month"
            java.lang.String r2 = r4.group(r2)     // Catch:{ IllegalArgumentException -> 0x004f }
            java.lang.String r3 = "day"
            java.lang.String r3 = r4.group(r3)     // Catch:{ IllegalArgumentException -> 0x004d }
            java.lang.String r5 = "hour"
            java.lang.String r5 = r4.group(r5)     // Catch:{ IllegalArgumentException -> 0x004b }
            java.lang.String r6 = "minute"
            java.lang.String r6 = r4.group(r6)     // Catch:{ IllegalArgumentException -> 0x0052 }
            r10 = r2
            r11 = r3
            r12 = r5
            r13 = r6
            r6 = r0
            goto L_0x005a
        L_0x004b:
            r5 = r15
            goto L_0x0052
        L_0x004d:
            r3 = r15
            goto L_0x0051
        L_0x004f:
            r2 = r15
            r3 = r2
        L_0x0051:
            r5 = r3
        L_0x0052:
            long r6 = java.lang.System.currentTimeMillis()
            r13 = r15
            r10 = r2
            r11 = r3
            r12 = r5
        L_0x005a:
            java.lang.String r2 = "year"
            java.lang.String r2 = r4.group(r2)     // Catch:{ IllegalArgumentException -> 0x0063 }
            r9 = r2
            goto L_0x0064
        L_0x0063:
            r9 = r15
        L_0x0064:
            int r2 = (r6 > r0 ? 1 : (r6 == r0 ? 0 : -1))
            if (r2 != 0) goto L_0x0084
            r8 = r14
            long r6 = r8.getEpochTime(r9, r10, r11, r12, r13)     // Catch:{ Exception -> 0x007d }
            int r0 = (r6 > r0 ? 1 : (r6 == r0 ? 0 : -1))
            if (r0 != 0) goto L_0x0084
            java.lang.String r0 = TAG     // Catch:{ Exception -> 0x007d }
            java.lang.String r1 = "Can't get the time. Use the current time."
            android.telephony.Rlog.e(r0, r1)     // Catch:{ Exception -> 0x007d }
            long r6 = java.lang.System.currentTimeMillis()     // Catch:{ Exception -> 0x007d }
            goto L_0x0084
        L_0x007d:
            java.lang.String r0 = TAG
            java.lang.String r1 = "Can't get the time for missed incoming call"
            android.telephony.Rlog.e(r0, r1)
        L_0x0084:
            java.lang.String r0 = "callerId"
            java.lang.String r15 = r4.group(r0)     // Catch:{ IllegalArgumentException -> 0x008b }
            goto L_0x0092
        L_0x008b:
            java.lang.String r0 = TAG
            java.lang.String r1 = "Caller id is not provided or can't be parsed."
            android.telephony.Rlog.d(r0, r1)
        L_0x0092:
            r14.createMissedIncomingCallEvent(r6, r15)
            r14 = 1
            return r14
        L_0x0097:
            r5 = move-exception
            java.lang.String r6 = TAG
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "Configuration error. Unexpected missed incoming call sms pattern: "
            r7.append(r8)
            r7.append(r4)
            java.lang.String r4 = ", e="
            r7.append(r4)
            r7.append(r5)
            java.lang.String r4 = r7.toString()
            android.telephony.Rlog.w(r6, r4)
        L_0x00b6:
            int r3 = r3 + 1
            goto L_0x0012
        L_0x00ba:
            java.lang.String r14 = TAG
            java.lang.String r15 = "SMS did not match any missed incoming call SMS pattern."
            android.telephony.Rlog.d(r14, r15)
            return r1
        L_0x00c2:
            java.lang.String r14 = TAG
            java.lang.String r15 = "Missed incoming call SMS pattern is not configured!"
            android.telephony.Rlog.w(r14, r15)
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.MissedIncomingCallSmsFilter.processSms(android.telephony.SmsMessage):boolean");
    }

    private static PhoneAccountHandle makePstnPhoneAccountHandle(Phone phone) {
        return new PhoneAccountHandle(PSTN_CONNECTION_SERVICE_COMPONENT, String.valueOf(phone.getFullIccSerialNumber()));
    }

    private void createMissedIncomingCallEvent(long j, String str) {
        TelecomManager telecomManager = (TelecomManager) this.mPhone.getContext().getSystemService("telecom");
        if (telecomManager != null) {
            Bundle bundle = new Bundle();
            if (str != null) {
                bundle.putParcelable("android.telecom.extra.INCOMING_CALL_ADDRESS", Uri.fromParts("tel", str, (String) null));
            }
            bundle.putLong("android.telecom.extra.CALL_CREATED_EPOCH_TIME_MILLIS", j);
            telecomManager.addNewIncomingCall(makePstnPhoneAccountHandle(this.mPhone), bundle);
        }
    }
}
