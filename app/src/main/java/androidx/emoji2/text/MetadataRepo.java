package androidx.emoji2.text;

import android.content.res.AssetManager;
import android.graphics.Typeface;
import android.util.SparseArray;
import androidx.annotation.AnyThread;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.annotation.VisibleForTesting;
import androidx.core.os.TraceCompat;
import androidx.core.util.Preconditions;
import androidx.emoji2.text.flatbuffer.MetadataList;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;

@RequiresApi(19)
@AnyThread
public final class MetadataRepo {
    private static final int DEFAULT_ROOT_SIZE = 1024;
    private static final String S_TRACE_CREATE_REPO = "EmojiCompat.MetadataRepo.create";
    @NonNull
    private final char[] mEmojiCharArray;
    @NonNull
    private final MetadataList mMetadataList;
    @NonNull
    private final Node mRootNode = new Node(1024);
    @NonNull
    private final Typeface mTypeface;

    private MetadataRepo(@NonNull Typeface typeface, @NonNull MetadataList metadataList) {
        this.mTypeface = typeface;
        this.mMetadataList = metadataList;
        this.mEmojiCharArray = new char[(metadataList.listLength() * 2)];
        constructIndex(metadataList);
    }

    @NonNull
    @RestrictTo({RestrictTo.Scope.TESTS})
    public static MetadataRepo create(@NonNull Typeface typeface) {
        try {
            TraceCompat.beginSection(S_TRACE_CREATE_REPO);
            return new MetadataRepo(typeface, new MetadataList());
        } finally {
            TraceCompat.endSection();
        }
    }

    @NonNull
    public static MetadataRepo create(@NonNull Typeface typeface, @NonNull InputStream inputStream) throws IOException {
        try {
            TraceCompat.beginSection(S_TRACE_CREATE_REPO);
            return new MetadataRepo(typeface, MetadataListReader.read(inputStream));
        } finally {
            TraceCompat.endSection();
        }
    }

    @NonNull
    public static MetadataRepo create(@NonNull Typeface typeface, @NonNull ByteBuffer byteBuffer) throws IOException {
        try {
            TraceCompat.beginSection(S_TRACE_CREATE_REPO);
            return new MetadataRepo(typeface, MetadataListReader.read(byteBuffer));
        } finally {
            TraceCompat.endSection();
        }
    }

    @NonNull
    public static MetadataRepo create(@NonNull AssetManager assetManager, @NonNull String str) throws IOException {
        try {
            TraceCompat.beginSection(S_TRACE_CREATE_REPO);
            return new MetadataRepo(Typeface.createFromAsset(assetManager, str), MetadataListReader.read(assetManager, str));
        } finally {
            TraceCompat.endSection();
        }
    }

    private void constructIndex(MetadataList metadataList) {
        int listLength = metadataList.listLength();
        for (int i = 0; i < listLength; i++) {
            EmojiMetadata emojiMetadata = new EmojiMetadata(this, i);
            Character.toChars(emojiMetadata.getId(), this.mEmojiCharArray, i * 2);
            put(emojiMetadata);
        }
    }

    /* access modifiers changed from: package-private */
    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public Typeface getTypeface() {
        return this.mTypeface;
    }

    /* access modifiers changed from: package-private */
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public int getMetadataVersion() {
        return this.mMetadataList.version();
    }

    /* access modifiers changed from: package-private */
    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public Node getRootNode() {
        return this.mRootNode;
    }

    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public char[] getEmojiCharArray() {
        return this.mEmojiCharArray;
    }

    @NonNull
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public MetadataList getMetadataList() {
        return this.mMetadataList;
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public void put(@NonNull EmojiMetadata emojiMetadata) {
        Preconditions.checkNotNull(emojiMetadata, "emoji metadata cannot be null");
        Preconditions.checkArgument(emojiMetadata.getCodepointsLength() > 0, "invalid metadata codepoint length");
        this.mRootNode.put(emojiMetadata, 0, emojiMetadata.getCodepointsLength() - 1);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    static class Node {
        private final SparseArray<Node> mChildren;
        private EmojiMetadata mData;

        private Node() {
            this(1);
        }

        Node(int i) {
            this.mChildren = new SparseArray<>(i);
        }

        /* access modifiers changed from: package-private */
        public Node get(int i) {
            SparseArray<Node> sparseArray = this.mChildren;
            if (sparseArray == null) {
                return null;
            }
            return sparseArray.get(i);
        }

        /* access modifiers changed from: package-private */
        public final EmojiMetadata getData() {
            return this.mData;
        }

        /* access modifiers changed from: package-private */
        public void put(@NonNull EmojiMetadata emojiMetadata, int i, int i2) {
            Node node = get(emojiMetadata.getCodepointAt(i));
            if (node == null) {
                node = new Node();
                this.mChildren.put(emojiMetadata.getCodepointAt(i), node);
            }
            if (i2 > i) {
                node.put(emojiMetadata, i + 1, i2);
            } else {
                node.mData = emojiMetadata;
            }
        }
    }
}
