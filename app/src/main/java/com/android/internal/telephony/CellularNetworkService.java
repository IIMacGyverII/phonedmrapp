package com.android.internal.telephony;

import android.hardware.radio.V1_0.DataRegStateResult;
import android.hardware.radio.V1_0.VoiceRegStateResult;
import android.hardware.radio.V1_4.LteVopsInfo;
import android.hardware.radio.V1_4.NrIndicators;
import android.hardware.radio.V1_5.RegStateResult;
import android.hardware.radio.V1_6.RegStateResult;
import android.hardware.radio.network.RegStateResult;
import android.os.AsyncResult;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.AnomalyReporter;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityCdma;
import android.telephony.CellIdentityGsm;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityNr;
import android.telephony.CellIdentityTdscdma;
import android.telephony.CellIdentityWcdma;
import android.telephony.LteVopsSupportInfo;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.NetworkService;
import android.telephony.NetworkServiceCallback;
import android.telephony.NrVopsSupportInfo;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.VopsSupportInfo;
import android.text.TextUtils;
import android.util.ArrayMap;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class CellularNetworkService extends NetworkService {
    private static final boolean DBG = false;
    private static final int GET_CS_REGISTRATION_STATE_DONE = 1;
    private static final int GET_PS_REGISTRATION_STATE_DONE = 2;
    private static final int MAX_DATA_CALLS = 16;
    private static final int NETWORK_REGISTRATION_STATE_CHANGED = 3;
    private static final String TAG = CellularNetworkService.class.getSimpleName();
    private static final Map<Class<? extends CellIdentity>, List<Integer>> sNetworkTypes;

    static {
        ArrayMap arrayMap = new ArrayMap();
        sNetworkTypes = arrayMap;
        arrayMap.put(CellIdentityGsm.class, Arrays.asList(new Integer[]{16, 1, 2}));
        arrayMap.put(CellIdentityWcdma.class, Arrays.asList(new Integer[]{3, 8, 9, 10, 15}));
        arrayMap.put(CellIdentityCdma.class, Arrays.asList(new Integer[]{4, 7, 5, 6, 12, 14}));
        arrayMap.put(CellIdentityLte.class, Arrays.asList(new Integer[]{13}));
        arrayMap.put(CellIdentityNr.class, Arrays.asList(new Integer[]{20}));
        arrayMap.put(CellIdentityTdscdma.class, Arrays.asList(new Integer[]{17}));
    }

    private class CellularNetworkServiceProvider extends NetworkService.NetworkServiceProvider {
        /* access modifiers changed from: private */
        public final Map<Message, NetworkServiceCallback> mCallbackMap = new HashMap();
        private final Handler mHandler;
        private final Phone mPhone;

        private int getRegStateFromHalRegState(int i) {
            int i2 = 1;
            if (i != 1) {
                i2 = 2;
                if (i != 2) {
                    if (i != 3) {
                        if (i != 4) {
                            if (i == 5) {
                                return 5;
                            }
                            switch (i) {
                                case 12:
                                    break;
                                case 13:
                                    break;
                                case 14:
                                    break;
                                default:
                                    return 0;
                            }
                        }
                        return 4;
                    }
                    return 3;
                }
            }
            return i2;
        }

        private boolean isEmergencyOnly(int i) {
            switch (i) {
                case 10:
                case 12:
                case 13:
                case 14:
                    return true;
                default:
                    return false;
            }
        }

        CellularNetworkServiceProvider(int i) {
            super(CellularNetworkService.this, i);
            Phone phone = PhoneFactory.getPhone(getSlotIndex());
            this.mPhone = phone;
            AnonymousClass1 r0 = new Handler(Looper.myLooper(), CellularNetworkService.this) {
                public void handleMessage(Message message) {
                    NetworkServiceCallback networkServiceCallback = (NetworkServiceCallback) CellularNetworkServiceProvider.this.mCallbackMap.remove(message);
                    int i = message.what;
                    int i2 = 2;
                    if (i == 1 || i == 2) {
                        if (networkServiceCallback != null) {
                            AsyncResult asyncResult = (AsyncResult) message.obj;
                            if (i == 1) {
                                i2 = 1;
                            }
                            NetworkRegistrationInfo r4 = CellularNetworkServiceProvider.this.getRegistrationStateFromResult(asyncResult.result, i2);
                            try {
                                networkServiceCallback.onRequestNetworkRegistrationInfoComplete((asyncResult.exception != null || r4 == null) ? 5 : 0, r4);
                            } catch (Exception e) {
                                CellularNetworkService.loge("Exception: " + e);
                            }
                        }
                    } else if (i == 3) {
                        CellularNetworkServiceProvider.this.notifyNetworkRegistrationInfoChanged();
                    }
                }
            };
            this.mHandler = r0;
            phone.mCi.registerForNetworkStateChanged(r0, 3, (Object) null);
        }

        private List<Integer> getAvailableServices(int i, int i2, boolean z) {
            ArrayList arrayList = new ArrayList();
            if (z) {
                arrayList.add(5);
            } else if (i == 5 || i == 1) {
                if (i2 == 2) {
                    arrayList.add(2);
                } else if (i2 == 1) {
                    arrayList.add(1);
                    arrayList.add(3);
                    arrayList.add(4);
                }
            }
            return arrayList;
        }

        /* access modifiers changed from: private */
        public NetworkRegistrationInfo getRegistrationStateFromResult(Object obj, int i) {
            if (obj == null) {
                return null;
            }
            if (i == 1) {
                return createRegistrationStateFromVoiceRegState(obj);
            }
            if (i == 2) {
                return createRegistrationStateFromDataRegState(obj);
            }
            return null;
        }

        private String getPlmnFromCellIdentity(CellIdentity cellIdentity) {
            if (cellIdentity == null || (cellIdentity instanceof CellIdentityCdma)) {
                return "";
            }
            String mccString = cellIdentity.getMccString();
            String mncString = cellIdentity.getMncString();
            if (TextUtils.isEmpty(mccString) || TextUtils.isEmpty(mncString)) {
                return "";
            }
            return mccString + mncString;
        }

        private NetworkRegistrationInfo createRegistrationStateFromVoiceRegState(Object obj) {
            Object obj2 = obj;
            if (obj2 instanceof RegStateResult) {
                return getNetworkRegistrationInfoAidl(1, 1, (RegStateResult) obj2);
            }
            if (obj2 instanceof android.hardware.radio.V1_6.RegStateResult) {
                return getNetworkRegistrationInfo1_6(1, 1, (android.hardware.radio.V1_6.RegStateResult) obj2);
            }
            if (obj2 instanceof android.hardware.radio.V1_5.RegStateResult) {
                return getNetworkRegistrationInfo(1, 1, (android.hardware.radio.V1_5.RegStateResult) obj2);
            }
            if (obj2 instanceof VoiceRegStateResult) {
                VoiceRegStateResult voiceRegStateResult = (VoiceRegStateResult) obj2;
                int regStateFromHalRegState = getRegStateFromHalRegState(voiceRegStateResult.regState);
                int rilRadioTechnologyToNetworkType = ServiceState.rilRadioTechnologyToNetworkType(voiceRegStateResult.rat);
                int i = voiceRegStateResult.reasonForDenial;
                boolean isEmergencyOnly = isEmergencyOnly(voiceRegStateResult.regState);
                boolean z = voiceRegStateResult.cssSupported;
                int i2 = voiceRegStateResult.roamingIndicator;
                int i3 = voiceRegStateResult.systemIsInPrl;
                int i4 = voiceRegStateResult.defaultRoamingIndicator;
                List<Integer> availableServices = getAvailableServices(regStateFromHalRegState, 1, isEmergencyOnly);
                CellIdentity convertHalCellIdentity = RILUtils.convertHalCellIdentity((Object) voiceRegStateResult.cellIdentity);
                return new NetworkRegistrationInfo(1, 1, regStateFromHalRegState, rilRadioTechnologyToNetworkType, i, isEmergencyOnly, availableServices, convertHalCellIdentity, getPlmnFromCellIdentity(convertHalCellIdentity), z, i2, i3, i4);
            } else if (!(obj2 instanceof android.hardware.radio.V1_2.VoiceRegStateResult)) {
                return null;
            } else {
                android.hardware.radio.V1_2.VoiceRegStateResult voiceRegStateResult2 = (android.hardware.radio.V1_2.VoiceRegStateResult) obj2;
                int regStateFromHalRegState2 = getRegStateFromHalRegState(voiceRegStateResult2.regState);
                int rilRadioTechnologyToNetworkType2 = ServiceState.rilRadioTechnologyToNetworkType(voiceRegStateResult2.rat);
                int i5 = voiceRegStateResult2.reasonForDenial;
                boolean isEmergencyOnly2 = isEmergencyOnly(voiceRegStateResult2.regState);
                boolean z2 = voiceRegStateResult2.cssSupported;
                int i6 = voiceRegStateResult2.roamingIndicator;
                int i7 = voiceRegStateResult2.systemIsInPrl;
                int i8 = voiceRegStateResult2.defaultRoamingIndicator;
                List<Integer> availableServices2 = getAvailableServices(regStateFromHalRegState2, 1, isEmergencyOnly2);
                CellIdentity convertHalCellIdentity2 = RILUtils.convertHalCellIdentity((Object) voiceRegStateResult2.cellIdentity);
                return new NetworkRegistrationInfo(1, 1, regStateFromHalRegState2, rilRadioTechnologyToNetworkType2, i5, isEmergencyOnly2, availableServices2, convertHalCellIdentity2, getPlmnFromCellIdentity(convertHalCellIdentity2), z2, i6, i7, i8);
            }
        }

        private NetworkRegistrationInfo createRegistrationStateFromDataRegState(Object obj) {
            VopsSupportInfo vopsSupportInfo;
            boolean z;
            boolean z2;
            boolean z3;
            int i;
            int i2;
            int i3;
            int i4;
            boolean z4;
            CellIdentity cellIdentity;
            VopsSupportInfo vopsSupportInfo2;
            int regStateFromHalRegState;
            int rilRadioTechnologyToNetworkType;
            int i5;
            int i6;
            Object obj2 = obj;
            VopsSupportInfo lteVopsSupportInfo = new LteVopsSupportInfo(1, 1);
            if (obj2 instanceof RegStateResult) {
                return getNetworkRegistrationInfoAidl(2, 1, (RegStateResult) obj2);
            }
            if (obj2 instanceof android.hardware.radio.V1_6.RegStateResult) {
                return getNetworkRegistrationInfo1_6(2, 1, (android.hardware.radio.V1_6.RegStateResult) obj2);
            }
            if (obj2 instanceof android.hardware.radio.V1_5.RegStateResult) {
                return getNetworkRegistrationInfo(2, 1, (android.hardware.radio.V1_5.RegStateResult) obj2);
            }
            if (obj2 instanceof DataRegStateResult) {
                DataRegStateResult dataRegStateResult = (DataRegStateResult) obj2;
                regStateFromHalRegState = getRegStateFromHalRegState(dataRegStateResult.regState);
                rilRadioTechnologyToNetworkType = ServiceState.rilRadioTechnologyToNetworkType(dataRegStateResult.rat);
                i5 = dataRegStateResult.reasonDataDenied;
                z4 = isEmergencyOnly(dataRegStateResult.regState);
                i6 = dataRegStateResult.maxDataCalls;
                cellIdentity = RILUtils.convertHalCellIdentity((Object) dataRegStateResult.cellIdentity);
            } else if (obj2 instanceof android.hardware.radio.V1_2.DataRegStateResult) {
                android.hardware.radio.V1_2.DataRegStateResult dataRegStateResult2 = (android.hardware.radio.V1_2.DataRegStateResult) obj2;
                regStateFromHalRegState = getRegStateFromHalRegState(dataRegStateResult2.regState);
                rilRadioTechnologyToNetworkType = ServiceState.rilRadioTechnologyToNetworkType(dataRegStateResult2.rat);
                i5 = dataRegStateResult2.reasonDataDenied;
                z4 = isEmergencyOnly(dataRegStateResult2.regState);
                i6 = dataRegStateResult2.maxDataCalls;
                cellIdentity = RILUtils.convertHalCellIdentity((Object) dataRegStateResult2.cellIdentity);
            } else if (obj2 instanceof android.hardware.radio.V1_4.DataRegStateResult) {
                android.hardware.radio.V1_4.DataRegStateResult dataRegStateResult3 = (android.hardware.radio.V1_4.DataRegStateResult) obj2;
                int regStateFromHalRegState2 = getRegStateFromHalRegState(dataRegStateResult3.base.regState);
                int rilRadioTechnologyToNetworkType2 = ServiceState.rilRadioTechnologyToNetworkType(dataRegStateResult3.base.rat);
                android.hardware.radio.V1_2.DataRegStateResult dataRegStateResult4 = dataRegStateResult3.base;
                int i7 = dataRegStateResult4.reasonDataDenied;
                z4 = isEmergencyOnly(dataRegStateResult4.regState);
                android.hardware.radio.V1_2.DataRegStateResult dataRegStateResult5 = dataRegStateResult3.base;
                int i8 = dataRegStateResult5.maxDataCalls;
                CellIdentity convertHalCellIdentity = RILUtils.convertHalCellIdentity((Object) dataRegStateResult5.cellIdentity);
                NrIndicators nrIndicators = dataRegStateResult3.nrIndicators;
                if (dataRegStateResult3.vopsInfo.getDiscriminator() == 1 && ServiceState.rilRadioTechnologyToAccessNetworkType(dataRegStateResult3.base.rat) == 3) {
                    LteVopsInfo lteVopsInfo = dataRegStateResult3.vopsInfo.lteVopsInfo();
                    vopsSupportInfo2 = convertHalLteVopsSupportInfo(lteVopsInfo.isVopsSupported, lteVopsInfo.isEmcBearerSupported);
                } else {
                    vopsSupportInfo2 = new LteVopsSupportInfo(1, 1);
                }
                boolean z5 = nrIndicators.isEndcAvailable;
                boolean z6 = nrIndicators.isNrAvailable;
                vopsSupportInfo = vopsSupportInfo2;
                i4 = regStateFromHalRegState2;
                z = z5;
                i3 = rilRadioTechnologyToNetworkType2;
                cellIdentity = convertHalCellIdentity;
                i2 = i7;
                i = i8;
                z3 = nrIndicators.isDcNrRestricted;
                z2 = z6;
                return new NetworkRegistrationInfo(2, 1, i4, i3, i2, z4, getAvailableServices(i4, 2, z4), cellIdentity, getPlmnFromCellIdentity(cellIdentity), i, z3, z2, z, vopsSupportInfo);
            } else {
                CellularNetworkService.loge("Unknown type of DataRegStateResult " + obj2);
                return null;
            }
            vopsSupportInfo = lteVopsSupportInfo;
            i4 = regStateFromHalRegState;
            i3 = rilRadioTechnologyToNetworkType;
            z3 = false;
            z2 = false;
            z = false;
            i2 = i5;
            i = i6;
            return new NetworkRegistrationInfo(2, 1, i4, i3, i2, z4, getAvailableServices(i4, 2, z4), cellIdentity, getPlmnFromCellIdentity(cellIdentity), i, z3, z2, z, vopsSupportInfo);
        }

        private NetworkRegistrationInfo getNetworkRegistrationInfo(int i, int i2, android.hardware.radio.V1_5.RegStateResult regStateResult) {
            LteVopsSupportInfo lteVopsSupportInfo;
            boolean z;
            int i3;
            int i4;
            boolean z2;
            boolean z3;
            int i5;
            boolean z4;
            int i6 = i;
            android.hardware.radio.V1_5.RegStateResult regStateResult2 = regStateResult;
            int regStateFromHalRegState = getRegStateFromHalRegState(regStateResult2.regState);
            boolean isEmergencyOnly = isEmergencyOnly(regStateResult2.regState);
            List<Integer> availableServices = getAvailableServices(regStateFromHalRegState, i6, isEmergencyOnly);
            CellIdentity convertHalCellIdentity = RILUtils.convertHalCellIdentity((Object) regStateResult2.cellIdentity);
            String str = regStateResult2.registeredPlmn;
            int i7 = regStateResult2.reasonForDenial;
            int networkTypeForCellIdentity = CellularNetworkService.getNetworkTypeForCellIdentity(ServiceState.rilRadioTechnologyToNetworkType(regStateResult2.rat), convertHalCellIdentity, this.mPhone.getCarrierId());
            LteVopsSupportInfo lteVopsSupportInfo2 = new LteVopsSupportInfo(1, 1);
            byte discriminator = regStateResult2.accessTechnologySpecificInfo.getDiscriminator();
            if (discriminator == 1) {
                RegStateResult.AccessTechnologySpecificInfo.Cdma2000RegistrationInfo cdmaInfo = regStateResult2.accessTechnologySpecificInfo.cdmaInfo();
                boolean z5 = cdmaInfo.cssSupported;
                i5 = cdmaInfo.roamingIndicator;
                int i8 = cdmaInfo.systemIsInPrl;
                i3 = cdmaInfo.defaultRoamingIndicator;
                lteVopsSupportInfo = lteVopsSupportInfo2;
                i4 = i8;
                z3 = false;
                z2 = false;
                z = false;
                z4 = z5;
            } else if (discriminator != 2) {
                CellularNetworkService.log("No access tech specific info passes for RegStateResult");
                lteVopsSupportInfo = lteVopsSupportInfo2;
                z4 = false;
                i5 = 0;
                z3 = false;
                z2 = false;
                i4 = 0;
                i3 = 0;
                z = false;
            } else {
                RegStateResult.AccessTechnologySpecificInfo.EutranRegistrationInfo eutranInfo = regStateResult2.accessTechnologySpecificInfo.eutranInfo();
                NrIndicators nrIndicators = eutranInfo.nrIndicators;
                boolean z6 = nrIndicators.isDcNrRestricted;
                z2 = nrIndicators.isNrAvailable;
                boolean z7 = nrIndicators.isEndcAvailable;
                LteVopsInfo lteVopsInfo = eutranInfo.lteVopsInfo;
                lteVopsSupportInfo = convertHalLteVopsSupportInfo(lteVopsInfo.isVopsSupported, lteVopsInfo.isEmcBearerSupported);
                z = z7;
                z3 = z6;
                z4 = false;
                i5 = 0;
                i4 = 0;
                i3 = 0;
            }
            if (i6 == 1) {
                return new NetworkRegistrationInfo(i, i2, regStateFromHalRegState, networkTypeForCellIdentity, i7, isEmergencyOnly, availableServices, convertHalCellIdentity, str, z4, i5, i4, i3);
            }
            if (i6 != 2) {
                CellularNetworkService.loge("Unknown domain passed to CellularNetworkService= " + i6);
            }
            return new NetworkRegistrationInfo(i, i2, regStateFromHalRegState, networkTypeForCellIdentity, i7, isEmergencyOnly, availableServices, convertHalCellIdentity, str, 16, z3, z2, z, lteVopsSupportInfo);
        }

        /* JADX WARNING: Removed duplicated region for block: B:18:0x00d8  */
        /* JADX WARNING: Removed duplicated region for block: B:22:0x0102  */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        private android.telephony.NetworkRegistrationInfo getNetworkRegistrationInfoAidl(int r21, int r22, android.hardware.radio.network.RegStateResult r23) {
            /*
                r20 = this;
                r0 = r20
                r1 = r21
                r2 = r23
                int r3 = r2.regState
                int r3 = r0.getRegStateFromHalRegState(r3)
                int r4 = r2.regState
                boolean r6 = r0.isEmergencyOnly(r4)
                java.util.List r7 = r0.getAvailableServices(r3, r1, r6)
                android.hardware.radio.network.CellIdentity r4 = r2.cellIdentity
                android.telephony.CellIdentity r8 = com.android.internal.telephony.RILUtils.convertHalCellIdentity((android.hardware.radio.network.CellIdentity) r4)
                java.lang.String r9 = r2.registeredPlmn
                int r5 = r2.reasonForDenial
                int r4 = r2.rat
                int r4 = android.telephony.ServiceState.rilRadioTechnologyToNetworkType(r4)
                r10 = 19
                if (r4 != r10) goto L_0x002c
                r4 = 13
            L_0x002c:
                r10 = 0
                android.hardware.radio.network.AccessTechnologySpecificInfo r2 = r2.accessTechnologySpecificInfo
                int r11 = r2.getTag()
                r12 = 2
                r13 = 1
                if (r11 == r13) goto L_0x00b3
                if (r11 == r12) goto L_0x007a
                r0 = 3
                if (r11 == r0) goto L_0x0056
                r0 = 4
                if (r11 == r0) goto L_0x0047
                java.lang.String r0 = "No access tech specific info passes for RegStateResult"
                com.android.internal.telephony.CellularNetworkService.log(r0)
                r19 = r10
                goto L_0x006f
            L_0x0047:
                boolean r0 = r2.getGeranDtmSupported()
                r19 = r10
                r11 = 0
                r14 = 0
                r15 = 0
                r16 = 0
                r17 = 0
                goto L_0x00d3
            L_0x0056:
                android.telephony.NrVopsSupportInfo r0 = new android.telephony.NrVopsSupportInfo
                android.hardware.radio.network.NrVopsInfo r10 = r2.getNgranNrVopsInfo()
                byte r10 = r10.vopsSupported
                android.hardware.radio.network.NrVopsInfo r11 = r2.getNgranNrVopsInfo()
                byte r11 = r11.emcSupported
                android.hardware.radio.network.NrVopsInfo r2 = r2.getNgranNrVopsInfo()
                byte r2 = r2.emfSupported
                r0.<init>(r10, r11, r2)
                r19 = r0
            L_0x006f:
                r10 = 0
                r11 = 0
                r14 = 0
                r15 = 0
                r16 = 0
                r17 = 0
                r18 = 0
                goto L_0x00d6
            L_0x007a:
                android.hardware.radio.network.EutranRegistrationInfo r10 = r2.getEutranInfo()
                android.hardware.radio.network.NrIndicators r10 = r10.nrIndicators
                boolean r10 = r10.isDcNrRestricted
                android.hardware.radio.network.EutranRegistrationInfo r11 = r2.getEutranInfo()
                android.hardware.radio.network.NrIndicators r11 = r11.nrIndicators
                boolean r11 = r11.isNrAvailable
                android.hardware.radio.network.EutranRegistrationInfo r15 = r2.getEutranInfo()
                android.hardware.radio.network.NrIndicators r15 = r15.nrIndicators
                boolean r15 = r15.isEndcAvailable
                android.hardware.radio.network.EutranRegistrationInfo r14 = r2.getEutranInfo()
                android.hardware.radio.network.LteVopsInfo r14 = r14.lteVopsInfo
                boolean r14 = r14.isVopsSupported
                android.hardware.radio.network.EutranRegistrationInfo r2 = r2.getEutranInfo()
                android.hardware.radio.network.LteVopsInfo r2 = r2.lteVopsInfo
                boolean r2 = r2.isEmcBearerSupported
                android.telephony.LteVopsSupportInfo r0 = r0.convertHalLteVopsSupportInfo(r14, r2)
                r19 = r0
                r14 = r10
                r16 = r11
                r18 = r15
                r10 = 0
                r11 = 0
                r15 = 0
                r17 = 0
                goto L_0x00d6
            L_0x00b3:
                android.hardware.radio.network.Cdma2000RegistrationInfo r0 = r2.getCdmaInfo()
                boolean r0 = r0.cssSupported
                android.hardware.radio.network.Cdma2000RegistrationInfo r11 = r2.getCdmaInfo()
                int r11 = r11.roamingIndicator
                android.hardware.radio.network.Cdma2000RegistrationInfo r14 = r2.getCdmaInfo()
                int r14 = r14.systemIsInPrl
                android.hardware.radio.network.Cdma2000RegistrationInfo r2 = r2.getCdmaInfo()
                int r2 = r2.defaultRoamingIndicator
                r17 = r2
                r19 = r10
                r15 = r14
                r14 = 0
                r16 = 0
            L_0x00d3:
                r18 = 0
                r10 = r0
            L_0x00d6:
                if (r1 == r13) goto L_0x0102
                if (r1 == r12) goto L_0x00ee
                java.lang.StringBuilder r0 = new java.lang.StringBuilder
                r0.<init>()
                java.lang.String r2 = "Unknown domain passed to CellularNetworkService= "
                r0.append(r2)
                r0.append(r1)
                java.lang.String r0 = r0.toString()
                com.android.internal.telephony.CellularNetworkService.loge(r0)
            L_0x00ee:
                android.telephony.NetworkRegistrationInfo r15 = new android.telephony.NetworkRegistrationInfo
                r10 = 16
                r0 = r15
                r1 = r21
                r2 = r22
                r11 = r14
                r12 = r16
                r13 = r18
                r14 = r19
                r0.<init>(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14)
                return r15
            L_0x0102:
                android.telephony.NetworkRegistrationInfo r14 = new android.telephony.NetworkRegistrationInfo
                r0 = r14
                r1 = r21
                r2 = r22
                r12 = r15
                r13 = r17
                r0.<init>(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13)
                return r14
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.CellularNetworkService.CellularNetworkServiceProvider.getNetworkRegistrationInfoAidl(int, int, android.hardware.radio.network.RegStateResult):android.telephony.NetworkRegistrationInfo");
        }

        private NetworkRegistrationInfo getNetworkRegistrationInfo1_6(int i, int i2, android.hardware.radio.V1_6.RegStateResult regStateResult) {
            NrVopsSupportInfo nrVopsSupportInfo;
            boolean z;
            int i3;
            boolean z2;
            int i4;
            boolean z3;
            int i5;
            boolean z4;
            int i6 = i;
            android.hardware.radio.V1_6.RegStateResult regStateResult2 = regStateResult;
            int regStateFromHalRegState = getRegStateFromHalRegState(regStateResult2.regState);
            boolean isEmergencyOnly = isEmergencyOnly(regStateResult2.regState);
            List<Integer> availableServices = getAvailableServices(regStateFromHalRegState, i6, isEmergencyOnly);
            CellIdentity convertHalCellIdentity = RILUtils.convertHalCellIdentity((Object) regStateResult2.cellIdentity);
            String str = regStateResult2.registeredPlmn;
            int i7 = regStateResult2.reasonForDenial;
            int networkTypeForCellIdentity = CellularNetworkService.getNetworkTypeForCellIdentity(ServiceState.rilRadioTechnologyToNetworkType(regStateResult2.rat), convertHalCellIdentity, this.mPhone.getCarrierId());
            RegStateResult.AccessTechnologySpecificInfo accessTechnologySpecificInfo = regStateResult2.accessTechnologySpecificInfo;
            byte discriminator = accessTechnologySpecificInfo.getDiscriminator();
            if (discriminator == 1) {
                boolean z5 = accessTechnologySpecificInfo.cdmaInfo().cssSupported;
                int i8 = accessTechnologySpecificInfo.cdmaInfo().roamingIndicator;
                int i9 = accessTechnologySpecificInfo.cdmaInfo().systemIsInPrl;
                i3 = accessTechnologySpecificInfo.cdmaInfo().defaultRoamingIndicator;
                i4 = i9;
                nrVopsSupportInfo = null;
                z3 = false;
                z2 = false;
                z = false;
                i5 = i8;
                z4 = z5;
            } else if (discriminator != 2) {
                if (discriminator == 3) {
                    nrVopsSupportInfo = new NrVopsSupportInfo(accessTechnologySpecificInfo.ngranNrVopsInfo().vopsSupported, accessTechnologySpecificInfo.ngranNrVopsInfo().emcSupported, accessTechnologySpecificInfo.ngranNrVopsInfo().emfSupported);
                } else if (discriminator != 4) {
                    CellularNetworkService.log("No access tech specific info passes for RegStateResult");
                    nrVopsSupportInfo = null;
                } else {
                    z4 = accessTechnologySpecificInfo.geranDtmSupported();
                    nrVopsSupportInfo = null;
                    i5 = 0;
                    z3 = false;
                    i4 = 0;
                    z2 = false;
                    i3 = 0;
                    z = false;
                }
                z4 = false;
                i5 = 0;
                z3 = false;
                i4 = 0;
                z2 = false;
                i3 = 0;
                z = false;
            } else {
                boolean z6 = accessTechnologySpecificInfo.eutranInfo().nrIndicators.isDcNrRestricted;
                boolean z7 = accessTechnologySpecificInfo.eutranInfo().nrIndicators.isNrAvailable;
                boolean z8 = accessTechnologySpecificInfo.eutranInfo().nrIndicators.isEndcAvailable;
                nrVopsSupportInfo = convertHalLteVopsSupportInfo(accessTechnologySpecificInfo.eutranInfo().lteVopsInfo.isVopsSupported, accessTechnologySpecificInfo.eutranInfo().lteVopsInfo.isEmcBearerSupported);
                z2 = z7;
                z = z8;
                i5 = 0;
                i4 = 0;
                i3 = 0;
                z3 = z6;
                z4 = false;
            }
            if (i6 == 1) {
                return new NetworkRegistrationInfo(i, i2, regStateFromHalRegState, networkTypeForCellIdentity, i7, isEmergencyOnly, availableServices, convertHalCellIdentity, str, z4, i5, i4, i3);
            }
            if (i6 != 2) {
                CellularNetworkService.loge("Unknown domain passed to CellularNetworkService= " + i6);
            }
            return new NetworkRegistrationInfo(i, i2, regStateFromHalRegState, networkTypeForCellIdentity, i7, isEmergencyOnly, availableServices, convertHalCellIdentity, str, 16, z3, z2, z, nrVopsSupportInfo);
        }

        private LteVopsSupportInfo convertHalLteVopsSupportInfo(boolean z, boolean z2) {
            int i = 2;
            int i2 = z ? 2 : 3;
            if (!z2) {
                i = 3;
            }
            return new LteVopsSupportInfo(i2, i);
        }

        public void requestNetworkRegistrationInfo(int i, NetworkServiceCallback networkServiceCallback) {
            if (i == 1) {
                Message obtain = Message.obtain(this.mHandler, 1);
                this.mCallbackMap.put(obtain, networkServiceCallback);
                this.mPhone.mCi.getVoiceRegistrationState(obtain);
            } else if (i == 2) {
                Message obtain2 = Message.obtain(this.mHandler, 2);
                this.mCallbackMap.put(obtain2, networkServiceCallback);
                this.mPhone.mCi.getDataRegistrationState(obtain2);
            } else {
                CellularNetworkService.loge("requestNetworkRegistrationInfo invalid domain " + i);
                networkServiceCallback.onRequestNetworkRegistrationInfoComplete(2, (NetworkRegistrationInfo) null);
            }
        }

        public void close() {
            this.mCallbackMap.clear();
            this.mPhone.mCi.unregisterForNetworkStateChanged(this.mHandler);
        }
    }

    @VisibleForTesting
    public static int getNetworkTypeForCellIdentity(int i, CellIdentity cellIdentity, int i2) {
        if (cellIdentity == null) {
            if (i != 0) {
                AnomalyReporter.reportAnomaly(UUID.fromString("e67ea4ef-7251-4a69-a063-22c47fc58743"), "RIL Unexpected NetworkType", i2);
                if (Build.isDebuggable()) {
                    logw("Updating incorrect network type from " + TelephonyManager.getNetworkTypeName(i) + " to UNKNOWN");
                    return 0;
                }
                for (List<Integer> contains : sNetworkTypes.values()) {
                    if (contains.contains(Integer.valueOf(i))) {
                        return i;
                    }
                }
            }
            return 0;
        } else if (i == 18) {
            AnomalyReporter.reportAnomaly(UUID.fromString("07dfa183-b2e7-42b7-98a1-dd5ae2abdd4f"), "RIL Reported IWLAN", i2);
            if (!Build.isDebuggable()) {
                return i;
            }
            Map<Class<? extends CellIdentity>, List<Integer>> map = sNetworkTypes;
            if (map.containsKey(cellIdentity.getClass())) {
                int intValue = ((Integer) map.get(cellIdentity.getClass()).get(0)).intValue();
                logw("Updating incorrect network type from IWLAN to " + intValue);
                return intValue;
            }
            logw("Updating incorrect network type from IWLAN to UNKNOWN");
            return 0;
        } else {
            Map<Class<? extends CellIdentity>, List<Integer>> map2 = sNetworkTypes;
            if (!map2.containsKey(cellIdentity.getClass())) {
                AnomalyReporter.reportAnomaly(UUID.fromString("469858cf-46e5-416e-bc11-5e7970917857"), "RIL Unknown CellIdentity", i2);
                return i;
            }
            List list = map2.get(cellIdentity.getClass());
            if (list.contains(Integer.valueOf(i))) {
                return i;
            }
            AnomalyReporter.reportAnomaly(UUID.fromString("2fb634fa-cab3-44d2-bbe8-c7689b0f3e31"), "RIL Mismatched NetworkType", i2);
            logw("Updating incorrect network type from " + TelephonyManager.getNetworkTypeName(i) + " to " + TelephonyManager.getNetworkTypeName(((Integer) list.get(0)).intValue()));
            return ((Integer) list.get(0)).intValue();
        }
    }

    public NetworkService.NetworkServiceProvider onCreateNetworkServiceProvider(int i) {
        if (SubscriptionManager.isValidSlotIndex(i)) {
            return new CellularNetworkServiceProvider(i);
        }
        loge("Tried to Cellular network service with invalid slotId " + i);
        return null;
    }

    /* access modifiers changed from: private */
    public static void log(String str) {
        Rlog.d(TAG, str);
    }

    private static void logw(String str) {
        Rlog.w(TAG, str);
    }

    /* access modifiers changed from: private */
    public static void loge(String str) {
        Rlog.e(TAG, str);
    }
}
