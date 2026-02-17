package android.internal.telephony.sysprop;

import android.os.SystemProperties;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.StringJoiner;
import java.util.function.Function;

public final class HdmiProperties {
    private HdmiProperties() {
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

    @Deprecated
    public static List<Integer> device_type() {
        return tryParseList(new HdmiProperties$$ExternalSyntheticLambda0(), SystemProperties.get("ro.hdmi.device_type"));
    }

    public enum cec_device_types_values {
        TV("tv"),
        RECORDING_DEVICE("recording_device"),
        RESERVED("reserved"),
        TUNER("tuner"),
        PLAYBACK_DEVICE("playback_device"),
        AUDIO_SYSTEM("audio_system"),
        PURE_CEC_SWITCH("pure_cec_switch"),
        VIDEO_PROCESSOR("video_processor");
        
        private final String propValue;

        private cec_device_types_values(String str) {
            this.propValue = str;
        }

        public String getPropValue() {
            return this.propValue;
        }
    }

    public static List<cec_device_types_values> cec_device_types() {
        return tryParseEnumList(cec_device_types_values.class, SystemProperties.get("ro.hdmi.cec_device_types"));
    }

    public static Optional<String> arc_port() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("ro.hdmi.property_sytem_audio_device_arc_port")));
    }

    public static Optional<Boolean> forward_volume_keys_when_system_audio_mode_off() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.hdmi.cec_audio_device_forward_volume_keys_system_audio_mode_off")));
    }

    public static Optional<Boolean> is_switch() {
        return Optional.ofNullable(tryParseBoolean(SystemProperties.get("ro.hdmi.property_is_device_hdmi_cec_switch")));
    }

    public enum playback_device_action_on_routing_control_values {
        NONE("none"),
        WAKE_UP_ONLY("wake_up_only"),
        WAKE_UP_AND_SEND_ACTIVE_SOURCE("wake_up_and_send_active_source");
        
        private final String propValue;

        private playback_device_action_on_routing_control_values(String str) {
            this.propValue = str;
        }

        public String getPropValue() {
            return this.propValue;
        }
    }

    public static Optional<playback_device_action_on_routing_control_values> playback_device_action_on_routing_control() {
        return Optional.ofNullable((playback_device_action_on_routing_control_values) tryParseEnum(playback_device_action_on_routing_control_values.class, SystemProperties.get("ro.hdmi.cec.source.playback_device_action_on_routing_control")));
    }
}
