package com.android.internal.telephony;

import android.hardware.radio.network.IRadioNetwork;
import android.os.AsyncResult;
import android.os.Message;
import android.os.RemoteException;
import android.telephony.NetworkScanRequest;
import android.telephony.RadioAccessSpecifier;
import android.telephony.Rlog;
import android.telephony.SignalThresholdInfo;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class RadioNetworkProxy extends RadioServiceProxy {
    private static final int INDICATION_FILTERS_ALL_AIDL = 127;
    private static final int INDICATION_FILTERS_ALL_V1_0 = 7;
    private static final int INDICATION_FILTERS_ALL_V1_2 = 31;
    private static final int INDICATION_FILTERS_ALL_V1_5 = 127;
    private static final String TAG = "RadioNetworkProxy";
    private volatile IRadioNetwork mNetworkProxy = null;

    public void setAidl(HalVersion halVersion, IRadioNetwork iRadioNetwork) {
        this.mHalVersion = halVersion;
        this.mNetworkProxy = iRadioNetwork;
        this.mIsAidl = true;
        Rlog.d(TAG, "AIDL initialized");
    }

    public IRadioNetwork getAidl() {
        return this.mNetworkProxy;
    }

    public void clear() {
        super.clear();
        this.mNetworkProxy = null;
    }

    public boolean isEmpty() {
        return this.mRadioProxy == null && this.mNetworkProxy == null;
    }

    public void getAllowedNetworkTypesBitmap(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getAllowedNetworkTypesBitmap(i);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.getAllowedNetworkTypesBitmap(i);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_4)) {
                this.mRadioProxy.getPreferredNetworkTypeBitmap(i);
            } else {
                this.mRadioProxy.getPreferredNetworkType(i);
            }
        }
    }

    public void getAvailableBandModes(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getAvailableBandModes(i);
            } else {
                this.mRadioProxy.getAvailableBandModes(i);
            }
        }
    }

    public void getAvailableNetworks(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getAvailableNetworks(i);
            } else {
                this.mRadioProxy.getAvailableNetworks(i);
            }
        }
    }

    public void getBarringInfo(int i) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_5)) {
            if (isAidl()) {
                this.mNetworkProxy.getBarringInfo(i);
            } else {
                this.mRadioProxy.getBarringInfo(i);
            }
        }
    }

    public void getCdmaRoamingPreference(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getCdmaRoamingPreference(i);
            } else {
                this.mRadioProxy.getCdmaRoamingPreference(i);
            }
        }
    }

    public void getCellInfoList(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getCellInfoList(i);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.getCellInfoList_1_6(i);
            } else {
                this.mRadioProxy.getCellInfoList(i);
            }
        }
    }

    public void getDataRegistrationState(int i, HalVersion halVersion) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getDataRegistrationState(i);
            } else if ((halVersion == null || halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) && this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.getDataRegistrationState_1_6(i);
            } else if ((halVersion == null || halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) && this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.getDataRegistrationState_1_5(i);
            } else {
                this.mRadioProxy.getDataRegistrationState(i);
            }
        }
    }

    public void getImsRegistrationState(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getImsRegistrationState(i);
            } else {
                this.mRadioProxy.getImsRegistrationState(i);
            }
        }
    }

    public void getNetworkSelectionMode(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getNetworkSelectionMode(i);
            } else {
                this.mRadioProxy.getNetworkSelectionMode(i);
            }
        }
    }

    public void getOperator(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getOperator(i);
            } else {
                this.mRadioProxy.getOperator(i);
            }
        }
    }

    public void getSignalStrength(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getSignalStrength(i);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.getSignalStrength_1_6(i);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_4)) {
                this.mRadioProxy.getSignalStrength_1_4(i);
            } else {
                this.mRadioProxy.getSignalStrength(i);
            }
        }
    }

    public void getSystemSelectionChannels(int i) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_6)) {
            if (isAidl()) {
                this.mNetworkProxy.getSystemSelectionChannels(i);
            } else {
                this.mRadioProxy.getSystemSelectionChannels(i);
            }
        }
    }

    public void getVoiceRadioTechnology(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getVoiceRadioTechnology(i);
            } else {
                this.mRadioProxy.getVoiceRadioTechnology(i);
            }
        }
    }

    public void getVoiceRegistrationState(int i, HalVersion halVersion) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.getVoiceRegistrationState(i);
            } else if ((halVersion == null || halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) && this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.getVoiceRegistrationState_1_6(i);
            } else if ((halVersion == null || halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) && this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.getVoiceRegistrationState_1_5(i);
            } else {
                this.mRadioProxy.getVoiceRegistrationState(i);
            }
        }
    }

    public void isNrDualConnectivityEnabled(int i) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_6)) {
            if (isAidl()) {
                this.mNetworkProxy.isNrDualConnectivityEnabled(i);
            } else {
                this.mRadioProxy.isNrDualConnectivityEnabled(i);
            }
        }
    }

    public void responseAcknowledgement() throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.responseAcknowledgement();
            } else {
                this.mRadioProxy.responseAcknowledgement();
            }
        }
    }

    public void setAllowedNetworkTypesBitmap(int i, int i2) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_6)) {
            if (isAidl()) {
                this.mNetworkProxy.setAllowedNetworkTypesBitmap(i, RILUtils.convertToHalRadioAccessFamilyAidl(i2));
            } else {
                this.mRadioProxy.setAllowedNetworkTypesBitmap(i, RILUtils.convertToHalRadioAccessFamily(i2));
            }
        }
    }

    public void setPreferredNetworkTypeBitmap(int i, int i2) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
            if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_4)) {
                this.mRadioProxy.setPreferredNetworkTypeBitmap(i, RILUtils.convertToHalRadioAccessFamily(i2));
            } else {
                this.mRadioProxy.setPreferredNetworkType(i, i2);
            }
        }
    }

    public void setBandMode(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setBandMode(i, i2);
            } else {
                this.mRadioProxy.setBandMode(i, i2);
            }
        }
    }

    public void setBarringPassword(int i, String str, String str2, String str3) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setBarringPassword(i, str, str2, str3);
            } else {
                this.mRadioProxy.setBarringPassword(i, str, str2, str3);
            }
        }
    }

    public void setCdmaRoamingPreference(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setCdmaRoamingPreference(i, i2);
            } else {
                this.mRadioProxy.setCdmaRoamingPreference(i, i2);
            }
        }
    }

    public void setCellInfoListRate(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setCellInfoListRate(i, i2);
            } else {
                this.mRadioProxy.setCellInfoListRate(i, i2);
            }
        }
    }

    public void setIndicationFilter(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setIndicationFilter(i, i2 & 127);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.setIndicationFilter_1_5(i, i2 & 127);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_2)) {
                this.mRadioProxy.setIndicationFilter_1_2(i, i2 & 31);
            } else {
                this.mRadioProxy.setIndicationFilter(i, i2 & 7);
            }
        }
    }

    public void setLinkCapacityReportingCriteria(int i, int i2, int i3, int i4, int[] iArr, int[] iArr2, int i5) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_2)) {
            if (isAidl()) {
                this.mNetworkProxy.setLinkCapacityReportingCriteria(i, i2, i3, i4, iArr, iArr2, RILUtils.convertToHalAccessNetworkAidl(i5));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.setLinkCapacityReportingCriteria_1_5(i, i2, i3, i4, RILUtils.primitiveArrayToArrayList(iArr), RILUtils.primitiveArrayToArrayList(iArr2), RILUtils.convertToHalAccessNetwork(i5));
            } else if (i5 != 6) {
                this.mRadioProxy.setLinkCapacityReportingCriteria(i, i2, i3, i4, RILUtils.primitiveArrayToArrayList(iArr), RILUtils.primitiveArrayToArrayList(iArr2), RILUtils.convertToHalAccessNetwork(i5));
            } else {
                throw new RuntimeException("NGRAN unsupported on IRadio version: " + this.mHalVersion);
            }
        }
    }

    public void setLocationUpdates(int i, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setLocationUpdates(i, z);
            } else {
                this.mRadioProxy.setLocationUpdates(i, z);
            }
        }
    }

    public void setNetworkSelectionModeAutomatic(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setNetworkSelectionModeAutomatic(i);
            } else {
                this.mRadioProxy.setNetworkSelectionModeAutomatic(i);
            }
        }
    }

    public void setNetworkSelectionModeManual(int i, String str, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setNetworkSelectionModeManual(i, str, RILUtils.convertToHalAccessNetworkAidl(i2));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.setNetworkSelectionModeManual_1_5(i, str, RILUtils.convertToHalRadioAccessNetworks(i2));
            } else {
                this.mRadioProxy.setNetworkSelectionModeManual(i, str);
            }
        }
    }

    public void setNrDualConnectivityState(int i, byte b) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_6)) {
            if (isAidl()) {
                this.mNetworkProxy.setNrDualConnectivityState(i, b);
            } else {
                this.mRadioProxy.setNrDualConnectivityState(i, b);
            }
        }
    }

    public void setSignalStrengthReportingCriteria(int i, List<SignalThresholdInfo> list) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_2)) {
            if (isAidl()) {
                android.hardware.radio.network.SignalThresholdInfo[] signalThresholdInfoArr = new android.hardware.radio.network.SignalThresholdInfo[list.size()];
                for (int i2 = 0; i2 < list.size(); i2++) {
                    signalThresholdInfoArr[i2] = RILUtils.convertToHalSignalThresholdInfoAidl(list.get(i2));
                }
                this.mNetworkProxy.setSignalStrengthReportingCriteria(i, signalThresholdInfoArr);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                for (SignalThresholdInfo next : list) {
                    this.mRadioProxy.setSignalStrengthReportingCriteria_1_5(i, RILUtils.convertToHalSignalThresholdInfo(next), RILUtils.convertToHalAccessNetwork(next.getRadioAccessNetworkType()));
                }
            } else {
                for (SignalThresholdInfo next2 : list) {
                    this.mRadioProxy.setSignalStrengthReportingCriteria(i, next2.getHysteresisMs(), next2.getHysteresisDb(), RILUtils.primitiveArrayToArrayList(next2.getThresholds()), RILUtils.convertToHalAccessNetwork(next2.getRadioAccessNetworkType()));
                }
            }
        }
    }

    public void setSuppServiceNotifications(int i, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.setSuppServiceNotifications(i, z);
            } else {
                this.mRadioProxy.setSuppServiceNotifications(i, z);
            }
        }
    }

    public void setSystemSelectionChannels(int i, List<RadioAccessSpecifier> list) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_3)) {
            if (isAidl()) {
                this.mNetworkProxy.setSystemSelectionChannels(i, !list.isEmpty(), (android.hardware.radio.network.RadioAccessSpecifier[]) list.stream().map(new RadioNetworkProxy$$ExternalSyntheticLambda2()).toArray(new RadioNetworkProxy$$ExternalSyntheticLambda3()));
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.setSystemSelectionChannels_1_5(i, !list.isEmpty(), (ArrayList) list.stream().map(new RadioNetworkProxy$$ExternalSyntheticLambda4()).collect(Collectors.toCollection(new RadioNetworkProxy$$ExternalSyntheticLambda5())));
            } else {
                this.mRadioProxy.setSystemSelectionChannels(i, !list.isEmpty(), (ArrayList) list.stream().map(new RadioNetworkProxy$$ExternalSyntheticLambda6()).collect(Collectors.toCollection(new RadioNetworkProxy$$ExternalSyntheticLambda5())));
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ android.hardware.radio.network.RadioAccessSpecifier[] lambda$setSystemSelectionChannels$0(int i) {
        return new android.hardware.radio.network.RadioAccessSpecifier[i];
    }

    public void startNetworkScan(int i, NetworkScanRequest networkScanRequest, HalVersion halVersion, Message message) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_1)) {
            int i2 = 0;
            if (isAidl()) {
                android.hardware.radio.network.NetworkScanRequest networkScanRequest2 = new android.hardware.radio.network.NetworkScanRequest();
                networkScanRequest2.type = networkScanRequest.getScanType();
                networkScanRequest2.interval = networkScanRequest.getSearchPeriodicity();
                networkScanRequest2.maxSearchTime = networkScanRequest.getMaxSearchTime();
                networkScanRequest2.incrementalResultsPeriodicity = networkScanRequest.getIncrementalResultsPeriodicity();
                networkScanRequest2.incrementalResults = networkScanRequest.getIncrementalResults();
                networkScanRequest2.mccMncs = (String[]) networkScanRequest.getPlmns().stream().toArray(new RadioNetworkProxy$$ExternalSyntheticLambda0());
                ArrayList arrayList = new ArrayList();
                RadioAccessSpecifier[] specifiers = networkScanRequest.getSpecifiers();
                int length = specifiers.length;
                while (i2 < length) {
                    android.hardware.radio.network.RadioAccessSpecifier convertToHalRadioAccessSpecifierAidl = RILUtils.convertToHalRadioAccessSpecifierAidl(specifiers[i2]);
                    if (convertToHalRadioAccessSpecifierAidl == null) {
                        AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                        message.sendToTarget();
                        return;
                    }
                    arrayList.add(convertToHalRadioAccessSpecifierAidl);
                    i2++;
                }
                networkScanRequest2.specifiers = (android.hardware.radio.network.RadioAccessSpecifier[]) arrayList.stream().toArray(new RadioNetworkProxy$$ExternalSyntheticLambda1());
                this.mNetworkProxy.startNetworkScan(i, networkScanRequest2);
            } else if ((halVersion == null || halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) && this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                android.hardware.radio.V1_5.NetworkScanRequest networkScanRequest3 = new android.hardware.radio.V1_5.NetworkScanRequest();
                networkScanRequest3.type = networkScanRequest.getScanType();
                networkScanRequest3.interval = networkScanRequest.getSearchPeriodicity();
                networkScanRequest3.maxSearchTime = networkScanRequest.getMaxSearchTime();
                networkScanRequest3.incrementalResultsPeriodicity = networkScanRequest.getIncrementalResultsPeriodicity();
                networkScanRequest3.incrementalResults = networkScanRequest.getIncrementalResults();
                networkScanRequest3.mccMncs.addAll(networkScanRequest.getPlmns());
                RadioAccessSpecifier[] specifiers2 = networkScanRequest.getSpecifiers();
                int length2 = specifiers2.length;
                while (i2 < length2) {
                    android.hardware.radio.V1_5.RadioAccessSpecifier convertToHalRadioAccessSpecifier15 = RILUtils.convertToHalRadioAccessSpecifier15(specifiers2[i2]);
                    if (convertToHalRadioAccessSpecifier15 == null) {
                        AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                        message.sendToTarget();
                        return;
                    }
                    networkScanRequest3.specifiers.add(convertToHalRadioAccessSpecifier15);
                    i2++;
                }
                this.mRadioProxy.startNetworkScan_1_5(i, networkScanRequest3);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_2)) {
                android.hardware.radio.V1_2.NetworkScanRequest networkScanRequest4 = new android.hardware.radio.V1_2.NetworkScanRequest();
                networkScanRequest4.type = networkScanRequest.getScanType();
                networkScanRequest4.interval = networkScanRequest.getSearchPeriodicity();
                networkScanRequest4.maxSearchTime = networkScanRequest.getMaxSearchTime();
                networkScanRequest4.incrementalResultsPeriodicity = networkScanRequest.getIncrementalResultsPeriodicity();
                networkScanRequest4.incrementalResults = networkScanRequest.getIncrementalResults();
                networkScanRequest4.mccMncs.addAll(networkScanRequest.getPlmns());
                RadioAccessSpecifier[] specifiers3 = networkScanRequest.getSpecifiers();
                int length3 = specifiers3.length;
                while (i2 < length3) {
                    android.hardware.radio.V1_1.RadioAccessSpecifier convertToHalRadioAccessSpecifier11 = RILUtils.convertToHalRadioAccessSpecifier11(specifiers3[i2]);
                    if (convertToHalRadioAccessSpecifier11 == null) {
                        AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                        message.sendToTarget();
                        return;
                    }
                    networkScanRequest4.specifiers.add(convertToHalRadioAccessSpecifier11);
                    i2++;
                }
                if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_4)) {
                    this.mRadioProxy.startNetworkScan_1_4(i, networkScanRequest4);
                } else {
                    this.mRadioProxy.startNetworkScan_1_2(i, networkScanRequest4);
                }
            } else {
                android.hardware.radio.V1_1.NetworkScanRequest networkScanRequest5 = new android.hardware.radio.V1_1.NetworkScanRequest();
                networkScanRequest5.type = networkScanRequest.getScanType();
                networkScanRequest5.interval = networkScanRequest.getSearchPeriodicity();
                RadioAccessSpecifier[] specifiers4 = networkScanRequest.getSpecifiers();
                int length4 = specifiers4.length;
                while (i2 < length4) {
                    android.hardware.radio.V1_1.RadioAccessSpecifier convertToHalRadioAccessSpecifier112 = RILUtils.convertToHalRadioAccessSpecifier11(specifiers4[i2]);
                    if (convertToHalRadioAccessSpecifier112 == null) {
                        AsyncResult.forMessage(message, (Object) null, CommandException.fromRilErrno(6));
                        message.sendToTarget();
                        return;
                    }
                    networkScanRequest5.specifiers.add(convertToHalRadioAccessSpecifier112);
                    i2++;
                }
                this.mRadioProxy.startNetworkScan(i, networkScanRequest5);
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$startNetworkScan$1(int i) {
        return new String[i];
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ android.hardware.radio.network.RadioAccessSpecifier[] lambda$startNetworkScan$2(int i) {
        return new android.hardware.radio.network.RadioAccessSpecifier[i];
    }

    public void stopNetworkScan(int i) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_1)) {
            if (isAidl()) {
                this.mNetworkProxy.stopNetworkScan(i);
            } else {
                this.mRadioProxy.stopNetworkScan(i);
            }
        }
    }

    public void supplyNetworkDepersonalization(int i, String str) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mNetworkProxy.supplyNetworkDepersonalization(i, str);
            } else {
                this.mRadioProxy.supplyNetworkDepersonalization(i, str);
            }
        }
    }

    public void getUsageSetting(int i) throws RemoteException {
        if (!isEmpty() && isAidl()) {
            this.mNetworkProxy.getUsageSetting(i);
        }
    }

    public void setUsageSetting(int i, int i2) throws RemoteException {
        if (!isEmpty() && isAidl()) {
            this.mNetworkProxy.setUsageSetting(i, i2);
        }
    }
}
