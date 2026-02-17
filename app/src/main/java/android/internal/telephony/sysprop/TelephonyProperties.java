package android.internal.telephony.sysprop;

import android.os.SystemProperties;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.StringJoiner;
import java.util.function.Function;

public final class TelephonyProperties {
    private TelephonyProperties() {
    }

    /* access modifiers changed from: private */
    public static Boolean tryParseBoolean(String str) {
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

    /* access modifiers changed from: private */
    public static Integer tryParseInteger(String str) {
        try {
            return Integer.valueOf(str);
        } catch (NumberFormatException unused) {
            return null;
        }
    }

    private static Integer tryParseUInt(String str) {
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

    /* access modifiers changed from: private */
    public static String tryParseString(String str) {
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

    public static Optional<Boolean> airplane_mode_on() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("persist.radio.airplane_mode_on")));
    }

    public static void airplane_mode_on(Boolean bool) {
        SystemProperties.set("persist.radio.airplane_mode_on", bool == null ? "" : bool.booleanValue() ? "1" : "0");
    }

    public static List<String> baseband_version() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda8(), SystemProperties.get("gsm.version.baseband"));
    }

    public static void baseband_version(List<String> list) {
        SystemProperties.set("gsm.version.baseband", list == null ? "" : formatList(list));
    }

    public static Optional<String> ril_impl() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("gsm.version.ril-impl")));
    }

    public static List<String> operator_alpha() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda0(), SystemProperties.get("gsm.operator.alpha"));
    }

    public static void operator_alpha(List<String> list) {
        SystemProperties.set("gsm.operator.alpha", list == null ? "" : formatList(list));
    }

    public static List<String> operator_numeric() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda9(), SystemProperties.get("gsm.operator.numeric"));
    }

    public static void operator_numeric(List<String> list) {
        SystemProperties.set("gsm.operator.numeric", list == null ? "" : formatList(list));
    }

    public static Optional<Boolean> operator_is_manual() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("operator.ismanual")));
    }

    public static List<Boolean> operator_is_roaming() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda3(), SystemProperties.get("gsm.operator.isroaming"));
    }

    public static void operator_is_roaming(List<Boolean> list) {
        SystemProperties.set("gsm.operator.isroaming", list == null ? "" : formatList(list));
    }

    public static List<String> operator_iso_country() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda4(), SystemProperties.get("gsm.operator.iso-country"));
    }

    public static void operator_iso_country(List<String> list) {
        SystemProperties.set("gsm.operator.iso-country", list == null ? "" : formatList(list));
    }

    public static Optional<String> lte_on_cdma_product_type() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("telephony.lteOnCdmaProductType")));
    }

    public static Optional<Integer> lte_on_cdma_device() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("telephony.lteOnCdmaDevice")));
    }

    public static List<Integer> current_active_phone() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda13(), SystemProperties.get("gsm.current.phone-type"));
    }

    public static void current_active_phone(List<Integer> list) {
        SystemProperties.set("gsm.current.phone-type", list == null ? "" : formatList(list));
    }

    public static List<String> sim_state() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda2(), SystemProperties.get("gsm.sim.state"));
    }

    public static void sim_state(List<String> list) {
        SystemProperties.set("gsm.sim.state", list == null ? "" : formatList(list));
    }

    public static List<String> icc_operator_numeric() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda5(), SystemProperties.get("gsm.sim.operator.numeric"));
    }

    public static void icc_operator_numeric(List<String> list) {
        SystemProperties.set("gsm.sim.operator.numeric", list == null ? "" : formatList(list));
    }

    public static List<String> icc_operator_alpha() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda7(), SystemProperties.get("gsm.sim.operator.alpha"));
    }

    public static void icc_operator_alpha(List<String> list) {
        SystemProperties.set("gsm.sim.operator.alpha", list == null ? "" : formatList(list));
    }

    public static List<String> icc_operator_iso_country() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda11(), SystemProperties.get("gsm.sim.operator.iso-country"));
    }

    public static void icc_operator_iso_country(List<String> list) {
        SystemProperties.set("gsm.sim.operator.iso-country", list == null ? "" : formatList(list));
    }

    public static List<String> data_network_type() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda12(), SystemProperties.get("gsm.network.type"));
    }

    public static void data_network_type(List<String> list) {
        SystemProperties.set("gsm.network.type", list == null ? "" : formatList(list));
    }

    public static Optional<Boolean> in_ecm_mode() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ril.cdma.inecmmode")));
    }

    public static void in_ecm_mode(Boolean bool) {
        SystemProperties.set("ril.cdma.inecmmode", bool == null ? "" : bool.toString());
    }

    public static Optional<Long> ecm_exit_timer() {
        return Optional.ofNullable(tryParseLong(SystemProperties.get("ro.cdma.ecmexittimer")));
    }

    public static Optional<String> operator_idp_string() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("gsm.operator.idpstring")));
    }

    public static void operator_idp_string(String str) {
        if (str == null) {
            str = "";
        }
        SystemProperties.set("gsm.operator.idpstring", str);
    }

    public static List<String> otasp_num_schema() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda1(), SystemProperties.get("ro.cdma.otaspnumschema"));
    }

    public static Optional<Boolean> disable_call() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.telephony.disable-call")));
    }

    public static Optional<Boolean> ril_sends_multiple_call_ring() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.telephony.call_ring.multiple")));
    }

    public static Optional<Integer> call_ring_delay() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("ro.telephony.call_ring.delay")));
    }

    public static Optional<Integer> cdma_msg_id() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("persist.radio.cdma.msgid")));
    }

    public static void cdma_msg_id(Integer num) {
        SystemProperties.set("persist.radio.cdma.msgid", num == null ? "" : num.toString());
    }

    public static Optional<Integer> wake_lock_timeout() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("ro.ril.wake_lock_timeout")));
    }

    public static Optional<Boolean> reset_on_radio_tech_change() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("persist.radio.reset_on_switch")));
    }

    public static List<Boolean> sms_receive() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda14(), SystemProperties.get("telephony.sms.receive"));
    }

    public static List<Boolean> sms_send() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda6(), SystemProperties.get("telephony.sms.send"));
    }

    public static Optional<Boolean> test_csim() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("persist.radio.test-csim")));
    }

    public static Optional<Boolean> ignore_nitz() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("telephony.test.ignore.nitz")));
    }

    public static Optional<String> multi_sim_config() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("persist.radio.multisim.config")));
    }

    public static void multi_sim_config(String str) {
        if (str == null) {
            str = "";
        }
        SystemProperties.set("persist.radio.multisim.config", str);
    }

    public static Optional<Boolean> reboot_on_modem_change() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("persist.radio.reboot_on_modem_change")));
    }

    public static Optional<Integer> videocall_audio_output() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("persist.radio.call.audio.output")));
    }

    public static Optional<Boolean> enable_esim_ui_by_default() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("esim.enable_esim_system_ui_by_default")));
    }

    public static List<Integer> default_network() {
        return tryParseList(new TelephonyProperties$$ExternalSyntheticLambda10(), SystemProperties.get("ro.telephony.default_network"));
    }

    public static Optional<Boolean> data_roaming() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.com.android.dataroaming")));
    }

    public static Optional<Boolean> mobile_data() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.com.android.mobiledata")));
    }

    public static Optional<Integer> wps_info() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("wifidirect.wps")));
    }

    public static Optional<Integer> max_active_modems() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("telephony.active_modems.max_count")));
    }

    public static Optional<Integer> sim_slots_count() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("ro.telephony.sim_slots.count")));
    }
}
