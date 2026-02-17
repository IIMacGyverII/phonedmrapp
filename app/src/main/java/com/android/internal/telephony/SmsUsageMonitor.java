package com.android.internal.telephony;

import android.app.role.RoleManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.XmlResourceParser;
import android.database.ContentObserver;
import android.os.Binder;
import android.os.Handler;
import android.os.UserHandle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.AtomicFile;
import com.android.internal.telephony.util.XmlUtils;
import com.android.telephony.Rlog;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Pattern;
import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

public class SmsUsageMonitor {
    private static final String ATTR_COUNTRY = "country";
    private static final String ATTR_FREE = "free";
    private static final String ATTR_PACKAGE_NAME = "name";
    private static final String ATTR_PACKAGE_SMS_POLICY = "sms-policy";
    private static final String ATTR_PATTERN = "pattern";
    private static final String ATTR_PREMIUM = "premium";
    private static final String ATTR_STANDARD = "standard";
    private static final boolean DBG = false;
    private static final int DEFAULT_SMS_CHECK_PERIOD = 60000;
    private static final int DEFAULT_SMS_MAX_COUNT = 30;
    public static final int PREMIUM_SMS_PERMISSION_ALWAYS_ALLOW = 3;
    public static final int PREMIUM_SMS_PERMISSION_ASK_USER = 1;
    public static final int PREMIUM_SMS_PERMISSION_NEVER_ALLOW = 2;
    public static final int PREMIUM_SMS_PERMISSION_UNKNOWN = 0;
    private static final String SHORT_CODE_PATH = "/data/misc/sms/codes";
    private static final String SMS_POLICY_FILE_DIRECTORY = "/data/misc/sms";
    private static final String SMS_POLICY_FILE_NAME = "premium_sms_policy.xml";
    private static final String TAG = "SmsUsageMonitor";
    private static final String TAG_PACKAGE = "package";
    private static final String TAG_SHORTCODE = "shortcode";
    private static final String TAG_SHORTCODES = "shortcodes";
    private static final String TAG_SMS_POLICY_BODY = "premium-sms-policy";
    private static final boolean VDBG = false;
    private final AtomicBoolean mCheckEnabled;
    private final int mCheckPeriod;
    private final Context mContext;
    private String mCurrentCountry;
    private ShortCodePatternMatcher mCurrentPatternMatcher;
    private final int mMaxAllowed;
    private final File mPatternFile;
    private long mPatternFileLastModified;
    private AtomicFile mPolicyFile;
    private final HashMap<String, Integer> mPremiumSmsPolicy;
    private RoleManager mRoleManager;
    private final SettingsObserverHandler mSettingsObserverHandler;
    private final HashMap<String, ArrayList<Long>> mSmsStamp = new HashMap<>();

    public static int mergeShortCodeCategories(int i, int i2) {
        return i > i2 ? i : i2;
    }

    private static final class ShortCodePatternMatcher {
        private final Pattern mFreeShortCodePattern;
        private final Pattern mPremiumShortCodePattern;
        private final Pattern mShortCodePattern;
        private final Pattern mStandardShortCodePattern;

        ShortCodePatternMatcher(String str, String str2, String str3, String str4) {
            Pattern pattern = null;
            this.mShortCodePattern = str != null ? Pattern.compile(str) : null;
            this.mPremiumShortCodePattern = str2 != null ? Pattern.compile(str2) : null;
            this.mFreeShortCodePattern = str3 != null ? Pattern.compile(str3) : null;
            this.mStandardShortCodePattern = str4 != null ? Pattern.compile(str4) : pattern;
        }

        /* access modifiers changed from: package-private */
        public int getNumberCategory(String str) {
            Pattern pattern = this.mFreeShortCodePattern;
            if (pattern != null && pattern.matcher(str).matches()) {
                return 1;
            }
            Pattern pattern2 = this.mStandardShortCodePattern;
            if (pattern2 != null && pattern2.matcher(str).matches()) {
                return 2;
            }
            Pattern pattern3 = this.mPremiumShortCodePattern;
            if (pattern3 != null && pattern3.matcher(str).matches()) {
                return 4;
            }
            Pattern pattern4 = this.mShortCodePattern;
            return (pattern4 == null || !pattern4.matcher(str).matches()) ? 0 : 3;
        }
    }

    private static class SettingsObserver extends ContentObserver {
        private final Context mContext;
        private final AtomicBoolean mEnabled;

        SettingsObserver(Handler handler, Context context, AtomicBoolean atomicBoolean) {
            super(handler);
            this.mContext = context;
            this.mEnabled = atomicBoolean;
            onChange(false);
        }

        public void onChange(boolean z) {
            AtomicBoolean atomicBoolean = this.mEnabled;
            boolean z2 = true;
            if (Settings.Global.getInt(this.mContext.getContentResolver(), "sms_short_code_confirmation", 1) == 0) {
                z2 = false;
            }
            atomicBoolean.set(z2);
        }
    }

    private static class SettingsObserverHandler extends Handler {
        SettingsObserverHandler(Context context, AtomicBoolean atomicBoolean) {
            context.getContentResolver().registerContentObserver(Settings.Global.getUriFor("sms_short_code_confirmation"), false, new SettingsObserver(this, context, atomicBoolean));
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public SmsUsageMonitor(Context context) {
        AtomicBoolean atomicBoolean = new AtomicBoolean(true);
        this.mCheckEnabled = atomicBoolean;
        this.mPatternFile = new File(SHORT_CODE_PATH);
        this.mPatternFileLastModified = 0;
        this.mPremiumSmsPolicy = new HashMap<>();
        this.mContext = context;
        ContentResolver contentResolver = context.getContentResolver();
        this.mRoleManager = (RoleManager) context.getSystemService("role");
        this.mMaxAllowed = Settings.Global.getInt(contentResolver, "sms_outgoing_check_max_count", 30);
        this.mCheckPeriod = Settings.Global.getInt(contentResolver, "sms_outgoing_check_interval_ms", 60000);
        this.mSettingsObserverHandler = new SettingsObserverHandler(context, atomicBoolean);
        loadPremiumSmsPolicyDb();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:18:0x0034, code lost:
        if (r2 != null) goto L_0x0036;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:20:?, code lost:
        r2.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:28:0x0048, code lost:
        if (r2 != null) goto L_0x0036;
     */
    /* JADX WARNING: Removed duplicated region for block: B:35:0x0058 A[SYNTHETIC, Splitter:B:35:0x0058] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private com.android.internal.telephony.SmsUsageMonitor.ShortCodePatternMatcher getPatternMatcherFromFile(java.lang.String r6) {
        /*
            r5 = this;
            java.lang.String r0 = "SmsUsageMonitor"
            r1 = 0
            java.io.FileReader r2 = new java.io.FileReader     // Catch:{ FileNotFoundException -> 0x003a, XmlPullParserException -> 0x0025, all -> 0x0023 }
            java.io.File r3 = r5.mPatternFile     // Catch:{ FileNotFoundException -> 0x003a, XmlPullParserException -> 0x0025, all -> 0x0023 }
            r2.<init>(r3)     // Catch:{ FileNotFoundException -> 0x003a, XmlPullParserException -> 0x0025, all -> 0x0023 }
            org.xmlpull.v1.XmlPullParser r3 = android.util.Xml.newPullParser()     // Catch:{ FileNotFoundException -> 0x003b, XmlPullParserException -> 0x0021 }
            r3.setInput(r2)     // Catch:{ FileNotFoundException -> 0x003b, XmlPullParserException -> 0x0021 }
            com.android.internal.telephony.SmsUsageMonitor$ShortCodePatternMatcher r6 = r5.getPatternMatcherFromXmlParser(r3, r6)     // Catch:{ FileNotFoundException -> 0x003b, XmlPullParserException -> 0x0021 }
            java.io.File r0 = r5.mPatternFile
            long r0 = r0.lastModified()
            r5.mPatternFileLastModified = r0
            r2.close()     // Catch:{ IOException -> 0x0020 }
        L_0x0020:
            return r6
        L_0x0021:
            r6 = move-exception
            goto L_0x0027
        L_0x0023:
            r6 = move-exception
            goto L_0x004e
        L_0x0025:
            r6 = move-exception
            r2 = r1
        L_0x0027:
            java.lang.String r3 = "XML parser exception reading short code pattern file"
            com.android.telephony.Rlog.e(r0, r3, r6)     // Catch:{ all -> 0x004c }
            java.io.File r6 = r5.mPatternFile
            long r3 = r6.lastModified()
            r5.mPatternFileLastModified = r3
            if (r2 == 0) goto L_0x004b
        L_0x0036:
            r2.close()     // Catch:{ IOException -> 0x004b }
            goto L_0x004b
        L_0x003a:
            r2 = r1
        L_0x003b:
            java.lang.String r6 = "Short Code Pattern File not found"
            com.android.telephony.Rlog.e(r0, r6)     // Catch:{ all -> 0x004c }
            java.io.File r6 = r5.mPatternFile
            long r3 = r6.lastModified()
            r5.mPatternFileLastModified = r3
            if (r2 == 0) goto L_0x004b
            goto L_0x0036
        L_0x004b:
            return r1
        L_0x004c:
            r6 = move-exception
            r1 = r2
        L_0x004e:
            java.io.File r0 = r5.mPatternFile
            long r2 = r0.lastModified()
            r5.mPatternFileLastModified = r2
            if (r1 == 0) goto L_0x005b
            r1.close()     // Catch:{ IOException -> 0x005b }
        L_0x005b:
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SmsUsageMonitor.getPatternMatcherFromFile(java.lang.String):com.android.internal.telephony.SmsUsageMonitor$ShortCodePatternMatcher");
    }

    private ShortCodePatternMatcher getPatternMatcherFromResource(String str) {
        XmlResourceParser xmlResourceParser = null;
        try {
            xmlResourceParser = this.mContext.getResources().getXml(18284565);
            return getPatternMatcherFromXmlParser(xmlResourceParser, str);
        } finally {
            if (xmlResourceParser != null) {
                xmlResourceParser.close();
            }
        }
    }

    private ShortCodePatternMatcher getPatternMatcherFromXmlParser(XmlPullParser xmlPullParser, String str) {
        try {
            XmlUtils.beginDocument(xmlPullParser, TAG_SHORTCODES);
            while (true) {
                XmlUtils.nextElement(xmlPullParser);
                String name = xmlPullParser.getName();
                if (name == null) {
                    Rlog.e(TAG, "Parsing pattern data found null");
                    break;
                } else if (!name.equals(TAG_SHORTCODE)) {
                    Rlog.e(TAG, "Error: skipping unknown XML tag " + name);
                } else if (str.equals(xmlPullParser.getAttributeValue((String) null, ATTR_COUNTRY))) {
                    return new ShortCodePatternMatcher(xmlPullParser.getAttributeValue((String) null, ATTR_PATTERN), xmlPullParser.getAttributeValue((String) null, ATTR_PREMIUM), xmlPullParser.getAttributeValue((String) null, ATTR_FREE), xmlPullParser.getAttributeValue((String) null, ATTR_STANDARD));
                }
            }
        } catch (XmlPullParserException e) {
            Rlog.e(TAG, "XML parser exception reading short code patterns", e);
        } catch (IOException e2) {
            Rlog.e(TAG, "I/O exception reading short code patterns", e2);
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        this.mSmsStamp.clear();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean check(String str, int i) {
        synchronized (this.mSmsStamp) {
            removeExpiredTimestamps();
            ArrayList arrayList = this.mSmsStamp.get(str);
            if (arrayList == null) {
                arrayList = new ArrayList();
                this.mSmsStamp.put(str, arrayList);
            }
            if (this.mRoleManager.getRoleHolders("android.app.role.SMS").contains(str)) {
                return true;
            }
            boolean isUnderLimit = isUnderLimit(arrayList, i);
            return isUnderLimit;
        }
    }

    public int checkDestination(String str, String str2) {
        String str3;
        synchronized (this.mSettingsObserverHandler) {
            if (((TelephonyManager) this.mContext.getSystemService(TelephonyManager.class)).isEmergencyNumber(str)) {
                return 0;
            }
            if (!this.mCheckEnabled.get()) {
                return 0;
            }
            if (str2 != null && ((str3 = this.mCurrentCountry) == null || !str2.equals(str3) || this.mPatternFile.lastModified() != this.mPatternFileLastModified)) {
                if (this.mPatternFile.exists()) {
                    this.mCurrentPatternMatcher = getPatternMatcherFromFile(str2);
                } else {
                    this.mCurrentPatternMatcher = getPatternMatcherFromResource(str2);
                }
                this.mCurrentCountry = str2;
            }
            ShortCodePatternMatcher shortCodePatternMatcher = this.mCurrentPatternMatcher;
            if (shortCodePatternMatcher != null) {
                int numberCategory = shortCodePatternMatcher.getNumberCategory(str);
                return numberCategory;
            }
            Rlog.e(TAG, "No patterns for \"" + str2 + "\": using generic short code rule");
            if (str.length() <= 5) {
                return 3;
            }
            return 0;
        }
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(4:42|(2:60|61)|62|63) */
    /* JADX WARNING: Code restructure failed: missing block: B:32:0x00af, code lost:
        r8 = th;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:33:0x00b0, code lost:
        r1 = r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:34:0x00b2, code lost:
        r8 = e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x00b3, code lost:
        r1 = r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x00b5, code lost:
        r8 = e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:37:0x00b6, code lost:
        r1 = r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:38:0x00b8, code lost:
        r8 = e;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:39:0x00b9, code lost:
        r1 = r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:40:0x00bb, code lost:
        r1 = r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:47:0x00c7, code lost:
        if (r1 != null) goto L_0x00c9;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:58:0x00e0, code lost:
        if (r1 != null) goto L_0x00c9;
     */
    /* JADX WARNING: Failed to process nested try/catch */
    /* JADX WARNING: Missing exception handler attribute for start block: B:62:0x00e8 */
    /* JADX WARNING: Removed duplicated region for block: B:32:0x00af A[ExcHandler: all (th java.lang.Throwable), Splitter:B:9:0x0028] */
    /* JADX WARNING: Removed duplicated region for block: B:34:0x00b2 A[ExcHandler: XmlPullParserException (e org.xmlpull.v1.XmlPullParserException), Splitter:B:9:0x0028] */
    /* JADX WARNING: Removed duplicated region for block: B:38:0x00b8 A[ExcHandler: IOException (e java.io.IOException), Splitter:B:9:0x0028] */
    /* JADX WARNING: Removed duplicated region for block: B:41:? A[ExcHandler: FileNotFoundException (unused java.io.FileNotFoundException), SYNTHETIC, Splitter:B:9:0x0028] */
    /* JADX WARNING: Removed duplicated region for block: B:55:0x00d7 A[Catch:{ FileNotFoundException -> 0x00e9, IOException -> 0x00d8, NumberFormatException -> 0x00cd, XmlPullParserException -> 0x00bf, all -> 0x00bd }] */
    /* JADX WARNING: Removed duplicated region for block: B:60:0x00e5 A[SYNTHETIC, Splitter:B:60:0x00e5] */
    /* JADX WARNING: Removed duplicated region for block: B:66:0x00eb  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void loadPremiumSmsPolicyDb() {
        /*
            r8 = this;
            java.util.HashMap<java.lang.String, java.lang.Integer> r0 = r8.mPremiumSmsPolicy
            monitor-enter(r0)
            android.util.AtomicFile r1 = r8.mPolicyFile     // Catch:{ all -> 0x00ee }
            if (r1 != 0) goto L_0x00ec
            java.io.File r1 = new java.io.File     // Catch:{ all -> 0x00ee }
            java.lang.String r2 = "/data/misc/sms"
            r1.<init>(r2)     // Catch:{ all -> 0x00ee }
            android.util.AtomicFile r2 = new android.util.AtomicFile     // Catch:{ all -> 0x00ee }
            java.io.File r3 = new java.io.File     // Catch:{ all -> 0x00ee }
            java.lang.String r4 = "premium_sms_policy.xml"
            r3.<init>(r1, r4)     // Catch:{ all -> 0x00ee }
            r2.<init>(r3)     // Catch:{ all -> 0x00ee }
            r8.mPolicyFile = r2     // Catch:{ all -> 0x00ee }
            java.util.HashMap<java.lang.String, java.lang.Integer> r1 = r8.mPremiumSmsPolicy     // Catch:{ all -> 0x00ee }
            r1.clear()     // Catch:{ all -> 0x00ee }
            r1 = 0
            android.util.AtomicFile r2 = r8.mPolicyFile     // Catch:{ FileNotFoundException -> 0x00e9, IOException -> 0x00d8, NumberFormatException -> 0x00cd, XmlPullParserException -> 0x00bf }
            java.io.FileInputStream r2 = r2.openRead()     // Catch:{ FileNotFoundException -> 0x00e9, IOException -> 0x00d8, NumberFormatException -> 0x00cd, XmlPullParserException -> 0x00bf }
            org.xmlpull.v1.XmlPullParser r3 = android.util.Xml.newPullParser()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.nio.charset.Charset r4 = java.nio.charset.StandardCharsets.UTF_8     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r4 = r4.name()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r3.setInput(r2, r4)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r4 = "premium-sms-policy"
            com.android.internal.telephony.util.XmlUtils.beginDocument(r3, r4)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
        L_0x003a:
            com.android.internal.telephony.util.XmlUtils.nextElement(r3)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r4 = r3.getName()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            if (r4 != 0) goto L_0x004a
            if (r2 == 0) goto L_0x00ec
            r2.close()     // Catch:{ IOException -> 0x00ec }
            goto L_0x00ec
        L_0x004a:
            java.lang.String r5 = "package"
            boolean r5 = r4.equals(r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            if (r5 == 0) goto L_0x0098
            java.lang.String r4 = "name"
            java.lang.String r4 = r3.getAttributeValue(r1, r4)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r5 = "sms-policy"
            java.lang.String r5 = r3.getAttributeValue(r1, r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            if (r4 != 0) goto L_0x0069
            java.lang.String r4 = "SmsUsageMonitor"
            java.lang.String r5 = "Error: missing package name attribute"
            com.android.telephony.Rlog.e(r4, r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            goto L_0x003a
        L_0x0069:
            if (r5 != 0) goto L_0x0073
            java.lang.String r4 = "SmsUsageMonitor"
            java.lang.String r5 = "Error: missing package policy attribute"
            com.android.telephony.Rlog.e(r4, r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            goto L_0x003a
        L_0x0073:
            java.util.HashMap<java.lang.String, java.lang.Integer> r6 = r8.mPremiumSmsPolicy     // Catch:{ NumberFormatException -> 0x0081, FileNotFoundException -> 0x00bb, IOException -> 0x00b8, XmlPullParserException -> 0x00b2, all -> 0x00af }
            int r7 = java.lang.Integer.parseInt(r5)     // Catch:{ NumberFormatException -> 0x0081, FileNotFoundException -> 0x00bb, IOException -> 0x00b8, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.Integer r7 = java.lang.Integer.valueOf(r7)     // Catch:{ NumberFormatException -> 0x0081, FileNotFoundException -> 0x00bb, IOException -> 0x00b8, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r6.put(r4, r7)     // Catch:{ NumberFormatException -> 0x0081, FileNotFoundException -> 0x00bb, IOException -> 0x00b8, XmlPullParserException -> 0x00b2, all -> 0x00af }
            goto L_0x003a
        L_0x0081:
            java.lang.String r4 = "SmsUsageMonitor"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r6.<init>()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r7 = "Error: non-numeric policy type "
            r6.append(r7)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r6.append(r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r5 = r6.toString()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            com.android.telephony.Rlog.e(r4, r5)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            goto L_0x003a
        L_0x0098:
            java.lang.String r5 = "SmsUsageMonitor"
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r6.<init>()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r7 = "Error: skipping unknown XML tag "
            r6.append(r7)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            r6.append(r4)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            java.lang.String r4 = r6.toString()     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            com.android.telephony.Rlog.e(r5, r4)     // Catch:{ FileNotFoundException -> 0x00bb, IOException -> 0x00b8, NumberFormatException -> 0x00b5, XmlPullParserException -> 0x00b2, all -> 0x00af }
            goto L_0x003a
        L_0x00af:
            r8 = move-exception
            r1 = r2
            goto L_0x00e3
        L_0x00b2:
            r8 = move-exception
            r1 = r2
            goto L_0x00c0
        L_0x00b5:
            r8 = move-exception
            r1 = r2
            goto L_0x00ce
        L_0x00b8:
            r8 = move-exception
            r1 = r2
            goto L_0x00d9
        L_0x00bb:
            r1 = r2
            goto L_0x00e9
        L_0x00bd:
            r8 = move-exception
            goto L_0x00e3
        L_0x00bf:
            r8 = move-exception
        L_0x00c0:
            java.lang.String r2 = "SmsUsageMonitor"
            java.lang.String r3 = "Unable to parse premium SMS policy database"
            com.android.telephony.Rlog.e(r2, r3, r8)     // Catch:{ all -> 0x00bd }
            if (r1 == 0) goto L_0x00ec
        L_0x00c9:
            r1.close()     // Catch:{ IOException -> 0x00ec }
            goto L_0x00ec
        L_0x00cd:
            r8 = move-exception
        L_0x00ce:
            java.lang.String r2 = "SmsUsageMonitor"
            java.lang.String r3 = "Unable to parse premium SMS policy database"
            com.android.telephony.Rlog.e(r2, r3, r8)     // Catch:{ all -> 0x00bd }
            if (r1 == 0) goto L_0x00ec
            goto L_0x00c9
        L_0x00d8:
            r8 = move-exception
        L_0x00d9:
            java.lang.String r2 = "SmsUsageMonitor"
            java.lang.String r3 = "Unable to read premium SMS policy database"
            com.android.telephony.Rlog.e(r2, r3, r8)     // Catch:{ all -> 0x00bd }
            if (r1 == 0) goto L_0x00ec
            goto L_0x00c9
        L_0x00e3:
            if (r1 == 0) goto L_0x00e8
            r1.close()     // Catch:{ IOException -> 0x00e8 }
        L_0x00e8:
            throw r8     // Catch:{ all -> 0x00ee }
        L_0x00e9:
            if (r1 == 0) goto L_0x00ec
            goto L_0x00c9
        L_0x00ec:
            monitor-exit(r0)     // Catch:{ all -> 0x00ee }
            return
        L_0x00ee:
            r8 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x00ee }
            throw r8
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SmsUsageMonitor.loadPremiumSmsPolicyDb():void");
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Removed duplicated region for block: B:19:0x007d  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void writePremiumSmsPolicyDb() {
        /*
            r9 = this;
            java.util.HashMap<java.lang.String, java.lang.Integer> r0 = r9.mPremiumSmsPolicy
            monitor-enter(r0)
            r1 = 0
            android.util.AtomicFile r2 = r9.mPolicyFile     // Catch:{ IOException -> 0x0070 }
            java.io.FileOutputStream r2 = r2.startWrite()     // Catch:{ IOException -> 0x0070 }
            com.android.internal.telephony.FastXmlSerializer r3 = new com.android.internal.telephony.FastXmlSerializer     // Catch:{ IOException -> 0x006c }
            r3.<init>()     // Catch:{ IOException -> 0x006c }
            java.nio.charset.Charset r4 = java.nio.charset.StandardCharsets.UTF_8     // Catch:{ IOException -> 0x006c }
            java.lang.String r4 = r4.name()     // Catch:{ IOException -> 0x006c }
            r3.setOutput(r2, r4)     // Catch:{ IOException -> 0x006c }
            java.lang.Boolean r4 = java.lang.Boolean.TRUE     // Catch:{ IOException -> 0x006c }
            r3.startDocument(r1, r4)     // Catch:{ IOException -> 0x006c }
            java.lang.String r4 = "premium-sms-policy"
            r3.startTag(r1, r4)     // Catch:{ IOException -> 0x006c }
            java.util.HashMap<java.lang.String, java.lang.Integer> r4 = r9.mPremiumSmsPolicy     // Catch:{ IOException -> 0x006c }
            java.util.Set r4 = r4.entrySet()     // Catch:{ IOException -> 0x006c }
            java.util.Iterator r4 = r4.iterator()     // Catch:{ IOException -> 0x006c }
        L_0x002c:
            boolean r5 = r4.hasNext()     // Catch:{ IOException -> 0x006c }
            if (r5 == 0) goto L_0x005e
            java.lang.Object r5 = r4.next()     // Catch:{ IOException -> 0x006c }
            java.util.Map$Entry r5 = (java.util.Map.Entry) r5     // Catch:{ IOException -> 0x006c }
            java.lang.String r6 = "package"
            r3.startTag(r1, r6)     // Catch:{ IOException -> 0x006c }
            java.lang.String r6 = "name"
            java.lang.Object r7 = r5.getKey()     // Catch:{ IOException -> 0x006c }
            java.lang.String r7 = (java.lang.String) r7     // Catch:{ IOException -> 0x006c }
            r3.attribute(r1, r6, r7)     // Catch:{ IOException -> 0x006c }
            java.lang.String r6 = "sms-policy"
            java.lang.Object r5 = r5.getValue()     // Catch:{ IOException -> 0x006c }
            java.lang.Integer r5 = (java.lang.Integer) r5     // Catch:{ IOException -> 0x006c }
            java.lang.String r5 = r5.toString()     // Catch:{ IOException -> 0x006c }
            r3.attribute(r1, r6, r5)     // Catch:{ IOException -> 0x006c }
            java.lang.String r5 = "package"
            r3.endTag(r1, r5)     // Catch:{ IOException -> 0x006c }
            goto L_0x002c
        L_0x005e:
            java.lang.String r4 = "premium-sms-policy"
            r3.endTag(r1, r4)     // Catch:{ IOException -> 0x006c }
            r3.endDocument()     // Catch:{ IOException -> 0x006c }
            android.util.AtomicFile r1 = r9.mPolicyFile     // Catch:{ IOException -> 0x006c }
            r1.finishWrite(r2)     // Catch:{ IOException -> 0x006c }
            goto L_0x0082
        L_0x006c:
            r1 = move-exception
            goto L_0x0074
        L_0x006e:
            r9 = move-exception
            goto L_0x0084
        L_0x0070:
            r2 = move-exception
            r8 = r2
            r2 = r1
            r1 = r8
        L_0x0074:
            java.lang.String r3 = "SmsUsageMonitor"
            java.lang.String r4 = "Unable to write premium SMS policy database"
            com.android.telephony.Rlog.e(r3, r4, r1)     // Catch:{ all -> 0x006e }
            if (r2 == 0) goto L_0x0082
            android.util.AtomicFile r9 = r9.mPolicyFile     // Catch:{ all -> 0x006e }
            r9.failWrite(r2)     // Catch:{ all -> 0x006e }
        L_0x0082:
            monitor-exit(r0)     // Catch:{ all -> 0x006e }
            return
        L_0x0084:
            monitor-exit(r0)     // Catch:{ all -> 0x006e }
            throw r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SmsUsageMonitor.writePremiumSmsPolicyDb():void");
    }

    public int getPremiumSmsPermission(String str) {
        checkCallerIsSystemOrPhoneOrSameApp(str);
        synchronized (this.mPremiumSmsPolicy) {
            Integer num = this.mPremiumSmsPolicy.get(str);
            if (num == null) {
                return 0;
            }
            int intValue = num.intValue();
            return intValue;
        }
    }

    public void setPremiumSmsPermission(String str, int i) {
        checkCallerIsSystemOrPhoneApp();
        if (i < 1 || i > 3) {
            throw new IllegalArgumentException("invalid SMS permission type " + i);
        }
        synchronized (this.mPremiumSmsPolicy) {
            this.mPremiumSmsPolicy.put(str, Integer.valueOf(i));
        }
        new Thread(new Runnable() {
            public void run() {
                SmsUsageMonitor.this.writePremiumSmsPolicyDb();
            }
        }).start();
    }

    private void checkCallerIsSystemOrPhoneOrSameApp(String str) {
        int callingUid = Binder.getCallingUid();
        int appId = UserHandle.getAppId(callingUid);
        if (appId != 1000 && appId != 1001 && callingUid != 0) {
            String str2 = "Calling uid " + callingUid + " gave package " + str + " which is either unknown or owned by another uid";
            try {
                if (UserHandle.getAppId(this.mContext.getPackageManager().getApplicationInfoAsUser(str, 0, UserHandle.getUserHandleForUid(callingUid)).uid) != UserHandle.getAppId(callingUid)) {
                    throw new SecurityException(str2);
                }
            } catch (PackageManager.NameNotFoundException unused) {
                throw new SecurityException(str2);
            }
        }
    }

    private static void checkCallerIsSystemOrPhoneApp() {
        int callingUid = Binder.getCallingUid();
        int appId = UserHandle.getAppId(callingUid);
        if (appId != 1000 && appId != 1001 && callingUid != 0) {
            throw new SecurityException("Disallowed call for uid " + callingUid);
        }
    }

    private void removeExpiredTimestamps() {
        long currentTimeMillis = System.currentTimeMillis() - ((long) this.mCheckPeriod);
        synchronized (this.mSmsStamp) {
            Iterator<Map.Entry<String, ArrayList<Long>>> it = this.mSmsStamp.entrySet().iterator();
            while (it.hasNext()) {
                ArrayList arrayList = (ArrayList) it.next().getValue();
                if (arrayList.isEmpty() || ((Long) arrayList.get(arrayList.size() - 1)).longValue() < currentTimeMillis) {
                    it.remove();
                }
            }
        }
    }

    private boolean isUnderLimit(ArrayList<Long> arrayList, int i) {
        int i2;
        Long valueOf = Long.valueOf(System.currentTimeMillis());
        long longValue = valueOf.longValue() - ((long) this.mCheckPeriod);
        while (true) {
            if (!arrayList.isEmpty() && arrayList.get(0).longValue() < longValue) {
                arrayList.remove(0);
            }
        }
        if (arrayList.size() + i > this.mMaxAllowed) {
            return false;
        }
        for (i2 = 0; i2 < i; i2++) {
            arrayList.add(valueOf);
        }
        return true;
    }

    private static void log(String str) {
        Rlog.d(TAG, str);
    }
}
