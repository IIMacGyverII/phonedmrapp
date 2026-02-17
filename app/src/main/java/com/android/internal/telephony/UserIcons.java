package com.android.internal.telephony;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;

public class UserIcons {
    private static final int[] USER_ICON_COLORS = {17171155, 17171156, 17171157, 17171158, 17171159, 17171160, 17171161, 17171162};

    public static Bitmap convertToBitmap(Drawable drawable) {
        return convertToBitmapAtSize(drawable, drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight());
    }

    public static Bitmap convertToBitmapAtUserIconSize(Resources resources, Drawable drawable) {
        int dimensionPixelSize = resources.getDimensionPixelSize(17105662);
        return convertToBitmapAtSize(drawable, dimensionPixelSize, dimensionPixelSize);
    }

    private static Bitmap convertToBitmapAtSize(Drawable drawable, int i, int i2) {
        if (drawable == null) {
            return null;
        }
        Bitmap createBitmap = Bitmap.createBitmap(i, i2, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(createBitmap);
        drawable.setBounds(0, 0, i, i2);
        drawable.draw(canvas);
        return createBitmap;
    }

    public static Drawable getDefaultUserIcon(Resources resources, int i, boolean z) {
        int i2 = z ? 17171164 : 17171163;
        if (i != -10000) {
            int[] iArr = USER_ICON_COLORS;
            i2 = iArr[i % iArr.length];
        }
        return getDefaultUserIconInColor(resources, resources.getColor(i2, (Resources.Theme) null));
    }

    public static Drawable getDefaultUserIconInColor(Resources resources, int i) {
        Drawable mutate = resources.getDrawable(17302313, (Resources.Theme) null).mutate();
        mutate.setColorFilter(i, PorterDuff.Mode.SRC_IN);
        mutate.setBounds(0, 0, mutate.getIntrinsicWidth(), mutate.getIntrinsicHeight());
        return mutate;
    }

    public static int[] getUserIconColors(Resources resources) {
        int length = USER_ICON_COLORS.length;
        int[] iArr = new int[length];
        for (int i = 0; i < length; i++) {
            iArr[i] = resources.getColor(USER_ICON_COLORS[i], (Resources.Theme) null);
        }
        return iArr;
    }
}
