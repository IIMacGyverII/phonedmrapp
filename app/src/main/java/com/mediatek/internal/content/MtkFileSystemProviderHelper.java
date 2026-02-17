package com.mediatek.internal.content;

import android.content.Context;
import android.drm.DrmManagerClient;
import android.media.MediaFile;
import android.net.Uri;
import android.os.SystemProperties;
import android.webkit.MimeTypeMap;
import com.mediatek.media.MtkMediaStore;
import java.io.File;

public class MtkFileSystemProviderHelper {
    private static final Uri BASE_URI = new Uri.Builder().scheme("content").authority("com.android.externalstorage.documents").build();
    private static final boolean DEBUG = false;
    private static final String[] DEFAULT_DOCUMENT_PROJECTION = {"document_id", "mime_type", "_display_name", "last_modified", "flags", "_size", "_data", "is_drm", MtkMediaStore.MediaColumns.DRM_METHOD};
    private static final boolean LOG_INOTIFY = false;
    private static final String MIMETYPE_JPEG = "image/jpeg";
    private static final String MIMETYPE_JPG = "image/jpg";
    private static final String MIMETYPE_OCTET_STREAM = "application/octet-stream";
    private static final String TAG = "FileSystemProvider";
    private Context mContext;
    private String[] mDefaultProjection;

    public MtkFileSystemProviderHelper(Context context) {
        this.mContext = context;
    }

    public static boolean isMtkDrmApp() {
        return SystemProperties.getBoolean("ro.vendor.mtk_oma_drm_support", false);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v0, resolved type: android.database.Cursor} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r13v2, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v1, resolved type: android.database.Cursor} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v2, resolved type: android.database.Cursor} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v3, resolved type: android.database.Cursor} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r13v5, resolved type: java.lang.String} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r13v8, resolved type: java.lang.String} */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x008d, code lost:
        if (r3 != null) goto L_0x0099;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:25:0x0097, code lost:
        if (r3 == null) goto L_0x009c;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:27:0x0099, code lost:
        r3.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:28:0x009c, code lost:
        r11 = r15;
     */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void supportDRM(java.io.File r11, android.database.MatrixCursor.RowBuilder r12, java.lang.String r13, java.lang.String r14, java.io.File r15) throws java.io.FileNotFoundException {
        /*
            r10 = this;
            java.lang.String r13 = r11.getName()
            boolean r0 = isMtkDrmApp()
            java.lang.String r1 = "mime_type"
            if (r0 == 0) goto L_0x009d
            boolean r0 = r11.isDirectory()
            if (r0 != 0) goto L_0x009d
            r0 = 46
            int r0 = r13.lastIndexOf(r0)
            r2 = 1
            r3 = 0
            if (r0 < 0) goto L_0x0026
            int r0 = r0 + r2
            java.lang.String r13 = r13.substring(r0)
            java.lang.String r13 = r13.toLowerCase()
            goto L_0x0027
        L_0x0026:
            r13 = r3
        L_0x0027:
            if (r13 == 0) goto L_0x009d
            java.lang.String r0 = "dcf"
            boolean r13 = r13.equalsIgnoreCase(r0)
            if (r13 == 0) goto L_0x009d
            java.lang.String r11 = "external"
            android.net.Uri r5 = android.provider.MediaStore.Files.getContentUri(r11)
            java.lang.String r7 = "_data = ?"
            java.lang.String r11 = "is_drm"
            java.lang.String r13 = "drm_method"
            java.lang.String[] r6 = new java.lang.String[]{r11, r13, r1}
            if (r15 == 0) goto L_0x0086
            android.content.Context r10 = r10.mContext     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            android.content.ContentResolver r4 = r10.getContentResolver()     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            java.lang.String[] r8 = new java.lang.String[r2]     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            r10 = 0
            java.lang.String r0 = r15.getAbsolutePath()     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            r8[r10] = r0     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            r9 = 0
            android.database.Cursor r3 = r4.query(r5, r6, r7, r8, r9)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            if (r3 == 0) goto L_0x008d
            boolean r10 = r3.moveToFirst()     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            if (r10 == 0) goto L_0x008d
            int r10 = r3.getColumnIndex(r11)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            int r10 = r3.getInt(r10)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            int r0 = r3.getColumnIndex(r13)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            int r0 = r3.getInt(r0)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            int r2 = r3.getColumnIndex(r1)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            java.lang.String r14 = r3.getString(r2)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            java.lang.Integer r10 = java.lang.Integer.valueOf(r10)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            r12.add(r11, r10)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            java.lang.Integer r10 = java.lang.Integer.valueOf(r0)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            r12.add(r13, r10)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
            goto L_0x008d
        L_0x0086:
            java.lang.String r10 = "FileSystemProvider"
            java.lang.String r11 = "VisibleFile is null"
            android.util.Log.d(r10, r11)     // Catch:{ IllegalStateException -> 0x0097, all -> 0x0090 }
        L_0x008d:
            if (r3 == 0) goto L_0x009c
            goto L_0x0099
        L_0x0090:
            r10 = move-exception
            if (r3 == 0) goto L_0x0096
            r3.close()
        L_0x0096:
            throw r10
        L_0x0097:
            if (r3 == 0) goto L_0x009c
        L_0x0099:
            r3.close()
        L_0x009c:
            r11 = r15
        L_0x009d:
            r12.add(r1, r14)
            java.lang.String r10 = r11.getAbsolutePath()
            java.lang.String r11 = "_data"
            r12.add(r11, r10)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.internal.content.MtkFileSystemProviderHelper.supportDRM(java.io.File, android.database.MatrixCursor$RowBuilder, java.lang.String, java.lang.String, java.io.File):void");
    }

    public String getTypeForNameMtk(File file, String str) {
        int lastIndexOf = str.lastIndexOf(46);
        if (lastIndexOf >= 0) {
            String lowerCase = str.substring(lastIndexOf + 1).toLowerCase();
            if (lowerCase.equalsIgnoreCase("dcf")) {
                return getTypeForDrmFile(file);
            }
            String mimeTypeFromExtension = MimeTypeMap.getSingleton().getMimeTypeFromExtension(lowerCase);
            if (mimeTypeFromExtension != null) {
                return mimeTypeFromExtension;
            }
        }
        String mimeTypeForFile = MediaFile.getMimeTypeForFile(str);
        return mimeTypeForFile != null ? mimeTypeForFile : MIMETYPE_OCTET_STREAM;
    }

    private String getTypeForDrmFile(File file) {
        DrmManagerClient drmManagerClient = new DrmManagerClient(this.mContext);
        String file2 = file.toString();
        return drmManagerClient.canHandle(file2, (String) null) ? drmManagerClient.getOriginalMimeType(file2) : MIMETYPE_OCTET_STREAM;
    }

    public String[] getDefaultProjection() {
        return DEFAULT_DOCUMENT_PROJECTION;
    }
}
