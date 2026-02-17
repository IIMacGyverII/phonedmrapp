package com.mediatek.location;

import android.content.Context;
import android.content.Intent;
import android.os.UserHandle;

public class BlueskyUtility {
    public static void sendBlueskyBroadcast(Context context) {
        Intent putExtra = new Intent("com.google.android.gms.phenotype.FLAG_OVERRIDE").putExtra("package", "com.google.android.location").putExtra("user", "*").putExtra("flags", "Bluesky__bluesky_enable_for_driving").putExtra("values", "true").putExtra("types", "boolean");
        putExtra.setPackage("com.google.android.gms");
        context.sendBroadcastAsUser(putExtra, new UserHandle(-2));
        Intent putExtra2 = new Intent("com.google.android.gms.phenotype.FLAG_OVERRIDE").putExtra("package", "com.google.android.location").putExtra("user", "*").putExtra("flags", "Bluesky__driving_max_speed_for_corrections_mps").putExtra("values", "60").putExtra("types", "long");
        putExtra2.setPackage("com.google.android.gms");
        context.sendBroadcastAsUser(putExtra2, new UserHandle(-2));
        Intent putExtra3 = new Intent("com.google.android.gms.phenotype.FLAG_OVERRIDE").putExtra("package", "com.google.android.location").putExtra("user", "*").putExtra("flags", "Bluesky__driving_ignore_chipset_driving_capability_bit").putExtra("values", "true").putExtra("types", "boolean");
        putExtra3.setPackage("com.google.android.gms");
        context.sendBroadcastAsUser(putExtra3, new UserHandle(-2));
    }
}
