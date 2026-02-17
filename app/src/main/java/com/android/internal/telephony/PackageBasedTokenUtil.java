package com.android.internal.telephony;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.Base64;
import android.util.Log;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

public class PackageBasedTokenUtil {
    private static final Charset CHARSET_UTF_8 = Charset.forName("UTF-8");
    private static final String HASH_TYPE = "SHA-256";
    static final int NUM_BASE64_CHARS = 11;
    private static final int NUM_HASHED_BYTES = 9;
    private static final String TAG = "PackageBasedTokenUtil";

    public static String generateToken(Context context, String str) {
        PackageManager packageManager = context.getPackageManager();
        String generatePackageBasedToken = generatePackageBasedToken(packageManager, str);
        for (PackageInfo packageInfo : packageManager.getInstalledPackages(128)) {
            String str2 = packageInfo.packageName;
            if (!str.equals(str2) && generatePackageBasedToken.equals(generatePackageBasedToken(packageManager, str2))) {
                Log.e(TAG, "token collides with other installed app.");
                generatePackageBasedToken = null;
            }
        }
        return generatePackageBasedToken;
    }

    private static String generatePackageBasedToken(PackageManager packageManager, String str) {
        try {
            Signature[] signatureArr = packageManager.getPackageInfo(str, 64).signatures;
            if (signatureArr == null) {
                Log.e(TAG, "The certificates is missing.");
                return null;
            }
            try {
                MessageDigest instance = MessageDigest.getInstance(HASH_TYPE);
                Charset charset = CHARSET_UTF_8;
                instance.update(str.getBytes(charset));
                instance.update(" ".getBytes(charset));
                for (Signature charsString : signatureArr) {
                    instance.update(charsString.toCharsString().getBytes(CHARSET_UTF_8));
                }
                return Base64.encodeToString(Arrays.copyOf(instance.digest(), 9), 3).substring(0, 11);
            } catch (NoSuchAlgorithmException e) {
                Log.e(TAG, "NoSuchAlgorithmException" + e);
                return null;
            }
        } catch (PackageManager.NameNotFoundException unused) {
            Log.e(TAG, "Failed to find package with package name: " + str);
            return null;
        }
    }
}
