package com.android.internal.telephony;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.telecom.PhoneAccountHandle;
import android.telephony.PhoneNumberUtils;
import android.telephony.SmsMessage;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.telephony.VisualVoicemailSms;
import android.telephony.VisualVoicemailSmsFilterSettings;
import android.util.ArrayMap;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.VisualVoicemailSmsParser;
import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class VisualVoicemailSmsFilter {
    private static final PhoneAccountHandleConverter DEFAULT_PHONE_ACCOUNT_HANDLE_CONVERTER;
    /* access modifiers changed from: private */
    public static final ComponentName PSTN_CONNECTION_SERVICE_COMPONENT = new ComponentName(TELEPHONY_SERVICE_PACKAGE, "com.android.services.telephony.TelephonyConnectionService");
    private static final String TAG = "VvmSmsFilter";
    private static final String TELEPHONY_SERVICE_PACKAGE = "com.android.phone";
    private static Map<String, List<Pattern>> sPatterns;
    private static PhoneAccountHandleConverter sPhoneAccountHandleConverter;

    @VisibleForTesting
    public interface PhoneAccountHandleConverter {
        PhoneAccountHandle fromSubId(int i);
    }

    static {
        AnonymousClass1 r0 = new PhoneAccountHandleConverter() {
            public PhoneAccountHandle fromSubId(int i) {
                int phoneId;
                if (SubscriptionManager.isValidSubscriptionId(i) && (phoneId = SubscriptionManager.getPhoneId(i)) != -1) {
                    return new PhoneAccountHandle(VisualVoicemailSmsFilter.PSTN_CONNECTION_SERVICE_COMPONENT, Integer.toString(PhoneFactory.getPhone(phoneId).getSubId()));
                }
                return null;
            }
        };
        DEFAULT_PHONE_ACCOUNT_HANDLE_CONVERTER = r0;
        sPhoneAccountHandleConverter = r0;
    }

    private static class FullMessage {
        public SmsMessage firstMessage;
        public String fullMessageBody;

        private FullMessage() {
        }
    }

    public static boolean filter(Context context, byte[][] bArr, String str, int i, int i2) {
        VisualVoicemailSmsFilterSettings activeVisualVoicemailSmsFilterSettings = ((TelephonyManager) context.getSystemService("phone")).getActiveVisualVoicemailSmsFilterSettings(i2);
        if (activeVisualVoicemailSmsFilterSettings == null) {
            FullMessage fullMessage = getFullMessage(bArr, str);
            if (fullMessage == null || !messageBodyMatchesVvmPattern(context, i2, fullMessage.fullMessageBody)) {
                return false;
            }
            Log.e(TAG, "SMS matching VVM format received but the filter not been set yet");
            return true;
        }
        PhoneAccountHandle fromSubId = sPhoneAccountHandleConverter.fromSubId(i2);
        if (fromSubId == null) {
            Log.e(TAG, "Unable to convert subId " + i2 + " to PhoneAccountHandle");
            return false;
        }
        String str2 = activeVisualVoicemailSmsFilterSettings.clientPrefix;
        FullMessage fullMessage2 = getFullMessage(bArr, str);
        if (fullMessage2 == null) {
            Log.i(TAG, "Unparsable SMS received");
            String parseAsciiPduMessage = parseAsciiPduMessage(bArr);
            VisualVoicemailSmsParser.WrappedMessageData parseAlternativeFormat = VisualVoicemailSmsParser.parseAlternativeFormat(parseAsciiPduMessage);
            if (parseAlternativeFormat == null) {
                Log.i(TAG, "Attempt to parse ascii PDU");
                parseAlternativeFormat = VisualVoicemailSmsParser.parse(str2, parseAsciiPduMessage);
            }
            if (parseAlternativeFormat != null) {
                sendVvmSmsBroadcast(context, activeVisualVoicemailSmsFilterSettings, fromSubId, parseAlternativeFormat, (String) null);
            }
            return false;
        }
        String str3 = fullMessage2.fullMessageBody;
        VisualVoicemailSmsParser.WrappedMessageData parse = VisualVoicemailSmsParser.parse(str2, str3);
        if (parse != null) {
            int i3 = activeVisualVoicemailSmsFilterSettings.destinationPort;
            if (i3 == -2) {
                if (i == -1) {
                    Log.i(TAG, "SMS matching VVM format received but is not a DATA SMS");
                    return false;
                }
            } else if (!(i3 == -1 || i3 == i)) {
                Log.i(TAG, "SMS matching VVM format received but is not directed to port " + activeVisualVoicemailSmsFilterSettings.destinationPort);
                return false;
            }
            if (activeVisualVoicemailSmsFilterSettings.originatingNumbers.isEmpty() || isSmsFromNumbers(fullMessage2.firstMessage, activeVisualVoicemailSmsFilterSettings.originatingNumbers)) {
                sendVvmSmsBroadcast(context, activeVisualVoicemailSmsFilterSettings, fromSubId, parse, (String) null);
                return true;
            }
            Log.i(TAG, "SMS matching VVM format received but is not from originating numbers");
            return false;
        } else if (!messageBodyMatchesVvmPattern(context, i2, str3)) {
            return false;
        } else {
            Log.w(TAG, "SMS matches pattern but has illegal format, still dropping as VVM SMS");
            sendVvmSmsBroadcast(context, activeVisualVoicemailSmsFilterSettings, fromSubId, (VisualVoicemailSmsParser.WrappedMessageData) null, str3);
            return true;
        }
    }

    private static boolean messageBodyMatchesVvmPattern(Context context, int i, String str) {
        buildPatternsMap(context);
        List<Pattern> list = sPatterns.get(((TelephonyManager) context.getSystemService(TelephonyManager.class)).getSimOperator(i));
        if (list != null && !list.isEmpty()) {
            for (Pattern pattern : list) {
                if (pattern.matcher(str).matches()) {
                    Log.w(TAG, "Incoming SMS matches pattern " + pattern);
                    return true;
                }
            }
        }
        return false;
    }

    @VisibleForTesting
    public static void setPhoneAccountHandleConverterForTest(PhoneAccountHandleConverter phoneAccountHandleConverter) {
        if (phoneAccountHandleConverter == null) {
            sPhoneAccountHandleConverter = DEFAULT_PHONE_ACCOUNT_HANDLE_CONVERTER;
        } else {
            sPhoneAccountHandleConverter = phoneAccountHandleConverter;
        }
    }

    private static void buildPatternsMap(Context context) {
        if (sPatterns == null) {
            sPatterns = new ArrayMap();
            for (String str : context.getResources().getStringArray(17236163)) {
                String[] split = str.split(";")[0].split(",");
                Pattern compile = Pattern.compile(str.split(";")[1]);
                for (String str2 : split) {
                    if (!sPatterns.containsKey(str2)) {
                        sPatterns.put(str2, new ArrayList());
                    }
                    sPatterns.get(str2).add(compile);
                }
            }
        }
    }

    private static void sendVvmSmsBroadcast(Context context, VisualVoicemailSmsFilterSettings visualVoicemailSmsFilterSettings, PhoneAccountHandle phoneAccountHandle, VisualVoicemailSmsParser.WrappedMessageData wrappedMessageData, String str) {
        Log.i(TAG, "VVM SMS received");
        Intent intent = new Intent("com.android.internal.provider.action.VOICEMAIL_SMS_RECEIVED");
        VisualVoicemailSms.Builder builder = new VisualVoicemailSms.Builder();
        if (wrappedMessageData != null) {
            builder.setPrefix(wrappedMessageData.prefix);
            builder.setFields(wrappedMessageData.fields);
        }
        if (str != null) {
            builder.setMessageBody(str);
        }
        builder.setPhoneAccountHandle(phoneAccountHandle);
        intent.putExtra("android.provider.extra.VOICEMAIL_SMS", builder.build());
        intent.putExtra("android.provider.extra.TARGET_PACAKGE", visualVoicemailSmsFilterSettings.packageName);
        intent.setPackage(TELEPHONY_SERVICE_PACKAGE);
        context.sendBroadcast(intent);
    }

    private static FullMessage getFullMessage(byte[][] bArr, String str) {
        FullMessage fullMessage = new FullMessage();
        StringBuilder sb = new StringBuilder();
        CharsetDecoder newDecoder = StandardCharsets.UTF_8.newDecoder();
        for (byte[] createFromPdu : bArr) {
            SmsMessage createFromPdu2 = SmsMessage.createFromPdu(createFromPdu, str);
            if (createFromPdu2 == null) {
                return null;
            }
            if (fullMessage.firstMessage == null) {
                fullMessage.firstMessage = createFromPdu2;
            }
            String messageBody = createFromPdu2.getMessageBody();
            if (messageBody == null && createFromPdu2.getUserData() != null) {
                try {
                    messageBody = newDecoder.decode(ByteBuffer.wrap(createFromPdu2.getUserData())).toString();
                } catch (CharacterCodingException unused) {
                    return null;
                }
            }
            if (messageBody != null) {
                sb.append(messageBody);
            }
        }
        fullMessage.fullMessageBody = sb.toString();
        return fullMessage;
    }

    private static String parseAsciiPduMessage(byte[][] bArr) {
        StringBuilder sb = new StringBuilder();
        for (byte[] str : bArr) {
            sb.append(new String(str, StandardCharsets.US_ASCII));
        }
        return sb.toString();
    }

    private static boolean isSmsFromNumbers(SmsMessage smsMessage, List<String> list) {
        if (smsMessage == null) {
            Log.e(TAG, "Unable to create SmsMessage from PDU, cannot determine originating number");
            return false;
        }
        for (String compare : list) {
            if (PhoneNumberUtils.compare(compare, smsMessage.getOriginatingAddress())) {
                return true;
            }
        }
        return false;
    }
}
