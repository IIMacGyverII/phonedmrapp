package com.mediatek.appresolutiontuner;

import android.util.Slog;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class OpenMsyncAppList {
    private static final String APP_LIST_PATH = "system/etc/open_msync_app_list.xml";
    private static final String NODE_PACKAGE_NAME = "packagename";
    private static final String TAG = "OpenMsyncAppList";
    private static final String TAG_APP = "app";
    private static OpenMsyncAppList sInstance;
    private boolean isRead = false;
    private ArrayList<Applic> mMsyncAppCache;

    public static OpenMsyncAppList getInstance() {
        if (sInstance == null) {
            sInstance = new OpenMsyncAppList();
        }
        return sInstance;
    }

    public boolean isRead() {
        return this.isRead;
    }

    /* JADX WARNING: Removed duplicated region for block: B:21:0x0040 A[SYNTHETIC, Splitter:B:21:0x0040] */
    /* JADX WARNING: Removed duplicated region for block: B:28:0x0050 A[SYNTHETIC, Splitter:B:28:0x0050] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void loadOpenMsyncAppList() {
        /*
            r5 = this;
            java.lang.String r0 = "close failed.."
            java.lang.String r1 = "OpenMsyncAppList"
            java.lang.String r2 = "loadTunerAppList + "
            android.util.Slog.d(r1, r2)
            r2 = 0
            java.io.File r3 = new java.io.File     // Catch:{ IOException -> 0x0038 }
            java.lang.String r4 = "system/etc/open_msync_app_list.xml"
            r3.<init>(r4)     // Catch:{ IOException -> 0x0038 }
            boolean r4 = r3.exists()     // Catch:{ IOException -> 0x0038 }
            if (r4 != 0) goto L_0x001e
            java.lang.String r5 = "Target file doesn't exist: system/etc/open_msync_app_list.xml"
            android.util.Slog.e(r1, r5)     // Catch:{ IOException -> 0x0038 }
            return
        L_0x001e:
            java.io.FileInputStream r4 = new java.io.FileInputStream     // Catch:{ IOException -> 0x0038 }
            r4.<init>(r3)     // Catch:{ IOException -> 0x0038 }
            java.util.ArrayList r2 = r5.parseAppListFile(r4)     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
            r5.mMsyncAppCache = r2     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
            r2 = 1
            r5.isRead = r2     // Catch:{ IOException -> 0x0033, all -> 0x0030 }
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
            java.lang.String r5 = "loadTunerAppList - "
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
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.appresolutiontuner.OpenMsyncAppList.loadOpenMsyncAppList():void");
    }

    public boolean isScaledBySurfaceView(String str) {
        ArrayList<Applic> arrayList = this.mMsyncAppCache;
        if (arrayList == null) {
            return false;
        }
        Iterator<Applic> it = arrayList.iterator();
        while (it.hasNext()) {
            if (it.next().getPackageName().equals(str)) {
                return true;
            }
        }
        return false;
    }

    class Applic {
        private String packageName;

        Applic() {
        }

        public String getPackageName() {
            return this.packageName;
        }

        public void setPackageName(String str) {
            this.packageName = str;
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
}
