package android.hardware.radio.config.V1_1;

import android.os.HidlSupport;
import android.os.HwBlob;
import android.os.HwParcel;
import java.util.ArrayList;
import java.util.Objects;

public final class PhoneCapability {
    public boolean isInternetLingeringSupported = false;
    public ArrayList<ModemInfo> logicalModemList = new ArrayList<>();
    public byte maxActiveData = 0;
    public byte maxActiveInternetData = 0;

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || obj.getClass() != PhoneCapability.class) {
            return false;
        }
        PhoneCapability phoneCapability = (PhoneCapability) obj;
        return this.maxActiveData == phoneCapability.maxActiveData && this.maxActiveInternetData == phoneCapability.maxActiveInternetData && this.isInternetLingeringSupported == phoneCapability.isInternetLingeringSupported && HidlSupport.deepEquals(this.logicalModemList, phoneCapability.logicalModemList);
    }

    public final int hashCode() {
        return Objects.hash(new Object[]{Integer.valueOf(HidlSupport.deepHashCode(Byte.valueOf(this.maxActiveData))), Integer.valueOf(HidlSupport.deepHashCode(Byte.valueOf(this.maxActiveInternetData))), Integer.valueOf(HidlSupport.deepHashCode(Boolean.valueOf(this.isInternetLingeringSupported))), Integer.valueOf(HidlSupport.deepHashCode(this.logicalModemList))});
    }

    public final String toString() {
        return "{" + ".maxActiveData = " + this.maxActiveData + ", .maxActiveInternetData = " + this.maxActiveInternetData + ", .isInternetLingeringSupported = " + this.isInternetLingeringSupported + ", .logicalModemList = " + this.logicalModemList + "}";
    }

    public final void readFromParcel(HwParcel hwParcel) {
        readEmbeddedFromParcel(hwParcel, hwParcel.readBuffer(24), 0);
    }

    public static final ArrayList<PhoneCapability> readVectorFromParcel(HwParcel hwParcel) {
        ArrayList<PhoneCapability> arrayList = new ArrayList<>();
        HwBlob readBuffer = hwParcel.readBuffer(16);
        int int32 = readBuffer.getInt32(8);
        HwBlob readEmbeddedBuffer = hwParcel.readEmbeddedBuffer((long) (int32 * 24), readBuffer.handle(), 0, true);
        arrayList.clear();
        for (int i = 0; i < int32; i++) {
            PhoneCapability phoneCapability = new PhoneCapability();
            phoneCapability.readEmbeddedFromParcel(hwParcel, readEmbeddedBuffer, (long) (i * 24));
            arrayList.add(phoneCapability);
        }
        return arrayList;
    }

    public final void readEmbeddedFromParcel(HwParcel hwParcel, HwBlob hwBlob, long j) {
        HwBlob hwBlob2 = hwBlob;
        this.maxActiveData = hwBlob2.getInt8(j + 0);
        this.maxActiveInternetData = hwBlob2.getInt8(j + 1);
        this.isInternetLingeringSupported = hwBlob2.getBool(j + 2);
        long j2 = j + 8;
        int int32 = hwBlob2.getInt32(8 + j2);
        HwBlob readEmbeddedBuffer = hwParcel.readEmbeddedBuffer((long) (int32 * 1), hwBlob.handle(), j2 + 0, true);
        this.logicalModemList.clear();
        for (int i = 0; i < int32; i++) {
            ModemInfo modemInfo = new ModemInfo();
            modemInfo.readEmbeddedFromParcel(hwParcel, readEmbeddedBuffer, (long) (i * 1));
            this.logicalModemList.add(modemInfo);
        }
    }

    public final void writeToParcel(HwParcel hwParcel) {
        HwBlob hwBlob = new HwBlob(24);
        writeEmbeddedToBlob(hwBlob, 0);
        hwParcel.writeBuffer(hwBlob);
    }

    public static final void writeVectorToParcel(HwParcel hwParcel, ArrayList<PhoneCapability> arrayList) {
        HwBlob hwBlob = new HwBlob(16);
        int size = arrayList.size();
        hwBlob.putInt32(8, size);
        hwBlob.putBool(12, false);
        HwBlob hwBlob2 = new HwBlob(size * 24);
        for (int i = 0; i < size; i++) {
            arrayList.get(i).writeEmbeddedToBlob(hwBlob2, (long) (i * 24));
        }
        hwBlob.putBlob(0, hwBlob2);
        hwParcel.writeBuffer(hwBlob);
    }

    public final void writeEmbeddedToBlob(HwBlob hwBlob, long j) {
        hwBlob.putInt8(j + 0, this.maxActiveData);
        hwBlob.putInt8(1 + j, this.maxActiveInternetData);
        hwBlob.putBool(2 + j, this.isInternetLingeringSupported);
        int size = this.logicalModemList.size();
        long j2 = j + 8;
        hwBlob.putInt32(8 + j2, size);
        hwBlob.putBool(12 + j2, false);
        HwBlob hwBlob2 = new HwBlob(size * 1);
        for (int i = 0; i < size; i++) {
            this.logicalModemList.get(i).writeEmbeddedToBlob(hwBlob2, (long) (i * 1));
        }
        hwBlob.putBlob(j2 + 0, hwBlob2);
    }
}
