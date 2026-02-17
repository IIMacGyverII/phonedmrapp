package com.android.internal.telephony;

import android.hardware.radio.V1_0.Carrier;
import android.hardware.radio.V1_0.CdmaSignalStrength;
import android.hardware.radio.V1_0.CdmaSmsMessage;
import android.hardware.radio.V1_0.CdmaSmsSubaddress;
import android.hardware.radio.V1_0.CellInfoCdma;
import android.hardware.radio.V1_0.CellInfoGsm;
import android.hardware.radio.V1_0.CellInfoLte;
import android.hardware.radio.V1_0.CellInfoTdscdma;
import android.hardware.radio.V1_0.CellInfoWcdma;
import android.hardware.radio.V1_0.DataProfileInfo;
import android.hardware.radio.V1_0.Dial;
import android.hardware.radio.V1_0.EvdoSignalStrength;
import android.hardware.radio.V1_0.GsmSignalStrength;
import android.hardware.radio.V1_0.GsmSmsMessage;
import android.hardware.radio.V1_0.HardwareConfig;
import android.hardware.radio.V1_0.HardwareConfigModem;
import android.hardware.radio.V1_0.HardwareConfigSim;
import android.hardware.radio.V1_0.LceDataInfo;
import android.hardware.radio.V1_0.LteSignalStrength;
import android.hardware.radio.V1_0.RadioCapability;
import android.hardware.radio.V1_0.SimApdu;
import android.hardware.radio.V1_0.TdScdmaSignalStrength;
import android.hardware.radio.V1_0.UusInfo;
import android.hardware.radio.V1_0.WcdmaSignalStrength;
import android.hardware.radio.V1_2.CellIdentityOperatorNames;
import android.hardware.radio.V1_2.TdscdmaSignalStrength;
import android.hardware.radio.V1_4.CellInfoNr;
import android.hardware.radio.V1_4.NrSignalStrength;
import android.hardware.radio.V1_5.BarringInfo;
import android.hardware.radio.V1_5.LinkAddress;
import android.hardware.radio.V1_5.OptionalCsgInfo;
import android.hardware.radio.V1_5.RadioAccessSpecifier;
import android.hardware.radio.V1_5.SignalThresholdInfo;
import android.hardware.radio.V1_6.EpsQos;
import android.hardware.radio.V1_6.MaybePort;
import android.hardware.radio.V1_6.NrQos;
import android.hardware.radio.V1_6.OptionalDnn;
import android.hardware.radio.V1_6.OptionalOsAppId;
import android.hardware.radio.V1_6.OptionalSliceInfo;
import android.hardware.radio.V1_6.OptionalTrafficDescriptor;
import android.hardware.radio.V1_6.OsAppId;
import android.hardware.radio.V1_6.PhonebookCapacity;
import android.hardware.radio.V1_6.PortRange;
import android.hardware.radio.V1_6.QosBandwidth;
import android.hardware.radio.V1_6.QosFilter;
import android.hardware.radio.V1_6.SliceInfo;
import android.hardware.radio.V1_6.SlicingConfig;
import android.hardware.radio.config.SlotPortMapping;
import android.hardware.radio.data.QosFilterIpsecSpi;
import android.hardware.radio.data.QosFilterIpv6FlowLabel;
import android.hardware.radio.data.QosFilterTypeOfService;
import android.hardware.radio.data.QosSession;
import android.hardware.radio.data.SetupDataCallResult;
import android.hardware.radio.messaging.CdmaSmsAddress;
import android.hardware.radio.network.BarringTypeSpecificInfo;
import android.hardware.radio.network.OperatorInfo;
import android.hardware.radio.network.RadioAccessSpecifierBands;
import android.hardware.radio.sim.AppStatus;
import android.hardware.radio.sim.CardStatus;
import android.hardware.radio.sim.PhonebookRecordInfo;
import android.hardware.radio.voice.Call;
import android.net.InetAddresses;
import android.net.LinkProperties;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.service.carrier.CarrierIdentifier;
import android.telephony.BarringInfo;
import android.telephony.CellConfigLte;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityCdma;
import android.telephony.CellIdentityGsm;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityNr;
import android.telephony.CellIdentityTdscdma;
import android.telephony.CellIdentityWcdma;
import android.telephony.CellInfo;
import android.telephony.CellSignalStrength;
import android.telephony.CellSignalStrengthCdma;
import android.telephony.CellSignalStrengthGsm;
import android.telephony.CellSignalStrengthLte;
import android.telephony.CellSignalStrengthNr;
import android.telephony.CellSignalStrengthTdscdma;
import android.telephony.CellSignalStrengthWcdma;
import android.telephony.ClosedSubscriberGroupInfo;
import android.telephony.LinkCapacityEstimate;
import android.telephony.ModemInfo;
import android.telephony.PhoneCapability;
import android.telephony.PhoneNumberUtils;
import android.telephony.RadioAccessSpecifier;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.UiccSlotMapping;
import android.telephony.data.ApnSetting;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.NetworkSlicingConfig;
import android.telephony.data.Qos;
import android.telephony.data.QosBearerFilter;
import android.telephony.data.QosBearerSession;
import android.telephony.data.RouteSelectionDescriptor;
import android.telephony.data.TrafficDescriptor;
import android.telephony.data.UrspRule;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.SparseArray;
import androidx.core.os.EnvironmentCompat;
import androidx.core.view.InputDeviceCompat;
import androidx.core.view.PointerIconCompat;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.cat.BerTlv;
import com.android.internal.telephony.cat.ComprehensionTlv;
import com.android.internal.telephony.cat.ComprehensionTlvTag;
import com.android.internal.telephony.cdma.SmsMessage;
import com.android.internal.telephony.cdma.sms.SmsEnvelope;
import com.android.internal.telephony.data.KeepaliveStatus;
import com.android.internal.telephony.uicc.AdnCapacity;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.IccSlotPortMapping;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.SimPhonebookRecord;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.InterPhoneService;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import kotlin.UByte;

public class RILUtils {
    public static final int CDMA_BROADCAST_SMS_NO_OF_SERVICE_CATEGORIES = 31;
    public static final int CDMA_BSI_NO_OF_INTS_STRUCT = 3;
    public static final String RADIO_POWER_FAILURE_BUGREPORT_UUID = "316f3801-fa21-4954-a42f-0041eada3b31";
    public static final String RADIO_POWER_FAILURE_NO_RF_CALIBRATION_UUID = "316f3801-fa21-4954-a42f-0041eada3b33";
    public static final String RADIO_POWER_FAILURE_RF_HARDWARE_ISSUE_UUID = "316f3801-fa21-4954-a42f-0041eada3b32";
    private static final String TAG = "RILUtils";
    private static final Set<Class> WRAPPER_CLASSES = new HashSet(Arrays.asList(new Class[]{Boolean.class, Character.class, Byte.class, Short.class, Integer.class, Long.class, Float.class, Double.class}));

    public static int convertHalCellConnectionStatus(int i) {
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                return -1;
            }
        }
        return i2;
    }

    @KeepaliveStatus.KeepaliveStatusCode
    public static int convertHalKeepaliveStatusCode(int i) {
        if (i == 0) {
            return 0;
        }
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                return -1;
            }
        }
        return i2;
    }

    public static int convertHalNetworkTypeBitMask(int i) {
        int i2 = (65536 & i) != 0 ? (int) (((long) 0) | 32768) : 0;
        if ((i & 2) != 0) {
            i2 = (int) (((long) i2) | 1);
        }
        if ((i & 4) != 0) {
            i2 = (int) (((long) i2) | 2);
        }
        if ((i & 16) != 0) {
            i2 = (int) (((long) i2) | 8);
        }
        if ((i & 32) != 0) {
            i2 = (int) (((long) i2) | 8);
        }
        if ((i & 64) != 0) {
            i2 = (int) (((long) i2) | 64);
        }
        if ((i & 128) != 0) {
            i2 = (int) (((long) i2) | 16);
        }
        if ((i & 256) != 0) {
            i2 = (int) (((long) i2) | 32);
        }
        if ((i & 4096) != 0) {
            i2 = (int) (((long) i2) | 2048);
        }
        if ((i & 8192) != 0) {
            i2 = (int) (((long) i2) | 8192);
        }
        if ((i & 1024) != 0) {
            i2 = (int) (((long) i2) | 256);
        }
        if ((i & 512) != 0) {
            i2 = (int) (((long) i2) | 128);
        }
        if ((i & 2048) != 0) {
            i2 = (int) (((long) i2) | 512);
        }
        if ((32768 & i) != 0) {
            i2 = (int) (((long) i2) | 16384);
        }
        if ((i & 8) != 0) {
            i2 = (int) (((long) i2) | 4);
        }
        if ((131072 & i) != 0) {
            i2 = (int) (((long) i2) | 65536);
        }
        if ((i & 16384) != 0) {
            i2 = (int) (((long) i2) | 4096);
        }
        if ((524288 & i) != 0) {
            i2 = (int) (((long) i2) | 262144);
        }
        if ((1048576 & i) != 0) {
            i2 = (int) (((long) i2) | 524288);
        }
        if ((i & 262144) != 0) {
            i2 = (int) (((long) i2) | 131072);
        }
        if (i2 == 0) {
            return 0;
        }
        return i2;
    }

    public static String convertHalOperatorStatus(int i) {
        return i == 0 ? EnvironmentCompat.MEDIA_UNKNOWN : i == 1 ? "available" : i == 2 ? "current" : i == 3 ? "forbidden" : "";
    }

    public static int convertHalRadioAccessNetworks(int i) {
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                i2 = 3;
                if (i != 3) {
                    if (i != 4) {
                        return i != 5 ? 0 : 4;
                    }
                    return 6;
                }
            }
        }
        return i2;
    }

    public static String convertNullToEmptyString(String str) {
        return str != null ? str : "";
    }

    public static int convertToHalAccessNetwork(int i) {
        switch (i) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 3;
            case 4:
                return 4;
            case 5:
                return 5;
            case 6:
                return 6;
            default:
                return 0;
        }
    }

    public static int convertToHalAccessNetworkAidl(int i) {
        switch (i) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 3;
            case 4:
                return 4;
            case 5:
                return 5;
            case 6:
                return 6;
            default:
                return 0;
        }
    }

    public static int convertToHalRadioAccessFamily(int i) {
        long j = (long) i;
        int i2 = (32768 & j) != 0 ? 65536 : 0;
        if ((1 & j) != 0) {
            i2 |= 2;
        }
        if ((2 & j) != 0) {
            i2 |= 4;
        }
        if ((8 & j) != 0) {
            i2 |= 16;
        }
        if ((64 & j) != 0) {
            i2 |= 64;
        }
        if ((16 & j) != 0) {
            i2 |= 128;
        }
        if ((32 & j) != 0) {
            i2 |= 256;
        }
        if ((2048 & j) != 0) {
            i2 |= 4096;
        }
        if ((8192 & j) != 0) {
            i2 |= 8192;
        }
        if ((256 & j) != 0) {
            i2 |= 1024;
        }
        if ((128 & j) != 0) {
            i2 |= 512;
        }
        if ((512 & j) != 0) {
            i2 |= 2048;
        }
        if ((16384 & j) != 0) {
            i2 |= 32768;
        }
        if ((4 & j) != 0) {
            i2 |= 8;
        }
        if ((65536 & j) != 0) {
            i2 |= 131072;
        }
        if ((131072 & j) != 0) {
            i2 |= 262144;
        }
        if ((4096 & j) != 0) {
            i2 |= 16384;
        }
        if ((262144 & j) != 0) {
            i2 |= 524288;
        }
        if ((j & 524288) != 0) {
            i2 |= 1048576;
        }
        if (i2 == 0) {
            return 1;
        }
        return i2;
    }

    public static int convertToHalRadioAccessFamilyAidl(int i) {
        long j = (long) i;
        int i2 = (32768 & j) != 0 ? 65536 : 0;
        if ((1 & j) != 0) {
            i2 |= 2;
        }
        if ((2 & j) != 0) {
            i2 |= 4;
        }
        if ((8 & j) != 0) {
            i2 |= 16;
        }
        if ((64 & j) != 0) {
            i2 |= 64;
        }
        if ((16 & j) != 0) {
            i2 |= 128;
        }
        if ((32 & j) != 0) {
            i2 |= 256;
        }
        if ((2048 & j) != 0) {
            i2 |= 4096;
        }
        if ((8192 & j) != 0) {
            i2 |= 8192;
        }
        if ((256 & j) != 0) {
            i2 |= 1024;
        }
        if ((128 & j) != 0) {
            i2 |= 512;
        }
        if ((512 & j) != 0) {
            i2 |= 2048;
        }
        if ((16384 & j) != 0) {
            i2 |= 32768;
        }
        if ((4 & j) != 0) {
            i2 |= 8;
        }
        if ((65536 & j) != 0) {
            i2 |= 131072;
        }
        if ((131072 & j) != 0) {
            i2 |= 262144;
        }
        if ((4096 & j) != 0) {
            i2 |= 16384;
        }
        if ((262144 & j) != 0) {
            i2 |= 524288;
        }
        if ((j & 524288) != 0) {
            i2 |= 1048576;
        }
        if (i2 == 0) {
            return 1;
        }
        return i2;
    }

    public static int convertToHalRadioAccessNetworks(int i) {
        int i2 = 1;
        if (i != 1) {
            i2 = 2;
            if (i != 2) {
                i2 = 3;
                if (i != 3) {
                    if (i != 4) {
                        return i != 6 ? 0 : 4;
                    }
                    return 5;
                }
            }
        }
        return i2;
    }

    public static int convertToHalResetNvType(int i) {
        if (i == 1) {
            return 0;
        }
        if (i != 2) {
            return i != 3 ? -1 : 2;
        }
        return 1;
    }

    public static int convertToHalResetNvTypeAidl(int i) {
        if (i == 1) {
            return 0;
        }
        if (i != 2) {
            return i != 3 ? -1 : 2;
        }
        return 1;
    }

    public static int convertToHalSimLockMultiSimPolicy(int i) {
        return i != 1 ? 0 : 1;
    }

    public static int convertToHalSimLockMultiSimPolicyAidl(int i) {
        return i != 1 ? 0 : 1;
    }

    public static int convertToHalSmsWriteArgsStatus(int i) {
        int i2 = i & 7;
        if (i2 == 3) {
            return 0;
        }
        if (i2 != 5) {
            return i2 != 7 ? 1 : 2;
        }
        return 3;
    }

    public static int convertToHalSmsWriteArgsStatusAidl(int i) {
        int i2 = i & 7;
        if (i2 == 3) {
            return 0;
        }
        if (i2 != 5) {
            return i2 != 7 ? 1 : 2;
        }
        return 3;
    }

    /* renamed from: com.android.internal.telephony.RILUtils$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState;

        /* JADX WARNING: Can't wrap try/catch for region: R(68:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|(3:67|68|70)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(70:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|70) */
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
        /* JADX WARNING: Missing exception handler attribute for start block: B:47:0x0114 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:49:0x0120 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:51:0x012c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:53:0x0138 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:55:0x0144 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:57:0x0150 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:59:0x015c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:61:0x0168 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:63:0x0174 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:65:0x0180 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:67:0x018c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState[] r0 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState = r0
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_IN_PROGRESS     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_READY     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NETWORK     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NETWORK_SUBSET     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_CORPORATE     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SERVICE_PROVIDER     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SIM     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NETWORK_PUK     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NETWORK_SUBSET_PUK     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_CORPORATE_PUK     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SERVICE_PROVIDER_PUK     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r2 = 11
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SIM_PUK     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r2 = 12
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_NETWORK1     // Catch:{ NoSuchFieldError -> 0x009c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r2 = 13
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_NETWORK2     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r2 = 14
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_HRPD     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r2 = 15
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_CORPORATE     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_SERVICE_PROVIDER     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r2 = 17
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_RUIM     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00e4 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_NETWORK1_PUK     // Catch:{ NoSuchFieldError -> 0x00e4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e4 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00e4 }
            L_0x00e4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00f0 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_NETWORK2_PUK     // Catch:{ NoSuchFieldError -> 0x00f0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f0 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f0 }
            L_0x00f0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x00fc }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_HRPD_PUK     // Catch:{ NoSuchFieldError -> 0x00fc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fc }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00fc }
            L_0x00fc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0108 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_CORPORATE_PUK     // Catch:{ NoSuchFieldError -> 0x0108 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0108 }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0108 }
            L_0x0108:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0114 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_SERVICE_PROVIDER_PUK     // Catch:{ NoSuchFieldError -> 0x0114 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0114 }
                r2 = 23
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0114 }
            L_0x0114:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0120 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_RUIM_RUIM_PUK     // Catch:{ NoSuchFieldError -> 0x0120 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0120 }
                r2 = 24
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0120 }
            L_0x0120:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x012c }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SPN     // Catch:{ NoSuchFieldError -> 0x012c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x012c }
                r2 = 25
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x012c }
            L_0x012c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0138 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SPN_PUK     // Catch:{ NoSuchFieldError -> 0x0138 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0138 }
                r2 = 26
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0138 }
            L_0x0138:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0144 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SP_EHPLMN     // Catch:{ NoSuchFieldError -> 0x0144 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0144 }
                r2 = 27
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0144 }
            L_0x0144:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0150 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_SP_EHPLMN_PUK     // Catch:{ NoSuchFieldError -> 0x0150 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0150 }
                r2 = 28
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0150 }
            L_0x0150:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x015c }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_ICCID     // Catch:{ NoSuchFieldError -> 0x015c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x015c }
                r2 = 29
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x015c }
            L_0x015c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0168 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_ICCID_PUK     // Catch:{ NoSuchFieldError -> 0x0168 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0168 }
                r2 = 30
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0168 }
            L_0x0168:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0174 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_IMPI     // Catch:{ NoSuchFieldError -> 0x0174 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0174 }
                r2 = 31
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0174 }
            L_0x0174:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0180 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_IMPI_PUK     // Catch:{ NoSuchFieldError -> 0x0180 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0180 }
                r2 = 32
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0180 }
            L_0x0180:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x018c }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NS_SP     // Catch:{ NoSuchFieldError -> 0x018c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x018c }
                r2 = 33
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x018c }
            L_0x018c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0198 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_SIM_NS_SP_PUK     // Catch:{ NoSuchFieldError -> 0x0198 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0198 }
                r2 = 34
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0198 }
            L_0x0198:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.AnonymousClass1.<clinit>():void");
        }
    }

    public static int convertToHalPersoType(IccCardApplicationStatus.PersoSubState persoSubState) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState[persoSubState.ordinal()]) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 3;
            case 4:
                return 4;
            case 5:
                return 5;
            case 6:
                return 6;
            case 7:
                return 7;
            case 8:
                return 8;
            case 9:
                return 9;
            case 10:
                return 10;
            case 11:
                return 11;
            case 12:
                return 12;
            case 13:
                return 13;
            case 14:
                return 14;
            case 15:
                return 15;
            case 16:
                return 16;
            case 17:
                return 17;
            case 18:
                return 18;
            case 19:
                return 19;
            case 20:
                return 20;
            case 21:
                return 21;
            case 22:
                return 22;
            case 23:
                return 23;
            case 24:
                return 24;
            case 25:
                return 25;
            case 26:
                return 26;
            case 27:
                return 27;
            case 28:
                return 28;
            case 29:
                return 29;
            case 30:
                return 30;
            case 31:
                return 31;
            case 32:
                return 32;
            case 33:
                return 33;
            case 34:
                return 34;
            default:
                return 0;
        }
    }

    public static int convertToHalPersoTypeAidl(IccCardApplicationStatus.PersoSubState persoSubState) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState[persoSubState.ordinal()]) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 3;
            case 4:
                return 4;
            case 5:
                return 5;
            case 6:
                return 6;
            case 7:
                return 7;
            case 8:
                return 8;
            case 9:
                return 9;
            case 10:
                return 10;
            case 11:
                return 11;
            case 12:
                return 12;
            case 13:
                return 13;
            case 14:
                return 14;
            case 15:
                return 15;
            case 16:
                return 16;
            case 17:
                return 17;
            case 18:
                return 18;
            case 19:
                return 19;
            case 20:
                return 20;
            case 21:
                return 21;
            case 22:
                return 22;
            case 23:
                return 23;
            case 24:
                return 24;
            case 25:
                return 25;
            case 26:
                return 26;
            case 27:
                return 27;
            case 28:
                return 28;
            case 29:
                return 29;
            case 30:
                return 30;
            case 31:
                return 31;
            case 32:
                return 32;
            case 33:
                return 33;
            case 34:
                return 34;
            default:
                return 0;
        }
    }

    public static GsmSmsMessage convertToHalGsmSmsMessage(String str, String str2) {
        GsmSmsMessage gsmSmsMessage = new GsmSmsMessage();
        if (str == null) {
            str = "";
        }
        gsmSmsMessage.smscPdu = str;
        if (str2 == null) {
            str2 = "";
        }
        gsmSmsMessage.pdu = str2;
        return gsmSmsMessage;
    }

    public static android.hardware.radio.messaging.GsmSmsMessage convertToHalGsmSmsMessageAidl(String str, String str2) {
        android.hardware.radio.messaging.GsmSmsMessage gsmSmsMessage = new android.hardware.radio.messaging.GsmSmsMessage();
        gsmSmsMessage.smscPdu = convertNullToEmptyString(str);
        gsmSmsMessage.pdu = convertNullToEmptyString(str2);
        return gsmSmsMessage;
    }

    public static CdmaSmsMessage convertToHalCdmaSmsMessage(byte[] bArr) {
        CdmaSmsMessage cdmaSmsMessage = new CdmaSmsMessage();
        DataInputStream dataInputStream = new DataInputStream(new ByteArrayInputStream(bArr));
        try {
            cdmaSmsMessage.teleserviceId = dataInputStream.readInt();
            boolean z = true;
            cdmaSmsMessage.isServicePresent = ((byte) dataInputStream.readInt()) == 1;
            cdmaSmsMessage.serviceCategory = dataInputStream.readInt();
            cdmaSmsMessage.address.digitMode = dataInputStream.read();
            cdmaSmsMessage.address.numberMode = dataInputStream.read();
            cdmaSmsMessage.address.numberType = dataInputStream.read();
            cdmaSmsMessage.address.numberPlan = dataInputStream.read();
            byte read = (byte) dataInputStream.read();
            for (int i = 0; i < read; i++) {
                cdmaSmsMessage.address.digits.add(Byte.valueOf(dataInputStream.readByte()));
            }
            cdmaSmsMessage.subAddress.subaddressType = dataInputStream.read();
            CdmaSmsSubaddress cdmaSmsSubaddress = cdmaSmsMessage.subAddress;
            if (((byte) dataInputStream.read()) != 1) {
                z = false;
            }
            cdmaSmsSubaddress.odd = z;
            byte read2 = (byte) dataInputStream.read();
            for (int i2 = 0; i2 < read2; i2++) {
                cdmaSmsMessage.subAddress.digits.add(Byte.valueOf(dataInputStream.readByte()));
            }
            int read3 = dataInputStream.read();
            for (int i3 = 0; i3 < read3; i3++) {
                cdmaSmsMessage.bearerData.add(Byte.valueOf(dataInputStream.readByte()));
            }
        } catch (IOException unused) {
        }
        return cdmaSmsMessage;
    }

    public static android.hardware.radio.messaging.CdmaSmsMessage convertToHalCdmaSmsMessageAidl(byte[] bArr) {
        android.hardware.radio.messaging.CdmaSmsMessage cdmaSmsMessage = new android.hardware.radio.messaging.CdmaSmsMessage();
        cdmaSmsMessage.address = new CdmaSmsAddress();
        cdmaSmsMessage.subAddress = new android.hardware.radio.messaging.CdmaSmsSubaddress();
        DataInputStream dataInputStream = new DataInputStream(new ByteArrayInputStream(bArr));
        try {
            cdmaSmsMessage.teleserviceId = dataInputStream.readInt();
            boolean z = true;
            cdmaSmsMessage.isServicePresent = ((byte) dataInputStream.readInt()) == 1;
            cdmaSmsMessage.serviceCategory = dataInputStream.readInt();
            CdmaSmsAddress cdmaSmsAddress = new CdmaSmsAddress();
            cdmaSmsMessage.address = cdmaSmsAddress;
            cdmaSmsAddress.digitMode = dataInputStream.read();
            cdmaSmsMessage.address.isNumberModeDataNetwork = dataInputStream.read() == 1;
            cdmaSmsMessage.address.numberType = dataInputStream.read();
            cdmaSmsMessage.address.numberPlan = dataInputStream.read();
            int read = (byte) dataInputStream.read();
            byte[] bArr2 = new byte[read];
            for (int i = 0; i < read; i++) {
                bArr2[i] = dataInputStream.readByte();
            }
            cdmaSmsMessage.address.digits = bArr2;
            android.hardware.radio.messaging.CdmaSmsSubaddress cdmaSmsSubaddress = new android.hardware.radio.messaging.CdmaSmsSubaddress();
            cdmaSmsMessage.subAddress = cdmaSmsSubaddress;
            cdmaSmsSubaddress.subaddressType = dataInputStream.read();
            android.hardware.radio.messaging.CdmaSmsSubaddress cdmaSmsSubaddress2 = cdmaSmsMessage.subAddress;
            if (((byte) dataInputStream.read()) != 1) {
                z = false;
            }
            cdmaSmsSubaddress2.odd = z;
            int read2 = (byte) dataInputStream.read();
            byte[] bArr3 = new byte[read2];
            for (int i2 = 0; i2 < read2; i2++) {
                bArr3[i2] = dataInputStream.readByte();
            }
            cdmaSmsMessage.subAddress.digits = bArr3;
            int read3 = dataInputStream.read();
            byte[] bArr4 = new byte[read3];
            for (int i3 = 0; i3 < read3; i3++) {
                bArr4[i3] = dataInputStream.readByte();
            }
            cdmaSmsMessage.bearerData = bArr4;
        } catch (IOException unused) {
        }
        return cdmaSmsMessage;
    }

    public static SmsMessage convertHalCdmaSmsMessage(CdmaSmsMessage cdmaSmsMessage) {
        SmsEnvelope smsEnvelope = new SmsEnvelope();
        com.android.internal.telephony.cdma.sms.CdmaSmsAddress cdmaSmsAddress = new com.android.internal.telephony.cdma.sms.CdmaSmsAddress();
        com.android.internal.telephony.cdma.sms.CdmaSmsSubaddress cdmaSmsSubaddress = new com.android.internal.telephony.cdma.sms.CdmaSmsSubaddress();
        int i = cdmaSmsMessage.teleserviceId;
        smsEnvelope.teleService = i;
        if (cdmaSmsMessage.isServicePresent) {
            smsEnvelope.messageType = 1;
        } else if (i == 0) {
            smsEnvelope.messageType = 2;
        } else {
            smsEnvelope.messageType = 0;
        }
        smsEnvelope.serviceCategory = cdmaSmsMessage.serviceCategory;
        android.hardware.radio.V1_0.CdmaSmsAddress cdmaSmsAddress2 = cdmaSmsMessage.address;
        int i2 = cdmaSmsAddress2.digitMode;
        cdmaSmsAddress.digitMode = (byte) (i2 & 255);
        cdmaSmsAddress.numberMode = (byte) (cdmaSmsAddress2.numberMode & 255);
        cdmaSmsAddress.ton = cdmaSmsAddress2.numberType;
        cdmaSmsAddress.numberPlan = (byte) (cdmaSmsAddress2.numberPlan & 255);
        int size = (byte) cdmaSmsAddress2.digits.size();
        cdmaSmsAddress.numberOfDigits = size;
        byte[] bArr = new byte[size];
        for (int i3 = 0; i3 < size; i3++) {
            byte byteValue = ((Byte) cdmaSmsMessage.address.digits.get(i3)).byteValue();
            bArr[i3] = byteValue;
            if (i2 == 0) {
                bArr[i3] = SmsMessage.convertDtmfToAscii(byteValue);
            }
        }
        cdmaSmsAddress.origBytes = bArr;
        CdmaSmsSubaddress cdmaSmsSubaddress2 = cdmaSmsMessage.subAddress;
        cdmaSmsSubaddress.type = cdmaSmsSubaddress2.subaddressType;
        cdmaSmsSubaddress.odd = cdmaSmsSubaddress2.odd ? (byte) 1 : 0;
        int size2 = (byte) cdmaSmsSubaddress2.digits.size();
        if (size2 < 0) {
            size2 = 0;
        }
        byte[] bArr2 = new byte[size2];
        for (int i4 = 0; i4 < size2; i4++) {
            bArr2[i4] = ((Byte) cdmaSmsMessage.subAddress.digits.get(i4)).byteValue();
        }
        cdmaSmsSubaddress.origBytes = bArr2;
        int size3 = cdmaSmsMessage.bearerData.size();
        if (size3 < 0) {
            size3 = 0;
        }
        byte[] bArr3 = new byte[size3];
        for (int i5 = 0; i5 < size3; i5++) {
            bArr3[i5] = ((Byte) cdmaSmsMessage.bearerData.get(i5)).byteValue();
        }
        smsEnvelope.bearerData = bArr3;
        smsEnvelope.origAddress = cdmaSmsAddress;
        smsEnvelope.origSubaddress = cdmaSmsSubaddress;
        return new SmsMessage(cdmaSmsAddress, smsEnvelope);
    }

    public static SmsMessage convertHalCdmaSmsMessage(android.hardware.radio.messaging.CdmaSmsMessage cdmaSmsMessage) {
        SmsEnvelope smsEnvelope = new SmsEnvelope();
        com.android.internal.telephony.cdma.sms.CdmaSmsAddress cdmaSmsAddress = new com.android.internal.telephony.cdma.sms.CdmaSmsAddress();
        com.android.internal.telephony.cdma.sms.CdmaSmsSubaddress cdmaSmsSubaddress = new com.android.internal.telephony.cdma.sms.CdmaSmsSubaddress();
        CdmaSmsAddress cdmaSmsAddress2 = cdmaSmsMessage.address;
        int i = cdmaSmsAddress2.digitMode;
        cdmaSmsAddress.digitMode = (byte) (i & 255);
        cdmaSmsAddress.numberMode = cdmaSmsAddress2.isNumberModeDataNetwork & true ? (byte) 1 : 0;
        cdmaSmsAddress.ton = cdmaSmsAddress2.numberType;
        cdmaSmsAddress.numberPlan = (byte) (cdmaSmsAddress2.numberPlan & 255);
        byte[] bArr = cdmaSmsAddress2.digits;
        cdmaSmsAddress.numberOfDigits = bArr.length;
        int length = bArr.length;
        byte[] bArr2 = new byte[length];
        for (int i2 = 0; i2 < length; i2++) {
            byte b = cdmaSmsMessage.address.digits[i2];
            bArr2[i2] = b;
            if (i == 0) {
                bArr2[i2] = SmsMessage.convertDtmfToAscii(b);
            }
        }
        cdmaSmsAddress.origBytes = bArr2;
        android.hardware.radio.messaging.CdmaSmsSubaddress cdmaSmsSubaddress2 = cdmaSmsMessage.subAddress;
        cdmaSmsSubaddress.type = cdmaSmsSubaddress2.subaddressType;
        cdmaSmsSubaddress.odd = cdmaSmsSubaddress2.odd ? (byte) 1 : 0;
        cdmaSmsSubaddress.origBytes = cdmaSmsSubaddress2.digits;
        int i3 = cdmaSmsMessage.teleserviceId;
        smsEnvelope.teleService = i3;
        if (cdmaSmsMessage.isServicePresent) {
            smsEnvelope.messageType = 1;
        } else if (i3 == 0) {
            smsEnvelope.messageType = 2;
        } else {
            smsEnvelope.messageType = 0;
        }
        smsEnvelope.serviceCategory = cdmaSmsMessage.serviceCategory;
        smsEnvelope.bearerData = cdmaSmsMessage.bearerData;
        smsEnvelope.origAddress = cdmaSmsAddress;
        smsEnvelope.origSubaddress = cdmaSmsSubaddress;
        return new SmsMessage(cdmaSmsAddress, smsEnvelope);
    }

    public static DataProfileInfo convertToHalDataProfile10(DataProfile dataProfile) {
        DataProfileInfo dataProfileInfo = new DataProfileInfo();
        dataProfileInfo.profileId = dataProfile.getProfileId();
        dataProfileInfo.apn = dataProfile.getApn();
        dataProfileInfo.protocol = ApnSetting.getProtocolStringFromInt(dataProfile.getProtocolType());
        dataProfileInfo.roamingProtocol = ApnSetting.getProtocolStringFromInt(dataProfile.getRoamingProtocolType());
        dataProfileInfo.authType = dataProfile.getAuthType();
        dataProfileInfo.user = TextUtils.emptyIfNull(dataProfile.getUserName());
        dataProfileInfo.password = TextUtils.emptyIfNull(dataProfile.getPassword());
        dataProfileInfo.type = dataProfile.getType();
        dataProfileInfo.maxConnsTime = dataProfile.getMaxConnectionsTime();
        dataProfileInfo.maxConns = dataProfile.getMaxConnections();
        dataProfileInfo.waitTime = dataProfile.getWaitTime();
        dataProfileInfo.enabled = dataProfile.isEnabled();
        dataProfileInfo.supportedApnTypesBitmap = dataProfile.getSupportedApnTypesBitmask();
        dataProfileInfo.bearerBitmap = ServiceState.convertNetworkTypeBitmaskToBearerBitmask(dataProfile.getBearerBitmask()) << 1;
        dataProfileInfo.mtu = dataProfile.getMtuV4();
        dataProfileInfo.mvnoType = 0;
        dataProfileInfo.mvnoMatchData = "";
        return dataProfileInfo;
    }

    public static android.hardware.radio.V1_4.DataProfileInfo convertToHalDataProfile14(DataProfile dataProfile) {
        android.hardware.radio.V1_4.DataProfileInfo dataProfileInfo = new android.hardware.radio.V1_4.DataProfileInfo();
        dataProfileInfo.apn = dataProfile.getApn();
        dataProfileInfo.protocol = dataProfile.getProtocolType();
        dataProfileInfo.roamingProtocol = dataProfile.getRoamingProtocolType();
        dataProfileInfo.authType = dataProfile.getAuthType();
        dataProfileInfo.user = TextUtils.emptyIfNull(dataProfile.getUserName());
        dataProfileInfo.password = TextUtils.emptyIfNull(dataProfile.getPassword());
        dataProfileInfo.type = dataProfile.getType();
        dataProfileInfo.maxConnsTime = dataProfile.getMaxConnectionsTime();
        dataProfileInfo.maxConns = dataProfile.getMaxConnections();
        dataProfileInfo.waitTime = dataProfile.getWaitTime();
        dataProfileInfo.enabled = dataProfile.isEnabled();
        dataProfileInfo.supportedApnTypesBitmap = dataProfile.getSupportedApnTypesBitmask();
        dataProfileInfo.bearerBitmap = ServiceState.convertNetworkTypeBitmaskToBearerBitmask(dataProfile.getBearerBitmask()) << 1;
        dataProfileInfo.mtu = dataProfile.getMtuV4();
        dataProfileInfo.persistent = dataProfile.isPersistent();
        dataProfileInfo.preferred = dataProfile.isPreferred();
        dataProfileInfo.profileId = dataProfileInfo.persistent ? dataProfile.getProfileId() : -1;
        return dataProfileInfo;
    }

    public static android.hardware.radio.V1_5.DataProfileInfo convertToHalDataProfile15(DataProfile dataProfile) {
        android.hardware.radio.V1_5.DataProfileInfo dataProfileInfo = new android.hardware.radio.V1_5.DataProfileInfo();
        dataProfileInfo.apn = dataProfile.getApn();
        dataProfileInfo.protocol = dataProfile.getProtocolType();
        dataProfileInfo.roamingProtocol = dataProfile.getRoamingProtocolType();
        dataProfileInfo.authType = dataProfile.getAuthType();
        dataProfileInfo.user = TextUtils.emptyIfNull(dataProfile.getUserName());
        dataProfileInfo.password = TextUtils.emptyIfNull(dataProfile.getPassword());
        dataProfileInfo.type = dataProfile.getType();
        dataProfileInfo.maxConnsTime = dataProfile.getMaxConnectionsTime();
        dataProfileInfo.maxConns = dataProfile.getMaxConnections();
        dataProfileInfo.waitTime = dataProfile.getWaitTime();
        dataProfileInfo.enabled = dataProfile.isEnabled();
        dataProfileInfo.supportedApnTypesBitmap = dataProfile.getSupportedApnTypesBitmask();
        dataProfileInfo.bearerBitmap = ServiceState.convertNetworkTypeBitmaskToBearerBitmask(dataProfile.getBearerBitmask()) << 1;
        dataProfileInfo.mtuV4 = dataProfile.getMtuV4();
        dataProfileInfo.mtuV6 = dataProfile.getMtuV6();
        dataProfileInfo.persistent = dataProfile.isPersistent();
        dataProfileInfo.preferred = dataProfile.isPreferred();
        dataProfileInfo.profileId = dataProfileInfo.persistent ? dataProfile.getProfileId() : -1;
        return dataProfileInfo;
    }

    public static android.hardware.radio.data.DataProfileInfo convertToHalDataProfile(DataProfile dataProfile) {
        android.hardware.radio.data.DataProfileInfo dataProfileInfo = new android.hardware.radio.data.DataProfileInfo();
        dataProfileInfo.apn = dataProfile.getApn();
        dataProfileInfo.protocol = dataProfile.getProtocolType();
        dataProfileInfo.roamingProtocol = dataProfile.getRoamingProtocolType();
        dataProfileInfo.authType = dataProfile.getAuthType();
        dataProfileInfo.user = convertNullToEmptyString(dataProfile.getUserName());
        dataProfileInfo.password = convertNullToEmptyString(dataProfile.getPassword());
        dataProfileInfo.type = dataProfile.getType();
        dataProfileInfo.maxConnsTime = dataProfile.getMaxConnectionsTime();
        dataProfileInfo.maxConns = dataProfile.getMaxConnections();
        dataProfileInfo.waitTime = dataProfile.getWaitTime();
        dataProfileInfo.enabled = dataProfile.isEnabled();
        dataProfileInfo.supportedApnTypesBitmap = dataProfile.getSupportedApnTypesBitmask();
        dataProfileInfo.bearerBitmap = ServiceState.convertNetworkTypeBitmaskToBearerBitmask(dataProfile.getBearerBitmask()) << 1;
        dataProfileInfo.mtuV4 = dataProfile.getMtuV4();
        dataProfileInfo.mtuV6 = dataProfile.getMtuV6();
        dataProfileInfo.persistent = dataProfile.isPersistent();
        dataProfileInfo.preferred = dataProfile.isPreferred();
        dataProfileInfo.alwaysOn = false;
        if (dataProfile.getApnSetting() != null) {
            dataProfileInfo.alwaysOn = dataProfile.getApnSetting().isAlwaysOn();
        }
        dataProfileInfo.trafficDescriptor = convertToHalTrafficDescriptorAidl(dataProfile.getTrafficDescriptor());
        dataProfileInfo.profileId = dataProfileInfo.persistent ? dataProfile.getProfileId() : -1;
        return dataProfileInfo;
    }

    public static DataProfile convertToDataProfile(android.hardware.radio.data.DataProfileInfo dataProfileInfo) {
        TrafficDescriptor trafficDescriptor;
        ApnSetting build = new ApnSetting.Builder().setEntryName(dataProfileInfo.apn).setApnName(dataProfileInfo.apn).setApnTypeBitmask(dataProfileInfo.supportedApnTypesBitmap).setAuthType(dataProfileInfo.authType).setMaxConnsTime(dataProfileInfo.maxConnsTime).setMaxConns(dataProfileInfo.maxConns).setWaitTime(dataProfileInfo.waitTime).setCarrierEnabled(dataProfileInfo.enabled).setModemCognitive(dataProfileInfo.persistent).setMtuV4(dataProfileInfo.mtuV4).setMtuV6(dataProfileInfo.mtuV6).setNetworkTypeBitmask(ServiceState.convertBearerBitmaskToNetworkTypeBitmask(dataProfileInfo.bearerBitmap) >> 1).setProfileId(dataProfileInfo.profileId).setPassword(dataProfileInfo.password).setProtocol(dataProfileInfo.protocol).setRoamingProtocol(dataProfileInfo.roamingProtocol).setUser(dataProfileInfo.user).setAlwaysOn(dataProfileInfo.alwaysOn).build();
        try {
            trafficDescriptor = convertHalTrafficDescriptor(dataProfileInfo.trafficDescriptor);
        } catch (IllegalArgumentException e) {
            loge("convertToDataProfile: Failed to convert traffic descriptor. e=" + e);
            trafficDescriptor = null;
        }
        return new DataProfile.Builder().setType(dataProfileInfo.type).setPreferred(dataProfileInfo.preferred).setTrafficDescriptor(trafficDescriptor).setApnSetting(build).build();
    }

    public static OptionalSliceInfo convertToHalSliceInfo(NetworkSliceInfo networkSliceInfo) {
        OptionalSliceInfo optionalSliceInfo = new OptionalSliceInfo();
        if (networkSliceInfo == null) {
            return optionalSliceInfo;
        }
        SliceInfo sliceInfo = new SliceInfo();
        sliceInfo.sst = (byte) networkSliceInfo.getSliceServiceType();
        sliceInfo.mappedHplmnSst = (byte) networkSliceInfo.getMappedHplmnSliceServiceType();
        sliceInfo.sliceDifferentiator = networkSliceInfo.getSliceDifferentiator();
        sliceInfo.mappedHplmnSD = networkSliceInfo.getMappedHplmnSliceDifferentiator();
        optionalSliceInfo.value(sliceInfo);
        return optionalSliceInfo;
    }

    public static android.hardware.radio.data.SliceInfo convertToHalSliceInfoAidl(NetworkSliceInfo networkSliceInfo) {
        if (networkSliceInfo == null) {
            return null;
        }
        android.hardware.radio.data.SliceInfo sliceInfo = new android.hardware.radio.data.SliceInfo();
        sliceInfo.sliceServiceType = (byte) networkSliceInfo.getSliceServiceType();
        sliceInfo.mappedHplmnSst = (byte) networkSliceInfo.getMappedHplmnSliceServiceType();
        sliceInfo.sliceDifferentiator = networkSliceInfo.getSliceDifferentiator();
        sliceInfo.mappedHplmnSd = networkSliceInfo.getMappedHplmnSliceDifferentiator();
        return sliceInfo;
    }

    public static OptionalTrafficDescriptor convertToHalTrafficDescriptor(TrafficDescriptor trafficDescriptor) {
        OptionalTrafficDescriptor optionalTrafficDescriptor = new OptionalTrafficDescriptor();
        if (trafficDescriptor == null) {
            return optionalTrafficDescriptor;
        }
        android.hardware.radio.V1_6.TrafficDescriptor trafficDescriptor2 = new android.hardware.radio.V1_6.TrafficDescriptor();
        OptionalDnn optionalDnn = new OptionalDnn();
        if (trafficDescriptor.getDataNetworkName() != null) {
            optionalDnn.value(trafficDescriptor.getDataNetworkName());
        }
        trafficDescriptor2.dnn = optionalDnn;
        OptionalOsAppId optionalOsAppId = new OptionalOsAppId();
        if (trafficDescriptor.getOsAppId() != null) {
            OsAppId osAppId = new OsAppId();
            osAppId.osAppId = primitiveArrayToArrayList(trafficDescriptor.getOsAppId());
            optionalOsAppId.value(osAppId);
        }
        trafficDescriptor2.osAppId = optionalOsAppId;
        optionalTrafficDescriptor.value(trafficDescriptor2);
        return optionalTrafficDescriptor;
    }

    public static android.hardware.radio.data.TrafficDescriptor convertToHalTrafficDescriptorAidl(TrafficDescriptor trafficDescriptor) {
        if (trafficDescriptor == null) {
            return new android.hardware.radio.data.TrafficDescriptor();
        }
        android.hardware.radio.data.TrafficDescriptor trafficDescriptor2 = new android.hardware.radio.data.TrafficDescriptor();
        trafficDescriptor2.dnn = trafficDescriptor.getDataNetworkName();
        if (trafficDescriptor.getOsAppId() == null) {
            trafficDescriptor2.osAppId = null;
        } else {
            android.hardware.radio.data.OsAppId osAppId = new android.hardware.radio.data.OsAppId();
            osAppId.osAppId = trafficDescriptor.getOsAppId();
            trafficDescriptor2.osAppId = osAppId;
        }
        return trafficDescriptor2;
    }

    public static ArrayList<LinkAddress> convertToHalLinkProperties15(LinkProperties linkProperties) {
        ArrayList<LinkAddress> arrayList = new ArrayList<>();
        if (linkProperties != null) {
            for (android.net.LinkAddress linkAddress : linkProperties.getAllLinkAddresses()) {
                LinkAddress linkAddress2 = new LinkAddress();
                linkAddress2.address = linkAddress.getAddress().getHostAddress();
                linkAddress2.properties = linkAddress.getFlags();
                linkAddress2.deprecationTime = linkAddress.getDeprecationTime();
                linkAddress2.expirationTime = linkAddress.getExpirationTime();
                arrayList.add(linkAddress2);
            }
        }
        return arrayList;
    }

    public static android.hardware.radio.data.LinkAddress[] convertToHalLinkProperties(LinkProperties linkProperties) {
        if (linkProperties == null) {
            return new android.hardware.radio.data.LinkAddress[0];
        }
        android.hardware.radio.data.LinkAddress[] linkAddressArr = new android.hardware.radio.data.LinkAddress[linkProperties.getAllLinkAddresses().size()];
        for (int i = 0; i < linkProperties.getAllLinkAddresses().size(); i++) {
            android.net.LinkAddress linkAddress = (android.net.LinkAddress) linkProperties.getAllLinkAddresses().get(i);
            android.hardware.radio.data.LinkAddress linkAddress2 = new android.hardware.radio.data.LinkAddress();
            linkAddress2.address = linkAddress.getAddress().getHostAddress();
            linkAddress2.addressProperties = linkAddress.getFlags();
            linkAddress2.deprecationTime = linkAddress.getDeprecationTime();
            linkAddress2.expirationTime = linkAddress.getExpirationTime();
            linkAddressArr[i] = linkAddress2;
        }
        return linkAddressArr;
    }

    public static RadioAccessSpecifier convertHalRadioAccessSpecifier(android.hardware.radio.V1_5.RadioAccessSpecifier radioAccessSpecifier) {
        if (radioAccessSpecifier == null) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        byte discriminator = radioAccessSpecifier.bands.getDiscriminator();
        if (discriminator == 0) {
            arrayList = radioAccessSpecifier.bands.geranBands();
        } else if (discriminator == 1) {
            arrayList = radioAccessSpecifier.bands.utranBands();
        } else if (discriminator == 2) {
            arrayList = radioAccessSpecifier.bands.eutranBands();
        } else if (discriminator == 3) {
            arrayList = radioAccessSpecifier.bands.ngranBands();
        }
        return new RadioAccessSpecifier(convertHalRadioAccessNetworks(radioAccessSpecifier.radioAccessNetwork), arrayList.stream().mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray(), radioAccessSpecifier.channels.stream().mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray());
    }

    public static RadioAccessSpecifier convertHalRadioAccessSpecifier(android.hardware.radio.network.RadioAccessSpecifier radioAccessSpecifier) {
        int[] iArr = null;
        if (radioAccessSpecifier == null) {
            return null;
        }
        int tag = radioAccessSpecifier.bands.getTag();
        if (tag == 1) {
            iArr = radioAccessSpecifier.bands.getGeranBands();
        } else if (tag == 2) {
            iArr = radioAccessSpecifier.bands.getUtranBands();
        } else if (tag == 3) {
            iArr = radioAccessSpecifier.bands.getEutranBands();
        } else if (tag == 4) {
            iArr = radioAccessSpecifier.bands.getNgranBands();
        }
        return new RadioAccessSpecifier(radioAccessSpecifier.accessNetwork, iArr, radioAccessSpecifier.channels);
    }

    public static android.hardware.radio.V1_1.RadioAccessSpecifier convertToHalRadioAccessSpecifier11(RadioAccessSpecifier radioAccessSpecifier) {
        android.hardware.radio.V1_1.RadioAccessSpecifier radioAccessSpecifier2 = new android.hardware.radio.V1_1.RadioAccessSpecifier();
        radioAccessSpecifier2.radioAccessNetwork = radioAccessSpecifier.getRadioAccessNetwork();
        ArrayList arrayList = new ArrayList();
        if (radioAccessSpecifier.getBands() != null) {
            for (int valueOf : radioAccessSpecifier.getBands()) {
                arrayList.add(Integer.valueOf(valueOf));
            }
        }
        int radioAccessNetwork = radioAccessSpecifier.getRadioAccessNetwork();
        if (radioAccessNetwork == 1) {
            radioAccessSpecifier2.geranBands = arrayList;
        } else if (radioAccessNetwork == 2) {
            radioAccessSpecifier2.utranBands = arrayList;
        } else if (radioAccessNetwork != 3) {
            return null;
        } else {
            radioAccessSpecifier2.eutranBands = arrayList;
        }
        if (radioAccessSpecifier.getChannels() != null) {
            for (int valueOf2 : radioAccessSpecifier.getChannels()) {
                radioAccessSpecifier2.channels.add(Integer.valueOf(valueOf2));
            }
        }
        return radioAccessSpecifier2;
    }

    public static android.hardware.radio.V1_5.RadioAccessSpecifier convertToHalRadioAccessSpecifier15(RadioAccessSpecifier radioAccessSpecifier) {
        android.hardware.radio.V1_5.RadioAccessSpecifier radioAccessSpecifier2 = new android.hardware.radio.V1_5.RadioAccessSpecifier();
        RadioAccessSpecifier.Bands bands = new RadioAccessSpecifier.Bands();
        radioAccessSpecifier2.radioAccessNetwork = convertToHalRadioAccessNetworks(radioAccessSpecifier.getRadioAccessNetwork());
        ArrayList arrayList = new ArrayList();
        if (radioAccessSpecifier.getBands() != null) {
            for (int valueOf : radioAccessSpecifier.getBands()) {
                arrayList.add(Integer.valueOf(valueOf));
            }
        }
        int radioAccessNetwork = radioAccessSpecifier.getRadioAccessNetwork();
        if (radioAccessNetwork == 1) {
            bands.geranBands(arrayList);
        } else if (radioAccessNetwork == 2) {
            bands.utranBands(arrayList);
        } else if (radioAccessNetwork == 3) {
            bands.eutranBands(arrayList);
        } else if (radioAccessNetwork != 6) {
            return null;
        } else {
            bands.ngranBands(arrayList);
        }
        radioAccessSpecifier2.bands = bands;
        if (radioAccessSpecifier.getChannels() != null) {
            for (int valueOf2 : radioAccessSpecifier.getChannels()) {
                radioAccessSpecifier2.channels.add(Integer.valueOf(valueOf2));
            }
        }
        return radioAccessSpecifier2;
    }

    public static android.hardware.radio.network.RadioAccessSpecifier convertToHalRadioAccessSpecifierAidl(android.telephony.RadioAccessSpecifier radioAccessSpecifier) {
        int[] iArr;
        int[] iArr2;
        android.hardware.radio.network.RadioAccessSpecifier radioAccessSpecifier2 = new android.hardware.radio.network.RadioAccessSpecifier();
        RadioAccessSpecifierBands radioAccessSpecifierBands = new RadioAccessSpecifierBands();
        radioAccessSpecifier2.accessNetwork = convertToHalAccessNetworkAidl(radioAccessSpecifier.getRadioAccessNetwork());
        if (radioAccessSpecifier.getBands() != null) {
            iArr = new int[radioAccessSpecifier.getBands().length];
            for (int i = 0; i < radioAccessSpecifier.getBands().length; i++) {
                iArr[i] = radioAccessSpecifier.getBands()[i];
            }
        } else {
            iArr = new int[0];
        }
        int radioAccessNetwork = radioAccessSpecifier.getRadioAccessNetwork();
        if (radioAccessNetwork == 1) {
            radioAccessSpecifierBands.setGeranBands(iArr);
        } else if (radioAccessNetwork == 2) {
            radioAccessSpecifierBands.setUtranBands(iArr);
        } else if (radioAccessNetwork == 3) {
            radioAccessSpecifierBands.setEutranBands(iArr);
        } else if (radioAccessNetwork != 6) {
            return null;
        } else {
            radioAccessSpecifierBands.setNgranBands(iArr);
        }
        radioAccessSpecifier2.bands = radioAccessSpecifierBands;
        if (radioAccessSpecifier.getChannels() != null) {
            iArr2 = new int[radioAccessSpecifier.getChannels().length];
            for (int i2 = 0; i2 < radioAccessSpecifier.getChannels().length; i2++) {
                iArr2[i2] = radioAccessSpecifier.getChannels()[i2];
            }
        } else {
            iArr2 = new int[0];
        }
        radioAccessSpecifier2.channels = iArr2;
        return radioAccessSpecifier2;
    }

    public static String convertToCensoredTerminalResponse(String str) {
        try {
            byte[] hexStringToBytes = IccUtils.hexStringToBytes(str);
            if (hexStringToBytes == null) {
                return str;
            }
            int i = 0;
            for (ComprehensionTlv next : ComprehensionTlv.decodeMany(hexStringToBytes, 0)) {
                if (ComprehensionTlvTag.TEXT_STRING.value() == next.getTag()) {
                    str = str.toLowerCase().replace(IccUtils.bytesToHexString(Arrays.copyOfRange(next.getRawValue(), i, next.getValueIndex() + next.getLength())).toLowerCase(), "********");
                }
                i = next.getValueIndex() + next.getLength();
            }
            return str;
        } catch (Exception unused) {
            return null;
        }
    }

    public static SimApdu convertToHalSimApdu(int i, int i2, int i3, int i4, int i5, int i6, String str) {
        SimApdu simApdu = new SimApdu();
        simApdu.sessionId = i;
        simApdu.cla = i2;
        simApdu.instruction = i3;
        simApdu.p1 = i4;
        simApdu.p2 = i5;
        simApdu.p3 = i6;
        simApdu.data = convertNullToEmptyString(str);
        return simApdu;
    }

    public static android.hardware.radio.sim.SimApdu convertToHalSimApduAidl(int i, int i2, int i3, int i4, int i5, int i6, String str) {
        android.hardware.radio.sim.SimApdu simApdu = new android.hardware.radio.sim.SimApdu();
        simApdu.sessionId = i;
        simApdu.cla = i2;
        simApdu.instruction = i3;
        simApdu.p1 = i4;
        simApdu.p2 = i5;
        simApdu.p3 = i6;
        simApdu.data = convertNullToEmptyString(str);
        return simApdu;
    }

    public static ArrayList<Carrier> convertToHalCarrierRestrictionList(List<CarrierIdentifier> list) {
        ArrayList<Carrier> arrayList = new ArrayList<>();
        for (CarrierIdentifier next : list) {
            Carrier carrier = new Carrier();
            carrier.mcc = convertNullToEmptyString(next.getMcc());
            carrier.mnc = convertNullToEmptyString(next.getMnc());
            int i = 0;
            String str = null;
            if (!TextUtils.isEmpty(next.getSpn())) {
                i = 1;
                str = next.getSpn();
            } else if (!TextUtils.isEmpty(next.getImsi())) {
                i = 2;
                str = next.getImsi();
            } else if (!TextUtils.isEmpty(next.getGid1())) {
                i = 3;
                str = next.getGid1();
            } else if (!TextUtils.isEmpty(next.getGid2())) {
                i = 4;
                str = next.getGid2();
            }
            carrier.matchType = i;
            carrier.matchData = convertNullToEmptyString(str);
            arrayList.add(carrier);
        }
        return arrayList;
    }

    public static android.hardware.radio.sim.Carrier[] convertToHalCarrierRestrictionListAidl(List<CarrierIdentifier> list) {
        int i;
        int i2;
        String gid2;
        android.hardware.radio.sim.Carrier[] carrierArr = new android.hardware.radio.sim.Carrier[list.size()];
        for (int i3 = 0; i3 < list.size(); i3++) {
            CarrierIdentifier carrierIdentifier = list.get(i3);
            android.hardware.radio.sim.Carrier carrier = new android.hardware.radio.sim.Carrier();
            carrier.mcc = convertNullToEmptyString(carrierIdentifier.getMcc());
            carrier.mnc = convertNullToEmptyString(carrierIdentifier.getMnc());
            String str = null;
            if (!TextUtils.isEmpty(carrierIdentifier.getSpn())) {
                str = carrierIdentifier.getSpn();
                i = 1;
            } else {
                if (!TextUtils.isEmpty(carrierIdentifier.getImsi())) {
                    i2 = 2;
                    gid2 = carrierIdentifier.getImsi();
                } else if (!TextUtils.isEmpty(carrierIdentifier.getGid1())) {
                    i2 = 3;
                    gid2 = carrierIdentifier.getGid1();
                } else if (!TextUtils.isEmpty(carrierIdentifier.getGid2())) {
                    i2 = 4;
                    gid2 = carrierIdentifier.getGid2();
                } else {
                    i = 0;
                }
                int i4 = i2;
                str = gid2;
                i = i4;
            }
            carrier.matchType = i;
            carrier.matchData = convertNullToEmptyString(str);
            carrierArr[i3] = carrier;
        }
        return carrierArr;
    }

    public static Dial convertToHalDial(String str, int i, UUSInfo uUSInfo) {
        Dial dial = new Dial();
        dial.address = convertNullToEmptyString(str);
        dial.clir = i;
        if (uUSInfo != null) {
            UusInfo uusInfo = new UusInfo();
            uusInfo.uusType = uUSInfo.getType();
            uusInfo.uusDcs = uUSInfo.getDcs();
            uusInfo.uusData = new String(uUSInfo.getUserData());
            dial.uusInfo.add(uusInfo);
        }
        return dial;
    }

    public static android.hardware.radio.voice.Dial convertToHalDialAidl(String str, int i, UUSInfo uUSInfo) {
        android.hardware.radio.voice.Dial dial = new android.hardware.radio.voice.Dial();
        dial.address = convertNullToEmptyString(str);
        dial.clir = i;
        if (uUSInfo != null) {
            android.hardware.radio.voice.UusInfo uusInfo = new android.hardware.radio.voice.UusInfo();
            uusInfo.uusType = uUSInfo.getType();
            uusInfo.uusDcs = uUSInfo.getDcs();
            uusInfo.uusData = new String(uUSInfo.getUserData());
            dial.uusInfo = new android.hardware.radio.voice.UusInfo[]{uusInfo};
        } else {
            dial.uusInfo = new android.hardware.radio.voice.UusInfo[0];
        }
        return dial;
    }

    public static SignalThresholdInfo convertToHalSignalThresholdInfo(android.telephony.SignalThresholdInfo signalThresholdInfo) {
        SignalThresholdInfo signalThresholdInfo2 = new SignalThresholdInfo();
        signalThresholdInfo2.signalMeasurement = signalThresholdInfo.getSignalMeasurementType();
        signalThresholdInfo2.hysteresisMs = signalThresholdInfo.getHysteresisMs();
        signalThresholdInfo2.hysteresisDb = signalThresholdInfo.getHysteresisDb();
        signalThresholdInfo2.thresholds = primitiveArrayToArrayList(signalThresholdInfo.getThresholds());
        signalThresholdInfo2.isEnabled = signalThresholdInfo.isEnabled();
        return signalThresholdInfo2;
    }

    public static android.hardware.radio.network.SignalThresholdInfo convertToHalSignalThresholdInfoAidl(android.telephony.SignalThresholdInfo signalThresholdInfo) {
        android.hardware.radio.network.SignalThresholdInfo signalThresholdInfo2 = new android.hardware.radio.network.SignalThresholdInfo();
        signalThresholdInfo2.signalMeasurement = signalThresholdInfo.getSignalMeasurementType();
        signalThresholdInfo2.hysteresisMs = signalThresholdInfo.getHysteresisMs();
        signalThresholdInfo2.hysteresisDb = signalThresholdInfo.getHysteresisDb();
        signalThresholdInfo2.thresholds = signalThresholdInfo.getThresholds();
        signalThresholdInfo2.isEnabled = signalThresholdInfo.isEnabled();
        signalThresholdInfo2.ran = signalThresholdInfo.getRadioAccessNetworkType();
        return signalThresholdInfo2;
    }

    public static ArrayList<HardwareConfig> convertHalHardwareConfigList(ArrayList<HardwareConfig> arrayList) {
        HardwareConfig hardwareConfig;
        ArrayList<HardwareConfig> arrayList2 = new ArrayList<>(arrayList.size());
        Iterator<HardwareConfig> it = arrayList.iterator();
        while (it.hasNext()) {
            HardwareConfig next = it.next();
            int i = next.type;
            if (i == 0) {
                HardwareConfig hardwareConfig2 = new HardwareConfig(i);
                HardwareConfigModem hardwareConfigModem = (HardwareConfigModem) next.modem.get(0);
                hardwareConfig2.assignModem(next.uuid, next.state, hardwareConfigModem.rilModel, hardwareConfigModem.rat, hardwareConfigModem.maxVoice, hardwareConfigModem.maxData, hardwareConfigModem.maxStandby);
                hardwareConfig = hardwareConfig2;
            } else if (i == 1) {
                hardwareConfig = new HardwareConfig(i);
                hardwareConfig.assignSim(next.uuid, next.state, ((HardwareConfigSim) next.sim.get(0)).modemUuid);
            } else {
                throw new RuntimeException("RIL_REQUEST_GET_HARDWARE_CONFIG invalid hardware type:" + i);
            }
            arrayList2.add(hardwareConfig);
        }
        return arrayList2;
    }

    public static ArrayList<HardwareConfig> convertHalHardwareConfigList(android.hardware.radio.modem.HardwareConfig[] hardwareConfigArr) {
        HardwareConfig hardwareConfig;
        ArrayList<HardwareConfig> arrayList = new ArrayList<>(hardwareConfigArr.length);
        for (android.hardware.radio.modem.HardwareConfig hardwareConfig2 : hardwareConfigArr) {
            int i = hardwareConfig2.type;
            if (i == 0) {
                HardwareConfig hardwareConfig3 = new HardwareConfig(i);
                android.hardware.radio.modem.HardwareConfigModem hardwareConfigModem = hardwareConfig2.modem[0];
                hardwareConfig3.assignModem(hardwareConfig2.uuid, hardwareConfig2.state, hardwareConfigModem.rilModel, hardwareConfigModem.rat, hardwareConfigModem.maxVoiceCalls, hardwareConfigModem.maxDataCalls, hardwareConfigModem.maxStandby);
                hardwareConfig = hardwareConfig3;
            } else if (i == 1) {
                hardwareConfig = new HardwareConfig(i);
                hardwareConfig.assignSim(hardwareConfig2.uuid, hardwareConfig2.state, hardwareConfig2.sim[0].modemUuid);
            } else {
                throw new RuntimeException("RIL_REQUEST_GET_HARDWARE_CONFIG invalid hardware type:" + i);
            }
            arrayList.add(hardwareConfig);
        }
        return arrayList;
    }

    public static RadioCapability convertHalRadioCapability(RadioCapability radioCapability, RIL ril) {
        int i = radioCapability.session;
        int i2 = radioCapability.phase;
        int convertHalNetworkTypeBitMask = convertHalNetworkTypeBitMask(radioCapability.raf);
        String str = radioCapability.logicalModemUuid;
        int i3 = radioCapability.status;
        ril.riljLog("convertHalRadioCapability: session=" + i + ", phase=" + i2 + ", rat=" + convertHalNetworkTypeBitMask + ", logicModemUuid=" + str + ", status=" + i3 + ", rcRil.raf=" + radioCapability.raf);
        return new RadioCapability(ril.mPhoneId.intValue(), i, i2, convertHalNetworkTypeBitMask, str, i3);
    }

    public static RadioCapability convertHalRadioCapability(android.hardware.radio.modem.RadioCapability radioCapability, RIL ril) {
        int i = radioCapability.session;
        int i2 = radioCapability.phase;
        int convertHalNetworkTypeBitMask = convertHalNetworkTypeBitMask(radioCapability.raf);
        String str = radioCapability.logicalModemUuid;
        int i3 = radioCapability.status;
        ril.riljLog("convertHalRadioCapability: session=" + i + ", phase=" + i2 + ", rat=" + convertHalNetworkTypeBitMask + ", logicModemUuid=" + str + ", status=" + i3 + ", rcRil.raf=" + radioCapability.raf);
        return new RadioCapability(ril.mPhoneId.intValue(), i, i2, convertHalNetworkTypeBitMask, str, i3);
    }

    public static List<LinkCapacityEstimate> convertHalLceData(Object obj) {
        int i;
        int i2;
        ArrayList arrayList = new ArrayList();
        if (obj == null) {
            return arrayList;
        }
        if (obj instanceof LceDataInfo) {
            arrayList.add(new LinkCapacityEstimate(2, ((LceDataInfo) obj).lastHopCapacityKbps, -1));
        } else if (obj instanceof android.hardware.radio.V1_2.LinkCapacityEstimate) {
            android.hardware.radio.V1_2.LinkCapacityEstimate linkCapacityEstimate = (android.hardware.radio.V1_2.LinkCapacityEstimate) obj;
            arrayList.add(new LinkCapacityEstimate(2, linkCapacityEstimate.downlinkCapacityKbps, linkCapacityEstimate.uplinkCapacityKbps));
        } else if (obj instanceof android.hardware.radio.V1_6.LinkCapacityEstimate) {
            android.hardware.radio.V1_6.LinkCapacityEstimate linkCapacityEstimate2 = (android.hardware.radio.V1_6.LinkCapacityEstimate) obj;
            int i3 = linkCapacityEstimate2.downlinkCapacityKbps;
            int i4 = linkCapacityEstimate2.uplinkCapacityKbps;
            if (!(i3 == -1 || (i2 = linkCapacityEstimate2.secondaryDownlinkCapacityKbps) == -1)) {
                i3 -= i2;
            }
            if (!(i4 == -1 || (i = linkCapacityEstimate2.secondaryUplinkCapacityKbps) == -1)) {
                i4 -= i;
            }
            arrayList.add(new LinkCapacityEstimate(0, i3, i4));
            arrayList.add(new LinkCapacityEstimate(1, linkCapacityEstimate2.secondaryDownlinkCapacityKbps, linkCapacityEstimate2.secondaryUplinkCapacityKbps));
        }
        return arrayList;
    }

    public static List<LinkCapacityEstimate> convertHalLceData(android.hardware.radio.network.LceDataInfo lceDataInfo) {
        ArrayList arrayList = new ArrayList();
        arrayList.add(new LinkCapacityEstimate(2, lceDataInfo.lastHopCapacityKbps, -1));
        return arrayList;
    }

    public static List<LinkCapacityEstimate> convertHalLceData(android.hardware.radio.network.LinkCapacityEstimate linkCapacityEstimate) {
        int i;
        int i2;
        ArrayList arrayList = new ArrayList();
        int i3 = linkCapacityEstimate.downlinkCapacityKbps;
        int i4 = linkCapacityEstimate.uplinkCapacityKbps;
        if (!(i3 == -1 || (i2 = linkCapacityEstimate.secondaryDownlinkCapacityKbps) == -1)) {
            i3 -= i2;
        }
        if (!(i4 == -1 || (i = linkCapacityEstimate.secondaryUplinkCapacityKbps) == -1)) {
            i4 -= i;
        }
        arrayList.add(new LinkCapacityEstimate(0, i3, i4));
        arrayList.add(new LinkCapacityEstimate(1, linkCapacityEstimate.secondaryDownlinkCapacityKbps, linkCapacityEstimate.secondaryUplinkCapacityKbps));
        return arrayList;
    }

    public static ArrayList<CellInfo> convertHalCellInfoList(ArrayList<Object> arrayList) {
        ArrayList<CellInfo> arrayList2 = new ArrayList<>(arrayList.size());
        if (arrayList.isEmpty()) {
            return arrayList2;
        }
        long elapsedRealtimeNanos = SystemClock.elapsedRealtimeNanos();
        Iterator<Object> it = arrayList.iterator();
        while (it.hasNext()) {
            arrayList2.add(convertHalCellInfo(it.next(), elapsedRealtimeNanos));
        }
        return arrayList2;
    }

    public static ArrayList<CellInfo> convertHalCellInfoList(android.hardware.radio.network.CellInfo[] cellInfoArr) {
        ArrayList<CellInfo> arrayList = new ArrayList<>(cellInfoArr.length);
        if (cellInfoArr.length == 0) {
            return arrayList;
        }
        long elapsedRealtimeNanos = SystemClock.elapsedRealtimeNanos();
        for (android.hardware.radio.network.CellInfo convertHalCellInfo : cellInfoArr) {
            arrayList.add(convertHalCellInfo(convertHalCellInfo, elapsedRealtimeNanos));
        }
        return arrayList;
    }

    private static CellInfo convertHalCellInfo(Object obj, long j) {
        CellSignalStrengthGsm cellSignalStrengthGsm;
        CellIdentityGsm cellIdentityGsm;
        CellConfigLte cellConfigLte;
        CellIdentityTdscdma cellIdentityTdscdma;
        CellIdentityLte cellIdentityLte;
        char c;
        boolean z;
        int i;
        CellConfigLte cellConfigLte2;
        CellIdentityCdma cellIdentityCdma;
        CellSignalStrengthLte cellSignalStrengthLte;
        CellSignalStrengthWcdma cellSignalStrengthWcdma;
        CellConfigLte cellConfigLte3;
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma;
        CellIdentityNr cellIdentityNr;
        CellIdentityWcdma cellIdentityWcdma;
        int i2;
        boolean z2;
        CellIdentityGsm convertHalCellIdentityGsm;
        CellSignalStrengthGsm convertHalGsmSignalStrength;
        CellIdentityWcdma convertHalCellIdentityWcdma;
        CellSignalStrengthWcdma convertHalWcdmaSignalStrength;
        CellSignalStrengthTdscdma convertHalTdscdmaSignalStrength;
        CellSignalStrengthGsm cellSignalStrengthGsm2;
        CellSignalStrengthLte cellSignalStrengthLte2;
        CellSignalStrengthWcdma cellSignalStrengthWcdma2;
        CellIdentityGsm cellIdentityGsm2;
        CellIdentityNr cellIdentityNr2;
        CellIdentityCdma cellIdentityCdma2;
        CellIdentityLte cellIdentityLte2;
        CellIdentityWcdma cellIdentityWcdma2;
        CellConfigLte cellConfigLte4;
        CellIdentityTdscdma cellIdentityTdscdma2;
        char c2;
        CellConfigLte cellConfigLte5;
        CellIdentityNr convertHalCellIdentityNr;
        CellConfigLte convertHalNrSignalStrength;
        CellIdentityCdma convertHalCellIdentityCdma;
        CellConfigLte convertHalCdmaSignalStrength;
        CellIdentityWcdma cellIdentityWcdma3;
        CellIdentityLte cellIdentityLte3;
        CellIdentityCdma cellIdentityCdma3;
        CellIdentityGsm cellIdentityGsm3;
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma2;
        CellSignalStrengthWcdma cellSignalStrengthWcdma3;
        CellIdentityNr cellIdentityNr3;
        CellConfigLte cellConfigLte6;
        CellConfigLte cellConfigLte7;
        CellSignalStrengthGsm cellSignalStrengthGsm3;
        CellConfigLte cellConfigLte8;
        CellIdentityTdscdma cellIdentityTdscdma3;
        CellIdentityWcdma cellIdentityWcdma4;
        CellIdentityLte cellIdentityLte4;
        CellIdentityCdma cellIdentityCdma4;
        CellIdentityGsm cellIdentityGsm4;
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma3;
        CellSignalStrengthWcdma cellSignalStrengthWcdma4;
        CellSignalStrengthLte cellSignalStrengthLte3;
        CellConfigLte cellConfigLte9;
        CellSignalStrengthGsm cellSignalStrengthGsm4;
        CellConfigLte cellConfigLte10;
        CellIdentityTdscdma cellIdentityTdscdma4;
        CellIdentityWcdma cellIdentityWcdma5;
        CellIdentityLte cellIdentityLte5;
        CellIdentityCdma cellIdentityCdma5;
        CellIdentityGsm cellIdentityGsm5;
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma4;
        CellSignalStrengthLte cellSignalStrengthLte4;
        CellConfigLte cellConfigLte11;
        CellSignalStrengthGsm cellSignalStrengthGsm5;
        Object obj2 = obj;
        if (obj2 == null) {
            return null;
        }
        char c3 = 5;
        char c4 = 4;
        if (obj2 instanceof android.hardware.radio.V1_0.CellInfo) {
            android.hardware.radio.V1_0.CellInfo cellInfo = (android.hardware.radio.V1_0.CellInfo) obj2;
            boolean z3 = cellInfo.registered;
            int i3 = cellInfo.cellInfoType;
            if (i3 == 1) {
                CellInfoGsm cellInfoGsm = (CellInfoGsm) cellInfo.gsm.get(0);
                CellIdentityGsm convertHalCellIdentityGsm2 = convertHalCellIdentityGsm((Object) cellInfoGsm.cellIdentityGsm);
                cellSignalStrengthGsm5 = convertHalGsmSignalStrength(cellInfoGsm.signalStrengthGsm);
                cellSignalStrengthLte4 = null;
                cellSignalStrengthWcdma = null;
                cellSignalStrengthTdscdma4 = null;
                cellIdentityLte5 = null;
                cellIdentityWcdma5 = null;
                cellIdentityTdscdma4 = null;
                cellConfigLte10 = null;
                cellIdentityGsm5 = convertHalCellIdentityGsm2;
                c = 1;
                cellConfigLte11 = null;
                cellIdentityCdma5 = null;
            } else if (i3 == 2) {
                CellInfoCdma cellInfoCdma = (CellInfoCdma) cellInfo.cdma.get(0);
                cellSignalStrengthLte4 = null;
                cellSignalStrengthWcdma = null;
                cellSignalStrengthTdscdma4 = null;
                cellIdentityLte5 = null;
                cellIdentityWcdma5 = null;
                cellIdentityTdscdma4 = null;
                cellConfigLte10 = null;
                cellIdentityCdma5 = convertHalCellIdentityCdma((Object) cellInfoCdma.cellIdentityCdma);
                c = 2;
                cellConfigLte11 = convertHalCdmaSignalStrength(cellInfoCdma.signalStrengthCdma, cellInfoCdma.signalStrengthEvdo);
                cellSignalStrengthGsm5 = null;
                cellIdentityGsm5 = null;
            } else if (i3 == 3) {
                CellInfoLte cellInfoLte = (CellInfoLte) cellInfo.lte.get(0);
                CellIdentityLte convertHalCellIdentityLte = convertHalCellIdentityLte((Object) cellInfoLte.cellIdentityLte);
                CellSignalStrengthLte convertHalLteSignalStrength = convertHalLteSignalStrength((Object) cellInfoLte.signalStrengthLte);
                cellSignalStrengthWcdma = null;
                cellIdentityGsm5 = null;
                cellIdentityCdma5 = null;
                cellIdentityWcdma5 = null;
                cellIdentityTdscdma4 = null;
                cellIdentityLte5 = convertHalCellIdentityLte;
                cellConfigLte10 = new CellConfigLte();
                c = 3;
                cellSignalStrengthLte4 = convertHalLteSignalStrength;
                cellSignalStrengthGsm5 = null;
                cellConfigLte11 = null;
                cellSignalStrengthTdscdma4 = null;
            } else if (i3 == 4) {
                CellInfoWcdma cellInfoWcdma = (CellInfoWcdma) cellInfo.wcdma.get(0);
                cellSignalStrengthLte4 = null;
                cellSignalStrengthTdscdma4 = null;
                cellIdentityGsm5 = null;
                cellIdentityCdma5 = null;
                cellIdentityLte5 = null;
                cellIdentityTdscdma4 = null;
                cellConfigLte10 = null;
                cellIdentityWcdma5 = convertHalCellIdentityWcdma((Object) cellInfoWcdma.cellIdentityWcdma);
                c = 4;
                cellSignalStrengthWcdma = convertHalWcdmaSignalStrength((Object) cellInfoWcdma.signalStrengthWcdma);
                cellSignalStrengthGsm5 = null;
                cellConfigLte11 = null;
            } else if (i3 != 5) {
                return null;
            } else {
                CellInfoTdscdma cellInfoTdscdma = (CellInfoTdscdma) cellInfo.tdscdma.get(0);
                CellIdentityTdscdma convertHalCellIdentityTdscdma = convertHalCellIdentityTdscdma((Object) cellInfoTdscdma.cellIdentityTdscdma);
                cellSignalStrengthTdscdma4 = convertHalTdscdmaSignalStrength((Object) cellInfoTdscdma.signalStrengthTdscdma);
                cellSignalStrengthGsm5 = null;
                cellSignalStrengthWcdma = null;
                cellIdentityGsm5 = null;
                cellIdentityCdma5 = null;
                cellIdentityLte5 = null;
                cellIdentityWcdma5 = null;
                cellConfigLte10 = null;
                cellIdentityTdscdma4 = convertHalCellIdentityTdscdma;
                c = 5;
                cellConfigLte11 = null;
                cellSignalStrengthLte4 = null;
            }
            cellSignalStrengthGsm = cellSignalStrengthGsm5;
            cellIdentityGsm = cellIdentityGsm5;
            cellIdentityCdma = cellIdentityCdma5;
            cellIdentityWcdma = cellIdentityWcdma5;
            cellIdentityTdscdma = cellIdentityTdscdma4;
            cellConfigLte = cellConfigLte10;
            cellConfigLte2 = cellConfigLte11;
            cellSignalStrengthTdscdma = cellSignalStrengthTdscdma4;
            z = z3;
            cellIdentityLte = cellIdentityLte5;
            i = Integer.MAX_VALUE;
            cellSignalStrengthLte = cellSignalStrengthLte4;
            cellIdentityNr = null;
            cellConfigLte3 = null;
        } else if (obj2 instanceof android.hardware.radio.V1_2.CellInfo) {
            android.hardware.radio.V1_2.CellInfo cellInfo2 = (android.hardware.radio.V1_2.CellInfo) obj2;
            int i4 = cellInfo2.connectionStatus;
            boolean z4 = cellInfo2.registered;
            int i5 = cellInfo2.cellInfoType;
            if (i5 != 1) {
                if (i5 == 2) {
                    android.hardware.radio.V1_2.CellInfoCdma cellInfoCdma2 = (android.hardware.radio.V1_2.CellInfoCdma) cellInfo2.cdma.get(0);
                    cellSignalStrengthLte3 = null;
                    cellSignalStrengthWcdma4 = null;
                    cellIdentityGsm4 = null;
                    cellIdentityLte4 = null;
                    cellIdentityWcdma4 = null;
                    cellIdentityTdscdma3 = null;
                    cellConfigLte8 = null;
                    cellIdentityCdma4 = convertHalCellIdentityCdma((Object) cellInfoCdma2.cellIdentityCdma);
                    c3 = 2;
                    cellConfigLte9 = convertHalCdmaSignalStrength(cellInfoCdma2.signalStrengthCdma, cellInfoCdma2.signalStrengthEvdo);
                    cellSignalStrengthGsm4 = null;
                    cellSignalStrengthTdscdma3 = null;
                } else if (i5 == 3) {
                    android.hardware.radio.V1_2.CellInfoLte cellInfoLte2 = (android.hardware.radio.V1_2.CellInfoLte) cellInfo2.lte.get(0);
                    CellIdentityLte convertHalCellIdentityLte2 = convertHalCellIdentityLte((Object) cellInfoLte2.cellIdentityLte);
                    cellSignalStrengthLte3 = convertHalLteSignalStrength((Object) cellInfoLte2.signalStrengthLte);
                    cellSignalStrengthGsm4 = null;
                    cellSignalStrengthTdscdma3 = null;
                    cellIdentityGsm4 = null;
                    cellIdentityCdma4 = null;
                    cellIdentityWcdma4 = null;
                    cellIdentityTdscdma3 = null;
                    cellIdentityLte4 = convertHalCellIdentityLte2;
                    cellConfigLte8 = new CellConfigLte();
                    c3 = 3;
                    cellConfigLte9 = null;
                    cellSignalStrengthWcdma4 = null;
                } else if (i5 == 4) {
                    android.hardware.radio.V1_2.CellInfoWcdma cellInfoWcdma2 = (android.hardware.radio.V1_2.CellInfoWcdma) cellInfo2.wcdma.get(0);
                    CellIdentityWcdma convertHalCellIdentityWcdma2 = convertHalCellIdentityWcdma((Object) cellInfoWcdma2.cellIdentityWcdma);
                    cellSignalStrengthWcdma4 = convertHalWcdmaSignalStrength((Object) cellInfoWcdma2.signalStrengthWcdma);
                    cellSignalStrengthGsm4 = null;
                    cellSignalStrengthTdscdma3 = null;
                    cellIdentityGsm4 = null;
                    cellIdentityCdma4 = null;
                    cellIdentityLte4 = null;
                    cellIdentityTdscdma3 = null;
                    cellConfigLte8 = null;
                    cellIdentityWcdma4 = convertHalCellIdentityWcdma2;
                    c3 = 4;
                    cellConfigLte9 = null;
                    cellSignalStrengthLte3 = null;
                } else if (i5 != 5) {
                    return null;
                } else {
                    android.hardware.radio.V1_2.CellInfoTdscdma cellInfoTdscdma2 = (android.hardware.radio.V1_2.CellInfoTdscdma) cellInfo2.tdscdma.get(0);
                    CellIdentityTdscdma convertHalCellIdentityTdscdma2 = convertHalCellIdentityTdscdma((Object) cellInfoTdscdma2.cellIdentityTdscdma);
                    cellSignalStrengthTdscdma3 = convertHalTdscdmaSignalStrength((Object) cellInfoTdscdma2.signalStrengthTdscdma);
                    cellSignalStrengthGsm4 = null;
                    cellSignalStrengthLte3 = null;
                    cellSignalStrengthWcdma4 = null;
                    cellIdentityGsm4 = null;
                    cellIdentityCdma4 = null;
                    cellIdentityLte4 = null;
                    cellIdentityWcdma4 = null;
                    cellConfigLte8 = null;
                    cellIdentityTdscdma3 = convertHalCellIdentityTdscdma2;
                }
                cellSignalStrengthGsm = cellSignalStrengthGsm4;
                cellIdentityGsm = cellIdentityGsm4;
                cellIdentityWcdma = cellIdentityWcdma4;
                cellIdentityTdscdma = cellIdentityTdscdma3;
                cellConfigLte = cellConfigLte8;
                cellConfigLte2 = cellConfigLte9;
                c = c3;
                cellSignalStrengthTdscdma = cellSignalStrengthTdscdma3;
                cellIdentityCdma = cellIdentityCdma4;
                cellIdentityLte = cellIdentityLte4;
                cellConfigLte3 = null;
                i = i4;
                z = z4;
                cellIdentityNr = null;
                CellSignalStrengthWcdma cellSignalStrengthWcdma5 = cellSignalStrengthWcdma4;
                cellSignalStrengthLte = cellSignalStrengthLte3;
                cellSignalStrengthWcdma = cellSignalStrengthWcdma5;
            } else {
                android.hardware.radio.V1_2.CellInfoGsm cellInfoGsm2 = (android.hardware.radio.V1_2.CellInfoGsm) cellInfo2.gsm.get(0);
                CellIdentityGsm convertHalCellIdentityGsm3 = convertHalCellIdentityGsm((Object) cellInfoGsm2.cellIdentityGsm);
                cellSignalStrengthGsm4 = convertHalGsmSignalStrength(cellInfoGsm2.signalStrengthGsm);
                cellSignalStrengthLte3 = null;
                cellSignalStrengthWcdma4 = null;
                cellSignalStrengthTdscdma3 = null;
                cellIdentityCdma4 = null;
                cellIdentityLte4 = null;
                cellIdentityWcdma4 = null;
                cellIdentityTdscdma3 = null;
                cellConfigLte8 = null;
                c3 = 1;
                cellIdentityGsm4 = convertHalCellIdentityGsm3;
            }
            cellConfigLte9 = cellConfigLte8;
            cellSignalStrengthGsm = cellSignalStrengthGsm4;
            cellIdentityGsm = cellIdentityGsm4;
            cellIdentityWcdma = cellIdentityWcdma4;
            cellIdentityTdscdma = cellIdentityTdscdma3;
            cellConfigLte = cellConfigLte8;
            cellConfigLte2 = cellConfigLte9;
            c = c3;
            cellSignalStrengthTdscdma = cellSignalStrengthTdscdma3;
            cellIdentityCdma = cellIdentityCdma4;
            cellIdentityLte = cellIdentityLte4;
            cellConfigLte3 = null;
            i = i4;
            z = z4;
            cellIdentityNr = null;
            CellSignalStrengthWcdma cellSignalStrengthWcdma52 = cellSignalStrengthWcdma4;
            cellSignalStrengthLte = cellSignalStrengthLte3;
            cellSignalStrengthWcdma = cellSignalStrengthWcdma52;
        } else if (obj2 instanceof android.hardware.radio.V1_4.CellInfo) {
            android.hardware.radio.V1_4.CellInfo cellInfo3 = (android.hardware.radio.V1_4.CellInfo) obj2;
            int i6 = cellInfo3.connectionStatus;
            boolean z5 = cellInfo3.isRegistered;
            byte discriminator = cellInfo3.info.getDiscriminator();
            if (discriminator == 0) {
                android.hardware.radio.V1_2.CellInfoGsm gsm = cellInfo3.info.gsm();
                CellIdentityGsm convertHalCellIdentityGsm4 = convertHalCellIdentityGsm((Object) gsm.cellIdentityGsm);
                cellSignalStrengthGsm3 = convertHalGsmSignalStrength(gsm.signalStrengthGsm);
                cellConfigLte6 = null;
                cellSignalStrengthLte = null;
                cellIdentityNr3 = null;
                cellSignalStrengthTdscdma2 = null;
                cellIdentityCdma3 = null;
                cellIdentityLte3 = null;
                cellIdentityWcdma3 = null;
                cellIdentityTdscdma = null;
                cellConfigLte = null;
                cellIdentityGsm3 = convertHalCellIdentityGsm4;
                c4 = 1;
                cellConfigLte7 = null;
                cellSignalStrengthWcdma3 = null;
            } else if (discriminator == 1) {
                android.hardware.radio.V1_2.CellInfoCdma cdma = cellInfo3.info.cdma();
                CellIdentityCdma convertHalCellIdentityCdma2 = convertHalCellIdentityCdma((Object) cdma.cellIdentityCdma);
                cellConfigLte6 = convertHalCdmaSignalStrength(cdma.signalStrengthCdma, cdma.signalStrengthEvdo);
                cellSignalStrengthGsm3 = null;
                cellSignalStrengthLte = null;
                cellSignalStrengthWcdma3 = null;
                cellSignalStrengthTdscdma2 = null;
                cellIdentityGsm3 = null;
                cellIdentityLte3 = null;
                cellIdentityWcdma3 = null;
                cellIdentityTdscdma = null;
                cellConfigLte = null;
                cellIdentityCdma3 = convertHalCellIdentityCdma2;
                c4 = 2;
                cellConfigLte7 = null;
                cellIdentityNr3 = null;
            } else if (discriminator != 2) {
                if (discriminator == 3) {
                    android.hardware.radio.V1_2.CellInfoTdscdma tdscdma = cellInfo3.info.tdscdma();
                    CellIdentityTdscdma convertHalCellIdentityTdscdma3 = convertHalCellIdentityTdscdma((Object) tdscdma.cellIdentityTdscdma);
                    cellSignalStrengthTdscdma2 = convertHalTdscdmaSignalStrength((Object) tdscdma.signalStrengthTdscdma);
                    cellSignalStrengthGsm3 = null;
                    cellSignalStrengthLte = null;
                    cellIdentityNr3 = null;
                    cellSignalStrengthWcdma3 = null;
                    cellIdentityGsm3 = null;
                    cellIdentityCdma3 = null;
                    cellIdentityLte3 = null;
                    cellIdentityWcdma3 = null;
                    cellConfigLte = null;
                    cellIdentityTdscdma = convertHalCellIdentityTdscdma3;
                    c4 = 5;
                    cellConfigLte7 = null;
                } else if (discriminator == 4) {
                    android.hardware.radio.V1_4.CellInfoLte lte = cellInfo3.info.lte();
                    CellIdentityLte convertHalCellIdentityLte3 = convertHalCellIdentityLte((Object) lte.base.cellIdentityLte);
                    CellSignalStrengthLte convertHalLteSignalStrength2 = convertHalLteSignalStrength((Object) lte.base.signalStrengthLte);
                    CellConfigLte cellConfigLte12 = new CellConfigLte(lte.cellConfig.isEndcAvailable);
                    cellSignalStrengthGsm3 = null;
                    cellIdentityNr3 = null;
                    cellSignalStrengthWcdma3 = null;
                    cellSignalStrengthTdscdma2 = null;
                    cellIdentityGsm3 = null;
                    cellIdentityCdma3 = null;
                    cellIdentityWcdma3 = null;
                    cellIdentityTdscdma = null;
                    cellIdentityLte3 = convertHalCellIdentityLte3;
                    cellConfigLte = cellConfigLte12;
                    c4 = 3;
                    cellConfigLte7 = null;
                    cellSignalStrengthLte = convertHalLteSignalStrength2;
                } else if (discriminator != 5) {
                    return null;
                } else {
                    CellInfoNr nr = cellInfo3.info.nr();
                    cellSignalStrengthLte = null;
                    cellSignalStrengthWcdma3 = null;
                    cellSignalStrengthTdscdma2 = null;
                    cellIdentityGsm3 = null;
                    cellIdentityCdma3 = null;
                    cellIdentityLte3 = null;
                    cellIdentityWcdma3 = null;
                    cellIdentityTdscdma = null;
                    cellConfigLte = null;
                    c4 = 6;
                    cellIdentityNr3 = convertHalCellIdentityNr((Object) nr.cellidentity);
                    cellConfigLte7 = convertHalNrSignalStrength((Object) nr.signalStrength);
                    cellSignalStrengthGsm3 = null;
                    cellConfigLte6 = null;
                }
                cellConfigLte6 = cellConfigLte7;
            } else {
                android.hardware.radio.V1_2.CellInfoWcdma wcdma = cellInfo3.info.wcdma();
                CellIdentityWcdma convertHalCellIdentityWcdma3 = convertHalCellIdentityWcdma((Object) wcdma.cellIdentityWcdma);
                cellSignalStrengthWcdma3 = convertHalWcdmaSignalStrength((Object) wcdma.signalStrengthWcdma);
                cellSignalStrengthGsm3 = null;
                cellConfigLte6 = null;
                cellSignalStrengthLte = null;
                cellIdentityNr3 = null;
                cellSignalStrengthTdscdma2 = null;
                cellIdentityGsm3 = null;
                cellIdentityCdma3 = null;
                cellIdentityLte3 = null;
                cellIdentityTdscdma = null;
                cellConfigLte = null;
                cellIdentityWcdma3 = convertHalCellIdentityWcdma3;
                cellConfigLte7 = null;
            }
            cellSignalStrengthGsm = cellSignalStrengthGsm3;
            cellIdentityGsm = cellIdentityGsm3;
            cellIdentityWcdma = cellIdentityWcdma3;
            z = z5;
            cellIdentityLte = cellIdentityLte3;
            c = c4;
            cellSignalStrengthWcdma = cellSignalStrengthWcdma3;
            cellConfigLte2 = cellConfigLte6;
            cellConfigLte3 = cellConfigLte7;
            cellSignalStrengthTdscdma = cellSignalStrengthTdscdma2;
            i = i6;
            cellIdentityNr = cellIdentityNr3;
            cellIdentityCdma = cellIdentityCdma3;
        } else {
            if (obj2 instanceof android.hardware.radio.V1_5.CellInfo) {
                android.hardware.radio.V1_5.CellInfo cellInfo4 = (android.hardware.radio.V1_5.CellInfo) obj2;
                i2 = cellInfo4.connectionStatus;
                z2 = cellInfo4.registered;
                byte discriminator2 = cellInfo4.ratSpecificInfo.getDiscriminator();
                if (discriminator2 == 0) {
                    android.hardware.radio.V1_5.CellInfoGsm gsm2 = cellInfo4.ratSpecificInfo.gsm();
                    convertHalCellIdentityGsm = convertHalCellIdentityGsm((Object) gsm2.cellIdentityGsm);
                    convertHalGsmSignalStrength = convertHalGsmSignalStrength(gsm2.signalStrengthGsm);
                    cellConfigLte3 = null;
                    cellSignalStrengthLte2 = null;
                    cellSignalStrengthWcdma2 = null;
                    cellIdentityNr2 = null;
                    cellIdentityCdma2 = null;
                    cellIdentityLte2 = null;
                    cellIdentityWcdma2 = null;
                    cellIdentityTdscdma2 = null;
                    cellConfigLte4 = null;
                    cellIdentityGsm2 = convertHalCellIdentityGsm;
                    c4 = 1;
                    cellConfigLte5 = null;
                    convertHalTdscdmaSignalStrength = null;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma5 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma5;
                } else if (discriminator2 != 1) {
                    if (discriminator2 == 2) {
                        android.hardware.radio.V1_5.CellInfoTdscdma tdscdma2 = cellInfo4.ratSpecificInfo.tdscdma();
                        CellIdentityTdscdma convertHalCellIdentityTdscdma4 = convertHalCellIdentityTdscdma((Object) tdscdma2.cellIdentityTdscdma);
                        convertHalTdscdmaSignalStrength = convertHalTdscdmaSignalStrength((Object) tdscdma2.signalStrengthTdscdma);
                        cellSignalStrengthGsm2 = null;
                        cellSignalStrengthLte2 = null;
                        cellSignalStrengthWcdma2 = null;
                        cellIdentityGsm2 = null;
                        cellIdentityNr2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityLte2 = null;
                        cellIdentityWcdma2 = null;
                        cellConfigLte4 = null;
                        cellIdentityTdscdma2 = convertHalCellIdentityTdscdma4;
                        c2 = 5;
                        cellConfigLte5 = null;
                    } else if (discriminator2 == 3) {
                        android.hardware.radio.V1_5.CellInfoLte lte2 = cellInfo4.ratSpecificInfo.lte();
                        CellIdentityLte convertHalCellIdentityLte4 = convertHalCellIdentityLte((Object) lte2.cellIdentityLte);
                        CellSignalStrengthLte convertHalLteSignalStrength3 = convertHalLteSignalStrength((Object) lte2.signalStrengthLte);
                        cellSignalStrengthWcdma2 = null;
                        convertHalTdscdmaSignalStrength = null;
                        cellIdentityGsm2 = null;
                        cellIdentityNr2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityWcdma2 = null;
                        cellIdentityTdscdma2 = null;
                        cellIdentityLte2 = convertHalCellIdentityLte4;
                        cellConfigLte4 = new CellConfigLte();
                        c2 = 3;
                        cellSignalStrengthLte2 = convertHalLteSignalStrength3;
                        cellSignalStrengthGsm2 = null;
                        cellConfigLte5 = null;
                    } else if (discriminator2 == 4) {
                        android.hardware.radio.V1_5.CellInfoNr nr2 = cellInfo4.ratSpecificInfo.nr();
                        convertHalCellIdentityNr = convertHalCellIdentityNr((Object) nr2.cellIdentityNr);
                        convertHalNrSignalStrength = convertHalNrSignalStrength((Object) nr2.signalStrengthNr);
                        cellSignalStrengthLte2 = null;
                        cellSignalStrengthWcdma2 = null;
                        convertHalTdscdmaSignalStrength = null;
                        cellIdentityGsm2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityLte2 = null;
                        cellIdentityWcdma2 = null;
                        cellIdentityTdscdma2 = null;
                        cellConfigLte4 = null;
                        c4 = 6;
                        cellIdentityNr2 = convertHalCellIdentityNr;
                        cellConfigLte3 = convertHalNrSignalStrength;
                        cellSignalStrengthGsm2 = null;
                        cellConfigLte5 = null;
                        cellSignalStrengthGsm = cellSignalStrengthGsm2;
                        cellIdentityGsm = cellIdentityGsm2;
                        cellIdentityWcdma = cellIdentityWcdma2;
                        i = i2;
                        cellIdentityNr = cellIdentityNr2;
                        cellIdentityLte = cellIdentityLte2;
                        c = c4;
                        cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                        z = z2;
                        cellIdentityCdma = cellIdentityCdma2;
                        CellSignalStrengthTdscdma cellSignalStrengthTdscdma52 = convertHalTdscdmaSignalStrength;
                        cellConfigLte2 = cellConfigLte5;
                        cellSignalStrengthTdscdma = cellSignalStrengthTdscdma52;
                    } else if (discriminator2 != 5) {
                        return null;
                    } else {
                        android.hardware.radio.V1_2.CellInfoCdma cdma2 = cellInfo4.ratSpecificInfo.cdma();
                        convertHalCellIdentityCdma = convertHalCellIdentityCdma((Object) cdma2.cellIdentityCdma);
                        convertHalCdmaSignalStrength = convertHalCdmaSignalStrength(cdma2.signalStrengthCdma, cdma2.signalStrengthEvdo);
                    }
                    cellConfigLte3 = cellConfigLte5;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma522 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma522;
                } else {
                    android.hardware.radio.V1_5.CellInfoWcdma wcdma2 = cellInfo4.ratSpecificInfo.wcdma();
                    convertHalCellIdentityWcdma = convertHalCellIdentityWcdma((Object) wcdma2.cellIdentityWcdma);
                    convertHalWcdmaSignalStrength = convertHalWcdmaSignalStrength((Object) wcdma2.signalStrengthWcdma);
                    cellSignalStrengthWcdma2 = convertHalWcdmaSignalStrength;
                    cellSignalStrengthGsm2 = null;
                    cellConfigLte3 = null;
                    cellSignalStrengthLte2 = null;
                    convertHalTdscdmaSignalStrength = null;
                    cellIdentityGsm2 = null;
                    cellIdentityNr2 = null;
                    cellIdentityCdma2 = null;
                    cellIdentityLte2 = null;
                    cellIdentityTdscdma2 = null;
                    cellConfigLte4 = null;
                    cellIdentityWcdma2 = convertHalCellIdentityWcdma;
                    cellConfigLte5 = null;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma5222 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma5222;
                }
            } else if (!(obj2 instanceof android.hardware.radio.V1_6.CellInfo)) {
                return null;
            } else {
                android.hardware.radio.V1_6.CellInfo cellInfo5 = (android.hardware.radio.V1_6.CellInfo) obj2;
                i2 = cellInfo5.connectionStatus;
                z2 = cellInfo5.registered;
                byte discriminator3 = cellInfo5.ratSpecificInfo.getDiscriminator();
                if (discriminator3 == 0) {
                    android.hardware.radio.V1_5.CellInfoGsm gsm3 = cellInfo5.ratSpecificInfo.gsm();
                    convertHalCellIdentityGsm = convertHalCellIdentityGsm((Object) gsm3.cellIdentityGsm);
                    convertHalGsmSignalStrength = convertHalGsmSignalStrength(gsm3.signalStrengthGsm);
                    cellConfigLte3 = null;
                    cellSignalStrengthLte2 = null;
                    cellSignalStrengthWcdma2 = null;
                    cellIdentityNr2 = null;
                    cellIdentityCdma2 = null;
                    cellIdentityLte2 = null;
                    cellIdentityWcdma2 = null;
                    cellIdentityTdscdma2 = null;
                    cellConfigLte4 = null;
                    cellIdentityGsm2 = convertHalCellIdentityGsm;
                    c4 = 1;
                    cellConfigLte5 = null;
                    convertHalTdscdmaSignalStrength = null;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma52222 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma52222;
                } else if (discriminator3 != 1) {
                    if (discriminator3 == 2) {
                        android.hardware.radio.V1_5.CellInfoTdscdma tdscdma3 = cellInfo5.ratSpecificInfo.tdscdma();
                        CellIdentityTdscdma convertHalCellIdentityTdscdma5 = convertHalCellIdentityTdscdma((Object) tdscdma3.cellIdentityTdscdma);
                        convertHalTdscdmaSignalStrength = convertHalTdscdmaSignalStrength((Object) tdscdma3.signalStrengthTdscdma);
                        cellSignalStrengthGsm2 = null;
                        cellSignalStrengthLte2 = null;
                        cellSignalStrengthWcdma2 = null;
                        cellIdentityGsm2 = null;
                        cellIdentityNr2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityLte2 = null;
                        cellIdentityWcdma2 = null;
                        cellConfigLte4 = null;
                        cellIdentityTdscdma2 = convertHalCellIdentityTdscdma5;
                        c2 = 5;
                        cellConfigLte5 = null;
                    } else if (discriminator3 == 3) {
                        android.hardware.radio.V1_6.CellInfoLte lte3 = cellInfo5.ratSpecificInfo.lte();
                        CellIdentityLte convertHalCellIdentityLte5 = convertHalCellIdentityLte((Object) lte3.cellIdentityLte);
                        CellSignalStrengthLte convertHalLteSignalStrength4 = convertHalLteSignalStrength((Object) lte3.signalStrengthLte);
                        cellSignalStrengthWcdma2 = null;
                        convertHalTdscdmaSignalStrength = null;
                        cellIdentityGsm2 = null;
                        cellIdentityNr2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityWcdma2 = null;
                        cellIdentityTdscdma2 = null;
                        cellIdentityLte2 = convertHalCellIdentityLte5;
                        cellConfigLte4 = new CellConfigLte();
                        c2 = 3;
                        cellSignalStrengthLte2 = convertHalLteSignalStrength4;
                        cellSignalStrengthGsm2 = null;
                        cellConfigLte5 = null;
                    } else if (discriminator3 == 4) {
                        android.hardware.radio.V1_6.CellInfoNr nr3 = cellInfo5.ratSpecificInfo.nr();
                        convertHalCellIdentityNr = convertHalCellIdentityNr((Object) nr3.cellIdentityNr);
                        convertHalNrSignalStrength = convertHalNrSignalStrength((Object) nr3.signalStrengthNr);
                        cellSignalStrengthLte2 = null;
                        cellSignalStrengthWcdma2 = null;
                        convertHalTdscdmaSignalStrength = null;
                        cellIdentityGsm2 = null;
                        cellIdentityCdma2 = null;
                        cellIdentityLte2 = null;
                        cellIdentityWcdma2 = null;
                        cellIdentityTdscdma2 = null;
                        cellConfigLte4 = null;
                        c4 = 6;
                        cellIdentityNr2 = convertHalCellIdentityNr;
                        cellConfigLte3 = convertHalNrSignalStrength;
                        cellSignalStrengthGsm2 = null;
                        cellConfigLte5 = null;
                        cellSignalStrengthGsm = cellSignalStrengthGsm2;
                        cellIdentityGsm = cellIdentityGsm2;
                        cellIdentityWcdma = cellIdentityWcdma2;
                        i = i2;
                        cellIdentityNr = cellIdentityNr2;
                        cellIdentityLte = cellIdentityLte2;
                        c = c4;
                        cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                        z = z2;
                        cellIdentityCdma = cellIdentityCdma2;
                        CellSignalStrengthTdscdma cellSignalStrengthTdscdma522222 = convertHalTdscdmaSignalStrength;
                        cellConfigLte2 = cellConfigLte5;
                        cellSignalStrengthTdscdma = cellSignalStrengthTdscdma522222;
                    } else if (discriminator3 != 5) {
                        return null;
                    } else {
                        android.hardware.radio.V1_2.CellInfoCdma cdma3 = cellInfo5.ratSpecificInfo.cdma();
                        convertHalCellIdentityCdma = convertHalCellIdentityCdma((Object) cdma3.cellIdentityCdma);
                        convertHalCdmaSignalStrength = convertHalCdmaSignalStrength(cdma3.signalStrengthCdma, cdma3.signalStrengthEvdo);
                    }
                    cellConfigLte3 = cellConfigLte5;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma5222222 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma5222222;
                } else {
                    android.hardware.radio.V1_5.CellInfoWcdma wcdma3 = cellInfo5.ratSpecificInfo.wcdma();
                    convertHalCellIdentityWcdma = convertHalCellIdentityWcdma((Object) wcdma3.cellIdentityWcdma);
                    convertHalWcdmaSignalStrength = convertHalWcdmaSignalStrength((Object) wcdma3.signalStrengthWcdma);
                    cellSignalStrengthWcdma2 = convertHalWcdmaSignalStrength;
                    cellSignalStrengthGsm2 = null;
                    cellConfigLte3 = null;
                    cellSignalStrengthLte2 = null;
                    convertHalTdscdmaSignalStrength = null;
                    cellIdentityGsm2 = null;
                    cellIdentityNr2 = null;
                    cellIdentityCdma2 = null;
                    cellIdentityLte2 = null;
                    cellIdentityTdscdma2 = null;
                    cellConfigLte4 = null;
                    cellIdentityWcdma2 = convertHalCellIdentityWcdma;
                    cellConfigLte5 = null;
                    cellSignalStrengthGsm = cellSignalStrengthGsm2;
                    cellIdentityGsm = cellIdentityGsm2;
                    cellIdentityWcdma = cellIdentityWcdma2;
                    i = i2;
                    cellIdentityNr = cellIdentityNr2;
                    cellIdentityLte = cellIdentityLte2;
                    c = c4;
                    cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
                    z = z2;
                    cellIdentityCdma = cellIdentityCdma2;
                    CellSignalStrengthTdscdma cellSignalStrengthTdscdma52222222 = convertHalTdscdmaSignalStrength;
                    cellConfigLte2 = cellConfigLte5;
                    cellSignalStrengthTdscdma = cellSignalStrengthTdscdma52222222;
                }
            }
            cellConfigLte3 = null;
            cellSignalStrengthLte2 = null;
            convertHalTdscdmaSignalStrength = null;
            cellIdentityGsm2 = null;
            cellIdentityNr2 = null;
            cellIdentityLte2 = null;
            cellIdentityWcdma2 = null;
            cellIdentityTdscdma2 = null;
            cellConfigLte4 = null;
            cellIdentityCdma2 = convertHalCellIdentityCdma;
            c4 = 2;
            cellConfigLte5 = convertHalCdmaSignalStrength;
            cellSignalStrengthGsm2 = null;
            cellSignalStrengthWcdma2 = null;
            cellSignalStrengthGsm = cellSignalStrengthGsm2;
            cellIdentityGsm = cellIdentityGsm2;
            cellIdentityWcdma = cellIdentityWcdma2;
            i = i2;
            cellIdentityNr = cellIdentityNr2;
            cellIdentityLte = cellIdentityLte2;
            c = c4;
            cellSignalStrengthWcdma = cellSignalStrengthWcdma2;
            z = z2;
            cellIdentityCdma = cellIdentityCdma2;
            CellSignalStrengthTdscdma cellSignalStrengthTdscdma522222222 = convertHalTdscdmaSignalStrength;
            cellConfigLte2 = cellConfigLte5;
            cellSignalStrengthTdscdma = cellSignalStrengthTdscdma522222222;
        }
        switch (c) {
            case 1:
                return new android.telephony.CellInfoGsm(i, z, j, cellIdentityGsm, cellSignalStrengthGsm);
            case 2:
                return new android.telephony.CellInfoCdma(i, z, j, cellIdentityCdma, cellConfigLte2);
            case 3:
                return new android.telephony.CellInfoLte(i, z, j, cellIdentityLte, cellSignalStrengthLte, cellConfigLte);
            case 4:
                return new android.telephony.CellInfoWcdma(i, z, j, cellIdentityWcdma, cellSignalStrengthWcdma);
            case 5:
                return new android.telephony.CellInfoTdscdma(i, z, j, cellIdentityTdscdma, cellSignalStrengthTdscdma);
            case 6:
                return new android.telephony.CellInfoNr(i, z, j, cellIdentityNr, cellConfigLte3);
            default:
                return null;
        }
    }

    private static CellInfo convertHalCellInfo(android.hardware.radio.network.CellInfo cellInfo, long j) {
        if (cellInfo == null) {
            return null;
        }
        int i = cellInfo.connectionStatus;
        boolean z = cellInfo.registered;
        int tag = cellInfo.ratSpecificInfo.getTag();
        if (tag == 0) {
            android.hardware.radio.network.CellInfoGsm gsm = cellInfo.ratSpecificInfo.getGsm();
            return new android.telephony.CellInfoGsm(i, z, j, convertHalCellIdentityGsm(gsm.cellIdentityGsm), convertHalGsmSignalStrength(gsm.signalStrengthGsm));
        } else if (tag == 1) {
            android.hardware.radio.network.CellInfoWcdma wcdma = cellInfo.ratSpecificInfo.getWcdma();
            return new android.telephony.CellInfoWcdma(i, z, j, convertHalCellIdentityWcdma(wcdma.cellIdentityWcdma), convertHalWcdmaSignalStrength(wcdma.signalStrengthWcdma));
        } else if (tag == 2) {
            android.hardware.radio.network.CellInfoTdscdma tdscdma = cellInfo.ratSpecificInfo.getTdscdma();
            return new android.telephony.CellInfoTdscdma(i, z, j, convertHalCellIdentityTdscdma(tdscdma.cellIdentityTdscdma), convertHalTdscdmaSignalStrength(tdscdma.signalStrengthTdscdma));
        } else if (tag == 3) {
            android.hardware.radio.network.CellInfoLte lte = cellInfo.ratSpecificInfo.getLte();
            return new android.telephony.CellInfoLte(i, z, j, convertHalCellIdentityLte(lte.cellIdentityLte), convertHalLteSignalStrength(lte.signalStrengthLte), new CellConfigLte());
        } else if (tag == 4) {
            android.hardware.radio.network.CellInfoNr nr = cellInfo.ratSpecificInfo.getNr();
            return new android.telephony.CellInfoNr(i, z, j, convertHalCellIdentityNr(nr.cellIdentityNr), convertHalNrSignalStrength(nr.signalStrengthNr));
        } else if (tag != 5) {
            return null;
        } else {
            android.hardware.radio.network.CellInfoCdma cdma = cellInfo.ratSpecificInfo.getCdma();
            return new android.telephony.CellInfoCdma(i, z, j, convertHalCellIdentityCdma(cdma.cellIdentityCdma), convertHalCdmaSignalStrength(cdma.signalStrengthCdma, cdma.signalStrengthEvdo));
        }
    }

    public static CellIdentity convertHalCellIdentity(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.CellIdentity) {
            android.hardware.radio.V1_0.CellIdentity cellIdentity = (android.hardware.radio.V1_0.CellIdentity) obj;
            int i = cellIdentity.cellInfoType;
            if (i != 1) {
                if (i != 2) {
                    if (i != 3) {
                        if (i != 4) {
                            if (i == 5 && cellIdentity.cellIdentityTdscdma.size() == 1) {
                                return convertHalCellIdentityTdscdma(cellIdentity.cellIdentityTdscdma.get(0));
                            }
                        } else if (cellIdentity.cellIdentityWcdma.size() == 1) {
                            return convertHalCellIdentityWcdma(cellIdentity.cellIdentityWcdma.get(0));
                        }
                    } else if (cellIdentity.cellIdentityLte.size() == 1) {
                        return convertHalCellIdentityLte(cellIdentity.cellIdentityLte.get(0));
                    }
                } else if (cellIdentity.cellIdentityCdma.size() == 1) {
                    return convertHalCellIdentityCdma(cellIdentity.cellIdentityCdma.get(0));
                }
            } else if (cellIdentity.cellIdentityGsm.size() == 1) {
                return convertHalCellIdentityGsm(cellIdentity.cellIdentityGsm.get(0));
            }
        } else if (obj instanceof android.hardware.radio.V1_2.CellIdentity) {
            android.hardware.radio.V1_2.CellIdentity cellIdentity2 = (android.hardware.radio.V1_2.CellIdentity) obj;
            int i2 = cellIdentity2.cellInfoType;
            if (i2 != 1) {
                if (i2 != 2) {
                    if (i2 != 3) {
                        if (i2 != 4) {
                            if (i2 == 5 && cellIdentity2.cellIdentityTdscdma.size() == 1) {
                                return convertHalCellIdentityTdscdma(cellIdentity2.cellIdentityTdscdma.get(0));
                            }
                        } else if (cellIdentity2.cellIdentityWcdma.size() == 1) {
                            return convertHalCellIdentityWcdma(cellIdentity2.cellIdentityWcdma.get(0));
                        }
                    } else if (cellIdentity2.cellIdentityLte.size() == 1) {
                        return convertHalCellIdentityLte(cellIdentity2.cellIdentityLte.get(0));
                    }
                } else if (cellIdentity2.cellIdentityCdma.size() == 1) {
                    return convertHalCellIdentityCdma(cellIdentity2.cellIdentityCdma.get(0));
                }
            } else if (cellIdentity2.cellIdentityGsm.size() == 1) {
                return convertHalCellIdentityGsm(cellIdentity2.cellIdentityGsm.get(0));
            }
        } else if (obj instanceof android.hardware.radio.V1_5.CellIdentity) {
            android.hardware.radio.V1_5.CellIdentity cellIdentity3 = (android.hardware.radio.V1_5.CellIdentity) obj;
            switch (cellIdentity3.getDiscriminator()) {
                case 1:
                    return convertHalCellIdentityGsm((Object) cellIdentity3.gsm());
                case 2:
                    return convertHalCellIdentityWcdma((Object) cellIdentity3.wcdma());
                case 3:
                    return convertHalCellIdentityTdscdma((Object) cellIdentity3.tdscdma());
                case 4:
                    return convertHalCellIdentityCdma((Object) cellIdentity3.cdma());
                case 5:
                    return convertHalCellIdentityLte((Object) cellIdentity3.lte());
                case 6:
                    return convertHalCellIdentityNr((Object) cellIdentity3.nr());
            }
        }
        return null;
    }

    public static CellIdentity convertHalCellIdentity(android.hardware.radio.network.CellIdentity cellIdentity) {
        if (cellIdentity == null) {
            return null;
        }
        switch (cellIdentity.getTag()) {
            case 1:
                return convertHalCellIdentityGsm(cellIdentity.getGsm());
            case 2:
                return convertHalCellIdentityWcdma(cellIdentity.getWcdma());
            case 3:
                return convertHalCellIdentityTdscdma(cellIdentity.getTdscdma());
            case 4:
                return convertHalCellIdentityCdma(cellIdentity.getCdma());
            case 5:
                return convertHalCellIdentityLte(cellIdentity.getLte());
            case 6:
                return convertHalCellIdentityNr(cellIdentity.getNr());
            default:
                return null;
        }
    }

    public static CellIdentityGsm convertHalCellIdentityGsm(Object obj) {
        CellIdentityGsm cellIdentityGsm = null;
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.CellIdentityGsm) {
            android.hardware.radio.V1_0.CellIdentityGsm cellIdentityGsm2 = (android.hardware.radio.V1_0.CellIdentityGsm) obj;
            int i = cellIdentityGsm2.lac;
            int i2 = cellIdentityGsm2.cid;
            int i3 = cellIdentityGsm2.arfcn;
            byte b = cellIdentityGsm2.bsic;
            return new CellIdentityGsm(i, i2, i3, b == -1 ? 2147483647 : b, cellIdentityGsm2.mcc, cellIdentityGsm2.mnc, "", "", new ArraySet());
        } else if (obj instanceof android.hardware.radio.V1_2.CellIdentityGsm) {
            android.hardware.radio.V1_2.CellIdentityGsm cellIdentityGsm3 = (android.hardware.radio.V1_2.CellIdentityGsm) obj;
            android.hardware.radio.V1_0.CellIdentityGsm cellIdentityGsm4 = cellIdentityGsm3.base;
            int i4 = cellIdentityGsm4.lac;
            int i5 = cellIdentityGsm4.cid;
            int i6 = cellIdentityGsm4.arfcn;
            byte b2 = cellIdentityGsm4.bsic;
            byte b3 = b2 == -1 ? 2147483647 : b2;
            String str = cellIdentityGsm4.mcc;
            String str2 = cellIdentityGsm4.mnc;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityGsm3.operatorNames;
            return new CellIdentityGsm(i4, i5, i6, b3, str, str2, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort, new ArraySet());
        } else {
            if (obj instanceof android.hardware.radio.V1_5.CellIdentityGsm) {
                android.hardware.radio.V1_5.CellIdentityGsm cellIdentityGsm5 = (android.hardware.radio.V1_5.CellIdentityGsm) obj;
                android.hardware.radio.V1_2.CellIdentityGsm cellIdentityGsm6 = cellIdentityGsm5.base;
                android.hardware.radio.V1_0.CellIdentityGsm cellIdentityGsm7 = cellIdentityGsm6.base;
                int i7 = cellIdentityGsm7.lac;
                int i8 = cellIdentityGsm7.cid;
                int i9 = cellIdentityGsm7.arfcn;
                byte b4 = cellIdentityGsm7.bsic;
                if (b4 == -1) {
                    b4 = 2147483647;
                }
                String str3 = cellIdentityGsm7.mcc;
                String str4 = cellIdentityGsm7.mnc;
                CellIdentityOperatorNames cellIdentityOperatorNames2 = cellIdentityGsm6.operatorNames;
                cellIdentityGsm = new CellIdentityGsm(i7, i8, i9, b4, str3, str4, cellIdentityOperatorNames2.alphaLong, cellIdentityOperatorNames2.alphaShort, cellIdentityGsm5.additionalPlmns);
            }
            return cellIdentityGsm;
        }
    }

    public static CellIdentityGsm convertHalCellIdentityGsm(android.hardware.radio.network.CellIdentityGsm cellIdentityGsm) {
        int i = cellIdentityGsm.lac;
        int i2 = cellIdentityGsm.cid;
        int i3 = cellIdentityGsm.arfcn;
        byte b = cellIdentityGsm.bsic;
        if (b == -1) {
            b = UByte.MAX_VALUE;
        }
        String str = cellIdentityGsm.mcc;
        String str2 = cellIdentityGsm.mnc;
        OperatorInfo operatorInfo = cellIdentityGsm.operatorNames;
        return new CellIdentityGsm(i, i2, i3, b, str, str2, operatorInfo.alphaLong, operatorInfo.alphaShort, new ArraySet());
    }

    public static CellIdentityCdma convertHalCellIdentityCdma(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.CellIdentityCdma) {
            android.hardware.radio.V1_0.CellIdentityCdma cellIdentityCdma = (android.hardware.radio.V1_0.CellIdentityCdma) obj;
            return new CellIdentityCdma(cellIdentityCdma.networkId, cellIdentityCdma.systemId, cellIdentityCdma.baseStationId, cellIdentityCdma.longitude, cellIdentityCdma.latitude, "", "");
        } else if (!(obj instanceof android.hardware.radio.V1_2.CellIdentityCdma)) {
            return null;
        } else {
            android.hardware.radio.V1_2.CellIdentityCdma cellIdentityCdma2 = (android.hardware.radio.V1_2.CellIdentityCdma) obj;
            android.hardware.radio.V1_0.CellIdentityCdma cellIdentityCdma3 = cellIdentityCdma2.base;
            int i = cellIdentityCdma3.networkId;
            int i2 = cellIdentityCdma3.systemId;
            int i3 = cellIdentityCdma3.baseStationId;
            int i4 = cellIdentityCdma3.longitude;
            int i5 = cellIdentityCdma3.latitude;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityCdma2.operatorNames;
            return new CellIdentityCdma(i, i2, i3, i4, i5, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort);
        }
    }

    public static CellIdentityCdma convertHalCellIdentityCdma(android.hardware.radio.network.CellIdentityCdma cellIdentityCdma) {
        int i = cellIdentityCdma.networkId;
        int i2 = cellIdentityCdma.systemId;
        int i3 = cellIdentityCdma.baseStationId;
        int i4 = cellIdentityCdma.longitude;
        int i5 = cellIdentityCdma.latitude;
        OperatorInfo operatorInfo = cellIdentityCdma.operatorNames;
        return new CellIdentityCdma(i, i2, i3, i4, i5, operatorInfo.alphaLong, operatorInfo.alphaShort);
    }

    public static CellIdentityLte convertHalCellIdentityLte(Object obj) {
        Object obj2 = obj;
        if (obj2 == null) {
            return null;
        }
        if (obj2 instanceof android.hardware.radio.V1_0.CellIdentityLte) {
            android.hardware.radio.V1_0.CellIdentityLte cellIdentityLte = (android.hardware.radio.V1_0.CellIdentityLte) obj2;
            return new CellIdentityLte(cellIdentityLte.ci, cellIdentityLte.pci, cellIdentityLte.tac, cellIdentityLte.earfcn, new int[0], Integer.MAX_VALUE, cellIdentityLte.mcc, cellIdentityLte.mnc, "", "", new ArraySet(), (ClosedSubscriberGroupInfo) null);
        } else if (obj2 instanceof android.hardware.radio.V1_2.CellIdentityLte) {
            android.hardware.radio.V1_2.CellIdentityLte cellIdentityLte2 = (android.hardware.radio.V1_2.CellIdentityLte) obj2;
            android.hardware.radio.V1_0.CellIdentityLte cellIdentityLte3 = cellIdentityLte2.base;
            int i = cellIdentityLte2.bandwidth;
            String str = cellIdentityLte3.mcc;
            String str2 = cellIdentityLte3.mnc;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityLte2.operatorNames;
            return new CellIdentityLte(cellIdentityLte3.ci, cellIdentityLte3.pci, cellIdentityLte3.tac, cellIdentityLte3.earfcn, new int[0], i, str, str2, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort, new ArraySet(), (ClosedSubscriberGroupInfo) null);
        } else if (!(obj2 instanceof android.hardware.radio.V1_5.CellIdentityLte)) {
            return null;
        } else {
            android.hardware.radio.V1_5.CellIdentityLte cellIdentityLte4 = (android.hardware.radio.V1_5.CellIdentityLte) obj2;
            android.hardware.radio.V1_0.CellIdentityLte cellIdentityLte5 = cellIdentityLte4.base.base;
            int i2 = cellIdentityLte5.ci;
            int i3 = cellIdentityLte5.pci;
            int i4 = cellIdentityLte5.tac;
            int i5 = cellIdentityLte5.earfcn;
            int[] array = cellIdentityLte4.bands.stream().mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray();
            android.hardware.radio.V1_2.CellIdentityLte cellIdentityLte6 = cellIdentityLte4.base;
            int i6 = cellIdentityLte6.bandwidth;
            android.hardware.radio.V1_0.CellIdentityLte cellIdentityLte7 = cellIdentityLte6.base;
            String str3 = cellIdentityLte7.mcc;
            String str4 = cellIdentityLte7.mnc;
            CellIdentityOperatorNames cellIdentityOperatorNames2 = cellIdentityLte6.operatorNames;
            return new CellIdentityLte(i2, i3, i4, i5, array, i6, str3, str4, cellIdentityOperatorNames2.alphaLong, cellIdentityOperatorNames2.alphaShort, cellIdentityLte4.additionalPlmns, convertHalClosedSubscriberGroupInfo(cellIdentityLte4.optionalCsgInfo));
        }
    }

    public static CellIdentityLte convertHalCellIdentityLte(android.hardware.radio.network.CellIdentityLte cellIdentityLte) {
        int i = cellIdentityLte.ci;
        int i2 = cellIdentityLte.pci;
        int i3 = cellIdentityLte.tac;
        int i4 = cellIdentityLte.earfcn;
        int[] iArr = cellIdentityLte.bands;
        int i5 = cellIdentityLte.bandwidth;
        String str = cellIdentityLte.mcc;
        String str2 = cellIdentityLte.mnc;
        OperatorInfo operatorInfo = cellIdentityLte.operatorNames;
        return new CellIdentityLte(i, i2, i3, i4, iArr, i5, str, str2, operatorInfo.alphaLong, operatorInfo.alphaShort, primitiveArrayToArrayList(cellIdentityLte.additionalPlmns), convertHalClosedSubscriberGroupInfo(cellIdentityLte.csgInfo));
    }

    public static CellIdentityWcdma convertHalCellIdentityWcdma(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.CellIdentityWcdma) {
            android.hardware.radio.V1_0.CellIdentityWcdma cellIdentityWcdma = (android.hardware.radio.V1_0.CellIdentityWcdma) obj;
            return new CellIdentityWcdma(cellIdentityWcdma.lac, cellIdentityWcdma.cid, cellIdentityWcdma.psc, cellIdentityWcdma.uarfcn, cellIdentityWcdma.mcc, cellIdentityWcdma.mnc, "", "", new ArraySet(), (ClosedSubscriberGroupInfo) null);
        } else if (obj instanceof android.hardware.radio.V1_2.CellIdentityWcdma) {
            android.hardware.radio.V1_2.CellIdentityWcdma cellIdentityWcdma2 = (android.hardware.radio.V1_2.CellIdentityWcdma) obj;
            android.hardware.radio.V1_0.CellIdentityWcdma cellIdentityWcdma3 = cellIdentityWcdma2.base;
            int i = cellIdentityWcdma3.lac;
            int i2 = cellIdentityWcdma3.cid;
            int i3 = cellIdentityWcdma3.psc;
            int i4 = cellIdentityWcdma3.uarfcn;
            String str = cellIdentityWcdma3.mcc;
            String str2 = cellIdentityWcdma3.mnc;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityWcdma2.operatorNames;
            return new CellIdentityWcdma(i, i2, i3, i4, str, str2, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort, new ArraySet(), (ClosedSubscriberGroupInfo) null);
        } else if (!(obj instanceof android.hardware.radio.V1_5.CellIdentityWcdma)) {
            return null;
        } else {
            android.hardware.radio.V1_5.CellIdentityWcdma cellIdentityWcdma4 = (android.hardware.radio.V1_5.CellIdentityWcdma) obj;
            android.hardware.radio.V1_2.CellIdentityWcdma cellIdentityWcdma5 = cellIdentityWcdma4.base;
            android.hardware.radio.V1_0.CellIdentityWcdma cellIdentityWcdma6 = cellIdentityWcdma5.base;
            int i5 = cellIdentityWcdma6.lac;
            int i6 = cellIdentityWcdma6.cid;
            int i7 = cellIdentityWcdma6.psc;
            int i8 = cellIdentityWcdma6.uarfcn;
            String str3 = cellIdentityWcdma6.mcc;
            String str4 = cellIdentityWcdma6.mnc;
            CellIdentityOperatorNames cellIdentityOperatorNames2 = cellIdentityWcdma5.operatorNames;
            return new CellIdentityWcdma(i5, i6, i7, i8, str3, str4, cellIdentityOperatorNames2.alphaLong, cellIdentityOperatorNames2.alphaShort, cellIdentityWcdma4.additionalPlmns, convertHalClosedSubscriberGroupInfo(cellIdentityWcdma4.optionalCsgInfo));
        }
    }

    public static CellIdentityWcdma convertHalCellIdentityWcdma(android.hardware.radio.network.CellIdentityWcdma cellIdentityWcdma) {
        int i = cellIdentityWcdma.lac;
        int i2 = cellIdentityWcdma.cid;
        int i3 = cellIdentityWcdma.psc;
        int i4 = cellIdentityWcdma.uarfcn;
        String str = cellIdentityWcdma.mcc;
        String str2 = cellIdentityWcdma.mnc;
        OperatorInfo operatorInfo = cellIdentityWcdma.operatorNames;
        return new CellIdentityWcdma(i, i2, i3, i4, str, str2, operatorInfo.alphaLong, operatorInfo.alphaShort, primitiveArrayToArrayList(cellIdentityWcdma.additionalPlmns), convertHalClosedSubscriberGroupInfo(cellIdentityWcdma.csgInfo));
    }

    public static CellIdentityTdscdma convertHalCellIdentityTdscdma(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.CellIdentityTdscdma) {
            android.hardware.radio.V1_0.CellIdentityTdscdma cellIdentityTdscdma = (android.hardware.radio.V1_0.CellIdentityTdscdma) obj;
            return new CellIdentityTdscdma(cellIdentityTdscdma.mcc, cellIdentityTdscdma.mnc, cellIdentityTdscdma.lac, cellIdentityTdscdma.cid, cellIdentityTdscdma.cpid, Integer.MAX_VALUE, "", "", Collections.emptyList(), (ClosedSubscriberGroupInfo) null);
        } else if (obj instanceof android.hardware.radio.V1_2.CellIdentityTdscdma) {
            android.hardware.radio.V1_2.CellIdentityTdscdma cellIdentityTdscdma2 = (android.hardware.radio.V1_2.CellIdentityTdscdma) obj;
            android.hardware.radio.V1_0.CellIdentityTdscdma cellIdentityTdscdma3 = cellIdentityTdscdma2.base;
            String str = cellIdentityTdscdma3.mcc;
            String str2 = cellIdentityTdscdma3.mnc;
            int i = cellIdentityTdscdma3.lac;
            int i2 = cellIdentityTdscdma3.cid;
            int i3 = cellIdentityTdscdma3.cpid;
            int i4 = cellIdentityTdscdma2.uarfcn;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityTdscdma2.operatorNames;
            return new CellIdentityTdscdma(str, str2, i, i2, i3, i4, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort, Collections.emptyList(), (ClosedSubscriberGroupInfo) null);
        } else if (!(obj instanceof android.hardware.radio.V1_5.CellIdentityTdscdma)) {
            return null;
        } else {
            android.hardware.radio.V1_5.CellIdentityTdscdma cellIdentityTdscdma4 = (android.hardware.radio.V1_5.CellIdentityTdscdma) obj;
            android.hardware.radio.V1_2.CellIdentityTdscdma cellIdentityTdscdma5 = cellIdentityTdscdma4.base;
            android.hardware.radio.V1_0.CellIdentityTdscdma cellIdentityTdscdma6 = cellIdentityTdscdma5.base;
            String str3 = cellIdentityTdscdma6.mcc;
            String str4 = cellIdentityTdscdma6.mnc;
            int i5 = cellIdentityTdscdma6.lac;
            int i6 = cellIdentityTdscdma6.cid;
            int i7 = cellIdentityTdscdma6.cpid;
            int i8 = cellIdentityTdscdma5.uarfcn;
            CellIdentityOperatorNames cellIdentityOperatorNames2 = cellIdentityTdscdma5.operatorNames;
            return new CellIdentityTdscdma(str3, str4, i5, i6, i7, i8, cellIdentityOperatorNames2.alphaLong, cellIdentityOperatorNames2.alphaShort, cellIdentityTdscdma4.additionalPlmns, convertHalClosedSubscriberGroupInfo(cellIdentityTdscdma4.optionalCsgInfo));
        }
    }

    public static CellIdentityTdscdma convertHalCellIdentityTdscdma(android.hardware.radio.network.CellIdentityTdscdma cellIdentityTdscdma) {
        String str = cellIdentityTdscdma.mcc;
        String str2 = cellIdentityTdscdma.mnc;
        int i = cellIdentityTdscdma.lac;
        int i2 = cellIdentityTdscdma.cid;
        int i3 = cellIdentityTdscdma.cpid;
        int i4 = cellIdentityTdscdma.uarfcn;
        OperatorInfo operatorInfo = cellIdentityTdscdma.operatorNames;
        return new CellIdentityTdscdma(str, str2, i, i2, i3, i4, operatorInfo.alphaLong, operatorInfo.alphaShort, primitiveArrayToArrayList(cellIdentityTdscdma.additionalPlmns), convertHalClosedSubscriberGroupInfo(cellIdentityTdscdma.csgInfo));
    }

    public static CellIdentityNr convertHalCellIdentityNr(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_4.CellIdentityNr) {
            android.hardware.radio.V1_4.CellIdentityNr cellIdentityNr = (android.hardware.radio.V1_4.CellIdentityNr) obj;
            String str = cellIdentityNr.mcc;
            String str2 = cellIdentityNr.mnc;
            long j = cellIdentityNr.nci;
            CellIdentityOperatorNames cellIdentityOperatorNames = cellIdentityNr.operatorNames;
            return new CellIdentityNr(cellIdentityNr.pci, cellIdentityNr.tac, cellIdentityNr.nrarfcn, new int[0], str, str2, j, cellIdentityOperatorNames.alphaLong, cellIdentityOperatorNames.alphaShort, new ArraySet());
        } else if (!(obj instanceof android.hardware.radio.V1_5.CellIdentityNr)) {
            return null;
        } else {
            android.hardware.radio.V1_5.CellIdentityNr cellIdentityNr2 = (android.hardware.radio.V1_5.CellIdentityNr) obj;
            android.hardware.radio.V1_4.CellIdentityNr cellIdentityNr3 = cellIdentityNr2.base;
            int i = cellIdentityNr3.pci;
            int i2 = cellIdentityNr3.tac;
            int i3 = cellIdentityNr3.nrarfcn;
            int[] array = cellIdentityNr2.bands.stream().mapToInt(new RILUtils$$ExternalSyntheticLambda5()).toArray();
            android.hardware.radio.V1_4.CellIdentityNr cellIdentityNr4 = cellIdentityNr2.base;
            String str3 = cellIdentityNr4.mcc;
            String str4 = cellIdentityNr4.mnc;
            long j2 = cellIdentityNr4.nci;
            CellIdentityOperatorNames cellIdentityOperatorNames2 = cellIdentityNr4.operatorNames;
            return new CellIdentityNr(i, i2, i3, array, str3, str4, j2, cellIdentityOperatorNames2.alphaLong, cellIdentityOperatorNames2.alphaShort, cellIdentityNr2.additionalPlmns);
        }
    }

    public static CellIdentityNr convertHalCellIdentityNr(android.hardware.radio.network.CellIdentityNr cellIdentityNr) {
        int i = cellIdentityNr.pci;
        int i2 = cellIdentityNr.tac;
        int i3 = cellIdentityNr.nrarfcn;
        int[] iArr = cellIdentityNr.bands;
        String str = cellIdentityNr.mcc;
        String str2 = cellIdentityNr.mnc;
        long j = cellIdentityNr.nci;
        OperatorInfo operatorInfo = cellIdentityNr.operatorNames;
        return new CellIdentityNr(i, i2, i3, iArr, str, str2, j, operatorInfo.alphaLong, operatorInfo.alphaShort, primitiveArrayToArrayList(cellIdentityNr.additionalPlmns));
    }

    public static SignalStrength convertHalSignalStrength(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof android.hardware.radio.V1_0.SignalStrength) {
            android.hardware.radio.V1_0.SignalStrength signalStrength = (android.hardware.radio.V1_0.SignalStrength) obj;
            return new SignalStrength(convertHalCdmaSignalStrength(signalStrength.cdma, signalStrength.evdo), convertHalGsmSignalStrength(signalStrength.gw), new CellSignalStrengthWcdma(), convertHalTdscdmaSignalStrength((Object) signalStrength.tdScdma), convertHalLteSignalStrength((Object) signalStrength.lte), new CellSignalStrengthNr());
        } else if (obj instanceof android.hardware.radio.V1_2.SignalStrength) {
            android.hardware.radio.V1_2.SignalStrength signalStrength2 = (android.hardware.radio.V1_2.SignalStrength) obj;
            return new SignalStrength(convertHalCdmaSignalStrength(signalStrength2.cdma, signalStrength2.evdo), convertHalGsmSignalStrength(signalStrength2.gsm), convertHalWcdmaSignalStrength((Object) signalStrength2.wcdma), convertHalTdscdmaSignalStrength((Object) signalStrength2.tdScdma), convertHalLteSignalStrength((Object) signalStrength2.lte), new CellSignalStrengthNr());
        } else if (obj instanceof android.hardware.radio.V1_4.SignalStrength) {
            android.hardware.radio.V1_4.SignalStrength signalStrength3 = (android.hardware.radio.V1_4.SignalStrength) obj;
            return new SignalStrength(convertHalCdmaSignalStrength(signalStrength3.cdma, signalStrength3.evdo), convertHalGsmSignalStrength(signalStrength3.gsm), convertHalWcdmaSignalStrength((Object) signalStrength3.wcdma), convertHalTdscdmaSignalStrength((Object) signalStrength3.tdscdma), convertHalLteSignalStrength((Object) signalStrength3.lte), convertHalNrSignalStrength((Object) signalStrength3.nr));
        } else if (!(obj instanceof android.hardware.radio.V1_6.SignalStrength)) {
            return null;
        } else {
            android.hardware.radio.V1_6.SignalStrength signalStrength4 = (android.hardware.radio.V1_6.SignalStrength) obj;
            return new SignalStrength(convertHalCdmaSignalStrength(signalStrength4.cdma, signalStrength4.evdo), convertHalGsmSignalStrength(signalStrength4.gsm), convertHalWcdmaSignalStrength((Object) signalStrength4.wcdma), convertHalTdscdmaSignalStrength((Object) signalStrength4.tdscdma), convertHalLteSignalStrength((Object) signalStrength4.lte), convertHalNrSignalStrength((Object) signalStrength4.nr));
        }
    }

    public static SignalStrength convertHalSignalStrength(android.hardware.radio.network.SignalStrength signalStrength) {
        return new SignalStrength(convertHalCdmaSignalStrength(signalStrength.cdma, signalStrength.evdo), convertHalGsmSignalStrength(signalStrength.gsm), convertHalWcdmaSignalStrength(signalStrength.wcdma), convertHalTdscdmaSignalStrength(signalStrength.tdscdma), convertHalLteSignalStrength(signalStrength.lte), convertHalNrSignalStrength(signalStrength.nr));
    }

    public static CellSignalStrengthGsm convertHalGsmSignalStrength(GsmSignalStrength gsmSignalStrength) {
        CellSignalStrengthGsm cellSignalStrengthGsm = new CellSignalStrengthGsm(CellSignalStrength.getRssiDbmFromAsu(gsmSignalStrength.signalStrength), gsmSignalStrength.bitErrorRate, gsmSignalStrength.timingAdvance);
        if (cellSignalStrengthGsm.getRssi() == Integer.MAX_VALUE) {
            cellSignalStrengthGsm.setDefaultValues();
            cellSignalStrengthGsm.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthGsm;
    }

    public static CellSignalStrengthGsm convertHalGsmSignalStrength(android.hardware.radio.network.GsmSignalStrength gsmSignalStrength) {
        CellSignalStrengthGsm cellSignalStrengthGsm = new CellSignalStrengthGsm(CellSignalStrength.getRssiDbmFromAsu(gsmSignalStrength.signalStrength), gsmSignalStrength.bitErrorRate, gsmSignalStrength.timingAdvance);
        if (cellSignalStrengthGsm.getRssi() == Integer.MAX_VALUE) {
            cellSignalStrengthGsm.setDefaultValues();
            cellSignalStrengthGsm.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthGsm;
    }

    public static CellSignalStrengthCdma convertHalCdmaSignalStrength(CdmaSignalStrength cdmaSignalStrength, EvdoSignalStrength evdoSignalStrength) {
        return new CellSignalStrengthCdma(-cdmaSignalStrength.dbm, -cdmaSignalStrength.ecio, -evdoSignalStrength.dbm, -evdoSignalStrength.ecio, evdoSignalStrength.signalNoiseRatio);
    }

    public static CellSignalStrengthCdma convertHalCdmaSignalStrength(android.hardware.radio.network.CdmaSignalStrength cdmaSignalStrength, android.hardware.radio.network.EvdoSignalStrength evdoSignalStrength) {
        return new CellSignalStrengthCdma(-cdmaSignalStrength.dbm, -cdmaSignalStrength.ecio, -evdoSignalStrength.dbm, -evdoSignalStrength.ecio, evdoSignalStrength.signalNoiseRatio);
    }

    public static CellSignalStrengthLte convertHalLteSignalStrength(Object obj) {
        CellSignalStrengthLte cellSignalStrengthLte = null;
        if (obj == null) {
            return null;
        }
        if (obj instanceof LteSignalStrength) {
            LteSignalStrength lteSignalStrength = (LteSignalStrength) obj;
            int convertRssiAsuToDBm = CellSignalStrengthLte.convertRssiAsuToDBm(lteSignalStrength.signalStrength);
            int i = lteSignalStrength.rsrp;
            if (i != Integer.MAX_VALUE) {
                i = -i;
            }
            int i2 = i;
            int i3 = lteSignalStrength.rsrq;
            if (i3 != Integer.MAX_VALUE) {
                i3 = -i3;
            }
            return new CellSignalStrengthLte(convertRssiAsuToDBm, i2, i3, CellSignalStrengthLte.convertRssnrUnitFromTenDbToDB(lteSignalStrength.rssnr), lteSignalStrength.cqi, lteSignalStrength.timingAdvance);
        }
        if (obj instanceof android.hardware.radio.V1_6.LteSignalStrength) {
            android.hardware.radio.V1_6.LteSignalStrength lteSignalStrength2 = (android.hardware.radio.V1_6.LteSignalStrength) obj;
            int convertRssiAsuToDBm2 = CellSignalStrengthLte.convertRssiAsuToDBm(lteSignalStrength2.base.signalStrength);
            LteSignalStrength lteSignalStrength3 = lteSignalStrength2.base;
            int i4 = lteSignalStrength3.rsrp;
            if (i4 != Integer.MAX_VALUE) {
                i4 = -i4;
            }
            int i5 = i4;
            int i6 = lteSignalStrength3.rsrq;
            int i7 = i6 != Integer.MAX_VALUE ? -i6 : i6;
            int convertRssnrUnitFromTenDbToDB = CellSignalStrengthLte.convertRssnrUnitFromTenDbToDB(lteSignalStrength3.rssnr);
            int i8 = lteSignalStrength2.cqiTableIndex;
            LteSignalStrength lteSignalStrength4 = lteSignalStrength2.base;
            cellSignalStrengthLte = new CellSignalStrengthLte(convertRssiAsuToDBm2, i5, i7, convertRssnrUnitFromTenDbToDB, i8, lteSignalStrength4.cqi, lteSignalStrength4.timingAdvance);
        }
        return cellSignalStrengthLte;
    }

    public static CellSignalStrengthLte convertHalLteSignalStrength(android.hardware.radio.network.LteSignalStrength lteSignalStrength) {
        int convertRssiAsuToDBm = CellSignalStrengthLte.convertRssiAsuToDBm(lteSignalStrength.signalStrength);
        int i = lteSignalStrength.rsrp;
        if (i != Integer.MAX_VALUE) {
            i = -i;
        }
        int i2 = i;
        int i3 = lteSignalStrength.rsrq;
        if (i3 != Integer.MAX_VALUE) {
            i3 = -i3;
        }
        return new CellSignalStrengthLte(convertRssiAsuToDBm, i2, i3, CellSignalStrengthLte.convertRssnrUnitFromTenDbToDB(lteSignalStrength.rssnr), lteSignalStrength.cqiTableIndex, lteSignalStrength.cqi, lteSignalStrength.timingAdvance);
    }

    public static CellSignalStrengthWcdma convertHalWcdmaSignalStrength(Object obj) {
        CellSignalStrengthWcdma cellSignalStrengthWcdma;
        if (obj == null) {
            return null;
        }
        if (obj instanceof WcdmaSignalStrength) {
            WcdmaSignalStrength wcdmaSignalStrength = (WcdmaSignalStrength) obj;
            cellSignalStrengthWcdma = new CellSignalStrengthWcdma(CellSignalStrength.getRssiDbmFromAsu(wcdmaSignalStrength.signalStrength), wcdmaSignalStrength.bitErrorRate, Integer.MAX_VALUE, Integer.MAX_VALUE);
        } else if (obj instanceof android.hardware.radio.V1_2.WcdmaSignalStrength) {
            android.hardware.radio.V1_2.WcdmaSignalStrength wcdmaSignalStrength2 = (android.hardware.radio.V1_2.WcdmaSignalStrength) obj;
            cellSignalStrengthWcdma = new CellSignalStrengthWcdma(CellSignalStrength.getRssiDbmFromAsu(wcdmaSignalStrength2.base.signalStrength), wcdmaSignalStrength2.base.bitErrorRate, CellSignalStrength.getRscpDbmFromAsu(wcdmaSignalStrength2.rscp), CellSignalStrength.getEcNoDbFromAsu(wcdmaSignalStrength2.ecno));
        } else {
            cellSignalStrengthWcdma = null;
        }
        if (cellSignalStrengthWcdma != null && cellSignalStrengthWcdma.getRssi() == Integer.MAX_VALUE && cellSignalStrengthWcdma.getRscp() == Integer.MAX_VALUE) {
            cellSignalStrengthWcdma.setDefaultValues();
            cellSignalStrengthWcdma.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthWcdma;
    }

    public static CellSignalStrengthWcdma convertHalWcdmaSignalStrength(android.hardware.radio.network.WcdmaSignalStrength wcdmaSignalStrength) {
        CellSignalStrengthWcdma cellSignalStrengthWcdma = new CellSignalStrengthWcdma(CellSignalStrength.getRssiDbmFromAsu(wcdmaSignalStrength.signalStrength), wcdmaSignalStrength.bitErrorRate, CellSignalStrength.getRscpDbmFromAsu(wcdmaSignalStrength.rscp), CellSignalStrength.getEcNoDbFromAsu(wcdmaSignalStrength.ecno));
        if (cellSignalStrengthWcdma.getRssi() == Integer.MAX_VALUE && cellSignalStrengthWcdma.getRscp() == Integer.MAX_VALUE) {
            cellSignalStrengthWcdma.setDefaultValues();
            cellSignalStrengthWcdma.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthWcdma;
    }

    public static CellSignalStrengthTdscdma convertHalTdscdmaSignalStrength(Object obj) {
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma;
        if (obj == null) {
            return null;
        }
        if (obj instanceof TdScdmaSignalStrength) {
            int i = ((TdScdmaSignalStrength) obj).rscp;
            if (i != Integer.MAX_VALUE) {
                i = -i;
            }
            cellSignalStrengthTdscdma = new CellSignalStrengthTdscdma(Integer.MAX_VALUE, Integer.MAX_VALUE, i);
        } else if (obj instanceof TdscdmaSignalStrength) {
            TdscdmaSignalStrength tdscdmaSignalStrength = (TdscdmaSignalStrength) obj;
            cellSignalStrengthTdscdma = new CellSignalStrengthTdscdma(CellSignalStrength.getRssiDbmFromAsu(tdscdmaSignalStrength.signalStrength), tdscdmaSignalStrength.bitErrorRate, CellSignalStrength.getRscpDbmFromAsu(tdscdmaSignalStrength.rscp));
        } else {
            cellSignalStrengthTdscdma = null;
        }
        if (cellSignalStrengthTdscdma != null && cellSignalStrengthTdscdma.getRssi() == Integer.MAX_VALUE && cellSignalStrengthTdscdma.getRscp() == Integer.MAX_VALUE) {
            cellSignalStrengthTdscdma.setDefaultValues();
            cellSignalStrengthTdscdma.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthTdscdma;
    }

    public static CellSignalStrengthTdscdma convertHalTdscdmaSignalStrength(android.hardware.radio.network.TdscdmaSignalStrength tdscdmaSignalStrength) {
        CellSignalStrengthTdscdma cellSignalStrengthTdscdma = new CellSignalStrengthTdscdma(CellSignalStrength.getRssiDbmFromAsu(tdscdmaSignalStrength.signalStrength), tdscdmaSignalStrength.bitErrorRate, CellSignalStrength.getRscpDbmFromAsu(tdscdmaSignalStrength.rscp));
        if (cellSignalStrengthTdscdma.getRssi() == Integer.MAX_VALUE && cellSignalStrengthTdscdma.getRscp() == Integer.MAX_VALUE) {
            cellSignalStrengthTdscdma.setDefaultValues();
            cellSignalStrengthTdscdma.updateLevel((PersistableBundle) null, (ServiceState) null);
        }
        return cellSignalStrengthTdscdma;
    }

    public static CellSignalStrengthNr convertHalNrSignalStrength(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof NrSignalStrength) {
            NrSignalStrength nrSignalStrength = (NrSignalStrength) obj;
            return new CellSignalStrengthNr(CellSignalStrengthNr.flip(nrSignalStrength.csiRsrp), CellSignalStrengthNr.flip(nrSignalStrength.csiRsrq), nrSignalStrength.csiSinr, CellSignalStrengthNr.flip(nrSignalStrength.ssRsrp), CellSignalStrengthNr.flip(nrSignalStrength.ssRsrq), nrSignalStrength.ssSinr);
        } else if (!(obj instanceof android.hardware.radio.V1_6.NrSignalStrength)) {
            return null;
        } else {
            android.hardware.radio.V1_6.NrSignalStrength nrSignalStrength2 = (android.hardware.radio.V1_6.NrSignalStrength) obj;
            int flip = CellSignalStrengthNr.flip(nrSignalStrength2.base.csiRsrp);
            int flip2 = CellSignalStrengthNr.flip(nrSignalStrength2.base.csiRsrq);
            NrSignalStrength nrSignalStrength3 = nrSignalStrength2.base;
            return new CellSignalStrengthNr(flip, flip2, nrSignalStrength3.csiSinr, nrSignalStrength2.csiCqiTableIndex, nrSignalStrength2.csiCqiReport, CellSignalStrengthNr.flip(nrSignalStrength3.ssRsrp), CellSignalStrengthNr.flip(nrSignalStrength2.base.ssRsrq), nrSignalStrength2.base.ssSinr);
        }
    }

    public static CellSignalStrengthNr convertHalNrSignalStrength(android.hardware.radio.network.NrSignalStrength nrSignalStrength) {
        return new CellSignalStrengthNr(CellSignalStrengthNr.flip(nrSignalStrength.csiRsrp), CellSignalStrengthNr.flip(nrSignalStrength.csiRsrq), nrSignalStrength.csiSinr, nrSignalStrength.csiCqiTableIndex, primitiveArrayToArrayList(nrSignalStrength.csiCqiReport), CellSignalStrengthNr.flip(nrSignalStrength.ssRsrp), CellSignalStrengthNr.flip(nrSignalStrength.ssRsrq), nrSignalStrength.ssSinr);
    }

    private static ClosedSubscriberGroupInfo convertHalClosedSubscriberGroupInfo(OptionalCsgInfo optionalCsgInfo) {
        android.hardware.radio.V1_5.ClosedSubscriberGroupInfo csgInfo = optionalCsgInfo.getDiscriminator() == 1 ? optionalCsgInfo.csgInfo() : null;
        if (csgInfo == null) {
            return null;
        }
        return new ClosedSubscriberGroupInfo(csgInfo.csgIndication, csgInfo.homeNodebName, csgInfo.csgIdentity);
    }

    private static ClosedSubscriberGroupInfo convertHalClosedSubscriberGroupInfo(android.hardware.radio.network.ClosedSubscriberGroupInfo closedSubscriberGroupInfo) {
        if (closedSubscriberGroupInfo == null) {
            return null;
        }
        return new ClosedSubscriberGroupInfo(closedSubscriberGroupInfo.csgIndication, closedSubscriberGroupInfo.homeNodebName, closedSubscriberGroupInfo.csgIdentity);
    }

    public static SparseArray<BarringInfo.BarringServiceInfo> convertHalBarringInfoList(List<android.hardware.radio.V1_5.BarringInfo> list) {
        SparseArray<BarringInfo.BarringServiceInfo> sparseArray = new SparseArray<>();
        for (android.hardware.radio.V1_5.BarringInfo next : list) {
            if (next.barringType != 1) {
                sparseArray.put(next.serviceType, new BarringInfo.BarringServiceInfo(next.barringType, false, 0, 0));
            } else if (next.barringTypeSpecificInfo.getDiscriminator() == 1) {
                BarringInfo.BarringTypeSpecificInfo.Conditional conditional = next.barringTypeSpecificInfo.conditional();
                sparseArray.put(next.serviceType, new BarringInfo.BarringServiceInfo(next.barringType, conditional.isBarred, conditional.factor, conditional.timeSeconds));
            }
        }
        return sparseArray;
    }

    public static SparseArray<BarringInfo.BarringServiceInfo> convertHalBarringInfoList(android.hardware.radio.network.BarringInfo[] barringInfoArr) {
        SparseArray<BarringInfo.BarringServiceInfo> sparseArray = new SparseArray<>();
        for (android.hardware.radio.network.BarringInfo barringInfo : barringInfoArr) {
            if (barringInfo.barringType != 1) {
                sparseArray.put(barringInfo.serviceType, new BarringInfo.BarringServiceInfo(barringInfo.barringType, false, 0, 0));
            } else if (barringInfo.barringTypeSpecificInfo != null) {
                int i = barringInfo.serviceType;
                int i2 = barringInfo.barringType;
                BarringTypeSpecificInfo barringTypeSpecificInfo = barringInfo.barringTypeSpecificInfo;
                sparseArray.put(i, new BarringInfo.BarringServiceInfo(i2, barringTypeSpecificInfo.isBarred, barringTypeSpecificInfo.factor, barringTypeSpecificInfo.timeSeconds));
            }
        }
        return sparseArray;
    }

    private static android.net.LinkAddress convertToLinkAddress(String str) {
        return convertToLinkAddress(str, 0, -1, -1);
    }

    /* access modifiers changed from: private */
    public static android.net.LinkAddress convertToLinkAddress(String str, int i, long j, long j2) {
        int i2;
        InetAddress inetAddress;
        int i3;
        String trim = str.trim();
        try {
            String[] split = trim.split("/", 2);
            InetAddress parseNumericAddress = InetAddresses.parseNumericAddress(split[0]);
            if (split.length == 1) {
                i3 = parseNumericAddress instanceof Inet4Address ? 32 : 128;
            } else {
                i3 = split.length == 2 ? Integer.parseInt(split[1]) : -1;
            }
            inetAddress = parseNumericAddress;
            i2 = i3;
        } catch (ArrayIndexOutOfBoundsException | IllegalArgumentException | NullPointerException | NumberFormatException unused) {
            i2 = -1;
            inetAddress = null;
        }
        if (inetAddress != null && i2 != -1) {
            return new android.net.LinkAddress(inetAddress, i2, i, 0, j, j2);
        }
        throw new IllegalArgumentException("Invalid link address " + trim);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v20, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v8, resolved type: java.util.List} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v43, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v24, resolved type: java.util.List} */
    /* JADX WARNING: type inference failed for: r1v22, types: [java.lang.Object[]] */
    /* JADX WARNING: type inference failed for: r1v45, types: [java.lang.Object[]] */
    /* JADX WARNING: type inference failed for: r3v16, types: [java.lang.Object[]] */
    /* JADX WARNING: type inference failed for: r13v18, types: [java.lang.Object[]] */
    /* JADX WARNING: type inference failed for: r3v20, types: [java.lang.Object[]] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Removed duplicated region for block: B:59:0x0289  */
    /* JADX WARNING: Removed duplicated region for block: B:69:0x02ca  */
    /* JADX WARNING: Removed duplicated region for block: B:72:0x02d7  */
    /* JADX WARNING: Removed duplicated region for block: B:83:0x0314  */
    @com.android.internal.annotations.VisibleForTesting
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static android.telephony.data.DataCallResponse convertHalDataCallResult(java.lang.Object r30) {
        /*
            r0 = r30
            r1 = 0
            if (r0 != 0) goto L_0x0006
            return r1
        L_0x0006:
            java.util.ArrayList r2 = new java.util.ArrayList
            r2.<init>()
            java.util.ArrayList r3 = new java.util.ArrayList
            r3.<init>()
            java.util.ArrayList r4 = new java.util.ArrayList
            r4.<init>()
            boolean r5 = r0 instanceof android.hardware.radio.V1_0.SetupDataCallResult
            if (r5 == 0) goto L_0x00a4
            android.hardware.radio.V1_0.SetupDataCallResult r0 = (android.hardware.radio.V1_0.SetupDataCallResult) r0
            int r5 = r0.status
            int r7 = r0.suggestedRetryTime
            long r7 = (long) r7
            int r9 = r0.cid
            int r10 = r0.active
            java.lang.String r11 = r0.type
            int r11 = android.telephony.data.ApnSetting.getProtocolIntFromString(r11)
            java.lang.String r12 = r0.ifname
            java.lang.String r13 = r0.addresses
            boolean r13 = android.text.TextUtils.isEmpty(r13)
            java.lang.String r14 = "\\s+"
            if (r13 != 0) goto L_0x003d
            java.lang.String r13 = r0.addresses
            java.lang.String[] r13 = r13.split(r14)
            goto L_0x003e
        L_0x003d:
            r13 = r1
        L_0x003e:
            java.lang.String r15 = r0.dnses
            boolean r15 = android.text.TextUtils.isEmpty(r15)
            if (r15 != 0) goto L_0x004d
            java.lang.String r15 = r0.dnses
            java.lang.String[] r15 = r15.split(r14)
            goto L_0x004e
        L_0x004d:
            r15 = r1
        L_0x004e:
            java.lang.String r1 = r0.gateways
            boolean r1 = android.text.TextUtils.isEmpty(r1)
            if (r1 != 0) goto L_0x005d
            java.lang.String r1 = r0.gateways
            java.lang.String[] r1 = r1.split(r14)
            goto L_0x005e
        L_0x005d:
            r1 = 0
        L_0x005e:
            java.lang.String r6 = r0.pcscf
            boolean r6 = android.text.TextUtils.isEmpty(r6)
            if (r6 != 0) goto L_0x006d
            java.lang.String r6 = r0.pcscf
            java.lang.String[] r6 = r6.split(r14)
            goto L_0x006e
        L_0x006d:
            r6 = 0
        L_0x006e:
            int r0 = r0.mtu
            if (r13 == 0) goto L_0x0088
            int r14 = r13.length
            r30 = r0
            r0 = 0
        L_0x0076:
            if (r0 >= r14) goto L_0x008a
            r18 = r13[r0]
            r19 = r1
            android.net.LinkAddress r1 = convertToLinkAddress(r18)
            r2.add(r1)
            int r0 = r0 + 1
            r1 = r19
            goto L_0x0076
        L_0x0088:
            r30 = r0
        L_0x008a:
            r19 = r1
            r13 = r30
            r18 = r4
            r4 = r9
            r1 = r19
            r16 = 0
            r20 = 0
            r21 = 0
            r22 = 0
            r19 = r3
            r9 = r5
            r5 = r10
            r3 = r13
            r10 = r6
            r6 = r3
            goto L_0x0181
        L_0x00a4:
            boolean r1 = r0 instanceof android.hardware.radio.V1_4.SetupDataCallResult
            if (r1 == 0) goto L_0x0114
            android.hardware.radio.V1_4.SetupDataCallResult r0 = (android.hardware.radio.V1_4.SetupDataCallResult) r0
            int r5 = r0.cause
            int r1 = r0.suggestedRetryTime
            long r7 = (long) r1
            int r9 = r0.cid
            int r10 = r0.active
            int r11 = r0.type
            java.lang.String r12 = r0.ifname
            java.util.ArrayList r1 = r0.addresses
            r6 = 0
            java.lang.String[] r13 = new java.lang.String[r6]
            java.lang.Object[] r1 = r1.toArray(r13)
            java.lang.String[] r1 = (java.lang.String[]) r1
            java.util.ArrayList r13 = r0.dnses
            java.lang.String[] r14 = new java.lang.String[r6]
            java.lang.Object[] r13 = r13.toArray(r14)
            r15 = r13
            java.lang.String[] r15 = (java.lang.String[]) r15
            java.util.ArrayList r13 = r0.gateways
            java.lang.String[] r14 = new java.lang.String[r6]
            java.lang.Object[] r13 = r13.toArray(r14)
            java.lang.String[] r13 = (java.lang.String[]) r13
            java.util.ArrayList r14 = r0.pcscf
            r18 = r3
            java.lang.String[] r3 = new java.lang.String[r6]
            java.lang.Object[] r3 = r14.toArray(r3)
            r6 = r3
            java.lang.String[] r6 = (java.lang.String[]) r6
            int r0 = r0.mtu
            if (r1 == 0) goto L_0x00fc
            int r3 = r1.length
            r14 = 0
        L_0x00ea:
            if (r14 >= r3) goto L_0x00fc
            r19 = r1[r14]
            r30 = r0
            android.net.LinkAddress r0 = convertToLinkAddress(r19)
            r2.add(r0)
            int r14 = r14 + 1
            r0 = r30
            goto L_0x00ea
        L_0x00fc:
            r30 = r0
            r3 = r30
            r1 = r13
            r19 = r18
            r16 = 0
            r20 = 0
            r21 = 0
            r22 = 0
            r13 = r3
            r18 = r4
            r4 = r9
            r9 = r5
            r5 = r10
            r10 = r6
            r6 = r13
            goto L_0x0181
        L_0x0114:
            r18 = r3
            boolean r1 = r0 instanceof android.hardware.radio.V1_5.SetupDataCallResult
            if (r1 == 0) goto L_0x018b
            android.hardware.radio.V1_5.SetupDataCallResult r0 = (android.hardware.radio.V1_5.SetupDataCallResult) r0
            int r5 = r0.cause
            int r1 = r0.suggestedRetryTime
            long r7 = (long) r1
            int r9 = r0.cid
            int r10 = r0.active
            int r11 = r0.type
            java.lang.String r12 = r0.ifname
            java.util.ArrayList r1 = r0.addresses
            java.util.stream.Stream r1 = r1.stream()
            com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda2 r2 = new com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda2
            r2.<init>()
            java.util.stream.Stream r1 = r1.map(r2)
            java.util.stream.Collector r2 = java.util.stream.Collectors.toList()
            java.lang.Object r1 = r1.collect(r2)
            r2 = r1
            java.util.List r2 = (java.util.List) r2
            java.util.ArrayList r1 = r0.dnses
            r3 = 0
            java.lang.String[] r6 = new java.lang.String[r3]
            java.lang.Object[] r1 = r1.toArray(r6)
            r15 = r1
            java.lang.String[] r15 = (java.lang.String[]) r15
            java.util.ArrayList r1 = r0.gateways
            java.lang.String[] r6 = new java.lang.String[r3]
            java.lang.Object[] r1 = r1.toArray(r6)
            java.lang.String[] r1 = (java.lang.String[]) r1
            java.util.ArrayList r6 = r0.pcscf
            java.lang.String[] r13 = new java.lang.String[r3]
            java.lang.Object[] r3 = r6.toArray(r13)
            r6 = r3
            java.lang.String[] r6 = (java.lang.String[]) r6
            int r3 = r0.mtuV4
            int r13 = r0.mtuV6
            int r3 = java.lang.Math.max(r3, r13)
            int r13 = r0.mtuV4
            int r0 = r0.mtuV6
            r19 = r18
            r16 = 0
            r20 = 0
            r21 = 0
            r22 = 0
            r18 = r4
            r4 = r9
            r9 = r5
            r5 = r10
            r10 = r6
            r6 = r0
        L_0x0181:
            r28 = r7
            r7 = r2
            r8 = r11
            r2 = r12
            r12 = r15
            r14 = r28
            goto L_0x027e
        L_0x018b:
            boolean r1 = r0 instanceof android.hardware.radio.V1_6.SetupDataCallResult
            if (r1 == 0) goto L_0x03b4
            android.hardware.radio.V1_6.SetupDataCallResult r0 = (android.hardware.radio.V1_6.SetupDataCallResult) r0
            int r5 = r0.cause
            long r7 = r0.suggestedRetryTime
            int r9 = r0.cid
            int r10 = r0.active
            int r11 = r0.type
            java.lang.String r12 = r0.ifname
            java.util.ArrayList r1 = r0.addresses
            java.util.stream.Stream r1 = r1.stream()
            com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda3 r2 = new com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda3
            r2.<init>()
            java.util.stream.Stream r1 = r1.map(r2)
            java.util.stream.Collector r2 = java.util.stream.Collectors.toList()
            java.lang.Object r1 = r1.collect(r2)
            r2 = r1
            java.util.List r2 = (java.util.List) r2
            java.util.ArrayList r1 = r0.dnses
            r6 = 0
            java.lang.String[] r3 = new java.lang.String[r6]
            java.lang.Object[] r1 = r1.toArray(r3)
            r15 = r1
            java.lang.String[] r15 = (java.lang.String[]) r15
            java.util.ArrayList r1 = r0.gateways
            java.lang.String[] r3 = new java.lang.String[r6]
            java.lang.Object[] r1 = r1.toArray(r3)
            java.lang.String[] r1 = (java.lang.String[]) r1
            java.util.ArrayList r3 = r0.pcscf
            java.lang.String[] r13 = new java.lang.String[r6]
            java.lang.Object[] r3 = r3.toArray(r13)
            java.lang.String[] r3 = (java.lang.String[]) r3
            int r13 = r0.mtuV4
            int r14 = r0.mtuV6
            int r13 = java.lang.Math.max(r13, r14)
            int r14 = r0.mtuV4
            int r6 = r0.mtuV6
            r30 = r1
            byte r1 = r0.handoverFailureMode
            r18 = r1
            int r1 = r0.pduSessionId
            r19 = r1
            android.hardware.radio.V1_6.Qos r1 = r0.defaultQos
            android.telephony.data.Qos r1 = convertHalQos((android.hardware.radio.V1_6.Qos) r1)
            r20 = r1
            java.util.ArrayList r1 = r0.qosSessions
            java.util.stream.Stream r1 = r1.stream()
            r21 = r2
            com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda4 r2 = new com.android.internal.telephony.RILUtils$$ExternalSyntheticLambda4
            r2.<init>()
            java.util.stream.Stream r1 = r1.map(r2)
            java.util.stream.Collector r2 = java.util.stream.Collectors.toList()
            java.lang.Object r1 = r1.collect(r2)
            java.util.List r1 = (java.util.List) r1
            android.hardware.radio.V1_6.OptionalSliceInfo r2 = r0.sliceInfo
            byte r2 = r2.getDiscriminator()
            if (r2 != 0) goto L_0x021b
            r16 = 0
            goto L_0x0227
        L_0x021b:
            android.hardware.radio.V1_6.OptionalSliceInfo r2 = r0.sliceInfo
            android.hardware.radio.V1_6.SliceInfo r2 = r2.value()
            android.telephony.data.NetworkSliceInfo r2 = convertHalSliceInfo((android.hardware.radio.V1_6.SliceInfo) r2)
            r16 = r2
        L_0x0227:
            java.util.ArrayList r0 = r0.trafficDescriptors
            java.util.Iterator r2 = r0.iterator()
        L_0x022d:
            boolean r0 = r2.hasNext()
            if (r0 == 0) goto L_0x0263
            java.lang.Object r0 = r2.next()
            android.hardware.radio.V1_6.TrafficDescriptor r0 = (android.hardware.radio.V1_6.TrafficDescriptor) r0
            android.telephony.data.TrafficDescriptor r0 = convertHalTrafficDescriptor((android.hardware.radio.V1_6.TrafficDescriptor) r0)     // Catch:{ IllegalArgumentException -> 0x0245 }
            r4.add(r0)     // Catch:{ IllegalArgumentException -> 0x0245 }
            r22 = r1
            r23 = r2
            goto L_0x025e
        L_0x0245:
            r0 = move-exception
            r22 = r1
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r23 = r2
            java.lang.String r2 = "convertHalDataCallResult: Failed to convert traffic descriptor. e="
            r1.append(r2)
            r1.append(r0)
            java.lang.String r0 = r1.toString()
            loge(r0)
        L_0x025e:
            r1 = r22
            r2 = r23
            goto L_0x022d
        L_0x0263:
            r22 = r1
            r1 = r30
            r2 = r12
            r12 = r15
            r28 = r10
            r10 = r3
            r3 = r13
            r13 = r14
            r14 = r7
            r8 = r11
            r7 = r21
            r21 = r19
            r19 = r22
            r22 = r18
            r18 = r4
            r4 = r9
            r9 = r5
            r5 = r28
        L_0x027e:
            java.util.ArrayList r11 = new java.util.ArrayList
            r11.<init>()
            r23 = r6
            java.lang.String r6 = "RILUtils"
            if (r12 == 0) goto L_0x02ca
            r30 = r13
            int r13 = r12.length
            r24 = r3
            r3 = 0
        L_0x028f:
            if (r3 >= r13) goto L_0x02c7
            r0 = r12[r3]
            r25 = r12
            java.lang.String r12 = r0.trim()
            java.net.InetAddress r0 = android.net.InetAddresses.parseNumericAddress(r12)     // Catch:{ IllegalArgumentException -> 0x02a5 }
            r11.add(r0)     // Catch:{ IllegalArgumentException -> 0x02a5 }
            r27 = r11
            r26 = r13
            goto L_0x02be
        L_0x02a5:
            r0 = move-exception
            r26 = r13
            java.lang.StringBuilder r13 = new java.lang.StringBuilder
            r13.<init>()
            r27 = r11
            java.lang.String r11 = "Unknown dns: "
            r13.append(r11)
            r13.append(r12)
            java.lang.String r11 = r13.toString()
            com.android.telephony.Rlog.e(r6, r11, r0)
        L_0x02be:
            int r3 = r3 + 1
            r12 = r25
            r13 = r26
            r11 = r27
            goto L_0x028f
        L_0x02c7:
            r27 = r11
            goto L_0x02d0
        L_0x02ca:
            r24 = r3
            r27 = r11
            r30 = r13
        L_0x02d0:
            java.util.ArrayList r3 = new java.util.ArrayList
            r3.<init>()
            if (r1 == 0) goto L_0x030d
            int r11 = r1.length
            r12 = 0
        L_0x02d9:
            if (r12 >= r11) goto L_0x030d
            r0 = r1[r12]
            java.lang.String r13 = r0.trim()
            java.net.InetAddress r0 = android.net.InetAddresses.parseNumericAddress(r13)     // Catch:{ IllegalArgumentException -> 0x02ed }
            r3.add(r0)     // Catch:{ IllegalArgumentException -> 0x02ed }
            r25 = r1
            r26 = r11
            goto L_0x0306
        L_0x02ed:
            r0 = move-exception
            r25 = r1
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r26 = r11
            java.lang.String r11 = "Unknown gateway: "
            r1.append(r11)
            r1.append(r13)
            java.lang.String r1 = r1.toString()
            com.android.telephony.Rlog.e(r6, r1, r0)
        L_0x0306:
            int r12 = r12 + 1
            r1 = r25
            r11 = r26
            goto L_0x02d9
        L_0x030d:
            java.util.ArrayList r1 = new java.util.ArrayList
            r1.<init>()
            if (r10 == 0) goto L_0x034a
            int r11 = r10.length
            r12 = 0
        L_0x0316:
            if (r12 >= r11) goto L_0x034a
            r0 = r10[r12]
            java.lang.String r13 = r0.trim()
            java.net.InetAddress r0 = android.net.InetAddresses.parseNumericAddress(r13)     // Catch:{ IllegalArgumentException -> 0x032a }
            r1.add(r0)     // Catch:{ IllegalArgumentException -> 0x032a }
            r17 = r10
            r25 = r11
            goto L_0x0343
        L_0x032a:
            r0 = move-exception
            r17 = r10
            java.lang.StringBuilder r10 = new java.lang.StringBuilder
            r10.<init>()
            r25 = r11
            java.lang.String r11 = "Unknown pcscf: "
            r10.append(r11)
            r10.append(r13)
            java.lang.String r10 = r10.toString()
            com.android.telephony.Rlog.e(r6, r10, r0)
        L_0x0343:
            int r12 = r12 + 1
            r10 = r17
            r11 = r25
            goto L_0x0316
        L_0x034a:
            android.telephony.data.DataCallResponse$Builder r0 = new android.telephony.data.DataCallResponse$Builder
            r0.<init>()
            android.telephony.data.DataCallResponse$Builder r0 = r0.setCause(r9)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setRetryDurationMillis(r14)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setId(r4)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setLinkStatus(r5)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setProtocolType(r8)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setInterfaceName(r2)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setAddresses(r7)
            r2 = r27
            android.telephony.data.DataCallResponse$Builder r0 = r0.setDnsAddresses(r2)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setGatewayAddresses(r3)
            android.telephony.data.DataCallResponse$Builder r0 = r0.setPcscfAddresses(r1)
            r3 = r24
            android.telephony.data.DataCallResponse$Builder r0 = r0.setMtu(r3)
            r13 = r30
            android.telephony.data.DataCallResponse$Builder r0 = r0.setMtuV4(r13)
            r6 = r23
            android.telephony.data.DataCallResponse$Builder r0 = r0.setMtuV6(r6)
            r1 = r22
            android.telephony.data.DataCallResponse$Builder r0 = r0.setHandoverFailureMode(r1)
            r1 = r21
            android.telephony.data.DataCallResponse$Builder r0 = r0.setPduSessionId(r1)
            r1 = r20
            android.telephony.data.DataCallResponse$Builder r0 = r0.setDefaultQos(r1)
            r3 = r19
            android.telephony.data.DataCallResponse$Builder r0 = r0.setQosBearerSessions(r3)
            r1 = r16
            android.telephony.data.DataCallResponse$Builder r0 = r0.setSliceInfo(r1)
            r1 = r18
            android.telephony.data.DataCallResponse$Builder r0 = r0.setTrafficDescriptors(r1)
            android.telephony.data.DataCallResponse r0 = r0.build()
            return r0
        L_0x03b4:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "Unsupported SetupDataCallResult "
            r1.append(r2)
            r1.append(r0)
            java.lang.String r0 = r1.toString()
            loge(r0)
            r0 = 0
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertHalDataCallResult(java.lang.Object):android.telephony.data.DataCallResponse");
    }

    @VisibleForTesting
    public static DataCallResponse convertHalDataCallResult(SetupDataCallResult setupDataCallResult) {
        NetworkSliceInfo networkSliceInfo = null;
        if (setupDataCallResult == null) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        for (android.hardware.radio.data.LinkAddress linkAddress : setupDataCallResult.addresses) {
            arrayList.add(convertToLinkAddress(linkAddress.address, linkAddress.addressProperties, linkAddress.deprecationTime, linkAddress.expirationTime));
        }
        ArrayList arrayList2 = new ArrayList();
        String[] strArr = setupDataCallResult.dnses;
        if (strArr != null) {
            for (String trim : strArr) {
                String trim2 = trim.trim();
                try {
                    arrayList2.add(InetAddresses.parseNumericAddress(trim2));
                } catch (IllegalArgumentException e) {
                    Rlog.e(TAG, "Unknown dns: " + trim2, e);
                }
            }
        }
        ArrayList arrayList3 = new ArrayList();
        String[] strArr2 = setupDataCallResult.gateways;
        if (strArr2 != null) {
            for (String trim3 : strArr2) {
                String trim4 = trim3.trim();
                try {
                    arrayList3.add(InetAddresses.parseNumericAddress(trim4));
                } catch (IllegalArgumentException e2) {
                    Rlog.e(TAG, "Unknown gateway: " + trim4, e2);
                }
            }
        }
        ArrayList arrayList4 = new ArrayList();
        String[] strArr3 = setupDataCallResult.pcscf;
        if (strArr3 != null) {
            for (String trim5 : strArr3) {
                String trim6 = trim5.trim();
                try {
                    arrayList4.add(InetAddresses.parseNumericAddress(trim6));
                } catch (IllegalArgumentException e3) {
                    Rlog.e(TAG, "Unknown pcscf: " + trim6, e3);
                }
            }
        }
        ArrayList arrayList5 = new ArrayList();
        for (QosSession convertHalQosBearerSession : setupDataCallResult.qosSessions) {
            arrayList5.add(convertHalQosBearerSession(convertHalQosBearerSession));
        }
        ArrayList arrayList6 = new ArrayList();
        for (android.hardware.radio.data.TrafficDescriptor convertHalTrafficDescriptor : setupDataCallResult.trafficDescriptors) {
            try {
                arrayList6.add(convertHalTrafficDescriptor(convertHalTrafficDescriptor));
            } catch (IllegalArgumentException e4) {
                loge("convertHalDataCallResult: Failed to convert traffic descriptor. e=" + e4);
            }
        }
        DataCallResponse.Builder qosBearerSessions = new DataCallResponse.Builder().setCause(setupDataCallResult.cause).setRetryDurationMillis(setupDataCallResult.suggestedRetryTime).setId(setupDataCallResult.cid).setLinkStatus(setupDataCallResult.active).setProtocolType(setupDataCallResult.type).setInterfaceName(setupDataCallResult.ifname).setAddresses(arrayList).setDnsAddresses(arrayList2).setGatewayAddresses(arrayList3).setPcscfAddresses(arrayList4).setMtu(Math.max(setupDataCallResult.mtuV4, setupDataCallResult.mtuV6)).setMtuV4(setupDataCallResult.mtuV4).setMtuV6(setupDataCallResult.mtuV6).setHandoverFailureMode(setupDataCallResult.handoverFailureMode).setPduSessionId(setupDataCallResult.pduSessionId).setDefaultQos(convertHalQos(setupDataCallResult.defaultQos)).setQosBearerSessions(arrayList5);
        android.hardware.radio.data.SliceInfo sliceInfo = setupDataCallResult.sliceInfo;
        if (sliceInfo != null) {
            networkSliceInfo = convertHalSliceInfo(sliceInfo);
        }
        return qosBearerSessions.setSliceInfo(networkSliceInfo).setTrafficDescriptors(arrayList6).build();
    }

    /* access modifiers changed from: private */
    public static NetworkSliceInfo convertHalSliceInfo(SliceInfo sliceInfo) {
        NetworkSliceInfo.Builder mappedHplmnSliceServiceType = new NetworkSliceInfo.Builder().setSliceServiceType(sliceInfo.sst).setMappedHplmnSliceServiceType(sliceInfo.mappedHplmnSst);
        int i = sliceInfo.sliceDifferentiator;
        if (i != -1) {
            mappedHplmnSliceServiceType.setSliceDifferentiator(i).setMappedHplmnSliceDifferentiator(sliceInfo.mappedHplmnSD);
        }
        return mappedHplmnSliceServiceType.build();
    }

    private static NetworkSliceInfo convertHalSliceInfo(android.hardware.radio.data.SliceInfo sliceInfo) {
        NetworkSliceInfo.Builder mappedHplmnSliceServiceType = new NetworkSliceInfo.Builder().setSliceServiceType(sliceInfo.sliceServiceType).setMappedHplmnSliceServiceType(sliceInfo.mappedHplmnSst);
        int i = sliceInfo.sliceDifferentiator;
        if (i != -1) {
            mappedHplmnSliceServiceType.setSliceDifferentiator(i).setMappedHplmnSliceDifferentiator(sliceInfo.mappedHplmnSd);
        }
        return mappedHplmnSliceServiceType.build();
    }

    private static TrafficDescriptor convertHalTrafficDescriptor(android.hardware.radio.V1_6.TrafficDescriptor trafficDescriptor) throws IllegalArgumentException {
        String str;
        byte[] bArr = null;
        if (trafficDescriptor.dnn.getDiscriminator() == 0) {
            str = null;
        } else {
            str = trafficDescriptor.dnn.value();
        }
        if (trafficDescriptor.osAppId.getDiscriminator() != 0) {
            bArr = arrayListToPrimitiveArray(trafficDescriptor.osAppId.value().osAppId);
        }
        TrafficDescriptor.Builder builder = new TrafficDescriptor.Builder();
        if (str != null) {
            builder.setDataNetworkName(str);
        }
        if (bArr != null) {
            builder.setOsAppId(bArr);
        }
        return builder.build();
    }

    private static TrafficDescriptor convertHalTrafficDescriptor(android.hardware.radio.data.TrafficDescriptor trafficDescriptor) throws IllegalArgumentException {
        String str = trafficDescriptor.dnn;
        android.hardware.radio.data.OsAppId osAppId = trafficDescriptor.osAppId;
        byte[] bArr = osAppId == null ? null : osAppId.osAppId;
        TrafficDescriptor.Builder builder = new TrafficDescriptor.Builder();
        if (str != null) {
            builder.setDataNetworkName(str);
        }
        if (bArr != null) {
            builder.setOsAppId(bArr);
        }
        return builder.build();
    }

    public static NetworkSlicingConfig convertHalSlicingConfig(SlicingConfig slicingConfig) {
        return new NetworkSlicingConfig((List) slicingConfig.urspRules.stream().map(new RILUtils$$ExternalSyntheticLambda1()).collect(Collectors.toList()), (List) slicingConfig.sliceInfo.stream().map(new RILUtils$$ExternalSyntheticLambda0()).collect(Collectors.toList()));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ UrspRule lambda$convertHalSlicingConfig$4(android.hardware.radio.V1_6.UrspRule urspRule) {
        return new UrspRule(urspRule.precedence, (List) urspRule.trafficDescriptors.stream().map(new RILUtils$$ExternalSyntheticLambda6()).filter(new RILUtils$$ExternalSyntheticLambda7()).collect(Collectors.toList()), (List) urspRule.routeSelectionDescriptor.stream().map(new RILUtils$$ExternalSyntheticLambda8()).collect(Collectors.toList()));
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ TrafficDescriptor lambda$convertHalSlicingConfig$2(android.hardware.radio.V1_6.TrafficDescriptor trafficDescriptor) {
        try {
            return convertHalTrafficDescriptor(trafficDescriptor);
        } catch (IllegalArgumentException e) {
            loge("convertHalSlicingConfig: Failed to convert traffic descriptor. e=" + e);
            return null;
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ RouteSelectionDescriptor lambda$convertHalSlicingConfig$3(android.hardware.radio.V1_6.RouteSelectionDescriptor routeSelectionDescriptor) {
        return new RouteSelectionDescriptor(routeSelectionDescriptor.precedence, routeSelectionDescriptor.sessionType.value(), routeSelectionDescriptor.sscMode.value(), (List) routeSelectionDescriptor.sliceInfo.stream().map(new RILUtils$$ExternalSyntheticLambda0()).collect(Collectors.toList()), routeSelectionDescriptor.dnn);
    }

    public static NetworkSlicingConfig convertHalSlicingConfig(android.hardware.radio.data.SlicingConfig slicingConfig) {
        android.hardware.radio.data.SlicingConfig slicingConfig2 = slicingConfig;
        ArrayList arrayList = new ArrayList();
        android.hardware.radio.data.UrspRule[] urspRuleArr = slicingConfig2.urspRules;
        int length = urspRuleArr.length;
        int i = 0;
        while (i < length) {
            android.hardware.radio.data.UrspRule urspRule = urspRuleArr[i];
            ArrayList arrayList2 = new ArrayList();
            for (android.hardware.radio.data.TrafficDescriptor convertHalTrafficDescriptor : urspRule.trafficDescriptors) {
                try {
                    arrayList2.add(convertHalTrafficDescriptor(convertHalTrafficDescriptor));
                } catch (IllegalArgumentException e) {
                    loge("convertHalTrafficDescriptor: " + e);
                }
            }
            ArrayList arrayList3 = new ArrayList();
            android.hardware.radio.data.RouteSelectionDescriptor[] routeSelectionDescriptorArr = urspRule.routeSelectionDescriptor;
            int length2 = routeSelectionDescriptorArr.length;
            int i2 = 0;
            while (i2 < length2) {
                android.hardware.radio.data.RouteSelectionDescriptor routeSelectionDescriptor = routeSelectionDescriptorArr[i2];
                ArrayList arrayList4 = new ArrayList();
                android.hardware.radio.data.SliceInfo[] sliceInfoArr = routeSelectionDescriptor.sliceInfo;
                int length3 = sliceInfoArr.length;
                int i3 = 0;
                while (i3 < length3) {
                    arrayList4.add(convertHalSliceInfo(sliceInfoArr[i3]));
                    i3++;
                    urspRuleArr = urspRuleArr;
                }
                arrayList3.add(new RouteSelectionDescriptor(routeSelectionDescriptor.precedence, routeSelectionDescriptor.sessionType, routeSelectionDescriptor.sscMode, arrayList4, primitiveArrayToArrayList(routeSelectionDescriptor.dnn)));
                i2++;
                urspRuleArr = urspRuleArr;
            }
            arrayList.add(new UrspRule(urspRule.precedence, arrayList2, arrayList3));
            i++;
            urspRuleArr = urspRuleArr;
        }
        ArrayList arrayList5 = new ArrayList();
        for (android.hardware.radio.data.SliceInfo convertHalSliceInfo : slicingConfig2.sliceInfo) {
            arrayList5.add(convertHalSliceInfo(convertHalSliceInfo));
        }
        return new NetworkSlicingConfig(arrayList, arrayList5);
    }

    private static Qos.QosBandwidth convertHalQosBandwidth(QosBandwidth qosBandwidth) {
        return new Qos.QosBandwidth(qosBandwidth.maxBitrateKbps, qosBandwidth.guaranteedBitrateKbps);
    }

    private static Qos.QosBandwidth convertHalQosBandwidth(android.hardware.radio.data.QosBandwidth qosBandwidth) {
        return new Qos.QosBandwidth(qosBandwidth.maxBitrateKbps, qosBandwidth.guaranteedBitrateKbps);
    }

    private static Qos convertHalQos(android.hardware.radio.V1_6.Qos qos) {
        byte discriminator = qos.getDiscriminator();
        if (discriminator == 1) {
            EpsQos eps = qos.eps();
            return new android.telephony.data.EpsQos(convertHalQosBandwidth(eps.downlink), convertHalQosBandwidth(eps.uplink), eps.qci);
        } else if (discriminator != 2) {
            return null;
        } else {
            NrQos nr = qos.nr();
            return new android.telephony.data.NrQos(convertHalQosBandwidth(nr.downlink), convertHalQosBandwidth(nr.uplink), nr.qfi, nr.fiveQi, nr.averagingWindowMs);
        }
    }

    private static Qos convertHalQos(android.hardware.radio.data.Qos qos) {
        int tag = qos.getTag();
        if (tag == 1) {
            android.hardware.radio.data.EpsQos eps = qos.getEps();
            return new android.telephony.data.EpsQos(convertHalQosBandwidth(eps.downlink), convertHalQosBandwidth(eps.uplink), eps.qci);
        } else if (tag != 2) {
            return null;
        } else {
            android.hardware.radio.data.NrQos nr = qos.getNr();
            return new android.telephony.data.NrQos(convertHalQosBandwidth(nr.downlink), convertHalQosBandwidth(nr.uplink), nr.qfi, nr.fiveQi, nr.averagingWindowMs);
        }
    }

    private static QosBearerFilter convertHalQosBearerFilter(QosFilter qosFilter) {
        QosBearerFilter.PortRange portRange;
        QosFilter qosFilter2 = qosFilter;
        ArrayList arrayList = new ArrayList();
        String[] strArr = (String[]) qosFilter2.localAddresses.toArray(new String[0]);
        if (strArr != null) {
            for (String convertToLinkAddress : strArr) {
                arrayList.add(convertToLinkAddress(convertToLinkAddress));
            }
        }
        ArrayList arrayList2 = new ArrayList();
        String[] strArr2 = (String[]) qosFilter2.remoteAddresses.toArray(new String[0]);
        if (strArr2 != null) {
            for (String convertToLinkAddress2 : strArr2) {
                arrayList2.add(convertToLinkAddress(convertToLinkAddress2));
            }
        }
        MaybePort maybePort = qosFilter2.localPort;
        QosBearerFilter.PortRange portRange2 = null;
        if (maybePort == null || maybePort.getDiscriminator() != 1) {
            portRange = null;
        } else {
            PortRange range = qosFilter2.localPort.range();
            portRange = new QosBearerFilter.PortRange(range.start, range.end);
        }
        MaybePort maybePort2 = qosFilter2.remotePort;
        if (maybePort2 != null && maybePort2.getDiscriminator() == 1) {
            PortRange range2 = qosFilter2.remotePort.range();
            portRange2 = new QosBearerFilter.PortRange(range2.start, range2.end);
        }
        byte b = -1;
        QosFilter.TypeOfService typeOfService = qosFilter2.tos;
        if (typeOfService != null && typeOfService.getDiscriminator() == 1) {
            b = qosFilter2.tos.value();
        }
        QosFilter.Ipv6FlowLabel ipv6FlowLabel = qosFilter2.flowLabel;
        long value = (ipv6FlowLabel == null || ipv6FlowLabel.getDiscriminator() != 1) ? -1 : (long) qosFilter2.flowLabel.value();
        QosFilter.IpsecSpi ipsecSpi = qosFilter2.spi;
        return new QosBearerFilter(arrayList, arrayList2, portRange, portRange2, qosFilter2.protocol, b, value, (ipsecSpi == null || ipsecSpi.getDiscriminator() != 1) ? -1 : (long) qosFilter2.spi.value(), qosFilter2.direction, qosFilter2.precedence);
    }

    private static QosBearerFilter convertHalQosBearerFilter(android.hardware.radio.data.QosFilter qosFilter) {
        QosBearerFilter.PortRange portRange;
        QosBearerFilter.PortRange portRange2;
        ArrayList arrayList = new ArrayList();
        String[] strArr = qosFilter.localAddresses;
        if (strArr != null) {
            for (String convertToLinkAddress : strArr) {
                arrayList.add(convertToLinkAddress(convertToLinkAddress));
            }
        }
        ArrayList arrayList2 = new ArrayList();
        String[] strArr2 = qosFilter.remoteAddresses;
        if (strArr2 != null) {
            for (String convertToLinkAddress2 : strArr2) {
                arrayList2.add(convertToLinkAddress(convertToLinkAddress2));
            }
        }
        if (qosFilter.localPort != null) {
            android.hardware.radio.data.PortRange portRange3 = qosFilter.localPort;
            portRange = new QosBearerFilter.PortRange(portRange3.start, portRange3.end);
        } else {
            portRange = null;
        }
        if (qosFilter.remotePort != null) {
            android.hardware.radio.data.PortRange portRange4 = qosFilter.remotePort;
            portRange2 = new QosBearerFilter.PortRange(portRange4.start, portRange4.end);
        } else {
            portRange2 = null;
        }
        QosFilterTypeOfService qosFilterTypeOfService = qosFilter.tos;
        int i = (qosFilterTypeOfService == null || qosFilterTypeOfService.getTag() != 1) ? -1 : 1;
        QosFilterIpv6FlowLabel qosFilterIpv6FlowLabel = qosFilter.flowLabel;
        long j = (qosFilterIpv6FlowLabel == null || qosFilterIpv6FlowLabel.getTag() != 1) ? -1 : 1;
        QosFilterIpsecSpi qosFilterIpsecSpi = qosFilter.spi;
        return new QosBearerFilter(arrayList, arrayList2, portRange, portRange2, qosFilter.protocol, i, j, (qosFilterIpsecSpi == null || qosFilterIpsecSpi.getTag() != 1) ? -1 : 1, qosFilter.direction, qosFilter.precedence);
    }

    /* access modifiers changed from: private */
    public static QosBearerSession convertHalQosBearerSession(android.hardware.radio.V1_6.QosSession qosSession) {
        ArrayList arrayList = new ArrayList();
        ArrayList arrayList2 = qosSession.qosFilters;
        if (arrayList2 != null) {
            Iterator it = arrayList2.iterator();
            while (it.hasNext()) {
                arrayList.add(convertHalQosBearerFilter((QosFilter) it.next()));
            }
        }
        return new QosBearerSession(qosSession.qosSessionId, convertHalQos(qosSession.qos), arrayList);
    }

    private static QosBearerSession convertHalQosBearerSession(QosSession qosSession) {
        ArrayList arrayList = new ArrayList();
        android.hardware.radio.data.QosFilter[] qosFilterArr = qosSession.qosFilters;
        if (qosFilterArr != null) {
            for (android.hardware.radio.data.QosFilter convertHalQosBearerFilter : qosFilterArr) {
                arrayList.add(convertHalQosBearerFilter(convertHalQosBearerFilter));
            }
        }
        return new QosBearerSession(qosSession.qosSessionId, convertHalQos(qosSession.qos), arrayList);
    }

    @VisibleForTesting
    public static ArrayList<DataCallResponse> convertHalDataCallResultList(List<? extends Object> list) {
        ArrayList<DataCallResponse> arrayList = new ArrayList<>(list.size());
        for (Object convertHalDataCallResult : list) {
            arrayList.add(convertHalDataCallResult((Object) convertHalDataCallResult));
        }
        return arrayList;
    }

    @VisibleForTesting
    public static ArrayList<DataCallResponse> convertHalDataCallResultList(SetupDataCallResult[] setupDataCallResultArr) {
        ArrayList<DataCallResponse> arrayList = new ArrayList<>(setupDataCallResultArr.length);
        for (SetupDataCallResult convertHalDataCallResult : setupDataCallResultArr) {
            arrayList.add(convertHalDataCallResult(convertHalDataCallResult));
        }
        return arrayList;
    }

    public static int convertHalRadioState(int i) {
        if (i == 0) {
            return 0;
        }
        if (i == 1) {
            return 2;
        }
        if (i == 10) {
            return 1;
        }
        throw new RuntimeException("Unrecognized RadioState: " + i);
    }

    /* JADX WARNING: Removed duplicated region for block: B:12:0x002d  */
    /* JADX WARNING: Removed duplicated region for block: B:19:0x00c5  */
    /* JADX WARNING: Removed duplicated region for block: B:21:0x00cb  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static com.android.internal.telephony.DriverCall convertToDriverCall(java.lang.Object r7) {
        /*
            com.android.internal.telephony.DriverCall r0 = new com.android.internal.telephony.DriverCall
            r0.<init>()
            boolean r1 = r7 instanceof android.hardware.radio.V1_6.Call
            r2 = 0
            if (r1 == 0) goto L_0x0016
            r2 = r7
            android.hardware.radio.V1_6.Call r2 = (android.hardware.radio.V1_6.Call) r2
            android.hardware.radio.V1_2.Call r7 = r2.base
            android.hardware.radio.V1_0.Call r1 = r7.base
        L_0x0011:
            r6 = r1
            r1 = r7
            r7 = r2
            r2 = r6
            goto L_0x002b
        L_0x0016:
            boolean r1 = r7 instanceof android.hardware.radio.V1_2.Call
            if (r1 == 0) goto L_0x001f
            android.hardware.radio.V1_2.Call r7 = (android.hardware.radio.V1_2.Call) r7
            android.hardware.radio.V1_0.Call r1 = r7.base
            goto L_0x0011
        L_0x001f:
            boolean r1 = r7 instanceof android.hardware.radio.V1_0.Call
            if (r1 == 0) goto L_0x0029
            android.hardware.radio.V1_0.Call r7 = (android.hardware.radio.V1_0.Call) r7
            r1 = r2
            r2 = r7
            r7 = r1
            goto L_0x002b
        L_0x0029:
            r7 = r2
            r1 = r7
        L_0x002b:
            if (r2 == 0) goto L_0x00c3
            int r3 = r2.state
            com.android.internal.telephony.DriverCall$State r3 = com.android.internal.telephony.DriverCall.stateFromCLCC(r3)
            r0.state = r3
            int r3 = r2.index
            r0.index = r3
            int r3 = r2.toa
            r0.TOA = r3
            boolean r3 = r2.isMpty
            r0.isMpty = r3
            boolean r3 = r2.isMT
            r0.isMT = r3
            byte r3 = r2.als
            r0.als = r3
            boolean r3 = r2.isVoice
            r0.isVoice = r3
            boolean r3 = r2.isVoicePrivacy
            r0.isVoicePrivacy = r3
            java.lang.String r3 = r2.number
            r0.number = r3
            int r3 = r2.numberPresentation
            int r3 = com.android.internal.telephony.DriverCall.presentationFromCLIP(r3)
            r0.numberPresentation = r3
            java.lang.String r3 = r2.name
            r0.name = r3
            int r3 = r2.namePresentation
            int r3 = com.android.internal.telephony.DriverCall.presentationFromCLIP(r3)
            r0.namePresentation = r3
            java.util.ArrayList r3 = r2.uusInfo
            int r3 = r3.size()
            r4 = 1
            if (r3 != r4) goto L_0x00b9
            com.android.internal.telephony.UUSInfo r3 = new com.android.internal.telephony.UUSInfo
            r3.<init>()
            r0.uusInfo = r3
            java.util.ArrayList r4 = r2.uusInfo
            r5 = 0
            java.lang.Object r4 = r4.get(r5)
            android.hardware.radio.V1_0.UusInfo r4 = (android.hardware.radio.V1_0.UusInfo) r4
            int r4 = r4.uusType
            r3.setType(r4)
            com.android.internal.telephony.UUSInfo r3 = r0.uusInfo
            java.util.ArrayList r4 = r2.uusInfo
            java.lang.Object r4 = r4.get(r5)
            android.hardware.radio.V1_0.UusInfo r4 = (android.hardware.radio.V1_0.UusInfo) r4
            int r4 = r4.uusDcs
            r3.setDcs(r4)
            java.util.ArrayList r3 = r2.uusInfo
            java.lang.Object r3 = r3.get(r5)
            android.hardware.radio.V1_0.UusInfo r3 = (android.hardware.radio.V1_0.UusInfo) r3
            java.lang.String r3 = r3.uusData
            boolean r3 = android.text.TextUtils.isEmpty(r3)
            if (r3 != 0) goto L_0x00b9
            java.util.ArrayList r2 = r2.uusInfo
            java.lang.Object r2 = r2.get(r5)
            android.hardware.radio.V1_0.UusInfo r2 = (android.hardware.radio.V1_0.UusInfo) r2
            java.lang.String r2 = r2.uusData
            byte[] r2 = r2.getBytes()
            com.android.internal.telephony.UUSInfo r3 = r0.uusInfo
            r3.setUserData(r2)
        L_0x00b9:
            java.lang.String r2 = r0.number
            int r3 = r0.TOA
            java.lang.String r2 = android.telephony.PhoneNumberUtils.stringFromStringAndTOA(r2, r3)
            r0.number = r2
        L_0x00c3:
            if (r1 == 0) goto L_0x00c9
            int r1 = r1.audioQuality
            r0.audioQuality = r1
        L_0x00c9:
            if (r7 == 0) goto L_0x00cf
            java.lang.String r7 = r7.forwardedNumber
            r0.forwardedNumber = r7
        L_0x00cf:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertToDriverCall(java.lang.Object):com.android.internal.telephony.DriverCall");
    }

    public static DriverCall convertToDriverCall(Call call) {
        DriverCall driverCall = new DriverCall();
        driverCall.state = DriverCall.stateFromCLCC(call.state);
        driverCall.index = call.index;
        driverCall.TOA = call.toa;
        driverCall.isMpty = call.isMpty;
        driverCall.isMT = call.isMT;
        driverCall.als = call.als;
        driverCall.isVoice = call.isVoice;
        driverCall.isVoicePrivacy = call.isVoicePrivacy;
        driverCall.number = call.number;
        driverCall.numberPresentation = DriverCall.presentationFromCLIP(call.numberPresentation);
        driverCall.name = call.name;
        driverCall.namePresentation = DriverCall.presentationFromCLIP(call.namePresentation);
        if (call.uusInfo.length == 1) {
            UUSInfo uUSInfo = new UUSInfo();
            driverCall.uusInfo = uUSInfo;
            uUSInfo.setType(call.uusInfo[0].uusType);
            driverCall.uusInfo.setDcs(call.uusInfo[0].uusDcs);
            if (!TextUtils.isEmpty(call.uusInfo[0].uusData)) {
                driverCall.uusInfo.setUserData(call.uusInfo[0].uusData.getBytes());
            }
        }
        driverCall.number = PhoneNumberUtils.stringFromStringAndTOA(driverCall.number, driverCall.TOA);
        driverCall.audioQuality = call.audioQuality;
        driverCall.forwardedNumber = call.forwardedNumber;
        return driverCall;
    }

    public static List<CarrierIdentifier> convertHalCarrierList(List<Carrier> list) {
        String str;
        String str2;
        String str3;
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            String str4 = list.get(i).mcc;
            String str5 = list.get(i).mnc;
            int i2 = list.get(i).matchType;
            String str6 = list.get(i).matchData;
            String str7 = null;
            if (i2 == 1) {
                str3 = str6;
                str2 = null;
            } else {
                if (i2 == 2) {
                    str3 = null;
                    str2 = null;
                    str = null;
                    str7 = str6;
                } else if (i2 == 3) {
                    str2 = str6;
                    str3 = null;
                    str = null;
                } else if (i2 == 4) {
                    str = str6;
                    str3 = null;
                    str2 = null;
                } else {
                    str3 = null;
                    str2 = null;
                }
                arrayList.add(new CarrierIdentifier(str4, str5, str3, str7, str2, str));
            }
            str = str2;
            arrayList.add(new CarrierIdentifier(str4, str5, str3, str7, str2, str));
        }
        return arrayList;
    }

    public static List<CarrierIdentifier> convertHalCarrierList(android.hardware.radio.sim.Carrier[] carrierArr) {
        String str;
        String str2;
        String str3;
        ArrayList arrayList = new ArrayList();
        for (android.hardware.radio.sim.Carrier carrier : carrierArr) {
            String str4 = carrier.mcc;
            String str5 = carrier.mnc;
            int i = carrier.matchType;
            String str6 = carrier.matchData;
            String str7 = null;
            if (i == 1) {
                str3 = str6;
                str2 = null;
            } else {
                if (i == 2) {
                    str3 = null;
                    str2 = null;
                    str = null;
                    str7 = str6;
                } else if (i == 3) {
                    str2 = str6;
                    str3 = null;
                    str = null;
                } else if (i == 4) {
                    str = str6;
                    str3 = null;
                    str2 = null;
                } else {
                    str3 = null;
                    str2 = null;
                }
                arrayList.add(new CarrierIdentifier(str4, str5, str3, str7, str2, str));
            }
            str = str2;
            arrayList.add(new CarrierIdentifier(str4, str5, str3, str7, str2, str));
        }
        return arrayList;
    }

    /* JADX WARNING: Removed duplicated region for block: B:10:0x0025  */
    /* JADX WARNING: Removed duplicated region for block: B:21:0x009a  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static com.android.internal.telephony.uicc.IccCardStatus convertHalCardStatus(java.lang.Object r11) {
        /*
            boolean r0 = r11 instanceof android.hardware.radio.V1_5.CardStatus
            r1 = 0
            if (r0 == 0) goto L_0x0012
            r1 = r11
            android.hardware.radio.V1_5.CardStatus r1 = (android.hardware.radio.V1_5.CardStatus) r1
            android.hardware.radio.V1_4.CardStatus r11 = r1.base
            android.hardware.radio.V1_2.CardStatus r11 = r11.base
            android.hardware.radio.V1_0.CardStatus r11 = r11.base
        L_0x000e:
            r10 = r1
            r1 = r11
            r11 = r10
            goto L_0x001a
        L_0x0012:
            boolean r0 = r11 instanceof android.hardware.radio.V1_0.CardStatus
            if (r0 == 0) goto L_0x0019
            android.hardware.radio.V1_0.CardStatus r11 = (android.hardware.radio.V1_0.CardStatus) r11
            goto L_0x000e
        L_0x0019:
            r11 = r1
        L_0x001a:
            com.android.internal.telephony.uicc.IccCardStatus r0 = new com.android.internal.telephony.uicc.IccCardStatus
            r0.<init>()
            r2 = 1
            r3 = 0
            r4 = 8
            if (r1 == 0) goto L_0x0098
            int r5 = r1.cardState
            r0.setCardState(r5)
            int r5 = r1.universalPinState
            r0.setUniversalPinState(r5)
            int r5 = r1.gsmUmtsSubscriptionAppIndex
            r0.mGsmUmtsSubscriptionAppIndex = r5
            int r5 = r1.cdmaSubscriptionAppIndex
            r0.mCdmaSubscriptionAppIndex = r5
            int r5 = r1.imsSubscriptionAppIndex
            r0.mImsSubscriptionAppIndex = r5
            java.util.ArrayList r5 = r1.applications
            int r5 = r5.size()
            if (r5 <= r4) goto L_0x0044
            r5 = r4
        L_0x0044:
            com.android.internal.telephony.uicc.IccCardApplicationStatus[] r6 = new com.android.internal.telephony.uicc.IccCardApplicationStatus[r5]
            r0.mApplications = r6
            r6 = r3
        L_0x0049:
            if (r6 >= r5) goto L_0x0098
            java.util.ArrayList r7 = r1.applications
            java.lang.Object r7 = r7.get(r6)
            android.hardware.radio.V1_0.AppStatus r7 = (android.hardware.radio.V1_0.AppStatus) r7
            com.android.internal.telephony.uicc.IccCardApplicationStatus r8 = new com.android.internal.telephony.uicc.IccCardApplicationStatus
            r8.<init>()
            int r9 = r7.appType
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r9 = r8.AppTypeFromRILInt(r9)
            r8.app_type = r9
            int r9 = r7.appState
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r9 = r8.AppStateFromRILInt(r9)
            r8.app_state = r9
            int r9 = r7.persoSubstate
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r9 = r8.PersoSubstateFromRILInt(r9)
            r8.perso_substate = r9
            java.lang.String r9 = r7.aidPtr
            r8.aid = r9
            java.lang.String r9 = r7.appLabelPtr
            r8.app_label = r9
            int r9 = r7.pin1Replaced
            if (r9 == 0) goto L_0x007e
            r9 = r2
            goto L_0x007f
        L_0x007e:
            r9 = r3
        L_0x007f:
            r8.pin1_replaced = r9
            int r9 = r7.pin1
            com.android.internal.telephony.uicc.IccCardStatus$PinState r9 = r8.PinStateFromRILInt(r9)
            r8.pin1 = r9
            int r7 = r7.pin2
            com.android.internal.telephony.uicc.IccCardStatus$PinState r7 = r8.PinStateFromRILInt(r7)
            r8.pin2 = r7
            com.android.internal.telephony.uicc.IccCardApplicationStatus[] r7 = r0.mApplications
            r7[r6] = r8
            int r6 = r6 + 1
            goto L_0x0049
        L_0x0098:
            if (r11 == 0) goto L_0x011b
            com.android.internal.telephony.uicc.IccSlotPortMapping r1 = new com.android.internal.telephony.uicc.IccSlotPortMapping
            r1.<init>()
            android.hardware.radio.V1_4.CardStatus r5 = r11.base
            android.hardware.radio.V1_2.CardStatus r6 = r5.base
            int r7 = r6.physicalSlotId
            r1.mPhysicalSlotIndex = r7
            r0.mSlotPortMapping = r1
            java.lang.String r1 = r6.atr
            r0.atr = r1
            java.lang.String r1 = r6.iccid
            r0.iccid = r1
            java.lang.String r1 = r5.eid
            r0.eid = r1
            java.util.ArrayList r1 = r11.applications
            int r1 = r1.size()
            if (r1 <= r4) goto L_0x00be
            goto L_0x00bf
        L_0x00be:
            r4 = r1
        L_0x00bf:
            com.android.internal.telephony.uicc.IccCardApplicationStatus[] r1 = new com.android.internal.telephony.uicc.IccCardApplicationStatus[r4]
            r0.mApplications = r1
            r1 = r3
        L_0x00c4:
            if (r1 >= r4) goto L_0x011b
            java.util.ArrayList r5 = r11.applications
            java.lang.Object r5 = r5.get(r1)
            android.hardware.radio.V1_5.AppStatus r5 = (android.hardware.radio.V1_5.AppStatus) r5
            com.android.internal.telephony.uicc.IccCardApplicationStatus r6 = new com.android.internal.telephony.uicc.IccCardApplicationStatus
            r6.<init>()
            android.hardware.radio.V1_0.AppStatus r7 = r5.base
            int r7 = r7.appType
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r7 = r6.AppTypeFromRILInt(r7)
            r6.app_type = r7
            android.hardware.radio.V1_0.AppStatus r7 = r5.base
            int r7 = r7.appState
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r7 = r6.AppStateFromRILInt(r7)
            r6.app_state = r7
            int r7 = r5.persoSubstate
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r7 = r6.PersoSubstateFromRILInt(r7)
            r6.perso_substate = r7
            android.hardware.radio.V1_0.AppStatus r7 = r5.base
            java.lang.String r8 = r7.aidPtr
            r6.aid = r8
            java.lang.String r8 = r7.appLabelPtr
            r6.app_label = r8
            int r8 = r7.pin1Replaced
            if (r8 == 0) goto L_0x00ff
            r8 = r2
            goto L_0x0100
        L_0x00ff:
            r8 = r3
        L_0x0100:
            r6.pin1_replaced = r8
            int r7 = r7.pin1
            com.android.internal.telephony.uicc.IccCardStatus$PinState r7 = r6.PinStateFromRILInt(r7)
            r6.pin1 = r7
            android.hardware.radio.V1_0.AppStatus r5 = r5.base
            int r5 = r5.pin2
            com.android.internal.telephony.uicc.IccCardStatus$PinState r5 = r6.PinStateFromRILInt(r5)
            r6.pin2 = r5
            com.android.internal.telephony.uicc.IccCardApplicationStatus[] r5 = r0.mApplications
            r5[r1] = r6
            int r1 = r1 + 1
            goto L_0x00c4
        L_0x011b:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertHalCardStatus(java.lang.Object):com.android.internal.telephony.uicc.IccCardStatus");
    }

    public static IccCardStatus convertHalCardStatus(CardStatus cardStatus) {
        IccCardStatus iccCardStatus = new IccCardStatus();
        iccCardStatus.setCardState(cardStatus.cardState);
        iccCardStatus.setUniversalPinState(cardStatus.universalPinState);
        iccCardStatus.mGsmUmtsSubscriptionAppIndex = cardStatus.gsmUmtsSubscriptionAppIndex;
        iccCardStatus.mCdmaSubscriptionAppIndex = cardStatus.cdmaSubscriptionAppIndex;
        iccCardStatus.mImsSubscriptionAppIndex = cardStatus.imsSubscriptionAppIndex;
        iccCardStatus.atr = cardStatus.atr;
        iccCardStatus.iccid = cardStatus.iccid;
        iccCardStatus.eid = cardStatus.eid;
        int min = Math.min(cardStatus.applications.length, 8);
        iccCardStatus.mApplications = new IccCardApplicationStatus[min];
        for (int i = 0; i < min; i++) {
            AppStatus appStatus = cardStatus.applications[i];
            IccCardApplicationStatus iccCardApplicationStatus = new IccCardApplicationStatus();
            iccCardApplicationStatus.app_type = iccCardApplicationStatus.AppTypeFromRILInt(appStatus.appType);
            iccCardApplicationStatus.app_state = iccCardApplicationStatus.AppStateFromRILInt(appStatus.appState);
            iccCardApplicationStatus.perso_substate = iccCardApplicationStatus.PersoSubstateFromRILInt(appStatus.persoSubstate);
            iccCardApplicationStatus.aid = appStatus.aidPtr;
            iccCardApplicationStatus.app_label = appStatus.appLabelPtr;
            iccCardApplicationStatus.pin1_replaced = appStatus.pin1Replaced;
            iccCardApplicationStatus.pin1 = iccCardApplicationStatus.PinStateFromRILInt(appStatus.pin1);
            iccCardApplicationStatus.pin2 = iccCardApplicationStatus.PinStateFromRILInt(appStatus.pin2);
            iccCardStatus.mApplications[i] = iccCardApplicationStatus;
        }
        IccSlotPortMapping iccSlotPortMapping = new IccSlotPortMapping();
        SlotPortMapping slotPortMapping = cardStatus.slotMap;
        iccSlotPortMapping.mPhysicalSlotIndex = slotPortMapping.physicalSlotId;
        iccSlotPortMapping.mPortIndex = slotPortMapping.portId;
        iccCardStatus.mSlotPortMapping = iccSlotPortMapping;
        return iccCardStatus;
    }

    public static AdnCapacity convertHalPhonebookCapacity(PhonebookCapacity phonebookCapacity) {
        if (phonebookCapacity != null) {
            return new AdnCapacity(phonebookCapacity.maxAdnRecords, phonebookCapacity.usedAdnRecords, phonebookCapacity.maxEmailRecords, phonebookCapacity.usedEmailRecords, phonebookCapacity.maxAdditionalNumberRecords, phonebookCapacity.usedAdditionalNumberRecords, phonebookCapacity.maxNameLen, phonebookCapacity.maxNumberLen, phonebookCapacity.maxEmailLen, phonebookCapacity.maxAdditionalNumberLen);
        }
        return null;
    }

    public static AdnCapacity convertHalPhonebookCapacity(android.hardware.radio.sim.PhonebookCapacity phonebookCapacity) {
        if (phonebookCapacity != null) {
            return new AdnCapacity(phonebookCapacity.maxAdnRecords, phonebookCapacity.usedAdnRecords, phonebookCapacity.maxEmailRecords, phonebookCapacity.usedEmailRecords, phonebookCapacity.maxAdditionalNumberRecords, phonebookCapacity.usedAdditionalNumberRecords, phonebookCapacity.maxNameLen, phonebookCapacity.maxNumberLen, phonebookCapacity.maxEmailLen, phonebookCapacity.maxAdditionalNumberLen);
        }
        return null;
    }

    /* JADX WARNING: type inference failed for: r0v3, types: [java.lang.Object[]] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static com.android.internal.telephony.uicc.SimPhonebookRecord convertHalPhonebookRecordInfo(android.hardware.radio.V1_6.PhonebookRecordInfo r8) {
        /*
            java.util.ArrayList r0 = r8.emails
            r1 = 0
            if (r0 != 0) goto L_0x0007
            r6 = r1
            goto L_0x0014
        L_0x0007:
            int r2 = r0.size()
            java.lang.String[] r2 = new java.lang.String[r2]
            java.lang.Object[] r0 = r0.toArray(r2)
            java.lang.String[] r0 = (java.lang.String[]) r0
            r6 = r0
        L_0x0014:
            java.util.ArrayList r0 = r8.additionalNumbers
            if (r0 != 0) goto L_0x0019
            goto L_0x0026
        L_0x0019:
            int r1 = r0.size()
            java.lang.String[] r1 = new java.lang.String[r1]
            java.lang.Object[] r0 = r0.toArray(r1)
            r1 = r0
            java.lang.String[] r1 = (java.lang.String[]) r1
        L_0x0026:
            r7 = r1
            com.android.internal.telephony.uicc.SimPhonebookRecord r0 = new com.android.internal.telephony.uicc.SimPhonebookRecord
            int r3 = r8.recordId
            java.lang.String r4 = r8.name
            java.lang.String r5 = r8.number
            r2 = r0
            r2.<init>(r3, r4, r5, r6, r7)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertHalPhonebookRecordInfo(android.hardware.radio.V1_6.PhonebookRecordInfo):com.android.internal.telephony.uicc.SimPhonebookRecord");
    }

    public static SimPhonebookRecord convertHalPhonebookRecordInfo(PhonebookRecordInfo phonebookRecordInfo) {
        return new SimPhonebookRecord(phonebookRecordInfo.recordId, phonebookRecordInfo.name, phonebookRecordInfo.number, phonebookRecordInfo.emails, phonebookRecordInfo.additionalNumbers);
    }

    public static android.hardware.radio.V1_6.PhonebookRecordInfo convertToHalPhonebookRecordInfo(SimPhonebookRecord simPhonebookRecord) {
        if (simPhonebookRecord != null) {
            return simPhonebookRecord.toPhonebookRecordInfo();
        }
        return null;
    }

    public static PhonebookRecordInfo convertToHalPhonebookRecordInfoAidl(SimPhonebookRecord simPhonebookRecord) {
        if (simPhonebookRecord != null) {
            return simPhonebookRecord.toPhonebookRecordInfoAidl();
        }
        return new PhonebookRecordInfo();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:31:?, code lost:
        r13 = ((java.util.ArrayList) r13).iterator();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:33:0x00ae, code lost:
        if (r13.hasNext() != false) goto L_0x00b0;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:34:0x00b0, code lost:
        r4 = (android.hardware.radio.config.V1_0.SimSlotStatus) r13.next();
        r5 = new com.android.internal.telephony.uicc.IccSlotStatus();
        r5.setCardState(r4.cardState);
        r5.mSimPortInfos = new com.android.internal.telephony.uicc.IccSimPortInfo[1];
        r6 = new com.android.internal.telephony.uicc.IccSimPortInfo();
        r6.mIccId = r4.iccid;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:35:0x00cf, code lost:
        if (r4.slotState == 1) goto L_0x00d1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:36:0x00d1, code lost:
        r7 = true;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:37:0x00d3, code lost:
        r7 = false;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:38:0x00d4, code lost:
        r6.mPortActive = r7;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:39:0x00d6, code lost:
        if (r7 != false) goto L_0x00d8;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:40:0x00d8, code lost:
        r7 = r4.logicalSlotId;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:41:0x00db, code lost:
        r7 = -1;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:42:0x00dc, code lost:
        r6.mLogicalSlotIndex = r7;
        r5.mSimPortInfos[0] = r6;
        r5.atr = r4.atr;
        r0.add(r5);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:43:0x00ea, code lost:
        return r0;
     */
    /* JADX WARNING: Failed to process nested try/catch */
    /* JADX WARNING: Missing exception handler attribute for start block: B:30:0x00a4 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static java.util.ArrayList<com.android.internal.telephony.uicc.IccSlotStatus> convertHalSlotStatus(java.lang.Object r13) {
        /*
            java.util.ArrayList r0 = new java.util.ArrayList
            r0.<init>()
            r1 = -1
            r2 = 0
            r3 = r13
            android.hardware.radio.config.SimSlotStatus[] r3 = (android.hardware.radio.config.SimSlotStatus[]) r3     // Catch:{ ClassCastException -> 0x0053 }
            int r4 = r3.length     // Catch:{ ClassCastException -> 0x0053 }
            r5 = r2
        L_0x000c:
            if (r5 >= r4) goto L_0x0052
            r6 = r3[r5]     // Catch:{ ClassCastException -> 0x0053 }
            com.android.internal.telephony.uicc.IccSlotStatus r7 = new com.android.internal.telephony.uicc.IccSlotStatus     // Catch:{ ClassCastException -> 0x0053 }
            r7.<init>()     // Catch:{ ClassCastException -> 0x0053 }
            int r8 = r6.cardState     // Catch:{ ClassCastException -> 0x0053 }
            r7.setCardState(r8)     // Catch:{ ClassCastException -> 0x0053 }
            android.hardware.radio.config.SimPortInfo[] r8 = r6.portInfo     // Catch:{ ClassCastException -> 0x0053 }
            int r8 = r8.length     // Catch:{ ClassCastException -> 0x0053 }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r9 = new com.android.internal.telephony.uicc.IccSimPortInfo[r8]     // Catch:{ ClassCastException -> 0x0053 }
            r7.mSimPortInfos = r9     // Catch:{ ClassCastException -> 0x0053 }
            r9 = r2
        L_0x0022:
            if (r9 >= r8) goto L_0x0044
            com.android.internal.telephony.uicc.IccSimPortInfo r10 = new com.android.internal.telephony.uicc.IccSimPortInfo     // Catch:{ ClassCastException -> 0x0053 }
            r10.<init>()     // Catch:{ ClassCastException -> 0x0053 }
            android.hardware.radio.config.SimPortInfo[] r11 = r6.portInfo     // Catch:{ ClassCastException -> 0x0053 }
            r11 = r11[r9]     // Catch:{ ClassCastException -> 0x0053 }
            java.lang.String r12 = r11.iccId     // Catch:{ ClassCastException -> 0x0053 }
            r10.mIccId = r12     // Catch:{ ClassCastException -> 0x0053 }
            boolean r12 = r11.portActive     // Catch:{ ClassCastException -> 0x0053 }
            if (r12 == 0) goto L_0x0038
            int r11 = r11.logicalSlotId     // Catch:{ ClassCastException -> 0x0053 }
            goto L_0x0039
        L_0x0038:
            r11 = r1
        L_0x0039:
            r10.mLogicalSlotIndex = r11     // Catch:{ ClassCastException -> 0x0053 }
            r10.mPortActive = r12     // Catch:{ ClassCastException -> 0x0053 }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r11 = r7.mSimPortInfos     // Catch:{ ClassCastException -> 0x0053 }
            r11[r9] = r10     // Catch:{ ClassCastException -> 0x0053 }
            int r9 = r9 + 1
            goto L_0x0022
        L_0x0044:
            java.lang.String r8 = r6.atr     // Catch:{ ClassCastException -> 0x0053 }
            r7.atr = r8     // Catch:{ ClassCastException -> 0x0053 }
            java.lang.String r6 = r6.eid     // Catch:{ ClassCastException -> 0x0053 }
            r7.eid = r6     // Catch:{ ClassCastException -> 0x0053 }
            r0.add(r7)     // Catch:{ ClassCastException -> 0x0053 }
            int r5 = r5 + 1
            goto L_0x000c
        L_0x0052:
            return r0
        L_0x0053:
            r3 = 1
            r4 = r13
            java.util.ArrayList r4 = (java.util.ArrayList) r4     // Catch:{ ClassCastException -> 0x00a4 }
            java.util.Iterator r4 = r4.iterator()     // Catch:{ ClassCastException -> 0x00a4 }
        L_0x005b:
            boolean r5 = r4.hasNext()     // Catch:{ ClassCastException -> 0x00a4 }
            if (r5 == 0) goto L_0x00a3
            java.lang.Object r5 = r4.next()     // Catch:{ ClassCastException -> 0x00a4 }
            android.hardware.radio.config.V1_2.SimSlotStatus r5 = (android.hardware.radio.config.V1_2.SimSlotStatus) r5     // Catch:{ ClassCastException -> 0x00a4 }
            com.android.internal.telephony.uicc.IccSlotStatus r6 = new com.android.internal.telephony.uicc.IccSlotStatus     // Catch:{ ClassCastException -> 0x00a4 }
            r6.<init>()     // Catch:{ ClassCastException -> 0x00a4 }
            android.hardware.radio.config.V1_0.SimSlotStatus r7 = r5.base     // Catch:{ ClassCastException -> 0x00a4 }
            int r7 = r7.cardState     // Catch:{ ClassCastException -> 0x00a4 }
            r6.setCardState(r7)     // Catch:{ ClassCastException -> 0x00a4 }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r7 = new com.android.internal.telephony.uicc.IccSimPortInfo[r3]     // Catch:{ ClassCastException -> 0x00a4 }
            r6.mSimPortInfos = r7     // Catch:{ ClassCastException -> 0x00a4 }
            com.android.internal.telephony.uicc.IccSimPortInfo r7 = new com.android.internal.telephony.uicc.IccSimPortInfo     // Catch:{ ClassCastException -> 0x00a4 }
            r7.<init>()     // Catch:{ ClassCastException -> 0x00a4 }
            android.hardware.radio.config.V1_0.SimSlotStatus r8 = r5.base     // Catch:{ ClassCastException -> 0x00a4 }
            java.lang.String r9 = r8.iccid     // Catch:{ ClassCastException -> 0x00a4 }
            r7.mIccId = r9     // Catch:{ ClassCastException -> 0x00a4 }
            int r9 = r8.slotState     // Catch:{ ClassCastException -> 0x00a4 }
            if (r9 != r3) goto L_0x0088
            r9 = r3
            goto L_0x0089
        L_0x0088:
            r9 = r2
        L_0x0089:
            r7.mPortActive = r9     // Catch:{ ClassCastException -> 0x00a4 }
            if (r9 == 0) goto L_0x0090
            int r9 = r8.logicalSlotId     // Catch:{ ClassCastException -> 0x00a4 }
            goto L_0x0091
        L_0x0090:
            r9 = r1
        L_0x0091:
            r7.mLogicalSlotIndex = r9     // Catch:{ ClassCastException -> 0x00a4 }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r9 = r6.mSimPortInfos     // Catch:{ ClassCastException -> 0x00a4 }
            r9[r2] = r7     // Catch:{ ClassCastException -> 0x00a4 }
            java.lang.String r7 = r8.atr     // Catch:{ ClassCastException -> 0x00a4 }
            r6.atr = r7     // Catch:{ ClassCastException -> 0x00a4 }
            java.lang.String r5 = r5.eid     // Catch:{ ClassCastException -> 0x00a4 }
            r6.eid = r5     // Catch:{ ClassCastException -> 0x00a4 }
            r0.add(r6)     // Catch:{ ClassCastException -> 0x00a4 }
            goto L_0x005b
        L_0x00a3:
            return r0
        L_0x00a4:
            java.util.ArrayList r13 = (java.util.ArrayList) r13     // Catch:{ ClassCastException -> 0x00ea }
            java.util.Iterator r13 = r13.iterator()     // Catch:{ ClassCastException -> 0x00ea }
        L_0x00aa:
            boolean r4 = r13.hasNext()     // Catch:{ ClassCastException -> 0x00ea }
            if (r4 == 0) goto L_0x00ea
            java.lang.Object r4 = r13.next()     // Catch:{ ClassCastException -> 0x00ea }
            android.hardware.radio.config.V1_0.SimSlotStatus r4 = (android.hardware.radio.config.V1_0.SimSlotStatus) r4     // Catch:{ ClassCastException -> 0x00ea }
            com.android.internal.telephony.uicc.IccSlotStatus r5 = new com.android.internal.telephony.uicc.IccSlotStatus     // Catch:{ ClassCastException -> 0x00ea }
            r5.<init>()     // Catch:{ ClassCastException -> 0x00ea }
            int r6 = r4.cardState     // Catch:{ ClassCastException -> 0x00ea }
            r5.setCardState(r6)     // Catch:{ ClassCastException -> 0x00ea }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r6 = new com.android.internal.telephony.uicc.IccSimPortInfo[r3]     // Catch:{ ClassCastException -> 0x00ea }
            r5.mSimPortInfos = r6     // Catch:{ ClassCastException -> 0x00ea }
            com.android.internal.telephony.uicc.IccSimPortInfo r6 = new com.android.internal.telephony.uicc.IccSimPortInfo     // Catch:{ ClassCastException -> 0x00ea }
            r6.<init>()     // Catch:{ ClassCastException -> 0x00ea }
            java.lang.String r7 = r4.iccid     // Catch:{ ClassCastException -> 0x00ea }
            r6.mIccId = r7     // Catch:{ ClassCastException -> 0x00ea }
            int r7 = r4.slotState     // Catch:{ ClassCastException -> 0x00ea }
            if (r7 != r3) goto L_0x00d3
            r7 = r3
            goto L_0x00d4
        L_0x00d3:
            r7 = r2
        L_0x00d4:
            r6.mPortActive = r7     // Catch:{ ClassCastException -> 0x00ea }
            if (r7 == 0) goto L_0x00db
            int r7 = r4.logicalSlotId     // Catch:{ ClassCastException -> 0x00ea }
            goto L_0x00dc
        L_0x00db:
            r7 = r1
        L_0x00dc:
            r6.mLogicalSlotIndex = r7     // Catch:{ ClassCastException -> 0x00ea }
            com.android.internal.telephony.uicc.IccSimPortInfo[] r7 = r5.mSimPortInfos     // Catch:{ ClassCastException -> 0x00ea }
            r7[r2] = r6     // Catch:{ ClassCastException -> 0x00ea }
            java.lang.String r4 = r4.atr     // Catch:{ ClassCastException -> 0x00ea }
            r5.atr = r4     // Catch:{ ClassCastException -> 0x00ea }
            r0.add(r5)     // Catch:{ ClassCastException -> 0x00ea }
            goto L_0x00aa
        L_0x00ea:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertHalSlotStatus(java.lang.Object):java.util.ArrayList");
    }

    public static SlotPortMapping[] convertSimSlotsMapping(List<UiccSlotMapping> list) {
        SlotPortMapping[] slotPortMappingArr = new SlotPortMapping[list.size()];
        for (UiccSlotMapping next : list) {
            int logicalSlotIndex = next.getLogicalSlotIndex();
            SlotPortMapping slotPortMapping = new SlotPortMapping();
            slotPortMappingArr[logicalSlotIndex] = slotPortMapping;
            slotPortMapping.physicalSlotId = next.getPhysicalSlotIndex();
            slotPortMappingArr[logicalSlotIndex].portId = next.getPortIndex();
        }
        return slotPortMappingArr;
    }

    public static ArrayList<Integer> convertSlotMappingToList(List<UiccSlotMapping> list) {
        int[] iArr = new int[list.size()];
        for (UiccSlotMapping next : list) {
            iArr[next.getLogicalSlotIndex()] = next.getPhysicalSlotIndex();
        }
        return primitiveArrayToArrayList(iArr);
    }

    public static PhoneCapability convertHalPhoneCapability(int[] iArr, Object obj) {
        boolean z;
        byte b;
        ArrayList arrayList = new ArrayList();
        if (obj instanceof android.hardware.radio.config.PhoneCapability) {
            android.hardware.radio.config.PhoneCapability phoneCapability = (android.hardware.radio.config.PhoneCapability) obj;
            byte b2 = phoneCapability.maxActiveData;
            boolean z2 = phoneCapability.isInternetLingeringSupported;
            for (byte modemInfo : phoneCapability.logicalModemIds) {
                arrayList.add(new ModemInfo(modemInfo));
            }
            z = z2;
            b = b2;
        } else if (obj instanceof android.hardware.radio.config.V1_1.PhoneCapability) {
            android.hardware.radio.config.V1_1.PhoneCapability phoneCapability2 = (android.hardware.radio.config.V1_1.PhoneCapability) obj;
            byte b3 = phoneCapability2.maxActiveData;
            boolean z3 = phoneCapability2.isInternetLingeringSupported;
            Iterator<android.hardware.radio.config.V1_1.ModemInfo> it = phoneCapability2.logicalModemList.iterator();
            while (it.hasNext()) {
                arrayList.add(new ModemInfo(it.next().modemId));
            }
            b = b3;
            z = z3;
        } else {
            b = 0;
            z = false;
        }
        return new PhoneCapability(0, b, arrayList, z, iArr);
    }

    public static void appendPrimitiveArrayToArrayList(byte[] bArr, ArrayList<Byte> arrayList) {
        for (byte valueOf : bArr) {
            arrayList.add(Byte.valueOf(valueOf));
        }
    }

    public static ArrayList<Byte> primitiveArrayToArrayList(byte[] bArr) {
        ArrayList<Byte> arrayList = new ArrayList<>(bArr.length);
        for (byte valueOf : bArr) {
            arrayList.add(Byte.valueOf(valueOf));
        }
        return arrayList;
    }

    public static ArrayList<Integer> primitiveArrayToArrayList(int[] iArr) {
        ArrayList<Integer> arrayList = new ArrayList<>(iArr.length);
        for (int valueOf : iArr) {
            arrayList.add(Integer.valueOf(valueOf));
        }
        return arrayList;
    }

    public static ArrayList<String> primitiveArrayToArrayList(String[] strArr) {
        return new ArrayList<>(Arrays.asList(strArr));
    }

    public static byte[] arrayListToPrimitiveArray(ArrayList<Byte> arrayList) {
        int size = arrayList.size();
        byte[] bArr = new byte[size];
        for (int i = 0; i < size; i++) {
            bArr[i] = arrayList.get(i).byteValue();
        }
        return bArr;
    }

    public static String setupDataReasonToString(int i) {
        if (i == 0) {
            return "UNKNOWN";
        }
        if (i == 1) {
            return "NORMAL";
        }
        if (i == 3) {
            return "HANDOVER";
        }
        return "UNKNOWN(" + i + ")";
    }

    public static String deactivateDataReasonToString(int i) {
        if (i == 0) {
            return "UNKNOWN";
        }
        if (i == 1) {
            return "NORMAL";
        }
        if (i == 2) {
            return "SHUTDOWN";
        }
        if (i == 3) {
            return "HANDOVER";
        }
        return "UNKNOWN(" + i + ")";
    }

    public static String requestToString(int i) {
        switch (i) {
            case 1:
                return "GET_SIM_STATUS";
            case 2:
                return "ENTER_SIM_PIN";
            case 3:
                return "ENTER_SIM_PUK";
            case 4:
                return "ENTER_SIM_PIN2";
            case 5:
                return "ENTER_SIM_PUK2";
            case 6:
                return "CHANGE_SIM_PIN";
            case 7:
                return "CHANGE_SIM_PIN2";
            case 8:
                return "ENTER_NETWORK_DEPERSONALIZATION";
            case 9:
                return "GET_CURRENT_CALLS";
            case 10:
                return "DIAL";
            case 11:
                return "GET_IMSI";
            case 12:
                return "HANGUP";
            case 13:
                return "HANGUP_WAITING_OR_BACKGROUND";
            case 14:
                return "HANGUP_FOREGROUND_RESUME_BACKGROUND";
            case 15:
                return "REQUEST_SWITCH_WAITING_OR_HOLDING_AND_ACTIVE";
            case 16:
                return "CONFERENCE";
            case 17:
                return "UDUB";
            case 18:
                return "LAST_CALL_FAIL_CAUSE";
            case 19:
                return "SIGNAL_STRENGTH";
            case 20:
                return "VOICE_REGISTRATION_STATE";
            case 21:
                return "DATA_REGISTRATION_STATE";
            case 22:
                return "OPERATOR";
            case 23:
                return "RADIO_POWER";
            case 24:
                return "DTMF";
            case 25:
                return "SEND_SMS";
            case 26:
                return "SEND_SMS_EXPECT_MORE";
            case 27:
                return "SETUP_DATA_CALL";
            case 28:
                return "SIM_IO";
            case 29:
                return "SEND_USSD";
            case 30:
                return "CANCEL_USSD";
            case 31:
                return "GET_CLIR";
            case 32:
                return "SET_CLIR";
            case 33:
                return "QUERY_CALL_FORWARD_STATUS";
            case 34:
                return "SET_CALL_FORWARD";
            case 35:
                return "QUERY_CALL_WAITING";
            case 36:
                return "SET_CALL_WAITING";
            case 37:
                return "SMS_ACKNOWLEDGE";
            case 38:
                return "GET_IMEI";
            case 39:
                return "GET_IMEISV";
            case 40:
                return "ANSWER";
            case 41:
                return "DEACTIVATE_DATA_CALL";
            case 42:
                return "QUERY_FACILITY_LOCK";
            case 43:
                return "SET_FACILITY_LOCK";
            case 44:
                return "CHANGE_BARRING_PASSWORD";
            case 45:
                return "QUERY_NETWORK_SELECTION_MODE";
            case 46:
                return "SET_NETWORK_SELECTION_AUTOMATIC";
            case 47:
                return "SET_NETWORK_SELECTION_MANUAL";
            case 48:
                return "QUERY_AVAILABLE_NETWORKS ";
            case 49:
                return "DTMF_START";
            case 50:
                return "DTMF_STOP";
            case 51:
                return "BASEBAND_VERSION";
            case 52:
                return "SEPARATE_CONNECTION";
            case 53:
                return "SET_MUTE";
            case 54:
                return "GET_MUTE";
            case 55:
                return "QUERY_CLIP";
            case 56:
                return "LAST_DATA_CALL_FAIL_CAUSE";
            case 57:
                return "DATA_CALL_LIST";
            case 58:
                return "RESET_RADIO";
            case 59:
                return "OEM_HOOK_RAW";
            case 60:
                return "OEM_HOOK_STRINGS";
            case 61:
                return "SCREEN_STATE";
            case 62:
                return "SET_SUPP_SVC_NOTIFICATION";
            case 63:
                return "WRITE_SMS_TO_SIM";
            case 64:
                return "DELETE_SMS_ON_SIM";
            case 65:
                return "SET_BAND_MODE";
            case 66:
                return "QUERY_AVAILABLE_BAND_MODE";
            case 67:
                return "STK_GET_PROFILE";
            case 68:
                return "STK_SET_PROFILE";
            case 69:
                return "STK_SEND_ENVELOPE_COMMAND";
            case 70:
                return "STK_SEND_TERMINAL_RESPONSE";
            case 71:
                return "STK_HANDLE_CALL_SETUP_REQUESTED_FROM_SIM";
            case 72:
                return "EXPLICIT_CALL_TRANSFER";
            case 73:
                return "SET_PREFERRED_NETWORK_TYPE";
            case 74:
                return "GET_PREFERRED_NETWORK_TYPE";
            case 75:
                return "GET_NEIGHBORING_CELL_IDS";
            case 76:
                return "SET_LOCATION_UPDATES";
            case 77:
                return "CDMA_SET_SUBSCRIPTION_SOURCE";
            case 78:
                return "CDMA_SET_ROAMING_PREFERENCE";
            case 79:
                return "CDMA_QUERY_ROAMING_PREFERENCE";
            case 80:
                return "SET_TTY_MODE";
            case 81:
                return "QUERY_TTY_MODE";
            case 82:
                return "CDMA_SET_PREFERRED_VOICE_PRIVACY_MODE";
            case 83:
                return "CDMA_QUERY_PREFERRED_VOICE_PRIVACY_MODE";
            case 84:
                return "CDMA_FLASH";
            case 85:
                return "CDMA_BURST_DTMF";
            case 86:
                return "CDMA_VALIDATE_AND_WRITE_AKEY";
            case 87:
                return "CDMA_SEND_SMS";
            case 88:
                return "CDMA_SMS_ACKNOWLEDGE";
            case 89:
                return "GSM_GET_BROADCAST_CONFIG";
            case 90:
                return "GSM_SET_BROADCAST_CONFIG";
            case 91:
                return "GSM_BROADCAST_ACTIVATION";
            case 92:
                return "CDMA_GET_BROADCAST_CONFIG";
            case 93:
                return "CDMA_SET_BROADCAST_CONFIG";
            case 94:
                return "CDMA_BROADCAST_ACTIVATION";
            case 95:
                return "CDMA_SUBSCRIPTION";
            case 96:
                return "CDMA_WRITE_SMS_TO_RUIM";
            case 97:
                return "CDMA_DELETE_SMS_ON_RUIM";
            case 98:
                return "DEVICE_IDENTITY";
            case 99:
                return "EXIT_EMERGENCY_CALLBACK_MODE";
            case 100:
                return "GET_SMSC_ADDRESS";
            case 101:
                return "SET_SMSC_ADDRESS";
            case 102:
                return "REPORT_SMS_MEMORY_STATUS";
            case 103:
                return "REPORT_STK_SERVICE_IS_RUNNING";
            case 104:
                return "CDMA_GET_SUBSCRIPTION_SOURCE";
            case 105:
                return "ISIM_AUTHENTICATION";
            case 106:
                return "ACKNOWLEDGE_INCOMING_GSM_SMS_WITH_PDU";
            case 107:
                return "STK_SEND_ENVELOPE_WITH_STATUS";
            case 108:
                return "VOICE_RADIO_TECH";
            case 109:
                return "GET_CELL_INFO_LIST";
            case 110:
                return "SET_CELL_INFO_LIST_RATE";
            case 111:
                return "SET_INITIAL_ATTACH_APN";
            case 112:
                return "IMS_REGISTRATION_STATE";
            case 113:
                return "IMS_SEND_SMS";
            case 114:
                return "SIM_TRANSMIT_APDU_BASIC";
            case 115:
                return "SIM_OPEN_CHANNEL";
            case 116:
                return "SIM_CLOSE_CHANNEL";
            case 117:
                return "SIM_TRANSMIT_APDU_CHANNEL";
            case 118:
                return "NV_READ_ITEM";
            case 119:
                return "NV_WRITE_ITEM";
            case 120:
                return "NV_WRITE_CDMA_PRL";
            case 121:
                return "NV_RESET_CONFIG";
            case 122:
                return "SET_UICC_SUBSCRIPTION";
            case 123:
                return "ALLOW_DATA";
            case 124:
                return "GET_HARDWARE_CONFIG";
            case 125:
                return "SIM_AUTHENTICATION";
            case 126:
                return "GET_DC_RT_INFO";
            case 127:
                return "SET_DC_RT_INFO_RATE";
            case 128:
                return "SET_DATA_PROFILE";
            case 129:
                return "SHUTDOWN";
            case InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT /*130*/:
                return "GET_RADIO_CAPABILITY";
            case InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC /*131*/:
                return "SET_RADIO_CAPABILITY";
            case 132:
                return "START_LCE";
            case NetworkStackConstants.ICMPV6_ROUTER_SOLICITATION /*133*/:
                return "STOP_LCE";
            case 134:
                return "PULL_LCEDATA";
            case NetworkStackConstants.ICMPV6_NEIGHBOR_SOLICITATION /*135*/:
                return "GET_ACTIVITY_INFO";
            case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                return "SET_ALLOWED_CARRIERS";
            case 137:
                return "GET_ALLOWED_CARRIERS";
            case 138:
                return "SEND_DEVICE_STATE";
            case 139:
                return "SET_UNSOLICITED_RESPONSE_FILTER";
            case android.telephony.gsm.SmsMessage.MAX_USER_DATA_BYTES:
                return "SET_SIM_CARD_POWER";
            case 141:
                return "SET_CARRIER_INFO_IMSI_ENCRYPTION";
            case 142:
                return "START_NETWORK_SCAN";
            case 143:
                return "STOP_NETWORK_SCAN";
            case 144:
                return "START_KEEPALIVE";
            case 145:
                return "STOP_KEEPALIVE";
            case 146:
                return "ENABLE_MODEM";
            case 147:
                return "GET_MODEM_STATUS";
            case 148:
                return "CDMA_SEND_SMS_EXPECT_MORE";
            case 149:
                return "GET_SIM_PHONEBOOK_CAPACITY";
            case 150:
                return "GET_SIM_PHONEBOOK_RECORDS";
            case 151:
                return "UPDATE_SIM_PHONEBOOK_RECORD";
            default:
                switch (i) {
                    case 200:
                        return "GET_SLOT_STATUS";
                    case 201:
                        return "SET_LOGICAL_TO_PHYSICAL_SLOT_MAPPING";
                    case 202:
                        return "SET_SIGNAL_STRENGTH_REPORTING_CRITERIA";
                    case 203:
                        return "SET_LINK_CAPACITY_REPORTING_CRITERIA";
                    case 204:
                        return "SET_PREFERRED_DATA_MODEM";
                    case 205:
                        return "EMERGENCY_DIAL";
                    case 206:
                        return "GET_PHONE_CAPABILITY";
                    case 207:
                        return "SWITCH_DUAL_SIM_CONFIG";
                    case BerTlv.BER_PROACTIVE_COMMAND_TAG /*208*/:
                        return "ENABLE_UICC_APPLICATIONS";
                    case 209:
                        return "GET_UICC_APPLICATIONS_ENABLEMENT";
                    case 210:
                        return "SET_SYSTEM_SELECTION_CHANNELS";
                    case 211:
                        return "GET_BARRING_INFO";
                    case CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_APP_TOOLKIT_BUSY:
                        return "ENTER_SIM_DEPERSONALIZATION";
                    case CommandsInterface.GSM_SMS_FAIL_CAUSE_USIM_DATA_DOWNLOAD_ERROR:
                        return "ENABLE_NR_DUAL_CONNECTIVITY";
                    case BerTlv.BER_EVENT_DOWNLOAD_TAG /*214*/:
                        return "IS_NR_DUAL_CONNECTIVITY_ENABLED";
                    case 215:
                        return "ALLOCATE_PDU_SESSION_ID";
                    case 216:
                        return "RELEASE_PDU_SESSION_ID";
                    case 217:
                        return "START_HANDOVER";
                    case 218:
                        return "CANCEL_HANDOVER";
                    case 219:
                        return "GET_SYSTEM_SELECTION_CHANNELS";
                    case 220:
                        return "GET_HAL_DEVICE_CAPABILITIES";
                    case NetworkStackConstants.VENDOR_SPECIFIC_IE_ID /*221*/:
                        return "SET_DATA_THROTTLING";
                    case 222:
                        return "SET_ALLOWED_NETWORK_TYPES_BITMAP";
                    case 223:
                        return "GET_ALLOWED_NETWORK_TYPES_BITMAP";
                    case 224:
                        return "GET_SLICING_CONFIG";
                    case 225:
                        return "ENABLE_VONR";
                    case 226:
                        return "IS_VONR_ENABLED";
                    case 227:
                        return "SET_USAGE_SETTING";
                    case 228:
                        return "GET_USAGE_SETTING";
                    default:
                        if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
                            try {
                                return (String) Class.forName("com.mediatek.internal.telephony.MtkRIL").getDeclaredMethod("requestToStringEx", new Class[]{Integer.class}).invoke((Object) null, new Object[]{Integer.valueOf(i)});
                            } catch (Exception unused) {
                                return "<unknown request " + i + ">";
                            }
                        } else {
                            return "<unknown request " + i + ">";
                        }
                }
        }
    }

    public static String responseToString(int i) {
        switch (i) {
            case 1000:
                return "UNSOL_RESPONSE_RADIO_STATE_CHANGED";
            case 1001:
                return "UNSOL_RESPONSE_CALL_STATE_CHANGED";
            case 1002:
                return "UNSOL_RESPONSE_NETWORK_STATE_CHANGED";
            case 1003:
                return "UNSOL_RESPONSE_NEW_SMS";
            case 1004:
                return "UNSOL_RESPONSE_NEW_SMS_STATUS_REPORT";
            case 1005:
                return "UNSOL_RESPONSE_NEW_SMS_ON_SIM";
            case 1006:
                return "UNSOL_ON_USSD";
            case 1007:
                return "UNSOL_ON_USSD_REQUEST";
            case 1008:
                return "UNSOL_NITZ_TIME_RECEIVED";
            case 1009:
                return "UNSOL_SIGNAL_STRENGTH";
            case PointerIconCompat.TYPE_ALIAS:
                return "UNSOL_DATA_CALL_LIST_CHANGED";
            case PointerIconCompat.TYPE_COPY:
                return "UNSOL_SUPP_SVC_NOTIFICATION";
            case PointerIconCompat.TYPE_NO_DROP:
                return "UNSOL_STK_SESSION_END";
            case PointerIconCompat.TYPE_ALL_SCROLL:
                return "UNSOL_STK_PROACTIVE_COMMAND";
            case PointerIconCompat.TYPE_HORIZONTAL_DOUBLE_ARROW:
                return "UNSOL_STK_EVENT_NOTIFY";
            case PointerIconCompat.TYPE_VERTICAL_DOUBLE_ARROW:
                return "UNSOL_STK_CALL_SETUP";
            case PointerIconCompat.TYPE_TOP_RIGHT_DIAGONAL_DOUBLE_ARROW:
                return "UNSOL_SIM_SMS_STORAGE_FULL";
            case PointerIconCompat.TYPE_TOP_LEFT_DIAGONAL_DOUBLE_ARROW:
                return "UNSOL_SIM_REFRESH";
            case PointerIconCompat.TYPE_ZOOM_IN:
                return "UNSOL_CALL_RING";
            case PointerIconCompat.TYPE_ZOOM_OUT:
                return "UNSOL_RESPONSE_SIM_STATUS_CHANGED";
            case PointerIconCompat.TYPE_GRAB:
                return "UNSOL_RESPONSE_CDMA_NEW_SMS";
            case PointerIconCompat.TYPE_GRABBING:
                return "UNSOL_RESPONSE_NEW_BROADCAST_SMS";
            case 1022:
                return "UNSOL_CDMA_RUIM_SMS_STORAGE_FULL";
            case 1023:
                return "UNSOL_RESTRICTED_STATE_CHANGED";
            case 1024:
                return "UNSOL_ENTER_EMERGENCY_CALLBACK_MODE";
            case InputDeviceCompat.SOURCE_GAMEPAD:
                return "UNSOL_CDMA_CALL_WAITING";
            case 1026:
                return "UNSOL_CDMA_OTA_PROVISION_STATUS";
            case 1027:
                return "UNSOL_CDMA_INFO_REC";
            case 1028:
                return "UNSOL_OEM_HOOK_RAW";
            case 1029:
                return "UNSOL_RINGBACK_TONE";
            case 1030:
                return "UNSOL_RESEND_INCALL_MUTE";
            case 1031:
                return "UNSOL_CDMA_SUBSCRIPTION_SOURCE_CHANGED";
            case 1032:
                return "UNSOL_CDMA_PRL_CHANGED";
            case 1033:
                return "UNSOL_EXIT_EMERGENCY_CALLBACK_MODE";
            case 1034:
                return "UNSOL_RIL_CONNECTED";
            case 1035:
                return "UNSOL_VOICE_RADIO_TECH_CHANGED";
            case 1036:
                return "UNSOL_CELL_INFO_LIST";
            case 1037:
                return "UNSOL_RESPONSE_IMS_NETWORK_STATE_CHANGED";
            case 1038:
                return "UNSOL_UICC_SUBSCRIPTION_STATUS_CHANGED";
            case 1039:
                return "UNSOL_SRVCC_STATE_NOTIFY";
            case 1040:
                return "UNSOL_HARDWARE_CONFIG_CHANGED";
            case 1041:
                return "UNSOL_DC_RT_INFO_CHANGED";
            case 1042:
                return "UNSOL_RADIO_CAPABILITY";
            case 1043:
                return "UNSOL_ON_SS";
            case 1044:
                return "UNSOL_STK_CC_ALPHA_NOTIFY";
            case 1045:
                return "UNSOL_LCE_INFO_RECV";
            case 1046:
                return "UNSOL_PCO_DATA";
            case 1047:
                return "UNSOL_MODEM_RESTART";
            case 1048:
                return "UNSOL_CARRIER_INFO_IMSI_ENCRYPTION";
            case 1049:
                return "UNSOL_NETWORK_SCAN_RESULT";
            case 1050:
                return "UNSOL_KEEPALIVE_STATUS";
            default:
                switch (i) {
                    case 1052:
                        return "UNSOL_UNTHROTTLE_APN";
                    case 1053:
                        return "UNSOL_RESPONSE_SIM_PHONEBOOK_CHANGED";
                    case 1054:
                        return "UNSOL_RESPONSE_SIM_PHONEBOOK_RECORDS_RECEIVED";
                    default:
                        switch (i) {
                            case 1100:
                                return "UNSOL_ICC_SLOT_STATUS";
                            case 1101:
                                return "UNSOL_PHYSICAL_CHANNEL_CONFIG";
                            case 1102:
                                return "UNSOL_EMERGENCY_NUMBER_LIST";
                            case 1103:
                                return "UNSOL_UICC_APPLICATIONS_ENABLEMENT_CHANGED";
                            case 1104:
                                return "UNSOL_REGISTRATION_FAILED";
                            case 1105:
                                return "UNSOL_BARRING_INFO_CHANGED";
                            default:
                                if (!SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
                                    return "<unknown response>";
                                }
                                try {
                                    return (String) Class.forName("com.mediatek.internal.telephony.MtkRIL").getDeclaredMethod("responseToStringEx", new Class[]{Integer.class}).invoke((Object) null, new Object[]{Integer.valueOf(i)});
                                } catch (Exception unused) {
                                    return "<unknown response>";
                                }
                        }
                }
        }
    }

    @VisibleForTesting
    public static Set<String> getCaps(HalVersion halVersion, boolean z) {
        HashSet hashSet = new HashSet();
        if (halVersion.equals(RIL.RADIO_HAL_VERSION_UNKNOWN)) {
            loge("Radio Hal Version is UNKNOWN!");
        }
        logd("Radio Hal Version = " + halVersion.toString());
        if (halVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
            hashSet.add("CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK");
            logd("CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK");
            if (!z) {
                hashSet.add("CAPABILITY_SECONDARY_LINK_BANDWIDTH_VISIBLE");
                logd("CAPABILITY_SECONDARY_LINK_BANDWIDTH_VISIBLE");
                hashSet.add("CAPABILITY_NR_DUAL_CONNECTIVITY_CONFIGURATION_AVAILABLE");
                logd("CAPABILITY_NR_DUAL_CONNECTIVITY_CONFIGURATION_AVAILABLE");
                hashSet.add("CAPABILITY_THERMAL_MITIGATION_DATA_THROTTLING");
                logd("CAPABILITY_THERMAL_MITIGATION_DATA_THROTTLING");
                hashSet.add("CAPABILITY_SLICING_CONFIG_SUPPORTED");
                logd("CAPABILITY_SLICING_CONFIG_SUPPORTED");
                hashSet.add("CAPABILITY_PHYSICAL_CHANNEL_CONFIG_1_6_SUPPORTED");
                logd("CAPABILITY_PHYSICAL_CHANNEL_CONFIG_1_6_SUPPORTED");
            } else {
                hashSet.add("CAPABILITY_SIM_PHONEBOOK_IN_MODEM");
                logd("CAPABILITY_SIM_PHONEBOOK_IN_MODEM");
            }
        }
        return hashSet;
    }

    private static boolean isPrimitiveOrWrapper(Class cls) {
        return cls.isPrimitive() || WRAPPER_CLASSES.contains(cls);
    }

    /* JADX WARNING: Removed duplicated region for block: B:13:0x0034  */
    /* JADX WARNING: Removed duplicated region for block: B:38:0x00e1 A[SYNTHETIC, Splitter:B:38:0x00e1] */
    /* JADX WARNING: Removed duplicated region for block: B:50:0x0159  */
    /* JADX WARNING: Removed duplicated region for block: B:66:0x01ad  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static java.lang.String convertToString(java.lang.Object r11) {
        /*
            r0 = 1
            r1 = 0
            java.lang.Class r2 = r11.getClass()     // Catch:{ NoSuchMethodException -> 0x0019 }
            java.lang.String r3 = "toString"
            java.lang.Class[] r4 = new java.lang.Class[r1]     // Catch:{ NoSuchMethodException -> 0x0019 }
            java.lang.reflect.Method r2 = r2.getMethod(r3, r4)     // Catch:{ NoSuchMethodException -> 0x0019 }
            java.lang.Class r2 = r2.getDeclaringClass()     // Catch:{ NoSuchMethodException -> 0x0019 }
            java.lang.Class<java.lang.Object> r3 = java.lang.Object.class
            if (r2 == r3) goto L_0x0021
            r2 = r0
            goto L_0x0022
        L_0x0019:
            r2 = move-exception
            java.lang.String r2 = r2.toString()
            loge(r2)
        L_0x0021:
            r2 = r1
        L_0x0022:
            if (r2 != 0) goto L_0x01ad
            java.lang.Class r2 = r11.getClass()
            boolean r2 = isPrimitiveOrWrapper(r2)
            if (r2 != 0) goto L_0x01ad
            boolean r2 = r11 instanceof java.util.ArrayList
            if (r2 == 0) goto L_0x0034
            goto L_0x01ad
        L_0x0034:
            java.lang.Class r2 = r11.getClass()
            boolean r2 = r2.isArray()
            java.lang.String r3 = ", "
            if (r2 == 0) goto L_0x009e
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            java.lang.String r4 = "["
            r2.<init>(r4)
            java.lang.Class r4 = r11.getClass()
            java.lang.Class r4 = r4.getComponentType()
            boolean r4 = isPrimitiveOrWrapper(r4)
            if (r4 == 0) goto L_0x006e
            r4 = r1
        L_0x0056:
            int r5 = java.lang.reflect.Array.getLength(r11)
            if (r1 >= r5) goto L_0x0085
            java.lang.Object r4 = java.lang.reflect.Array.get(r11, r1)
            java.lang.String r4 = convertToString(r4)
            r2.append(r4)
            r2.append(r3)
            int r1 = r1 + 1
            r4 = r0
            goto L_0x0056
        L_0x006e:
            java.lang.Object[] r11 = (java.lang.Object[]) r11
            int r4 = r11.length
            r5 = r1
        L_0x0072:
            if (r1 >= r4) goto L_0x0084
            r5 = r11[r1]
            java.lang.String r5 = convertToString(r5)
            r2.append(r5)
            r2.append(r3)
            int r1 = r1 + 1
            r5 = r0
            goto L_0x0072
        L_0x0084:
            r4 = r5
        L_0x0085:
            if (r4 == 0) goto L_0x0094
            int r11 = r2.length()
            int r11 = r11 + -2
            int r0 = r2.length()
            r2.delete(r11, r0)
        L_0x0094:
            java.lang.String r11 = "]"
            r2.append(r11)
            java.lang.String r11 = r2.toString()
            return r11
        L_0x009e:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            java.lang.Class r4 = r11.getClass()
            java.lang.String r4 = r4.getSimpleName()
            r2.<init>(r4)
            java.lang.String r4 = "{"
            r2.append(r4)
            java.lang.Class r4 = r11.getClass()
            java.lang.reflect.Field[] r4 = r4.getDeclaredFields()
            r5 = -1
            java.lang.Class r6 = r11.getClass()     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            java.lang.String r7 = "getTag"
            java.lang.Class[] r8 = new java.lang.Class[r1]     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            java.lang.reflect.Method r6 = r6.getDeclaredMethod(r7, r8)     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            java.lang.Object[] r7 = new java.lang.Object[r1]     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            java.lang.Object r6 = r6.invoke(r11, r7)     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            java.lang.Integer r6 = (java.lang.Integer) r6     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            int r6 = r6.intValue()     // Catch:{ IllegalAccessException | InvocationTargetException -> 0x00d3, NoSuchMethodException -> 0x00db }
            goto L_0x00dc
        L_0x00d3:
            r6 = move-exception
            java.lang.String r6 = r6.toString()
            loge(r6)
        L_0x00db:
            r6 = r5
        L_0x00dc:
            java.lang.String r7 = "="
            r8 = 0
            if (r6 == r5) goto L_0x0159
            java.lang.Class r3 = r11.getClass()     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.String r4 = "_tagString"
            java.lang.Class[] r5 = new java.lang.Class[r0]     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.Class r9 = java.lang.Integer.TYPE     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            r5[r1] = r9     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.reflect.Method r3 = r3.getDeclaredMethod(r4, r5)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            r3.setAccessible(r0)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.Object[] r4 = new java.lang.Object[r0]     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.Integer r5 = java.lang.Integer.valueOf(r6)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            r4[r1] = r5     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.Object r3 = r3.invoke(r11, r4)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            java.lang.String r3 = (java.lang.String) r3     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0103 }
            goto L_0x010c
        L_0x0103:
            r3 = move-exception
            java.lang.String r3 = r3.toString()
            loge(r3)
            r3 = r8
        L_0x010c:
            if (r3 == 0) goto L_0x01a2
            r2.append(r3)
            r2.append(r7)
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "get"
            r4.append(r5)
            java.lang.String r5 = r3.substring(r1, r0)
            java.util.Locale r6 = java.util.Locale.ROOT
            java.lang.String r5 = r5.toUpperCase(r6)
            r4.append(r5)
            java.lang.String r0 = r3.substring(r0)
            r4.append(r0)
            java.lang.String r0 = r4.toString()
            java.lang.Class r3 = r11.getClass()     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0147 }
            java.lang.Class[] r4 = new java.lang.Class[r1]     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0147 }
            java.lang.reflect.Method r0 = r3.getDeclaredMethod(r0, r4)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0147 }
            java.lang.Object[] r1 = new java.lang.Object[r1]     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0147 }
            java.lang.Object r8 = r0.invoke(r11, r1)     // Catch:{ IllegalAccessException | NoSuchMethodException | InvocationTargetException -> 0x0147 }
            goto L_0x014f
        L_0x0147:
            r11 = move-exception
            java.lang.String r11 = r11.toString()
            loge(r11)
        L_0x014f:
            if (r8 == 0) goto L_0x01a2
            java.lang.String r11 = convertToString(r8)
            r2.append(r11)
            goto L_0x01a2
        L_0x0159:
            int r5 = r4.length
            r6 = r1
        L_0x015b:
            if (r1 >= r5) goto L_0x0193
            r9 = r4[r1]
            int r10 = r9.getModifiers()
            boolean r10 = java.lang.reflect.Modifier.isStatic(r10)
            if (r10 == 0) goto L_0x016a
            goto L_0x0190
        L_0x016a:
            java.lang.String r10 = r9.getName()
            r2.append(r10)
            r2.append(r7)
            java.lang.Object r9 = r9.get(r11)     // Catch:{ IllegalAccessException -> 0x0179 }
            goto L_0x0182
        L_0x0179:
            r9 = move-exception
            java.lang.String r9 = r9.toString()
            loge(r9)
            r9 = r8
        L_0x0182:
            if (r9 != 0) goto L_0x0185
            goto L_0x0190
        L_0x0185:
            java.lang.String r6 = convertToString(r9)
            r2.append(r6)
            r2.append(r3)
            r6 = r0
        L_0x0190:
            int r1 = r1 + 1
            goto L_0x015b
        L_0x0193:
            if (r6 == 0) goto L_0x01a2
            int r11 = r2.length()
            int r11 = r11 + -2
            int r0 = r2.length()
            r2.delete(r11, r0)
        L_0x01a2:
            java.lang.String r11 = "}"
            r2.append(r11)
            java.lang.String r11 = r2.toString()
            return r11
        L_0x01ad:
            java.lang.String r11 = r11.toString()
            return r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RILUtils.convertToString(java.lang.Object):java.lang.String");
    }

    private static void logd(String str) {
        Rlog.d(TAG, str);
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }
}
