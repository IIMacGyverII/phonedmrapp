package com.android.internal.telephony.uicc;

import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.os.UserHandle;
import android.telephony.SubscriptionManager;
import android.text.TextUtils;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.RadioConfig$$ExternalSyntheticLambda0;
import com.android.internal.telephony.nano.TelephonyProto;
import com.android.internal.telephony.uicc.AnswerToReset;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.euicc.EuiccCard;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class UiccSlot extends Handler {
    private static final boolean DBG = true;
    private static final int EVENT_CARD_ADDED = 14;
    private static final int EVENT_CARD_REMOVED = 13;
    public static final String EXTRA_ICC_CARD_ADDED = "com.android.internal.telephony.uicc.ICC_CARD_ADDED";
    public static final int INVALID_PHONE_ID = -1;
    private static final String TAG = "UiccSlot";
    public static final int VOLTAGE_CLASS_A = 1;
    public static final int VOLTAGE_CLASS_B = 2;
    public static final int VOLTAGE_CLASS_C = 3;
    public static final int VOLTAGE_CLASS_UNKNOWN = 0;
    private boolean mActive;
    private AnswerToReset mAtr;
    protected IccCardStatus.CardState mCardState;
    protected Context mContext;
    private String mEid;
    private HashMap<Integer, String> mIccIds = new HashMap<>();
    private boolean mIsEuicc;
    private boolean mIsRemovable;
    protected HashMap<Integer, Integer> mLastRadioState = new HashMap<>();
    /* access modifiers changed from: private */
    public final Object mLock = new Object();
    private int mMinimumVoltageClass;
    private HashMap<Integer, Integer> mPortIdxToPhoneId = new HashMap<>();
    private boolean mStateIsUnknown = true;
    protected UiccCard mUiccCard;

    @Retention(RetentionPolicy.SOURCE)
    public @interface VoltageClass {
    }

    public UiccSlot(Context context, boolean z) {
        log("Creating");
        this.mContext = context;
        this.mActive = z;
        this.mCardState = null;
    }

    public void update(CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, int i2) {
        log("cardStatus update: " + iccCardStatus.toString());
        synchronized (this.mLock) {
            this.mPortIdxToPhoneId.put(Integer.valueOf(iccCardStatus.mSlotPortMapping.mPortIndex), Integer.valueOf(i));
            IccCardStatus.CardState cardState = this.mCardState;
            this.mCardState = iccCardStatus.mCardState;
            this.mIccIds.put(Integer.valueOf(iccCardStatus.mSlotPortMapping.mPortIndex), iccCardStatus.iccid);
            parseAtr(iccCardStatus.atr);
            this.mIsRemovable = isSlotRemovable(i2);
            int radioState = commandsInterface.getRadioState();
            log("update: radioState=" + radioState + " mLastRadioState=" + this.mLastRadioState);
            if (absentStateUpdateNeeded(cardState)) {
                updateCardStateAbsent(commandsInterface.getRadioState(), i, iccCardStatus.mSlotPortMapping.mPortIndex);
            } else if ((cardState == null || cardState == IccCardStatus.CardState.CARDSTATE_ABSENT || this.mUiccCard == null) && this.mCardState != IccCardStatus.CardState.CARDSTATE_ABSENT) {
                if (!(radioState == 2 || this.mLastRadioState.getOrDefault(Integer.valueOf(iccCardStatus.mSlotPortMapping.mPortIndex), 2).intValue() == 2)) {
                    log("update: notify card added");
                    sendMessage(obtainMessage(14, (Object) null));
                }
                if (this.mUiccCard != null) {
                    loge("update: mUiccCard != null when card was present; disposing it now");
                    this.mUiccCard.dispose();
                }
                if (!this.mIsEuicc) {
                    this.mUiccCard = new UiccCard(this.mContext, commandsInterface, iccCardStatus, i, this.mLock, false);
                } else {
                    if (TextUtils.isEmpty(iccCardStatus.eid)) {
                        loge("update: eid is missing. ics.eid=" + Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, iccCardStatus.eid));
                    }
                    this.mUiccCard = new EuiccCard(this.mContext, commandsInterface, iccCardStatus, i, this.mLock, isMultipleEnabledProfileSupported());
                }
            } else {
                UiccCard uiccCard = this.mUiccCard;
                if (uiccCard != null) {
                    uiccCard.update(this.mContext, commandsInterface, iccCardStatus, i);
                }
            }
            this.mLastRadioState.put(Integer.valueOf(iccCardStatus.mSlotPortMapping.mPortIndex), Integer.valueOf(radioState));
        }
    }

    public void update(CommandsInterface[] commandsInterfaceArr, IccSlotStatus iccSlotStatus, int i) {
        log("slotStatus update: " + iccSlotStatus.toString());
        synchronized (this.mLock) {
            IccSimPortInfo[] iccSimPortInfoArr = iccSlotStatus.mSimPortInfos;
            IccCardStatus.CardState cardState = this.mCardState;
            parseAtr(iccSlotStatus.atr);
            this.mCardState = iccSlotStatus.cardState;
            this.mEid = iccSlotStatus.eid;
            this.mIsRemovable = isSlotRemovable(i);
            for (int i2 = 0; i2 < iccSimPortInfoArr.length; i2++) {
                int i3 = iccSlotStatus.mSimPortInfos[i2].mLogicalSlotIndex;
                this.mIccIds.put(Integer.valueOf(i2), iccSimPortInfoArr[i2].mIccId);
                int i4 = 2;
                if (!iccSlotStatus.mSimPortInfos[i2].mPortActive) {
                    UiccController.updateInternalIccStateForInactivePort(this.mContext, this.mPortIdxToPhoneId.getOrDefault(Integer.valueOf(i2), -1).intValue(), iccSlotStatus.mSimPortInfos[i2].mIccId);
                    this.mLastRadioState.put(Integer.valueOf(i2), 2);
                    UiccCard uiccCard = this.mUiccCard;
                    if (uiccCard != null) {
                        uiccCard.disposePort(i2);
                    }
                } else if (absentStateUpdateNeeded(cardState)) {
                    if (SubscriptionManager.isValidPhoneId(i3)) {
                        i4 = commandsInterfaceArr[i3].getRadioState();
                    }
                    updateCardStateAbsent(i4, i3, i2);
                }
            }
            if (hasActivePort(iccSimPortInfoArr)) {
                this.mActive = true;
            } else if (this.mActive) {
                this.mActive = false;
                nullifyUiccCard(true);
            }
            this.mPortIdxToPhoneId.clear();
            for (int i5 = 0; i5 < iccSimPortInfoArr.length; i5++) {
                HashMap<Integer, Integer> hashMap = this.mPortIdxToPhoneId;
                Integer valueOf = Integer.valueOf(i5);
                IccSimPortInfo iccSimPortInfo = iccSimPortInfoArr[i5];
                hashMap.put(valueOf, Integer.valueOf(iccSimPortInfo.mPortActive ? iccSimPortInfo.mLogicalSlotIndex : -1));
            }
            UiccCard uiccCard2 = this.mUiccCard;
            if (uiccCard2 != null) {
                uiccCard2.updateSupportMultipleEnabledProfile(isMultipleEnabledProfileSupported());
            }
        }
    }

    private boolean hasActivePort(IccSimPortInfo[] iccSimPortInfoArr) {
        for (IccSimPortInfo iccSimPortInfo : iccSimPortInfoArr) {
            if (iccSimPortInfo.mPortActive) {
                return true;
            }
        }
        return false;
    }

    private int getAnyValidPhoneId() {
        for (Integer intValue : this.mPortIdxToPhoneId.values()) {
            int intValue2 = intValue.intValue();
            if (SubscriptionManager.isValidPhoneId(intValue2)) {
                return intValue2;
            }
        }
        return -1;
    }

    public int[] getPortList() {
        int[] array;
        synchronized (this.mLock) {
            array = this.mPortIdxToPhoneId.keySet().stream().mapToInt(new RadioConfig$$ExternalSyntheticLambda0()).toArray();
        }
        return array;
    }

    public boolean isValidPortIndex(int i) {
        return this.mPortIdxToPhoneId.containsKey(Integer.valueOf(i));
    }

    public int getPortIndexFromPhoneId(int i) {
        synchronized (this.mLock) {
            for (Map.Entry next : this.mPortIdxToPhoneId.entrySet()) {
                if (((Integer) next.getValue()).intValue() == i) {
                    int intValue = ((Integer) next.getKey()).intValue();
                    return intValue;
                }
            }
            return 0;
        }
    }

    public int getPortIndexFromIccId(String str) {
        synchronized (this.mLock) {
            for (Map.Entry next : this.mIccIds.entrySet()) {
                if (IccUtils.compareIgnoreTrailingFs((String) next.getValue(), str)) {
                    int intValue = ((Integer) next.getKey()).intValue();
                    return intValue;
                }
            }
            return -1;
        }
    }

    public int getPhoneIdFromPortIndex(int i) {
        int intValue;
        synchronized (this.mLock) {
            intValue = this.mPortIdxToPhoneId.getOrDefault(Integer.valueOf(i), -1).intValue();
        }
        return intValue;
    }

    public boolean isPortActive(int i) {
        boolean isValidPhoneId;
        synchronized (this.mLock) {
            isValidPhoneId = SubscriptionManager.isValidPhoneId(this.mPortIdxToPhoneId.getOrDefault(Integer.valueOf(i), -1).intValue());
        }
        return isValidPhoneId;
    }

    public boolean isMultipleEnabledProfileSupported() {
        AnswerToReset answerToReset;
        if (this.mPortIdxToPhoneId.size() <= 1 || (answerToReset = this.mAtr) == null || !answerToReset.isMultipleEnabledProfilesSupported()) {
            return false;
        }
        return true;
    }

    private boolean absentStateUpdateNeeded(IccCardStatus.CardState cardState) {
        IccCardStatus.CardState cardState2 = IccCardStatus.CardState.CARDSTATE_ABSENT;
        return !(cardState == cardState2 && this.mUiccCard == null) && this.mCardState == cardState2;
    }

    private void updateCardStateAbsent(int i, int i2, int i3) {
        if (!(i == 2 || this.mLastRadioState.getOrDefault(Integer.valueOf(i3), 2).intValue() == 2)) {
            log("update: notify card removed");
            sendMessage(obtainMessage(13, (Object) null));
        }
        UiccController.updateInternalIccState(this.mContext, IccCardConstants.State.ABSENT, (String) null, i2);
        nullifyUiccCard(false);
        this.mLastRadioState.put(Integer.valueOf(i3), 2);
    }

    /* access modifiers changed from: protected */
    public void nullifyUiccCard(boolean z) {
        UiccCard uiccCard = this.mUiccCard;
        if (uiccCard != null) {
            uiccCard.dispose();
        }
        this.mStateIsUnknown = z;
        this.mUiccCard = null;
    }

    public boolean isStateUnknown() {
        IccCardStatus.CardState cardState = this.mCardState;
        if (cardState == null || cardState == IccCardStatus.CardState.CARDSTATE_ABSENT) {
            return this.mStateIsUnknown;
        }
        return this.mUiccCard == null;
    }

    private boolean isSlotRemovable(int i) {
        int[] intArray = this.mContext.getResources().getIntArray(17236184);
        if (intArray == null) {
            return true;
        }
        for (int i2 : intArray) {
            if (i2 == i) {
                return false;
            }
        }
        return true;
    }

    private void checkIsEuiccSupported() {
        AnswerToReset answerToReset = this.mAtr;
        if (answerToReset == null) {
            this.mIsEuicc = false;
            return;
        }
        this.mIsEuicc = answerToReset.isEuiccSupported();
        log(" checkIsEuiccSupported : " + this.mIsEuicc);
    }

    private void checkMinimumVoltageClass() {
        this.mMinimumVoltageClass = 0;
        AnswerToReset answerToReset = this.mAtr;
        if (answerToReset != null) {
            List<AnswerToReset.InterfaceByte> interfaceBytes = answerToReset.getInterfaceBytes();
            for (int i = 0; i < interfaceBytes.size() - 1; i++) {
                if (interfaceBytes.get(i).getTD() != null && (interfaceBytes.get(i).getTD().byteValue() & 15) == 15) {
                    int i2 = i + 1;
                    if (interfaceBytes.get(i2).getTA() != null) {
                        byte byteValue = interfaceBytes.get(i2).getTA().byteValue();
                        if ((byteValue & 1) != 0) {
                            this.mMinimumVoltageClass = 1;
                        }
                        if ((byteValue & 2) != 0) {
                            this.mMinimumVoltageClass = 2;
                        }
                        if ((byteValue & 4) != 0) {
                            this.mMinimumVoltageClass = 3;
                            return;
                        }
                        return;
                    }
                }
            }
            this.mMinimumVoltageClass = 1;
        }
    }

    private void parseAtr(String str) {
        this.mAtr = AnswerToReset.parseAtr(str);
        checkIsEuiccSupported();
        checkMinimumVoltageClass();
    }

    public boolean isEuicc() {
        return this.mIsEuicc;
    }

    public int getMinimumVoltageClass() {
        return this.mMinimumVoltageClass;
    }

    public boolean isActive() {
        return this.mActive;
    }

    public boolean isRemovable() {
        return this.mIsRemovable;
    }

    public String getIccId(int i) {
        return this.mIccIds.get(Integer.valueOf(i));
    }

    public String getEid() {
        return this.mEid;
    }

    public boolean isExtendedApduSupported() {
        AnswerToReset answerToReset = this.mAtr;
        return answerToReset != null && answerToReset.isExtendedApduSupported();
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("UiccSlot finalized");
    }

    private void onIccSwap(boolean z) {
        if (this.mContext.getResources().getBoolean(17891686)) {
            log("onIccSwap: isHotSwapSupported is true, don't prompt for rebooting");
            return;
        }
        Phone phone = PhoneFactory.getPhone(getAnyValidPhoneId());
        if (phone == null || !phone.isShuttingDown()) {
            log("onIccSwap: isHotSwapSupported is false, prompt for rebooting");
            promptForRestart(z);
            return;
        }
        log("onIccSwap: already doing shutdown, no need to prompt");
    }

    private void promptForRestart(boolean z) {
        String str;
        String str2;
        synchronized (this.mLock) {
            ComponentName unflattenFromString = ComponentName.unflattenFromString(this.mContext.getResources().getString(17039987));
            if (unflattenFromString != null) {
                try {
                    this.mContext.startActivityAsUser(new Intent().setComponent(unflattenFromString).addFlags(268435456).putExtra("com.android.internal.telephony.uicc.ICC_CARD_ADDED", z), UserHandle.CURRENT);
                    return;
                } catch (ActivityNotFoundException e) {
                    loge("Unable to find ICC hotswap prompt for restart activity: " + e);
                }
            }
            AnonymousClass1 r1 = new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialogInterface, int i) {
                    synchronized (UiccSlot.this.mLock) {
                        if (i == -1) {
                            UiccSlot.this.log("Reboot due to SIM swap");
                            ((PowerManager) UiccSlot.this.mContext.getSystemService(XmlTagConst.TAG_POWER)).reboot("SIM is added.");
                        }
                    }
                }
            };
            Resources system = Resources.getSystem();
            if (z) {
                str = system.getString(17041557);
            } else {
                str = system.getString(17041560);
            }
            if (z) {
                str2 = system.getString(17041556);
            } else {
                str2 = system.getString(17041559);
            }
            AlertDialog create = new AlertDialog.Builder(this.mContext).setTitle(str).setMessage(str2).setPositiveButton(system.getString(17041561), r1).create();
            create.getWindow().setType(TelephonyProto.TelephonyEvent.RilSetupDataCallResponse.RilDataCallFailCause.PDP_FAIL_MIP_FA_MOBILE_NODE_AUTHENTICATION_FAILURE);
            create.show();
        }
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 13) {
            onIccSwap(false);
        } else if (i != 14) {
            loge("Unknown Event " + message.what);
        } else {
            onIccSwap(true);
        }
    }

    public IccCardStatus.CardState getCardState() {
        synchronized (this.mLock) {
            IccCardStatus.CardState cardState = this.mCardState;
            if (cardState != null) {
                return cardState;
            }
            IccCardStatus.CardState cardState2 = IccCardStatus.CardState.CARDSTATE_ABSENT;
            return cardState2;
        }
    }

    public UiccCard getUiccCard() {
        UiccCard uiccCard;
        synchronized (this.mLock) {
            uiccCard = this.mUiccCard;
        }
        return uiccCard;
    }

    public void onRadioStateUnavailable(int i) {
        nullifyUiccCard(true);
        if (i != -1) {
            UiccController.updateInternalIccState(this.mContext, IccCardConstants.State.UNKNOWN, (String) null, i);
            this.mLastRadioState.put(Integer.valueOf(getPortIndexFromPhoneId(i)), 2);
        }
        this.mCardState = null;
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(TAG, str);
    }

    private void loge(String str) {
        Rlog.e(TAG, str);
    }

    private Map<Integer, String> getPrintableIccIds() {
        return (Map) this.mIccIds.entrySet().stream().collect(Collectors.toMap(new UiccSlot$$ExternalSyntheticLambda0(), new UiccSlot$$ExternalSyntheticLambda1()));
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("UiccSlot:");
        printWriter.println(" mActive=" + this.mActive);
        printWriter.println(" mIsEuicc=" + this.mIsEuicc);
        printWriter.println(" isEuiccSupportsMultipleEnabledProfiles=" + isMultipleEnabledProfileSupported());
        printWriter.println(" mIsRemovable=" + this.mIsRemovable);
        printWriter.println(" mLastRadioState=" + this.mLastRadioState);
        printWriter.println(" mIccIds=" + getPrintableIccIds());
        printWriter.println(" mPortIdxToPhoneId=" + this.mPortIdxToPhoneId);
        printWriter.println(" mEid=" + Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, this.mEid));
        printWriter.println(" mCardState=" + this.mCardState);
        if (this.mUiccCard != null) {
            printWriter.println(" mUiccCard=" + this.mUiccCard);
            this.mUiccCard.dump(fileDescriptor, printWriter, strArr);
        } else {
            printWriter.println(" mUiccCard=null");
        }
        printWriter.println();
        printWriter.flush();
    }
}
