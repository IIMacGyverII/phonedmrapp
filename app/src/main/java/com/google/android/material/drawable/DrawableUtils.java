package com.google.android.material.drawable;

import android.annotation.TargetApi;
import android.content.res.ColorStateList;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.RippleDrawable;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
public final class DrawableUtils {
    private DrawableUtils() {
    }

    @Nullable
    public static PorterDuffColorFilter updateTintFilter(@NonNull Drawable drawable, @Nullable ColorStateList colorStateList, @Nullable PorterDuff.Mode mode) {
        if (colorStateList == null || mode == null) {
            return null;
        }
        return new PorterDuffColorFilter(colorStateList.getColorForState(drawable.getState(), 0), mode);
    }

    /* JADX WARNING: Removed duplicated region for block: B:13:0x003f A[Catch:{ IOException | XmlPullParserException -> 0x0047 }] */
    /* JADX WARNING: Removed duplicated region for block: B:7:0x0014 A[Catch:{ IOException | XmlPullParserException -> 0x0047 }] */
    @androidx.annotation.NonNull
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static android.util.AttributeSet parseDrawableXml(@androidx.annotation.NonNull android.content.Context r3, @androidx.annotation.XmlRes int r4, @androidx.annotation.NonNull java.lang.CharSequence r5) {
        /*
            android.content.res.Resources r3 = r3.getResources()     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            android.content.res.XmlResourceParser r3 = r3.getXml(r4)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
        L_0x0008:
            int r0 = r3.next()     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            r1 = 2
            if (r0 == r1) goto L_0x0012
            r2 = 1
            if (r0 != r2) goto L_0x0008
        L_0x0012:
            if (r0 != r1) goto L_0x003f
            java.lang.String r0 = r3.getName()     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            boolean r0 = android.text.TextUtils.equals(r0, r5)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            if (r0 == 0) goto L_0x0023
            android.util.AttributeSet r3 = android.util.Xml.asAttributeSet(r3)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            return r3
        L_0x0023:
            org.xmlpull.v1.XmlPullParserException r3 = new org.xmlpull.v1.XmlPullParserException     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            r0.<init>()     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            java.lang.String r1 = "Must have a <"
            r0.append(r1)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            r0.append(r5)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            java.lang.String r5 = "> start tag"
            r0.append(r5)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            java.lang.String r5 = r0.toString()     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            r3.<init>(r5)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            throw r3     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
        L_0x003f:
            org.xmlpull.v1.XmlPullParserException r3 = new org.xmlpull.v1.XmlPullParserException     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            java.lang.String r5 = "No start tag found"
            r3.<init>(r5)     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
            throw r3     // Catch:{ IOException | XmlPullParserException -> 0x0047 }
        L_0x0047:
            r3 = move-exception
            android.content.res.Resources$NotFoundException r5 = new android.content.res.Resources$NotFoundException
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "Can't load badge resource ID #0x"
            r0.append(r1)
            java.lang.String r4 = java.lang.Integer.toHexString(r4)
            r0.append(r4)
            java.lang.String r4 = r0.toString()
            r5.<init>(r4)
            r5.initCause(r3)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.drawable.DrawableUtils.parseDrawableXml(android.content.Context, int, java.lang.CharSequence):android.util.AttributeSet");
    }

    @TargetApi(21)
    public static void setRippleDrawableRadius(@Nullable RippleDrawable rippleDrawable, int i) {
        rippleDrawable.setRadius(i);
    }
}
