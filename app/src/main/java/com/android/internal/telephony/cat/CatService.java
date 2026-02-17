package com.android.internal.telephony.cat;

import android.app.ActivityManager;
import android.app.backup.BackupManager;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.LocaleList;
import android.os.Message;
import android.os.RemoteException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.cat.AppInterface;
import com.android.internal.telephony.cat.Duration;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.IccRefreshResponse;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccProfile;
import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class CatService extends Handler implements AppInterface {
    private static final boolean DBG = false;
    protected static final int DEV_ID_DISPLAY = 2;
    protected static final int DEV_ID_KEYPAD = 1;
    protected static final int DEV_ID_NETWORK = 131;
    protected static final int DEV_ID_TERMINAL = 130;
    protected static final int DEV_ID_UICC = 129;
    protected static final int MSG_ID_ALPHA_NOTIFY = 9;
    public static final int MSG_ID_CALL_SETUP = 4;
    public static final int MSG_ID_EVENT_NOTIFY = 3;
    protected static final int MSG_ID_ICC_CHANGED = 8;
    public static final int MSG_ID_ICC_RECORDS_LOADED = 20;
    public static final int MSG_ID_ICC_REFRESH = 30;
    public static final int MSG_ID_PROACTIVE_COMMAND = 2;
    public static final int MSG_ID_REFRESH = 5;
    public static final int MSG_ID_RESPONSE = 6;
    public static final int MSG_ID_RIL_MSG_DECODED = 10;
    public static final int MSG_ID_SESSION_END = 1;
    public static final int MSG_ID_SIM_READY = 7;
    public static final String STK_DEFAULT = "Default Message";
    protected static IccRecords mIccRecords;
    protected static UiccCardApplication mUiccApplication;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static CatService[] sInstance;
    @UnsupportedAppUsage
    protected static final Object sInstanceLock = new Object();
    protected IccCardStatus.CardState mCardState = IccCardStatus.CardState.CARDSTATE_ABSENT;
    @UnsupportedAppUsage
    protected CommandsInterface mCmdIf;
    @UnsupportedAppUsage
    protected Context mContext;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected CatCmdMessage mCurrntCmd = null;
    @UnsupportedAppUsage
    protected CatCmdMessage mMenuCmd = null;
    @UnsupportedAppUsage
    protected RilMessageDecoder mMsgDecoder = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mSlotId;
    @UnsupportedAppUsage
    protected boolean mStkAppInstalled = false;
    @UnsupportedAppUsage
    protected UiccController mUiccController;

    /* access modifiers changed from: protected */
    public void onSetResponsedFlag() {
    }

    public CatService(CommandsInterface commandsInterface, UiccCardApplication uiccCardApplication, IccRecords iccRecords, Context context, IccFileHandler iccFileHandler, UiccProfile uiccProfile, int i) {
        if (commandsInterface == null || uiccCardApplication == null || iccRecords == null || context == null || iccFileHandler == null || uiccProfile == null) {
            throw new NullPointerException("Service: Input parameters must not be null");
        }
        this.mCmdIf = commandsInterface;
        this.mContext = context;
        this.mSlotId = i;
        RilMessageDecoder instance = RilMessageDecoder.getInstance(this, iccFileHandler, context, i);
        this.mMsgDecoder = instance;
        if (instance == null) {
            CatLog.d((Object) this, "Null RilMessageDecoder instance");
            return;
        }
        instance.start();
        this.mCmdIf.setOnCatSessionEnd(this, 1, (Object) null);
        this.mCmdIf.setOnCatProactiveCmd(this, 2, (Object) null);
        this.mCmdIf.setOnCatEvent(this, 3, (Object) null);
        this.mCmdIf.setOnCatCallSetUp(this, 4, (Object) null);
        this.mCmdIf.registerForIccRefresh(this, 30, (Object) null);
        this.mCmdIf.setOnCatCcAlphaNotify(this, 9, (Object) null);
        mIccRecords = iccRecords;
        mUiccApplication = uiccCardApplication;
        iccRecords.registerForRecordsLoaded(this, 20, (Object) null);
        CatLog.d((Object) this, "registerForRecordsLoaded slotid=" + this.mSlotId + " instance:" + this);
        UiccController instance2 = UiccController.getInstance();
        this.mUiccController = instance2;
        instance2.registerForIccChanged(this, 8, (Object) null);
        this.mStkAppInstalled = isStkAppInstalled();
        CatLog.d((Object) this, "Running CAT service on Slotid: " + this.mSlotId + ". STK app installed:" + this.mStkAppInstalled);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r4v0, resolved type: com.android.internal.telephony.uicc.IccRecords} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r4v5, resolved type: com.android.internal.telephony.uicc.IccRecords} */
    /* JADX WARNING: type inference failed for: r4v6 */
    /*  JADX ERROR: IndexOutOfBoundsException in pass: RegionMakerVisitor
        java.lang.IndexOutOfBoundsException: Index: 0, Size: 0
        	at java.util.ArrayList.rangeCheck(ArrayList.java:659)
        	at java.util.ArrayList.get(ArrayList.java:435)
        	at jadx.core.dex.nodes.InsnNode.getArg(InsnNode.java:101)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:611)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverseMonitorExits(RegionMaker.java:619)
        	at jadx.core.dex.visitors.regions.RegionMaker.processMonitorEnter(RegionMaker.java:561)
        	at jadx.core.dex.visitors.regions.RegionMaker.traverse(RegionMaker.java:133)
        	at jadx.core.dex.visitors.regions.RegionMaker.makeRegion(RegionMaker.java:86)
        	at jadx.core.dex.visitors.regions.RegionMakerVisitor.visit(RegionMakerVisitor.java:49)
        */
    /* JADX WARNING: Multi-variable type inference failed */
    public static com.android.internal.telephony.cat.CatService getInstance(com.android.internal.telephony.CommandsInterface r11, android.content.Context r12, com.android.internal.telephony.uicc.UiccProfile r13, int r14) {
        /*
            r1 = 0
            r2 = 0
            if (r13 == 0) goto L_0x0017
            com.android.internal.telephony.uicc.UiccCardApplication r3 = r13.getApplicationIndex(r1)
            if (r3 == 0) goto L_0x0015
            com.android.internal.telephony.uicc.IccFileHandler r4 = r3.getIccFileHandler()
            com.android.internal.telephony.uicc.IccRecords r5 = r3.getIccRecords()
            r6 = r4
            r4 = r5
            goto L_0x001a
        L_0x0015:
            r4 = r2
            goto L_0x0019
        L_0x0017:
            r3 = r2
            r4 = r3
        L_0x0019:
            r6 = r4
        L_0x001a:
            java.lang.Object r9 = sInstanceLock
            monitor-enter(r9)
            com.android.internal.telephony.cat.CatService[] r5 = sInstance     // Catch:{ all -> 0x00a6 }
            if (r5 != 0) goto L_0x0036
            android.telephony.TelephonyManager r5 = android.telephony.TelephonyManager.getDefault()     // Catch:{ all -> 0x00a6 }
            int r5 = r5.getSupportedModemCount()     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.cat.CatService[] r7 = new com.android.internal.telephony.cat.CatService[r5]     // Catch:{ all -> 0x00a6 }
            sInstance = r7     // Catch:{ all -> 0x00a6 }
        L_0x002d:
            if (r1 >= r5) goto L_0x0036
            com.android.internal.telephony.cat.CatService[] r7 = sInstance     // Catch:{ all -> 0x00a6 }
            r7[r1] = r2     // Catch:{ all -> 0x00a6 }
            int r1 = r1 + 1
            goto L_0x002d
        L_0x0036:
            com.android.internal.telephony.cat.CatService[] r10 = sInstance     // Catch:{ all -> 0x00a6 }
            r1 = r10[r14]     // Catch:{ all -> 0x00a6 }
            if (r1 != 0) goto L_0x0064
            if (r11 == 0) goto L_0x0062
            if (r3 == 0) goto L_0x0062
            if (r4 == 0) goto L_0x0062
            if (r12 == 0) goto L_0x0062
            if (r6 == 0) goto L_0x0062
            if (r13 != 0) goto L_0x0049
            goto L_0x0062
        L_0x0049:
            com.android.internal.telephony.TelephonyComponentFactory r1 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()     // Catch:{ all -> 0x00a6 }
            java.lang.Class<com.android.internal.telephony.TelephonyComponentFactory> r2 = com.android.internal.telephony.TelephonyComponentFactory.class
            java.lang.String r2 = r2.getName()     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.TelephonyComponentFactory r1 = r1.inject(r2)     // Catch:{ all -> 0x00a6 }
            r2 = r11
            r5 = r12
            r7 = r13
            r8 = r14
            com.android.internal.telephony.cat.CatService r0 = r1.makeCatService(r2, r3, r4, r5, r6, r7, r8)     // Catch:{ all -> 0x00a6 }
            r10[r14] = r0     // Catch:{ all -> 0x00a6 }
            goto L_0x00a0
        L_0x0062:
            monitor-exit(r9)     // Catch:{ all -> 0x00a6 }
            return r2
        L_0x0064:
            if (r4 == 0) goto L_0x00a0
            com.android.internal.telephony.uicc.IccRecords r0 = mIccRecords     // Catch:{ all -> 0x00a6 }
            if (r0 == r4) goto L_0x00a0
            if (r0 == 0) goto L_0x006f
            r0.unregisterForRecordsLoaded(r1)     // Catch:{ all -> 0x00a6 }
        L_0x006f:
            mIccRecords = r4     // Catch:{ all -> 0x00a6 }
            mUiccApplication = r3     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.cat.CatService[] r0 = sInstance     // Catch:{ all -> 0x00a6 }
            r0 = r0[r14]     // Catch:{ all -> 0x00a6 }
            r1 = 20
            r4.registerForRecordsLoaded(r0, r1, r2)     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.cat.CatService[] r0 = sInstance     // Catch:{ all -> 0x00a6 }
            r0 = r0[r14]     // Catch:{ all -> 0x00a6 }
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00a6 }
            r1.<init>()     // Catch:{ all -> 0x00a6 }
            java.lang.String r2 = "registerForRecordsLoaded slotid="
            r1.append(r2)     // Catch:{ all -> 0x00a6 }
            r1.append(r14)     // Catch:{ all -> 0x00a6 }
            java.lang.String r2 = " instance:"
            r1.append(r2)     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.cat.CatService[] r2 = sInstance     // Catch:{ all -> 0x00a6 }
            r2 = r2[r14]     // Catch:{ all -> 0x00a6 }
            r1.append(r2)     // Catch:{ all -> 0x00a6 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x00a6 }
            com.android.internal.telephony.cat.CatLog.d((java.lang.Object) r0, (java.lang.String) r1)     // Catch:{ all -> 0x00a6 }
        L_0x00a0:
            com.android.internal.telephony.cat.CatService[] r0 = sInstance     // Catch:{ all -> 0x00a6 }
            r0 = r0[r14]     // Catch:{ all -> 0x00a6 }
            monitor-exit(r9)     // Catch:{ all -> 0x00a6 }
            return r0
        L_0x00a6:
            r0 = move-exception
            monitor-exit(r9)     // Catch:{ all -> 0x00a6 }
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CatService.getInstance(com.android.internal.telephony.CommandsInterface, android.content.Context, com.android.internal.telephony.uicc.UiccProfile, int):com.android.internal.telephony.cat.CatService");
    }

    @UnsupportedAppUsage
    public void dispose() {
        synchronized (sInstanceLock) {
            CatLog.d((Object) this, "Disposing CatService object");
            mIccRecords.unregisterForRecordsLoaded(this);
            broadcastCardStateAndIccRefreshResp(IccCardStatus.CardState.CARDSTATE_ABSENT, (IccRefreshResponse) null);
            this.mCmdIf.unSetOnCatSessionEnd(this);
            this.mCmdIf.unSetOnCatProactiveCmd(this);
            this.mCmdIf.unSetOnCatEvent(this);
            this.mCmdIf.unSetOnCatCallSetUp(this);
            this.mCmdIf.unSetOnCatCcAlphaNotify(this);
            this.mCmdIf.unregisterForIccRefresh(this);
            UiccController uiccController = this.mUiccController;
            if (uiccController != null) {
                uiccController.unregisterForIccChanged(this);
                this.mUiccController = null;
            }
            RilMessageDecoder rilMessageDecoder = this.mMsgDecoder;
            if (rilMessageDecoder != null) {
                rilMessageDecoder.dispose();
                this.mMsgDecoder = null;
            }
            removeCallbacksAndMessages((Object) null);
            CatService[] catServiceArr = sInstance;
            if (catServiceArr != null) {
                int i = this.mSlotId;
                if (i < 0 || i >= catServiceArr.length) {
                    CatLog.d((Object) this, "error: invaild slot id: " + this.mSlotId);
                } else {
                    catServiceArr[i] = null;
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        CatLog.d((Object) this, "Service finalized");
    }

    /* access modifiers changed from: protected */
    public void handleRilMsg(RilMessage rilMessage) {
        CommandParams commandParams;
        CommandParams commandParams2;
        if (rilMessage != null) {
            int i = rilMessage.mId;
            if (i == 1) {
                handleSessionEnd();
            } else if (i == 2) {
                try {
                    CommandParams commandParams3 = (CommandParams) rilMessage.mData;
                    if (commandParams3 != null) {
                        ResultCode resultCode = rilMessage.mResCode;
                        if (resultCode == ResultCode.OK) {
                            handleCommand(commandParams3, true);
                            return;
                        }
                        sendTerminalResponse(commandParams3.mCmdDet, resultCode, false, 0, (ResponseData) null);
                    }
                } catch (ClassCastException unused) {
                    CatLog.d((Object) this, "Fail to parse proactive command");
                    CatCmdMessage catCmdMessage = this.mCurrntCmd;
                    if (catCmdMessage != null) {
                        sendTerminalResponse(catCmdMessage.mCmdDet, ResultCode.CMD_DATA_NOT_UNDERSTOOD, false, 0, (ResponseData) null);
                    }
                }
            } else if (i != 3) {
                if (i == 5 && (commandParams2 = (CommandParams) rilMessage.mData) != null) {
                    handleCommand(commandParams2, false);
                }
            } else if (rilMessage.mResCode == ResultCode.OK && (commandParams = (CommandParams) rilMessage.mData) != null) {
                handleCommand(commandParams, false);
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean isSupportedSetupEventCommand(CatCmdMessage catCmdMessage) {
        boolean z = true;
        for (int i : catCmdMessage.getSetEventList().eventList) {
            CatLog.d((Object) this, "Event: " + i);
            if (!(i == 4 || i == 5 || i == 7)) {
                z = false;
            }
        }
        return z;
    }

    /* access modifiers changed from: protected */
    public void handleCommand(CommandParams commandParams, boolean z) {
        ResultCode resultCode;
        ResultCode resultCode2;
        boolean z2;
        CatLog.d((Object) this, commandParams.getCommandType().name());
        if (z) {
            UiccController.addLocalLog("CatService[" + this.mSlotId + "]: ProactiveCommand  cmdParams=" + commandParams);
        }
        CatCmdMessage catCmdMessage = new CatCmdMessage(commandParams);
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[commandParams.getCommandType().ordinal()]) {
            case 1:
                if (removeMenu(catCmdMessage.getMenu())) {
                    this.mMenuCmd = null;
                } else {
                    this.mMenuCmd = catCmdMessage;
                }
                if (commandParams.mLoadIconFailed) {
                    resultCode = ResultCode.PRFRMD_ICON_NOT_DISPLAYED;
                } else {
                    resultCode = ResultCode.OK;
                }
                sendTerminalResponse(commandParams.mCmdDet, resultCode, false, 0, (ResponseData) null);
                break;
            case 2:
            case 7:
            case 8:
            case 9:
            case 16:
                break;
            case 3:
                if (commandParams.mLoadIconFailed) {
                    resultCode2 = ResultCode.PRFRMD_ICON_NOT_DISPLAYED;
                } else {
                    resultCode2 = ResultCode.OK;
                }
                sendTerminalResponse(commandParams.mCmdDet, resultCode2, false, 0, (ResponseData) null);
                break;
            case 4:
                if (!isSupportedSetupEventCommand(catCmdMessage)) {
                    sendTerminalResponse(commandParams.mCmdDet, ResultCode.BEYOND_TERMINAL_CAPABILITY, false, 0, (ResponseData) null);
                    break;
                } else {
                    sendTerminalResponse(commandParams.mCmdDet, ResultCode.OK, false, 0, (ResponseData) null);
                    break;
                }
            case 5:
                CommandDetails commandDetails = commandParams.mCmdDet;
                int i = commandDetails.commandQualifier;
                if (i == 3) {
                    sendTerminalResponse(commandParams.mCmdDet, ResultCode.OK, false, 0, new DTTZResponseData((Calendar) null));
                    return;
                } else if (i != 4) {
                    sendTerminalResponse(commandDetails, ResultCode.OK, false, 0, (ResponseData) null);
                    return;
                } else {
                    sendTerminalResponse(commandParams.mCmdDet, ResultCode.OK, false, 0, new LanguageResponseData(Locale.getDefault().getLanguage()));
                    return;
                }
            case 6:
                LaunchBrowserParams launchBrowserParams = (LaunchBrowserParams) commandParams;
                String str = launchBrowserParams.mConfirmMsg.text;
                if (str != null && str.equals(STK_DEFAULT)) {
                    CharSequence text = this.mContext.getText(17040596);
                    launchBrowserParams.mConfirmMsg.text = text.toString();
                    break;
                }
            case 10:
            case 11:
                DisplayTextParams displayTextParams = (DisplayTextParams) commandParams;
                if (STK_DEFAULT.equals(displayTextParams.mTextMsg.text)) {
                    displayTextParams.mTextMsg.text = null;
                    break;
                }
                break;
            case 12:
            case 13:
            case 14:
            case 15:
                DisplayTextParams displayTextParams2 = (DisplayTextParams) commandParams;
                String str2 = displayTextParams2.mTextMsg.text;
                if (str2 != null && str2.equals(STK_DEFAULT)) {
                    CharSequence text2 = this.mContext.getText(17041508);
                    displayTextParams2.mTextMsg.text = text2.toString();
                    break;
                }
            case 17:
                CallSetupParams callSetupParams = (CallSetupParams) commandParams;
                String str3 = callSetupParams.mConfirmMsg.text;
                if (str3 != null && str3.equals(STK_DEFAULT)) {
                    CharSequence text3 = this.mContext.getText(17039567);
                    callSetupParams.mConfirmMsg.text = text3.toString();
                    break;
                }
            case 18:
                String str4 = ((LanguageParams) commandParams).mLanguage;
                ResultCode resultCode3 = ResultCode.OK;
                if (str4 != null && str4.length() > 0) {
                    try {
                        changeLanguage(str4);
                    } catch (RemoteException unused) {
                        resultCode3 = ResultCode.TERMINAL_CRNTLY_UNABLE_TO_PROCESS;
                    }
                }
                sendTerminalResponse(commandParams.mCmdDet, resultCode3, false, 0, (ResponseData) null);
                return;
            case 19:
            case 20:
            case 21:
            case 22:
                BIPClientParams bIPClientParams = (BIPClientParams) commandParams;
                try {
                    z2 = this.mContext.getResources().getBoolean(17891771);
                } catch (Resources.NotFoundException unused2) {
                    z2 = false;
                }
                if (bIPClientParams.mTextMsg.text != null || (!bIPClientParams.mHasAlphaId && !z2)) {
                    if (!this.mStkAppInstalled) {
                        CatLog.d((Object) this, "No STK application found.");
                        if (z) {
                            sendTerminalResponse(commandParams.mCmdDet, ResultCode.BEYOND_TERMINAL_CAPABILITY, false, 0, (ResponseData) null);
                            return;
                        }
                    }
                    if (z && (commandParams.getCommandType() == AppInterface.CommandType.CLOSE_CHANNEL || commandParams.getCommandType() == AppInterface.CommandType.RECEIVE_DATA || commandParams.getCommandType() == AppInterface.CommandType.SEND_DATA)) {
                        sendTerminalResponse(commandParams.mCmdDet, ResultCode.OK, false, 0, (ResponseData) null);
                        break;
                    }
                } else {
                    CatLog.d((Object) this, "cmd " + commandParams.getCommandType() + " with null alpha id");
                    if (z) {
                        sendTerminalResponse(commandParams.mCmdDet, ResultCode.OK, false, 0, (ResponseData) null);
                        return;
                    } else if (commandParams.getCommandType() == AppInterface.CommandType.OPEN_CHANNEL) {
                        this.mCmdIf.handleCallSetupRequestFromSim(true, (Message) null);
                        return;
                    } else {
                        return;
                    }
                }
                break;
            default:
                CatLog.d((Object) this, "Unsupported command");
                return;
        }
        this.mCurrntCmd = catCmdMessage;
        broadcastCatCmdIntent(catCmdMessage);
    }

    /* access modifiers changed from: protected */
    public void broadcastCatCmdIntent(CatCmdMessage catCmdMessage) {
        Intent intent = new Intent(AppInterface.CAT_CMD_ACTION);
        intent.putExtra("STK CMD", catCmdMessage);
        intent.putExtra("SLOT_ID", this.mSlotId);
        intent.setComponent(AppInterface.getDefaultSTKApplication());
        CatLog.d((Object) this, "Sending CmdMsg: " + catCmdMessage + " on slotid:" + this.mSlotId);
        this.mContext.sendBroadcast(intent, AppInterface.STK_PERMISSION);
    }

    /* access modifiers changed from: protected */
    public void handleSessionEnd() {
        CatLog.d((Object) this, "SESSION END on " + this.mSlotId);
        this.mCurrntCmd = this.mMenuCmd;
        Intent intent = new Intent(AppInterface.CAT_SESSION_END_ACTION);
        intent.putExtra("SLOT_ID", this.mSlotId);
        intent.setComponent(AppInterface.getDefaultSTKApplication());
        this.mContext.sendBroadcast(intent, AppInterface.STK_PERMISSION);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendTerminalResponse(CommandDetails commandDetails, ResultCode resultCode, boolean z, int i, ResponseData responseData) {
        if (commandDetails != null) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            CatCmdMessage catCmdMessage = this.mCurrntCmd;
            Input geInput = catCmdMessage != null ? catCmdMessage.geInput() : null;
            int value = ComprehensionTlvTag.COMMAND_DETAILS.value();
            if (commandDetails.compRequired) {
                value |= 128;
            }
            byteArrayOutputStream.write(value);
            byteArrayOutputStream.write(3);
            byteArrayOutputStream.write(commandDetails.commandNumber);
            byteArrayOutputStream.write(commandDetails.typeOfCommand);
            byteArrayOutputStream.write(commandDetails.commandQualifier);
            byteArrayOutputStream.write(ComprehensionTlvTag.DEVICE_IDENTITIES.value());
            int i2 = 2;
            byteArrayOutputStream.write(2);
            byteArrayOutputStream.write(130);
            byteArrayOutputStream.write(129);
            int value2 = ComprehensionTlvTag.RESULT.value();
            if (commandDetails.compRequired) {
                value2 |= 128;
            }
            byteArrayOutputStream.write(value2);
            if (!z) {
                i2 = 1;
            }
            byteArrayOutputStream.write(i2);
            byteArrayOutputStream.write(resultCode.value());
            if (z) {
                byteArrayOutputStream.write(i);
            }
            if (responseData != null) {
                responseData.format(byteArrayOutputStream);
            } else {
                encodeOptionalTags(commandDetails, resultCode, geInput, byteArrayOutputStream);
            }
            this.mCmdIf.sendTerminalResponse(IccUtils.bytesToHexString(byteArrayOutputStream.toByteArray()), (Message) null);
            onSetResponsedFlag();
        }
    }

    /* access modifiers changed from: protected */
    public void encodeOptionalTags(CommandDetails commandDetails, ResultCode resultCode, Input input, ByteArrayOutputStream byteArrayOutputStream) {
        AppInterface.CommandType fromInt = AppInterface.CommandType.fromInt(commandDetails.typeOfCommand);
        if (fromInt != null) {
            int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[fromInt.ordinal()];
            if (i != 5) {
                if (i != 8 && i != 9) {
                    CatLog.d((Object) this, "encodeOptionalTags() Unsupported Cmd details=" + commandDetails);
                } else if (resultCode.value() == ResultCode.NO_RESPONSE_FROM_USER.value() && input != null && input.duration != null) {
                    getInKeyResponse(byteArrayOutputStream, input);
                }
            } else if (commandDetails.commandQualifier == 4 && resultCode.value() == ResultCode.OK.value()) {
                getPliResponse(byteArrayOutputStream);
            }
        } else {
            CatLog.d((Object) this, "encodeOptionalTags() bad Cmd details=" + commandDetails);
        }
    }

    /* access modifiers changed from: protected */
    public void getInKeyResponse(ByteArrayOutputStream byteArrayOutputStream, Input input) {
        byteArrayOutputStream.write(ComprehensionTlvTag.DURATION.value());
        byteArrayOutputStream.write(2);
        Duration.TimeUnit timeUnit = input.duration.timeUnit;
        byteArrayOutputStream.write(Duration.TimeUnit.SECOND.value());
        byteArrayOutputStream.write(input.duration.timeInterval);
    }

    /* access modifiers changed from: protected */
    public void getPliResponse(ByteArrayOutputStream byteArrayOutputStream) {
        String language = Locale.getDefault().getLanguage();
        if (language != null) {
            byteArrayOutputStream.write(ComprehensionTlvTag.LANGUAGE.value());
            ResponseData.writeLength(byteArrayOutputStream, language.length());
            byteArrayOutputStream.write(language.getBytes(), 0, language.length());
        }
    }

    /* access modifiers changed from: protected */
    public void sendMenuSelection(int i, boolean z) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byteArrayOutputStream.write(211);
        byteArrayOutputStream.write(0);
        byteArrayOutputStream.write(ComprehensionTlvTag.DEVICE_IDENTITIES.value() | 128);
        byteArrayOutputStream.write(2);
        byteArrayOutputStream.write(1);
        byteArrayOutputStream.write(129);
        byteArrayOutputStream.write(ComprehensionTlvTag.ITEM_ID.value() | 128);
        byteArrayOutputStream.write(1);
        byteArrayOutputStream.write(i);
        if (z) {
            byteArrayOutputStream.write(ComprehensionTlvTag.HELP_REQUEST.value());
            byteArrayOutputStream.write(0);
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        byteArray[1] = (byte) (byteArray.length - 2);
        this.mCmdIf.sendEnvelope(IccUtils.bytesToHexString(byteArray), (Message) null);
    }

    /* access modifiers changed from: protected */
    public void eventDownload(int i, int i2, int i3, byte[] bArr, boolean z) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byteArrayOutputStream.write(BerTlv.BER_EVENT_DOWNLOAD_TAG);
        byteArrayOutputStream.write(0);
        byteArrayOutputStream.write(ComprehensionTlvTag.EVENT_LIST.value() | 128);
        byteArrayOutputStream.write(1);
        byteArrayOutputStream.write(i);
        byteArrayOutputStream.write(ComprehensionTlvTag.DEVICE_IDENTITIES.value() | 128);
        byteArrayOutputStream.write(2);
        byteArrayOutputStream.write(i2);
        byteArrayOutputStream.write(i3);
        if (i == 5) {
            CatLog.d((Object) sInstance, " Sending Idle Screen Available event download to ICC");
        } else if (i == 7) {
            CatLog.d((Object) sInstance, " Sending Language Selection event download to ICC");
            byteArrayOutputStream.write(ComprehensionTlvTag.LANGUAGE.value() | 128);
            byteArrayOutputStream.write(2);
        }
        if (bArr != null) {
            for (byte write : bArr) {
                byteArrayOutputStream.write(write);
            }
        }
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        byteArray[1] = (byte) (byteArray.length - 2);
        String bytesToHexString = IccUtils.bytesToHexString(byteArray);
        CatLog.d((Object) this, "ENVELOPE COMMAND: " + bytesToHexString);
        this.mCmdIf.sendEnvelope(bytesToHexString, (Message) null);
    }

    public static AppInterface getInstance() {
        SubscriptionController instance = SubscriptionController.getInstance();
        return getInstance((CommandsInterface) null, (Context) null, (UiccProfile) null, instance != null ? instance.getSlotIndex(instance.getDefaultSubId()) : 0);
    }

    public static AppInterface getInstance(int i) {
        return getInstance((CommandsInterface) null, (Context) null, (UiccProfile) null, i);
    }

    public void handleMessage(Message message) {
        Object obj;
        AsyncResult asyncResult;
        Object obj2;
        Object obj3;
        CatLog.d((Object) this, "handleMessage[" + message.what + "]");
        int i = message.what;
        if (i == 20) {
            return;
        }
        if (i != 30) {
            String str = null;
            switch (i) {
                case 1:
                case 2:
                case 3:
                case 5:
                    CatLog.d((Object) this, "ril message arrived,slotid:" + this.mSlotId);
                    Object obj4 = message.obj;
                    if (!(obj4 == null || (asyncResult = (AsyncResult) obj4) == null || (obj2 = asyncResult.result) == null)) {
                        try {
                            str = (String) obj2;
                        } catch (ClassCastException unused) {
                            return;
                        }
                    }
                    this.mMsgDecoder.sendStartDecodingMessageParams(new RilMessage(message.what, str));
                    return;
                case 4:
                    this.mMsgDecoder.sendStartDecodingMessageParams(new RilMessage(i, (String) null));
                    return;
                case 6:
                    handleCmdResponse((CatResponseMessage) message.obj);
                    return;
                default:
                    switch (i) {
                        case 8:
                            CatLog.d((Object) this, "MSG_ID_ICC_CHANGED");
                            updateIccAvailability();
                            return;
                        case 9:
                            CatLog.d((Object) this, "Received CAT CC Alpha message from card");
                            Object obj5 = message.obj;
                            if (obj5 != null) {
                                AsyncResult asyncResult2 = (AsyncResult) obj5;
                                if (asyncResult2 == null || (obj3 = asyncResult2.result) == null) {
                                    CatLog.d((Object) this, "CAT Alpha message: ar.result is null");
                                    return;
                                } else {
                                    broadcastAlphaMessage((String) obj3);
                                    return;
                                }
                            } else {
                                CatLog.d((Object) this, "CAT Alpha message: msg.obj is null");
                                return;
                            }
                        case 10:
                            handleRilMsg((RilMessage) message.obj);
                            return;
                        default:
                            throw new AssertionError("Unrecognized CAT command: " + message.what);
                    }
            }
        } else {
            Object obj6 = message.obj;
            if (obj6 != null) {
                AsyncResult asyncResult3 = (AsyncResult) obj6;
                if (asyncResult3 == null || (obj = asyncResult3.result) == null) {
                    CatLog.d((Object) this, "Icc REFRESH with exception: " + asyncResult3.exception);
                    return;
                }
                broadcastCardStateAndIccRefreshResp(IccCardStatus.CardState.CARDSTATE_PRESENT, (IccRefreshResponse) obj);
                return;
            }
            CatLog.d((Object) this, "IccRefresh Message is null");
        }
    }

    /* access modifiers changed from: protected */
    public void broadcastCardStateAndIccRefreshResp(IccCardStatus.CardState cardState, IccRefreshResponse iccRefreshResponse) {
        Intent intent = new Intent(AppInterface.CAT_ICC_STATUS_CHANGE);
        boolean z = cardState == IccCardStatus.CardState.CARDSTATE_PRESENT;
        if (iccRefreshResponse != null) {
            intent.putExtra(AppInterface.REFRESH_RESULT, iccRefreshResponse.refreshResult);
            CatLog.d((Object) this, "Sending IccResult with Result: " + iccRefreshResponse.refreshResult);
        }
        intent.putExtra(AppInterface.CARD_STATUS, z);
        intent.setComponent(AppInterface.getDefaultSTKApplication());
        intent.putExtra("SLOT_ID", this.mSlotId);
        CatLog.d((Object) this, "Sending Card Status: " + cardState + " cardPresent: " + z + "SLOT_ID: " + this.mSlotId);
        this.mContext.sendBroadcast(intent, AppInterface.STK_PERMISSION);
    }

    /* access modifiers changed from: protected */
    public void broadcastAlphaMessage(String str) {
        CatLog.d((Object) this, "Broadcasting CAT Alpha message from card: " + str);
        Intent intent = new Intent(AppInterface.CAT_ALPHA_NOTIFY_ACTION);
        intent.addFlags(268435456);
        intent.putExtra(AppInterface.ALPHA_STRING, str);
        intent.putExtra("SLOT_ID", this.mSlotId);
        intent.setComponent(AppInterface.getDefaultSTKApplication());
        this.mContext.sendBroadcast(intent, AppInterface.STK_PERMISSION);
    }

    public synchronized void onCmdResponse(CatResponseMessage catResponseMessage) {
        if (catResponseMessage != null) {
            obtainMessage(6, catResponseMessage).sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public boolean validateResponse(CatResponseMessage catResponseMessage) {
        if (catResponseMessage.mCmdDet.typeOfCommand == AppInterface.CommandType.SET_UP_EVENT_LIST.value() || catResponseMessage.mCmdDet.typeOfCommand == AppInterface.CommandType.SET_UP_MENU.value()) {
            CatLog.d((Object) this, "CmdType: " + catResponseMessage.mCmdDet.typeOfCommand);
            return true;
        }
        CatCmdMessage catCmdMessage = this.mCurrntCmd;
        if (catCmdMessage == null) {
            return false;
        }
        boolean compareTo = catResponseMessage.mCmdDet.compareTo(catCmdMessage.mCmdDet);
        CatLog.d((Object) this, "isResponse for last valid cmd: " + compareTo);
        return compareTo;
    }

    /* access modifiers changed from: protected */
    public boolean removeMenu(Menu menu) {
        try {
            return menu.items.size() == 1 && menu.items.get(0) == null;
        } catch (NullPointerException unused) {
            CatLog.d((Object) this, "Unable to get Menu's items size");
            return true;
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x0088, code lost:
        r6 = r0;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleCmdResponse(com.android.internal.telephony.cat.CatResponseMessage r9) {
        /*
            r8 = this;
            boolean r0 = r8.validateResponse(r9)
            if (r0 != 0) goto L_0x0007
            return
        L_0x0007:
            com.android.internal.telephony.cat.CommandDetails r2 = r9.getCmdDetails()
            int r0 = r2.typeOfCommand
            com.android.internal.telephony.cat.AppInterface$CommandType r0 = com.android.internal.telephony.cat.AppInterface.CommandType.fromInt(r0)
            int[] r1 = com.android.internal.telephony.cat.CatService.AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$ResultCode
            com.android.internal.telephony.cat.ResultCode r3 = r9.mResCode
            int r3 = r3.ordinal()
            r1 = r1[r3]
            r3 = 1
            r4 = 0
            r7 = 0
            switch(r1) {
                case 1: goto L_0x0043;
                case 2: goto L_0x0041;
                case 3: goto L_0x0041;
                case 4: goto L_0x0041;
                case 5: goto L_0x0041;
                case 6: goto L_0x0041;
                case 7: goto L_0x0041;
                case 8: goto L_0x0041;
                case 9: goto L_0x0041;
                case 10: goto L_0x0041;
                case 11: goto L_0x0041;
                case 12: goto L_0x0041;
                case 13: goto L_0x0041;
                case 14: goto L_0x0031;
                case 15: goto L_0x0031;
                case 16: goto L_0x0022;
                case 17: goto L_0x002e;
                default: goto L_0x0021;
            }
        L_0x0021:
            return
        L_0x0022:
            com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_CALL
            if (r0 != r1) goto L_0x002e
            com.android.internal.telephony.CommandsInterface r9 = r8.mCmdIf
            r9.handleCallSetupRequestFromSim(r4, r7)
            r8.mCurrntCmd = r7
            return
        L_0x002e:
            r6 = r7
            goto L_0x00d0
        L_0x0031:
            com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_CALL
            if (r0 == r1) goto L_0x0039
            com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.OPEN_CHANNEL
            if (r0 != r1) goto L_0x002e
        L_0x0039:
            com.android.internal.telephony.CommandsInterface r9 = r8.mCmdIf
            r9.handleCallSetupRequestFromSim(r4, r7)
            r8.mCurrntCmd = r7
            return
        L_0x0041:
            r1 = r4
            goto L_0x0044
        L_0x0043:
            r1 = r3
        L_0x0044:
            int[] r5 = com.android.internal.telephony.cat.CatService.AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType
            int r0 = r0.ordinal()
            r0 = r5[r0]
            if (r0 == r3) goto L_0x00dd
            r5 = 2
            if (r0 == r5) goto L_0x00bf
            r3 = 4
            if (r0 == r3) goto L_0x00a3
            r5 = 17
            if (r0 == r5) goto L_0x0099
            r5 = 19
            if (r0 == r5) goto L_0x0099
            switch(r0) {
                case 6: goto L_0x008a;
                case 7: goto L_0x0081;
                case 8: goto L_0x0060;
                case 9: goto L_0x0060;
                default: goto L_0x005f;
            }
        L_0x005f:
            goto L_0x002e
        L_0x0060:
            com.android.internal.telephony.cat.CatCmdMessage r0 = r8.mCurrntCmd
            com.android.internal.telephony.cat.Input r0 = r0.geInput()
            boolean r3 = r0.yesNo
            if (r3 != 0) goto L_0x0079
            if (r1 != 0) goto L_0x002e
            com.android.internal.telephony.cat.GetInkeyInputResponseData r1 = new com.android.internal.telephony.cat.GetInkeyInputResponseData
            java.lang.String r3 = r9.mUsersInput
            boolean r4 = r0.ucs2
            boolean r0 = r0.packed
            r1.<init>(r3, r4, r0)
            r6 = r1
            goto L_0x00d0
        L_0x0079:
            com.android.internal.telephony.cat.GetInkeyInputResponseData r0 = new com.android.internal.telephony.cat.GetInkeyInputResponseData
            boolean r1 = r9.mUsersYesNoSelection
            r0.<init>(r1)
            goto L_0x0088
        L_0x0081:
            com.android.internal.telephony.cat.SelectItemResponseData r0 = new com.android.internal.telephony.cat.SelectItemResponseData
            int r1 = r9.mUsersMenuSelection
            r0.<init>(r1)
        L_0x0088:
            r6 = r0
            goto L_0x00d0
        L_0x008a:
            com.android.internal.telephony.cat.ResultCode r0 = r9.mResCode
            com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.LAUNCH_BROWSER_ERROR
            if (r0 != r1) goto L_0x0094
            r9.setAdditionalInfo(r3)
            goto L_0x002e
        L_0x0094:
            r9.mIncludeAdditionalInfo = r4
            r9.mAdditionalInfo = r4
            goto L_0x002e
        L_0x0099:
            com.android.internal.telephony.CommandsInterface r0 = r8.mCmdIf
            boolean r9 = r9.mUsersConfirm
            r0.handleCallSetupRequestFromSim(r9, r7)
            r8.mCurrntCmd = r7
            return
        L_0x00a3:
            r0 = 5
            int r2 = r9.mEventValue
            if (r0 != r2) goto L_0x00b3
            r3 = 2
            r4 = 129(0x81, float:1.81E-43)
            byte[] r5 = r9.mAddedInfo
            r6 = 0
            r1 = r8
            r1.eventDownload(r2, r3, r4, r5, r6)
            goto L_0x00be
        L_0x00b3:
            r3 = 130(0x82, float:1.82E-43)
            r4 = 129(0x81, float:1.81E-43)
            byte[] r5 = r9.mAddedInfo
            r6 = 0
            r1 = r8
            r1.eventDownload(r2, r3, r4, r5, r6)
        L_0x00be:
            return
        L_0x00bf:
            com.android.internal.telephony.cat.ResultCode r0 = r9.mResCode
            com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.TERMINAL_CRNTLY_UNABLE_TO_PROCESS
            if (r0 != r1) goto L_0x00ca
            r9.setAdditionalInfo(r3)
            goto L_0x002e
        L_0x00ca:
            r9.mIncludeAdditionalInfo = r4
            r9.mAdditionalInfo = r4
            goto L_0x002e
        L_0x00d0:
            com.android.internal.telephony.cat.ResultCode r3 = r9.mResCode
            boolean r4 = r9.mIncludeAdditionalInfo
            int r5 = r9.mAdditionalInfo
            r1 = r8
            r1.sendTerminalResponse(r2, r3, r4, r5, r6)
            r8.mCurrntCmd = r7
            return
        L_0x00dd:
            com.android.internal.telephony.cat.ResultCode r0 = r9.mResCode
            com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.HELP_INFO_REQUIRED
            if (r0 != r1) goto L_0x00e4
            goto L_0x00e5
        L_0x00e4:
            r3 = r4
        L_0x00e5:
            int r9 = r9.mUsersMenuSelection
            r8.sendMenuSelection(r9, r3)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CatService.handleCmdResponse(com.android.internal.telephony.cat.CatResponseMessage):void");
    }

    /* renamed from: com.android.internal.telephony.cat.CatService$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$cat$ResultCode;

        /* JADX WARNING: Can't wrap try/catch for region: R(79:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|(2:17|18)|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|(2:37|38)|39|(2:41|42)|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|(2:57|58)|59|(2:61|62)|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|(3:111|112|114)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(80:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|(2:17|18)|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|(2:37|38)|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|(2:57|58)|59|(2:61|62)|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|(3:111|112|114)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(81:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|(2:17|18)|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|(2:37|38)|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|(2:57|58)|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|(3:111|112|114)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(82:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|(2:37|38)|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|(2:57|58)|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|(3:111|112|114)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(85:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|(2:57|58)|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(86:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|(2:13|14)|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(87:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|13|14|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|(2:33|34)|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(88:0|(2:1|2)|3|(2:5|6)|7|(2:9|10)|11|13|14|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|33|34|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|(2:53|54)|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(90:0|(2:1|2)|3|(2:5|6)|7|9|10|11|13|14|15|17|18|19|21|22|23|(2:25|26)|27|(2:29|30)|31|33|34|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|53|54|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(91:0|(2:1|2)|3|(2:5|6)|7|9|10|11|13|14|15|17|18|19|21|22|23|(2:25|26)|27|29|30|31|33|34|35|37|38|39|41|42|43|(2:45|46)|47|(2:49|50)|51|53|54|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(93:0|(2:1|2)|3|5|6|7|9|10|11|13|14|15|17|18|19|21|22|23|(2:25|26)|27|29|30|31|33|34|35|37|38|39|41|42|43|(2:45|46)|47|49|50|51|53|54|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(96:0|1|2|3|5|6|7|9|10|11|13|14|15|17|18|19|21|22|23|25|26|27|29|30|31|33|34|35|37|38|39|41|42|43|45|46|47|49|50|51|53|54|55|57|58|59|61|62|63|(2:65|66)|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Can't wrap try/catch for region: R(97:0|1|2|3|5|6|7|9|10|11|13|14|15|17|18|19|21|22|23|25|26|27|29|30|31|33|34|35|37|38|39|41|42|43|45|46|47|49|50|51|53|54|55|57|58|59|61|62|63|65|66|67|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100|101|102|103|104|105|106|107|108|109|110|111|112|114) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:101:0x0175 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:103:0x017f */
        /* JADX WARNING: Missing exception handler attribute for start block: B:105:0x018b */
        /* JADX WARNING: Missing exception handler attribute for start block: B:107:0x0197 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:109:0x01a3 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:111:0x01af */
        /* JADX WARNING: Missing exception handler attribute for start block: B:71:0x00dd */
        /* JADX WARNING: Missing exception handler attribute for start block: B:73:0x00e7 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:75:0x00f1 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:77:0x00fb */
        /* JADX WARNING: Missing exception handler attribute for start block: B:79:0x0105 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:81:0x010f */
        /* JADX WARNING: Missing exception handler attribute for start block: B:83:0x0119 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:85:0x0123 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:87:0x012d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:89:0x0137 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:91:0x0141 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:93:0x014b */
        /* JADX WARNING: Missing exception handler attribute for start block: B:95:0x0155 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:97:0x015f */
        /* JADX WARNING: Missing exception handler attribute for start block: B:99:0x0169 */
        static {
            /*
                com.android.internal.telephony.cat.ResultCode[] r0 = com.android.internal.telephony.cat.ResultCode.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$cat$ResultCode = r0
                r1 = 1
                com.android.internal.telephony.cat.ResultCode r2 = com.android.internal.telephony.cat.ResultCode.HELP_INFO_REQUIRED     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.cat.ResultCode r3 = com.android.internal.telephony.cat.ResultCode.OK     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.cat.ResultCode r4 = com.android.internal.telephony.cat.ResultCode.PRFRMD_WITH_PARTIAL_COMPREHENSION     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                r3 = 4
                int[] r4 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.cat.ResultCode r5 = com.android.internal.telephony.cat.ResultCode.PRFRMD_WITH_MISSING_INFO     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                r4 = 5
                int[] r5 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.cat.ResultCode r6 = com.android.internal.telephony.cat.ResultCode.PRFRMD_WITH_ADDITIONAL_EFS_READ     // Catch:{ NoSuchFieldError -> 0x003e }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r5[r6] = r4     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                r5 = 6
                int[] r6 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.cat.ResultCode r7 = com.android.internal.telephony.cat.ResultCode.PRFRMD_ICON_NOT_DISPLAYED     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r7 = r7.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r6[r7] = r5     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                r6 = 7
                int[] r7 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.cat.ResultCode r8 = com.android.internal.telephony.cat.ResultCode.PRFRMD_MODIFIED_BY_NAA     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r8 = r8.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r7[r8] = r6     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                r7 = 8
                int[] r8 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.cat.ResultCode r9 = com.android.internal.telephony.cat.ResultCode.PRFRMD_LIMITED_SERVICE     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r9 = r9.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r8[r9] = r7     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                r8 = 9
                int[] r9 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.cat.ResultCode r10 = com.android.internal.telephony.cat.ResultCode.PRFRMD_WITH_MODIFICATION     // Catch:{ NoSuchFieldError -> 0x006c }
                int r10 = r10.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r9[r10] = r8     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                r9 = 10
                int[] r10 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.cat.ResultCode r11 = com.android.internal.telephony.cat.ResultCode.PRFRMD_NAA_NOT_ACTIVE     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r11 = r11.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r10[r11] = r9     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                r10 = 11
                int[] r11 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.cat.ResultCode r12 = com.android.internal.telephony.cat.ResultCode.PRFRMD_TONE_NOT_PLAYED     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r12 = r12.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r11[r12] = r10     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                r11 = 12
                int[] r12 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.cat.ResultCode r13 = com.android.internal.telephony.cat.ResultCode.LAUNCH_BROWSER_ERROR     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r13 = r13.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r12[r13] = r11     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                r12 = 13
                int[] r13 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.cat.ResultCode r14 = com.android.internal.telephony.cat.ResultCode.TERMINAL_CRNTLY_UNABLE_TO_PROCESS     // Catch:{ NoSuchFieldError -> 0x009c }
                int r14 = r14.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r13[r14] = r12     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                r13 = 14
                int[] r14 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.cat.ResultCode r15 = com.android.internal.telephony.cat.ResultCode.BACKWARD_MOVE_BY_USER     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r15 = r15.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r14[r15] = r13     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                r14 = 15
                int[] r15 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.cat.ResultCode r16 = com.android.internal.telephony.cat.ResultCode.USER_NOT_ACCEPT     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r16 = r16.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r15[r16] = r14     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                r15 = 16
                int[] r16 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.cat.ResultCode r17 = com.android.internal.telephony.cat.ResultCode.NO_RESPONSE_FROM_USER     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r17 = r17.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r16[r17] = r15     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                r16 = 17
                int[] r17 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.cat.ResultCode r18 = com.android.internal.telephony.cat.ResultCode.UICC_SESSION_TERM_BY_USER     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r18 = r18.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r17[r18] = r16     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                com.android.internal.telephony.cat.AppInterface$CommandType[] r15 = com.android.internal.telephony.cat.AppInterface.CommandType.values()
                int r15 = r15.length
                int[] r15 = new int[r15]
                $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType = r15
                com.android.internal.telephony.cat.AppInterface$CommandType r18 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_MENU     // Catch:{ NoSuchFieldError -> 0x00dd }
                int r18 = r18.ordinal()     // Catch:{ NoSuchFieldError -> 0x00dd }
                r15[r18] = r1     // Catch:{ NoSuchFieldError -> 0x00dd }
            L_0x00dd:
                int[] r1 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00e7 }
                com.android.internal.telephony.cat.AppInterface$CommandType r15 = com.android.internal.telephony.cat.AppInterface.CommandType.DISPLAY_TEXT     // Catch:{ NoSuchFieldError -> 0x00e7 }
                int r15 = r15.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e7 }
                r1[r15] = r0     // Catch:{ NoSuchFieldError -> 0x00e7 }
            L_0x00e7:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00f1 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_IDLE_MODE_TEXT     // Catch:{ NoSuchFieldError -> 0x00f1 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f1 }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f1 }
            L_0x00f1:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00fb }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_EVENT_LIST     // Catch:{ NoSuchFieldError -> 0x00fb }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fb }
                r0[r1] = r3     // Catch:{ NoSuchFieldError -> 0x00fb }
            L_0x00fb:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0105 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PROVIDE_LOCAL_INFORMATION     // Catch:{ NoSuchFieldError -> 0x0105 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0105 }
                r0[r1] = r4     // Catch:{ NoSuchFieldError -> 0x0105 }
            L_0x0105:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x010f }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.LAUNCH_BROWSER     // Catch:{ NoSuchFieldError -> 0x010f }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x010f }
                r0[r1] = r5     // Catch:{ NoSuchFieldError -> 0x010f }
            L_0x010f:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0119 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SELECT_ITEM     // Catch:{ NoSuchFieldError -> 0x0119 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0119 }
                r0[r1] = r6     // Catch:{ NoSuchFieldError -> 0x0119 }
            L_0x0119:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0123 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INPUT     // Catch:{ NoSuchFieldError -> 0x0123 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0123 }
                r0[r1] = r7     // Catch:{ NoSuchFieldError -> 0x0123 }
            L_0x0123:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x012d }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INKEY     // Catch:{ NoSuchFieldError -> 0x012d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x012d }
                r0[r1] = r8     // Catch:{ NoSuchFieldError -> 0x012d }
            L_0x012d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0137 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.REFRESH     // Catch:{ NoSuchFieldError -> 0x0137 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0137 }
                r0[r1] = r9     // Catch:{ NoSuchFieldError -> 0x0137 }
            L_0x0137:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0141 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RUN_AT     // Catch:{ NoSuchFieldError -> 0x0141 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0141 }
                r0[r1] = r10     // Catch:{ NoSuchFieldError -> 0x0141 }
            L_0x0141:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x014b }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DTMF     // Catch:{ NoSuchFieldError -> 0x014b }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x014b }
                r0[r1] = r11     // Catch:{ NoSuchFieldError -> 0x014b }
            L_0x014b:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0155 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SMS     // Catch:{ NoSuchFieldError -> 0x0155 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0155 }
                r0[r1] = r12     // Catch:{ NoSuchFieldError -> 0x0155 }
            L_0x0155:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x015f }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SS     // Catch:{ NoSuchFieldError -> 0x015f }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x015f }
                r0[r1] = r13     // Catch:{ NoSuchFieldError -> 0x015f }
            L_0x015f:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0169 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_USSD     // Catch:{ NoSuchFieldError -> 0x0169 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0169 }
                r0[r1] = r14     // Catch:{ NoSuchFieldError -> 0x0169 }
            L_0x0169:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0175 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PLAY_TONE     // Catch:{ NoSuchFieldError -> 0x0175 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0175 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0175 }
            L_0x0175:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x017f }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_CALL     // Catch:{ NoSuchFieldError -> 0x017f }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x017f }
                r0[r1] = r16     // Catch:{ NoSuchFieldError -> 0x017f }
            L_0x017f:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x018b }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.LANGUAGE_NOTIFICATION     // Catch:{ NoSuchFieldError -> 0x018b }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x018b }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x018b }
            L_0x018b:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0197 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.OPEN_CHANNEL     // Catch:{ NoSuchFieldError -> 0x0197 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0197 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0197 }
            L_0x0197:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x01a3 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.CLOSE_CHANNEL     // Catch:{ NoSuchFieldError -> 0x01a3 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x01a3 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x01a3 }
            L_0x01a3:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x01af }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RECEIVE_DATA     // Catch:{ NoSuchFieldError -> 0x01af }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x01af }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x01af }
            L_0x01af:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x01bb }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DATA     // Catch:{ NoSuchFieldError -> 0x01bb }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x01bb }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x01bb }
            L_0x01bb:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CatService.AnonymousClass1.<clinit>():void");
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private boolean isStkAppInstalled() {
        int i;
        List<ResolveInfo> queryBroadcastReceivers = this.mContext.getPackageManager().queryBroadcastReceivers(new Intent(AppInterface.CAT_CMD_ACTION), 128);
        if (queryBroadcastReceivers == null) {
            i = 0;
        } else {
            i = queryBroadcastReceivers.size();
        }
        if (i > 0) {
            return true;
        }
        return false;
    }

    public void update(CommandsInterface commandsInterface, Context context, UiccProfile uiccProfile) {
        IccRecords iccRecords;
        UiccCardApplication uiccCardApplication;
        if (uiccProfile != null) {
            uiccCardApplication = uiccProfile.getApplicationIndex(0);
            iccRecords = uiccCardApplication != null ? uiccCardApplication.getIccRecords() : null;
        } else {
            uiccCardApplication = null;
            iccRecords = null;
        }
        synchronized (sInstanceLock) {
            if (iccRecords != null) {
                IccRecords iccRecords2 = mIccRecords;
                if (iccRecords2 != iccRecords) {
                    if (iccRecords2 != null) {
                        iccRecords2.unregisterForRecordsLoaded(this);
                    }
                    CatLog.d((Object) this, "Reinitialize the Service with SIMRecords and UiccCardApplication");
                    mIccRecords = iccRecords;
                    mUiccApplication = uiccCardApplication;
                    iccRecords.registerForRecordsLoaded(this, 20, (Object) null);
                    CatLog.d((Object) this, "registerForRecordsLoaded slotid=" + this.mSlotId + " instance:" + this);
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void updateIccAvailability() {
        UiccController uiccController = this.mUiccController;
        if (uiccController != null) {
            IccCardStatus.CardState cardState = IccCardStatus.CardState.CARDSTATE_ABSENT;
            UiccCard uiccCard = uiccController.getUiccCard(this.mSlotId);
            if (uiccCard != null) {
                cardState = uiccCard.getCardState();
            }
            IccCardStatus.CardState cardState2 = this.mCardState;
            this.mCardState = cardState;
            CatLog.d((Object) this, "New Card State = " + cardState + " Old Card State = " + cardState2);
            IccCardStatus.CardState cardState3 = IccCardStatus.CardState.CARDSTATE_PRESENT;
            if (cardState2 == cardState3 && cardState != cardState3) {
                broadcastCardStateAndIccRefreshResp(cardState, (IccRefreshResponse) null);
            } else if (cardState2 != cardState3 && cardState == cardState3) {
                this.mCmdIf.reportStkServiceIsRunning((Message) null);
            }
        }
    }

    private void changeLanguage(String str) throws RemoteException {
        LocaleList localeList = LocaleList.getDefault();
        Locale[] localeArr = new Locale[(localeList.size() + 1)];
        Locale locale = new Locale(str);
        int i = 0;
        localeArr[0] = locale;
        while (i < localeList.size()) {
            int i2 = i + 1;
            localeArr[i2] = localeList.get(i);
            i = i2;
        }
        ((ActivityManager) this.mContext.getSystemService(ActivityManager.class)).setDeviceLocales(new LocaleList(localeArr));
        BackupManager.dataChanged("com.android.providers.settings");
    }
}
