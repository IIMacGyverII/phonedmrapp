package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.cat.Duration;
import com.android.internal.telephony.uicc.IccUtils;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import kotlin.UByte;

public abstract class ValueParser {
    public static CommandDetails retrieveCommandDetails(ComprehensionTlv comprehensionTlv) throws ResultException {
        CommandDetails commandDetails = new CommandDetails();
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        try {
            commandDetails.compRequired = comprehensionTlv.isComprehensionRequired();
            commandDetails.commandNumber = rawValue[valueIndex] & UByte.MAX_VALUE;
            commandDetails.typeOfCommand = rawValue[valueIndex + 1] & UByte.MAX_VALUE;
            commandDetails.commandQualifier = rawValue[valueIndex + 2] & UByte.MAX_VALUE;
            return commandDetails;
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static DeviceIdentities retrieveDeviceIdentities(ComprehensionTlv comprehensionTlv) throws ResultException {
        DeviceIdentities deviceIdentities = new DeviceIdentities();
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        try {
            deviceIdentities.sourceId = rawValue[valueIndex] & UByte.MAX_VALUE;
            deviceIdentities.destinationId = rawValue[valueIndex + 1] & UByte.MAX_VALUE;
            return deviceIdentities;
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.REQUIRED_VALUES_MISSING);
        }
    }

    public static Duration retrieveDuration(ComprehensionTlv comprehensionTlv) throws ResultException {
        Duration.TimeUnit timeUnit = Duration.TimeUnit.SECOND;
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        try {
            return new Duration((int) rawValue[valueIndex + 1] & UByte.MAX_VALUE, Duration.TimeUnit.values()[rawValue[valueIndex] & UByte.MAX_VALUE]);
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    static Item retrieveItem(ComprehensionTlv comprehensionTlv) throws ResultException {
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        int length = comprehensionTlv.getLength();
        if (length == 0) {
            return null;
        }
        try {
            return new Item(rawValue[valueIndex] & UByte.MAX_VALUE, IccUtils.adnStringFieldToString(rawValue, valueIndex + 1, length - 1));
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    public static int retrieveItemId(ComprehensionTlv comprehensionTlv) throws ResultException {
        try {
            return comprehensionTlv.getRawValue()[comprehensionTlv.getValueIndex()] & UByte.MAX_VALUE;
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    public static IconId retrieveIconId(ComprehensionTlv comprehensionTlv) throws ResultException {
        IconId iconId = new IconId();
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        int i = valueIndex + 1;
        try {
            iconId.selfExplanatory = (rawValue[valueIndex] & UByte.MAX_VALUE) == 0;
            iconId.recordNumber = rawValue[i] & UByte.MAX_VALUE;
            return iconId;
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    public static ItemsIconId retrieveItemsIconId(ComprehensionTlv comprehensionTlv) throws ResultException {
        CatLog.d("ValueParser", "retrieveItemsIconId:");
        ItemsIconId itemsIconId = new ItemsIconId();
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        boolean z = true;
        int length = comprehensionTlv.getLength() - 1;
        itemsIconId.recordNumbers = new int[length];
        int i = valueIndex + 1;
        try {
            int i2 = 0;
            if (rawValue[valueIndex] != false && true) {
                z = false;
            }
            itemsIconId.selfExplanatory = z;
            while (i2 < length) {
                int i3 = i2 + 1;
                int i4 = i + 1;
                itemsIconId.recordNumbers[i2] = rawValue[i];
                i2 = i3;
                i = i4;
            }
            return itemsIconId;
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static List<TextAttribute> retrieveTextAttribute(ComprehensionTlv comprehensionTlv) throws ResultException {
        ArrayList arrayList = new ArrayList();
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        int length = comprehensionTlv.getLength();
        if (length == 0) {
            return null;
        }
        int i = length / 4;
        int i2 = 0;
        while (i2 < i) {
            try {
                byte b = rawValue[valueIndex] & UByte.MAX_VALUE;
                byte b2 = rawValue[valueIndex + 1] & UByte.MAX_VALUE;
                byte b3 = rawValue[valueIndex + 2] & UByte.MAX_VALUE;
                byte b4 = rawValue[valueIndex + 3] & UByte.MAX_VALUE;
                TextAlignment fromInt = TextAlignment.fromInt(b3 & 3);
                FontSize fromInt2 = FontSize.fromInt((b3 >> 2) & 3);
                if (fromInt2 == null) {
                    fromInt2 = FontSize.NORMAL;
                }
                TextAttribute textAttribute = r7;
                TextAttribute textAttribute2 = new TextAttribute(b, b2, fromInt, fromInt2, (b3 & 16) != 0, (b3 & 32) != 0, (b3 & 64) != 0, (b3 & 128) != 0, TextColor.fromInt(b4));
                arrayList.add(textAttribute);
                i2++;
                valueIndex += 4;
            } catch (IndexOutOfBoundsException unused) {
                throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
            }
        }
        return arrayList;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static String retrieveAlphaId(ComprehensionTlv comprehensionTlv, boolean z) throws ResultException {
        if (comprehensionTlv != null) {
            byte[] rawValue = comprehensionTlv.getRawValue();
            int valueIndex = comprehensionTlv.getValueIndex();
            int length = comprehensionTlv.getLength();
            if (length != 0) {
                try {
                    return IccUtils.adnStringFieldToString(rawValue, valueIndex, length);
                } catch (IndexOutOfBoundsException unused) {
                    throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
                }
            } else {
                CatLog.d("ValueParser", "Alpha Id length=" + length);
                return null;
            }
        } else if (z) {
            return null;
        } else {
            return CatService.STK_DEFAULT;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static String retrieveTextString(ComprehensionTlv comprehensionTlv) throws ResultException {
        byte[] rawValue = comprehensionTlv.getRawValue();
        int valueIndex = comprehensionTlv.getValueIndex();
        int length = comprehensionTlv.getLength();
        if (length == 0) {
            return null;
        }
        int i = length - 1;
        try {
            byte b = (byte) (rawValue[valueIndex] & 12);
            if (b == 0) {
                return GsmAlphabet.gsm7BitPackedToString(rawValue, valueIndex + 1, (i * 8) / 7);
            }
            if (b == 4) {
                return GsmAlphabet.gsm8BitUnpackedToString(rawValue, valueIndex + 1, i);
            }
            if (b == 8) {
                return new String(rawValue, valueIndex + 1, i, "UTF-16");
            }
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        } catch (IndexOutOfBoundsException unused) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        } catch (UnsupportedEncodingException unused2) {
            throw new ResultException(ResultCode.CMD_DATA_NOT_UNDERSTOOD);
        }
    }
}
