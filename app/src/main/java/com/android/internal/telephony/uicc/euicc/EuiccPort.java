package com.android.internal.telephony.uicc.euicc;

import android.content.Context;
import android.content.res.Resources;
import android.os.Handler;
import android.service.carrier.CarrierIdentifier;
import android.service.euicc.EuiccProfileInfo;
import android.telephony.SubscriptionInfo;
import android.telephony.UiccAccessRule;
import android.telephony.euicc.EuiccNotification;
import android.telephony.euicc.EuiccRulesAuthTable;
import android.telephony.gsm.SmsMessage;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccIoResult;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.asn1.Asn1Decoder;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.asn1.InvalidAsn1DataException;
import com.android.internal.telephony.uicc.asn1.TagNotFoundException;
import com.android.internal.telephony.uicc.euicc.apdu.ApduException;
import com.android.internal.telephony.uicc.euicc.apdu.ApduSender;
import com.android.internal.telephony.uicc.euicc.apdu.ApduSenderResultCallback;
import com.android.internal.telephony.uicc.euicc.apdu.RequestBuilder;
import com.android.internal.telephony.uicc.euicc.apdu.RequestProvider;
import com.android.internal.telephony.uicc.euicc.async.AsyncResultCallback;
import com.android.internal.telephony.uicc.euicc.async.AsyncResultHelper;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.InterPhoneService;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import kotlin.UByte;

public class EuiccPort extends UiccPort {
    private static final int APDU_ERROR_SIM_REFRESH = 28416;
    private static final int CODE_NOTHING_TO_DELETE = 1;
    private static final int CODE_NO_RESULT_AVAILABLE = 1;
    private static final int CODE_OK = 0;
    private static final int CODE_PROFILE_NOT_IN_EXPECTED_STATE = 2;
    private static final boolean DBG = true;
    private static final String DEV_CAP_CDMA_1X = "cdma1x";
    private static final String DEV_CAP_CRL = "crl";
    private static final String DEV_CAP_EHRPD = "ehrpd";
    private static final String DEV_CAP_EUTRAN = "eutran";
    private static final String DEV_CAP_EUTRAN5GC = "eutran5gc";
    private static final String DEV_CAP_GSM = "gsm";
    private static final String DEV_CAP_HRPD = "hrpd";
    private static final String DEV_CAP_NFC = "nfc";
    private static final String DEV_CAP_NR5GC = "nr5gc";
    private static final String DEV_CAP_NREPC = "nrepc";
    private static final String DEV_CAP_UTRAN = "utran";
    private static final int ICCID_LENGTH = 20;
    private static final String ISD_R_AID = "A0000005591010FFFFFFFF8900000100";
    private static final String LOG_TAG = "EuiccPort";
    private static final EuiccSpecVersion SGP22_V_2_0 = new EuiccSpecVersion(2, 0, 0);
    private static final EuiccSpecVersion SGP22_V_2_1 = new EuiccSpecVersion(2, 1, 0);
    private final ApduSender mApduSender;
    private volatile String mEid;
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public boolean mIsSupportsMultipleEnabledProfiles;
    private EuiccSpecVersion mSpecVersion;

    private interface ApduExceptionHandler {
        void handleException(Throwable th);
    }

    private interface ApduIntermediateResultHandler {
        boolean shouldContinue(IccIoResult iccIoResult);
    }

    private interface ApduRequestBuilder {
        void build(RequestBuilder requestBuilder) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException;
    }

    private interface ApduResponseHandler<T> {
        T handleResult(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ byte[] lambda$getEuiccInfo1$29(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        return bArr;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ byte[] lambda$getEuiccInfo2$31(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        return bArr;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$getSpecVersion$0(RequestBuilder requestBuilder) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
    }

    public EuiccPort(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, Object obj, UiccCard uiccCard, boolean z) {
        super(context, commandsInterface, iccCardStatus, i, obj, uiccCard);
        this.mApduSender = new ApduSender(commandsInterface, ISD_R_AID, false);
        if (TextUtils.isEmpty(iccCardStatus.eid)) {
            loge("no eid given in constructor for phone " + i);
        } else {
            this.mEid = iccCardStatus.eid;
            this.mCardId = iccCardStatus.eid;
        }
        this.mIsSupportsMultipleEnabledProfiles = z;
    }

    public void getSpecVersion(AsyncResultCallback<EuiccSpecVersion> asyncResultCallback, Handler handler) {
        EuiccSpecVersion euiccSpecVersion = this.mSpecVersion;
        if (euiccSpecVersion != null) {
            AsyncResultHelper.returnResult(euiccSpecVersion, asyncResultCallback, handler);
        } else {
            sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda18()), new EuiccPort$$ExternalSyntheticLambda19(this), asyncResultCallback, handler);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ EuiccSpecVersion lambda$getSpecVersion$1(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        return this.mSpecVersion;
    }

    public void update(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, UiccCard uiccCard) {
        synchronized (this.mLock) {
            if (!TextUtils.isEmpty(iccCardStatus.eid)) {
                this.mEid = iccCardStatus.eid;
            }
            super.update(context, commandsInterface, iccCardStatus, uiccCard);
        }
    }

    public void updateSupportMultipleEnabledProfile(boolean z) {
        logd("updateSupportMultipleEnabledProfile");
        this.mIsSupportsMultipleEnabledProfiles = z;
    }

    public void getAllProfiles(AsyncResultCallback<EuiccProfileInfo[]> asyncResultCallback, Handler handler) {
        byte[] bArr;
        if (this.mIsSupportsMultipleEnabledProfiles) {
            bArr = Tags.EUICC_PROFILE_MEP_TAGS;
        } else {
            bArr = Tags.EUICC_PROFILE_TAGS;
        }
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda8(bArr)), new EuiccPort$$ExternalSyntheticLambda9(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccProfileInfo[] lambda$getAllProfiles$3(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        List children = new Asn1Decoder(bArr).nextNode().getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]).getChildren(227);
        int size = children.size();
        EuiccProfileInfo[] euiccProfileInfoArr = new EuiccProfileInfo[size];
        int i = 0;
        for (int i2 = 0; i2 < size; i2++) {
            Asn1Node asn1Node = (Asn1Node) children.get(i2);
            if (!asn1Node.hasChild(90, new int[0])) {
                loge("Profile must have an ICCID.");
            } else {
                EuiccProfileInfo.Builder builder = new EuiccProfileInfo.Builder(stripTrailingFs(asn1Node.getChild(90, new int[0]).asBytes()));
                buildProfile(asn1Node, builder);
                euiccProfileInfoArr[i] = builder.build();
                i++;
            }
        }
        return euiccProfileInfoArr;
    }

    public final void getProfile(String str, AsyncResultCallback<EuiccProfileInfo> asyncResultCallback, Handler handler) {
        byte[] bArr;
        if (this.mIsSupportsMultipleEnabledProfiles) {
            bArr = Tags.EUICC_PROFILE_MEP_TAGS;
        } else {
            bArr = Tags.EUICC_PROFILE_TAGS;
        }
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda22(str, bArr)), new EuiccPort$$ExternalSyntheticLambda23(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccProfileInfo lambda$getProfile$5(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        List children = new Asn1Decoder(bArr).nextNode().getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]).getChildren(227);
        if (children.isEmpty()) {
            return null;
        }
        Asn1Node asn1Node = (Asn1Node) children.get(0);
        EuiccProfileInfo.Builder builder = new EuiccProfileInfo.Builder(stripTrailingFs(asn1Node.getChild(90, new int[0]).asBytes()));
        buildProfile(asn1Node, builder);
        return builder.build();
    }

    public void disableProfile(String str, boolean z, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApduWithSimResetErrorWorkaround(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda31(str, z)), new EuiccPort$$ExternalSyntheticLambda32(str), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$disableProfile$7(String str, byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0) {
            return null;
        }
        if (parseSimpleResult == 2) {
            logd("Profile is already disabled, iccid: " + SubscriptionInfo.givePrintableIccid(str));
            return null;
        }
        throw new EuiccCardErrorException(11, parseSimpleResult);
    }

    public void switchToProfile(String str, boolean z, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApduWithSimResetErrorWorkaround(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda14(str, z)), new EuiccPort$$ExternalSyntheticLambda15(str), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$switchToProfile$9(String str, byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0) {
            return null;
        }
        if (parseSimpleResult == 2) {
            logd("Profile is already enabled, iccid: " + SubscriptionInfo.givePrintableIccid(str));
            return null;
        }
        throw new EuiccCardErrorException(10, parseSimpleResult);
    }

    public String getEid() {
        return this.mEid;
    }

    public void getEid(AsyncResultCallback<String> asyncResultCallback, Handler handler) {
        if (this.mEid != null) {
            AsyncResultHelper.returnResult(this.mEid, asyncResultCallback, handler);
        } else {
            sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda24()), new EuiccPort$$ExternalSyntheticLambda25(this), asyncResultCallback, handler);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ String lambda$getEid$11(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        String bytesToHexString = IccUtils.bytesToHexString(parseResponse(bArr).getChild(90, new int[0]).asBytes());
        synchronized (this.mLock) {
            this.mEid = bytesToHexString;
            this.mCardId = bytesToHexString;
        }
        return bytesToHexString;
    }

    public void setNickname(String str, String str2, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda16(str, str2)), new EuiccPort$$ExternalSyntheticLambda17(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$setNickname$13(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0) {
            return null;
        }
        throw new EuiccCardErrorException(7, parseSimpleResult);
    }

    public void deleteProfile(String str, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda37(str)), new EuiccPort$$ExternalSyntheticLambda38(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$deleteProfile$15(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0) {
            return null;
        }
        throw new EuiccCardErrorException(12, parseSimpleResult);
    }

    public void resetMemory(int i, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApduWithSimResetErrorWorkaround(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda33(i)), new EuiccPort$$ExternalSyntheticLambda34(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$resetMemory$17(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0 || parseSimpleResult == 1) {
            return null;
        }
        throw new EuiccCardErrorException(13, parseSimpleResult);
    }

    public void getDefaultSmdpAddress(AsyncResultCallback<String> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda26()), new EuiccPort$$ExternalSyntheticLambda27(), asyncResultCallback, handler);
    }

    public void getSmdsAddress(AsyncResultCallback<String> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda2()), new EuiccPort$$ExternalSyntheticLambda3(), asyncResultCallback, handler);
    }

    public void setDefaultSmdpAddress(String str, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda0(str)), new EuiccPort$$ExternalSyntheticLambda1(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$setDefaultSmdpAddress$23(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0) {
            return null;
        }
        throw new EuiccCardErrorException(14, parseSimpleResult);
    }

    public void getRulesAuthTable(AsyncResultCallback<EuiccRulesAuthTable> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda35()), new EuiccPort$$ExternalSyntheticLambda36(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccRulesAuthTable lambda$getRulesAuthTable$25(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        List children = parseResponse(bArr).getChildren(SmsMessage.MAX_USER_DATA_SEPTETS);
        EuiccRulesAuthTable.Builder builder = new EuiccRulesAuthTable.Builder(children.size());
        int size = children.size();
        for (int i = 0; i < size; i++) {
            Asn1Node asn1Node = (Asn1Node) children.get(i);
            List children2 = asn1Node.getChild(48, new int[]{161}).getChildren();
            int size2 = children2.size();
            CarrierIdentifier[] carrierIdentifierArr = new CarrierIdentifier[size2];
            for (int i2 = 0; i2 < size2; i2++) {
                carrierIdentifierArr[i2] = buildCarrierIdentifier((Asn1Node) children2.get(i2));
            }
            builder.add(asn1Node.getChild(48, new int[]{128}).asBits(), Arrays.asList(carrierIdentifierArr), asn1Node.getChild(48, new int[]{130}).asBits());
        }
        return builder.build();
    }

    public void getEuiccChallenge(AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda29()), new EuiccPort$$ExternalSyntheticLambda30(), asyncResultCallback, handler);
    }

    public void getEuiccInfo1(AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda20()), new EuiccPort$$ExternalSyntheticLambda21(), asyncResultCallback, handler);
    }

    public void getEuiccInfo2(AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda42()), new EuiccPort$$ExternalSyntheticLambda43(), asyncResultCallback, handler);
    }

    public void authenticateServer(String str, byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4, AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda6(this, str, bArr, bArr2, bArr3, bArr4)), new EuiccPort$$ExternalSyntheticLambda7(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$authenticateServer$32(String str, byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4, RequestBuilder requestBuilder) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        byte[] deviceId = getDeviceId();
        byte[] bArr5 = new byte[4];
        System.arraycopy(deviceId, 0, bArr5, 0, 4);
        Asn1Node.Builder newBuilder = Asn1Node.newBuilder(161);
        String[] stringArray = getResources().getStringArray(17236149);
        if (stringArray != null) {
            for (String addDeviceCapability : stringArray) {
                addDeviceCapability(newBuilder, addDeviceCapability);
            }
        } else {
            logd("No device capabilities set.");
        }
        requestBuilder.addStoreData(Asn1Node.newBuilder(48952).addChild(new Asn1Decoder(bArr).nextNode()).addChild(new Asn1Decoder(bArr2).nextNode()).addChild(new Asn1Decoder(bArr3).nextNode()).addChild(new Asn1Decoder(bArr4).nextNode()).addChild(Asn1Node.newBuilder(SmsMessage.MAX_USER_DATA_SEPTETS).addChildAsString(128, str).addChild(Asn1Node.newBuilder(161).addChildAsBytes(128, bArr5).addChild(newBuilder).addChildAsBytes(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, deviceId))).build().toHex());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ byte[] lambda$authenticateServer$33(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node parseResponse = parseResponse(bArr);
        if (!parseResponse.hasChild(161, new int[]{2})) {
            return parseResponse.toBytes();
        }
        throw new EuiccCardErrorException(3, parseResponse.getChild(161, new int[]{2}).asInteger());
    }

    public void prepareDownload(byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4, AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda44(bArr2, bArr3, bArr, bArr4)), new EuiccPort$$ExternalSyntheticLambda45(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$prepareDownload$34(byte[] bArr, byte[] bArr2, byte[] bArr3, byte[] bArr4, RequestBuilder requestBuilder) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node.Builder addChild = Asn1Node.newBuilder(48929).addChild(new Asn1Decoder(bArr).nextNode()).addChild(new Asn1Decoder(bArr2).nextNode());
        if (bArr3 != null) {
            addChild.addChildAsBytes(4, bArr3);
        }
        requestBuilder.addStoreData(addChild.addChild(new Asn1Decoder(bArr4).nextNode()).build().toHex());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ byte[] lambda$prepareDownload$35(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node parseResponse = parseResponse(bArr);
        if (!parseResponse.hasChild(161, new int[]{2})) {
            return parseResponse.toBytes();
        }
        throw new EuiccCardErrorException(2, parseResponse.getChild(161, new int[]{2}).asInteger());
    }

    public void loadBoundProfilePackage(byte[] bArr, AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda39(this, bArr)), new EuiccPort$$ExternalSyntheticLambda40(), new EuiccPort$$ExternalSyntheticLambda41(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$loadBoundProfilePackage$36(byte[] bArr, RequestBuilder requestBuilder) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node asn1Node;
        Asn1Node nextNode = new Asn1Decoder(bArr).nextNode();
        int dataLength = nextNode.getDataLength();
        Asn1Node child = nextNode.getChild(48931, new int[0]);
        Asn1Node child2 = nextNode.getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]);
        int encodedLength = child.getEncodedLength() + 0 + child2.getEncodedLength();
        Asn1Node child3 = nextNode.getChild(161, new int[0]);
        List children = child3.getChildren(NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT);
        int encodedLength2 = encodedLength + child3.getEncodedLength();
        if (nextNode.hasChild(162, new int[0])) {
            asn1Node = nextNode.getChild(162, new int[0]);
            encodedLength2 += asn1Node.getEncodedLength();
        } else {
            asn1Node = null;
        }
        Asn1Node child4 = nextNode.getChild(163, new int[0]);
        List children2 = child4.getChildren(134);
        int encodedLength3 = encodedLength2 + child4.getEncodedLength();
        if (this.mSpecVersion.compareTo(SGP22_V_2_1) >= 0) {
            if (children2 == null || children2.isEmpty()) {
                throw new EuiccCardException("No profile elements in BPP");
            } else if (dataLength != encodedLength3) {
                throw new EuiccCardException("Actual BPP length (" + dataLength + ") does not match segmented length (" + encodedLength3 + "), this must be due to a malformed BPP");
            }
        }
        requestBuilder.addStoreData(nextNode.getHeadAsHex() + child.toHex());
        requestBuilder.addStoreData(child2.toHex());
        requestBuilder.addStoreData(child3.getHeadAsHex());
        int size = children.size();
        for (int i = 0; i < size; i++) {
            requestBuilder.addStoreData(((Asn1Node) children.get(i)).toHex());
        }
        if (asn1Node != null) {
            requestBuilder.addStoreData(asn1Node.toHex());
        }
        requestBuilder.addStoreData(child4.getHeadAsHex());
        int size2 = children2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            requestBuilder.addStoreData(((Asn1Node) children2.get(i2)).toHex());
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ byte[] lambda$loadBoundProfilePackage$37(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node parseResponse = parseResponse(bArr);
        if (!parseResponse.hasChild(48935, new int[]{162, 161, 129})) {
            return parseResponse.toBytes();
        }
        Asn1Node child = parseResponse.getChild(48935, new int[]{162, 161, 129});
        throw new EuiccCardErrorException(5, child.asInteger(), child);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ boolean lambda$loadBoundProfilePackage$38(IccIoResult iccIoResult) {
        byte[] bArr = iccIoResult.payload;
        if (bArr != null && bArr.length > 2) {
            if (((bArr[1] & UByte.MAX_VALUE) | ((bArr[0] & UByte.MAX_VALUE) << 8)) == 48951) {
                logd("loadBoundProfilePackage failed due to an early error.");
                return false;
            }
        }
        return true;
    }

    public void cancelSession(byte[] bArr, int i, AsyncResultCallback<byte[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda11(bArr, i)), new EuiccPort$$ExternalSyntheticLambda12(), asyncResultCallback, handler);
    }

    public void listNotifications(int i, AsyncResultCallback<EuiccNotification[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda46(i)), new EuiccPort$$ExternalSyntheticLambda47(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccNotification[] lambda$listNotifications$42(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        List children = parseResponseAndCheckSimpleError(bArr, 6).getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]).getChildren();
        int size = children.size();
        EuiccNotification[] euiccNotificationArr = new EuiccNotification[size];
        for (int i = 0; i < size; i++) {
            euiccNotificationArr[i] = createNotification((Asn1Node) children.get(i));
        }
        return euiccNotificationArr;
    }

    public void retrieveNotificationList(int i, AsyncResultCallback<EuiccNotification[]> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda4(i)), new EuiccPort$$ExternalSyntheticLambda5(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccNotification[] lambda$retrieveNotificationList$44(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        Asn1Node parseResponse = parseResponse(bArr);
        if (parseResponse.hasChild(129, new int[0])) {
            int asInteger = parseResponse.getChild(129, new int[0]).asInteger();
            if (asInteger == 1) {
                return new EuiccNotification[0];
            }
            throw new EuiccCardErrorException(8, asInteger);
        }
        List children = parseResponse.getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]).getChildren();
        int size = children.size();
        EuiccNotification[] euiccNotificationArr = new EuiccNotification[size];
        for (int i = 0; i < size; i++) {
            euiccNotificationArr[i] = createNotification((Asn1Node) children.get(i));
        }
        return euiccNotificationArr;
    }

    public void retrieveNotification(int i, AsyncResultCallback<EuiccNotification> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda50(i)), new EuiccPort$$ExternalSyntheticLambda51(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ EuiccNotification lambda$retrieveNotification$46(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        List children = parseResponseAndCheckSimpleError(bArr, 8).getChild(SmsMessage.MAX_USER_DATA_SEPTETS, new int[0]).getChildren();
        if (children.size() > 0) {
            return createNotification((Asn1Node) children.get(0));
        }
        return null;
    }

    public void removeNotificationFromList(int i, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApdu(newRequestProvider(new EuiccPort$$ExternalSyntheticLambda48(i)), new EuiccPort$$ExternalSyntheticLambda49(), asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Void lambda$removeNotificationFromList$48(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        int parseSimpleResult = parseSimpleResult(bArr);
        if (parseSimpleResult == 0 || parseSimpleResult == 1) {
            return null;
        }
        throw new EuiccCardErrorException(9, parseSimpleResult);
    }

    /* JADX WARNING: Can't fix incorrect switch cases order */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x00b9, code lost:
        if (r1.equals(DEV_CAP_EUTRAN5GC) == false) goto L_0x0051;
     */
    @com.android.internal.annotations.VisibleForTesting(visibility = com.android.internal.annotations.VisibleForTesting.Visibility.PRIVATE)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void addDeviceCapability(com.android.internal.telephony.uicc.asn1.Asn1Node.Builder r7, java.lang.String r8) {
        /*
            r6 = this;
            java.lang.String r6 = ","
            java.lang.String[] r6 = r8.split(r6)
            int r8 = r6.length
            r0 = 2
            if (r8 == r0) goto L_0x0023
            java.lang.StringBuilder r7 = new java.lang.StringBuilder
            r7.<init>()
            java.lang.String r8 = "Invalid device capability item: "
            r7.append(r8)
            java.lang.String r6 = java.util.Arrays.toString(r6)
            r7.append(r6)
            java.lang.String r6 = r7.toString()
            loge(r6)
            return
        L_0x0023:
            r8 = 0
            r1 = r6[r8]
            java.lang.String r1 = r1.trim()
            r2 = 1
            r6 = r6[r2]     // Catch:{ NumberFormatException -> 0x012b }
            java.lang.String r6 = r6.trim()     // Catch:{ NumberFormatException -> 0x012b }
            int r6 = java.lang.Integer.parseInt(r6)     // Catch:{ NumberFormatException -> 0x012b }
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)     // Catch:{ NumberFormatException -> 0x012b }
            r3 = 3
            byte[] r4 = new byte[r3]
            byte r6 = r6.byteValue()
            r4[r8] = r6
            r4[r2] = r8
            r4[r0] = r8
            r1.hashCode()
            r6 = -1
            int r5 = r1.hashCode()
            switch(r5) {
                case -1364987172: goto L_0x00c7;
                case -1291802661: goto L_0x00bc;
                case -1186047466: goto L_0x00b3;
                case 98781: goto L_0x00a8;
                case 102657: goto L_0x009d;
                case 108971: goto L_0x0092;
                case 3211390: goto L_0x0087;
                case 96487011: goto L_0x007c;
                case 105037709: goto L_0x006f;
                case 105084116: goto L_0x0062;
                case 111620384: goto L_0x0054;
                default: goto L_0x0051;
            }
        L_0x0051:
            r0 = r6
            goto L_0x00d1
        L_0x0054:
            java.lang.String r8 = "utran"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x005e
            goto L_0x0051
        L_0x005e:
            r0 = 10
            goto L_0x00d1
        L_0x0062:
            java.lang.String r8 = "nrepc"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x006b
            goto L_0x0051
        L_0x006b:
            r0 = 9
            goto L_0x00d1
        L_0x006f:
            java.lang.String r8 = "nr5gc"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x0078
            goto L_0x0051
        L_0x0078:
            r0 = 8
            goto L_0x00d1
        L_0x007c:
            java.lang.String r8 = "ehrpd"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x0085
            goto L_0x0051
        L_0x0085:
            r0 = 7
            goto L_0x00d1
        L_0x0087:
            java.lang.String r8 = "hrpd"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x0090
            goto L_0x0051
        L_0x0090:
            r0 = 6
            goto L_0x00d1
        L_0x0092:
            java.lang.String r8 = "nfc"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x009b
            goto L_0x0051
        L_0x009b:
            r0 = 5
            goto L_0x00d1
        L_0x009d:
            java.lang.String r8 = "gsm"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x00a6
            goto L_0x0051
        L_0x00a6:
            r0 = 4
            goto L_0x00d1
        L_0x00a8:
            java.lang.String r8 = "crl"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x00b1
            goto L_0x0051
        L_0x00b1:
            r0 = r3
            goto L_0x00d1
        L_0x00b3:
            java.lang.String r8 = "eutran5gc"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x00d1
            goto L_0x0051
        L_0x00bc:
            java.lang.String r8 = "eutran"
            boolean r8 = r1.equals(r8)
            if (r8 != 0) goto L_0x00c5
            goto L_0x0051
        L_0x00c5:
            r0 = r2
            goto L_0x00d1
        L_0x00c7:
            java.lang.String r0 = "cdma1x"
            boolean r0 = r1.equals(r0)
            if (r0 != 0) goto L_0x00d0
            goto L_0x0051
        L_0x00d0:
            r0 = r8
        L_0x00d1:
            switch(r0) {
                case 0: goto L_0x0125;
                case 1: goto L_0x011f;
                case 2: goto L_0x0119;
                case 3: goto L_0x0113;
                case 4: goto L_0x010d;
                case 5: goto L_0x0107;
                case 6: goto L_0x0101;
                case 7: goto L_0x00fb;
                case 8: goto L_0x00f5;
                case 9: goto L_0x00ef;
                case 10: goto L_0x00e9;
                default: goto L_0x00d4;
            }
        L_0x00d4:
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r7 = "Invalid device capability name: "
            r6.append(r7)
            r6.append(r1)
            java.lang.String r6 = r6.toString()
            loge(r6)
            goto L_0x012a
        L_0x00e9:
            r6 = 129(0x81, float:1.81E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x00ef:
            r6 = 136(0x88, float:1.9E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x00f5:
            r6 = 137(0x89, float:1.92E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x00fb:
            r6 = 132(0x84, float:1.85E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x0101:
            r6 = 131(0x83, float:1.84E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x0107:
            r6 = 134(0x86, float:1.88E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x010d:
            r6 = 128(0x80, float:1.794E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x0113:
            r6 = 135(0x87, float:1.89E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x0119:
            r6 = 138(0x8a, float:1.93E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x011f:
            r6 = 133(0x85, float:1.86E-43)
            r7.addChildAsBytes(r6, r4)
            goto L_0x012a
        L_0x0125:
            r6 = 130(0x82, float:1.82E-43)
            r7.addChildAsBytes(r6, r4)
        L_0x012a:
            return
        L_0x012b:
            r6 = move-exception
            java.lang.String r7 = "Invalid device capability version number."
            loge(r7, r6)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.euicc.EuiccPort.addDeviceCapability(com.android.internal.telephony.uicc.asn1.Asn1Node$Builder, java.lang.String):void");
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public byte[] getDeviceId() {
        Phone phone = PhoneFactory.getPhone(getPhoneId());
        if (phone == null) {
            return new byte[8];
        }
        return getDeviceId(phone.getDeviceId(), this.mSpecVersion);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public static byte[] getDeviceId(String str, EuiccSpecVersion euiccSpecVersion) {
        byte[] bArr = new byte[8];
        if (euiccSpecVersion.compareTo(SGP22_V_2_1) >= 0) {
            IccUtils.bcdToBytes(str + 'F', bArr);
            byte b = bArr[7] & UByte.MAX_VALUE;
            bArr[7] = (byte) ((b >>> 4) | (b << 4));
        } else {
            IccUtils.bcdToBytes(str, bArr);
        }
        return bArr;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public Resources getResources() {
        return Resources.getSystem();
    }

    private RequestProvider newRequestProvider(ApduRequestBuilder apduRequestBuilder) {
        return new EuiccPort$$ExternalSyntheticLambda28(this, apduRequestBuilder);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$newRequestProvider$49(ApduRequestBuilder apduRequestBuilder, byte[] bArr, RequestBuilder requestBuilder) throws Throwable {
        EuiccSpecVersion orExtractSpecVersion = getOrExtractSpecVersion(bArr);
        if (orExtractSpecVersion != null) {
            try {
                if (orExtractSpecVersion.compareTo(SGP22_V_2_0) >= 0) {
                    apduRequestBuilder.build(requestBuilder);
                    return;
                }
                throw new EuiccCardException("eUICC spec version is unsupported: " + orExtractSpecVersion);
            } catch (InvalidAsn1DataException | TagNotFoundException e) {
                throw new EuiccCardException("Cannot parse ASN1 to build request.", e);
            }
        } else {
            throw new EuiccCardException("Cannot get eUICC spec version.");
        }
    }

    private EuiccSpecVersion getOrExtractSpecVersion(byte[] bArr) {
        EuiccSpecVersion euiccSpecVersion = this.mSpecVersion;
        if (euiccSpecVersion != null) {
            return euiccSpecVersion;
        }
        EuiccSpecVersion fromOpenChannelResponse = EuiccSpecVersion.fromOpenChannelResponse(bArr);
        if (fromOpenChannelResponse != null) {
            synchronized (this.mLock) {
                if (this.mSpecVersion == null) {
                    this.mSpecVersion = fromOpenChannelResponse;
                }
            }
        }
        return fromOpenChannelResponse;
    }

    private <T> void sendApdu(RequestProvider requestProvider, ApduResponseHandler<T> apduResponseHandler, AsyncResultCallback<T> asyncResultCallback, Handler handler) {
        sendApdu(requestProvider, apduResponseHandler, new EuiccPort$$ExternalSyntheticLambda52(asyncResultCallback), (ApduIntermediateResultHandler) null, asyncResultCallback, handler);
    }

    private <T> void sendApdu(RequestProvider requestProvider, ApduResponseHandler<T> apduResponseHandler, ApduIntermediateResultHandler apduIntermediateResultHandler, AsyncResultCallback<T> asyncResultCallback, Handler handler) {
        sendApdu(requestProvider, apduResponseHandler, new EuiccPort$$ExternalSyntheticLambda13(asyncResultCallback), apduIntermediateResultHandler, asyncResultCallback, handler);
    }

    private void sendApduWithSimResetErrorWorkaround(RequestProvider requestProvider, ApduResponseHandler<Void> apduResponseHandler, AsyncResultCallback<Void> asyncResultCallback, Handler handler) {
        sendApdu(requestProvider, apduResponseHandler, new EuiccPort$$ExternalSyntheticLambda10(asyncResultCallback), (ApduIntermediateResultHandler) null, asyncResultCallback, handler);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$sendApduWithSimResetErrorWorkaround$52(AsyncResultCallback asyncResultCallback, Throwable th) {
        if (!(th instanceof ApduException) || ((ApduException) th).getApduStatus() != APDU_ERROR_SIM_REFRESH) {
            asyncResultCallback.onException(new EuiccCardException("Cannot send APDU.", th));
            return;
        }
        logi("Sim is refreshed after disabling profile, no response got.");
        asyncResultCallback.onResult(null);
    }

    private <T> void sendApdu(RequestProvider requestProvider, ApduResponseHandler<T> apduResponseHandler, ApduExceptionHandler apduExceptionHandler, ApduIntermediateResultHandler apduIntermediateResultHandler, AsyncResultCallback<T> asyncResultCallback, Handler handler) {
        final AsyncResultCallback<T> asyncResultCallback2 = asyncResultCallback;
        final ApduResponseHandler<T> apduResponseHandler2 = apduResponseHandler;
        final ApduIntermediateResultHandler apduIntermediateResultHandler2 = apduIntermediateResultHandler;
        final ApduExceptionHandler apduExceptionHandler2 = apduExceptionHandler;
        this.mApduSender.send(requestProvider, new ApduSenderResultCallback() {
            public void onResult(byte[] bArr) {
                try {
                    asyncResultCallback2.onResult(apduResponseHandler2.handleResult(bArr));
                } catch (EuiccCardException e) {
                    asyncResultCallback2.onException(e);
                } catch (InvalidAsn1DataException | TagNotFoundException e2) {
                    AsyncResultCallback asyncResultCallback = asyncResultCallback2;
                    asyncResultCallback.onException(new EuiccCardException("Cannot parse response: " + IccUtils.bytesToHexString(bArr), e2));
                }
            }

            public boolean shouldContinueOnIntermediateResult(IccIoResult iccIoResult) {
                ApduIntermediateResultHandler apduIntermediateResultHandler = apduIntermediateResultHandler2;
                if (apduIntermediateResultHandler == null) {
                    return true;
                }
                return apduIntermediateResultHandler.shouldContinue(iccIoResult);
            }

            public void onException(Throwable th) {
                apduExceptionHandler2.handleException(th);
            }
        }, handler);
    }

    private static void buildProfile(Asn1Node asn1Node, EuiccProfileInfo.Builder builder) throws TagNotFoundException, InvalidAsn1DataException {
        if (asn1Node.hasChild(144, new int[0])) {
            builder.setNickname(asn1Node.getChild(144, new int[0]).asString());
        }
        if (asn1Node.hasChild(145, new int[0])) {
            builder.setServiceProviderName(asn1Node.getChild(145, new int[0]).asString());
        }
        if (asn1Node.hasChild(146, new int[0])) {
            builder.setProfileName(asn1Node.getChild(146, new int[0]).asString());
        }
        if (asn1Node.hasChild(183, new int[0])) {
            builder.setCarrierIdentifier(buildCarrierIdentifier(asn1Node.getChild(183, new int[0])));
        }
        if (!asn1Node.hasChild(40816, new int[0])) {
            builder.setState(0);
        } else if (!asn1Node.hasChild(40740, new int[0]) || asn1Node.getChild(40740, new int[0]).asInteger() < 0) {
            builder.setState(asn1Node.getChild(40816, new int[0]).asInteger());
        } else {
            builder.setState(1);
        }
        if (asn1Node.hasChild(149, new int[0])) {
            builder.setProfileClass(asn1Node.getChild(149, new int[0]).asInteger());
        } else {
            builder.setProfileClass(2);
        }
        if (asn1Node.hasChild(SmsMessage.MAX_USER_DATA_SEPTETS_WITH_HEADER, new int[0])) {
            builder.setPolicyRules(asn1Node.getChild(SmsMessage.MAX_USER_DATA_SEPTETS_WITH_HEADER, new int[0]).asBits());
        }
        if (asn1Node.hasChild(49014, new int[0])) {
            UiccAccessRule[] buildUiccAccessRule = buildUiccAccessRule(asn1Node.getChild(49014, new int[0]).getChildren(226));
            List list = null;
            if (buildUiccAccessRule != null) {
                list = Arrays.asList(buildUiccAccessRule);
            }
            builder.setUiccAccessRule(list);
        }
    }

    private static CarrierIdentifier buildCarrierIdentifier(Asn1Node asn1Node) throws InvalidAsn1DataException, TagNotFoundException {
        String str = null;
        String bytesToHexString = asn1Node.hasChild(129, new int[0]) ? IccUtils.bytesToHexString(asn1Node.getChild(129, new int[0]).asBytes()) : null;
        if (asn1Node.hasChild(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, new int[0])) {
            str = IccUtils.bytesToHexString(asn1Node.getChild(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT, new int[0]).asBytes());
        }
        return new CarrierIdentifier(asn1Node.getChild(128, new int[0]).asBytes(), bytesToHexString, str);
    }

    private static UiccAccessRule[] buildUiccAccessRule(List<Asn1Node> list) throws InvalidAsn1DataException, TagNotFoundException {
        if (list.isEmpty()) {
            return null;
        }
        int size = list.size();
        UiccAccessRule[] uiccAccessRuleArr = new UiccAccessRule[size];
        for (int i = 0; i < size; i++) {
            Asn1Node asn1Node = list.get(i);
            Asn1Node child = asn1Node.getChild(225, new int[0]);
            byte[] asBytes = child.getChild(193, new int[0]).asBytes();
            String asString = child.hasChild(202, new int[0]) ? child.getChild(202, new int[0]).asString() : null;
            long j = 0;
            if (asn1Node.hasChild(227, new int[]{219})) {
                j = asn1Node.getChild(227, new int[]{219}).asRawLong();
            }
            uiccAccessRuleArr[i] = new UiccAccessRule(asBytes, asString, j);
        }
        return uiccAccessRuleArr;
    }

    private static EuiccNotification createNotification(Asn1Node asn1Node) throws TagNotFoundException, InvalidAsn1DataException {
        Asn1Node asn1Node2;
        if (asn1Node.getTag() == 48943) {
            asn1Node2 = asn1Node;
        } else if (asn1Node.getTag() == 48951) {
            asn1Node2 = asn1Node.getChild(48935, new int[]{48943});
        } else {
            asn1Node2 = asn1Node.getChild(48943, new int[0]);
        }
        return new EuiccNotification(asn1Node2.getChild(128, new int[0]).asInteger(), asn1Node2.getChild(12, new int[0]).asString(), asn1Node2.getChild(129, new int[0]).asBits(), asn1Node.getTag() == 48943 ? null : asn1Node.toBytes());
    }

    private static int parseSimpleResult(byte[] bArr) throws EuiccCardException, TagNotFoundException, InvalidAsn1DataException {
        return parseResponse(bArr).getChild(128, new int[0]).asInteger();
    }

    private static Asn1Node parseResponse(byte[] bArr) throws EuiccCardException, InvalidAsn1DataException {
        Asn1Decoder asn1Decoder = new Asn1Decoder(bArr);
        if (asn1Decoder.hasNextNode()) {
            return asn1Decoder.nextNode();
        }
        throw new EuiccCardException("Empty response", (Throwable) null);
    }

    private static Asn1Node parseResponseAndCheckSimpleError(byte[] bArr, int i) throws EuiccCardException, InvalidAsn1DataException, TagNotFoundException {
        Asn1Node parseResponse = parseResponse(bArr);
        if (!parseResponse.hasChild(129, new int[0])) {
            return parseResponse;
        }
        throw new EuiccCardErrorException(i, parseResponse.getChild(129, new int[0]).asInteger());
    }

    private static String stripTrailingFs(byte[] bArr) {
        return IccUtils.stripTrailingFs(IccUtils.bchToString(bArr, 0, bArr.length));
    }

    private static String padTrailingFs(String str) {
        if (TextUtils.isEmpty(str) || str.length() >= 20) {
            return str;
        }
        return str + new String(new char[(20 - str.length())]).replace(0, 'F');
    }

    private static void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    private static void loge(String str, Throwable th) {
        Rlog.e(LOG_TAG, str, th);
    }

    private static void logi(String str) {
        Rlog.i(LOG_TAG, str);
    }

    private static void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("EuiccPort:");
        printWriter.println(" mEid=" + this.mEid);
        printWriter.println(" mIsSupportsMultipleEnabledProfiles=" + this.mIsSupportsMultipleEnabledProfiles);
    }
}
