package android.internal.telephony.sysprop;

import android.os.SystemProperties;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.StringJoiner;
import java.util.function.Function;

public final class BluetoothProperties {
    private BluetoothProperties() {
    }

    private static Boolean tryParseBoolean(String str) {
        String lowerCase = str.toLowerCase(Locale.US);
        lowerCase.hashCode();
        char c = 65535;
        switch (lowerCase.hashCode()) {
            case 48:
                if (lowerCase.equals("0")) {
                    c = 0;
                    break;
                }
                break;
            case 49:
                if (lowerCase.equals("1")) {
                    c = 1;
                    break;
                }
                break;
            case 3569038:
                if (lowerCase.equals("true")) {
                    c = 2;
                    break;
                }
                break;
            case 97196323:
                if (lowerCase.equals("false")) {
                    c = 3;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
            case 3:
                return Boolean.FALSE;
            case 1:
            case 2:
                return Boolean.TRUE;
            default:
                return null;
        }
    }

    private static Integer tryParseInteger(String str) {
        try {
            return Integer.valueOf(str);
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    /* access modifiers changed from: private */
    public static Integer tryParseUInt(String str) {
        try {
            return Integer.valueOf(Integer.parseUnsignedInt(str));
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    private static Long tryParseLong(String str) {
        try {
            return Long.valueOf(str);
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    private static Long tryParseULong(String str) {
        try {
            return Long.valueOf(Long.parseUnsignedLong(str));
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    private static Double tryParseDouble(String str) {
        try {
            return Double.valueOf(str);
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    private static String tryParseString(String str) {
        if ("".equals(str)) {
            return null;
        }
        return str;
    }

    private static <T extends Enum<T>> T tryParseEnum(Class<T> cls, String str) {
        try {
            return Enum.valueOf(cls, str.toUpperCase(Locale.US));
        } catch (IllegalArgumentException unused) {
            return null;
        }
    }

    private static <T> List<T> tryParseList(Function<String, T> function, String str) {
        if ("".equals(str)) {
            return new ArrayList();
        }
        ArrayList arrayList = new ArrayList();
        int i = 0;
        while (true) {
            StringBuilder sb = new StringBuilder();
            while (i < str.length() && str.charAt(i) != ',') {
                if (str.charAt(i) == '\\') {
                    i++;
                }
                if (i == str.length()) {
                    break;
                }
                sb.append(str.charAt(i));
                i++;
            }
            arrayList.add(function.apply(sb.toString()));
            if (i == str.length()) {
                return arrayList;
            }
            i++;
        }
    }

    private static <T extends Enum<T>> List<T> tryParseEnumList(Class<T> cls, String str) {
        if ("".equals(str)) {
            return new ArrayList();
        }
        ArrayList arrayList = new ArrayList();
        for (String tryParseEnum : str.split(",")) {
            arrayList.add(tryParseEnum(cls, tryParseEnum));
        }
        return arrayList;
    }

    private static String escape(String str) {
        return str.replaceAll("([\\\\,])", "\\\\$1");
    }

    private static <T> String formatList(List<T> list) {
        String str;
        StringJoiner stringJoiner = new StringJoiner(",");
        for (T next : list) {
            if (next == null) {
                str = "";
            } else {
                str = escape(next.toString());
            }
            stringJoiner.add(str);
        }
        return stringJoiner.toString();
    }

    private static String formatUIntList(List<Integer> list) {
        String str;
        StringJoiner stringJoiner = new StringJoiner(",");
        for (Integer next : list) {
            if (next == null) {
                str = "";
            } else {
                str = escape(Integer.toUnsignedString(next.intValue()));
            }
            stringJoiner.add(str);
        }
        return stringJoiner.toString();
    }

    private static String formatULongList(List<Long> list) {
        String str;
        StringJoiner stringJoiner = new StringJoiner(",");
        for (Long next : list) {
            if (next == null) {
                str = "";
            } else {
                str = escape(Long.toUnsignedString(next.longValue()));
            }
            stringJoiner.add(str);
        }
        return stringJoiner.toString();
    }

    private static <T extends Enum<T>> String formatEnumList(List<T> list, Function<T, String> function) {
        CharSequence charSequence;
        StringJoiner stringJoiner = new StringJoiner(",");
        for (T t : list) {
            if (t == null) {
                charSequence = "";
            } else {
                charSequence = function.apply(t);
            }
            stringJoiner.add(charSequence);
        }
        return stringJoiner.toString();
    }

    public enum snoop_default_mode_values {
        EMPTY("empty"),
        DISABLED("disabled"),
        FILTERED("filtered"),
        FULL("full");
        
        private final String propValue;

        private snoop_default_mode_values(String str) {
            this.propValue = str;
        }

        public String getPropValue() {
            return this.propValue;
        }
    }

    public static Optional<snoop_default_mode_values> snoop_default_mode() {
        return Optional.ofNullable((snoop_default_mode_values) tryParseEnum(snoop_default_mode_values.class, SystemProperties.get("persist.bluetooth.btsnoopdefaultmode")));
    }

    public static void snoop_default_mode(snoop_default_mode_values snoop_default_mode_values2) {
        SystemProperties.set("persist.bluetooth.btsnoopdefaultmode", snoop_default_mode_values2 == null ? "" : snoop_default_mode_values2.getPropValue());
    }

    public enum snoop_log_mode_values {
        EMPTY("empty"),
        DISABLED("disabled"),
        FILTERED("filtered"),
        FULL("full");
        
        private final String propValue;

        private snoop_log_mode_values(String str) {
            this.propValue = str;
        }

        public String getPropValue() {
            return this.propValue;
        }
    }

    public static Optional<snoop_log_mode_values> snoop_log_mode() {
        return Optional.ofNullable((snoop_log_mode_values) tryParseEnum(snoop_log_mode_values.class, SystemProperties.get("persist.bluetooth.btsnooplogmode")));
    }

    public static void snoop_log_mode(snoop_log_mode_values snoop_log_mode_values2) {
        SystemProperties.set("persist.bluetooth.btsnooplogmode", snoop_log_mode_values2 == null ? "" : snoop_log_mode_values2.getPropValue());
    }

    public static Optional<Boolean> factory_reset() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("persist.bluetooth.factoryreset")));
    }

    public static void factory_reset(Boolean bool) {
        SystemProperties.set("persist.bluetooth.factoryreset", bool == null ? "" : bool.toString());
    }

    public static Optional<Boolean> isGapLePrivacyEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.core.gap.le.privacy.enabled")));
    }

    public static Optional<String> getDefaultDeviceName() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("bluetooth.device.default_name")));
    }

    public static List<Integer> getClassOfDevice() {
        return tryParseList(new BluetoothProperties$$ExternalSyntheticLambda0(), SystemProperties.get("bluetooth.device.class_of_device"));
    }

    public static Optional<Integer> getHardwareOperatingVoltageMv() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("bluetooth.hardware.power.operating_voltage_mv")));
    }

    public static Optional<Integer> getHardwareIdleCurrentMa() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("bluetooth.hardware.power.idle_cur_ma")));
    }

    public static Optional<Integer> getHardwareTxCurrentMa() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("bluetooth.hardware.power.tx_cur_ma")));
    }

    public static Optional<Integer> getHardwareRxCurrentMa() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("bluetooth.hardware.power.rx_cur_ma")));
    }

    public static Optional<Boolean> isSupportPersistedStateEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.framework.support_persisted_state")));
    }

    public static Optional<Boolean> isAdapterAddressValidationEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.framework.adapter_address_validation")));
    }

    public static Optional<Boolean> isProfileA2dpSinkEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.a2dp.sink.enabled")));
    }

    public static Optional<Boolean> isProfileA2dpSourceEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.a2dp.source.enabled")));
    }

    public static Optional<Boolean> isProfileAshaCentralEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.asha.central.enabled")));
    }

    public static Optional<Boolean> isProfileAvrcpControllerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.avrcp.controller.enabled")));
    }

    public static Optional<Boolean> isProfileAvrcpTargetEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.avrcp.target.enabled")));
    }

    public static Optional<Boolean> isProfileBapBroadcastAssistEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.bap.broadcast.assist.enabled")));
    }

    public static Optional<Boolean> isProfileBapBroadcastSourceEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.bap.broadcast.source.enabled")));
    }

    public static Optional<Boolean> isProfileBapUnicastClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.bap.unicast.client.enabled")));
    }

    public static Optional<Boolean> isProfileBasClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.bas.client.enabled")));
    }

    public static Optional<Boolean> isProfileBassClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.bass.client.enabled")));
    }

    public static Optional<Boolean> isProfileCsipSetCoordinatorEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.csip.set_coordinator.enabled")));
    }

    public static Optional<Boolean> isProfileGattEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.gatt.enabled")));
    }

    public static Optional<Boolean> isProfileHapClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.hap.client.enabled")));
    }

    public static Optional<Boolean> isProfileHfpAgEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.hfp.ag.enabled")));
    }

    public static Optional<Boolean> isProfileHfpHfEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.hfp.hf.enabled")));
    }

    public static Optional<Boolean> isProfileHidDeviceEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.hid.device.enabled")));
    }

    public static Optional<Boolean> isProfileHidHostEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.hid.host.enabled")));
    }

    public static Optional<Boolean> isProfileMapClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.map.client.enabled")));
    }

    public static Optional<Boolean> isProfileMapServerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.map.server.enabled")));
    }

    public static Optional<Boolean> isProfileMcpServerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.mcp.server.enabled")));
    }

    public static Optional<Boolean> isProfileOppEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.opp.enabled")));
    }

    public static Optional<Boolean> isProfilePanNapEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.pan.nap.enabled")));
    }

    public static Optional<Boolean> isProfilePanPanuEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.pan.panu.enabled")));
    }

    public static Optional<Boolean> isProfilePbapClientEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.pbap.client.enabled")));
    }

    public static Optional<Boolean> isProfilePbapServerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.pbap.server.enabled")));
    }

    public static Optional<Boolean> isProfileSapServerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.sap.server.enabled")));
    }

    public static Optional<Boolean> isProfileCcpServerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.ccp.server.enabled")));
    }

    public static Optional<Boolean> isProfileVcpControllerEnabled() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("bluetooth.profile.vcp.controller.enabled")));
    }
}
