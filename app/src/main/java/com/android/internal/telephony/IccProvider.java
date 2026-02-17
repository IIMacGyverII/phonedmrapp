package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.database.MergeCursor;
import android.net.Uri;
import android.os.RemoteException;
import android.os.SystemProperties;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyFrameworkInitializer;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.IIccPhoneBook;
import com.android.internal.telephony.uicc.AdnRecord;
import com.android.internal.telephony.uicc.IccConstants;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.lang.reflect.Constructor;
import java.util.List;

public class IccProvider extends ContentProvider {
    @UnsupportedAppUsage
    private static final String[] ADDRESS_BOOK_COLUMN_NAMES = {XmlTagConst.TAG_CHANNEL_NAME, "number", STR_EMAILS, STR_ANRS, "_id"};
    protected static final int ADN = 1;
    protected static final int ADN_ALL = 7;
    protected static final int ADN_SUB = 2;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static final boolean DBG = true;
    protected static final int FDN = 3;
    protected static final int FDN_SUB = 4;
    protected static final int SDN = 5;
    protected static final int SDN_SUB = 6;
    @VisibleForTesting
    public static final String STR_ANRS = "anrs";
    @VisibleForTesting
    public static final String STR_EMAILS = "emails";
    @VisibleForTesting
    public static final String STR_NEW_ANRS = "newAnrs";
    @VisibleForTesting
    public static final String STR_NEW_EMAILS = "newEmails";
    @VisibleForTesting
    public static final String STR_NEW_NUMBER = "newNumber";
    @VisibleForTesting
    public static final String STR_NEW_TAG = "newTag";
    @VisibleForTesting
    public static final String STR_NUMBER = "number";
    @VisibleForTesting
    public static final String STR_PIN2 = "pin2";
    @VisibleForTesting
    public static final String STR_TAG = "tag";
    private static final String TAG = "IccProvider";
    private static final UriMatcher URL_MATCHER;
    static IccInternalInterface sMtkIccProvider = null;
    private SubscriptionManager mSubscriptionManager;

    static {
        UriMatcher uriMatcher = new UriMatcher(-1);
        URL_MATCHER = uriMatcher;
        uriMatcher.addURI("icc", "adn", 1);
        uriMatcher.addURI("icc", "adn/subId/#", 2);
        uriMatcher.addURI("icc", "fdn", 3);
        uriMatcher.addURI("icc", "fdn/subId/#", 4);
        uriMatcher.addURI("icc", "sdn", 5);
        uriMatcher.addURI("icc", "sdn/subId/#", 6);
    }

    private static IccInternalInterface makeIccProvider(UriMatcher uriMatcher, Context context) {
        if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
            try {
                Class<?> cls = Class.forName("com.mediatek.internal.telephony.phb.MtkIccProvider", false, ClassLoader.getSystemClassLoader());
                Rlog.d(TAG, "class = " + cls);
                Constructor<?> constructor = cls.getConstructor(new Class[]{UriMatcher.class, Context.class});
                Rlog.d(TAG, "constructor function = " + constructor);
                return (IccInternalInterface) constructor.newInstance(new Object[]{uriMatcher, context});
            } catch (Exception unused) {
                Rlog.e(TAG, "No MtkIccProvider! Used AOSP for instead!");
                return null;
            }
        } else {
            Rlog.e(TAG, "No MtkIccProvider! Used AOSP for instead!");
            return null;
        }
    }

    public boolean onCreate() {
        this.mSubscriptionManager = SubscriptionManager.from(getContext());
        sMtkIccProvider = makeIccProvider(URL_MATCHER, getContext());
        return true;
    }

    public Cursor query(Uri uri, String[] strArr, String str, String[] strArr2, String str2) {
        log("query");
        IccInternalInterface iccInternalInterface = sMtkIccProvider;
        if (iccInternalInterface != null) {
            return iccInternalInterface.query(uri, strArr, str, strArr2, str2);
        }
        switch (URL_MATCHER.match(uri)) {
            case 1:
                return loadFromEf(28474, SubscriptionManager.getDefaultSubscriptionId());
            case 2:
                return loadFromEf(28474, getRequestSubId(uri));
            case 3:
                return loadFromEf(IccConstants.EF_FDN, SubscriptionManager.getDefaultSubscriptionId());
            case 4:
                return loadFromEf(IccConstants.EF_FDN, getRequestSubId(uri));
            case 5:
                return loadFromEf(IccConstants.EF_SDN, SubscriptionManager.getDefaultSubscriptionId());
            case 6:
                return loadFromEf(IccConstants.EF_SDN, getRequestSubId(uri));
            case 7:
                return loadAllSimContacts(28474);
            default:
                throw new IllegalArgumentException("Unknown URL " + uri);
        }
    }

    private Cursor loadAllSimContacts(int i) {
        Cursor[] cursorArr;
        List activeSubscriptionInfoList = this.mSubscriptionManager.getActiveSubscriptionInfoList(false);
        if (activeSubscriptionInfoList == null || activeSubscriptionInfoList.size() == 0) {
            cursorArr = new Cursor[0];
        } else {
            int size = activeSubscriptionInfoList.size();
            cursorArr = new Cursor[size];
            for (int i2 = 0; i2 < size; i2++) {
                int subscriptionId = ((SubscriptionInfo) activeSubscriptionInfoList.get(i2)).getSubscriptionId();
                cursorArr[i2] = loadFromEf(i, subscriptionId);
                Rlog.i(TAG, "ADN Records loaded for Subscription ::" + subscriptionId);
            }
        }
        return new MergeCursor(cursorArr);
    }

    public String getType(Uri uri) {
        switch (URL_MATCHER.match(uri)) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
                return "vnd.android.cursor.dir/sim-contact";
            default:
                throw new IllegalArgumentException("Unknown URL " + uri);
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:19:0x00a4 A[RETURN] */
    /* JADX WARNING: Removed duplicated region for block: B:20:0x00a5  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.net.Uri insert(android.net.Uri r17, android.content.ContentValues r18) {
        /*
            r16 = this;
            r0 = r16
            r1 = r17
            r2 = r18
            com.android.internal.telephony.IccInternalInterface r3 = sMtkIccProvider
            r4 = 0
            if (r3 == 0) goto L_0x001b
            android.net.Uri r2 = r3.insert(r1, r2)
            android.content.Context r0 = r16.getContext()
            android.content.ContentResolver r0 = r0.getContentResolver()
            r0.notifyChange(r1, r4)
            return r2
        L_0x001b:
            java.lang.String r3 = "insert"
            r0.log(r3)
            android.content.UriMatcher r3 = URL_MATCHER
            int r3 = r3.match(r1)
            r5 = 28475(0x6f3b, float:3.9902E-41)
            r6 = 28474(0x6f3a, float:3.99E-41)
            r7 = 4
            r8 = 3
            r9 = 2
            r10 = 1
            if (r3 == r10) goto L_0x0066
            if (r3 == r9) goto L_0x0061
            java.lang.String r6 = "pin2"
            if (r3 == r8) goto L_0x0058
            if (r3 != r7) goto L_0x0041
            int r11 = r16.getRequestSubId(r17)
            java.lang.String r6 = r2.getAsString(r6)
            goto L_0x006c
        L_0x0041:
            java.lang.UnsupportedOperationException r0 = new java.lang.UnsupportedOperationException
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "Cannot insert into URL: "
            r2.append(r3)
            r2.append(r1)
            java.lang.String r1 = r2.toString()
            r0.<init>(r1)
            throw r0
        L_0x0058:
            int r11 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
            java.lang.String r6 = r2.getAsString(r6)
            goto L_0x006c
        L_0x0061:
            int r11 = r16.getRequestSubId(r17)
            goto L_0x006a
        L_0x0066:
            int r11 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
        L_0x006a:
            r5 = r6
            r6 = r4
        L_0x006c:
            java.lang.String r12 = "tag"
            java.lang.String r12 = r2.getAsString(r12)
            java.lang.String r13 = "number"
            java.lang.String r13 = r2.getAsString(r13)
            java.lang.String r14 = "emails"
            java.lang.String r14 = r2.getAsString(r14)
            java.lang.String r15 = "anrs"
            java.lang.String r2 = r2.getAsString(r15)
            android.content.ContentValues r15 = new android.content.ContentValues
            r15.<init>()
            java.lang.String r7 = "newTag"
            r15.put(r7, r12)
            java.lang.String r7 = "newNumber"
            r15.put(r7, r13)
            java.lang.String r7 = "newEmails"
            r15.put(r7, r14)
            java.lang.String r7 = "newAnrs"
            r15.put(r7, r2)
            boolean r2 = r0.updateIccRecordInEf(r5, r15, r6, r11)
            if (r2 != 0) goto L_0x00a5
            return r4
        L_0x00a5:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            java.lang.String r5 = "content://icc/"
            r2.<init>(r5)
            if (r3 == r10) goto L_0x00c8
            if (r3 == r9) goto L_0x00c2
            if (r3 == r8) goto L_0x00bc
            r5 = 4
            if (r3 == r5) goto L_0x00b6
            goto L_0x00cd
        L_0x00b6:
            java.lang.String r3 = "fdn/subId/"
            r2.append(r3)
            goto L_0x00cd
        L_0x00bc:
            java.lang.String r3 = "fdn/"
            r2.append(r3)
            goto L_0x00cd
        L_0x00c2:
            java.lang.String r3 = "adn/subId/"
            r2.append(r3)
            goto L_0x00cd
        L_0x00c8:
            java.lang.String r3 = "adn/"
            r2.append(r3)
        L_0x00cd:
            r3 = 0
            r2.append(r3)
            java.lang.String r2 = r2.toString()
            android.net.Uri r2 = android.net.Uri.parse(r2)
            android.content.Context r0 = r16.getContext()
            android.content.ContentResolver r0 = r0.getContentResolver()
            r0.notifyChange(r1, r4)
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccProvider.insert(android.net.Uri, android.content.ContentValues):android.net.Uri");
    }

    private String normalizeValue(String str) {
        int length = str.length();
        if (length == 0) {
            log("len of input String is 0");
            return str;
        } else if (str.charAt(0) != '\'') {
            return str;
        } else {
            int i = length - 1;
            return str.charAt(i) == '\'' ? str.substring(1, i) : str;
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:23:0x0081  */
    /* JADX WARNING: Removed duplicated region for block: B:46:0x0130 A[RETURN] */
    /* JADX WARNING: Removed duplicated region for block: B:47:0x0131  */
    /* JADX WARNING: Removed duplicated region for block: B:52:0x0116 A[EDGE_INSN: B:52:0x0116->B:42:0x0116 ?: BREAK  , SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int delete(android.net.Uri r19, java.lang.String r20, java.lang.String[] r21) {
        /*
            r18 = this;
            r0 = r18
            r1 = r19
            r2 = r20
            com.android.internal.telephony.IccInternalInterface r3 = sMtkIccProvider
            r4 = 0
            if (r3 == 0) goto L_0x0020
            r5 = r21
            int r2 = r3.delete(r1, r2, r5)
            if (r2 > 0) goto L_0x0014
            return r2
        L_0x0014:
            android.content.Context r0 = r18.getContext()
            android.content.ContentResolver r0 = r0.getContentResolver()
            r0.notifyChange(r1, r4)
            return r2
        L_0x0020:
            android.content.UriMatcher r3 = URL_MATCHER
            int r3 = r3.match(r1)
            r5 = 28475(0x6f3b, float:3.9902E-41)
            r6 = 28474(0x6f3a, float:3.99E-41)
            r7 = 3
            r8 = 2
            r9 = 1
            if (r3 == r9) goto L_0x005c
            if (r3 == r8) goto L_0x0057
            if (r3 == r7) goto L_0x0052
            r6 = 4
            if (r3 != r6) goto L_0x003b
            int r3 = r18.getRequestSubId(r19)
            goto L_0x0061
        L_0x003b:
            java.lang.UnsupportedOperationException r0 = new java.lang.UnsupportedOperationException
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "Cannot insert into URL: "
            r2.append(r3)
            r2.append(r1)
            java.lang.String r1 = r2.toString()
            r0.<init>(r1)
            throw r0
        L_0x0052:
            int r3 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
            goto L_0x0061
        L_0x0057:
            int r3 = r18.getRequestSubId(r19)
            goto L_0x0060
        L_0x005c:
            int r3 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
        L_0x0060:
            r5 = r6
        L_0x0061:
            java.lang.String r6 = "delete"
            r0.log(r6)
            java.lang.String r6 = " AND "
            java.lang.String[] r2 = r2.split(r6)
            int r6 = r2.length
            r10 = r4
            r11 = r10
            r12 = r11
            r13 = r12
            r14 = r13
        L_0x0072:
            int r6 = r6 + -1
            java.lang.String r15 = "anrs"
            java.lang.String r4 = "emails"
            java.lang.String r7 = "number"
            java.lang.String r9 = "tag"
            r16 = 0
            if (r6 < 0) goto L_0x0116
            r8 = r2[r6]
            r20 = r2
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            r17 = r6
            java.lang.String r6 = "parsing '"
            r2.append(r6)
            r2.append(r8)
            java.lang.String r6 = "'"
            r2.append(r6)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            java.lang.String r2 = "="
            r6 = 2
            java.lang.String[] r2 = r8.split(r2, r6)
            int r1 = r2.length
            if (r1 == r6) goto L_0x00cb
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "resolve: bad whereClause parameter: "
            r1.append(r2)
            r1.append(r8)
            java.lang.String r1 = r1.toString()
            java.lang.String r2 = "IccProvider"
            com.android.telephony.Rlog.e(r2, r1)
        L_0x00c0:
            r1 = r19
            r2 = r20
            r8 = r6
            r6 = r17
            r4 = 0
            r7 = 3
            r9 = 1
            goto L_0x0072
        L_0x00cb:
            r1 = r2[r16]
            java.lang.String r1 = r1.trim()
            r8 = 1
            r2 = r2[r8]
            java.lang.String r2 = r2.trim()
            boolean r8 = r9.equals(r1)
            if (r8 == 0) goto L_0x00e4
            java.lang.String r1 = r0.normalizeValue(r2)
            r10 = r1
            goto L_0x00c0
        L_0x00e4:
            boolean r7 = r7.equals(r1)
            if (r7 == 0) goto L_0x00f0
            java.lang.String r1 = r0.normalizeValue(r2)
            r11 = r1
            goto L_0x00c0
        L_0x00f0:
            boolean r4 = r4.equals(r1)
            if (r4 == 0) goto L_0x00fc
            java.lang.String r1 = r0.normalizeValue(r2)
            r12 = r1
            goto L_0x00c0
        L_0x00fc:
            boolean r4 = r15.equals(r1)
            if (r4 == 0) goto L_0x0108
            java.lang.String r1 = r0.normalizeValue(r2)
            r13 = r1
            goto L_0x00c0
        L_0x0108:
            java.lang.String r4 = "pin2"
            boolean r1 = r4.equals(r1)
            if (r1 == 0) goto L_0x00c0
            java.lang.String r1 = r0.normalizeValue(r2)
            r14 = r1
            goto L_0x00c0
        L_0x0116:
            android.content.ContentValues r1 = new android.content.ContentValues
            r1.<init>()
            r1.put(r9, r10)
            r1.put(r7, r11)
            r1.put(r4, r12)
            r1.put(r15, r13)
            r2 = 3
            if (r5 != r2) goto L_0x0131
            boolean r2 = android.text.TextUtils.isEmpty(r14)
            if (r2 == 0) goto L_0x0131
            return r16
        L_0x0131:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r4 = "delete mvalues= "
            r2.append(r4)
            r2.append(r1)
            java.lang.String r2 = r2.toString()
            r0.log(r2)
            boolean r1 = r0.updateIccRecordInEf(r5, r1, r14, r3)
            if (r1 != 0) goto L_0x014c
            return r16
        L_0x014c:
            android.content.Context r0 = r18.getContext()
            android.content.ContentResolver r0 = r0.getContentResolver()
            r1 = r19
            r2 = 0
            r0.notifyChange(r1, r2)
            r0 = 1
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccProvider.delete(android.net.Uri, java.lang.String, java.lang.String[]):int");
    }

    /* JADX WARNING: Removed duplicated region for block: B:24:0x0070 A[RETURN] */
    /* JADX WARNING: Removed duplicated region for block: B:25:0x0072  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public int update(android.net.Uri r5, android.content.ContentValues r6, java.lang.String r7, java.lang.String[] r8) {
        /*
            r4 = this;
            com.android.internal.telephony.IccInternalInterface r0 = sMtkIccProvider
            r1 = 0
            if (r0 == 0) goto L_0x0018
            int r6 = r0.update(r5, r6, r7, r8)
            if (r6 > 0) goto L_0x000c
            return r6
        L_0x000c:
            android.content.Context r4 = r4.getContext()
            android.content.ContentResolver r4 = r4.getContentResolver()
            r4.notifyChange(r5, r1)
            return r6
        L_0x0018:
            java.lang.String r7 = "update"
            r4.log(r7)
            android.content.UriMatcher r7 = URL_MATCHER
            int r7 = r7.match(r5)
            r8 = 28475(0x6f3b, float:3.9902E-41)
            r0 = 28474(0x6f3a, float:3.99E-41)
            r2 = 1
            if (r7 == r2) goto L_0x0064
            r3 = 2
            if (r7 == r3) goto L_0x005f
            r0 = 3
            java.lang.String r3 = "pin2"
            if (r7 == r0) goto L_0x0056
            r0 = 4
            if (r7 != r0) goto L_0x003f
            int r7 = r4.getRequestSubId(r5)
            java.lang.String r0 = r6.getAsString(r3)
            goto L_0x006a
        L_0x003f:
            java.lang.UnsupportedOperationException r4 = new java.lang.UnsupportedOperationException
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "Cannot insert into URL: "
            r6.append(r7)
            r6.append(r5)
            java.lang.String r5 = r6.toString()
            r4.<init>(r5)
            throw r4
        L_0x0056:
            int r7 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
            java.lang.String r0 = r6.getAsString(r3)
            goto L_0x006a
        L_0x005f:
            int r7 = r4.getRequestSubId(r5)
            goto L_0x0068
        L_0x0064:
            int r7 = android.telephony.SubscriptionManager.getDefaultSubscriptionId()
        L_0x0068:
            r8 = r0
            r0 = r1
        L_0x006a:
            boolean r6 = r4.updateIccRecordInEf(r8, r6, r0, r7)
            if (r6 != 0) goto L_0x0072
            r4 = 0
            return r4
        L_0x0072:
            android.content.Context r4 = r4.getContext()
            android.content.ContentResolver r4 = r4.getContentResolver()
            r4.notifyChange(r5, r1)
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccProvider.update(android.net.Uri, android.content.ContentValues, java.lang.String, java.lang.String[]):int");
    }

    private MatrixCursor loadFromEf(int i, int i2) {
        log("loadFromEf: efType=0x" + Integer.toHexString(i).toUpperCase() + ", subscription=" + i2);
        List<AdnRecord> list = null;
        try {
            IIccPhoneBook asInterface = IIccPhoneBook.Stub.asInterface(TelephonyFrameworkInitializer.getTelephonyServiceManager().getIccPhoneBookServiceRegisterer().get());
            if (asInterface != null) {
                list = asInterface.getAdnRecordsInEfForSubscriber(i2, i);
            }
        } catch (RemoteException unused) {
        } catch (SecurityException e) {
            log(e.toString());
        }
        if (list != null) {
            int size = list.size();
            MatrixCursor matrixCursor = new MatrixCursor(ADDRESS_BOOK_COLUMN_NAMES, size);
            log("adnRecords.size=" + size);
            for (int i3 = 0; i3 < size; i3++) {
                loadRecord(list.get(i3), matrixCursor, i3);
            }
            return matrixCursor;
        }
        Rlog.w(TAG, "Cannot load ADN records");
        return new MatrixCursor(ADDRESS_BOOK_COLUMN_NAMES);
    }

    private boolean updateIccRecordInEf(int i, ContentValues contentValues, String str, int i2) {
        log("updateIccRecordInEf: efType=" + i + ", values: [ " + contentValues + "  ], subId:" + i2);
        boolean z = false;
        try {
            IIccPhoneBook asInterface = IIccPhoneBook.Stub.asInterface(TelephonyFrameworkInitializer.getTelephonyServiceManager().getIccPhoneBookServiceRegisterer().get());
            if (asInterface != null) {
                z = asInterface.updateAdnRecordsInEfBySearchForSubscriber(i2, i, contentValues, str);
            }
        } catch (RemoteException unused) {
        } catch (SecurityException e) {
            log(e.toString());
        }
        log("updateIccRecordInEf: " + z);
        return z;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void loadRecord(AdnRecord adnRecord, MatrixCursor matrixCursor, int i) {
        if (!adnRecord.isEmpty()) {
            Object[] objArr = new Object[5];
            String alphaTag = adnRecord.getAlphaTag();
            String number = adnRecord.getNumber();
            log("loadRecord: " + alphaTag + ", " + Rlog.pii(TAG, number));
            objArr[0] = alphaTag;
            objArr[1] = number;
            String[] emails = adnRecord.getEmails();
            if (emails != null) {
                StringBuilder sb = new StringBuilder();
                for (String str : emails) {
                    log("Adding email:" + Rlog.pii(TAG, str));
                    sb.append(str);
                    sb.append(",");
                }
                objArr[2] = sb.toString();
            }
            String[] additionalNumbers = adnRecord.getAdditionalNumbers();
            if (additionalNumbers != null) {
                StringBuilder sb2 = new StringBuilder();
                for (String str2 : additionalNumbers) {
                    log("Adding anr:" + str2);
                    sb2.append(str2);
                    sb2.append(":");
                }
                objArr[3] = sb2.toString();
            }
            objArr[4] = Integer.valueOf(i);
            matrixCursor.addRow(objArr);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void log(String str) {
        Rlog.d(TAG, "[IccProvider] " + str);
    }

    private int getRequestSubId(Uri uri) {
        log("getRequestSubId url: " + uri);
        try {
            return Integer.parseInt(uri.getLastPathSegment());
        } catch (NumberFormatException unused) {
            throw new IllegalArgumentException("Unknown URL " + uri);
        }
    }
}
