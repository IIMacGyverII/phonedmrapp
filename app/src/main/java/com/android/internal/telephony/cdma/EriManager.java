package com.android.internal.telephony.cdma;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.util.HashMap;

public class EriManager {
    private static final boolean DBG = true;
    static final int ERI_FROM_FILE_SYSTEM = 1;
    static final int ERI_FROM_MODEM = 2;
    public static final int ERI_FROM_XML = 0;
    private static final String LOG_TAG = "EriManager";
    private static final boolean VDBG = false;
    private Context mContext;
    private EriFile mEriFile;
    private int mEriFileSource = 0;
    private boolean mIsEriFileLoaded;
    private final Phone mPhone;

    private void loadEriFileFromFileSystem() {
    }

    private void loadEriFileFromModem() {
    }

    class EriFile {
        String[] mCallPromptId = {"", "", ""};
        int mEriFileType = -1;
        int mNumberOfEriEntries = 0;
        HashMap<Integer, EriInfo> mRoamIndTable = new HashMap<>();
        int mVersionNumber = -1;

        EriFile() {
        }
    }

    class EriDisplayInformation {
        int mEriIconIndex;
        int mEriIconMode;
        @UnsupportedAppUsage
        String mEriIconText;

        EriDisplayInformation(int i, int i2, String str) {
            this.mEriIconIndex = i;
            this.mEriIconMode = i2;
            this.mEriIconText = str;
        }

        public String toString() {
            return "EriDisplayInformation: { IconIndex: " + this.mEriIconIndex + " EriIconMode: " + this.mEriIconMode + " EriIconText: " + this.mEriIconText + " }";
        }
    }

    public EriManager(Phone phone, int i) {
        this.mPhone = phone;
        this.mContext = phone.getContext();
        this.mEriFileSource = i;
        this.mEriFile = new EriFile();
    }

    public void dispose() {
        this.mEriFile = new EriFile();
        this.mIsEriFileLoaded = false;
    }

    public void loadEriFile() {
        int i = this.mEriFileSource;
        if (i == 1) {
            loadEriFileFromFileSystem();
        } else if (i != 2) {
            loadEriFileFromXml();
        } else {
            loadEriFileFromModem();
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:18:0x004a, code lost:
        r0 = r0.getConfigForSubId(r1.mPhone.getSubId());
     */
    /* JADX WARNING: Removed duplicated region for block: B:16:0x003e  */
    /* JADX WARNING: Removed duplicated region for block: B:37:0x00ed A[Catch:{ Exception -> 0x01df, all -> 0x01dd }] */
    /* JADX WARNING: Removed duplicated region for block: B:41:0x013d  */
    /* JADX WARNING: Removed duplicated region for block: B:45:0x0149 A[SYNTHETIC, Splitter:B:45:0x0149] */
    /* JADX WARNING: Removed duplicated region for block: B:76:0x00e7 A[EDGE_INSN: B:76:0x00e7->B:35:0x00e7 ?: BREAK  , SYNTHETIC] */
    /* JADX WARNING: Removed duplicated region for block: B:82:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void loadEriFileFromXml() {
        /*
            r17 = this;
            r1 = r17
            java.lang.String r2 = "CallPromptId"
            java.lang.String r3 = "EriManager"
            android.content.Context r0 = r1.mContext
            android.content.res.Resources r0 = r0.getResources()
            r4 = 0
            java.lang.String r5 = "loadEriFileFromXml: check for alternate file"
            com.android.telephony.Rlog.d(r3, r5)     // Catch:{ FileNotFoundException -> 0x0034, XmlPullParserException -> 0x002d }
            java.io.FileInputStream r5 = new java.io.FileInputStream     // Catch:{ FileNotFoundException -> 0x0034, XmlPullParserException -> 0x002d }
            r6 = 17039661(0x104012d, float:2.4245415E-38)
            java.lang.String r0 = r0.getString(r6)     // Catch:{ FileNotFoundException -> 0x0034, XmlPullParserException -> 0x002d }
            r5.<init>(r0)     // Catch:{ FileNotFoundException -> 0x0034, XmlPullParserException -> 0x002d }
            org.xmlpull.v1.XmlPullParser r0 = android.util.Xml.newPullParser()     // Catch:{ FileNotFoundException -> 0x0035, XmlPullParserException -> 0x002e }
            r0.setInput(r5, r4)     // Catch:{ FileNotFoundException -> 0x0035, XmlPullParserException -> 0x002e }
            java.lang.String r6 = "loadEriFileFromXml: opened alternate file"
            com.android.telephony.Rlog.d(r3, r6)     // Catch:{ FileNotFoundException -> 0x0035, XmlPullParserException -> 0x002e }
            r6 = r5
            r5 = r0
            goto L_0x003c
        L_0x002d:
            r5 = r4
        L_0x002e:
            java.lang.String r0 = "loadEriFileFromXml: no parser for alternate file"
            com.android.telephony.Rlog.d(r3, r0)
            goto L_0x003a
        L_0x0034:
            r5 = r4
        L_0x0035:
            java.lang.String r0 = "loadEriFileFromXml: no alternate file"
            com.android.telephony.Rlog.d(r3, r0)
        L_0x003a:
            r6 = r5
            r5 = r4
        L_0x003c:
            if (r5 != 0) goto L_0x00ae
            android.content.Context r0 = r1.mContext
            java.lang.String r7 = "carrier_config"
            java.lang.Object r0 = r0.getSystemService(r7)
            android.telephony.CarrierConfigManager r0 = (android.telephony.CarrierConfigManager) r0
            if (r0 == 0) goto L_0x005e
            com.android.internal.telephony.Phone r7 = r1.mPhone
            int r7 = r7.getSubId()
            android.os.PersistableBundle r0 = r0.getConfigForSubId(r7)
            if (r0 == 0) goto L_0x005e
            java.lang.String r7 = "carrier_eri_file_name_string"
            java.lang.String r0 = r0.getString(r7)
            r7 = r0
            goto L_0x005f
        L_0x005e:
            r7 = r4
        L_0x005f:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r8 = "eriFile = "
            r0.append(r8)
            r0.append(r7)
            java.lang.String r0 = r0.toString()
            com.android.telephony.Rlog.d(r3, r0)
            if (r7 != 0) goto L_0x007b
            java.lang.String r0 = "loadEriFileFromXml: Can't find ERI file to load"
            com.android.telephony.Rlog.e(r3, r0)
            return
        L_0x007b:
            org.xmlpull.v1.XmlPullParser r5 = android.util.Xml.newPullParser()     // Catch:{ IOException | XmlPullParserException -> 0x008d }
            android.content.Context r0 = r1.mContext     // Catch:{ IOException | XmlPullParserException -> 0x008d }
            android.content.res.AssetManager r0 = r0.getAssets()     // Catch:{ IOException | XmlPullParserException -> 0x008d }
            java.io.InputStream r0 = r0.open(r7)     // Catch:{ IOException | XmlPullParserException -> 0x008d }
            r5.setInput(r0, r4)     // Catch:{ IOException | XmlPullParserException -> 0x008d }
            goto L_0x00ae
        L_0x008d:
            r0 = move-exception
            java.lang.StringBuilder r8 = new java.lang.StringBuilder
            r8.<init>()
            java.lang.String r9 = "loadEriFileFromXml: no parser for "
            r8.append(r9)
            r8.append(r7)
            java.lang.String r7 = ". Exception = "
            r8.append(r7)
            java.lang.String r0 = r0.toString()
            r8.append(r0)
            java.lang.String r0 = r8.toString()
            com.android.telephony.Rlog.e(r3, r0)
        L_0x00ae:
            java.lang.String r0 = "EriFile"
            com.android.internal.telephony.util.XmlUtils.beginDocument(r5, r0)     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r0 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "VersionNumber"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r7 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            r0.mVersionNumber = r7     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r0 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "NumberOfEriEntries"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r7 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            r0.mNumberOfEriEntries = r7     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r0 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "EriFileType"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r7 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            r0.mEriFileType = r7     // Catch:{ Exception -> 0x01df }
            r0 = 0
        L_0x00de:
            com.android.internal.telephony.util.XmlUtils.nextElement(r5)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = r5.getName()     // Catch:{ Exception -> 0x01df }
            if (r7 != 0) goto L_0x0149
            com.android.internal.telephony.cdma.EriManager$EriFile r2 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            int r2 = r2.mNumberOfEriEntries     // Catch:{ Exception -> 0x01df }
            if (r0 == r2) goto L_0x0112
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x01df }
            r2.<init>()     // Catch:{ Exception -> 0x01df }
            java.lang.String r4 = "Error Parsing ERI file: "
            r2.append(r4)     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r4 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            int r4 = r4.mNumberOfEriEntries     // Catch:{ Exception -> 0x01df }
            r2.append(r4)     // Catch:{ Exception -> 0x01df }
            java.lang.String r4 = " defined, "
            r2.append(r4)     // Catch:{ Exception -> 0x01df }
            r2.append(r0)     // Catch:{ Exception -> 0x01df }
            java.lang.String r0 = " parsed!"
            r2.append(r0)     // Catch:{ Exception -> 0x01df }
            java.lang.String r0 = r2.toString()     // Catch:{ Exception -> 0x01df }
            com.android.telephony.Rlog.e(r3, r0)     // Catch:{ Exception -> 0x01df }
        L_0x0112:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x01df }
            r0.<init>()     // Catch:{ Exception -> 0x01df }
            java.lang.String r2 = "loadEriFileFromXml: eri parsing successful, file loaded. ver = "
            r0.append(r2)     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r2 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            int r2 = r2.mVersionNumber     // Catch:{ Exception -> 0x01df }
            r0.append(r2)     // Catch:{ Exception -> 0x01df }
            java.lang.String r2 = ", # of entries = "
            r0.append(r2)     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriManager$EriFile r2 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            int r2 = r2.mNumberOfEriEntries     // Catch:{ Exception -> 0x01df }
            r0.append(r2)     // Catch:{ Exception -> 0x01df }
            java.lang.String r0 = r0.toString()     // Catch:{ Exception -> 0x01df }
            com.android.telephony.Rlog.d(r3, r0)     // Catch:{ Exception -> 0x01df }
            r0 = 1
            r1.mIsEriFileLoaded = r0     // Catch:{ Exception -> 0x01df }
            boolean r0 = r5 instanceof android.content.res.XmlResourceParser
            if (r0 == 0) goto L_0x0142
            android.content.res.XmlResourceParser r5 = (android.content.res.XmlResourceParser) r5
            r5.close()
        L_0x0142:
            if (r6 == 0) goto L_0x01f2
        L_0x0144:
            r6.close()     // Catch:{ IOException -> 0x01f2 }
            goto L_0x01f2
        L_0x0149:
            boolean r8 = r7.equals(r2)     // Catch:{ Exception -> 0x01df }
            if (r8 == 0) goto L_0x0187
            java.lang.String r7 = "Id"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r7 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r8 = "CallPromptText"
            java.lang.String r8 = r5.getAttributeValue(r4, r8)     // Catch:{ Exception -> 0x01df }
            if (r7 < 0) goto L_0x016c
            r9 = 2
            if (r7 > r9) goto L_0x016c
            com.android.internal.telephony.cdma.EriManager$EriFile r9 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            java.lang.String[] r9 = r9.mCallPromptId     // Catch:{ Exception -> 0x01df }
            r9[r7] = r8     // Catch:{ Exception -> 0x01df }
            goto L_0x00de
        L_0x016c:
            java.lang.StringBuilder r8 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x01df }
            r8.<init>()     // Catch:{ Exception -> 0x01df }
            java.lang.String r9 = "Error Parsing ERI file: found"
            r8.append(r9)     // Catch:{ Exception -> 0x01df }
            r8.append(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = " CallPromptId"
            r8.append(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = r8.toString()     // Catch:{ Exception -> 0x01df }
            com.android.telephony.Rlog.e(r3, r7)     // Catch:{ Exception -> 0x01df }
            goto L_0x00de
        L_0x0187:
            java.lang.String r8 = "EriInfo"
            boolean r7 = r7.equals(r8)     // Catch:{ Exception -> 0x01df }
            if (r7 == 0) goto L_0x00de
            java.lang.String r7 = "RoamingIndicator"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r9 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "IconIndex"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r10 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "IconMode"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r11 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "EriText"
            java.lang.String r12 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = r5.getAttributeValue(r4, r2)     // Catch:{ Exception -> 0x01df }
            int r13 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            java.lang.String r7 = "AlertId"
            java.lang.String r7 = r5.getAttributeValue(r4, r7)     // Catch:{ Exception -> 0x01df }
            int r14 = java.lang.Integer.parseInt(r7)     // Catch:{ Exception -> 0x01df }
            int r0 = r0 + 1
            com.android.internal.telephony.cdma.EriManager$EriFile r7 = r1.mEriFile     // Catch:{ Exception -> 0x01df }
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.cdma.EriInfo> r7 = r7.mRoamIndTable     // Catch:{ Exception -> 0x01df }
            java.lang.Integer r15 = java.lang.Integer.valueOf(r9)     // Catch:{ Exception -> 0x01df }
            com.android.internal.telephony.cdma.EriInfo r8 = new com.android.internal.telephony.cdma.EriInfo     // Catch:{ Exception -> 0x01df }
            r16 = r8
            r8 = r16
            r8.<init>(r9, r10, r11, r12, r13, r14)     // Catch:{ Exception -> 0x01df }
            r7.put(r15, r8)     // Catch:{ Exception -> 0x01df }
            goto L_0x00de
        L_0x01dd:
            r0 = move-exception
            goto L_0x01f3
        L_0x01df:
            r0 = move-exception
            java.lang.String r1 = "Got exception while loading ERI file."
            com.android.telephony.Rlog.e(r3, r1, r0)     // Catch:{ all -> 0x01dd }
            boolean r0 = r5 instanceof android.content.res.XmlResourceParser
            if (r0 == 0) goto L_0x01ee
            android.content.res.XmlResourceParser r5 = (android.content.res.XmlResourceParser) r5
            r5.close()
        L_0x01ee:
            if (r6 == 0) goto L_0x01f2
            goto L_0x0144
        L_0x01f2:
            return
        L_0x01f3:
            boolean r1 = r5 instanceof android.content.res.XmlResourceParser
            if (r1 == 0) goto L_0x01fc
            android.content.res.XmlResourceParser r5 = (android.content.res.XmlResourceParser) r5
            r5.close()
        L_0x01fc:
            if (r6 == 0) goto L_0x0201
            r6.close()     // Catch:{ IOException -> 0x0201 }
        L_0x0201:
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cdma.EriManager.loadEriFileFromXml():void");
    }

    public int getEriFileVersion() {
        return this.mEriFile.mVersionNumber;
    }

    public int getEriNumberOfEntries() {
        return this.mEriFile.mNumberOfEriEntries;
    }

    public int getEriFileType() {
        return this.mEriFile.mEriFileType;
    }

    public boolean isEriFileLoaded() {
        return this.mIsEriFileLoaded;
    }

    private EriInfo getEriInfo(int i) {
        if (this.mEriFile.mRoamIndTable.containsKey(Integer.valueOf(i))) {
            return this.mEriFile.mRoamIndTable.get(Integer.valueOf(i));
        }
        return null;
    }

    @UnsupportedAppUsage
    private EriDisplayInformation getEriDisplayInformation(int i, int i2) {
        EriInfo eriInfo;
        if (this.mIsEriFileLoaded && (eriInfo = getEriInfo(i)) != null) {
            return new EriDisplayInformation(eriInfo.iconIndex, eriInfo.iconMode, eriInfo.eriText);
        }
        switch (i) {
            case 0:
                return new EriDisplayInformation(0, 0, this.mContext.getText(17041460).toString());
            case 1:
                return new EriDisplayInformation(1, 0, this.mContext.getText(17041461).toString());
            case 2:
                return new EriDisplayInformation(2, 1, this.mContext.getText(17041465).toString());
            case 3:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041466).toString());
            case 4:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041467).toString());
            case 5:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041468).toString());
            case 6:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041469).toString());
            case 7:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041470).toString());
            case 8:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041471).toString());
            case 9:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041472).toString());
            case 10:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041462).toString());
            case 11:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041463).toString());
            case 12:
                return new EriDisplayInformation(i, 0, this.mContext.getText(17041464).toString());
            default:
                if (!this.mIsEriFileLoaded) {
                    Rlog.d(LOG_TAG, "ERI File not loaded");
                    if (i2 > 2) {
                        return new EriDisplayInformation(2, 1, this.mContext.getText(17041465).toString());
                    }
                    if (i2 == 0) {
                        return new EriDisplayInformation(0, 0, this.mContext.getText(17041460).toString());
                    }
                    if (i2 == 1) {
                        return new EriDisplayInformation(1, 0, this.mContext.getText(17041461).toString());
                    }
                    if (i2 != 2) {
                        return new EriDisplayInformation(-1, -1, "ERI text");
                    }
                    return new EriDisplayInformation(2, 1, this.mContext.getText(17041465).toString());
                }
                EriInfo eriInfo2 = getEriInfo(i);
                EriInfo eriInfo3 = getEriInfo(i2);
                if (eriInfo2 != null) {
                    return new EriDisplayInformation(eriInfo2.iconIndex, eriInfo2.iconMode, eriInfo2.eriText);
                }
                if (eriInfo3 != null) {
                    return new EriDisplayInformation(eriInfo3.iconIndex, eriInfo3.iconMode, eriInfo3.eriText);
                }
                Rlog.e(LOG_TAG, "ERI defRoamInd " + i2 + " not found in ERI file ...on");
                return new EriDisplayInformation(0, 0, this.mContext.getText(17041460).toString());
        }
    }

    public int getCdmaEriIconIndex(int i, int i2) {
        return getEriDisplayInformation(i, i2).mEriIconIndex;
    }

    public int getCdmaEriIconMode(int i, int i2) {
        return getEriDisplayInformation(i, i2).mEriIconMode;
    }

    public String getCdmaEriText(int i, int i2) {
        return getEriDisplayInformation(i, i2).mEriIconText;
    }
}
