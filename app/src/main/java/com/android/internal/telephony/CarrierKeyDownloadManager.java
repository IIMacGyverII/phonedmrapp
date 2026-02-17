package com.android.internal.telephony;

import android.app.AlarmManager;
import android.app.DownloadManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.ImsiEncryptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;
import androidx.core.app.NotificationCompat;
import com.android.internal.annotations.VisibleForTesting;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.PublicKey;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Date;
import java.util.Random;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CarrierKeyDownloadManager extends Handler {
    private static final int[] CARRIER_KEY_TYPES = {1, 2};
    private static final String CERT_BEGIN_STRING = "-----BEGIN CERTIFICATE-----";
    private static final String CERT_END_STRING = "-----END CERTIFICATE-----";
    private static final int DAY_IN_MILLIS = 86400000;
    private static final int END_RENEWAL_WINDOW_DAYS = 7;
    private static final int EVENT_ALARM_OR_CONFIG_CHANGE = 0;
    private static final int EVENT_DOWNLOAD_COMPLETE = 1;
    private static final String INTENT_KEY_RENEWAL_ALARM_PREFIX = "com.android.internal.telephony.carrier_key_download_alarm";
    private static final String JSON_CARRIER_KEYS = "carrier-keys";
    private static final String JSON_CERTIFICATE = "certificate";
    private static final String JSON_CERTIFICATE_ALTERNATE = "public-key";
    private static final String JSON_IDENTIFIER = "key-identifier";
    private static final String JSON_TYPE = "key-type";
    private static final String JSON_TYPE_VALUE_EPDG = "EPDG";
    private static final String JSON_TYPE_VALUE_WLAN = "WLAN";
    private static final String LOG_TAG = "CarrierKeyDownloadManager";
    private static final int START_RENEWAL_WINDOW_DAYS = 21;
    private boolean mAllowedOverMeteredNetwork = false;
    private final BroadcastReceiver mBroadcastReceiver;
    public int mCarrierId;
    private final Context mContext;
    private boolean mDeleteOldKeyAfterDownload = false;
    @VisibleForTesting
    public long mDownloadId;
    public final DownloadManager mDownloadManager;
    private final BroadcastReceiver mDownloadReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals("android.intent.action.DOWNLOAD_COMPLETE")) {
                Log.d(CarrierKeyDownloadManager.LOG_TAG, "Download Complete");
                CarrierKeyDownloadManager carrierKeyDownloadManager = CarrierKeyDownloadManager.this;
                carrierKeyDownloadManager.sendMessage(carrierKeyDownloadManager.obtainMessage(1, Long.valueOf(intent.getLongExtra("extra_download_id", 0))));
            }
        }
    };
    @VisibleForTesting
    public int mKeyAvailability = 0;
    @VisibleForTesting
    public String mMccMncForDownload;
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private TelephonyManager mTelephonyManager;
    private String mURL;

    public static boolean isKeyEnabled(int i, int i2) {
        return ((i2 >> (i - 1)) & 1) == 1;
    }

    public CarrierKeyDownloadManager(Phone phone) {
        AnonymousClass2 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                int slotIndex = SubscriptionManager.getSlotIndex(CarrierKeyDownloadManager.this.mPhone.getSubId());
                int phoneId = CarrierKeyDownloadManager.this.mPhone.getPhoneId();
                if (action.equals(CarrierKeyDownloadManager.INTENT_KEY_RENEWAL_ALARM_PREFIX)) {
                    if (intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1) == slotIndex) {
                        Log.d(CarrierKeyDownloadManager.LOG_TAG, "Handling key renewal alarm: " + action);
                        CarrierKeyDownloadManager.this.sendEmptyMessage(0);
                    }
                } else if (action.equals("com.android.internal.telephony.ACTION_CARRIER_CERTIFICATE_DOWNLOAD")) {
                    if (phoneId == intent.getIntExtra("phone", -1)) {
                        Log.d(CarrierKeyDownloadManager.LOG_TAG, "Handling reset intent: " + action);
                        CarrierKeyDownloadManager.this.sendEmptyMessage(0);
                    }
                } else if (action.equals("android.telephony.action.CARRIER_CONFIG_CHANGED") && phoneId == intent.getIntExtra("phone", -1)) {
                    Log.d(CarrierKeyDownloadManager.LOG_TAG, "Carrier Config changed: " + action);
                    CarrierKeyDownloadManager.this.sendEmptyMessage(0);
                }
            }
        };
        this.mBroadcastReceiver = r0;
        this.mPhone = phone;
        Context context = phone.getContext();
        this.mContext = context;
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        intentFilter.addAction(INTENT_KEY_RENEWAL_ALARM_PREFIX);
        intentFilter.addAction("com.android.internal.telephony.ACTION_CARRIER_CERTIFICATE_DOWNLOAD");
        context.registerReceiver(r0, intentFilter, (String) null, phone);
        this.mDownloadManager = (DownloadManager) context.getSystemService("download");
        this.mTelephonyManager = ((TelephonyManager) context.getSystemService(TelephonyManager.class)).createForSubscriptionId(phone.getSubId());
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 0) {
            handleAlarmOrConfigChange();
        } else if (i == 1) {
            long longValue = ((Long) message.obj).longValue();
            String simOperator = getSimOperator();
            int simCarrierId = getSimCarrierId();
            if (isValidDownload(simOperator, longValue, simCarrierId)) {
                onDownloadComplete(longValue, simOperator, simCarrierId);
                onPostDownloadProcessing(longValue);
            }
        }
    }

    private void onPostDownloadProcessing(long j) {
        resetRenewalAlarm();
        cleanupDownloadInfo();
        this.mContext.unregisterReceiver(this.mDownloadReceiver);
    }

    private void handleAlarmOrConfigChange() {
        if (!carrierUsesKeys()) {
            cleanupRenewalAlarms();
            this.mPhone.deleteCarrierInfoForImsiEncryption(getSimCarrierId());
        } else if (areCarrierKeysAbsentOrExpiring() && !downloadKey()) {
            resetRenewalAlarm();
        }
    }

    private void cleanupDownloadInfo() {
        Log.d(LOG_TAG, "Cleaning up download info");
        this.mDownloadId = -1;
        this.mMccMncForDownload = null;
        this.mCarrierId = -1;
    }

    private void cleanupRenewalAlarms() {
        Log.d(LOG_TAG, "Cleaning up existing renewal alarms");
        int slotIndex = SubscriptionManager.getSlotIndex(this.mPhone.getSubId());
        Intent intent = new Intent(INTENT_KEY_RENEWAL_ALARM_PREFIX);
        intent.putExtra("android.telephony.extra.SLOT_INDEX", slotIndex);
        ((AlarmManager) this.mContext.getSystemService(NotificationCompat.CATEGORY_ALARM)).cancel(PendingIntent.getBroadcast(this.mContext, 0, intent, 201326592));
    }

    @VisibleForTesting
    public long getExpirationDate() {
        ImsiEncryptionInfo carrierInfoForImsiEncryption;
        long j = Long.MAX_VALUE;
        for (int i : CARRIER_KEY_TYPES) {
            if (isKeyEnabled(i) && (carrierInfoForImsiEncryption = this.mPhone.getCarrierInfoForImsiEncryption(i, false)) != null && carrierInfoForImsiEncryption.getExpirationTime() != null && j > carrierInfoForImsiEncryption.getExpirationTime().getTime()) {
                j = carrierInfoForImsiEncryption.getExpirationTime().getTime();
            }
        }
        return (j == Long.MAX_VALUE || j < System.currentTimeMillis() + 604800000) ? System.currentTimeMillis() + 86400000 : j - ((long) (new Random().nextInt(1209600000) + 604800000));
    }

    @VisibleForTesting
    public void resetRenewalAlarm() {
        cleanupRenewalAlarms();
        int slotIndex = SubscriptionManager.getSlotIndex(this.mPhone.getSubId());
        long expirationDate = getExpirationDate();
        Log.d(LOG_TAG, "minExpirationDate: " + new Date(expirationDate));
        Intent intent = new Intent(INTENT_KEY_RENEWAL_ALARM_PREFIX);
        intent.putExtra("android.telephony.extra.SLOT_INDEX", slotIndex);
        ((AlarmManager) this.mContext.getSystemService(NotificationCompat.CATEGORY_ALARM)).set(0, expirationDate, PendingIntent.getBroadcast(this.mContext, 0, intent, 201326592));
        Log.d(LOG_TAG, "setRenewalAlarm: action=" + intent.getAction() + " time=" + new Date(expirationDate));
    }

    @VisibleForTesting
    public String getSimOperator() {
        return this.mTelephonyManager.getSimOperator(this.mPhone.getSubId());
    }

    @VisibleForTesting
    public int getSimCarrierId() {
        return this.mTelephonyManager.getSimCarrierId();
    }

    @VisibleForTesting
    public boolean isValidDownload(String str, long j, int i) {
        if (j != this.mDownloadId) {
            Log.e(LOG_TAG, "download ID=" + j + " for completed download does not match stored id=" + this.mDownloadId);
            return false;
        } else if (TextUtils.isEmpty(str) || TextUtils.isEmpty(this.mMccMncForDownload) || !TextUtils.equals(str, this.mMccMncForDownload) || this.mCarrierId != i) {
            Log.e(LOG_TAG, "currentMccMnc=" + str + " storedMccMnc =" + this.mMccMncForDownload + "currentCarrierId = " + i + "  storedCarrierId = " + this.mCarrierId);
            return false;
        } else {
            Log.d(LOG_TAG, "Matched MccMnc =  " + str + ", carrierId = " + i + ", downloadId: " + j);
            return true;
        }
    }

    private void onDownloadComplete(long j, String str, int i) {
        Log.d(LOG_TAG, "onDownloadComplete: " + j);
        DownloadManager.Query query = new DownloadManager.Query();
        query.setFilterById(new long[]{j});
        Cursor query2 = this.mDownloadManager.query(query);
        if (query2 != null) {
            if (query2.moveToFirst()) {
                if (8 == query2.getInt(query2.getColumnIndex(NotificationCompat.CATEGORY_STATUS))) {
                    try {
                        String convertToString = convertToString(this.mDownloadManager, j);
                        if (TextUtils.isEmpty(convertToString)) {
                            Log.d(LOG_TAG, "fallback to no gzip");
                            convertToString = convertToStringNoGZip(this.mDownloadManager, j);
                        }
                        parseJsonAndPersistKey(convertToString, str, i);
                    } catch (Exception e) {
                        Log.e(LOG_TAG, "Error in download:" + j + ". " + e);
                    } finally {
                        this.mDownloadManager.remove(new long[]{j});
                    }
                }
                Log.d(LOG_TAG, "Completed downloading keys");
            }
            query2.close();
        }
    }

    private boolean carrierUsesKeys() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return false;
        }
        this.mKeyAvailability = configForSubId.getInt("imsi_key_availability_int");
        this.mURL = configForSubId.getString("imsi_key_download_url_string");
        this.mAllowedOverMeteredNetwork = configForSubId.getBoolean("allow_metered_network_for_cert_download_bool");
        if (this.mKeyAvailability == 0 || TextUtils.isEmpty(this.mURL)) {
            Log.d(LOG_TAG, "Carrier not enabled or invalid values. mKeyAvailability=" + this.mKeyAvailability + " mURL=" + this.mURL);
            return false;
        }
        for (int isKeyEnabled : CARRIER_KEY_TYPES) {
            if (isKeyEnabled(isKeyEnabled)) {
                return true;
            }
        }
        return false;
    }

    private static String convertToStringNoGZip(DownloadManager downloadManager, long j) {
        FileInputStream fileInputStream;
        StringBuilder sb = new StringBuilder();
        try {
            fileInputStream = new FileInputStream(downloadManager.openDownloadedFile(j).getFileDescriptor());
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream, StandardCharsets.UTF_8));
            while (true) {
                String readLine = bufferedReader.readLine();
                if (readLine != null) {
                    sb.append(readLine);
                    sb.append(10);
                } else {
                    fileInputStream.close();
                    return sb.toString();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } catch (Throwable th) {
            th.addSuppressed(th);
        }
        throw th;
    }

    private static String convertToString(DownloadManager downloadManager, long j) {
        GZIPInputStream gZIPInputStream;
        try {
            FileInputStream fileInputStream = new FileInputStream(downloadManager.openDownloadedFile(j).getFileDescriptor());
            try {
                gZIPInputStream = new GZIPInputStream(fileInputStream);
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(gZIPInputStream, StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                while (true) {
                    String readLine = bufferedReader.readLine();
                    if (readLine != null) {
                        sb.append(readLine);
                        sb.append(10);
                    } else {
                        String sb2 = sb.toString();
                        gZIPInputStream.close();
                        fileInputStream.close();
                        return sb2;
                    }
                }
            } catch (Throwable th) {
                fileInputStream.close();
                throw th;
            }
            throw th;
        } catch (ZipException e) {
            Log.d(LOG_TAG, "Stream is not gzipped e=" + e);
            return null;
        } catch (IOException e2) {
            Log.e(LOG_TAG, "Unexpected exception in convertToString e=" + e2);
            return null;
        } catch (Throwable th2) {
            th.addSuppressed(th2);
        }
    }

    @VisibleForTesting
    public void parseJsonAndPersistKey(String str, String str2, int i) {
        String str3;
        String str4 = str2;
        if (TextUtils.isEmpty(str) || TextUtils.isEmpty(str2) || i == -1) {
            Log.e(LOG_TAG, "jsonStr or mcc, mnc: is empty or carrierId is UNKNOWN_CARRIER_ID");
            return;
        }
        try {
            String substring = str4.substring(0, 3);
            String substring2 = str4.substring(3);
            JSONArray jSONArray = new JSONObject(str).getJSONArray(JSON_CARRIER_KEYS);
            int i2 = 0;
            while (i2 < jSONArray.length()) {
                JSONObject jSONObject = jSONArray.getJSONObject(i2);
                if (jSONObject.has(JSON_CERTIFICATE)) {
                    str3 = jSONObject.getString(JSON_CERTIFICATE);
                } else {
                    str3 = jSONObject.getString(JSON_CERTIFICATE_ALTERNATE);
                }
                int i3 = 2;
                if (jSONObject.has(JSON_TYPE)) {
                    String string = jSONObject.getString(JSON_TYPE);
                    if (string.equals(JSON_TYPE_VALUE_EPDG)) {
                        i3 = 1;
                    } else if (!string.equals(JSON_TYPE_VALUE_WLAN)) {
                        Log.e(LOG_TAG, "Invalid key-type specified: " + string);
                    }
                }
                String string2 = jSONObject.getString(JSON_IDENTIFIER);
                Pair<PublicKey, Long> keyInformation = getKeyInformation(cleanCertString(str3).getBytes());
                if (this.mDeleteOldKeyAfterDownload) {
                    this.mPhone.deleteCarrierInfoForImsiEncryption(-1);
                    this.mDeleteOldKeyAfterDownload = false;
                }
                int i4 = i2;
                JSONArray jSONArray2 = jSONArray;
                savePublicKey((PublicKey) keyInformation.first, i3, string2, ((Long) keyInformation.second).longValue(), substring, substring2, i);
                i2 = i4 + 1;
                jSONArray = jSONArray2;
            }
        } catch (JSONException e) {
            Log.e(LOG_TAG, "Json parsing error: " + e.getMessage());
        } catch (Exception e2) {
            Log.e(LOG_TAG, "Exception getting certificate: " + e2);
        }
    }

    @VisibleForTesting
    public boolean isKeyEnabled(int i) {
        return isKeyEnabled(i, this.mKeyAvailability);
    }

    @VisibleForTesting
    public boolean areCarrierKeysAbsentOrExpiring() {
        int[] iArr = CARRIER_KEY_TYPES;
        int length = iArr.length;
        int i = 0;
        while (i < length) {
            int i2 = iArr[i];
            if (!isKeyEnabled(i2)) {
                i++;
            } else {
                ImsiEncryptionInfo carrierInfoForImsiEncryption = this.mPhone.getCarrierInfoForImsiEncryption(i2, false);
                if (carrierInfoForImsiEncryption == null) {
                    Log.d(LOG_TAG, "Key not found for: " + i2);
                    return true;
                } else if (carrierInfoForImsiEncryption.getCarrierId() == -1) {
                    Log.d(LOG_TAG, "carrier key is unknown carrier, so prefer to reDownload");
                    this.mDeleteOldKeyAfterDownload = true;
                    return true;
                } else if (carrierInfoForImsiEncryption.getExpirationTime().getTime() - System.currentTimeMillis() < 1814400000) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        return false;
    }

    private boolean downloadKey() {
        Log.d(LOG_TAG, "starting download from: " + this.mURL);
        String simOperator = getSimOperator();
        int simCarrierId = getSimCarrierId();
        if (!TextUtils.isEmpty(simOperator) || simCarrierId != -1) {
            Log.d(LOG_TAG, "downloading key for mccmnc : " + simOperator + ", carrierId : " + simCarrierId);
            try {
                this.mContext.registerReceiver(this.mDownloadReceiver, new IntentFilter("android.intent.action.DOWNLOAD_COMPLETE"), (String) null, this.mPhone, 2);
                DownloadManager.Request request = new DownloadManager.Request(Uri.parse(this.mURL));
                request.setAllowedOverMetered(this.mAllowedOverMeteredNetwork);
                request.setNotificationVisibility(2);
                request.addRequestHeader("Accept-Encoding", "gzip");
                Long valueOf = Long.valueOf(this.mDownloadManager.enqueue(request));
                Log.d(LOG_TAG, "saving values mccmnc: " + simOperator + ", downloadId: " + valueOf + ", carrierId: " + simCarrierId);
                this.mMccMncForDownload = simOperator;
                this.mCarrierId = simCarrierId;
                this.mDownloadId = valueOf.longValue();
                return true;
            } catch (Exception unused) {
                Log.e(LOG_TAG, "exception trying to download key from url: " + this.mURL);
                return false;
            }
        } else {
            Log.e(LOG_TAG, "mccmnc or carrierId is UnKnown");
            return false;
        }
    }

    @VisibleForTesting
    public static Pair<PublicKey, Long> getKeyInformation(byte[] bArr) throws Exception {
        X509Certificate x509Certificate = (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(new ByteArrayInputStream(bArr));
        return new Pair<>(x509Certificate.getPublicKey(), Long.valueOf(x509Certificate.getNotAfter().getTime()));
    }

    @VisibleForTesting
    public void savePublicKey(PublicKey publicKey, int i, String str, long j, String str2, String str3, int i2) {
        long j2 = j;
        this.mPhone.setCarrierInfoForImsiEncryption(new ImsiEncryptionInfo(str2, str3, i, str, publicKey, new Date(j), i2));
    }

    @VisibleForTesting
    public static String cleanCertString(String str) {
        return str.substring(str.indexOf(CERT_BEGIN_STRING), str.indexOf(CERT_END_STRING) + 25);
    }
}
