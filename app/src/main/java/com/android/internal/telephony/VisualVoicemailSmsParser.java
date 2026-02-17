package com.android.internal.telephony;

import android.os.Bundle;

public class VisualVoicemailSmsParser {
    private static final String[] ALLOWED_ALTERNATIVE_FORMAT_EVENT = {"MBOXUPDATE", "UNRECOGNIZED"};

    public static class WrappedMessageData {
        public final Bundle fields;
        public final String prefix;

        public String toString() {
            return "WrappedMessageData [type=" + this.prefix + " fields=" + this.fields + "]";
        }

        WrappedMessageData(String str, Bundle bundle) {
            this.prefix = str;
            this.fields = bundle;
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0015, code lost:
        r3 = r3 + 1;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static com.android.internal.telephony.VisualVoicemailSmsParser.WrappedMessageData parse(java.lang.String r3, java.lang.String r4) {
        /*
            r0 = 0
            boolean r1 = r4.startsWith(r3)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            if (r1 != 0) goto L_0x0008
            return r0
        L_0x0008:
            int r3 = r3.length()     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            char r1 = r4.charAt(r3)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            r2 = 58
            if (r1 == r2) goto L_0x0015
            return r0
        L_0x0015:
            java.lang.String r1 = ":"
            int r3 = r3 + 1
            int r1 = r4.indexOf(r1, r3)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            r2 = -1
            if (r1 != r2) goto L_0x0021
            return r0
        L_0x0021:
            java.lang.String r3 = r4.substring(r3, r1)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            int r1 = r1 + 1
            java.lang.String r4 = r4.substring(r1)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            android.os.Bundle r4 = parseSmsBody(r4)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            if (r4 != 0) goto L_0x0032
            return r0
        L_0x0032:
            com.android.internal.telephony.VisualVoicemailSmsParser$WrappedMessageData r1 = new com.android.internal.telephony.VisualVoicemailSmsParser$WrappedMessageData     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            r1.<init>(r3, r4)     // Catch:{ IndexOutOfBoundsException -> 0x0038 }
            return r1
        L_0x0038:
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.VisualVoicemailSmsParser.parse(java.lang.String, java.lang.String):com.android.internal.telephony.VisualVoicemailSmsParser$WrappedMessageData");
    }

    private static Bundle parseSmsBody(String str) {
        Bundle bundle = new Bundle();
        for (String str2 : str.split(";")) {
            if (str2.length() != 0) {
                int indexOf = str2.indexOf("=");
                if (indexOf == -1 || indexOf == 0) {
                    return null;
                }
                bundle.putString(str2.substring(0, indexOf), str2.substring(indexOf + 1));
            }
        }
        return bundle;
    }

    public static WrappedMessageData parseAlternativeFormat(String str) {
        Bundle parseSmsBody;
        try {
            int indexOf = str.indexOf("?");
            if (indexOf == -1) {
                return null;
            }
            String substring = str.substring(0, indexOf);
            if (isAllowedAlternativeFormatEvent(substring) && (parseSmsBody = parseSmsBody(str.substring(indexOf + 1))) != null) {
                return new WrappedMessageData(substring, parseSmsBody);
            }
            return null;
        } catch (IndexOutOfBoundsException unused) {
            return null;
        }
    }

    private static boolean isAllowedAlternativeFormatEvent(String str) {
        for (String equals : ALLOWED_ALTERNATIVE_FORMAT_EVENT) {
            if (equals.equals(str)) {
                return true;
            }
        }
        return false;
    }
}
