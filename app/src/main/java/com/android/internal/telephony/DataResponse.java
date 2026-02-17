package com.android.internal.telephony;

import android.hardware.radio.RadioResponseInfo;
import android.hardware.radio.data.IRadioDataResponse;
import android.hardware.radio.data.KeepaliveStatus;
import android.hardware.radio.data.SetupDataCallResult;
import android.hardware.radio.data.SlicingConfig;
import android.telephony.data.DataCallResponse;
import android.telephony.data.NetworkSlicingConfig;
import java.util.ArrayList;

public class DataResponse extends IRadioDataResponse.Stub {
    private final RIL mRil;

    public String getInterfaceHash() {
        return "6d7a86008ea4fe79ced2a86b526a92618eb4c84a";
    }

    public int getInterfaceVersion() {
        return 1;
    }

    public DataResponse(RIL ril) {
        this.mRil = ril;
    }

    public void acknowledgeRequest(int i) {
        this.mRil.processRequestAck(i);
    }

    public void allocatePduSessionIdResponse(RadioResponseInfo radioResponseInfo, int i) {
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
        if (processResponse != null) {
            if (radioResponseInfo.error == 0) {
                RadioResponse.sendMessageResponse(processResponse.mResult, Integer.valueOf(i));
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) Integer.valueOf(i));
        }
    }

    public void cancelHandoverResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void deactivateDataCallResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void getDataCallListResponse(RadioResponseInfo radioResponseInfo, SetupDataCallResult[] setupDataCallResultArr) {
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
        if (processResponse != null) {
            ArrayList<DataCallResponse> convertHalDataCallResultList = RILUtils.convertHalDataCallResultList(setupDataCallResultArr);
            if (radioResponseInfo.error == 0) {
                RadioResponse.sendMessageResponse(processResponse.mResult, convertHalDataCallResultList);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalDataCallResultList);
        }
    }

    public void getSlicingConfigResponse(RadioResponseInfo radioResponseInfo, SlicingConfig slicingConfig) {
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
        if (processResponse != null) {
            NetworkSlicingConfig convertHalSlicingConfig = RILUtils.convertHalSlicingConfig(slicingConfig);
            if (radioResponseInfo.error == 0) {
                RadioResponse.sendMessageResponse(processResponse.mResult, convertHalSlicingConfig);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalSlicingConfig);
        }
    }

    public void releasePduSessionIdResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void setDataAllowedResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void setDataProfileResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void setDataThrottlingResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void setInitialAttachApnResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void setupDataCallResponse(RadioResponseInfo radioResponseInfo, SetupDataCallResult setupDataCallResult) {
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
        if (processResponse != null) {
            DataCallResponse convertHalDataCallResult = RILUtils.convertHalDataCallResult(setupDataCallResult);
            if (radioResponseInfo.error == 0) {
                RadioResponse.sendMessageResponse(processResponse.mResult, convertHalDataCallResult);
            }
            this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) convertHalDataCallResult);
        }
    }

    public void startHandoverResponse(RadioResponseInfo radioResponseInfo) {
        RadioResponse.responseVoid(1, this.mRil, radioResponseInfo);
    }

    public void startKeepaliveResponse(RadioResponseInfo radioResponseInfo, KeepaliveStatus keepaliveStatus) {
        com.android.internal.telephony.data.KeepaliveStatus keepaliveStatus2;
        com.android.internal.telephony.data.KeepaliveStatus keepaliveStatus3;
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
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
                    RadioResponse.sendMessageResponse(processResponse.mResult, keepaliveStatus2);
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
        RILRequest processResponse = this.mRil.processResponse(1, radioResponseInfo);
        if (processResponse != null) {
            try {
                if (radioResponseInfo.error == 0) {
                    RadioResponse.sendMessageResponse(processResponse.mResult, (Object) null);
                }
            } finally {
                this.mRil.processResponseDone(processResponse, radioResponseInfo, (Object) null);
            }
        }
    }
}
