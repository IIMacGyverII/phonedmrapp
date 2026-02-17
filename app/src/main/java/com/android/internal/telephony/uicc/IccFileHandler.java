package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import com.android.internal.telephony.CommandsInterface;
import java.util.ArrayList;
import kotlin.UByte;

public abstract class IccFileHandler extends Handler implements IccConstants {
    protected static final int COMMAND_GET_RESPONSE = 192;
    protected static final int COMMAND_READ_BINARY = 176;
    protected static final int COMMAND_READ_RECORD = 178;
    protected static final int COMMAND_SEEK = 162;
    protected static final int COMMAND_UPDATE_BINARY = 214;
    protected static final int COMMAND_UPDATE_RECORD = 220;
    protected static final int EF_TYPE_CYCLIC = 3;
    protected static final int EF_TYPE_LINEAR_FIXED = 1;
    protected static final int EF_TYPE_TRANSPARENT = 0;
    protected static final int EVENT_GET_BINARY_SIZE_DONE = 4;
    protected static final int EVENT_GET_EF_LINEAR_RECORD_SIZE_DONE = 8;
    protected static final int EVENT_GET_EF_TRANSPARENT_SIZE_DONE = 12;
    protected static final int EVENT_GET_RECORD_SIZE_DONE = 6;
    protected static final int EVENT_GET_RECORD_SIZE_IMG_DONE = 11;
    protected static final int EVENT_READ_BINARY_DONE = 5;
    protected static final int EVENT_READ_ICON_DONE = 10;
    protected static final int EVENT_READ_IMG_DONE = 9;
    protected static final int EVENT_READ_RECORD_DONE = 7;
    protected static final int GET_RESPONSE_EF_IMG_SIZE_BYTES = 10;
    protected static final int GET_RESPONSE_EF_SIZE_BYTES = 15;
    protected static final int READ_RECORD_MODE_ABSOLUTE = 4;
    protected static final int RESPONSE_DATA_ACCESS_CONDITION_1 = 8;
    protected static final int RESPONSE_DATA_ACCESS_CONDITION_2 = 9;
    protected static final int RESPONSE_DATA_ACCESS_CONDITION_3 = 10;
    protected static final int RESPONSE_DATA_FILE_ID_1 = 4;
    protected static final int RESPONSE_DATA_FILE_ID_2 = 5;
    protected static final int RESPONSE_DATA_FILE_SIZE_1 = 2;
    protected static final int RESPONSE_DATA_FILE_SIZE_2 = 3;
    protected static final int RESPONSE_DATA_FILE_STATUS = 11;
    protected static final int RESPONSE_DATA_FILE_TYPE = 6;
    protected static final int RESPONSE_DATA_LENGTH = 12;
    protected static final int RESPONSE_DATA_RECORD_LENGTH = 14;
    protected static final int RESPONSE_DATA_RFU_1 = 0;
    protected static final int RESPONSE_DATA_RFU_2 = 1;
    protected static final int RESPONSE_DATA_RFU_3 = 7;
    protected static final int RESPONSE_DATA_STRUCTURE = 13;
    protected static final int TYPE_DF = 2;
    protected static final int TYPE_EF = 4;
    protected static final int TYPE_MF = 1;
    protected static final int TYPE_RFU = 0;
    private static final boolean VDBG = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final String mAid;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public final CommandsInterface mCi;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final UiccCardApplication mParentApp;

    public void dispose() {
    }

    /* access modifiers changed from: protected */
    public String getCommonIccEFPath(int i) {
        if (i == 12037 || i == 12258) {
            return IccConstants.MF_SIM;
        }
        if (i == 20256) {
            return "3F007F105F50";
        }
        if (i == 20272) {
            return "3F007F105F3A";
        }
        if (i == 28480 || i == 28645 || i == 28474 || i == 28475) {
            return "3F007F10";
        }
        switch (i) {
            case IccConstants.EF_SDN:
            case IccConstants.EF_EXT1:
            case IccConstants.EF_EXT2:
            case IccConstants.EF_EXT3:
                return "3F007F10";
            default:
                return null;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract String getEFPath(int i);

    /* access modifiers changed from: protected */
    public abstract void logd(String str);

    /* access modifiers changed from: protected */
    public abstract void loge(String str);

    public static class LoadLinearFixedContext {
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public int mCountRecords;
        public int mEfid;
        public boolean mLoadAll;
        public Message mOnLoaded;
        public String mPath;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public int mRecordNum;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public int mRecordSize;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public ArrayList<byte[]> results;

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        LoadLinearFixedContext(int i, int i2, Message message) {
            this.mEfid = i;
            this.mRecordNum = i2;
            this.mOnLoaded = message;
            this.mLoadAll = false;
            this.mPath = null;
        }

        LoadLinearFixedContext(int i, int i2, String str, Message message) {
            this.mEfid = i;
            this.mRecordNum = i2;
            this.mOnLoaded = message;
            this.mLoadAll = false;
            this.mPath = str;
        }

        LoadLinearFixedContext(int i, String str, Message message) {
            this.mEfid = i;
            this.mRecordNum = 1;
            this.mLoadAll = true;
            this.mOnLoaded = message;
            this.mPath = str;
        }

        LoadLinearFixedContext(int i, Message message) {
            this.mEfid = i;
            this.mRecordNum = 1;
            this.mLoadAll = true;
            this.mOnLoaded = message;
            this.mPath = null;
        }
    }

    protected IccFileHandler(UiccCardApplication uiccCardApplication, String str, CommandsInterface commandsInterface) {
        this.mParentApp = uiccCardApplication;
        this.mAid = str;
        this.mCi = commandsInterface;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadEFLinearFixed(int i, String str, int i2, Message message) {
        if (str == null) {
            str = getEFPath(i);
        }
        String str2 = str;
        int i3 = i;
        this.mCi.iccIOForApp(192, i3, str2, 0, 0, 15, (String) null, (String) null, this.mAid, obtainMessage(6, new LoadLinearFixedContext(i, i2, str2, message)));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadEFLinearFixed(int i, int i2, Message message) {
        loadEFLinearFixed(i, getEFPath(i), i2, message);
    }

    public void loadEFImgLinearFixed(int i, Message message) {
        int i2 = i;
        this.mCi.iccIOForApp(192, 20256, getEFPath(20256), i2, 4, 15, (String) null, (String) null, this.mAid, obtainMessage(11, new LoadLinearFixedContext(20256, i, message)));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void getEFLinearRecordSize(int i, String str, Message message) {
        if (str == null) {
            str = getEFPath(i);
        }
        String str2 = str;
        int i2 = i;
        this.mCi.iccIOForApp(192, i2, str2, 0, 0, 15, (String) null, (String) null, this.mAid, obtainMessage(8, new LoadLinearFixedContext(i, str2, message)));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void getEFLinearRecordSize(int i, Message message) {
        getEFLinearRecordSize(i, getEFPath(i), message);
    }

    public void getEFTransparentRecordSize(int i, String str, Message message) {
        if (str == null) {
            getEFPath(i);
        }
        int i2 = i;
        this.mCi.iccIOForApp(192, i2, getEFPath(i), 0, 0, 15, (String) null, (String) null, this.mAid, obtainMessage(12, i, 0, message));
    }

    public void getEFTransparentRecordSize(int i, Message message) {
        getEFTransparentRecordSize(i, getEFPath(i), message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadEFLinearFixedAll(int i, String str, Message message) {
        if (str == null) {
            str = getEFPath(i);
        }
        String str2 = str;
        int i2 = i;
        this.mCi.iccIOForApp(192, i2, str2, 0, 0, 15, (String) null, (String) null, this.mAid, obtainMessage(6, new LoadLinearFixedContext(i, str2, message)));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadEFLinearFixedAll(int i, Message message) {
        loadEFLinearFixedAll(i, getEFPath(i), message);
    }

    @UnsupportedAppUsage
    public void loadEFTransparent(int i, Message message) {
        int i2 = i;
        this.mCi.iccIOForApp(192, i2, getEFPath(i), 0, 0, 15, (String) null, (String) null, this.mAid, obtainMessage(4, i, 0, message));
    }

    public void loadEFTransparent(int i, int i2, Message message) {
        Message obtainMessage = obtainMessage(5, i, 0, message);
        this.mCi.iccIOForApp(COMMAND_READ_BINARY, i, getEFPath(i), 0, 0, i2, (String) null, (String) null, this.mAid, obtainMessage);
    }

    public void loadEFImgTransparent(int i, int i2, int i3, int i4, Message message) {
        Message obtainMessage = obtainMessage(10, i, 0, message);
        StringBuilder sb = new StringBuilder();
        sb.append("IccFileHandler: loadEFImgTransparent fileid = ");
        sb.append(i);
        sb.append(" filePath = ");
        sb.append(getEFPath(20256));
        sb.append(" highOffset = ");
        sb.append(i2);
        sb.append(" lowOffset = ");
        sb.append(i3);
        sb.append(" length = ");
        int i5 = i4;
        sb.append(i5);
        logd(sb.toString());
        CommandsInterface commandsInterface = this.mCi;
        String eFPath = getEFPath(20256);
        String str = this.mAid;
        commandsInterface.iccIOForApp(COMMAND_READ_BINARY, i, eFPath, i2, i3, i5, (String) null, (String) null, str, obtainMessage);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateEFLinearFixed(int i, String str, int i2, byte[] bArr, String str2, Message message) {
        this.mCi.iccIOForApp(COMMAND_UPDATE_RECORD, i, str == null ? getEFPath(i) : str, i2, 4, bArr.length, IccUtils.bytesToHexString(bArr), str2, this.mAid, message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateEFLinearFixed(int i, int i2, byte[] bArr, String str, Message message) {
        this.mCi.iccIOForApp(COMMAND_UPDATE_RECORD, i, getEFPath(i), i2, 4, bArr.length, IccUtils.bytesToHexString(bArr), str, this.mAid, message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateEFTransparent(int i, byte[] bArr, Message message) {
        this.mCi.iccIOForApp(214, i, getEFPath(i), 0, 0, bArr.length, IccUtils.bytesToHexString(bArr), (String) null, this.mAid, message);
    }

    /* access modifiers changed from: protected */
    public void sendResult(Message message, Object obj, Throwable th) {
        if (message != null) {
            AsyncResult.forMessage(message, obj, th);
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public boolean processException(Message message, AsyncResult asyncResult) {
        IccIoResult iccIoResult = (IccIoResult) asyncResult.result;
        Throwable th = asyncResult.exception;
        if (th != null) {
            sendResult(message, (Object) null, th);
            return true;
        }
        IccException exception = iccIoResult.getException();
        if (exception == null) {
            return false;
        }
        sendResult(message, (Object) null, exception);
        return true;
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleMessage(android.os.Message r24) {
        /*
            r23 = this;
            r1 = r23
            r0 = r24
            r2 = 0
            int r3 = r0.what     // Catch:{ Exception -> 0x01e9 }
            r4 = 7
            r5 = 14
            r6 = 0
            r7 = 1
            r8 = 13
            r9 = 6
            r10 = 4
            switch(r3) {
                case 4: goto L_0x0198;
                case 5: goto L_0x0178;
                case 6: goto L_0x00f8;
                case 7: goto L_0x0092;
                case 8: goto L_0x004f;
                case 9: goto L_0x0092;
                case 10: goto L_0x0178;
                case 11: goto L_0x00f8;
                case 12: goto L_0x0015;
                default: goto L_0x0013;
            }     // Catch:{ Exception -> 0x01e9 }
        L_0x0013:
            goto L_0x0206
        L_0x0015:
            java.lang.Object r0 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r3 = r0
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r4 = r3.userObj     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r4 = (android.os.Message) r4     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r3 = r3.result     // Catch:{ Exception -> 0x0196 }
            com.android.internal.telephony.uicc.IccIoResult r3 = (com.android.internal.telephony.uicc.IccIoResult) r3     // Catch:{ Exception -> 0x0196 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ Exception -> 0x0196 }
            boolean r0 = r1.processException(r4, r0)     // Catch:{ Exception -> 0x0196 }
            if (r0 == 0) goto L_0x002c
            goto L_0x0206
        L_0x002c:
            byte[] r0 = r3.payload     // Catch:{ Exception -> 0x0196 }
            byte r3 = r0[r9]     // Catch:{ Exception -> 0x0196 }
            if (r10 != r3) goto L_0x0049
            byte r3 = r0[r8]     // Catch:{ Exception -> 0x0196 }
            if (r3 != 0) goto L_0x0043
            int r0 = getDataFileSize(r0)     // Catch:{ Exception -> 0x0196 }
            java.lang.Integer r0 = java.lang.Integer.valueOf(r0)     // Catch:{ Exception -> 0x0196 }
            r1.sendResult(r4, r0, r2)     // Catch:{ Exception -> 0x0196 }
            goto L_0x0206
        L_0x0043:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x0196 }
            r0.<init>()     // Catch:{ Exception -> 0x0196 }
            throw r0     // Catch:{ Exception -> 0x0196 }
        L_0x0049:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x0196 }
            r0.<init>()     // Catch:{ Exception -> 0x0196 }
            throw r0     // Catch:{ Exception -> 0x0196 }
        L_0x004f:
            java.lang.Object r0 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r3 = r0
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r4 = r3.userObj     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccFileHandler$LoadLinearFixedContext r4 = (com.android.internal.telephony.uicc.IccFileHandler.LoadLinearFixedContext) r4     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r3 = r3.result     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccIoResult r3 = (com.android.internal.telephony.uicc.IccIoResult) r3     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r4 = r4.mOnLoaded     // Catch:{ Exception -> 0x01e9 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ Exception -> 0x0196 }
            boolean r0 = r1.processException(r4, r0)     // Catch:{ Exception -> 0x0196 }
            if (r0 == 0) goto L_0x0068
            goto L_0x0206
        L_0x0068:
            byte[] r0 = r3.payload     // Catch:{ Exception -> 0x0196 }
            byte r3 = r0[r9]     // Catch:{ Exception -> 0x0196 }
            if (r10 != r3) goto L_0x008c
            byte r3 = r0[r8]     // Catch:{ Exception -> 0x0196 }
            if (r7 != r3) goto L_0x008c
            r3 = 3
            int[] r3 = new int[r3]     // Catch:{ Exception -> 0x0196 }
            byte r5 = r0[r5]     // Catch:{ Exception -> 0x0196 }
            r5 = r5 & 255(0xff, float:3.57E-43)
            r3[r6] = r5     // Catch:{ Exception -> 0x0196 }
            int r0 = getDataFileSize(r0)     // Catch:{ Exception -> 0x0196 }
            r3[r7] = r0     // Catch:{ Exception -> 0x0196 }
            r5 = 2
            r6 = r3[r6]     // Catch:{ Exception -> 0x0196 }
            int r0 = r0 / r6
            r3[r5] = r0     // Catch:{ Exception -> 0x0196 }
            r1.sendResult(r4, r3, r2)     // Catch:{ Exception -> 0x0196 }
            goto L_0x0206
        L_0x008c:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x0196 }
            r0.<init>()     // Catch:{ Exception -> 0x0196 }
            throw r0     // Catch:{ Exception -> 0x0196 }
        L_0x0092:
            java.lang.Object r0 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r3 = r0
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r5 = r3.userObj     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccFileHandler$LoadLinearFixedContext r5 = (com.android.internal.telephony.uicc.IccFileHandler.LoadLinearFixedContext) r5     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r3 = r3.result     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccIoResult r3 = (com.android.internal.telephony.uicc.IccIoResult) r3     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r6 = r5.mOnLoaded     // Catch:{ Exception -> 0x01e9 }
            java.lang.String r8 = r5.mPath     // Catch:{ Exception -> 0x00f4 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ Exception -> 0x00f4 }
            boolean r0 = r1.processException(r6, r0)     // Catch:{ Exception -> 0x00f4 }
            if (r0 == 0) goto L_0x00ad
            goto L_0x0206
        L_0x00ad:
            boolean r0 = r5.mLoadAll     // Catch:{ Exception -> 0x00f4 }
            if (r0 != 0) goto L_0x00b8
            byte[] r0 = r3.payload     // Catch:{ Exception -> 0x00f4 }
            r1.sendResult(r6, r0, r2)     // Catch:{ Exception -> 0x00f4 }
            goto L_0x0206
        L_0x00b8:
            java.util.ArrayList<byte[]> r0 = r5.results     // Catch:{ Exception -> 0x00f4 }
            byte[] r3 = r3.payload     // Catch:{ Exception -> 0x00f4 }
            r0.add(r3)     // Catch:{ Exception -> 0x00f4 }
            int r0 = r5.mRecordNum     // Catch:{ Exception -> 0x00f4 }
            int r0 = r0 + r7
            r5.mRecordNum = r0     // Catch:{ Exception -> 0x00f4 }
            int r3 = r5.mCountRecords     // Catch:{ Exception -> 0x00f4 }
            if (r0 <= r3) goto L_0x00cf
            java.util.ArrayList<byte[]> r0 = r5.results     // Catch:{ Exception -> 0x00f4 }
            r1.sendResult(r6, r0, r2)     // Catch:{ Exception -> 0x00f4 }
            goto L_0x0206
        L_0x00cf:
            if (r8 != 0) goto L_0x00d7
            int r0 = r5.mEfid     // Catch:{ Exception -> 0x00f4 }
            java.lang.String r8 = r1.getEFPath(r0)     // Catch:{ Exception -> 0x00f4 }
        L_0x00d7:
            r12 = r8
            com.android.internal.telephony.CommandsInterface r9 = r1.mCi     // Catch:{ Exception -> 0x00f4 }
            r10 = 178(0xb2, float:2.5E-43)
            int r11 = r5.mEfid     // Catch:{ Exception -> 0x00f4 }
            int r13 = r5.mRecordNum     // Catch:{ Exception -> 0x00f4 }
            r14 = 4
            int r15 = r5.mRecordSize     // Catch:{ Exception -> 0x00f4 }
            r16 = 0
            r17 = 0
            java.lang.String r0 = r1.mAid     // Catch:{ Exception -> 0x00f4 }
            android.os.Message r19 = r1.obtainMessage(r4, r5)     // Catch:{ Exception -> 0x00f4 }
            r18 = r0
            r9.iccIOForApp(r10, r11, r12, r13, r14, r15, r16, r17, r18, r19)     // Catch:{ Exception -> 0x00f4 }
            goto L_0x0206
        L_0x00f4:
            r0 = move-exception
            r4 = r6
            goto L_0x01eb
        L_0x00f8:
            java.lang.Object r0 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r3 = r0
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r6 = r3.userObj     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccFileHandler$LoadLinearFixedContext r6 = (com.android.internal.telephony.uicc.IccFileHandler.LoadLinearFixedContext) r6     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r3 = r3.result     // Catch:{ Exception -> 0x01e9 }
            com.android.internal.telephony.uicc.IccIoResult r3 = (com.android.internal.telephony.uicc.IccIoResult) r3     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r11 = r6.mOnLoaded     // Catch:{ Exception -> 0x01e9 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ Exception -> 0x0174 }
            boolean r0 = r1.processException(r11, r0)     // Catch:{ Exception -> 0x0174 }
            if (r0 == 0) goto L_0x0116
            java.lang.String r0 = "exception caught from EVENT_GET_RECORD_SIZE"
            r1.loge(r0)     // Catch:{ Exception -> 0x0174 }
            goto L_0x0206
        L_0x0116:
            byte[] r0 = r3.payload     // Catch:{ Exception -> 0x0174 }
            java.lang.String r3 = r6.mPath     // Catch:{ Exception -> 0x0174 }
            byte r9 = r0[r9]     // Catch:{ Exception -> 0x0174 }
            if (r10 != r9) goto L_0x016e
            byte r8 = r0[r8]     // Catch:{ Exception -> 0x0174 }
            if (r7 != r8) goto L_0x0168
            byte r5 = r0[r5]     // Catch:{ Exception -> 0x0174 }
            r5 = r5 & 255(0xff, float:3.57E-43)
            r6.mRecordSize = r5     // Catch:{ Exception -> 0x0174 }
            int r0 = getDataFileSize(r0)     // Catch:{ Exception -> 0x0174 }
            int r5 = r6.mRecordSize     // Catch:{ Exception -> 0x0174 }
            int r0 = r0 / r5
            r6.mCountRecords = r0     // Catch:{ Exception -> 0x0174 }
            boolean r0 = r6.mLoadAll     // Catch:{ Exception -> 0x0174 }
            if (r0 == 0) goto L_0x013e
            java.util.ArrayList r0 = new java.util.ArrayList     // Catch:{ Exception -> 0x0174 }
            int r5 = r6.mCountRecords     // Catch:{ Exception -> 0x0174 }
            r0.<init>(r5)     // Catch:{ Exception -> 0x0174 }
            r6.results = r0     // Catch:{ Exception -> 0x0174 }
        L_0x013e:
            if (r3 != 0) goto L_0x0146
            int r0 = r6.mEfid     // Catch:{ Exception -> 0x0174 }
            java.lang.String r3 = r1.getEFPath(r0)     // Catch:{ Exception -> 0x0174 }
        L_0x0146:
            r15 = r3
            com.android.internal.telephony.CommandsInterface r12 = r1.mCi     // Catch:{ Exception -> 0x0174 }
            r13 = 178(0xb2, float:2.5E-43)
            int r14 = r6.mEfid     // Catch:{ Exception -> 0x0174 }
            int r0 = r6.mRecordNum     // Catch:{ Exception -> 0x0174 }
            r17 = 4
            int r3 = r6.mRecordSize     // Catch:{ Exception -> 0x0174 }
            r19 = 0
            r20 = 0
            java.lang.String r5 = r1.mAid     // Catch:{ Exception -> 0x0174 }
            android.os.Message r22 = r1.obtainMessage(r4, r6)     // Catch:{ Exception -> 0x0174 }
            r16 = r0
            r18 = r3
            r21 = r5
            r12.iccIOForApp(r13, r14, r15, r16, r17, r18, r19, r20, r21, r22)     // Catch:{ Exception -> 0x0174 }
            goto L_0x0206
        L_0x0168:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x0174 }
            r0.<init>()     // Catch:{ Exception -> 0x0174 }
            throw r0     // Catch:{ Exception -> 0x0174 }
        L_0x016e:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x0174 }
            r0.<init>()     // Catch:{ Exception -> 0x0174 }
            throw r0     // Catch:{ Exception -> 0x0174 }
        L_0x0174:
            r0 = move-exception
            r4 = r11
            goto L_0x01eb
        L_0x0178:
            java.lang.Object r0 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r3 = r0
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r4 = r3.userObj     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r4 = (android.os.Message) r4     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r3 = r3.result     // Catch:{ Exception -> 0x0196 }
            com.android.internal.telephony.uicc.IccIoResult r3 = (com.android.internal.telephony.uicc.IccIoResult) r3     // Catch:{ Exception -> 0x0196 }
            android.os.AsyncResult r0 = (android.os.AsyncResult) r0     // Catch:{ Exception -> 0x0196 }
            boolean r0 = r1.processException(r4, r0)     // Catch:{ Exception -> 0x0196 }
            if (r0 == 0) goto L_0x018f
            goto L_0x0206
        L_0x018f:
            byte[] r0 = r3.payload     // Catch:{ Exception -> 0x0196 }
            r1.sendResult(r4, r0, r2)     // Catch:{ Exception -> 0x0196 }
            goto L_0x0206
        L_0x0196:
            r0 = move-exception
            goto L_0x01eb
        L_0x0198:
            java.lang.Object r3 = r0.obj     // Catch:{ Exception -> 0x01e9 }
            r4 = r3
            android.os.AsyncResult r4 = (android.os.AsyncResult) r4     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r5 = r4.userObj     // Catch:{ Exception -> 0x01e9 }
            android.os.Message r5 = (android.os.Message) r5     // Catch:{ Exception -> 0x01e9 }
            java.lang.Object r4 = r4.result     // Catch:{ Exception -> 0x01e6 }
            com.android.internal.telephony.uicc.IccIoResult r4 = (com.android.internal.telephony.uicc.IccIoResult) r4     // Catch:{ Exception -> 0x01e6 }
            android.os.AsyncResult r3 = (android.os.AsyncResult) r3     // Catch:{ Exception -> 0x01e6 }
            boolean r3 = r1.processException(r5, r3)     // Catch:{ Exception -> 0x01e6 }
            if (r3 == 0) goto L_0x01ae
            goto L_0x0206
        L_0x01ae:
            byte[] r3 = r4.payload     // Catch:{ Exception -> 0x01e6 }
            int r13 = r0.arg1     // Catch:{ Exception -> 0x01e6 }
            byte r0 = r3[r9]     // Catch:{ Exception -> 0x01e6 }
            if (r10 != r0) goto L_0x01e0
            byte r0 = r3[r8]     // Catch:{ Exception -> 0x01e6 }
            if (r0 != 0) goto L_0x01da
            int r17 = getDataFileSize(r3)     // Catch:{ Exception -> 0x01e6 }
            com.android.internal.telephony.CommandsInterface r11 = r1.mCi     // Catch:{ Exception -> 0x01e6 }
            r12 = 176(0xb0, float:2.47E-43)
            java.lang.String r14 = r1.getEFPath(r13)     // Catch:{ Exception -> 0x01e6 }
            r15 = 0
            r16 = 0
            r18 = 0
            r19 = 0
            java.lang.String r0 = r1.mAid     // Catch:{ Exception -> 0x01e6 }
            r3 = 5
            android.os.Message r21 = r1.obtainMessage(r3, r13, r6, r5)     // Catch:{ Exception -> 0x01e6 }
            r20 = r0
            r11.iccIOForApp(r12, r13, r14, r15, r16, r17, r18, r19, r20, r21)     // Catch:{ Exception -> 0x01e6 }
            goto L_0x0206
        L_0x01da:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x01e6 }
            r0.<init>()     // Catch:{ Exception -> 0x01e6 }
            throw r0     // Catch:{ Exception -> 0x01e6 }
        L_0x01e0:
            com.android.internal.telephony.uicc.IccFileTypeMismatch r0 = new com.android.internal.telephony.uicc.IccFileTypeMismatch     // Catch:{ Exception -> 0x01e6 }
            r0.<init>()     // Catch:{ Exception -> 0x01e6 }
            throw r0     // Catch:{ Exception -> 0x01e6 }
        L_0x01e6:
            r0 = move-exception
            r4 = r5
            goto L_0x01eb
        L_0x01e9:
            r0 = move-exception
            r4 = r2
        L_0x01eb:
            if (r4 == 0) goto L_0x01f1
            r1.sendResult(r4, r2, r0)
            goto L_0x0206
        L_0x01f1:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "uncaught exception"
            r2.append(r3)
            r2.append(r0)
            java.lang.String r0 = r2.toString()
            r1.loge(r0)
        L_0x0206:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.IccFileHandler.handleMessage(android.os.Message):void");
    }

    private static int getDataFileSize(byte[] bArr) {
        return ((bArr[2] & UByte.MAX_VALUE) << 8) + (bArr[3] & UByte.MAX_VALUE);
    }

    public void loadEFLinearFixedAll(int i, Message message, boolean z) {
        sendResult(message, (Object) null, new IccException("Default loadEFLinearFixedAll exception."));
    }

    public void loadEFLinearFixedAll(int i, int i2, Message message) {
        sendResult(message, (Object) null, new IccException("Default loadEFLinearFixedAll exception."));
    }

    public void loadEFTransparent(int i, String str, Message message) {
        sendResult(message, (Object) null, new IccException("Default loadEFTransparent exception."));
    }

    public void updateEFTransparent(int i, String str, byte[] bArr, Message message) {
        sendResult(message, (Object) null, new IccException("Default updateEFTransparent exception."));
    }

    public void readEFLinearFixed(int i, int i2, int i3, Message message) {
        sendResult(message, (Object) null, new IccException("Default readEFLinearFixed exception."));
    }

    public void selectEFFile(int i, Message message) {
        sendResult(message, (Object) null, new IccException("Default selectEFFile exception."));
    }
}
