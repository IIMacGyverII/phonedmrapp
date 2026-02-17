package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.cat.AppInterface;
import com.android.internal.telephony.uicc.IccFileHandler;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import kotlin.UByte;

public class CommandParamsFactory extends Handler {
    public static final int DTTZ_SETTING = 3;
    public static final int LANGUAGE_SETTING = 4;
    protected static final int LOAD_MULTI_ICONS = 2;
    protected static final int LOAD_NO_ICON = 0;
    protected static final int LOAD_SINGLE_ICON = 1;
    protected static final int MAX_GSM7_DEFAULT_CHARS = 239;
    protected static final int MAX_UCS2_CHARS = 118;
    protected static final int MSG_ID_LOAD_ICON_DONE = 1;
    static final int NON_SPECIFIC_LANGUAGE = 0;
    static final int SPECIFIC_LANGUAGE = 1;
    protected static CommandParamsFactory sInstance;
    protected RilMessageDecoder mCaller;
    protected CommandParams mCmdParams = null;
    protected int mIconLoadState = 0;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IconLoader mIconLoader;
    protected boolean mNoAlphaUsrCnf = false;
    private String mRequestedLanguage;
    private String mSavedLanguage;
    protected boolean mloadIcon = false;

    static synchronized CommandParamsFactory getInstance(RilMessageDecoder rilMessageDecoder, IccFileHandler iccFileHandler, Context context) {
        synchronized (CommandParamsFactory.class) {
            CommandParamsFactory commandParamsFactory = sInstance;
            if (commandParamsFactory != null) {
                return commandParamsFactory;
            }
            if (iccFileHandler == null) {
                return null;
            }
            CommandParamsFactory makeCommandParamsFactory = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeCommandParamsFactory(rilMessageDecoder, iccFileHandler, context);
            return makeCommandParamsFactory;
        }
    }

    public CommandParamsFactory(RilMessageDecoder rilMessageDecoder, IccFileHandler iccFileHandler, Context context) {
        this.mCaller = rilMessageDecoder;
        this.mIconLoader = IconLoader.getInstance(this, iccFileHandler);
        try {
            this.mNoAlphaUsrCnf = context.getResources().getBoolean(17891771);
        } catch (Resources.NotFoundException unused) {
            this.mNoAlphaUsrCnf = false;
        }
    }

    private CommandDetails processCommandDetails(List<ComprehensionTlv> list) {
        ComprehensionTlv searchForTag;
        if (!(list == null || (searchForTag = searchForTag(ComprehensionTlvTag.COMMAND_DETAILS, list)) == null)) {
            try {
                return ValueParser.retrieveCommandDetails(searchForTag);
            } catch (ResultException e) {
                CatLog.d((Object) this, "processCommandDetails: Failed to procees command details e=" + e);
            }
        }
        return null;
    }

    public void make(BerTlv berTlv) {
        boolean z;
        if (berTlv != null) {
            this.mCmdParams = null;
            this.mIconLoadState = 0;
            if (berTlv.getTag() != 208) {
                sendCmdParams(ResultCode.CMD_TYPE_NOT_UNDERSTOOD);
                return;
            }
            List<ComprehensionTlv> comprehensionTlvs = berTlv.getComprehensionTlvs();
            CommandDetails processCommandDetails = processCommandDetails(comprehensionTlvs);
            if (processCommandDetails == null) {
                sendCmdParams(ResultCode.CMD_TYPE_NOT_UNDERSTOOD);
                return;
            }
            AppInterface.CommandType fromInt = AppInterface.CommandType.fromInt(processCommandDetails.typeOfCommand);
            if (fromInt == null) {
                this.mCmdParams = new CommandParams(processCommandDetails);
                sendCmdParams(ResultCode.BEYOND_TERMINAL_CAPABILITY);
            } else if (!berTlv.isLengthValid()) {
                this.mCmdParams = new CommandParams(processCommandDetails);
                sendCmdParams(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
            } else {
                try {
                    switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[fromInt.ordinal()]) {
                        case 1:
                            z = processSelectItem(processCommandDetails, comprehensionTlvs);
                            break;
                        case 2:
                            z = processSelectItem(processCommandDetails, comprehensionTlvs);
                            break;
                        case 3:
                            z = processDisplayText(processCommandDetails, comprehensionTlvs);
                            break;
                        case 4:
                            z = processSetUpIdleModeText(processCommandDetails, comprehensionTlvs);
                            break;
                        case 5:
                            z = processGetInkey(processCommandDetails, comprehensionTlvs);
                            break;
                        case 6:
                            z = processGetInput(processCommandDetails, comprehensionTlvs);
                            break;
                        case 7:
                        case 8:
                        case 9:
                        case 10:
                        case 11:
                        case 12:
                            z = processEventNotify(processCommandDetails, comprehensionTlvs);
                            break;
                        case 13:
                        case 14:
                            z = processSetupCall(processCommandDetails, comprehensionTlvs);
                            break;
                        case 15:
                            z = processLaunchBrowser(processCommandDetails, comprehensionTlvs);
                            break;
                        case 16:
                            z = processPlayTone(processCommandDetails, comprehensionTlvs);
                            break;
                        case 17:
                            z = processSetUpEventList(processCommandDetails, comprehensionTlvs);
                            break;
                        case 18:
                            z = processProvideLocalInfo(processCommandDetails, comprehensionTlvs);
                            break;
                        case 19:
                            z = processLanguageNotification(processCommandDetails, comprehensionTlvs);
                            break;
                        case 20:
                        case 21:
                        case 22:
                        case 23:
                            z = processBIPClient(processCommandDetails, comprehensionTlvs);
                            break;
                        default:
                            this.mCmdParams = new CommandParams(processCommandDetails);
                            sendCmdParams(ResultCode.BEYOND_TERMINAL_CAPABILITY);
                            return;
                    }
                    if (!z) {
                        sendCmdParams(ResultCode.OK);
                    }
                } catch (ResultException e) {
                    CatLog.d((Object) this, "make: caught ResultException e=" + e);
                    this.mCmdParams = new CommandParams(processCommandDetails);
                    sendCmdParams(e.result());
                }
            }
        }
    }

    /* renamed from: com.android.internal.telephony.cat.CommandParamsFactory$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType;

        /* JADX WARNING: Can't wrap try/catch for region: R(48:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|48) */
        /* JADX WARNING: Code restructure failed: missing block: B:49:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0084 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x0090 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x009c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x00a8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x00b4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x00c0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:35:0x00cc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:37:0x00d8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:39:0x00e4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:41:0x00f0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:43:0x00fc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:45:0x0108 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.cat.AppInterface$CommandType[] r0 = com.android.internal.telephony.cat.AppInterface.CommandType.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType = r0
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_MENU     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SELECT_ITEM     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.DISPLAY_TEXT     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_IDLE_MODE_TEXT     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INKEY     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INPUT     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DTMF     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SMS     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.REFRESH     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RUN_AT     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SS     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r2 = 11
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_USSD     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r2 = 12
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_CHANNEL_STATUS     // Catch:{ NoSuchFieldError -> 0x009c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r2 = 13
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_CALL     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r2 = 14
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.LAUNCH_BROWSER     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r2 = 15
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PLAY_TONE     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_EVENT_LIST     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r2 = 17
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PROVIDE_LOCAL_INFORMATION     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00e4 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.LANGUAGE_NOTIFICATION     // Catch:{ NoSuchFieldError -> 0x00e4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e4 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00e4 }
            L_0x00e4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00f0 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.OPEN_CHANNEL     // Catch:{ NoSuchFieldError -> 0x00f0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f0 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f0 }
            L_0x00f0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00fc }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.CLOSE_CHANNEL     // Catch:{ NoSuchFieldError -> 0x00fc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fc }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00fc }
            L_0x00fc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0108 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RECEIVE_DATA     // Catch:{ NoSuchFieldError -> 0x0108 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0108 }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0108 }
            L_0x0108:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0114 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DATA     // Catch:{ NoSuchFieldError -> 0x0114 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0114 }
                r2 = 23
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0114 }
            L_0x0114:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CommandParamsFactory.AnonymousClass1.<clinit>():void");
        }
    }

    public void handleMessage(Message message) {
        if (message.what == 1 && this.mIconLoader != null) {
            sendCmdParams(setIcons(message.obj));
        }
    }

    /* access modifiers changed from: protected */
    public ResultCode setIcons(Object obj) {
        if (obj == null) {
            CatLog.d((Object) this, "Optional Icon data is NULL");
            this.mCmdParams.mLoadIconFailed = true;
            this.mloadIcon = false;
            return ResultCode.OK;
        }
        int i = this.mIconLoadState;
        if (i == 1) {
            this.mCmdParams.setIcon((Bitmap) obj);
        } else if (i == 2) {
            for (Bitmap bitmap : (Bitmap[]) obj) {
                this.mCmdParams.setIcon(bitmap);
                if (bitmap == null && this.mloadIcon) {
                    CatLog.d((Object) this, "Optional Icon data is NULL while loading multi icons");
                    this.mCmdParams.mLoadIconFailed = true;
                }
            }
        }
        return ResultCode.OK;
    }

    /* access modifiers changed from: protected */
    public void sendCmdParams(ResultCode resultCode) {
        this.mCaller.sendMsgParamsDecoded(resultCode, this.mCmdParams);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ComprehensionTlv searchForTag(ComprehensionTlvTag comprehensionTlvTag, List<ComprehensionTlv> list) {
        return searchForNextTag(comprehensionTlvTag, list.iterator());
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ComprehensionTlv searchForNextTag(ComprehensionTlvTag comprehensionTlvTag, Iterator<ComprehensionTlv> it) {
        int value = comprehensionTlvTag.value();
        while (it.hasNext()) {
            ComprehensionTlv next = it.next();
            if (next.getTag() == value) {
                return next;
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public boolean processDisplayText(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process DisplayText");
        TextMessage textMessage = new TextMessage();
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.TEXT_STRING, list);
        if (searchForTag != null) {
            textMessage.text = ValueParser.retrieveTextString(searchForTag);
        }
        if (textMessage.text != null) {
            if (searchForTag(ComprehensionTlvTag.IMMEDIATE_RESPONSE, list) != null) {
                textMessage.responseNeeded = false;
            }
            ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
            if (searchForTag2 != null) {
                iconId = ValueParser.retrieveIconId(searchForTag2);
                textMessage.iconSelfExplanatory = iconId.selfExplanatory;
            } else {
                iconId = null;
            }
            ComprehensionTlv searchForTag3 = searchForTag(ComprehensionTlvTag.DURATION, list);
            if (searchForTag3 != null) {
                textMessage.duration = ValueParser.retrieveDuration(searchForTag3);
            }
            int i = commandDetails.commandQualifier;
            textMessage.isHighPriority = (i & 1) != 0;
            textMessage.userClear = (i & 128) != 0;
            this.mCmdParams = new DisplayTextParams(commandDetails, textMessage);
            if (iconId == null) {
                return false;
            }
            this.mloadIcon = true;
            this.mIconLoadState = 1;
            this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
            return true;
        }
        throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
    }

    private boolean processSetUpIdleModeText(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process SetUpIdleModeText");
        TextMessage textMessage = new TextMessage();
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.TEXT_STRING, list);
        if (searchForTag != null) {
            textMessage.text = ValueParser.retrieveTextString(searchForTag);
        }
        ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
        if (searchForTag2 != null) {
            iconId = ValueParser.retrieveIconId(searchForTag2);
            textMessage.iconSelfExplanatory = iconId.selfExplanatory;
        } else {
            iconId = null;
        }
        if (textMessage.text != null || iconId == null || textMessage.iconSelfExplanatory) {
            this.mCmdParams = new DisplayTextParams(commandDetails, textMessage);
            if (iconId == null) {
                return false;
            }
            this.mloadIcon = true;
            this.mIconLoadState = 1;
            this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
            return true;
        }
        throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
    }

    /* access modifiers changed from: protected */
    public boolean processGetInkey(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process GetInkey");
        Input input = new Input();
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.TEXT_STRING, list);
        if (searchForTag != null) {
            input.text = ValueParser.retrieveTextString(searchForTag);
            ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
            if (searchForTag2 != null) {
                iconId = ValueParser.retrieveIconId(searchForTag2);
                input.iconSelfExplanatory = iconId.selfExplanatory;
            } else {
                iconId = null;
            }
            ComprehensionTlv searchForTag3 = searchForTag(ComprehensionTlvTag.DURATION, list);
            if (searchForTag3 != null) {
                input.duration = ValueParser.retrieveDuration(searchForTag3);
            }
            input.minLen = 1;
            input.maxLen = 1;
            int i = commandDetails.commandQualifier;
            input.digitOnly = (i & 1) == 0;
            input.ucs2 = (i & 2) != 0;
            input.yesNo = (i & 4) != 0;
            input.helpAvailable = (i & 128) != 0;
            input.echo = true;
            this.mCmdParams = new GetInputParams(commandDetails, input);
            if (iconId == null) {
                return false;
            }
            this.mloadIcon = true;
            this.mIconLoadState = 1;
            this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
            return true;
        }
        throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
    }

    /* access modifiers changed from: protected */
    public boolean processGetInput(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process GetInput");
        Input input = new Input();
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.TEXT_STRING, list);
        if (searchForTag != null) {
            input.text = ValueParser.retrieveTextString(searchForTag);
            ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.RESPONSE_LENGTH, list);
            if (searchForTag2 != null) {
                try {
                    byte[] rawValue = searchForTag2.getRawValue();
                    int valueIndex = searchForTag2.getValueIndex();
                    input.minLen = rawValue[valueIndex] & UByte.MAX_VALUE;
                    input.maxLen = rawValue[valueIndex + 1] & UByte.MAX_VALUE;
                    ComprehensionTlv searchForTag3 = searchForTag(ComprehensionTlvTag.DEFAULT_TEXT, list);
                    if (searchForTag3 != null) {
                        input.defaultText = ValueParser.retrieveTextString(searchForTag3);
                    }
                    ComprehensionTlv searchForTag4 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
                    if (searchForTag4 != null) {
                        iconId = ValueParser.retrieveIconId(searchForTag4);
                        input.iconSelfExplanatory = iconId.selfExplanatory;
                    } else {
                        iconId = null;
                    }
                    ComprehensionTlv searchForTag5 = searchForTag(ComprehensionTlvTag.DURATION, list);
                    if (searchForTag5 != null) {
                        input.duration = ValueParser.retrieveDuration(searchForTag5);
                    }
                    int i = commandDetails.commandQualifier;
                    input.digitOnly = (i & 1) == 0;
                    boolean z = (i & 2) != 0;
                    input.ucs2 = z;
                    input.echo = (i & 4) == 0;
                    boolean z2 = (i & 8) != 0;
                    input.packed = z2;
                    input.helpAvailable = (i & 128) != 0;
                    if (z && input.maxLen > 118) {
                        CatLog.d((Object) this, "UCS2: received maxLen = " + input.maxLen + ", truncating to " + 118);
                        input.maxLen = 118;
                    } else if (!z2 && input.maxLen > MAX_GSM7_DEFAULT_CHARS) {
                        CatLog.d((Object) this, "GSM 7Bit Default: received maxLen = " + input.maxLen + ", truncating to " + MAX_GSM7_DEFAULT_CHARS);
                        input.maxLen = MAX_GSM7_DEFAULT_CHARS;
                    }
                    this.mCmdParams = new GetInputParams(commandDetails, input);
                    if (iconId == null) {
                        return false;
                    }
                    this.mloadIcon = true;
                    this.mIconLoadState = 1;
                    this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
                    return true;
                } catch (IndexOutOfBoundsException unused) {
                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
                }
            } else {
                throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
            }
        } else {
            throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
        }
    }

    /* access modifiers changed from: protected */
    public boolean processSelectItem(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process SelectItem");
        Menu menu = new Menu();
        Iterator<ComprehensionTlv> it = list.iterator();
        AppInterface.CommandType fromInt = AppInterface.CommandType.fromInt(commandDetails.typeOfCommand);
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.ALPHA_ID, list);
        if (searchForTag != null) {
            menu.title = ValueParser.retrieveAlphaId(searchForTag, this.mNoAlphaUsrCnf);
        } else if (fromInt == AppInterface.CommandType.SET_UP_MENU) {
            throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
        }
        while (true) {
            ComprehensionTlv searchForNextTag = searchForNextTag(ComprehensionTlvTag.ITEM, it);
            if (searchForNextTag == null) {
                break;
            }
            menu.items.add(ValueParser.retrieveItem(searchForNextTag));
        }
        if (menu.items.size() != 0) {
            ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ITEM_ID, list);
            if (searchForTag2 != null) {
                menu.defaultItem = ValueParser.retrieveItemId(searchForTag2) - 1;
            }
            ComprehensionTlv searchForTag3 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
            ItemsIconId itemsIconId = null;
            if (searchForTag3 != null) {
                this.mIconLoadState = 1;
                iconId = ValueParser.retrieveIconId(searchForTag3);
                menu.titleIconSelfExplanatory = iconId.selfExplanatory;
            } else {
                iconId = null;
            }
            ComprehensionTlv searchForTag4 = searchForTag(ComprehensionTlvTag.ITEM_ICON_ID_LIST, list);
            if (searchForTag4 != null) {
                this.mIconLoadState = 2;
                itemsIconId = ValueParser.retrieveItemsIconId(searchForTag4);
                menu.itemsIconSelfExplanatory = itemsIconId.selfExplanatory;
            }
            int i = commandDetails.commandQualifier;
            if ((i & 1) != 0) {
                if ((i & 2) == 0) {
                    menu.presentationType = PresentationType.DATA_VALUES;
                } else {
                    menu.presentationType = PresentationType.NAVIGATION_OPTIONS;
                }
            }
            menu.softKeyPreferred = (i & 4) != 0;
            menu.helpAvailable = (i & 128) != 0;
            this.mCmdParams = new SelectItemParams(commandDetails, menu, iconId != null);
            int i2 = this.mIconLoadState;
            if (i2 == 0) {
                return false;
            }
            if (i2 == 1) {
                this.mloadIcon = true;
                this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
            } else if (i2 == 2) {
                int[] iArr = itemsIconId.recordNumbers;
                if (iconId != null) {
                    int[] iArr2 = new int[(iArr.length + 1)];
                    iArr2[0] = iconId.recordNumber;
                    System.arraycopy(iArr, 0, iArr2, 1, iArr.length);
                    iArr = iArr2;
                }
                this.mloadIcon = true;
                this.mIconLoader.loadIcons(iArr, obtainMessage(1));
            }
            return true;
        }
        throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
    }

    /* access modifiers changed from: protected */
    public boolean processEventNotify(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process EventNotify");
        TextMessage textMessage = new TextMessage();
        textMessage.text = ValueParser.retrieveAlphaId(searchForTag(ComprehensionTlvTag.ALPHA_ID, list), this.mNoAlphaUsrCnf);
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.ICON_ID, list);
        if (searchForTag != null) {
            iconId = ValueParser.retrieveIconId(searchForTag);
            textMessage.iconSelfExplanatory = iconId.selfExplanatory;
        } else {
            iconId = null;
        }
        textMessage.responseNeeded = false;
        this.mCmdParams = new DisplayTextParams(commandDetails, textMessage);
        if (iconId == null) {
            return false;
        }
        this.mloadIcon = true;
        this.mIconLoadState = 1;
        this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean processSetUpEventList(CommandDetails commandDetails, List<ComprehensionTlv> list) {
        CatLog.d((Object) this, "process SetUpEventList");
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.EVENT_LIST, list);
        if (searchForTag != null) {
            try {
                byte[] rawValue = searchForTag.getRawValue();
                int valueIndex = searchForTag.getValueIndex();
                int length = searchForTag.getLength();
                int[] iArr = new int[length];
                int i = 0;
                while (length > 0) {
                    int i2 = rawValue[valueIndex] & UByte.MAX_VALUE;
                    valueIndex++;
                    length--;
                    if (i2 == 4 || i2 == 5 || i2 == 7 || i2 == 8 || i2 == 15) {
                        iArr[i] = i2;
                        i++;
                    }
                }
                this.mCmdParams = new SetEventListParams(commandDetails, iArr);
            } catch (IndexOutOfBoundsException unused) {
                CatLog.e((Object) this, " IndexOutofBoundException in processSetUpEventList");
            }
        }
        return false;
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Removed duplicated region for block: B:12:0x0045  */
    /* JADX WARNING: Removed duplicated region for block: B:15:0x0052  */
    /* JADX WARNING: Removed duplicated region for block: B:19:0x005b  */
    /* JADX WARNING: Removed duplicated region for block: B:22:0x0066  */
    /* JADX WARNING: Removed duplicated region for block: B:24:0x0075 A[RETURN] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean processLaunchBrowser(com.android.internal.telephony.cat.CommandDetails r6, java.util.List<com.android.internal.telephony.cat.ComprehensionTlv> r7) throws com.android.internal.telephony.cat.ResultException {
        /*
            r5 = this;
            java.lang.String r0 = "process LaunchBrowser"
            com.android.internal.telephony.cat.CatLog.d((java.lang.Object) r5, (java.lang.String) r0)
            com.android.internal.telephony.cat.TextMessage r0 = new com.android.internal.telephony.cat.TextMessage
            r0.<init>()
            com.android.internal.telephony.cat.ComprehensionTlvTag r1 = com.android.internal.telephony.cat.ComprehensionTlvTag.URL
            com.android.internal.telephony.cat.ComprehensionTlv r1 = r5.searchForTag(r1, r7)
            r2 = 0
            if (r1 == 0) goto L_0x002e
            byte[] r3 = r1.getRawValue()     // Catch:{ IndexOutOfBoundsException -> 0x0026 }
            int r4 = r1.getValueIndex()     // Catch:{ IndexOutOfBoundsException -> 0x0026 }
            int r1 = r1.getLength()     // Catch:{ IndexOutOfBoundsException -> 0x0026 }
            if (r1 <= 0) goto L_0x002e
            java.lang.String r1 = com.android.internal.telephony.GsmAlphabet.gsm8BitUnpackedToString(r3, r4, r1)     // Catch:{ IndexOutOfBoundsException -> 0x0026 }
            goto L_0x002f
        L_0x0026:
            com.android.internal.telephony.cat.ResultException r5 = new com.android.internal.telephony.cat.ResultException
            com.android.internal.telephony.cat.ResultCode r6 = com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD
            r5.<init>(r6)
            throw r5
        L_0x002e:
            r1 = r2
        L_0x002f:
            com.android.internal.telephony.cat.ComprehensionTlvTag r3 = com.android.internal.telephony.cat.ComprehensionTlvTag.ALPHA_ID
            com.android.internal.telephony.cat.ComprehensionTlv r3 = r5.searchForTag(r3, r7)
            boolean r4 = r5.mNoAlphaUsrCnf
            java.lang.String r3 = com.android.internal.telephony.cat.ValueParser.retrieveAlphaId(r3, r4)
            r0.text = r3
            com.android.internal.telephony.cat.ComprehensionTlvTag r3 = com.android.internal.telephony.cat.ComprehensionTlvTag.ICON_ID
            com.android.internal.telephony.cat.ComprehensionTlv r7 = r5.searchForTag(r3, r7)
            if (r7 == 0) goto L_0x004d
            com.android.internal.telephony.cat.IconId r2 = com.android.internal.telephony.cat.ValueParser.retrieveIconId(r7)
            boolean r7 = r2.selfExplanatory
            r0.iconSelfExplanatory = r7
        L_0x004d:
            int r7 = r6.commandQualifier
            r3 = 2
            if (r7 == r3) goto L_0x005b
            r3 = 3
            if (r7 == r3) goto L_0x0058
            com.android.internal.telephony.cat.LaunchBrowserMode r7 = com.android.internal.telephony.cat.LaunchBrowserMode.LAUNCH_IF_NOT_ALREADY_LAUNCHED
            goto L_0x005d
        L_0x0058:
            com.android.internal.telephony.cat.LaunchBrowserMode r7 = com.android.internal.telephony.cat.LaunchBrowserMode.LAUNCH_NEW_BROWSER
            goto L_0x005d
        L_0x005b:
            com.android.internal.telephony.cat.LaunchBrowserMode r7 = com.android.internal.telephony.cat.LaunchBrowserMode.USE_EXISTING_BROWSER
        L_0x005d:
            com.android.internal.telephony.cat.LaunchBrowserParams r3 = new com.android.internal.telephony.cat.LaunchBrowserParams
            r3.<init>(r6, r0, r1, r7)
            r5.mCmdParams = r3
            if (r2 == 0) goto L_0x0075
            r6 = 1
            r5.mIconLoadState = r6
            com.android.internal.telephony.cat.IconLoader r7 = r5.mIconLoader
            int r0 = r2.recordNumber
            android.os.Message r5 = r5.obtainMessage(r6)
            r7.loadIcon(r0, r5)
            return r6
        L_0x0075:
            r5 = 0
            return r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CommandParamsFactory.processLaunchBrowser(com.android.internal.telephony.cat.CommandDetails, java.util.List):boolean");
    }

    /* access modifiers changed from: protected */
    public boolean processPlayTone(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        Tone tone;
        CatLog.d((Object) this, "process PlayTone");
        TextMessage textMessage = new TextMessage();
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.TONE, list);
        IconId iconId = null;
        if (searchForTag == null || searchForTag.getLength() <= 0) {
            tone = null;
        } else {
            try {
                tone = Tone.fromInt(searchForTag.getRawValue()[searchForTag.getValueIndex()]);
            } catch (IndexOutOfBoundsException unused) {
                throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
            }
        }
        ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ALPHA_ID, list);
        if (searchForTag2 != null) {
            String retrieveAlphaId = ValueParser.retrieveAlphaId(searchForTag2, this.mNoAlphaUsrCnf);
            textMessage.text = retrieveAlphaId;
            if (retrieveAlphaId == null) {
                textMessage.text = "";
            }
        }
        ComprehensionTlv searchForTag3 = searchForTag(ComprehensionTlvTag.DURATION, list);
        Duration retrieveDuration = searchForTag3 != null ? ValueParser.retrieveDuration(searchForTag3) : null;
        ComprehensionTlv searchForTag4 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
        if (searchForTag4 != null) {
            iconId = ValueParser.retrieveIconId(searchForTag4);
            textMessage.iconSelfExplanatory = iconId.selfExplanatory;
        }
        IconId iconId2 = iconId;
        boolean z = (commandDetails.commandQualifier & 1) != 0;
        textMessage.responseNeeded = false;
        this.mCmdParams = new PlayToneParams(commandDetails, textMessage, tone, retrieveDuration, z);
        if (iconId2 == null) {
            return false;
        }
        this.mIconLoadState = 1;
        this.mIconLoader.loadIcon(iconId2.recordNumber, obtainMessage(1));
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean processSetupCall(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        IconId iconId;
        CatLog.d((Object) this, "process SetupCall");
        Iterator<ComprehensionTlv> it = list.iterator();
        TextMessage textMessage = new TextMessage();
        TextMessage textMessage2 = new TextMessage();
        ComprehensionTlvTag comprehensionTlvTag = ComprehensionTlvTag.ALPHA_ID;
        textMessage.text = ValueParser.retrieveAlphaId(searchForNextTag(comprehensionTlvTag, it), this.mNoAlphaUsrCnf);
        ComprehensionTlvTag comprehensionTlvTag2 = ComprehensionTlvTag.ICON_ID;
        ComprehensionTlv searchForTag = searchForTag(comprehensionTlvTag2, list);
        IconId iconId2 = null;
        if (searchForTag != null) {
            iconId = ValueParser.retrieveIconId(searchForTag);
            textMessage.iconSelfExplanatory = iconId.selfExplanatory;
        } else {
            iconId = null;
        }
        ComprehensionTlv searchForNextTag = searchForNextTag(comprehensionTlvTag, it);
        if (searchForNextTag != null) {
            textMessage2.text = ValueParser.retrieveAlphaId(searchForNextTag, this.mNoAlphaUsrCnf);
        }
        ComprehensionTlv searchForTag2 = searchForTag(comprehensionTlvTag2, list);
        if (searchForTag2 != null) {
            iconId2 = ValueParser.retrieveIconId(searchForTag2);
            textMessage2.iconSelfExplanatory = iconId2.selfExplanatory;
        }
        this.mCmdParams = new CallSetupParams(commandDetails, textMessage, textMessage2);
        if (iconId == null && iconId2 == null) {
            return false;
        }
        this.mIconLoadState = 2;
        int[] iArr = new int[2];
        int i = -1;
        iArr[0] = iconId != null ? iconId.recordNumber : -1;
        if (iconId2 != null) {
            i = iconId2.recordNumber;
        }
        iArr[1] = i;
        this.mIconLoader.loadIcons(iArr, obtainMessage(1));
        return true;
    }

    /* access modifiers changed from: protected */
    public boolean processProvideLocalInfo(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        CatLog.d((Object) this, "process ProvideLocalInfo");
        int i = commandDetails.commandQualifier;
        if (i == 3) {
            CatLog.d((Object) this, "PLI [DTTZ_SETTING]");
            this.mCmdParams = new CommandParams(commandDetails);
            return false;
        } else if (i == 4) {
            CatLog.d((Object) this, "PLI [LANGUAGE_SETTING]");
            this.mCmdParams = new CommandParams(commandDetails);
            return false;
        } else {
            CatLog.d((Object) this, "PLI[" + commandDetails.commandQualifier + "] Command Not Supported");
            this.mCmdParams = new CommandParams(commandDetails);
            throw new ResultException(ResultCode.BEYOND_TERMINAL_CAPABILITY);
        }
    }

    /* access modifiers changed from: protected */
    public boolean processLanguageNotification(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        String str;
        CatLog.d((Object) this, "process Language Notification");
        String language = Locale.getDefault().getLanguage();
        int i = commandDetails.commandQualifier;
        String str2 = null;
        if (i == 0) {
            if (TextUtils.isEmpty(this.mSavedLanguage) || TextUtils.isEmpty(this.mRequestedLanguage) || !this.mRequestedLanguage.equals(language)) {
                str = null;
            } else {
                CatLog.d((Object) this, "Non-specific language notification changes the language setting back to " + this.mSavedLanguage);
                str = this.mSavedLanguage;
            }
            this.mSavedLanguage = null;
            this.mRequestedLanguage = null;
            str2 = str;
        } else if (i != 1) {
            CatLog.d((Object) this, "LN[" + commandDetails.commandQualifier + "] Command Not Supported");
        } else {
            ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.LANGUAGE, list);
            if (searchForTag != null) {
                if (searchForTag.getLength() == 2) {
                    str2 = GsmAlphabet.gsm8BitUnpackedToString(searchForTag.getRawValue(), searchForTag.getValueIndex(), 2);
                    if (TextUtils.isEmpty(this.mSavedLanguage) || (!TextUtils.isEmpty(this.mRequestedLanguage) && !this.mRequestedLanguage.equals(language))) {
                        this.mSavedLanguage = language;
                    }
                    this.mRequestedLanguage = str2;
                    CatLog.d((Object) this, "Specific language notification changes the language setting to " + this.mRequestedLanguage);
                } else {
                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
                }
            }
        }
        this.mCmdParams = new LanguageParams(commandDetails, str2);
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean processBIPClient(CommandDetails commandDetails, List<ComprehensionTlv> list) throws ResultException {
        boolean z;
        AppInterface.CommandType fromInt = AppInterface.CommandType.fromInt(commandDetails.typeOfCommand);
        if (fromInt != null) {
            CatLog.d((Object) this, "process " + fromInt.name());
        }
        TextMessage textMessage = new TextMessage();
        IconId iconId = null;
        ComprehensionTlv searchForTag = searchForTag(ComprehensionTlvTag.ALPHA_ID, list);
        if (searchForTag != null) {
            textMessage.text = ValueParser.retrieveAlphaId(searchForTag, this.mNoAlphaUsrCnf);
            CatLog.d((Object) this, "alpha TLV text=" + textMessage.text);
            z = true;
        } else {
            z = false;
        }
        ComprehensionTlv searchForTag2 = searchForTag(ComprehensionTlvTag.ICON_ID, list);
        if (searchForTag2 != null) {
            iconId = ValueParser.retrieveIconId(searchForTag2);
            textMessage.iconSelfExplanatory = iconId.selfExplanatory;
        }
        textMessage.responseNeeded = false;
        this.mCmdParams = new BIPClientParams(commandDetails, textMessage, z);
        if (iconId == null) {
            return false;
        }
        this.mIconLoadState = 1;
        this.mIconLoader.loadIcon(iconId.recordNumber, obtainMessage(1));
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dispose() {
        this.mIconLoader.dispose();
        this.mIconLoader = null;
        this.mCmdParams = null;
        this.mCaller = null;
        sInstance = null;
    }
}
