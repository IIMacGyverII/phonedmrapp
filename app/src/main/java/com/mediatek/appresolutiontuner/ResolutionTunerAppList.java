package com.mediatek.appresolutiontuner;

import android.util.Slog;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ResolutionTunerAppList {
    private static final String APP_LIST_PATH = "system/etc/resolution_tuner_app_list.xml";
    private static final String APP_LIST_PATH_FOR_AIVRS = "/vendor/etc/aivrs.ini";
    private static final String APP_LIST_PATH_FOR_GAISR = "/vendor/etc/gaisr.ini";
    private static final String NODE_FILTERED_WINDOW = "filteredwindow";
    private static final String NODE_PACKAGE_NAME = "packagename";
    private static final String NODE_SCALE = "scale";
    private static final String NODE_SCALING_FLOW = "flow";
    private static final String TAG = "AppResolutionTuner";
    private static final String TAG_APP = "app";
    private static final String VALUE_SCALING_FLOW_GAME = "game";
    private static final String VALUE_SCALING_FLOW_SURFACEVIEW = "surfaceview";
    private static final String VALUE_SCALING_FLOW_WMS = "wms";
    private static ResolutionTunerAppList sInstance;
    private ArrayList<Applic> mTunerAppCache;

    public static ResolutionTunerAppList getInstance() {
        if (sInstance == null) {
            sInstance = new ResolutionTunerAppList();
        }
        return sInstance;
    }

    /* JADX WARNING: Removed duplicated region for block: B:44:0x0092 A[SYNTHETIC, Splitter:B:44:0x0092] */
    /* JADX WARNING: Removed duplicated region for block: B:51:0x00a2 A[SYNTHETIC, Splitter:B:51:0x00a2] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public java.util.ArrayList<com.mediatek.appresolutiontuner.ResolutionTunerAppList.Applic> loadTunerAppList() {
        /*
            r6 = this;
            java.lang.String r0 = "close failed.."
            java.lang.String r1 = "loadTunerAppList - "
            java.lang.String r2 = "AppResolutionTuner"
            java.lang.String r3 = "loadTunerAppList + "
            android.util.Slog.d(r2, r3)
            r3 = 0
            java.lang.String r4 = "1"
            java.lang.String r5 = "ro.vendor.game_aisr_enable"
            java.lang.String r5 = android.os.SystemProperties.get(r5)     // Catch:{ IOException -> 0x008a }
            boolean r4 = r4.equals(r5)     // Catch:{ IOException -> 0x008a }
            if (r4 == 0) goto L_0x0058
            java.io.File r4 = new java.io.File     // Catch:{ IOException -> 0x008a }
            java.lang.String r5 = "/vendor/etc/aivrs.ini"
            r4.<init>(r5)     // Catch:{ IOException -> 0x008a }
            boolean r5 = r4.exists()     // Catch:{ IOException -> 0x008a }
            if (r5 == 0) goto L_0x0031
            java.util.ArrayList r4 = r6.parseAppListFileForAIVRS(r4)     // Catch:{ IOException -> 0x008a }
            r6.mTunerAppCache = r4     // Catch:{ IOException -> 0x008a }
            android.util.Slog.d(r2, r1)
            return r4
        L_0x0031:
            java.lang.String r4 = "Target file doesn't exist: /vendor/etc/aivrs.ini"
            android.util.Slog.d(r2, r4)     // Catch:{ IOException -> 0x008a }
            java.io.File r4 = new java.io.File     // Catch:{ IOException -> 0x008a }
            java.lang.String r5 = "/vendor/etc/gaisr.ini"
            r4.<init>(r5)     // Catch:{ IOException -> 0x008a }
            boolean r5 = r4.exists()     // Catch:{ IOException -> 0x008a }
            if (r5 == 0) goto L_0x004d
            java.util.ArrayList r4 = r6.parseAppListFileForGAISR(r4)     // Catch:{ IOException -> 0x008a }
            r6.mTunerAppCache = r4     // Catch:{ IOException -> 0x008a }
            android.util.Slog.d(r2, r1)
            return r4
        L_0x004d:
            java.lang.String r4 = "Target file doesn't exist: /vendor/etc/gaisr.ini"
            android.util.Slog.d(r2, r4)     // Catch:{ IOException -> 0x008a }
            java.util.ArrayList<com.mediatek.appresolutiontuner.ResolutionTunerAppList$Applic> r6 = r6.mTunerAppCache     // Catch:{ IOException -> 0x008a }
            android.util.Slog.d(r2, r1)
            return r6
        L_0x0058:
            java.io.File r4 = new java.io.File     // Catch:{ IOException -> 0x008a }
            java.lang.String r5 = "system/etc/resolution_tuner_app_list.xml"
            r4.<init>(r5)     // Catch:{ IOException -> 0x008a }
            boolean r5 = r4.exists()     // Catch:{ IOException -> 0x008a }
            if (r5 != 0) goto L_0x0071
            java.lang.String r4 = "Target file doesn't exist: system/etc/resolution_tuner_app_list.xml"
            android.util.Slog.e(r2, r4)     // Catch:{ IOException -> 0x008a }
            java.util.ArrayList<com.mediatek.appresolutiontuner.ResolutionTunerAppList$Applic> r6 = r6.mTunerAppCache     // Catch:{ IOException -> 0x008a }
            android.util.Slog.d(r2, r1)
            return r6
        L_0x0071:
            java.io.FileInputStream r5 = new java.io.FileInputStream     // Catch:{ IOException -> 0x008a }
            r5.<init>(r4)     // Catch:{ IOException -> 0x008a }
            java.util.ArrayList r3 = r6.parseAppListFile(r5)     // Catch:{ IOException -> 0x0085, all -> 0x0082 }
            r6.mTunerAppCache = r3     // Catch:{ IOException -> 0x0085, all -> 0x0082 }
            r5.close()     // Catch:{ IOException -> 0x0080 }
            goto L_0x009a
        L_0x0080:
            r3 = move-exception
            goto L_0x0097
        L_0x0082:
            r6 = move-exception
            r3 = r5
            goto L_0x00a0
        L_0x0085:
            r4 = move-exception
            r3 = r5
            goto L_0x008b
        L_0x0088:
            r6 = move-exception
            goto L_0x00a0
        L_0x008a:
            r4 = move-exception
        L_0x008b:
            java.lang.String r5 = "IOException"
            android.util.Slog.w(r2, r5, r4)     // Catch:{ all -> 0x0088 }
            if (r3 == 0) goto L_0x009a
            r3.close()     // Catch:{ IOException -> 0x0096 }
            goto L_0x009a
        L_0x0096:
            r3 = move-exception
        L_0x0097:
            android.util.Slog.w(r2, r0, r3)
        L_0x009a:
            android.util.Slog.d(r2, r1)
            java.util.ArrayList<com.mediatek.appresolutiontuner.ResolutionTunerAppList$Applic> r6 = r6.mTunerAppCache
            return r6
        L_0x00a0:
            if (r3 == 0) goto L_0x00aa
            r3.close()     // Catch:{ IOException -> 0x00a6 }
            goto L_0x00aa
        L_0x00a6:
            r3 = move-exception
            android.util.Slog.w(r2, r0, r3)
        L_0x00aa:
            android.util.Slog.d(r2, r1)
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.appresolutiontuner.ResolutionTunerAppList.loadTunerAppList():java.util.ArrayList");
    }

    public boolean isScaledByWMS(String str, String str2) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return false;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str) && next.getScalingFlow().equals(VALUE_SCALING_FLOW_WMS)) {
                return !next.isFiltered(str2);
            }
        }
        return false;
    }

    public boolean isScaledByGameMode(String str) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return false;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str) && next.getScalingFlow().equals(VALUE_SCALING_FLOW_GAME)) {
                return true;
            }
        }
        return false;
    }

    public boolean isScaledBySurfaceView(String str) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return false;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str) && !next.getScalingFlow().equals(VALUE_SCALING_FLOW_WMS) && !next.getScalingFlow().equals(VALUE_SCALING_FLOW_GAME)) {
                return true;
            }
        }
        return false;
    }

    public float getScaleValue(String str) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return 1.0f;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str)) {
                return next.getScale();
            }
        }
        return 1.0f;
    }

    public float getScaleWidth(String str) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return 1.0f;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str)) {
                return next.getScaleWidth();
            }
        }
        return 1.0f;
    }

    public float getScaleHeight(String str) {
        ArrayList<Applic> arrayList = this.mTunerAppCache;
        if (arrayList == null) {
            return 1.0f;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            Applic next = it.next();
            if (next.getPackageName().equals(str)) {
                return next.getScaleHeight();
            }
        }
        return 1.0f;
    }

    public static class Applic {
        private ArrayList<String> filteredWindows = new ArrayList<>();
        private String packageName;
        private float scale;
        private float scaleHeight;
        private float scaleWidth;
        private String scalingFlow = "";

        public String getPackageName() {
            return this.packageName;
        }

        public void setPackageName(String str) {
            this.packageName = str;
        }

        public float getScale() {
            return this.scale;
        }

        public void setScale(float f) {
            this.scale = f;
        }

        public void setScale(float f, float f2) {
            this.scaleWidth = f;
            this.scaleHeight = f2;
        }

        public float getScaleWidth() {
            return this.scaleWidth;
        }

        public void setScaleWidth(float f) {
            this.scaleWidth = f;
        }

        public float getScaleHeight() {
            return this.scaleHeight;
        }

        public void setScaleHeight(float f) {
            this.scaleHeight = f;
        }

        public void addFilteredWindow(String str) {
            this.filteredWindows.add(str);
        }

        public boolean isFiltered(String str) {
            return this.filteredWindows.contains(str);
        }

        public String getScalingFlow() {
            return this.scalingFlow;
        }

        public void setScalingFlow(String str) {
            this.scalingFlow = str;
        }

        public boolean isGameFlow() {
            return ResolutionTunerAppList.VALUE_SCALING_FLOW_GAME.equals(this.scalingFlow);
        }

        public String toString() {
            return "App{packageName='" + this.packageName + '\'' + ", scale='" + this.scale + '\'' + ", scaleWidth='" + this.scaleWidth + '\'' + ", scaleHeight='" + this.scaleHeight + '\'' + ", filteredWindows= " + this.filteredWindows + '\'' + ", scalingFlow= " + this.scalingFlow + '\'' + '}';
        }
    }

    private ArrayList<Applic> parseAppListFile(InputStream inputStream) {
        ArrayList<Applic> arrayList = new ArrayList<>();
        try {
            NodeList elementsByTagName = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(inputStream).getElementsByTagName(TAG_APP);
            for (int i = 0; i < elementsByTagName.getLength(); i++) {
                NodeList childNodes = elementsByTagName.item(i).getChildNodes();
                Applic applic = new Applic();
                for (int i2 = 0; i2 < childNodes.getLength(); i2++) {
                    Node item = childNodes.item(i2);
                    if (item.getNodeName().equals(NODE_PACKAGE_NAME)) {
                        applic.setPackageName(item.getTextContent());
                    } else if (item.getNodeName().equals(NODE_SCALE)) {
                        applic.setScale(Float.parseFloat(item.getTextContent()));
                    } else if (item.getNodeName().startsWith(NODE_FILTERED_WINDOW)) {
                        applic.addFilteredWindow(item.getTextContent());
                    } else if (item.getNodeName().startsWith(NODE_SCALING_FLOW)) {
                        applic.setScalingFlow(item.getTextContent());
                    }
                }
                arrayList.add(applic);
                Slog.d(TAG, "dom2xml: " + applic);
            }
            return arrayList;
        } catch (ParserConfigurationException e) {
            Slog.w(TAG, "dom2xml ParserConfigurationException", e);
            return arrayList;
        } catch (SAXException e2) {
            Slog.w(TAG, "dom2xml SAXException", e2);
            return arrayList;
        } catch (IOException e3) {
            Slog.w(TAG, "IOException", e3);
            return arrayList;
        }
    }

    private ArrayList<Applic> parseAppListFileForGAISR(File file) {
        BufferedReader bufferedReader;
        ArrayList<Applic> arrayList = new ArrayList<>();
        try {
            bufferedReader = new BufferedReader(new FileReader(file));
            while (true) {
                String readLine = bufferedReader.readLine();
                if (readLine == null) {
                    break;
                } else if (!readLine.isEmpty()) {
                    if (readLine.indexOf("=") >= 1) {
                        String substring = readLine.substring(0, readLine.lastIndexOf("\"") + 1);
                        boolean endsWith = substring.endsWith("game\"");
                        if (endsWith) {
                            substring = substring.replace(",game", "");
                        }
                        String substring2 = substring.substring(0, substring.indexOf("="));
                        float parseFloat = Float.parseFloat(substring.substring(substring.indexOf("\"") + 1, substring.indexOf(" ")));
                        float parseFloat2 = Float.parseFloat(substring.substring(substring.indexOf(" ") + 1, substring.length() - 1));
                        Applic applic = new Applic();
                        if (endsWith) {
                            applic.setScalingFlow(VALUE_SCALING_FLOW_GAME);
                        }
                        applic.setPackageName(substring2.trim());
                        applic.setScale(parseFloat, parseFloat2);
                        arrayList.add(applic);
                        Slog.w(TAG, "parseAppListFileForGAISR  packageName: " + substring2);
                    }
                }
            }
            bufferedReader.close();
            bufferedReader.close();
        } catch (Exception e) {
            Slog.w(TAG, "Failed to read app list for resolution tuner app list " + file, e);
        } catch (Throwable th) {
            th.addSuppressed(th);
        }
        return arrayList;
        throw th;
    }

    private ArrayList<Applic> parseAppListFileForAIVRS(File file) {
        BufferedReader bufferedReader;
        ArrayList<Applic> arrayList = new ArrayList<>();
        try {
            bufferedReader = new BufferedReader(new FileReader(file));
            while (true) {
                String readLine = bufferedReader.readLine();
                if (readLine == null) {
                    break;
                } else if (!readLine.isEmpty() && readLine.indexOf("=") >= 1) {
                    if (readLine.indexOf("\"") >= 1) {
                        String substring = readLine.substring(0, readLine.lastIndexOf("\"") + 1);
                        boolean endsWith = substring.endsWith("game\"");
                        if (endsWith) {
                            substring = substring.replace(",game", "");
                        }
                        String substring2 = substring.substring(substring.indexOf("\"") + 1, substring.length() - 1);
                        if (Integer.parseInt(substring2) < 70) {
                            if (Integer.parseInt(substring2) > 0) {
                                String substring3 = substring.substring(0, substring.indexOf("="));
                                Applic applic = new Applic();
                                if (endsWith) {
                                    applic.setScalingFlow(VALUE_SCALING_FLOW_GAME);
                                }
                                applic.setPackageName(substring3.trim());
                                applic.setScale(1.5f);
                                arrayList.add(applic);
                                Slog.w(TAG, "parseAppListFileForAIVRS  packageName: " + substring3 + " value:" + substring2);
                            }
                        }
                    }
                }
            }
            bufferedReader.close();
            bufferedReader.close();
        } catch (Exception e) {
            Slog.w(TAG, "Failed to read app list for resolution tuner app list " + file, e);
        } catch (Throwable th) {
            th.addSuppressed(th);
        }
        return arrayList;
        throw th;
    }
}
