package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.Parcel;
import android.os.Parcelable;
import com.android.internal.telephony.cat.AppInterface;

public class CatCmdMessage implements Parcelable {
    public static final Parcelable.Creator<CatCmdMessage> CREATOR = new Parcelable.Creator<CatCmdMessage>() {
        public CatCmdMessage createFromParcel(Parcel parcel) {
            return new CatCmdMessage(parcel);
        }

        public CatCmdMessage[] newArray(int i) {
            return new CatCmdMessage[i];
        }
    };
    public BrowserSettings mBrowserSettings;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CallSettings mCallSettings;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CommandDetails mCmdDet;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Input mInput;
    public boolean mLoadIconFailed;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Menu mMenu;
    public SetupEventListSettings mSetupEventListSettings;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public TextMessage mTextMsg;
    public ToneSettings mToneSettings;

    public int describeContents() {
        return 0;
    }

    public class BrowserSettings {
        public LaunchBrowserMode mode;
        public String url;

        public BrowserSettings() {
        }
    }

    public class CallSettings {
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public TextMessage callMsg;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public TextMessage confirmMsg;

        public CallSettings() {
        }
    }

    public class SetupEventListSettings {
        @UnsupportedAppUsage
        public int[] eventList;

        public SetupEventListSettings() {
        }
    }

    public final class SetupEventListConstants {
        public static final int BROWSER_TERMINATION_EVENT = 8;
        public static final int BROWSING_STATUS_EVENT = 15;
        public static final int IDLE_SCREEN_AVAILABLE_EVENT = 5;
        public static final int LANGUAGE_SELECTION_EVENT = 7;
        public static final int USER_ACTIVITY_EVENT = 4;

        public SetupEventListConstants() {
        }
    }

    public final class BrowserTerminationCauses {
        public static final int ERROR_TERMINATION = 1;
        public static final int USER_TERMINATION = 0;

        public BrowserTerminationCauses() {
        }
    }

    public CatCmdMessage(CommandParams commandParams) {
        this.mBrowserSettings = null;
        this.mToneSettings = null;
        this.mCallSettings = null;
        this.mSetupEventListSettings = null;
        this.mLoadIconFailed = false;
        this.mCmdDet = commandParams.mCmdDet;
        this.mLoadIconFailed = commandParams.mLoadIconFailed;
        switch (AnonymousClass2.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[getCmdType().ordinal()]) {
            case 1:
            case 2:
                this.mMenu = ((SelectItemParams) commandParams).mMenu;
                return;
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                this.mTextMsg = ((DisplayTextParams) commandParams).mTextMsg;
                return;
            case 11:
            case 12:
                this.mInput = ((GetInputParams) commandParams).mInput;
                return;
            case 13:
                LaunchBrowserParams launchBrowserParams = (LaunchBrowserParams) commandParams;
                this.mTextMsg = launchBrowserParams.mConfirmMsg;
                BrowserSettings browserSettings = new BrowserSettings();
                this.mBrowserSettings = browserSettings;
                browserSettings.url = launchBrowserParams.mUrl;
                browserSettings.mode = launchBrowserParams.mMode;
                return;
            case 14:
                PlayToneParams playToneParams = (PlayToneParams) commandParams;
                this.mToneSettings = playToneParams.mSettings;
                this.mTextMsg = playToneParams.mTextMsg;
                return;
            case 15:
                this.mTextMsg = ((CallSetupParams) commandParams).mConfirmMsg;
                return;
            case 16:
                CallSettings callSettings = new CallSettings();
                this.mCallSettings = callSettings;
                CallSetupParams callSetupParams = (CallSetupParams) commandParams;
                callSettings.confirmMsg = callSetupParams.mConfirmMsg;
                callSettings.callMsg = callSetupParams.mCallMsg;
                return;
            case 17:
            case 18:
            case 19:
            case 20:
                this.mTextMsg = ((BIPClientParams) commandParams).mTextMsg;
                return;
            case 21:
                SetupEventListSettings setupEventListSettings = new SetupEventListSettings();
                this.mSetupEventListSettings = setupEventListSettings;
                setupEventListSettings.eventList = ((SetEventListParams) commandParams).mEventInfo;
                return;
            default:
                return;
        }
    }

    /* renamed from: com.android.internal.telephony.cat.CatCmdMessage$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType;

        /* JADX WARNING: Can't wrap try/catch for region: R(44:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|(3:43|44|46)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(46:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|46) */
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
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DTMF     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SMS     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.REFRESH     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RUN_AT     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_SS     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_USSD     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INPUT     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r2 = 11
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_INKEY     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r2 = 12
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.LAUNCH_BROWSER     // Catch:{ NoSuchFieldError -> 0x009c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r2 = 13
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PLAY_TONE     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r2 = 14
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.GET_CHANNEL_STATUS     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r2 = 15
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_CALL     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.OPEN_CHANNEL     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r2 = 17
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.CLOSE_CHANNEL     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00e4 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.RECEIVE_DATA     // Catch:{ NoSuchFieldError -> 0x00e4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e4 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00e4 }
            L_0x00e4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00f0 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SEND_DATA     // Catch:{ NoSuchFieldError -> 0x00f0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f0 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f0 }
            L_0x00f0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x00fc }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.SET_UP_EVENT_LIST     // Catch:{ NoSuchFieldError -> 0x00fc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fc }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00fc }
            L_0x00fc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType     // Catch:{ NoSuchFieldError -> 0x0108 }
                com.android.internal.telephony.cat.AppInterface$CommandType r1 = com.android.internal.telephony.cat.AppInterface.CommandType.PROVIDE_LOCAL_INFORMATION     // Catch:{ NoSuchFieldError -> 0x0108 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0108 }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0108 }
            L_0x0108:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.CatCmdMessage.AnonymousClass2.<clinit>():void");
        }
    }

    public CatCmdMessage(Parcel parcel) {
        this.mBrowserSettings = null;
        this.mToneSettings = null;
        this.mCallSettings = null;
        this.mSetupEventListSettings = null;
        this.mLoadIconFailed = false;
        this.mCmdDet = (CommandDetails) parcel.readParcelable(CommandDetails.class.getClassLoader());
        this.mTextMsg = (TextMessage) parcel.readParcelable(TextMessage.class.getClassLoader());
        this.mMenu = (Menu) parcel.readParcelable(Menu.class.getClassLoader());
        this.mInput = (Input) parcel.readParcelable(Input.class.getClassLoader());
        this.mLoadIconFailed = parcel.readByte() != 1 ? false : true;
        int i = AnonymousClass2.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[getCmdType().ordinal()];
        if (i == 13) {
            BrowserSettings browserSettings = new BrowserSettings();
            this.mBrowserSettings = browserSettings;
            browserSettings.url = parcel.readString();
            this.mBrowserSettings.mode = LaunchBrowserMode.values()[parcel.readInt()];
        } else if (i == 14) {
            this.mToneSettings = (ToneSettings) parcel.readParcelable(ToneSettings.class.getClassLoader());
        } else if (i == 16) {
            CallSettings callSettings = new CallSettings();
            this.mCallSettings = callSettings;
            callSettings.confirmMsg = (TextMessage) parcel.readParcelable(TextMessage.class.getClassLoader());
            this.mCallSettings.callMsg = (TextMessage) parcel.readParcelable(TextMessage.class.getClassLoader());
        } else if (i == 21) {
            this.mSetupEventListSettings = new SetupEventListSettings();
            int readInt = parcel.readInt();
            this.mSetupEventListSettings.eventList = new int[readInt];
            for (int i2 = 0; i2 < readInt; i2++) {
                this.mSetupEventListSettings.eventList[i2] = parcel.readInt();
            }
        }
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeParcelable(this.mCmdDet, 0);
        parcel.writeParcelable(this.mTextMsg, 0);
        parcel.writeParcelable(this.mMenu, 0);
        parcel.writeParcelable(this.mInput, 0);
        parcel.writeByte(this.mLoadIconFailed ? (byte) 1 : 0);
        int i2 = AnonymousClass2.$SwitchMap$com$android$internal$telephony$cat$AppInterface$CommandType[getCmdType().ordinal()];
        if (i2 == 13) {
            parcel.writeString(this.mBrowserSettings.url);
            parcel.writeInt(this.mBrowserSettings.mode.ordinal());
        } else if (i2 == 14) {
            parcel.writeParcelable(this.mToneSettings, 0);
        } else if (i2 == 16) {
            parcel.writeParcelable(this.mCallSettings.confirmMsg, 0);
            parcel.writeParcelable(this.mCallSettings.callMsg, 0);
        } else if (i2 == 21) {
            parcel.writeIntArray(this.mSetupEventListSettings.eventList);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AppInterface.CommandType getCmdType() {
        return AppInterface.CommandType.fromInt(this.mCmdDet.typeOfCommand);
    }

    public Menu getMenu() {
        return this.mMenu;
    }

    public Input geInput() {
        return this.mInput;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public TextMessage geTextMessage() {
        return this.mTextMsg;
    }

    public BrowserSettings getBrowserSettings() {
        return this.mBrowserSettings;
    }

    public ToneSettings getToneSettings() {
        return this.mToneSettings;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CallSettings getCallSettings() {
        return this.mCallSettings;
    }

    @UnsupportedAppUsage
    public SetupEventListSettings getSetEventList() {
        return this.mSetupEventListSettings;
    }

    @UnsupportedAppUsage
    public boolean hasIconLoadFailed() {
        return this.mLoadIconFailed;
    }
}
