package android.hardware.radio.config.V1_2;

import android.os.HidlSupport;
import android.os.HwBlob;
import android.os.HwParcel;
import java.util.ArrayList;
import java.util.Objects;

public final class SimSlotStatus {
    public android.hardware.radio.config.V1_0.SimSlotStatus base = new android.hardware.radio.config.V1_0.SimSlotStatus();
    public String eid = new String();

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || obj.getClass() != SimSlotStatus.class) {
            return false;
        }
        SimSlotStatus simSlotStatus = (SimSlotStatus) obj;
        return HidlSupport.deepEquals(this.base, simSlotStatus.base) && HidlSupport.deepEquals(this.eid, simSlotStatus.eid);
    }

    public final int hashCode() {
        return Objects.hash(new Object[]{Integer.valueOf(HidlSupport.deepHashCode(this.base)), Integer.valueOf(HidlSupport.deepHashCode(this.eid))});
    }

    public final String toString() {
        return "{" + ".base = " + this.base + ", .eid = " + this.eid + "}";
    }

    public final void readFromParcel(HwParcel hwParcel) {
        readEmbeddedFromParcel(hwParcel, hwParcel.readBuffer(64), 0);
    }

    public static final ArrayList<SimSlotStatus> readVectorFromParcel(HwParcel hwParcel) {
        ArrayList<SimSlotStatus> arrayList = new ArrayList<>();
        HwBlob readBuffer = hwParcel.readBuffer(16);
        int int32 = readBuffer.getInt32(8);
        HwBlob readEmbeddedBuffer = hwParcel.readEmbeddedBuffer((long) (int32 * 64), readBuffer.handle(), 0, true);
        arrayList.clear();
        for (int i = 0; i < int32; i++) {
            SimSlotStatus simSlotStatus = new SimSlotStatus();
            simSlotStatus.readEmbeddedFromParcel(hwParcel, readEmbeddedBuffer, (long) (i * 64));
            arrayList.add(simSlotStatus);
        }
        return arrayList;
    }

    public final void readEmbeddedFromParcel(HwParcel hwParcel, HwBlob hwBlob, long j) {
        this.base.readEmbeddedFromParcel(hwParcel, hwBlob, j + 0);
        long j2 = j + 48;
        String string = hwBlob.getString(j2);
        this.eid = string;
        hwParcel.readEmbeddedBuffer((long) (string.getBytes().length + 1), hwBlob.handle(), j2 + 0, false);
    }

    public final void writeToParcel(HwParcel hwParcel) {
        HwBlob hwBlob = new HwBlob(64);
        writeEmbeddedToBlob(hwBlob, 0);
        hwParcel.writeBuffer(hwBlob);
    }

    public static final void writeVectorToParcel(HwParcel hwParcel, ArrayList<SimSlotStatus> arrayList) {
        HwBlob hwBlob = new HwBlob(16);
        int size = arrayList.size();
        hwBlob.putInt32(8, size);
        hwBlob.putBool(12, false);
        HwBlob hwBlob2 = new HwBlob(size * 64);
        for (int i = 0; i < size; i++) {
            arrayList.get(i).writeEmbeddedToBlob(hwBlob2, (long) (i * 64));
        }
        hwBlob.putBlob(0, hwBlob2);
        hwParcel.writeBuffer(hwBlob);
    }

    public final void writeEmbeddedToBlob(HwBlob hwBlob, long j) {
        this.base.writeEmbeddedToBlob(hwBlob, 0 + j);
        hwBlob.putString(j + 48, this.eid);
    }
}
