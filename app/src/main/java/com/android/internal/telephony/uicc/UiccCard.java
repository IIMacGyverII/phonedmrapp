package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.text.TextUtils;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.HashMap;

public class UiccCard {
    protected static final boolean DBG = true;
    public static final String EXTRA_ICC_CARD_ADDED = "com.android.internal.telephony.uicc.ICC_CARD_ADDED";
    protected static final String LOG_TAG = "UiccCard";
    /* access modifiers changed from: protected */
    public String mCardId;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private IccCardStatus.CardState mCardState;
    protected boolean mIsSupportsMultipleEnabledProfiles;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final Object mLock;
    private HashMap<Integer, Integer> mPhoneIdToPortIdx = new HashMap<>();
    protected HashMap<Integer, UiccPort> mUiccPorts = new HashMap<>();

    public UiccCard(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, Object obj, boolean z) {
        log("Creating");
        this.mCardState = iccCardStatus.mCardState;
        this.mLock = obj;
        this.mIsSupportsMultipleEnabledProfiles = z;
        update(context, commandsInterface, iccCardStatus, i);
    }

    public void dispose() {
        synchronized (this.mLock) {
            log("Disposing card");
            for (UiccPort next : this.mUiccPorts.values()) {
                if (next != null) {
                    next.dispose();
                }
            }
            this.mUiccPorts.clear();
            this.mUiccPorts = null;
            this.mPhoneIdToPortIdx.clear();
            this.mPhoneIdToPortIdx = null;
        }
    }

    public void disposePort(int i) {
        synchronized (this.mLock) {
            log("Disposing port for index " + i);
            UiccPort uiccPort = getUiccPort(i);
            if (uiccPort != null) {
                this.mPhoneIdToPortIdx.remove(Integer.valueOf(uiccPort.getPhoneId()));
                uiccPort.dispose();
            }
            this.mUiccPorts.remove(Integer.valueOf(i));
        }
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v5, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v6, resolved type: com.android.internal.telephony.uicc.UiccPort} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v7, resolved type: com.android.internal.telephony.uicc.euicc.EuiccPort} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v3, resolved type: com.android.internal.telephony.uicc.euicc.EuiccPort} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void update(android.content.Context r12, com.android.internal.telephony.CommandsInterface r13, com.android.internal.telephony.uicc.IccCardStatus r14, int r15) {
        /*
            r11 = this;
            java.lang.Object r0 = r11.mLock
            monitor-enter(r0)
            com.android.internal.telephony.uicc.IccCardStatus$CardState r1 = r14.mCardState     // Catch:{ all -> 0x006a }
            r11.mCardState = r1     // Catch:{ all -> 0x006a }
            java.lang.String r1 = r14.iccid     // Catch:{ all -> 0x006a }
            r11.updateCardId(r1)     // Catch:{ all -> 0x006a }
            com.android.internal.telephony.uicc.IccCardStatus$CardState r1 = r11.mCardState     // Catch:{ all -> 0x006a }
            com.android.internal.telephony.uicc.IccCardStatus$CardState r2 = com.android.internal.telephony.uicc.IccCardStatus.CardState.CARDSTATE_ABSENT     // Catch:{ all -> 0x006a }
            if (r1 == r2) goto L_0x0062
            com.android.internal.telephony.uicc.IccSlotPortMapping r1 = r14.mSlotPortMapping     // Catch:{ all -> 0x006a }
            int r1 = r1.mPortIndex     // Catch:{ all -> 0x006a }
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.uicc.UiccPort> r2 = r11.mUiccPorts     // Catch:{ all -> 0x006a }
            java.lang.Integer r3 = java.lang.Integer.valueOf(r1)     // Catch:{ all -> 0x006a }
            java.lang.Object r2 = r2.get(r3)     // Catch:{ all -> 0x006a }
            com.android.internal.telephony.uicc.UiccPort r2 = (com.android.internal.telephony.uicc.UiccPort) r2     // Catch:{ all -> 0x006a }
            if (r2 != 0) goto L_0x0050
            boolean r2 = r11 instanceof com.android.internal.telephony.uicc.euicc.EuiccCard     // Catch:{ all -> 0x006a }
            if (r2 == 0) goto L_0x0038
            com.android.internal.telephony.uicc.euicc.EuiccPort r2 = new com.android.internal.telephony.uicc.euicc.EuiccPort     // Catch:{ all -> 0x006a }
            java.lang.Object r8 = r11.mLock     // Catch:{ all -> 0x006a }
            boolean r10 = r11.mIsSupportsMultipleEnabledProfiles     // Catch:{ all -> 0x006a }
            r3 = r2
            r4 = r12
            r5 = r13
            r6 = r14
            r7 = r15
            r9 = r11
            r3.<init>(r4, r5, r6, r7, r8, r9, r10)     // Catch:{ all -> 0x006a }
            goto L_0x0046
        L_0x0038:
            com.android.internal.telephony.uicc.UiccPort r9 = new com.android.internal.telephony.uicc.UiccPort     // Catch:{ all -> 0x006a }
            java.lang.Object r7 = r11.mLock     // Catch:{ all -> 0x006a }
            r2 = r9
            r3 = r12
            r4 = r13
            r5 = r14
            r6 = r15
            r8 = r11
            r2.<init>(r3, r4, r5, r6, r7, r8)     // Catch:{ all -> 0x006a }
            r2 = r9
        L_0x0046:
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.uicc.UiccPort> r12 = r11.mUiccPorts     // Catch:{ all -> 0x006a }
            java.lang.Integer r13 = java.lang.Integer.valueOf(r1)     // Catch:{ all -> 0x006a }
            r12.put(r13, r2)     // Catch:{ all -> 0x006a }
            goto L_0x0053
        L_0x0050:
            r2.update(r12, r13, r14, r11)     // Catch:{ all -> 0x006a }
        L_0x0053:
            java.util.HashMap<java.lang.Integer, java.lang.Integer> r11 = r11.mPhoneIdToPortIdx     // Catch:{ all -> 0x006a }
            java.lang.Integer r12 = java.lang.Integer.valueOf(r15)     // Catch:{ all -> 0x006a }
            java.lang.Integer r13 = java.lang.Integer.valueOf(r1)     // Catch:{ all -> 0x006a }
            r11.put(r12, r13)     // Catch:{ all -> 0x006a }
            monitor-exit(r0)     // Catch:{ all -> 0x006a }
            return
        L_0x0062:
            java.lang.RuntimeException r11 = new java.lang.RuntimeException     // Catch:{ all -> 0x006a }
            java.lang.String r12 = "Card state is absent when updating!"
            r11.<init>(r12)     // Catch:{ all -> 0x006a }
            throw r11     // Catch:{ all -> 0x006a }
        L_0x006a:
            r11 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x006a }
            throw r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCard.update(android.content.Context, com.android.internal.telephony.CommandsInterface, com.android.internal.telephony.uicc.IccCardStatus, int):void");
    }

    /* access modifiers changed from: protected */
    public void finalize() {
        log("UiccCard finalized");
    }

    /* access modifiers changed from: protected */
    public void updateCardId(String str) {
        this.mCardId = str;
    }

    public void updateSupportMultipleEnabledProfile(boolean z) {
        this.mIsSupportsMultipleEnabledProfiles = z;
    }

    @UnsupportedAppUsage
    public IccCardStatus.CardState getCardState() {
        IccCardStatus.CardState cardState;
        synchronized (this.mLock) {
            cardState = this.mCardState;
        }
        return cardState;
    }

    public String getCardId() {
        if (!TextUtils.isEmpty(this.mCardId)) {
            return this.mCardId;
        }
        UiccProfile uiccProfile = this.mUiccPorts.get(0).getUiccProfile();
        if (uiccProfile == null) {
            return null;
        }
        return uiccProfile.getIccId();
    }

    public UiccPort[] getUiccPortList() {
        UiccPort[] uiccPortArr;
        synchronized (this.mLock) {
            uiccPortArr = (UiccPort[]) this.mUiccPorts.values().stream().toArray(new UiccCard$$ExternalSyntheticLambda0());
        }
        return uiccPortArr;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ UiccPort[] lambda$getUiccPortList$0(int i) {
        return new UiccPort[i];
    }

    public UiccPort getUiccPortForPhone(int i) {
        UiccPort uiccPort;
        synchronized (this.mLock) {
            uiccPort = this.mUiccPorts.get(this.mPhoneIdToPortIdx.get(Integer.valueOf(i)));
        }
        return uiccPort;
    }

    public UiccPort getUiccPort(int i) {
        UiccPort uiccPort;
        synchronized (this.mLock) {
            uiccPort = this.mUiccPorts.get(Integer.valueOf(i));
        }
        return uiccPort;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("UiccCard:");
        printWriter.println(" mCardState=" + this.mCardState);
        printWriter.println(" mCardId=" + this.mCardId);
        printWriter.println(" mNumberOfPorts=" + this.mUiccPorts.size());
        printWriter.println("mIsSupportsMultipleEnabledProfiles=" + this.mIsSupportsMultipleEnabledProfiles);
        printWriter.println();
        for (UiccPort dump : this.mUiccPorts.values()) {
            dump.dump(fileDescriptor, printWriter, strArr);
        }
    }
}
