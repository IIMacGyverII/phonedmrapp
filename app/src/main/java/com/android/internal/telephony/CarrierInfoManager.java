package com.android.internal.telephony;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteConstraintException;
import android.os.UserHandle;
import android.provider.Telephony;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import java.util.Date;

public class CarrierInfoManager {
    private static final String EPDG_BACKUP_KEY_ID = "backup_key_from_carrier_config_epdg";
    private static final String KEY_TYPE = "KEY_TYPE";
    private static final String LOG_TAG = "CarrierInfoManager";
    private static final int RESET_CARRIER_KEY_RATE_LIMIT = 43200000;
    private static final String WLAN_BACKUP_KEY_ID = "backup_key_from_carrier_config_wlan";
    private long mLastAccessResetCarrierKey = 0;

    /* JADX WARNING: Code restructure failed: missing block: B:104:0x01e5, code lost:
        if (r11 != null) goto L_0x01e7;
     */
    /* JADX WARNING: Removed duplicated region for block: B:100:0x01ce A[Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4, all -> 0x01eb }] */
    /* JADX WARNING: Removed duplicated region for block: B:110:0x01ef  */
    /* JADX WARNING: Removed duplicated region for block: B:85:0x016b A[Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }] */
    /* JADX WARNING: Removed duplicated region for block: B:89:0x0185 A[SYNTHETIC, Splitter:B:89:0x0185] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static android.telephony.ImsiEncryptionInfo getCarrierInfoForImsiEncryption(int r17, android.content.Context r18, java.lang.String r19, int r20, boolean r21, int r22) {
        /*
            r0 = r17
            r1 = r19
            r2 = r22
            boolean r3 = android.text.TextUtils.isEmpty(r19)
            r9 = 0
            java.lang.String r10 = "CarrierInfoManager"
            if (r3 != 0) goto L_0x01f3
            r3 = 0
            r4 = 3
            java.lang.String r5 = r1.substring(r3, r4)
            java.lang.String r6 = r1.substring(r4)
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r7 = "using values for mcc, mnc: "
            r1.append(r7)
            r1.append(r5)
            java.lang.String r7 = ","
            r1.append(r7)
            r1.append(r6)
            java.lang.String r1 = r1.toString()
            android.util.Log.i(r10, r1)
            android.content.ContentResolver r11 = r18.getContentResolver()     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            java.lang.String r1 = "public_key"
            java.lang.String r7 = "expiration_time"
            java.lang.String r8 = "key_identifier"
            java.lang.String r12 = "carrier_id"
            java.lang.String[] r13 = new java.lang.String[]{r1, r7, r8, r12}     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            android.net.Uri r12 = android.provider.Telephony.CarrierColumns.CONTENT_URI     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            java.lang.String r14 = "mcc=? and mnc=? and key_type=?"
            java.lang.String[] r15 = new java.lang.String[r4]     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            r15[r3] = r5     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            r1 = 1
            r15[r1] = r6     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            java.lang.String r3 = java.lang.String.valueOf(r17)     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            r7 = 2
            r15[r7] = r3     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            r16 = 0
            android.database.Cursor r11 = r11.query(r12, r13, r14, r15, r16)     // Catch:{ IllegalArgumentException -> 0x01cf, Exception -> 0x01b6, all -> 0x01b4 }
            r3 = -1
            if (r11 == 0) goto L_0x00c6
            boolean r8 = r11.moveToFirst()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r8 != 0) goto L_0x0068
            goto L_0x00c6
        L_0x0068:
            int r2 = r11.getCount()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r2 <= r1) goto L_0x00a9
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.<init>()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r2 = "More than 1 row found for the keyType: "
            r1.append(r2)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.append(r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r1 = r1.toString()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.util.Log.e(r10, r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
        L_0x0082:
            boolean r1 = r11.moveToNext()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r1 == 0) goto L_0x00a6
            java.lang.String r1 = r11.getString(r4)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            boolean r2 = android.text.TextUtils.isEmpty(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r2 == 0) goto L_0x0094
            r1 = r3
            goto L_0x0098
        L_0x0094:
            int r1 = java.lang.Integer.parseInt(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
        L_0x0098:
            r8 = r20
            if (r1 == r3) goto L_0x0082
            if (r1 != r8) goto L_0x0082
            android.telephony.ImsiEncryptionInfo r0 = getImsiEncryptionInfo(r11, r5, r6, r0, r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r11.close()
            return r0
        L_0x00a6:
            r11.moveToFirst()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
        L_0x00a9:
            java.lang.String r1 = r11.getString(r4)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            boolean r2 = android.text.TextUtils.isEmpty(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r2 == 0) goto L_0x00b4
            goto L_0x00b8
        L_0x00b4:
            int r3 = java.lang.Integer.parseInt(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
        L_0x00b8:
            android.telephony.ImsiEncryptionInfo r0 = getImsiEncryptionInfo(r11, r5, r6, r0, r3)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r11.close()
            return r0
        L_0x00c0:
            r0 = move-exception
            goto L_0x01b8
        L_0x00c3:
            r0 = move-exception
            goto L_0x01d1
        L_0x00c6:
            r8 = r20
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r4.<init>()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r12 = "No rows found for keyType: "
            r4.append(r12)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r4.append(r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r4 = r4.toString()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.util.Log.d(r10, r4)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r21 != 0) goto L_0x00e9
            java.lang.String r0 = "Skipping fallback logic"
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x00e8
            r11.close()
        L_0x00e8:
            return r9
        L_0x00e9:
            java.lang.String r4 = "carrier_config"
            r12 = r18
            java.lang.Object r4 = r12.getSystemService(r4)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.telephony.CarrierConfigManager r4 = (android.telephony.CarrierConfigManager) r4     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r4 != 0) goto L_0x0100
            java.lang.String r0 = "Could not get CarrierConfigManager for backup key"
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x00ff
            r11.close()
        L_0x00ff:
            return r9
        L_0x0100:
            if (r2 != r3) goto L_0x010d
            java.lang.String r0 = "Could not get carrier config with invalid subId"
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x010c
            r11.close()
        L_0x010c:
            return r9
        L_0x010d:
            android.os.PersistableBundle r2 = r4.getConfigForSubId(r2)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r2 != 0) goto L_0x011e
            java.lang.String r0 = "Could not get carrier config bundle for backup key"
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x011d
            r11.close()
        L_0x011d:
            return r9
        L_0x011e:
            java.lang.String r3 = "imsi_key_availability_int"
            int r3 = r2.getInt(r3)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            boolean r4 = com.android.internal.telephony.CarrierKeyDownloadManager.isKeyEnabled(r0, r3)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r4 != 0) goto L_0x014c
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.<init>()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r2 = "Backup key does not have matching keyType. keyType="
            r1.append(r2)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.append(r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r0 = " keyAvailability="
            r1.append(r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.append(r3)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r0 = r1.toString()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x014b
            r11.close()
        L_0x014b:
            return r9
        L_0x014c:
            if (r0 != r1) goto L_0x0158
            java.lang.String r1 = "imsi_carrier_public_key_epdg_string"
            java.lang.String r1 = r2.getString(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r2 = "backup_key_from_carrier_config_epdg"
        L_0x0156:
            r7 = r2
            goto L_0x0165
        L_0x0158:
            if (r0 != r7) goto L_0x0163
            java.lang.String r1 = "imsi_carrier_public_key_wlan_string"
            java.lang.String r1 = r2.getString(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r2 = "backup_key_from_carrier_config_wlan"
            goto L_0x0156
        L_0x0163:
            r1 = r9
            r7 = r1
        L_0x0165:
            boolean r2 = android.text.TextUtils.isEmpty(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r2 == 0) goto L_0x0185
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.<init>()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r2 = "Could not get carrier config key string for backup key. keyType="
            r1.append(r2)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1.append(r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.String r0 = r1.toString()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.util.Log.d(r10, r0)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x0184
            r11.close()
        L_0x0184:
            return r9
        L_0x0185:
            byte[] r1 = r1.getBytes()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.util.Pair r1 = com.android.internal.telephony.CarrierKeyDownloadManager.getKeyInformation(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            android.telephony.ImsiEncryptionInfo r12 = new android.telephony.ImsiEncryptionInfo     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.Object r2 = r1.first     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r13 = r2
            java.security.PublicKey r13 = (java.security.PublicKey) r13     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.util.Date r14 = new java.util.Date     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.Object r1 = r1.second     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            java.lang.Long r1 = (java.lang.Long) r1     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            long r1 = r1.longValue()     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r14.<init>(r1)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            r1 = r12
            r2 = r5
            r3 = r6
            r4 = r17
            r5 = r7
            r6 = r13
            r7 = r14
            r8 = r20
            r1.<init>(r2, r3, r4, r5, r6, r7, r8)     // Catch:{ IllegalArgumentException -> 0x00c3, Exception -> 0x00c0 }
            if (r11 == 0) goto L_0x01b3
            r11.close()
        L_0x01b3:
            return r12
        L_0x01b4:
            r0 = move-exception
            goto L_0x01ed
        L_0x01b6:
            r0 = move-exception
            r11 = r9
        L_0x01b8:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01eb }
            r1.<init>()     // Catch:{ all -> 0x01eb }
            java.lang.String r2 = "Query failed:"
            r1.append(r2)     // Catch:{ all -> 0x01eb }
            r1.append(r0)     // Catch:{ all -> 0x01eb }
            java.lang.String r0 = r1.toString()     // Catch:{ all -> 0x01eb }
            android.util.Log.e(r10, r0)     // Catch:{ all -> 0x01eb }
            if (r11 == 0) goto L_0x01ea
            goto L_0x01e7
        L_0x01cf:
            r0 = move-exception
            r11 = r9
        L_0x01d1:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x01eb }
            r1.<init>()     // Catch:{ all -> 0x01eb }
            java.lang.String r2 = "Bad arguments:"
            r1.append(r2)     // Catch:{ all -> 0x01eb }
            r1.append(r0)     // Catch:{ all -> 0x01eb }
            java.lang.String r0 = r1.toString()     // Catch:{ all -> 0x01eb }
            android.util.Log.e(r10, r0)     // Catch:{ all -> 0x01eb }
            if (r11 == 0) goto L_0x01ea
        L_0x01e7:
            r11.close()
        L_0x01ea:
            return r9
        L_0x01eb:
            r0 = move-exception
            r9 = r11
        L_0x01ed:
            if (r9 == 0) goto L_0x01f2
            r9.close()
        L_0x01f2:
            throw r0
        L_0x01f3:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r2 = "Invalid networkOperator: "
            r0.append(r2)
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            android.util.Log.e(r10, r0)
            return r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CarrierInfoManager.getCarrierInfoForImsiEncryption(int, android.content.Context, java.lang.String, int, boolean, int):android.telephony.ImsiEncryptionInfo");
    }

    private static ImsiEncryptionInfo getImsiEncryptionInfo(Cursor cursor, String str, String str2, int i, int i2) {
        try {
            return new ImsiEncryptionInfo(str, str2, i, cursor.getString(2), cursor.getBlob(0), new Date(cursor.getLong(1)), i2);
        } catch (Exception e) {
            Log.e(LOG_TAG, "Exception = " + e.getMessage());
            return null;
        }
    }

    public static void updateOrInsertCarrierKey(ImsiEncryptionInfo imsiEncryptionInfo, Context context, int i) {
        byte[] encoded = imsiEncryptionInfo.getPublicKey().getEncoded();
        ContentResolver contentResolver = context.getContentResolver();
        TelephonyMetrics instance = TelephonyMetrics.getInstance();
        ContentValues contentValues = new ContentValues();
        contentValues.put("mcc", imsiEncryptionInfo.getMcc());
        contentValues.put("mnc", imsiEncryptionInfo.getMnc());
        contentValues.put("carrier_id", Integer.valueOf(imsiEncryptionInfo.getCarrierId()));
        contentValues.put("key_type", Integer.valueOf(imsiEncryptionInfo.getKeyType()));
        contentValues.put("key_identifier", imsiEncryptionInfo.getKeyIdentifier());
        contentValues.put("public_key", encoded);
        contentValues.put("expiration_time", Long.valueOf(imsiEncryptionInfo.getExpirationTime().getTime()));
        boolean z = true;
        boolean z2 = false;
        try {
            Log.i(LOG_TAG, "Inserting imsiEncryptionInfo into db");
            contentResolver.insert(Telephony.CarrierColumns.CONTENT_URI, contentValues);
            instance.writeCarrierKeyEvent(i, imsiEncryptionInfo.getKeyType(), true);
        } catch (SQLiteConstraintException unused) {
            Log.i(LOG_TAG, "Insert failed, updating imsiEncryptionInfo into db");
            ContentValues contentValues2 = new ContentValues();
            contentValues2.put("public_key", encoded);
            contentValues2.put("expiration_time", Long.valueOf(imsiEncryptionInfo.getExpirationTime().getTime()));
            contentValues2.put("key_identifier", imsiEncryptionInfo.getKeyIdentifier());
            try {
                if (contentResolver.update(Telephony.CarrierColumns.CONTENT_URI, contentValues2, "mcc=? and mnc=? and key_type=? and carrier_id=?", new String[]{imsiEncryptionInfo.getMcc(), imsiEncryptionInfo.getMnc(), String.valueOf(imsiEncryptionInfo.getKeyType()), String.valueOf(imsiEncryptionInfo.getCarrierId())}) == 0) {
                    Log.d(LOG_TAG, "Error updating values:" + imsiEncryptionInfo);
                    z = false;
                }
                z2 = z;
            } catch (Exception e) {
                Log.d(LOG_TAG, "Error updating values:" + imsiEncryptionInfo + e);
            }
            instance.writeCarrierKeyEvent(i, imsiEncryptionInfo.getKeyType(), z2);
        } catch (Exception e2) {
            Log.d(LOG_TAG, "Error inserting/updating values:" + imsiEncryptionInfo + e2);
            instance.writeCarrierKeyEvent(i, imsiEncryptionInfo.getKeyType(), z2);
        } catch (Throwable th) {
            instance.writeCarrierKeyEvent(i, imsiEncryptionInfo.getKeyType(), true);
            throw th;
        }
    }

    public static void setCarrierInfoForImsiEncryption(ImsiEncryptionInfo imsiEncryptionInfo, Context context, int i) {
        Log.i(LOG_TAG, "inserting carrier key: " + imsiEncryptionInfo);
        updateOrInsertCarrierKey(imsiEncryptionInfo, context, i);
    }

    public void resetCarrierKeysForImsiEncryption(Context context, int i) {
        Log.i(LOG_TAG, "resetting carrier key");
        long currentTimeMillis = System.currentTimeMillis();
        if (currentTimeMillis - this.mLastAccessResetCarrierKey < 43200000) {
            Log.i(LOG_TAG, "resetCarrierKeysForImsiEncryption: Access rate exceeded");
            return;
        }
        this.mLastAccessResetCarrierKey = currentTimeMillis;
        int[] subscriptionIds = ((SubscriptionManager) context.getSystemService(SubscriptionManager.class)).getSubscriptionIds(i);
        if (subscriptionIds == null || subscriptionIds.length < 1) {
            Log.e(LOG_TAG, "Could not reset carrier keys, subscription for mPhoneId=" + i);
            return;
        }
        deleteCarrierInfoForImsiEncryption(context, subscriptionIds[0], ((TelephonyManager) context.getSystemService(TelephonyManager.class)).createForSubscriptionId(subscriptionIds[0]).getSimCarrierId());
        Intent intent = new Intent("com.android.internal.telephony.ACTION_CARRIER_CERTIFICATE_DOWNLOAD");
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, i);
        context.sendBroadcastAsUser(intent, UserHandle.ALL);
    }

    public static void deleteCarrierInfoForImsiEncryption(Context context, int i, int i2) {
        Log.i(LOG_TAG, "deleting carrier key from db for subId=" + i);
        String simOperator = ((TelephonyManager) context.getSystemService(TelephonyManager.class)).createForSubscriptionId(i).getSimOperator();
        if (!TextUtils.isEmpty(simOperator)) {
            String substring = simOperator.substring(0, 3);
            String substring2 = simOperator.substring(3);
            String valueOf = String.valueOf(i2);
            try {
                int delete = context.getContentResolver().delete(Telephony.CarrierColumns.CONTENT_URI, "mcc=? and mnc=? and carrier_id=?", new String[]{substring, substring2, valueOf});
                Log.i(LOG_TAG, "Deleting the number of entries = " + delete + "   for carrierId = " + valueOf);
            } catch (Exception e) {
                Log.e(LOG_TAG, "Delete failed" + e);
            }
        } else {
            Log.e(LOG_TAG, "Invalid networkOperator: " + simOperator);
        }
    }

    public static void deleteAllCarrierKeysForImsiEncryption(Context context) {
        Log.i(LOG_TAG, "deleting ALL carrier keys from db");
        try {
            context.getContentResolver().delete(Telephony.CarrierColumns.CONTENT_URI, (String) null, (String[]) null);
        } catch (Exception e) {
            Log.e(LOG_TAG, "Delete failed" + e);
        }
    }
}
