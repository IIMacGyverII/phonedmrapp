package android.internal.telephony.sysprop;

import android.os.SystemProperties;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.StringJoiner;
import java.util.function.Function;

public final class VoldProperties {
    private VoldProperties() {
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

    public static Optional<String> decrypt() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("vold.decrypt")));
    }

    public static void decrypt(String str) {
        if (str == null) {
            str = "";
        }
        SystemProperties.set("vold.decrypt", str);
    }

    public static Optional<String> encrypt_progress() {
        return Optional.ofNullable(tryParseString(SystemProperties.get("vold.encrypt_progress")));
    }

    public static void encrypt_progress(String str) {
        if (str == null) {
            str = "";
        }
        SystemProperties.set("vold.encrypt_progress", str);
    }

    public static Optional<Integer> encrypt_time_remaining() {
        return Optional.ofNullable(tryParseInteger(SystemProperties.get("vold.encrypt_time_remaining")));
    }

    public static void encrypt_time_remaining(Integer num) {
        SystemProperties.set("vold.encrypt_time_remaining", num == null ? "" : num.toString());
    }
}
