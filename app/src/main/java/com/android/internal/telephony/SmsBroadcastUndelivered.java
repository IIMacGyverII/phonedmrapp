package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.PersistableBundle;
import android.os.SystemProperties;
import android.os.UserManager;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import com.android.internal.telephony.cdma.CdmaInboundSmsHandler;
import com.android.internal.telephony.gsm.GsmInboundSmsHandler;
import com.android.telephony.Rlog;
import java.util.HashMap;
import java.util.Map;

public class SmsBroadcastUndelivered {
    protected static final boolean DBG = true;
    protected static final long DEFAULT_PARTIAL_SEGMENT_EXPIRE_AGE = 604800000;
    private static final String[] PDU_PENDING_MESSAGE_PROJECTION = {"pdu", "sequence", "destination_port", "date", "reference_number", "count", "address", "_id", "message_body", "display_originating_addr", "sub_id"};
    static final Map<Integer, Integer> PDU_PENDING_MESSAGE_PROJECTION_INDEX_MAPPING = new HashMap<Integer, Integer>() {
        {
            put(0, 0);
            put(1, 1);
            put(2, 2);
            put(3, 3);
            put(4, 4);
            put(5, 5);
            put(6, 6);
            put(7, 7);
            put(8, 8);
            put(9, 9);
            put(11, 10);
        }
    };
    private static final String TAG = "SmsBroadcastUndelivered";
    private static SmsBroadcastUndelivered instance;
    private static Class<?> sMtkSmsBroadcastUndelivered = getMtkSmsBroadcastUndelivered();
    private final BroadcastReceiver mBroadcastReceiver;
    protected final ContentResolver mResolver;

    private class ScanRawTableThread extends Thread {
        private final Context context;

        private ScanRawTableThread(Context context2) {
            this.context = context2;
        }

        public void run() {
            SmsBroadcastUndelivered.scanRawTable(this.context, System.currentTimeMillis() - SmsBroadcastUndelivered.this.getUndeliveredSmsExpirationTime(this.context));
            InboundSmsHandler.cancelNewMessageNotification(this.context);
        }
    }

    public static void initialize(Context context, GsmInboundSmsHandler gsmInboundSmsHandler, CdmaInboundSmsHandler cdmaInboundSmsHandler) {
        if (instance == null) {
            instance = new SmsBroadcastUndelivered(context);
        }
        if (gsmInboundSmsHandler != null) {
            gsmInboundSmsHandler.sendMessage(6);
        }
        if (cdmaInboundSmsHandler != null) {
            cdmaInboundSmsHandler.sendMessage(6);
        }
    }

    @UnsupportedAppUsage
    protected SmsBroadcastUndelivered(Context context) {
        AnonymousClass2 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                Rlog.d(SmsBroadcastUndelivered.TAG, "Received broadcast " + intent.getAction());
                if ("android.intent.action.USER_UNLOCKED".equals(intent.getAction())) {
                    new ScanRawTableThread(context).start();
                }
            }
        };
        this.mBroadcastReceiver = r0;
        this.mResolver = context.getContentResolver();
        if (((UserManager) context.getSystemService("user")).isUserUnlocked()) {
            new ScanRawTableThread(context).start();
            return;
        }
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.USER_UNLOCKED");
        context.registerReceiver(r0, intentFilter);
    }

    /* JADX WARNING: Removed duplicated region for block: B:66:0x0198  */
    /* JADX WARNING: Removed duplicated region for block: B:72:0x01bb  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    static void scanRawTable(android.content.Context r21, long r22) {
        /*
            r1 = r21
            java.lang.String r2 = " ms"
            java.lang.String r3 = "finished scanning raw table in "
            java.lang.Class<?> r0 = sMtkSmsBroadcastUndelivered
            r4 = 0
            r5 = 0
            r6 = 1
            java.lang.String r7 = "SmsBroadcastUndelivered"
            if (r0 == 0) goto L_0x0036
            r8 = 2
            java.lang.Class[] r9 = new java.lang.Class[r8]     // Catch:{ Exception -> 0x0031 }
            java.lang.Class<android.content.Context> r10 = android.content.Context.class
            r9[r5] = r10     // Catch:{ Exception -> 0x0031 }
            java.lang.Class r10 = java.lang.Long.TYPE     // Catch:{ Exception -> 0x0031 }
            r9[r6] = r10     // Catch:{ Exception -> 0x0031 }
            java.lang.String r10 = "scanRawTable"
            java.lang.reflect.Method r0 = r0.getDeclaredMethod(r10, r9)     // Catch:{ Exception -> 0x0031 }
            java.lang.Object[] r8 = new java.lang.Object[r8]     // Catch:{ Exception -> 0x0031 }
            r8[r5] = r1     // Catch:{ Exception -> 0x0031 }
            java.lang.Long r9 = java.lang.Long.valueOf(r22)     // Catch:{ Exception -> 0x0031 }
            r8[r6] = r9     // Catch:{ Exception -> 0x0031 }
            r0.setAccessible(r6)     // Catch:{ Exception -> 0x0031 }
            r0.invoke(r4, r8)     // Catch:{ Exception -> 0x0031 }
            return
        L_0x0031:
            java.lang.String r0 = "No MtkSmsBroadcastUndelivered! Used AOSP for instead!"
            com.android.telephony.Rlog.e(r7, r0)
        L_0x0036:
            java.lang.String r0 = "scanning raw table for undelivered messages"
            com.android.telephony.Rlog.d(r7, r0)
            long r8 = java.lang.System.nanoTime()
            android.content.ContentResolver r15 = r21.getContentResolver()
            java.util.HashMap r14 = new java.util.HashMap
            r0 = 4
            r14.<init>(r0)
            java.util.HashSet r13 = new java.util.HashSet
            r13.<init>(r0)
            r16 = 1000000(0xf4240, double:4.940656E-318)
            android.net.Uri r11 = com.android.internal.telephony.InboundSmsHandler.sRawUri     // Catch:{ SQLException -> 0x018f, all -> 0x018c }
            java.lang.String[] r12 = PDU_PENDING_MESSAGE_PROJECTION     // Catch:{ SQLException -> 0x018f, all -> 0x018c }
            java.lang.String r0 = "deleted = 0"
            r18 = 0
            r19 = 0
            r10 = r15
            r4 = r13
            r13 = r0
            r5 = r14
            r14 = r18
            r20 = r15
            r15 = r19
            android.database.Cursor r10 = r10.query(r11, r12, r13, r14, r15)     // Catch:{ SQLException -> 0x018f, all -> 0x018c }
            if (r10 != 0) goto L_0x0092
            java.lang.String r0 = "error getting pending message cursor"
            com.android.telephony.Rlog.e(r7, r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r10 == 0) goto L_0x0075
            r10.close()
        L_0x0075:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            r0.append(r3)
            long r3 = java.lang.System.nanoTime()
            long r3 = r3 - r8
            long r3 = r3 / r16
            r0.append(r3)
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            com.android.telephony.Rlog.d(r7, r0)
            return
        L_0x0092:
            boolean r11 = com.android.internal.telephony.InboundSmsHandler.isCurrentFormat3gpp2()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
        L_0x0096:
            boolean r0 = r10.moveToNext()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r0 == 0) goto L_0x010d
            com.android.internal.telephony.TelephonyComponentFactory r0 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ IllegalArgumentException -> 0x00f7 }
            java.lang.Class<com.android.internal.telephony.InboundSmsTracker> r12 = com.android.internal.telephony.InboundSmsTracker.class
            java.lang.String r12 = r12.getName()     // Catch:{ IllegalArgumentException -> 0x00f7 }
            com.android.internal.telephony.TelephonyComponentFactory r0 = r0.inject(r12)     // Catch:{ IllegalArgumentException -> 0x00f7 }
            com.android.internal.telephony.InboundSmsTracker r0 = r0.makeInboundSmsTracker(r1, r10, r11)     // Catch:{ IllegalArgumentException -> 0x00f7 }
            int r12 = r0.getMessageCount()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r12 != r6) goto L_0x00b8
            broadcastSms(r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x0096
        L_0x00b8:
            com.android.internal.telephony.SmsBroadcastUndelivered$SmsReferenceKey r12 = new com.android.internal.telephony.SmsBroadcastUndelivered$SmsReferenceKey     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r12.<init>(r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.Object r13 = r5.get(r12)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.Integer r13 = (java.lang.Integer) r13     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r13 != 0) goto L_0x00d8
            java.lang.Integer r13 = java.lang.Integer.valueOf(r6)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r5.put(r12, r13)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            long r13 = r0.getTimestamp()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            int r0 = (r13 > r22 ? 1 : (r13 == r22 ? 0 : -1))
            if (r0 >= 0) goto L_0x0096
            r4.add(r12)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x0096
        L_0x00d8:
            int r13 = r13.intValue()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            int r13 = r13 + r6
            int r14 = r0.getMessageCount()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r13 != r14) goto L_0x00ef
            java.lang.String r13 = "found complete multi-part message"
            com.android.telephony.Rlog.d(r7, r13)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            broadcastSms(r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r4.remove(r12)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x0096
        L_0x00ef:
            java.lang.Integer r0 = java.lang.Integer.valueOf(r13)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r5.put(r12, r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x0096
        L_0x00f7:
            r0 = move-exception
            java.lang.StringBuilder r12 = new java.lang.StringBuilder     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r12.<init>()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r13 = "error loading SmsTracker: "
            r12.append(r13)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r12.append(r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r0 = r12.toString()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            com.android.telephony.Rlog.e(r7, r0)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x0096
        L_0x010d:
            r1 = 0
            com.android.internal.telephony.Phone r0 = com.android.internal.telephony.PhoneFactory.getPhone(r1)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.util.Iterator r1 = r4.iterator()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
        L_0x0116:
            boolean r4 = r1.hasNext()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r4 == 0) goto L_0x017d
            java.lang.Object r4 = r1.next()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            com.android.internal.telephony.SmsBroadcastUndelivered$SmsReferenceKey r4 = (com.android.internal.telephony.SmsBroadcastUndelivered.SmsReferenceKey) r4     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            android.net.Uri r5 = com.android.internal.telephony.InboundSmsHandler.sRawUriPermanentDelete     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r6 = r4.getDeleteWhere()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String[] r11 = r4.getDeleteWhereArgs()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r12 = r20
            int r5 = r12.delete(r5, r6, r11)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r5 != 0) goto L_0x013a
            java.lang.String r6 = "No rows were deleted from raw table!"
            com.android.telephony.Rlog.e(r7, r6)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x015d
        L_0x013a:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r6.<init>()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r11 = "Deleted "
            r6.append(r11)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r6.append(r5)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r11 = " rows from raw table for incomplete "
            r6.append(r11)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            int r11 = r4.mMessageCount     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r6.append(r11)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r11 = " part message"
            r6.append(r11)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r6 = r6.toString()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            com.android.telephony.Rlog.d(r7, r6)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
        L_0x015d:
            if (r5 <= 0) goto L_0x0179
            com.android.internal.telephony.metrics.TelephonyMetrics r6 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            java.lang.String r11 = r4.mFormat     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            int r13 = r4.mMessageCount     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r14 = 0
            r6.writeDroppedIncomingMultipartSms(r14, r11, r5, r13)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            if (r0 == 0) goto L_0x017a
            com.android.internal.telephony.metrics.SmsStats r6 = r0.getSmsStats()     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            boolean r11 = r4.mIs3gpp2     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            int r4 = r4.mMessageCount     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            r6.onDroppedIncomingMultipartSms(r11, r5, r4)     // Catch:{ SQLException -> 0x0189, all -> 0x0186 }
            goto L_0x017a
        L_0x0179:
            r14 = 0
        L_0x017a:
            r20 = r12
            goto L_0x0116
        L_0x017d:
            r10.close()
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            goto L_0x01a0
        L_0x0186:
            r0 = move-exception
            r4 = r10
            goto L_0x01b9
        L_0x0189:
            r0 = move-exception
            r4 = r10
            goto L_0x0191
        L_0x018c:
            r0 = move-exception
            r4 = 0
            goto L_0x01b9
        L_0x018f:
            r0 = move-exception
            r4 = 0
        L_0x0191:
            java.lang.String r1 = "error reading pending SMS messages"
            com.android.telephony.Rlog.e(r7, r1, r0)     // Catch:{ all -> 0x01b8 }
            if (r4 == 0) goto L_0x019b
            r4.close()
        L_0x019b:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
        L_0x01a0:
            r0.append(r3)
            long r3 = java.lang.System.nanoTime()
            long r3 = r3 - r8
            long r3 = r3 / r16
            r0.append(r3)
            r0.append(r2)
            java.lang.String r0 = r0.toString()
            com.android.telephony.Rlog.d(r7, r0)
            return
        L_0x01b8:
            r0 = move-exception
        L_0x01b9:
            if (r4 == 0) goto L_0x01be
            r4.close()
        L_0x01be:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r1.append(r3)
            long r3 = java.lang.System.nanoTime()
            long r3 = r3 - r8
            long r3 = r3 / r16
            r1.append(r3)
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            com.android.telephony.Rlog.d(r7, r1)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SmsBroadcastUndelivered.scanRawTable(android.content.Context, long):void");
    }

    private static void broadcastSms(InboundSmsTracker inboundSmsTracker) {
        int subId = inboundSmsTracker.getSubId();
        int phoneId = SubscriptionController.getInstance().getPhoneId(subId);
        if (!SubscriptionManager.isValidPhoneId(phoneId)) {
            Rlog.e(TAG, "broadcastSms: ignoring message; no phone found for subId " + subId);
            return;
        }
        Phone phone = PhoneFactory.getPhone(phoneId);
        if (phone == null) {
            Rlog.e(TAG, "broadcastSms: ignoring message; no phone found for subId " + subId + " phoneId " + phoneId);
            return;
        }
        InboundSmsHandler inboundSmsHandler = phone.getInboundSmsHandler(inboundSmsTracker.is3gpp2());
        if (inboundSmsHandler != null) {
            inboundSmsHandler.sendMessage(2, (Object) inboundSmsTracker);
            return;
        }
        Rlog.e(TAG, "null handler for " + inboundSmsTracker.getFormat() + " format, can't deliver.");
    }

    /* access modifiers changed from: private */
    public long getUndeliveredSmsExpirationTime(Context context) {
        PersistableBundle configForSubId = ((CarrierConfigManager) context.getSystemService("carrier_config")).getConfigForSubId(SubscriptionManager.getDefaultSmsSubscriptionId());
        if (configForSubId != null) {
            return configForSubId.getLong("undelivered_sms_message_expiration_time", DEFAULT_PARTIAL_SEGMENT_EXPIRE_AGE);
        }
        return DEFAULT_PARTIAL_SEGMENT_EXPIRE_AGE;
    }

    private static Class<?> getMtkSmsBroadcastUndelivered() {
        if (!SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
            return null;
        }
        try {
            return Class.forName("com.mediatek.internal.telephony.MtkSmsBroadcastUndelivered");
        } catch (Exception unused) {
            Rlog.e(TAG, "No MtkSmsBroadcastUndeliveredClass! Used AOSP for instead!");
            return null;
        }
    }

    private static class SmsReferenceKey {
        final String mAddress;
        final String mFormat;
        final boolean mIs3gpp2;
        final int mMessageCount;
        final String mQuery;
        final int mReferenceNumber;

        SmsReferenceKey(InboundSmsTracker inboundSmsTracker) {
            this.mAddress = inboundSmsTracker.getAddress();
            this.mReferenceNumber = inboundSmsTracker.getReferenceNumber();
            this.mMessageCount = inboundSmsTracker.getMessageCount();
            this.mQuery = inboundSmsTracker.getQueryForSegments();
            this.mIs3gpp2 = inboundSmsTracker.is3gpp2();
            this.mFormat = inboundSmsTracker.getFormat();
        }

        /* access modifiers changed from: package-private */
        public String[] getDeleteWhereArgs() {
            return new String[]{this.mAddress, Integer.toString(this.mReferenceNumber), Integer.toString(this.mMessageCount)};
        }

        /* access modifiers changed from: package-private */
        public String getDeleteWhere() {
            return this.mQuery;
        }

        public int hashCode() {
            return (((this.mReferenceNumber * 31) + this.mMessageCount) * 31) + this.mAddress.hashCode();
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof SmsReferenceKey)) {
                return false;
            }
            SmsReferenceKey smsReferenceKey = (SmsReferenceKey) obj;
            if (smsReferenceKey.mAddress.equals(this.mAddress) && smsReferenceKey.mReferenceNumber == this.mReferenceNumber && smsReferenceKey.mMessageCount == this.mMessageCount) {
                return true;
            }
            return false;
        }
    }
}
