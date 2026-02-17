package com.android.internal.telephony.cat;

import android.os.SystemProperties;
import android.text.TextUtils;
import com.android.internal.telephony.cat.AppInterface;
import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.TimeZone;

/* compiled from: ResponseData */
class DTTZResponseData extends ResponseData {
    private Calendar mCalendar;

    public DTTZResponseData(Calendar calendar) {
        this.mCalendar = calendar;
    }

    public void format(ByteArrayOutputStream byteArrayOutputStream) {
        if (byteArrayOutputStream != null) {
            byteArrayOutputStream.write(AppInterface.CommandType.PROVIDE_LOCAL_INFORMATION.value() | 128);
            byte[] bArr = new byte[8];
            bArr[0] = 7;
            if (this.mCalendar == null) {
                this.mCalendar = Calendar.getInstance();
            }
            bArr[1] = byteToBCD(this.mCalendar.get(1) % 100);
            bArr[2] = byteToBCD(this.mCalendar.get(2) + 1);
            bArr[3] = byteToBCD(this.mCalendar.get(5));
            bArr[4] = byteToBCD(this.mCalendar.get(11));
            bArr[5] = byteToBCD(this.mCalendar.get(12));
            bArr[6] = byteToBCD(this.mCalendar.get(13));
            String str = SystemProperties.get("persist.sys.timezone", "");
            if (TextUtils.isEmpty(str)) {
                bArr[7] = -1;
            } else {
                bArr[7] = getTZOffSetByte((long) TimeZone.getTimeZone(str).getOffset(this.mCalendar.getTimeInMillis()));
            }
            for (int i = 0; i < 8; i++) {
                byteArrayOutputStream.write(bArr[i]);
            }
        }
    }

    private byte byteToBCD(int i) {
        if (i >= 0 || i <= 99) {
            return (byte) ((i / 10) | ((i % 10) << 4));
        }
        CatLog.d((Object) this, "Err: byteToBCD conversion Value is " + i + " Value has to be between 0 and 99");
        return 0;
    }

    private byte getTZOffSetByte(long j) {
        int i = 1;
        boolean z = j < 0;
        long j2 = j / 900000;
        if (z) {
            i = -1;
        }
        byte byteToBCD = byteToBCD((int) (((long) i) * j2));
        return z ? (byte) (byteToBCD | 8) : byteToBCD;
    }
}
