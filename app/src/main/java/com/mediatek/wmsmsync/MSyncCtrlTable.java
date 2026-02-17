package com.mediatek.wmsmsync;

import java.util.ArrayList;

public class MSyncCtrlTable {
    private static final String APP_LIST_PATH = "system/etc/msync_ctrl_table.xml";
    private static final String ARRAY_ACTIVITY = "activities";
    private static final Object LOCK = new Object();
    private static final String NODE_ACTIVITY = "activity";
    private static final String NODE_ACTIVITY_FPS = "fps";
    private static final String NODE_ACTIVITY_NAME = "name";
    private static final String NODE_DEFAULT_FPS = "defaultfps";
    private static final String NODE_GLOBAL_FPS = "globalfps";
    private static final String NODE_IME_DEFAULT_FPS = "defaultimefps";
    private static final String NODE_IME_FPS = "imefps";
    private static final String NODE_IME_GLOBAL_CONTROL = "enableimeglobalcontrol";
    private static final String NODE_PACKAGE_NAME = "packagename";
    private static final String NODE_SLIDE_RESPONSE = "slideresponse";
    private static final String NODE_VOICE_DEFAULT_FPS = "defaultvoicefps";
    private static final String NODE_VOICE_FPS = "voicefps";
    private static final String NODE_VOICE_GLOBAL_CONTROL = "enablevoiceglobalcontrol";
    private static final String TAG = "MSyncCtrlTable";
    private static final String TAG_APP = "app";
    private static volatile MSyncCtrlTable sInstance;
    private float mDefaultImeFps;
    private float mDefaultVoiceFps;
    private boolean mEnableImeGlobalFpsControl = false;
    private boolean mEnableVoiceGlobalFpsControl = false;
    private float mGlobalFPS;
    private boolean mIsRead = false;
    private ArrayList<MSyncCtrlBean> mMSyncAppCache;

    public ArrayList<MSyncCtrlBean> getMSyncAppCache() {
        return this.mMSyncAppCache;
    }

    public static MSyncCtrlTable getInstance() {
        if (sInstance == null) {
            synchronized (LOCK) {
                if (sInstance == null) {
                    sInstance = new MSyncCtrlTable();
                }
            }
        }
        return sInstance;
    }

    private MSyncCtrlTable() {
    }

    public boolean isRead() {
        return this.mIsRead;
    }

    public boolean isEnableImeGlobalFpsControl() {
        return this.mEnableImeGlobalFpsControl;
    }

    public boolean isEnableVoiceGlobalFpsControl() {
        return this.mEnableVoiceGlobalFpsControl;
    }

    public float getDefaultImeFps() {
        return this.mDefaultImeFps;
    }

    public float getDefaultVoiceFps() {
        return this.mDefaultVoiceFps;
    }

    public float getGlobalFPS() {
        return this.mGlobalFPS;
    }

    /* JADX WARNING: Removed duplicated region for block: B:21:0x0040 A[SYNTHETIC, Splitter:B:21:0x0040] */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x0050 A[SYNTHETIC, Splitter:B:28:0x0050] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void loadMSyncCtrlTable() {
        /*
            r5 = this;
            java.lang.String r0 = "close failed.."
            java.lang.String r1 = "MSyncCtrlTable"
            java.lang.String r2 = "loadMSyncCtrlTable + "
            android.util.Slog.d(r1, r2)
            r2 = 0
            java.io.File r3 = new java.io.File     // Catch:{ IOException -> 0x0038 }
            java.lang.String r4 = "system/etc/msync_ctrl_table.xml"
            r3.<init>(r4)     // Catch:{ IOException -> 0x0038 }
            boolean r4 = r3.exists()     // Catch:{ IOException -> 0x0038 }
            if (r4 != 0) goto L_0x001e
            java.lang.String r5 = "Target file doesn't exist: system/etc/msync_ctrl_table.xml"
            android.util.Slog.e(r1, r5)     // Catch:{ IOException -> 0x0038 }
            return
        L_0x001e:
            java.io.FileInputStream r4 = new java.io.FileInputStream     // Catch:{ IOException -> 0x0038 }
            r4.<init>(r3)     // Catch:{ IOException -> 0x0038 }
            java.util.ArrayList r2 = r5.parseAppListFile(r4)     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
            r5.mMSyncAppCache = r2     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
            r2 = 1
            r5.mIsRead = r2     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
            r4.close()     // Catch:{ IOException -> 0x0044 }
            goto L_0x0048
        L_0x0030:
            r5 = move-exception
            r2 = r4
            goto L_0x004e
        L_0x0033:
            r5 = move-exception
            r2 = r4
            goto L_0x0039
        L_0x0036:
            r5 = move-exception
            goto L_0x004e
        L_0x0038:
            r5 = move-exception
        L_0x0039:
            java.lang.String r3 = "IOException"
            android.util.Slog.w(r1, r3, r5)     // Catch:{ all -> 0x0036 }
            if (r2 == 0) goto L_0x0048
            r2.close()     // Catch:{ IOException -> 0x0044 }
            goto L_0x0048
        L_0x0044:
            r5 = move-exception
            android.util.Slog.w(r1, r0, r5)
        L_0x0048:
            java.lang.String r5 = "loadMSyncCtrlTable - "
            android.util.Slog.d(r1, r5)
            return
        L_0x004e:
            if (r2 == 0) goto L_0x0058
            r2.close()     // Catch:{ IOException -> 0x0054 }
            goto L_0x0058
        L_0x0054:
            r2 = move-exception
            android.util.Slog.w(r1, r0, r2)
        L_0x0058:
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.wmsmsync.MSyncCtrlTable.loadMSyncCtrlTable():void");
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.util.ArrayList<com.mediatek.wmsmsync.MSyncCtrlBean> parseAppListFile(java.io.InputStream r19) {
        /*
            r18 = this;
            r0 = r18
            java.lang.String r1 = "MSyncCtrlTable"
            java.util.ArrayList r2 = new java.util.ArrayList
            r2.<init>()
            javax.xml.parsers.DocumentBuilderFactory r3 = javax.xml.parsers.DocumentBuilderFactory.newInstance()     // Catch:{ ParserConfigurationException -> 0x02aa, SAXException -> 0x02a3, IOException -> 0x029c }
            javax.xml.parsers.DocumentBuilder r3 = r3.newDocumentBuilder()     // Catch:{ ParserConfigurationException -> 0x02aa, SAXException -> 0x02a3, IOException -> 0x029c }
            r4 = r19
            org.w3c.dom.Document r3 = r3.parse(r4)     // Catch:{ ParserConfigurationException -> 0x02aa, SAXException -> 0x02a3, IOException -> 0x029c }
            java.lang.String r4 = "enableimeglobalcontrol"
            org.w3c.dom.NodeList r4 = r3.getElementsByTagName(r4)     // Catch:{ Exception -> 0x0292 }
            r5 = 0
            org.w3c.dom.Node r4 = r4.item(r5)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = r4.getTextContent()     // Catch:{ Exception -> 0x0292 }
            boolean r4 = java.lang.Boolean.parseBoolean(r4)     // Catch:{ Exception -> 0x0292 }
            r0.mEnableImeGlobalFpsControl = r4     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = "enablevoiceglobalcontrol"
            org.w3c.dom.NodeList r4 = r3.getElementsByTagName(r4)     // Catch:{ Exception -> 0x0292 }
            org.w3c.dom.Node r4 = r4.item(r5)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = r4.getTextContent()     // Catch:{ Exception -> 0x0292 }
            boolean r4 = java.lang.Boolean.parseBoolean(r4)     // Catch:{ Exception -> 0x0292 }
            r0.mEnableVoiceGlobalFpsControl = r4     // Catch:{ Exception -> 0x0292 }
            boolean r4 = r0.mEnableImeGlobalFpsControl     // Catch:{ Exception -> 0x0292 }
            if (r4 == 0) goto L_0x0058
            java.lang.String r4 = "defaultimefps"
            org.w3c.dom.NodeList r4 = r3.getElementsByTagName(r4)     // Catch:{ Exception -> 0x0292 }
            org.w3c.dom.Node r4 = r4.item(r5)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = r4.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r4 = java.lang.Float.parseFloat(r4)     // Catch:{ Exception -> 0x0292 }
            r0.mDefaultImeFps = r4     // Catch:{ Exception -> 0x0292 }
        L_0x0058:
            boolean r4 = r0.mEnableVoiceGlobalFpsControl     // Catch:{ Exception -> 0x0292 }
            if (r4 == 0) goto L_0x0070
            java.lang.String r4 = "defaultvoicefps"
            org.w3c.dom.NodeList r4 = r3.getElementsByTagName(r4)     // Catch:{ Exception -> 0x0292 }
            org.w3c.dom.Node r4 = r4.item(r5)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = r4.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r4 = java.lang.Float.parseFloat(r4)     // Catch:{ Exception -> 0x0292 }
            r0.mDefaultVoiceFps = r4     // Catch:{ Exception -> 0x0292 }
        L_0x0070:
            java.lang.String r4 = "globalfps"
            org.w3c.dom.NodeList r4 = r3.getElementsByTagName(r4)     // Catch:{ Exception -> 0x0292 }
            org.w3c.dom.Node r4 = r4.item(r5)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = r4.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r4 = java.lang.Float.parseFloat(r4)     // Catch:{ Exception -> 0x0292 }
            r0.mGlobalFPS = r4     // Catch:{ Exception -> 0x0292 }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x0292 }
            r4.<init>()     // Catch:{ Exception -> 0x0292 }
            java.lang.String r6 = "mEnableIMEGlobalFPSControl = "
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            boolean r6 = r0.mEnableImeGlobalFpsControl     // Catch:{ Exception -> 0x0292 }
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r6 = " | mDefaultIMEFPS = "
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            float r6 = r0.mDefaultImeFps     // Catch:{ Exception -> 0x0292 }
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r6 = "\nmEnableVoiceGlobalFPSControl = "
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            boolean r6 = r0.mEnableVoiceGlobalFpsControl     // Catch:{ Exception -> 0x0292 }
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r6 = " | mDefaultVoiceFPS = "
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            float r6 = r0.mDefaultVoiceFps     // Catch:{ Exception -> 0x0292 }
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r6 = "\nmGlobalFPS = "
            r4.append(r6)     // Catch:{ Exception -> 0x0292 }
            float r0 = r0.mGlobalFPS     // Catch:{ Exception -> 0x0292 }
            r4.append(r0)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r0 = r4.toString()     // Catch:{ Exception -> 0x0292 }
            android.util.Slog.d(r1, r0)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r0 = "app"
            org.w3c.dom.NodeList r0 = r3.getElementsByTagName(r0)     // Catch:{ Exception -> 0x0292 }
            r3 = r5
        L_0x00c9:
            int r4 = r0.getLength()     // Catch:{ Exception -> 0x0292 }
            if (r3 >= r4) goto L_0x0291
            org.w3c.dom.Node r4 = r0.item(r3)     // Catch:{ Exception -> 0x0292 }
            org.w3c.dom.NodeList r4 = r4.getChildNodes()     // Catch:{ Exception -> 0x0292 }
            com.mediatek.wmsmsync.MSyncCtrlBean r6 = new com.mediatek.wmsmsync.MSyncCtrlBean     // Catch:{ Exception -> 0x0292 }
            r6.<init>()     // Catch:{ Exception -> 0x0292 }
            r7 = r5
        L_0x00dd:
            int r8 = r4.getLength()     // Catch:{ Exception -> 0x0292 }
            if (r7 >= r8) goto L_0x0271
            org.w3c.dom.Node r8 = r4.item(r7)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r9 = r8.getNodeName()     // Catch:{ Exception -> 0x0292 }
            int r10 = r9.hashCode()     // Catch:{ Exception -> 0x0292 }
            java.lang.String r11 = "imefps"
            java.lang.String r12 = "voicefps"
            r14 = 4
            r5 = 3
            r15 = 2
            r13 = 1
            switch(r10) {
                case -1972517257: goto L_0x012d;
                case -1185132152: goto L_0x0125;
                case 678658824: goto L_0x011b;
                case 909712337: goto L_0x0111;
                case 1291981042: goto L_0x0106;
                case 2048605165: goto L_0x00fc;
                default: goto L_0x00fb;
            }
        L_0x00fb:
            goto L_0x0135
        L_0x00fc:
            java.lang.String r10 = "activities"
            boolean r9 = r9.equals(r10)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = 5
            goto L_0x0136
        L_0x0106:
            java.lang.String r10 = "slideresponse"
            boolean r9 = r9.equals(r10)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = r13
            goto L_0x0136
        L_0x0111:
            java.lang.String r10 = "packagename"
            boolean r9 = r9.equals(r10)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = 0
            goto L_0x0136
        L_0x011b:
            java.lang.String r10 = "defaultfps"
            boolean r9 = r9.equals(r10)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = r15
            goto L_0x0136
        L_0x0125:
            boolean r9 = r9.equals(r11)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = r5
            goto L_0x0136
        L_0x012d:
            boolean r9 = r9.equals(r12)     // Catch:{ Exception -> 0x0292 }
            if (r9 == 0) goto L_0x0135
            r9 = r14
            goto L_0x0136
        L_0x0135:
            r9 = -1
        L_0x0136:
            if (r9 == 0) goto L_0x025d
            if (r9 == r13) goto L_0x024d
            if (r9 == r15) goto L_0x023d
            if (r9 == r5) goto L_0x022d
            if (r9 == r14) goto L_0x021d
            r10 = 5
            if (r9 == r10) goto L_0x0149
            r16 = r0
            r17 = r4
            goto L_0x0268
        L_0x0149:
            org.w3c.dom.NodeList r8 = r8.getChildNodes()     // Catch:{ Exception -> 0x0292 }
            java.util.ArrayList r9 = new java.util.ArrayList     // Catch:{ Exception -> 0x0292 }
            r9.<init>()     // Catch:{ Exception -> 0x0292 }
            r10 = 0
        L_0x0153:
            int r14 = r8.getLength()     // Catch:{ Exception -> 0x0292 }
            if (r10 >= r14) goto L_0x0215
            org.w3c.dom.Node r14 = r8.item(r10)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r5 = "activity"
            java.lang.String r15 = r14.getNodeName()     // Catch:{ Exception -> 0x0292 }
            boolean r5 = r5.equals(r15)     // Catch:{ Exception -> 0x0292 }
            if (r5 == 0) goto L_0x0205
            org.w3c.dom.NodeList r5 = r14.getChildNodes()     // Catch:{ Exception -> 0x0292 }
            com.mediatek.wmsmsync.MSyncCtrlBean$ActivityBean r14 = new com.mediatek.wmsmsync.MSyncCtrlBean$ActivityBean     // Catch:{ Exception -> 0x0292 }
            r14.<init>()     // Catch:{ Exception -> 0x0292 }
            r15 = 0
        L_0x0173:
            int r13 = r5.getLength()     // Catch:{ Exception -> 0x0292 }
            if (r15 >= r13) goto L_0x01fc
            org.w3c.dom.Node r13 = r5.item(r15)     // Catch:{ Exception -> 0x0292 }
            r16 = r0
            java.lang.String r0 = r13.getNodeName()     // Catch:{ Exception -> 0x0292 }
            int r17 = r0.hashCode()     // Catch:{ Exception -> 0x0292 }
            switch(r17) {
                case -1972517257: goto L_0x01af;
                case -1185132152: goto L_0x01a5;
                case 101609: goto L_0x0199;
                case 3373707: goto L_0x018d;
                default: goto L_0x018a;
            }     // Catch:{ Exception -> 0x0292 }
        L_0x018a:
            r17 = r4
            goto L_0x01b9
        L_0x018d:
            r17 = r4
            java.lang.String r4 = "name"
            boolean r0 = r0.equals(r4)     // Catch:{ Exception -> 0x0292 }
            if (r0 == 0) goto L_0x01b9
            r0 = 0
            goto L_0x01ba
        L_0x0199:
            r17 = r4
            java.lang.String r4 = "fps"
            boolean r0 = r0.equals(r4)     // Catch:{ Exception -> 0x0292 }
            if (r0 == 0) goto L_0x01b9
            r0 = 1
            goto L_0x01ba
        L_0x01a5:
            r17 = r4
            boolean r0 = r0.equals(r11)     // Catch:{ Exception -> 0x0292 }
            if (r0 == 0) goto L_0x01b9
            r0 = 2
            goto L_0x01ba
        L_0x01af:
            r17 = r4
            boolean r0 = r0.equals(r12)     // Catch:{ Exception -> 0x0292 }
            if (r0 == 0) goto L_0x01b9
            r0 = 3
            goto L_0x01ba
        L_0x01b9:
            r0 = -1
        L_0x01ba:
            if (r0 == 0) goto L_0x01ec
            r4 = 1
            if (r0 == r4) goto L_0x01df
            r4 = 2
            if (r0 == r4) goto L_0x01d2
            r4 = 3
            if (r0 == r4) goto L_0x01c6
            goto L_0x01f4
        L_0x01c6:
            java.lang.String r0 = r13.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r14.setVoiceFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x01f4
        L_0x01d2:
            r4 = 3
            java.lang.String r0 = r13.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r14.setImeFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x01f4
        L_0x01df:
            r4 = 3
            java.lang.String r0 = r13.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r14.setFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x01f4
        L_0x01ec:
            r4 = 3
            java.lang.String r0 = r13.getTextContent()     // Catch:{ Exception -> 0x0292 }
            r14.setName(r0)     // Catch:{ Exception -> 0x0292 }
        L_0x01f4:
            int r15 = r15 + 1
            r0 = r16
            r4 = r17
            goto L_0x0173
        L_0x01fc:
            r16 = r0
            r17 = r4
            r4 = 3
            r9.add(r14)     // Catch:{ Exception -> 0x0292 }
            goto L_0x020a
        L_0x0205:
            r16 = r0
            r17 = r4
            r4 = 3
        L_0x020a:
            int r10 = r10 + 1
            r5 = r4
            r0 = r16
            r4 = r17
            r13 = 1
            r15 = 2
            goto L_0x0153
        L_0x0215:
            r16 = r0
            r17 = r4
            r6.setActivityBeans(r9)     // Catch:{ Exception -> 0x0292 }
            goto L_0x0268
        L_0x021d:
            r16 = r0
            r17 = r4
            java.lang.String r0 = r8.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r6.setVoiceFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x0268
        L_0x022d:
            r16 = r0
            r17 = r4
            java.lang.String r0 = r8.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r6.setImeFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x0268
        L_0x023d:
            r16 = r0
            r17 = r4
            java.lang.String r0 = r8.getTextContent()     // Catch:{ Exception -> 0x0292 }
            float r0 = java.lang.Float.parseFloat(r0)     // Catch:{ Exception -> 0x0292 }
            r6.setFps(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x0268
        L_0x024d:
            r16 = r0
            r17 = r4
            java.lang.String r0 = r8.getTextContent()     // Catch:{ Exception -> 0x0292 }
            boolean r0 = java.lang.Boolean.parseBoolean(r0)     // Catch:{ Exception -> 0x0292 }
            r6.setSlideResponse(r0)     // Catch:{ Exception -> 0x0292 }
            goto L_0x0268
        L_0x025d:
            r16 = r0
            r17 = r4
            java.lang.String r0 = r8.getTextContent()     // Catch:{ Exception -> 0x0292 }
            r6.setPackageName(r0)     // Catch:{ Exception -> 0x0292 }
        L_0x0268:
            int r7 = r7 + 1
            r0 = r16
            r4 = r17
            r5 = 0
            goto L_0x00dd
        L_0x0271:
            r16 = r0
            r2.add(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ Exception -> 0x0292 }
            r0.<init>()     // Catch:{ Exception -> 0x0292 }
            java.lang.String r4 = "MSyncCtrlTableBean dom2xml: "
            r0.append(r4)     // Catch:{ Exception -> 0x0292 }
            r0.append(r6)     // Catch:{ Exception -> 0x0292 }
            java.lang.String r0 = r0.toString()     // Catch:{ Exception -> 0x0292 }
            android.util.Log.d(r1, r0)     // Catch:{ Exception -> 0x0292 }
            int r3 = r3 + 1
            r0 = r16
            r5 = 0
            goto L_0x00c9
        L_0x0291:
            return r2
        L_0x0292:
            r0 = move-exception
            r0.printStackTrace()
            java.util.ArrayList r0 = new java.util.ArrayList
            r0.<init>()
            return r0
        L_0x029c:
            r0 = move-exception
            java.lang.String r3 = "IOException"
            android.util.Log.w(r1, r3, r0)
            return r2
        L_0x02a3:
            r0 = move-exception
            java.lang.String r3 = "dom2xml SAXException"
            android.util.Log.w(r1, r3, r0)
            return r2
        L_0x02aa:
            r0 = move-exception
            java.lang.String r3 = "dom2xml ParserConfigurationException"
            android.util.Log.w(r1, r3, r0)
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.wmsmsync.MSyncCtrlTable.parseAppListFile(java.io.InputStream):java.util.ArrayList");
    }
}
