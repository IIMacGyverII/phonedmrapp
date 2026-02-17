package androidx.core.content.pm;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.content.pm.SigningInfo;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.Size;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class PackageInfoCompat {
    public static long getLongVersionCode(@NonNull PackageInfo packageInfo) {
        return Api28Impl.getLongVersionCode(packageInfo);
    }

    @NonNull
    public static List<Signature> getSignatures(@NonNull PackageManager packageManager, @NonNull String str) throws PackageManager.NameNotFoundException {
        Signature[] signatureArr;
        SigningInfo signingInfo = packageManager.getPackageInfo(str, 134217728).signingInfo;
        if (Api28Impl.hasMultipleSigners(signingInfo)) {
            signatureArr = Api28Impl.getApkContentsSigners(signingInfo);
        } else {
            signatureArr = Api28Impl.getSigningCertificateHistory(signingInfo);
        }
        if (signatureArr == null) {
            return Collections.emptyList();
        }
        return Arrays.asList(signatureArr);
    }

    public static boolean hasSignatures(@NonNull PackageManager packageManager, @NonNull String str, @Size(min = 1) @NonNull Map<byte[], Integer> map, boolean z) throws PackageManager.NameNotFoundException {
        if (map.isEmpty()) {
            return false;
        }
        Set<byte[]> keySet = map.keySet();
        for (byte[] next : keySet) {
            if (next != null) {
                Integer num = map.get(next);
                if (num != null) {
                    int intValue = num.intValue();
                    if (intValue != 0 && intValue != 1) {
                        throw new IllegalArgumentException("Unsupported certificate type " + num + " when verifying " + str);
                    }
                } else {
                    throw new IllegalArgumentException("Type must be specified for cert when verifying " + str);
                }
            } else {
                throw new IllegalArgumentException("Cert byte array cannot be null when verifying " + str);
            }
        }
        List<Signature> signatures = getSignatures(packageManager, str);
        if (!z) {
            for (byte[] next2 : keySet) {
                if (!Api28Impl.hasSigningCertificate(packageManager, str, next2, map.get(next2).intValue())) {
                    return false;
                }
            }
            return true;
        }
        if (signatures.size() != 0 && map.size() <= signatures.size() && (!z || map.size() == signatures.size())) {
            byte[][] bArr = null;
            if (map.containsValue(1)) {
                bArr = new byte[signatures.size()][];
                for (int i = 0; i < signatures.size(); i++) {
                    bArr[i] = computeSHA256Digest(signatures.get(i).toByteArray());
                }
            }
            Iterator<byte[]> it = keySet.iterator();
            if (it.hasNext()) {
                byte[] next3 = it.next();
                Integer num2 = map.get(next3);
                int intValue2 = num2.intValue();
                if (intValue2 != 0) {
                    if (intValue2 != 1) {
                        throw new IllegalArgumentException("Unsupported certificate type " + num2);
                    } else if (!byteArrayContains(bArr, next3)) {
                        return false;
                    }
                } else if (!signatures.contains(new Signature(next3))) {
                    return false;
                }
                return true;
            }
        }
        return false;
    }

    private static boolean byteArrayContains(@NonNull byte[][] bArr, @NonNull byte[] bArr2) {
        for (byte[] equals : bArr) {
            if (Arrays.equals(bArr2, equals)) {
                return true;
            }
        }
        return false;
    }

    private static byte[] computeSHA256Digest(byte[] bArr) {
        try {
            return MessageDigest.getInstance("SHA256").digest(bArr);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Device doesn't support SHA256 cert checking", e);
        }
    }

    private PackageInfoCompat() {
    }

    @RequiresApi(28)
    private static class Api28Impl {
        private Api28Impl() {
        }

        @DoNotInline
        static boolean hasSigningCertificate(@NonNull PackageManager packageManager, @NonNull String str, @NonNull byte[] bArr, int i) {
            return packageManager.hasSigningCertificate(str, bArr, i);
        }

        @DoNotInline
        static boolean hasMultipleSigners(@NonNull SigningInfo signingInfo) {
            return signingInfo.hasMultipleSigners();
        }

        @DoNotInline
        @Nullable
        static Signature[] getApkContentsSigners(@NonNull SigningInfo signingInfo) {
            return signingInfo.getApkContentsSigners();
        }

        @DoNotInline
        @Nullable
        static Signature[] getSigningCertificateHistory(@NonNull SigningInfo signingInfo) {
            return signingInfo.getSigningCertificateHistory();
        }

        @DoNotInline
        static long getLongVersionCode(PackageInfo packageInfo) {
            return packageInfo.getLongVersionCode();
        }
    }
}
