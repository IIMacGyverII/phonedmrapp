package com.android.internal.telephony;

import android.hardware.radio.V1_0.ActivityStatsInfo;
import android.hardware.radio.V1_0.Call;
import android.hardware.radio.V1_0.CallForwardInfo;
import android.hardware.radio.V1_0.CardStatus;
import android.hardware.radio.V1_0.Carrier;
import android.hardware.radio.V1_0.CarrierRestrictions;
import android.hardware.radio.V1_0.CdmaBroadcastSmsConfigInfo;
import android.hardware.radio.V1_0.CellInfo;
import android.hardware.radio.V1_0.DataRegStateResult;
import android.hardware.radio.V1_0.GsmBroadcastSmsConfigInfo;
import android.hardware.radio.V1_0.HardwareConfig;
import android.hardware.radio.V1_0.IccIoResult;
import android.hardware.radio.V1_0.LastCallFailCauseInfo;
import android.hardware.radio.V1_0.LceDataInfo;
import android.hardware.radio.V1_0.LceStatusInfo;
import android.hardware.radio.V1_0.NeighboringCell;
import android.hardware.radio.V1_0.OperatorInfo;
import android.hardware.radio.V1_0.RadioCapability;
import android.hardware.radio.V1_0.RadioResponseInfo;
import android.hardware.radio.V1_0.SendSmsResult;
import android.hardware.radio.V1_0.SetupDataCallResult;
import android.hardware.radio.V1_0.SignalStrength;
import android.hardware.radio.V1_0.VoiceRegStateResult;
import android.hardware.radio.V1_1.KeepaliveStatus;
import android.hardware.radio.V1_4.CarrierRestrictionsWithPriority;
import android.hardware.radio.V1_5.BarringInfo;
import android.hardware.radio.V1_5.CellIdentity;
import android.hardware.radio.V1_5.RadioAccessSpecifier;
import android.hardware.radio.V1_5.RegStateResult;
import android.hardware.radio.V1_6.IRadioResponse;
import android.hardware.radio.V1_6.PhonebookCapacity;
import android.hardware.radio.V1_6.SlicingConfig;
import android.os.AsyncResult;
import android.os.Message;
import android.os.SystemClock;
import android.telephony.AnomalyReporter;
import android.telephony.CarrierRestrictionRules;
import android.telephony.LinkCapacityEstimate;
import android.telephony.ModemActivityInfo;
import android.telephony.NeighboringCellInfo;
import android.telephony.NetworkScanRequest;
import android.telephony.RadioAccessFamily;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.data.DataCallResponse;
import android.telephony.data.NetworkSlicingConfig;
import android.text.TextUtils;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import com.android.internal.telephony.uicc.AdnCapacity;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccSlotPortMapping;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

public class RadioResponse extends IRadioResponse.Stub {
    public RIL mRil;

    public void sendOemRilRequestRawResponse(RadioResponseInfo radioResponseInfo, ArrayList<Byte> arrayList) {
    }

    public RadioResponse(RIL ril) {
        this.mRil = ril;
    }

    public static void sendMessageResponse(Message message, Object obj) {
        if (message != null) {
            AsyncResult.forMessage(message, obj, (Throwable) null);
            message.sendToTarget();
        }
    }

    public void acknowledgeRequest(int i) {
        this.mRil.processRequestAck(i);
    }

    public void getIccCardStatusResponse(RadioResponseInfo radioResponseInfo, CardStatus cardStatus) {
        responseIccCardStatus(radioResponseInfo, cardStatus);
    }

    public void getIccCardStatusResponse_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.CardStatus cardStatus) {
        responseIccCardStatus_1_2(radioResponseInfo, cardStatus);
    }

    public void getIccCardStatusResponse_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.CardStatus cardStatus) {
        responseIccCardStatus_1_4(radioResponseInfo, cardStatus);
    }

    public void getIccCardStatusResponse_1_5(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_5.CardStatus cardStatus) {
        responseIccCardStatus_1_5(radioResponseInfo, cardStatus);
    }

    public void supplyIccPinForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void supplyIccPukForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void supplyIccPin2ForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void supplyIccPuk2ForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void changeIccPinForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void changeIccPin2ForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void supplyNetworkDepersonalizationResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void supplySimDepersonalizationResponse(RadioResponseInfo radioResponseInfo, int i, int i2) {
        responseInts(radioResponseInfo, i, i2);
    }

    public void getCurrentCallsResponse(RadioResponseInfo radioResponseInfo, ArrayList<Call> arrayList) {
        responseCurrentCalls(radioResponseInfo, arrayList);
    }

    public void getCurrentCallsResponse_1_2(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_2.Call> arrayList) {
        responseCurrentCalls_1_2(radioResponseInfo, arrayList);
    }

    public void getCurrentCallsResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_6.Call> arrayList) {
        responseCurrentCalls_1_6(radioResponseInfo, arrayList);
    }

    public void dialResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getIMSIForAppResponse(RadioResponseInfo radioResponseInfo, String str) {
        responseString(radioResponseInfo, str);
    }

    public void hangupConnectionResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void hangupWaitingOrBackgroundResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void hangupForegroundResumeBackgroundResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void switchWaitingOrHoldingAndActiveResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void conferenceResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void rejectCallResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getLastCallFailCauseResponse(RadioResponseInfo radioResponseInfo, LastCallFailCauseInfo lastCallFailCauseInfo) {
        responseLastCallFailCauseInfo(radioResponseInfo, lastCallFailCauseInfo);
    }

    public void getSignalStrengthResponse(RadioResponseInfo radioResponseInfo, SignalStrength signalStrength) {
        responseSignalStrength(radioResponseInfo, signalStrength);
    }

    public void getSignalStrengthResponse_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.SignalStrength signalStrength) {
        responseSignalStrength_1_2(radioResponseInfo, signalStrength);
    }

    public void getSignalStrengthResponse_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.SignalStrength signalStrength) {
        responseSignalStrength_1_4(radioResponseInfo, signalStrength);
    }

    public void getSignalStrengthResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_6.SignalStrength signalStrength) {
        responseSignalStrength_1_6(radioResponseInfo, signalStrength);
    }

    public void getVoiceRegistrationStateResponse(RadioResponseInfo radioResponseInfo, VoiceRegStateResult voiceRegStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, voiceRegStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) voiceRegStateResult);
        }
    }

    public void getVoiceRegistrationStateResponse_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.VoiceRegStateResult voiceRegStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, voiceRegStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) voiceRegStateResult);
        }
    }

    public void getVoiceRegistrationStateResponse_1_5(RadioResponseInfo radioResponseInfo, RegStateResult regStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int i = radioResponseInfo.error;
            if (i == 6) {
                this.mRil.mRilHandler.post(new RadioResponse$$ExternalSyntheticLambda2(this, processResponse.getRequest(), processResponse.getResult()));
                this.mRil.processResponseFallback(processResponse, radioResponseInfo, regStateResult);
                return;
            }
            if (i == 0) {
                sendMessageResponse(processResponse.mResult, regStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) regStateResult);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$getVoiceRegistrationStateResponse_1_5$0(int i, Message message) {
        this.mRil.setCompatVersion(i, RIL.RADIO_HAL_VERSION_1_4);
        this.mRil.getVoiceRegistrationState(message);
    }

    public void getVoiceRegistrationStateResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_6.RegStateResult regStateResult) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, regStateResult);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, regStateResult);
        }
    }

    public void getDataRegistrationStateResponse(RadioResponseInfo radioResponseInfo, DataRegStateResult dataRegStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, dataRegStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) dataRegStateResult);
        }
    }

    public void getDataRegistrationStateResponse_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.DataRegStateResult dataRegStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, dataRegStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) dataRegStateResult);
        }
    }

    public void getDataRegistrationStateResponse_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.DataRegStateResult dataRegStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, dataRegStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) dataRegStateResult);
        }
    }

    public void getDataRegistrationStateResponse_1_5(RadioResponseInfo radioResponseInfo, RegStateResult regStateResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int i = radioResponseInfo.error;
            if (i == 6) {
                this.mRil.mRilHandler.post(new RadioResponse$$ExternalSyntheticLambda1(this, processResponse.getRequest(), processResponse.getResult()));
                this.mRil.processResponseFallback(processResponse, radioResponseInfo, regStateResult);
                return;
            }
            if (i == 0) {
                sendMessageResponse(processResponse.mResult, regStateResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) regStateResult);
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$getDataRegistrationStateResponse_1_5$1(int i, Message message) {
        this.mRil.setCompatVersion(i, RIL.RADIO_HAL_VERSION_1_4);
        this.mRil.getDataRegistrationState(message);
    }

    public void getDataRegistrationStateResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_6.RegStateResult regStateResult) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, regStateResult);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, regStateResult);
        }
    }

    public void getOperatorResponse(RadioResponseInfo radioResponseInfo, String str, String str2, String str3) {
        responseStrings(radioResponseInfo, str, str2, str3);
    }

    public void setRadioPowerResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
        this.mRil.mLastRadioPowerResult = radioResponseInfo.error;
    }

    public void sendDtmfResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void sendSmsResponse(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms(radioResponseInfo, sendSmsResult);
    }

    public void sendSmsResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms_1_6(radioResponseInfo, sendSmsResult);
    }

    public void sendSMSExpectMoreResponse(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms(radioResponseInfo, sendSmsResult);
    }

    public void sendSmsExpectMoreResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms_1_6(radioResponseInfo, sendSmsResult);
    }

    public void setupDataCallResponse(RadioResponseInfo radioResponseInfo, SetupDataCallResult setupDataCallResult) {
        responseSetupDataCall(radioResponseInfo, setupDataCallResult);
    }

    public void setupDataCallResponse_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.SetupDataCallResult setupDataCallResult) {
        responseSetupDataCall(radioResponseInfo, setupDataCallResult);
    }

    public void setupDataCallResponse_1_5(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_5.SetupDataCallResult setupDataCallResult) {
        responseSetupDataCall(radioResponseInfo, setupDataCallResult);
    }

    public void setupDataCallResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_6.SetupDataCallResult setupDataCallResult) {
        responseSetupDataCall_1_6(radioResponseInfo, setupDataCallResult);
    }

    public void getDataCallListResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_6.SetupDataCallResult> arrayList) {
        responseDataCallList(radioResponseInfo, (List<? extends Object>) arrayList);
    }

    public void setSimCardPowerResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void setAllowedNetworkTypesBitmapResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void getAllowedNetworkTypesBitmapResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, int i) {
        int convertHalNetworkTypeBitMask = RILUtils.convertHalNetworkTypeBitMask(i);
        this.mRil.mAllowedNetworkTypesBitmask = convertHalNetworkTypeBitMask;
        responseInts_1_6(radioResponseInfo, convertHalNetworkTypeBitMask);
    }

    public void iccIOForAppResponse(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        responseIccIo(radioResponseInfo, iccIoResult);
    }

    public void sendUssdResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void cancelPendingUssdResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getClirResponse(RadioResponseInfo radioResponseInfo, int i, int i2) {
        responseInts(radioResponseInfo, i, i2);
    }

    public void setClirResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCallForwardStatusResponse(RadioResponseInfo radioResponseInfo, ArrayList<CallForwardInfo> arrayList) {
        responseCallForwardInfo(radioResponseInfo, arrayList);
    }

    public void setCallForwardResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCallWaitingResponse(RadioResponseInfo radioResponseInfo, boolean z, int i) {
        responseInts(radioResponseInfo, z, i);
    }

    public void setCallWaitingResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void acknowledgeLastIncomingGsmSmsResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void acceptCallResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void deactivateDataCallResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getFacilityLockForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void setFacilityLockForAppResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void setBarringPasswordResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getNetworkSelectionModeResponse(RadioResponseInfo radioResponseInfo, boolean z) {
        responseInts(radioResponseInfo, z);
    }

    public void setNetworkSelectionModeAutomaticResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setNetworkSelectionModeManualResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setNetworkSelectionModeManualResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getAvailableNetworksResponse(RadioResponseInfo radioResponseInfo, ArrayList<OperatorInfo> arrayList) {
        responseOperatorInfos(radioResponseInfo, arrayList);
    }

    public void startNetworkScanResponse(RadioResponseInfo radioResponseInfo) {
        responseScanStatus(radioResponseInfo, (HalVersion) null);
    }

    public void startNetworkScanResponse_1_4(RadioResponseInfo radioResponseInfo) {
        responseScanStatus(radioResponseInfo, (HalVersion) null);
    }

    public void startNetworkScanResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseScanStatus(radioResponseInfo, RIL.RADIO_HAL_VERSION_1_4);
    }

    public void stopNetworkScanResponse(RadioResponseInfo radioResponseInfo) {
        responseScanStatus(radioResponseInfo, (HalVersion) null);
    }

    public void startDtmfResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void stopDtmfResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getBasebandVersionResponse(RadioResponseInfo radioResponseInfo, String str) {
        responseString(radioResponseInfo, str);
    }

    public void separateConnectionResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setMuteResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getMuteResponse(RadioResponseInfo radioResponseInfo, boolean z) {
        responseInts(radioResponseInfo, z);
    }

    public void getClipResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void getDataCallListResponse(RadioResponseInfo radioResponseInfo, ArrayList<SetupDataCallResult> arrayList) {
        responseDataCallList(radioResponseInfo, (List<? extends Object>) arrayList);
    }

    public void getDataCallListResponse_1_4(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_4.SetupDataCallResult> arrayList) {
        responseDataCallList(radioResponseInfo, (List<? extends Object>) arrayList);
    }

    public void getDataCallListResponse_1_5(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_5.SetupDataCallResult> arrayList) {
        responseDataCallList(radioResponseInfo, (List<? extends Object>) arrayList);
    }

    public void setSuppServiceNotificationsResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void writeSmsToSimResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void deleteSmsOnSimResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setBandModeResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getAvailableBandModesResponse(RadioResponseInfo radioResponseInfo, ArrayList<Integer> arrayList) {
        responseIntArrayList(radioResponseInfo, arrayList);
    }

    public void sendEnvelopeResponse(RadioResponseInfo radioResponseInfo, String str) {
        responseString(radioResponseInfo, str);
    }

    public void sendTerminalResponseToSimResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void handleStkCallSetupRequestFromSimResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void explicitCallTransferResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setPreferredNetworkTypeResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setPreferredNetworkTypeBitmapResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getPreferredNetworkTypeResponse(RadioResponseInfo radioResponseInfo, int i) {
        this.mRil.mAllowedNetworkTypesBitmask = RadioAccessFamily.getRafFromNetworkType(i);
        responseInts(radioResponseInfo, RadioAccessFamily.getRafFromNetworkType(i));
    }

    public void getPreferredNetworkTypeBitmapResponse(RadioResponseInfo radioResponseInfo, int i) {
        int convertHalNetworkTypeBitMask = RILUtils.convertHalNetworkTypeBitMask(i);
        this.mRil.mAllowedNetworkTypesBitmask = convertHalNetworkTypeBitMask;
        responseInts(radioResponseInfo, convertHalNetworkTypeBitMask);
    }

    public void getNeighboringCidsResponse(RadioResponseInfo radioResponseInfo, ArrayList<NeighboringCell> arrayList) {
        responseCellList(radioResponseInfo, arrayList);
    }

    public void setLocationUpdatesResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setCdmaSubscriptionSourceResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setCdmaRoamingPreferenceResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCdmaRoamingPreferenceResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void setTTYModeResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getTTYModeResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void setPreferredVoicePrivacyResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getPreferredVoicePrivacyResponse(RadioResponseInfo radioResponseInfo, boolean z) {
        responseInts(radioResponseInfo, z);
    }

    public void sendCDMAFeatureCodeResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void sendBurstDtmfResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void sendCdmaSmsResponse(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms(radioResponseInfo, sendSmsResult);
    }

    public void sendCdmaSmsResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms_1_6(radioResponseInfo, sendSmsResult);
    }

    public void sendCdmaSmsExpectMoreResponse(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms(radioResponseInfo, sendSmsResult);
    }

    public void sendCdmaSmsExpectMoreResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms_1_6(radioResponseInfo, sendSmsResult);
    }

    public void setDataThrottlingResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void acknowledgeLastIncomingCdmaSmsResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getGsmBroadcastConfigResponse(RadioResponseInfo radioResponseInfo, ArrayList<GsmBroadcastSmsConfigInfo> arrayList) {
        responseGmsBroadcastConfig(radioResponseInfo, arrayList);
    }

    public void setGsmBroadcastConfigResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setGsmBroadcastActivationResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCdmaBroadcastConfigResponse(RadioResponseInfo radioResponseInfo, ArrayList<CdmaBroadcastSmsConfigInfo> arrayList) {
        responseCdmaBroadcastConfig(radioResponseInfo, arrayList);
    }

    public void setCdmaBroadcastConfigResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setCdmaBroadcastActivationResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCDMASubscriptionResponse(RadioResponseInfo radioResponseInfo, String str, String str2, String str3, String str4, String str5) {
        responseStrings(radioResponseInfo, str, str2, str3, str4, str5);
    }

    public void writeSmsToRuimResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void deleteSmsOnRuimResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getDeviceIdentityResponse(RadioResponseInfo radioResponseInfo, String str, String str2, String str3, String str4) {
        responseStrings(radioResponseInfo, str, str2, str3, str4);
    }

    public void exitEmergencyCallbackModeResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getSmscAddressResponse(RadioResponseInfo radioResponseInfo, String str) {
        responseString(radioResponseInfo, str);
    }

    public void setSmscAddressResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void reportSmsMemoryStatusResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void reportStkServiceIsRunningResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getCdmaSubscriptionSourceResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void requestIsimAuthenticationResponse(RadioResponseInfo radioResponseInfo, String str) {
        throw new RuntimeException("Inexplicable response received for requestIsimAuthentication");
    }

    public void acknowledgeIncomingGsmSmsWithPduResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void sendEnvelopeWithStatusResponse(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        responseIccIo(radioResponseInfo, iccIoResult);
    }

    public void getVoiceRadioTechnologyResponse(RadioResponseInfo radioResponseInfo, int i) {
        responseInts(radioResponseInfo, i);
    }

    public void getCellInfoListResponse(RadioResponseInfo radioResponseInfo, ArrayList<CellInfo> arrayList) {
        responseCellInfoList(radioResponseInfo, arrayList);
    }

    public void getCellInfoListResponse_1_2(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_2.CellInfo> arrayList) {
        responseCellInfoList(radioResponseInfo, arrayList);
    }

    public void getCellInfoListResponse_1_4(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_4.CellInfo> arrayList) {
        responseCellInfoList(radioResponseInfo, arrayList);
    }

    public void getCellInfoListResponse_1_5(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_5.CellInfo> arrayList) {
        responseCellInfoList(radioResponseInfo, arrayList);
    }

    public void getCellInfoListResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_6.CellInfo> arrayList) {
        responseCellInfoList_1_6(radioResponseInfo, arrayList);
    }

    public void setCellInfoListRateResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setInitialAttachApnResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setInitialAttachApnResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getImsRegistrationStateResponse(RadioResponseInfo radioResponseInfo, boolean z, int i) {
        int i2 = 2;
        int[] iArr = new int[2];
        iArr[0] = z;
        if (i == 0) {
            i2 = 1;
        }
        iArr[1] = i2;
        responseInts(radioResponseInfo, iArr);
    }

    public void sendImsSmsResponse(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        responseSms(radioResponseInfo, sendSmsResult);
    }

    public void iccTransmitApduBasicChannelResponse(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        responseIccIo(radioResponseInfo, iccIoResult);
    }

    public void iccOpenLogicalChannelResponse(RadioResponseInfo radioResponseInfo, int i, ArrayList<Byte> arrayList) {
        ArrayList arrayList2 = new ArrayList();
        arrayList2.add(Integer.valueOf(i));
        for (int i2 = 0; i2 < arrayList.size(); i2++) {
            arrayList2.add(Integer.valueOf(arrayList.get(i2).byteValue()));
        }
        responseIntArrayList(radioResponseInfo, arrayList2);
    }

    public void iccCloseLogicalChannelResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void iccTransmitApduLogicalChannelResponse(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        responseIccIo(radioResponseInfo, iccIoResult);
    }

    public void nvReadItemResponse(RadioResponseInfo radioResponseInfo, String str) {
        responseString(radioResponseInfo, str);
    }

    public void nvWriteItemResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void nvWriteCdmaPrlResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void nvResetConfigResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setUiccSubscriptionResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setDataAllowedResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getHardwareConfigResponse(RadioResponseInfo radioResponseInfo, ArrayList<HardwareConfig> arrayList) {
        responseHardwareConfig(radioResponseInfo, arrayList);
    }

    public void requestIccSimAuthenticationResponse(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            com.android.internal.telephony.uicc.IccIoResult iccIoResult2 = new com.android.internal.telephony.uicc.IccIoResult(iccIoResult.sw1, iccIoResult.sw2, TextUtils.isEmpty(iccIoResult.simResponse) ? null : iccIoResult.simResponse.getBytes());
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, iccIoResult2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) iccIoResult2);
        }
    }

    public void setDataProfileResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setDataProfileResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void requestShutdownResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getRadioCapabilityResponse(RadioResponseInfo radioResponseInfo, RadioCapability radioCapability) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            RadioCapability convertHalRadioCapability = RILUtils.convertHalRadioCapability(radioCapability, this.mRil);
            int i = radioResponseInfo.error;
            if (i == 6 || i == 2) {
                convertHalRadioCapability = this.mRil.makeStaticRadioCapability();
                radioResponseInfo.error = 0;
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalRadioCapability);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalRadioCapability);
        }
    }

    public void setRadioCapabilityResponse(RadioResponseInfo radioResponseInfo, RadioCapability radioCapability) {
        responseRadioCapability(radioResponseInfo, radioCapability);
    }

    public void startLceServiceResponse(RadioResponseInfo radioResponseInfo, LceStatusInfo lceStatusInfo) {
        responseLceStatus(radioResponseInfo, lceStatusInfo);
    }

    public void stopLceServiceResponse(RadioResponseInfo radioResponseInfo, LceStatusInfo lceStatusInfo) {
        responseLceStatus(radioResponseInfo, lceStatusInfo);
    }

    public void pullLceDataResponse(RadioResponseInfo radioResponseInfo, LceDataInfo lceDataInfo) {
        responseLceData(radioResponseInfo, lceDataInfo);
    }

    public void getModemActivityInfoResponse(RadioResponseInfo radioResponseInfo, ActivityStatsInfo activityStatsInfo) {
        responseActivityData(radioResponseInfo, activityStatsInfo);
    }

    public void isNrDualConnectivityEnabledResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, boolean z) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, Boolean.valueOf(z));
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, Boolean.valueOf(z));
        }
    }

    public void setNrDualConnectivityStateResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void setAllowedCarriersResponse(RadioResponseInfo radioResponseInfo, int i) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            RIL ril = this.mRil;
            ril.riljLog("setAllowedCarriersResponse - error = " + radioResponseInfo.error);
            int i2 = radioResponseInfo.error;
            int i3 = 0;
            if (i2 == 0) {
                sendMessageResponse(processResponse.mResult, 0);
            } else if (i2 == 6) {
                radioResponseInfo.error = 0;
                i3 = 1;
                sendMessageResponse(processResponse.mResult, 1);
            } else {
                i3 = 2;
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) Integer.valueOf(i3));
        }
    }

    public void setAllowedCarriersResponse_1_4(RadioResponseInfo radioResponseInfo) {
        int i;
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            RIL ril = this.mRil;
            ril.riljLog("setAllowedCarriersResponse_1_4 - error = " + radioResponseInfo.error);
            if (radioResponseInfo.error == 0) {
                i = 0;
                sendMessageResponse(processResponse.mResult, 0);
            } else {
                i = 2;
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) Integer.valueOf(i));
        }
    }

    public void getAllowedCarriersResponse(RadioResponseInfo radioResponseInfo, boolean z, CarrierRestrictions carrierRestrictions) {
        CarrierRestrictionsWithPriority carrierRestrictionsWithPriority = new CarrierRestrictionsWithPriority();
        carrierRestrictionsWithPriority.allowedCarriers = carrierRestrictions.allowedCarriers;
        carrierRestrictionsWithPriority.excludedCarriers = carrierRestrictions.excludedCarriers;
        carrierRestrictionsWithPriority.allowedCarriersPrioritized = true;
        responseCarrierRestrictions(radioResponseInfo, z, carrierRestrictionsWithPriority, 0);
    }

    public void getAllowedCarriersResponse_1_4(RadioResponseInfo radioResponseInfo, CarrierRestrictionsWithPriority carrierRestrictionsWithPriority, int i) {
        responseCarrierRestrictions(radioResponseInfo, false, carrierRestrictionsWithPriority, i);
    }

    public void sendDeviceStateResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setCarrierInfoForImsiEncryptionResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setIndicationFilterResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setIndicationFilterResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setSimCardPowerResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setSignalStrengthReportingCriteriaResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setSignalStrengthReportingCriteriaResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setLinkCapacityReportingCriteriaResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setLinkCapacityReportingCriteriaResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void setSimCardPowerResponse_1_1(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void startKeepaliveResponse(RadioResponseInfo radioResponseInfo, KeepaliveStatus keepaliveStatus) {
        com.android.internal.telephony.data.KeepaliveStatus keepaliveStatus2;
        com.android.internal.telephony.data.KeepaliveStatus keepaliveStatus3;
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            com.android.internal.telephony.data.KeepaliveStatus keepaliveStatus4 = null;
            try {
                int i = radioResponseInfo.error;
                if (i == 0) {
                    int convertHalKeepaliveStatusCode = RILUtils.convertHalKeepaliveStatusCode(keepaliveStatus.code);
                    if (convertHalKeepaliveStatusCode < 0) {
                        keepaliveStatus2 = new com.android.internal.telephony.data.KeepaliveStatus(1);
                    } else {
                        keepaliveStatus2 = new com.android.internal.telephony.data.KeepaliveStatus(keepaliveStatus.sessionHandle, convertHalKeepaliveStatusCode);
                    }
                    sendMessageResponse(processResponse.mResult, keepaliveStatus2);
                    keepaliveStatus3 = keepaliveStatus2;
                } else if (i == 6) {
                    keepaliveStatus3 = new com.android.internal.telephony.data.KeepaliveStatus(1);
                } else if (i != 42) {
                    keepaliveStatus3 = new com.android.internal.telephony.data.KeepaliveStatus(3);
                } else {
                    keepaliveStatus3 = new com.android.internal.telephony.data.KeepaliveStatus(2);
                }
            } finally {
                this.mRil.processResponseDone(processResponse, radioResponseInfo, keepaliveStatus4);
            }
        }
    }

    public void stopKeepaliveResponse(RadioResponseInfo radioResponseInfo) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            try {
                if (radioResponseInfo.error == 0) {
                    sendMessageResponse(processResponse.mResult, (Object) null);
                }
            } finally {
                this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) null);
            }
        }
    }

    public void getSimPhonebookRecordsResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void getSimPhonebookCapacityResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, PhonebookCapacity phonebookCapacity) {
        responseAdnCapacity(radioResponseInfo, RILUtils.convertHalPhonebookCapacity(phonebookCapacity));
    }

    public void updateSimPhonebookRecordsResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, int i) {
        responseInts_1_6(radioResponseInfo, i);
    }

    private void responseAdnCapacity(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, AdnCapacity adnCapacity) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, adnCapacity);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, adnCapacity);
        }
    }

    private void responseIccCardStatus(RadioResponseInfo radioResponseInfo, CardStatus cardStatus) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            IccCardStatus convertHalCardStatus = RILUtils.convertHalCardStatus((Object) cardStatus);
            RIL ril = this.mRil;
            ril.riljLog("responseIccCardStatus: from HIDL: " + convertHalCardStatus);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalCardStatus);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalCardStatus);
        }
    }

    private void responseIccCardStatus_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.CardStatus cardStatus) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            IccCardStatus convertHalCardStatus = RILUtils.convertHalCardStatus((Object) cardStatus.base);
            IccSlotPortMapping iccSlotPortMapping = new IccSlotPortMapping();
            iccSlotPortMapping.mPhysicalSlotIndex = cardStatus.physicalSlotId;
            convertHalCardStatus.mSlotPortMapping = iccSlotPortMapping;
            convertHalCardStatus.atr = cardStatus.atr;
            convertHalCardStatus.iccid = cardStatus.iccid;
            RIL ril = this.mRil;
            ril.riljLog("responseIccCardStatus: from HIDL: " + convertHalCardStatus);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalCardStatus);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalCardStatus);
        }
    }

    private void responseIccCardStatus_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.CardStatus cardStatus) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            IccCardStatus convertHalCardStatus = RILUtils.convertHalCardStatus((Object) cardStatus.base.base);
            IccSlotPortMapping iccSlotPortMapping = new IccSlotPortMapping();
            android.hardware.radio.V1_2.CardStatus cardStatus2 = cardStatus.base;
            iccSlotPortMapping.mPhysicalSlotIndex = cardStatus2.physicalSlotId;
            convertHalCardStatus.mSlotPortMapping = iccSlotPortMapping;
            convertHalCardStatus.atr = cardStatus2.atr;
            convertHalCardStatus.iccid = cardStatus2.iccid;
            convertHalCardStatus.eid = cardStatus.eid;
            RIL ril = this.mRil;
            ril.riljLog("responseIccCardStatus: from HIDL: " + convertHalCardStatus);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalCardStatus);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalCardStatus);
        }
    }

    private void responseIccCardStatus_1_5(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_5.CardStatus cardStatus) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            IccCardStatus convertHalCardStatus = RILUtils.convertHalCardStatus((Object) cardStatus);
            RIL ril = this.mRil;
            ril.riljLog("responseIccCardStatus: from HIDL: " + convertHalCardStatus);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalCardStatus);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalCardStatus);
        }
    }

    public void emergencyDialResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void responseInts(RadioResponseInfo radioResponseInfo, int... iArr) {
        ArrayList arrayList = new ArrayList();
        for (int valueOf : iArr) {
            arrayList.add(Integer.valueOf(valueOf));
        }
        responseIntArrayList(radioResponseInfo, arrayList);
    }

    public void responseInts_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, int... iArr) {
        ArrayList arrayList = new ArrayList();
        for (int valueOf : iArr) {
            arrayList.add(Integer.valueOf(valueOf));
        }
        responseIntArrayList_1_6(radioResponseInfo, arrayList);
    }

    public static void responseInts(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo, int... iArr) {
        ArrayList arrayList = new ArrayList();
        for (int valueOf : iArr) {
            arrayList.add(Integer.valueOf(valueOf));
        }
        responseIntArrayList(i, ril, radioResponseInfo, arrayList);
    }

    public void responseIntArrayList(RadioResponseInfo radioResponseInfo, ArrayList<Integer> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int[] iArr = new int[arrayList.size()];
            for (int i = 0; i < arrayList.size(); i++) {
                iArr[i] = arrayList.get(i).intValue();
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, iArr);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) iArr);
        }
    }

    public void responseIntArrayList_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<Integer> arrayList) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            int[] iArr = new int[arrayList.size()];
            for (int i = 0; i < arrayList.size(); i++) {
                iArr[i] = arrayList.get(i).intValue();
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, iArr);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, iArr);
        }
    }

    public static void responseIntArrayList(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo, ArrayList<Integer> arrayList) {
        RILRequest processResponse = ril.processResponse(i, radioResponseInfo);
        if (processResponse != null) {
            int[] iArr = new int[arrayList.size()];
            for (int i2 = 0; i2 < arrayList.size(); i2++) {
                iArr[i2] = arrayList.get(i2).intValue();
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, iArr);
            }
            ril.processResponseDone(processResponse, radioResponseInfo, (Object) iArr);
        }
    }

    private void responseCurrentCalls(RadioResponseInfo radioResponseInfo, ArrayList<Call> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int size = arrayList.size();
            ArrayList arrayList2 = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                DriverCall convertToDriverCall = RILUtils.convertToDriverCall((Object) arrayList.get(i));
                arrayList2.add(convertToDriverCall);
                if (convertToDriverCall.isVoicePrivacy) {
                    this.mRil.mVoicePrivacyOnRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is enabled");
                } else {
                    this.mRil.mVoicePrivacyOffRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is disabled");
                }
            }
            Collections.sort(arrayList2);
            if (size == 0 && this.mRil.mTestingEmergencyCall.getAndSet(false)) {
                RIL ril = this.mRil;
                if (ril.mEmergencyCallbackModeRegistrant != null) {
                    ril.riljLog("responseCurrentCalls: call ended, testing emergency call, notify ECM Registrants");
                    this.mRil.mEmergencyCallbackModeRegistrant.notifyRegistrant();
                }
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList2);
        }
    }

    private void responseCurrentCalls_1_2(RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_2.Call> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int size = arrayList.size();
            ArrayList arrayList2 = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                DriverCall convertToDriverCall = RILUtils.convertToDriverCall((Object) arrayList.get(i));
                arrayList2.add(convertToDriverCall);
                if (convertToDriverCall.isVoicePrivacy) {
                    this.mRil.mVoicePrivacyOnRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is enabled");
                } else {
                    this.mRil.mVoicePrivacyOffRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is disabled");
                }
            }
            Collections.sort(arrayList2);
            if (size == 0 && this.mRil.mTestingEmergencyCall.getAndSet(false)) {
                RIL ril = this.mRil;
                if (ril.mEmergencyCallbackModeRegistrant != null) {
                    ril.riljLog("responseCurrentCalls: call ended, testing emergency call, notify ECM Registrants");
                    this.mRil.mEmergencyCallbackModeRegistrant.notifyRegistrant();
                }
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList2);
        }
    }

    private void responseCurrentCalls_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<android.hardware.radio.V1_6.Call> arrayList) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            int size = arrayList.size();
            ArrayList arrayList2 = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                DriverCall convertToDriverCall = RILUtils.convertToDriverCall((Object) arrayList.get(i));
                arrayList2.add(convertToDriverCall);
                if (convertToDriverCall.isVoicePrivacy) {
                    this.mRil.mVoicePrivacyOnRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is enabled");
                } else {
                    this.mRil.mVoicePrivacyOffRegistrants.notifyRegistrants();
                    this.mRil.riljLog("InCall VoicePrivacy is disabled");
                }
            }
            Collections.sort(arrayList2);
            if (size == 0 && this.mRil.mTestingEmergencyCall.getAndSet(false)) {
                RIL ril = this.mRil;
                if (ril.mEmergencyCallbackModeRegistrant != null) {
                    ril.riljLog("responseCurrentCalls: call ended, testing emergency call, notify ECM Registrants");
                    this.mRil.mEmergencyCallbackModeRegistrant.notifyRegistrant();
                }
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, arrayList2);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, arrayList2);
        }
    }

    public void responseVoid(RadioResponseInfo radioResponseInfo) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, (Object) null);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) null);
        }
    }

    public void responseVoid_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, (Object) null);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, (Object) null);
        }
    }

    public static void responseVoid(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo) {
        RILRequest processResponse = ril.processResponse(i, radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, (Object) null);
            }
            ril.processResponseDone(processResponse, radioResponseInfo, (Object) null);
        }
    }

    public void responseString(RadioResponseInfo radioResponseInfo, String str) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, str);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) str);
        }
    }

    public static void responseString(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo, String str) {
        RILRequest processResponse = ril.processResponse(i, radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, str);
            }
            ril.processResponseDone(processResponse, radioResponseInfo, (Object) str);
        }
    }

    public void responseStrings(RadioResponseInfo radioResponseInfo, String... strArr) {
        ArrayList arrayList = new ArrayList();
        for (String add : strArr) {
            arrayList.add(add);
        }
        responseStringArrayList(this.mRil, radioResponseInfo, arrayList);
    }

    public static void responseStrings(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo, String... strArr) {
        ArrayList arrayList = new ArrayList();
        for (String add : strArr) {
            arrayList.add(add);
        }
        responseStringArrayList(i, ril, radioResponseInfo, arrayList);
    }

    public static void responseStringArrayList(RIL ril, RadioResponseInfo radioResponseInfo, ArrayList<String> arrayList) {
        RILRequest processResponse = ril.processResponse(radioResponseInfo);
        if (processResponse != null) {
            String[] strArr = new String[arrayList.size()];
            for (int i = 0; i < arrayList.size(); i++) {
                strArr[i] = arrayList.get(i);
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, strArr);
            }
            ril.processResponseDone(processResponse, radioResponseInfo, (Object) strArr);
        }
    }

    public static void responseStringArrayList(int i, RIL ril, android.hardware.radio.RadioResponseInfo radioResponseInfo, ArrayList<String> arrayList) {
        RILRequest processResponse = ril.processResponse(i, radioResponseInfo);
        if (processResponse != null) {
            String[] strArr = new String[arrayList.size()];
            for (int i2 = 0; i2 < arrayList.size(); i2++) {
                strArr[i2] = arrayList.get(i2);
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, strArr);
            }
            ril.processResponseDone(processResponse, radioResponseInfo, (Object) strArr);
        }
    }

    private void responseLastCallFailCauseInfo(RadioResponseInfo radioResponseInfo, LastCallFailCauseInfo lastCallFailCauseInfo) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            LastCallFailCause lastCallFailCause = new LastCallFailCause();
            lastCallFailCause.causeCode = lastCallFailCauseInfo.causeCode;
            lastCallFailCause.vendorCause = lastCallFailCauseInfo.vendorCause;
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, lastCallFailCause);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) lastCallFailCause);
        }
    }

    private void responseSignalStrength(RadioResponseInfo radioResponseInfo, SignalStrength signalStrength) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            android.telephony.SignalStrength convertHalSignalStrength = RILUtils.convertHalSignalStrength((Object) signalStrength);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalSignalStrength);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalSignalStrength);
        }
    }

    private void responseSignalStrength_1_2(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_2.SignalStrength signalStrength) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            android.telephony.SignalStrength convertHalSignalStrength = RILUtils.convertHalSignalStrength((Object) signalStrength);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalSignalStrength);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalSignalStrength);
        }
    }

    private void responseSignalStrength_1_4(RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_4.SignalStrength signalStrength) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            android.telephony.SignalStrength convertHalSignalStrength = RILUtils.convertHalSignalStrength((Object) signalStrength);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalSignalStrength);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalSignalStrength);
        }
    }

    private void responseSignalStrength_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, android.hardware.radio.V1_6.SignalStrength signalStrength) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            android.telephony.SignalStrength convertHalSignalStrength = RILUtils.convertHalSignalStrength((Object) signalStrength);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, convertHalSignalStrength);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, convertHalSignalStrength);
        }
    }

    private void responseSms(RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            SmsResponse smsResponse = new SmsResponse(sendSmsResult.messageRef, sendSmsResult.ackPDU, sendSmsResult.errorCode, RIL.getOutgoingSmsMessageId(processResponse.mResult));
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, smsResponse);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) smsResponse);
        }
    }

    private void responseSms_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SendSmsResult sendSmsResult) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            SmsResponse smsResponse = new SmsResponse(sendSmsResult.messageRef, sendSmsResult.ackPDU, sendSmsResult.errorCode, RIL.getOutgoingSmsMessageId(processResponse_1_6.mResult));
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, smsResponse);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, smsResponse);
        }
    }

    private void responseSetupDataCall(RadioResponseInfo radioResponseInfo, Object obj) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            DataCallResponse convertHalDataCallResult = RILUtils.convertHalDataCallResult(obj);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalDataCallResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalDataCallResult);
        }
    }

    private void responseSetupDataCall_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, Object obj) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            DataCallResponse convertHalDataCallResult = RILUtils.convertHalDataCallResult(obj);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, convertHalDataCallResult);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, convertHalDataCallResult);
        }
    }

    private void responseIccIo(RadioResponseInfo radioResponseInfo, IccIoResult iccIoResult) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            com.android.internal.telephony.uicc.IccIoResult iccIoResult2 = new com.android.internal.telephony.uicc.IccIoResult(iccIoResult.sw1, iccIoResult.sw2, iccIoResult.simResponse);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, iccIoResult2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) iccIoResult2);
        }
    }

    private void responseCallForwardInfo(RadioResponseInfo radioResponseInfo, ArrayList<CallForwardInfo> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            CallForwardInfo[] callForwardInfoArr = new CallForwardInfo[arrayList.size()];
            for (int i = 0; i < arrayList.size(); i++) {
                CallForwardInfo callForwardInfo = new CallForwardInfo();
                callForwardInfoArr[i] = callForwardInfo;
                callForwardInfo.status = arrayList.get(i).status;
                callForwardInfoArr[i].reason = arrayList.get(i).reason;
                callForwardInfoArr[i].serviceClass = arrayList.get(i).serviceClass;
                callForwardInfoArr[i].toa = arrayList.get(i).toa;
                callForwardInfoArr[i].number = arrayList.get(i).number;
                callForwardInfoArr[i].timeSeconds = arrayList.get(i).timeSeconds;
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, callForwardInfoArr);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) callForwardInfoArr);
        }
    }

    private void responseOperatorInfos(RadioResponseInfo radioResponseInfo, ArrayList<OperatorInfo> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList arrayList2 = new ArrayList();
            for (int i = 0; i < arrayList.size(); i++) {
                arrayList2.add(new OperatorInfo(arrayList.get(i).alphaLong, arrayList.get(i).alphaShort, arrayList.get(i).operatorNumeric, RILUtils.convertHalOperatorStatus(arrayList.get(i).status)));
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList2);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:6:0x0012, code lost:
        r8 = r0.mArguments;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void responseScanStatus(android.hardware.radio.V1_0.RadioResponseInfo r7, com.android.internal.telephony.HalVersion r8) {
        /*
            r6 = this;
            com.android.internal.telephony.RIL r0 = r6.mRil
            com.android.internal.telephony.RILRequest r0 = r0.processResponse(r7)
            if (r0 != 0) goto L_0x0009
            return
        L_0x0009:
            int r1 = r7.error
            r2 = 6
            r3 = 1
            r4 = 0
            if (r1 != r2) goto L_0x0021
            if (r8 == 0) goto L_0x0021
            java.lang.Object[] r8 = r0.mArguments
            if (r8 == 0) goto L_0x0021
            int r2 = r8.length
            if (r2 <= 0) goto L_0x0021
            r8 = r8[r4]
            boolean r8 = r8 instanceof android.telephony.NetworkScanRequest
            if (r8 == 0) goto L_0x0021
            r8 = r3
            goto L_0x0022
        L_0x0021:
            r8 = r4
        L_0x0022:
            r2 = 0
            if (r8 == 0) goto L_0x0045
            int r8 = r0.getRequest()
            android.os.Message r1 = r0.getResult()
            java.lang.Object[] r3 = r0.mArguments
            r3 = r3[r4]
            android.telephony.NetworkScanRequest r3 = (android.telephony.NetworkScanRequest) r3
            com.android.internal.telephony.RIL r4 = r6.mRil
            com.android.internal.telephony.RIL$RilHandler r4 = r4.mRilHandler
            com.android.internal.telephony.RadioResponse$$ExternalSyntheticLambda0 r5 = new com.android.internal.telephony.RadioResponse$$ExternalSyntheticLambda0
            r5.<init>(r6, r8, r3, r1)
            r4.post(r5)
            com.android.internal.telephony.RIL r6 = r6.mRil
            r6.processResponseFallback(r0, r7, r2)
            return
        L_0x0045:
            if (r1 != 0) goto L_0x0052
            com.android.internal.telephony.NetworkScanResult r8 = new com.android.internal.telephony.NetworkScanResult
            r8.<init>(r3, r4, r2)
            android.os.Message r1 = r0.mResult
            sendMessageResponse(r1, r8)
            r2 = r8
        L_0x0052:
            com.android.internal.telephony.RIL r6 = r6.mRil
            r6.processResponseDone((com.android.internal.telephony.RILRequest) r0, (android.hardware.radio.V1_0.RadioResponseInfo) r7, (java.lang.Object) r2)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RadioResponse.responseScanStatus(android.hardware.radio.V1_0.RadioResponseInfo, com.android.internal.telephony.HalVersion):void");
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$responseScanStatus$2(int i, NetworkScanRequest networkScanRequest, Message message) {
        this.mRil.setCompatVersion(i, RIL.RADIO_HAL_VERSION_1_4);
        this.mRil.startNetworkScan(networkScanRequest, message);
    }

    private void responseDataCallList(RadioResponseInfo radioResponseInfo, List<? extends Object> list) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList<DataCallResponse> convertHalDataCallResultList = RILUtils.convertHalDataCallResultList(list);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalDataCallResultList);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalDataCallResultList);
        }
    }

    private void responseDataCallList(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, List<? extends Object> list) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            ArrayList<DataCallResponse> convertHalDataCallResultList = RILUtils.convertHalDataCallResultList(list);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, convertHalDataCallResultList);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, convertHalDataCallResultList);
        }
    }

    private void responseCellList(RadioResponseInfo radioResponseInfo, ArrayList<NeighboringCell> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList arrayList2 = new ArrayList();
            int dataNetworkType = ((TelephonyManager) this.mRil.mContext.getSystemService("phone")).getDataNetworkType(SubscriptionManager.getSubId(this.mRil.mPhoneId.intValue())[0]);
            if (dataNetworkType != 0) {
                for (int i = 0; i < arrayList.size(); i++) {
                    arrayList2.add(new NeighboringCellInfo(arrayList.get(i).rssi, arrayList.get(i).cid, dataNetworkType));
                }
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList2);
        }
    }

    private void responseGmsBroadcastConfig(RadioResponseInfo radioResponseInfo, ArrayList<GsmBroadcastSmsConfigInfo> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList arrayList2 = new ArrayList();
            for (int i = 0; i < arrayList.size(); i++) {
                arrayList2.add(new SmsBroadcastConfigInfo(arrayList.get(i).fromServiceId, arrayList.get(i).toServiceId, arrayList.get(i).fromCodeScheme, arrayList.get(i).toCodeScheme, arrayList.get(i).selected));
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList2);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList2);
        }
    }

    private void responseCdmaBroadcastConfig(RadioResponseInfo radioResponseInfo, ArrayList<CdmaBroadcastSmsConfigInfo> arrayList) {
        int[] iArr;
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            int size = arrayList.size();
            int i = 0;
            int i2 = 1;
            if (size == 0) {
                iArr = new int[94];
                iArr[0] = 31;
                for (int i3 = 1; i3 < 94; i3 += 3) {
                    iArr[i3 + 0] = i3 / 3;
                    iArr[i3 + 1] = 1;
                    iArr[i3 + 2] = 0;
                }
            } else {
                int[] iArr2 = new int[((size * 3) + 1)];
                iArr2[0] = size;
                while (i < arrayList.size()) {
                    iArr2[i2] = arrayList.get(i).serviceCategory;
                    iArr2[i2 + 1] = arrayList.get(i).language;
                    iArr2[i2 + 2] = arrayList.get(i).selected;
                    i++;
                    i2 += 3;
                }
                iArr = iArr2;
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, iArr);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) iArr);
        }
    }

    private void responseCellInfoList(RadioResponseInfo radioResponseInfo, ArrayList<? extends Object> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList<android.telephony.CellInfo> convertHalCellInfoList = RILUtils.convertHalCellInfoList((ArrayList<Object>) arrayList);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalCellInfoList);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalCellInfoList);
        }
    }

    private void responseCellInfoList_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<? extends Object> arrayList) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            ArrayList<android.telephony.CellInfo> convertHalCellInfoList = RILUtils.convertHalCellInfoList((ArrayList<Object>) arrayList);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, convertHalCellInfoList);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, convertHalCellInfoList);
        }
    }

    private void responseActivityData(RadioResponseInfo radioResponseInfo, ActivityStatsInfo activityStatsInfo) {
        ModemActivityInfo modemActivityInfo;
        RadioResponseInfo radioResponseInfo2 = radioResponseInfo;
        ActivityStatsInfo activityStatsInfo2 = activityStatsInfo;
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo2);
        if (processResponse != null) {
            if (radioResponseInfo2.error == 0) {
                int i = activityStatsInfo2.sleepModeTimeMs;
                int i2 = activityStatsInfo2.idleModeTimeMs;
                int[] iArr = new int[ModemActivityInfo.getNumTxPowerLevels()];
                for (int i3 = 0; i3 < ModemActivityInfo.getNumTxPowerLevels(); i3++) {
                    iArr[i3] = activityStatsInfo2.txmModetimeMs[i3];
                }
                modemActivityInfo = new ModemActivityInfo(SystemClock.elapsedRealtime(), i, i2, iArr, activityStatsInfo2.rxModeTimeMs);
            } else {
                modemActivityInfo = new ModemActivityInfo(0, 0, 0, new int[ModemActivityInfo.getNumTxPowerLevels()], 0);
                radioResponseInfo2.error = 0;
            }
            sendMessageResponse(processResponse.mResult, modemActivityInfo);
            this.mRil.processResponseDone(processResponse, radioResponseInfo2, (Object) modemActivityInfo);
        }
    }

    private void responseHardwareConfig(RadioResponseInfo radioResponseInfo, ArrayList<HardwareConfig> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList<HardwareConfig> convertHalHardwareConfigList = RILUtils.convertHalHardwareConfigList(arrayList);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalHardwareConfigList);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalHardwareConfigList);
        }
    }

    private void responseRadioCapability(RadioResponseInfo radioResponseInfo, RadioCapability radioCapability) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            RadioCapability convertHalRadioCapability = RILUtils.convertHalRadioCapability(radioCapability, this.mRil);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalRadioCapability);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalRadioCapability);
        }
    }

    private void responseLceStatus(RadioResponseInfo radioResponseInfo, LceStatusInfo lceStatusInfo) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            ArrayList arrayList = new ArrayList();
            arrayList.add(Integer.valueOf(lceStatusInfo.lceStatus));
            arrayList.add(Integer.valueOf(Byte.toUnsignedInt(lceStatusInfo.actualIntervalMs)));
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, arrayList);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) arrayList);
        }
    }

    private void responseLceData(RadioResponseInfo radioResponseInfo, LceDataInfo lceDataInfo) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            List<LinkCapacityEstimate> convertHalLceData = RILUtils.convertHalLceData((Object) lceDataInfo);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, convertHalLceData);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalLceData);
        }
    }

    private void responseCarrierRestrictions(RadioResponseInfo radioResponseInfo, boolean z, CarrierRestrictionsWithPriority carrierRestrictionsWithPriority, int i) {
        CarrierRestrictionRules carrierRestrictionRules;
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (z) {
                carrierRestrictionRules = CarrierRestrictionRules.newBuilder().setAllCarriersAllowed().build();
            } else {
                int i2 = 0;
                if (i == 1) {
                    i2 = 1;
                }
                carrierRestrictionRules = CarrierRestrictionRules.newBuilder().setAllowedCarriers(RILUtils.convertHalCarrierList((List<Carrier>) carrierRestrictionsWithPriority.allowedCarriers)).setExcludedCarriers(RILUtils.convertHalCarrierList((List<Carrier>) carrierRestrictionsWithPriority.excludedCarriers)).setDefaultCarrierRestriction(carrierRestrictionsWithPriority.allowedCarriersPrioritized ^ true ? 1 : 0).setMultiSimPolicy(i2).build();
            }
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, carrierRestrictionRules);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) carrierRestrictionRules);
        }
    }

    public void enableModemResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getModemStackStatusResponse(RadioResponseInfo radioResponseInfo, boolean z) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, Boolean.valueOf(z));
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) Boolean.valueOf(z));
        }
    }

    public void setSystemSelectionChannelsResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void enableUiccApplicationsResponse(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void areUiccApplicationsEnabledResponse(RadioResponseInfo radioResponseInfo, boolean z) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, Boolean.valueOf(z));
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) Boolean.valueOf(z));
        }
    }

    public void setRadioPowerResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
        RIL ril = this.mRil;
        int i = radioResponseInfo.error;
        ril.mLastRadioPowerResult = i;
        if (i != 1 && i != 0) {
            AnomalyReporter.reportAnomaly(UUID.fromString(RILUtils.RADIO_POWER_FAILURE_BUGREPORT_UUID), "Radio power failure");
        }
    }

    public void setRadioPowerResponse_1_6(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
        RIL ril = this.mRil;
        int i = radioResponseInfo.error;
        ril.mLastRadioPowerResult = i;
        if (i == 70) {
            AnomalyReporter.reportAnomaly(UUID.fromString(RILUtils.RADIO_POWER_FAILURE_RF_HARDWARE_ISSUE_UUID), "RF HW damaged");
        } else if (i == 71) {
            AnomalyReporter.reportAnomaly(UUID.fromString(RILUtils.RADIO_POWER_FAILURE_NO_RF_CALIBRATION_UUID), "No RF calibration data");
        } else if (i != 1 && i != 0) {
            AnomalyReporter.reportAnomaly(UUID.fromString(RILUtils.RADIO_POWER_FAILURE_BUGREPORT_UUID), "Radio power failure");
        }
    }

    public void setSystemSelectionChannelsResponse_1_5(RadioResponseInfo radioResponseInfo) {
        responseVoid(radioResponseInfo);
    }

    public void getSystemSelectionChannelsResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, ArrayList<RadioAccessSpecifier> arrayList) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            ArrayList arrayList2 = new ArrayList();
            Iterator<RadioAccessSpecifier> it = arrayList.iterator();
            while (it.hasNext()) {
                arrayList2.add(RILUtils.convertHalRadioAccessSpecifier(it.next()));
            }
            RIL ril = this.mRil;
            ril.riljLog("getSystemSelectionChannelsResponse: from HIDL: " + arrayList2);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, arrayList2);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, arrayList2);
        }
    }

    public void getBarringInfoResponse(RadioResponseInfo radioResponseInfo, CellIdentity cellIdentity, ArrayList<BarringInfo> arrayList) {
        RILRequest processResponse = this.mRil.processResponse(radioResponseInfo);
        if (processResponse != null) {
            android.telephony.BarringInfo barringInfo = new android.telephony.BarringInfo(RILUtils.convertHalCellIdentity((Object) cellIdentity), RILUtils.convertHalBarringInfoList((List<BarringInfo>) arrayList));
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse.mResult, barringInfo);
                this.mRil.mBarringInfoChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, barringInfo, (Throwable) null));
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) barringInfo);
        }
    }

    public void allocatePduSessionIdResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, int i) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, Integer.valueOf(i));
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, Integer.valueOf(i));
        }
    }

    public void releasePduSessionIdResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void startHandoverResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void cancelHandoverResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo) {
        responseVoid_1_6(radioResponseInfo);
    }

    public void getSlicingConfigResponse(android.hardware.radio.V1_6.RadioResponseInfo radioResponseInfo, SlicingConfig slicingConfig) {
        RILRequest processResponse_1_6 = this.mRil.processResponse_1_6(radioResponseInfo);
        if (processResponse_1_6 != null) {
            NetworkSlicingConfig convertHalSlicingConfig = RILUtils.convertHalSlicingConfig(slicingConfig);
            if (radioResponseInfo.error == 0) {
                sendMessageResponse(processResponse_1_6.mResult, convertHalSlicingConfig);
            }
            this.mRil.processResponseDone_1_6(processResponse_1_6, radioResponseInfo, convertHalSlicingConfig);
        }
    }
}
