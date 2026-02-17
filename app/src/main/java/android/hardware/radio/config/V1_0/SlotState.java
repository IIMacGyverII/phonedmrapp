package android.hardware.radio.config.V1_0;

import java.util.ArrayList;

public final class SlotState {
    public static final int ACTIVE = 1;
    public static final int INACTIVE = 0;

    public static final String toString(int i) {
        if (i == 0) {
            return "INACTIVE";
        }
        if (i == 1) {
            return "ACTIVE";
        }
        return "0x" + Integer.toHexString(i);
    }

    public static final String dumpBitfield(int i) {
        ArrayList arrayList = new ArrayList();
        arrayList.add("INACTIVE");
        int i2 = 1;
        if ((i & 1) == 1) {
            arrayList.add("ACTIVE");
        } else {
            i2 = 0;
        }
        if (i != i2) {
            arrayList.add("0x" + Integer.toHexString(i & (~i2)));
        }
        return String.join(" | ", arrayList);
    }
}
