package androidx.core.provider;

import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.provider.DocumentsContract;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.io.FileNotFoundException;

public final class DocumentsContractCompat {
    private static final String PATH_TREE = "tree";

    public static final class DocumentCompat {
        public static final int FLAG_VIRTUAL_DOCUMENT = 512;

        private DocumentCompat() {
        }
    }

    public static boolean isDocumentUri(@NonNull Context context, @Nullable Uri uri) {
        return DocumentsContractApi19Impl.isDocumentUri(context, uri);
    }

    public static boolean isTreeUri(@NonNull Uri uri) {
        return DocumentsContractApi24Impl.isTreeUri(uri);
    }

    @Nullable
    public static String getDocumentId(@NonNull Uri uri) {
        return DocumentsContractApi19Impl.getDocumentId(uri);
    }

    @Nullable
    public static String getTreeDocumentId(@NonNull Uri uri) {
        return DocumentsContractApi21Impl.getTreeDocumentId(uri);
    }

    @Nullable
    public static Uri buildDocumentUri(@NonNull String str, @NonNull String str2) {
        return DocumentsContractApi19Impl.buildDocumentUri(str, str2);
    }

    @Nullable
    public static Uri buildDocumentUriUsingTree(@NonNull Uri uri, @NonNull String str) {
        return DocumentsContractApi21Impl.buildDocumentUriUsingTree(uri, str);
    }

    @Nullable
    public static Uri buildTreeDocumentUri(@NonNull String str, @NonNull String str2) {
        return DocumentsContractApi21Impl.buildTreeDocumentUri(str, str2);
    }

    @Nullable
    public static Uri buildChildDocumentsUri(@NonNull String str, @Nullable String str2) {
        return DocumentsContractApi21Impl.buildChildDocumentsUri(str, str2);
    }

    @Nullable
    public static Uri buildChildDocumentsUriUsingTree(@NonNull Uri uri, @NonNull String str) {
        return DocumentsContractApi21Impl.buildChildDocumentsUriUsingTree(uri, str);
    }

    @Nullable
    public static Uri createDocument(@NonNull ContentResolver contentResolver, @NonNull Uri uri, @NonNull String str, @NonNull String str2) throws FileNotFoundException {
        return DocumentsContractApi21Impl.createDocument(contentResolver, uri, str, str2);
    }

    @Nullable
    public static Uri renameDocument(@NonNull ContentResolver contentResolver, @NonNull Uri uri, @NonNull String str) throws FileNotFoundException {
        return DocumentsContractApi21Impl.renameDocument(contentResolver, uri, str);
    }

    public static boolean removeDocument(@NonNull ContentResolver contentResolver, @NonNull Uri uri, @NonNull Uri uri2) throws FileNotFoundException {
        return DocumentsContractApi24Impl.removeDocument(contentResolver, uri, uri2);
    }

    @RequiresApi(19)
    private static class DocumentsContractApi19Impl {
        @DoNotInline
        public static Uri buildDocumentUri(String str, String str2) {
            return DocumentsContract.buildDocumentUri(str, str2);
        }

        @DoNotInline
        static boolean isDocumentUri(Context context, @Nullable Uri uri) {
            return DocumentsContract.isDocumentUri(context, uri);
        }

        @DoNotInline
        static String getDocumentId(Uri uri) {
            return DocumentsContract.getDocumentId(uri);
        }

        @DoNotInline
        static boolean deleteDocument(ContentResolver contentResolver, Uri uri) throws FileNotFoundException {
            return DocumentsContract.deleteDocument(contentResolver, uri);
        }

        private DocumentsContractApi19Impl() {
        }
    }

    @RequiresApi(21)
    private static class DocumentsContractApi21Impl {
        @DoNotInline
        static String getTreeDocumentId(Uri uri) {
            return DocumentsContract.getTreeDocumentId(uri);
        }

        @DoNotInline
        public static Uri buildTreeDocumentUri(String str, String str2) {
            return DocumentsContract.buildTreeDocumentUri(str, str2);
        }

        @DoNotInline
        static Uri buildDocumentUriUsingTree(Uri uri, String str) {
            return DocumentsContract.buildDocumentUriUsingTree(uri, str);
        }

        @DoNotInline
        static Uri buildChildDocumentsUri(String str, String str2) {
            return DocumentsContract.buildChildDocumentsUri(str, str2);
        }

        @DoNotInline
        static Uri buildChildDocumentsUriUsingTree(Uri uri, String str) {
            return DocumentsContract.buildChildDocumentsUriUsingTree(uri, str);
        }

        @DoNotInline
        static Uri createDocument(ContentResolver contentResolver, Uri uri, String str, String str2) throws FileNotFoundException {
            return DocumentsContract.createDocument(contentResolver, uri, str, str2);
        }

        @DoNotInline
        static Uri renameDocument(@NonNull ContentResolver contentResolver, @NonNull Uri uri, @NonNull String str) throws FileNotFoundException {
            return DocumentsContract.renameDocument(contentResolver, uri, str);
        }

        private DocumentsContractApi21Impl() {
        }
    }

    @RequiresApi(24)
    private static class DocumentsContractApi24Impl {
        @DoNotInline
        static boolean isTreeUri(@NonNull Uri uri) {
            return DocumentsContract.isTreeUri(uri);
        }

        @DoNotInline
        static boolean removeDocument(ContentResolver contentResolver, Uri uri, Uri uri2) throws FileNotFoundException {
            return DocumentsContract.removeDocument(contentResolver, uri, uri2);
        }

        private DocumentsContractApi24Impl() {
        }
    }

    private DocumentsContractCompat() {
    }
}
