package androidx.emoji2.text;

import android.content.Context;
import android.content.pm.PackageManager;
import android.database.ContentObserver;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.CancellationSignal;
import android.os.Handler;
import android.os.SystemClock;
import androidx.annotation.GuardedBy;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.annotation.WorkerThread;
import androidx.core.provider.FontRequest;
import androidx.core.provider.FontsContractCompat;
import androidx.core.util.Preconditions;
import androidx.emoji2.text.EmojiCompat;
import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

public class FontRequestEmojiCompatConfig extends EmojiCompat.Config {
    private static final FontProviderHelper DEFAULT_FONTS_CONTRACT = new FontProviderHelper();

    public static abstract class RetryPolicy {
        public abstract long getRetryDelay();
    }

    public static class ExponentialBackoffRetryPolicy extends RetryPolicy {
        private long mRetryOrigin;
        private final long mTotalMs;

        public ExponentialBackoffRetryPolicy(long j) {
            this.mTotalMs = j;
        }

        public long getRetryDelay() {
            if (this.mRetryOrigin == 0) {
                this.mRetryOrigin = SystemClock.uptimeMillis();
                return 0;
            }
            long uptimeMillis = SystemClock.uptimeMillis() - this.mRetryOrigin;
            if (uptimeMillis > this.mTotalMs) {
                return -1;
            }
            return Math.min(Math.max(uptimeMillis, 1000), this.mTotalMs - uptimeMillis);
        }
    }

    public FontRequestEmojiCompatConfig(@NonNull Context context, @NonNull FontRequest fontRequest) {
        super(new FontRequestMetadataLoader(context, fontRequest, DEFAULT_FONTS_CONTRACT));
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public FontRequestEmojiCompatConfig(@NonNull Context context, @NonNull FontRequest fontRequest, @NonNull FontProviderHelper fontProviderHelper) {
        super(new FontRequestMetadataLoader(context, fontRequest, fontProviderHelper));
    }

    @NonNull
    public FontRequestEmojiCompatConfig setLoadingExecutor(@NonNull Executor executor) {
        ((FontRequestMetadataLoader) getMetadataRepoLoader()).setExecutor(executor);
        return this;
    }

    @NonNull
    @Deprecated
    public FontRequestEmojiCompatConfig setHandler(@Nullable Handler handler) {
        if (handler == null) {
            return this;
        }
        setLoadingExecutor(ConcurrencyHelpers.convertHandlerToExecutor(handler));
        return this;
    }

    @NonNull
    public FontRequestEmojiCompatConfig setRetryPolicy(@Nullable RetryPolicy retryPolicy) {
        ((FontRequestMetadataLoader) getMetadataRepoLoader()).setRetryPolicy(retryPolicy);
        return this;
    }

    private static class FontRequestMetadataLoader implements EmojiCompat.MetadataRepoLoader {
        private static final String S_TRACE_BUILD_TYPEFACE = "EmojiCompat.FontRequestEmojiCompatConfig.buildTypeface";
        @GuardedBy("mLock")
        @Nullable
        EmojiCompat.MetadataRepoLoaderCallback mCallback;
        @NonNull
        private final Context mContext;
        @GuardedBy("mLock")
        @Nullable
        private Executor mExecutor;
        @NonNull
        private final FontProviderHelper mFontProviderHelper;
        @NonNull
        private final Object mLock = new Object();
        @GuardedBy("mLock")
        @Nullable
        private Handler mMainHandler;
        @GuardedBy("mLock")
        @Nullable
        private Runnable mMainHandlerLoadCallback;
        @GuardedBy("mLock")
        @Nullable
        private ThreadPoolExecutor mMyThreadPoolExecutor;
        @GuardedBy("mLock")
        @Nullable
        private ContentObserver mObserver;
        @NonNull
        private final FontRequest mRequest;
        @GuardedBy("mLock")
        @Nullable
        private RetryPolicy mRetryPolicy;

        FontRequestMetadataLoader(@NonNull Context context, @NonNull FontRequest fontRequest, @NonNull FontProviderHelper fontProviderHelper) {
            Preconditions.checkNotNull(context, "Context cannot be null");
            Preconditions.checkNotNull(fontRequest, "FontRequest cannot be null");
            this.mContext = context.getApplicationContext();
            this.mRequest = fontRequest;
            this.mFontProviderHelper = fontProviderHelper;
        }

        public void setExecutor(@NonNull Executor executor) {
            synchronized (this.mLock) {
                this.mExecutor = executor;
            }
        }

        public void setRetryPolicy(@Nullable RetryPolicy retryPolicy) {
            synchronized (this.mLock) {
                this.mRetryPolicy = retryPolicy;
            }
        }

        @RequiresApi(19)
        public void load(@NonNull EmojiCompat.MetadataRepoLoaderCallback metadataRepoLoaderCallback) {
            Preconditions.checkNotNull(metadataRepoLoaderCallback, "LoaderCallback cannot be null");
            synchronized (this.mLock) {
                this.mCallback = metadataRepoLoaderCallback;
            }
            loadInternal();
        }

        /* access modifiers changed from: package-private */
        @RequiresApi(19)
        public void loadInternal() {
            synchronized (this.mLock) {
                if (this.mCallback != null) {
                    if (this.mExecutor == null) {
                        ThreadPoolExecutor createBackgroundPriorityExecutor = ConcurrencyHelpers.createBackgroundPriorityExecutor("emojiCompat");
                        this.mMyThreadPoolExecutor = createBackgroundPriorityExecutor;
                        this.mExecutor = createBackgroundPriorityExecutor;
                    }
                    this.mExecutor.execute(new FontRequestEmojiCompatConfig$FontRequestMetadataLoader$$ExternalSyntheticLambda0(this));
                }
            }
        }

        @WorkerThread
        private FontsContractCompat.FontInfo retrieveFontInfo() {
            try {
                FontsContractCompat.FontFamilyResult fetchFonts = this.mFontProviderHelper.fetchFonts(this.mContext, this.mRequest);
                if (fetchFonts.getStatusCode() == 0) {
                    FontsContractCompat.FontInfo[] fonts = fetchFonts.getFonts();
                    if (fonts != null && fonts.length != 0) {
                        return fonts[0];
                    }
                    throw new RuntimeException("fetchFonts failed (empty result)");
                }
                throw new RuntimeException("fetchFonts failed (" + fetchFonts.getStatusCode() + ")");
            } catch (PackageManager.NameNotFoundException e) {
                throw new RuntimeException("provider not found", e);
            }
        }

        @RequiresApi(19)
        @WorkerThread
        private void scheduleRetry(Uri uri, long j) {
            synchronized (this.mLock) {
                Handler handler = this.mMainHandler;
                if (handler == null) {
                    handler = ConcurrencyHelpers.mainHandlerAsync();
                    this.mMainHandler = handler;
                }
                if (this.mObserver == null) {
                    AnonymousClass1 r2 = new ContentObserver(handler) {
                        public void onChange(boolean z, Uri uri) {
                            FontRequestMetadataLoader.this.loadInternal();
                        }
                    };
                    this.mObserver = r2;
                    this.mFontProviderHelper.registerObserver(this.mContext, uri, r2);
                }
                if (this.mMainHandlerLoadCallback == null) {
                    this.mMainHandlerLoadCallback = new FontRequestEmojiCompatConfig$FontRequestMetadataLoader$$ExternalSyntheticLambda1(this);
                }
                handler.postDelayed(this.mMainHandlerLoadCallback, j);
            }
        }

        private void cleanUp() {
            synchronized (this.mLock) {
                this.mCallback = null;
                ContentObserver contentObserver = this.mObserver;
                if (contentObserver != null) {
                    this.mFontProviderHelper.unregisterObserver(this.mContext, contentObserver);
                    this.mObserver = null;
                }
                Handler handler = this.mMainHandler;
                if (handler != null) {
                    handler.removeCallbacks(this.mMainHandlerLoadCallback);
                }
                this.mMainHandler = null;
                ThreadPoolExecutor threadPoolExecutor = this.mMyThreadPoolExecutor;
                if (threadPoolExecutor != null) {
                    threadPoolExecutor.shutdown();
                }
                this.mExecutor = null;
                this.mMyThreadPoolExecutor = null;
            }
        }

        /* access modifiers changed from: package-private */
        /* JADX WARNING: Code restructure failed: missing block: B:10:0x0013, code lost:
            if (r1 != 2) goto L_0x0034;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:11:0x0015, code lost:
            r2 = r7.mLock;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:12:0x0017, code lost:
            monitor-enter(r2);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:14:?, code lost:
            r3 = r7.mRetryPolicy;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:15:0x001a, code lost:
            if (r3 == null) goto L_0x002f;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:16:0x001c, code lost:
            r3 = r3.getRetryDelay();
         */
        /* JADX WARNING: Code restructure failed: missing block: B:17:0x0024, code lost:
            if (r3 < 0) goto L_0x002f;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:18:0x0026, code lost:
            scheduleRetry(r0.getUri(), r3);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:19:0x002d, code lost:
            monitor-exit(r2);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:20:0x002e, code lost:
            return;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:21:0x002f, code lost:
            monitor-exit(r2);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:27:0x0034, code lost:
            if (r1 != 0) goto L_0x0078;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:30:?, code lost:
            androidx.core.os.TraceCompat.beginSection(S_TRACE_BUILD_TYPEFACE);
            r1 = r7.mFontProviderHelper.buildTypeface(r7.mContext, r0);
            r0 = androidx.core.graphics.TypefaceCompatUtil.mmap(r7.mContext, (android.os.CancellationSignal) null, r0.getUri());
         */
        /* JADX WARNING: Code restructure failed: missing block: B:31:0x004e, code lost:
            if (r0 == null) goto L_0x006b;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:32:0x0050, code lost:
            if (r1 == null) goto L_0x006b;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:33:0x0052, code lost:
            r0 = androidx.emoji2.text.MetadataRepo.create(r1, r0);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:35:?, code lost:
            androidx.core.os.TraceCompat.endSection();
            r1 = r7.mLock;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:36:0x005b, code lost:
            monitor-enter(r1);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:38:?, code lost:
            r2 = r7.mCallback;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:39:0x005e, code lost:
            if (r2 == null) goto L_0x0063;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:40:0x0060, code lost:
            r2.onLoaded(r0);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:41:0x0063, code lost:
            monitor-exit(r1);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:43:?, code lost:
            cleanUp();
         */
        /* JADX WARNING: Code restructure failed: missing block: B:51:0x0072, code lost:
            throw new java.lang.RuntimeException("Unable to open file.");
         */
        /* JADX WARNING: Code restructure failed: missing block: B:52:0x0073, code lost:
            r0 = move-exception;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:54:?, code lost:
            androidx.core.os.TraceCompat.endSection();
         */
        /* JADX WARNING: Code restructure failed: missing block: B:55:0x0077, code lost:
            throw r0;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:57:0x0093, code lost:
            throw new java.lang.RuntimeException("fetchFonts result is not OK. (" + r1 + ")");
         */
        /* JADX WARNING: Code restructure failed: missing block: B:58:0x0094, code lost:
            r0 = move-exception;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:60:0x0097, code lost:
            monitor-enter(r7.mLock);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:62:?, code lost:
            r2 = r7.mCallback;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:63:0x009a, code lost:
            if (r2 != null) goto L_0x009c;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:64:0x009c, code lost:
            r2.onFailed(r0);
         */
        /* JADX WARNING: Code restructure failed: missing block: B:66:0x00a0, code lost:
            cleanUp();
         */
        /* JADX WARNING: Code restructure failed: missing block: B:83:?, code lost:
            return;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:84:?, code lost:
            return;
         */
        /* JADX WARNING: Code restructure failed: missing block: B:9:?, code lost:
            r0 = retrieveFontInfo();
            r1 = r0.getResultCode();
         */
        @androidx.annotation.RequiresApi(19)
        @androidx.annotation.WorkerThread
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void createMetadata() {
            /*
                r7 = this;
                java.lang.Object r0 = r7.mLock
                monitor-enter(r0)
                androidx.emoji2.text.EmojiCompat$MetadataRepoLoaderCallback r1 = r7.mCallback     // Catch:{ all -> 0x00a7 }
                if (r1 != 0) goto L_0x0009
                monitor-exit(r0)     // Catch:{ all -> 0x00a7 }
                return
            L_0x0009:
                monitor-exit(r0)     // Catch:{ all -> 0x00a7 }
                androidx.core.provider.FontsContractCompat$FontInfo r0 = r7.retrieveFontInfo()     // Catch:{ all -> 0x0094 }
                int r1 = r0.getResultCode()     // Catch:{ all -> 0x0094 }
                r2 = 2
                if (r1 != r2) goto L_0x0034
                java.lang.Object r2 = r7.mLock     // Catch:{ all -> 0x0094 }
                monitor-enter(r2)     // Catch:{ all -> 0x0094 }
                androidx.emoji2.text.FontRequestEmojiCompatConfig$RetryPolicy r3 = r7.mRetryPolicy     // Catch:{ all -> 0x0031 }
                if (r3 == 0) goto L_0x002f
                long r3 = r3.getRetryDelay()     // Catch:{ all -> 0x0031 }
                r5 = 0
                int r5 = (r3 > r5 ? 1 : (r3 == r5 ? 0 : -1))
                if (r5 < 0) goto L_0x002f
                android.net.Uri r0 = r0.getUri()     // Catch:{ all -> 0x0031 }
                r7.scheduleRetry(r0, r3)     // Catch:{ all -> 0x0031 }
                monitor-exit(r2)     // Catch:{ all -> 0x0031 }
                return
            L_0x002f:
                monitor-exit(r2)     // Catch:{ all -> 0x0031 }
                goto L_0x0034
            L_0x0031:
                r0 = move-exception
                monitor-exit(r2)     // Catch:{ all -> 0x0031 }
                throw r0     // Catch:{ all -> 0x0094 }
            L_0x0034:
                if (r1 != 0) goto L_0x0078
                java.lang.String r1 = "EmojiCompat.FontRequestEmojiCompatConfig.buildTypeface"
                androidx.core.os.TraceCompat.beginSection(r1)     // Catch:{ all -> 0x0073 }
                androidx.emoji2.text.FontRequestEmojiCompatConfig$FontProviderHelper r1 = r7.mFontProviderHelper     // Catch:{ all -> 0x0073 }
                android.content.Context r2 = r7.mContext     // Catch:{ all -> 0x0073 }
                android.graphics.Typeface r1 = r1.buildTypeface(r2, r0)     // Catch:{ all -> 0x0073 }
                android.content.Context r2 = r7.mContext     // Catch:{ all -> 0x0073 }
                r3 = 0
                android.net.Uri r0 = r0.getUri()     // Catch:{ all -> 0x0073 }
                java.nio.ByteBuffer r0 = androidx.core.graphics.TypefaceCompatUtil.mmap(r2, r3, r0)     // Catch:{ all -> 0x0073 }
                if (r0 == 0) goto L_0x006b
                if (r1 == 0) goto L_0x006b
                androidx.emoji2.text.MetadataRepo r0 = androidx.emoji2.text.MetadataRepo.create((android.graphics.Typeface) r1, (java.nio.ByteBuffer) r0)     // Catch:{ all -> 0x0073 }
                androidx.core.os.TraceCompat.endSection()     // Catch:{ all -> 0x0094 }
                java.lang.Object r1 = r7.mLock     // Catch:{ all -> 0x0094 }
                monitor-enter(r1)     // Catch:{ all -> 0x0094 }
                androidx.emoji2.text.EmojiCompat$MetadataRepoLoaderCallback r2 = r7.mCallback     // Catch:{ all -> 0x0068 }
                if (r2 == 0) goto L_0x0063
                r2.onLoaded(r0)     // Catch:{ all -> 0x0068 }
            L_0x0063:
                monitor-exit(r1)     // Catch:{ all -> 0x0068 }
                r7.cleanUp()     // Catch:{ all -> 0x0094 }
                goto L_0x00a3
            L_0x0068:
                r0 = move-exception
                monitor-exit(r1)     // Catch:{ all -> 0x0068 }
                throw r0     // Catch:{ all -> 0x0094 }
            L_0x006b:
                java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ all -> 0x0073 }
                java.lang.String r1 = "Unable to open file."
                r0.<init>(r1)     // Catch:{ all -> 0x0073 }
                throw r0     // Catch:{ all -> 0x0073 }
            L_0x0073:
                r0 = move-exception
                androidx.core.os.TraceCompat.endSection()     // Catch:{ all -> 0x0094 }
                throw r0     // Catch:{ all -> 0x0094 }
            L_0x0078:
                java.lang.RuntimeException r0 = new java.lang.RuntimeException     // Catch:{ all -> 0x0094 }
                java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0094 }
                r2.<init>()     // Catch:{ all -> 0x0094 }
                java.lang.String r3 = "fetchFonts result is not OK. ("
                r2.append(r3)     // Catch:{ all -> 0x0094 }
                r2.append(r1)     // Catch:{ all -> 0x0094 }
                java.lang.String r1 = ")"
                r2.append(r1)     // Catch:{ all -> 0x0094 }
                java.lang.String r1 = r2.toString()     // Catch:{ all -> 0x0094 }
                r0.<init>(r1)     // Catch:{ all -> 0x0094 }
                throw r0     // Catch:{ all -> 0x0094 }
            L_0x0094:
                r0 = move-exception
                java.lang.Object r1 = r7.mLock
                monitor-enter(r1)
                androidx.emoji2.text.EmojiCompat$MetadataRepoLoaderCallback r2 = r7.mCallback     // Catch:{ all -> 0x00a4 }
                if (r2 == 0) goto L_0x009f
                r2.onFailed(r0)     // Catch:{ all -> 0x00a4 }
            L_0x009f:
                monitor-exit(r1)     // Catch:{ all -> 0x00a4 }
                r7.cleanUp()
            L_0x00a3:
                return
            L_0x00a4:
                r7 = move-exception
                monitor-exit(r1)     // Catch:{ all -> 0x00a4 }
                throw r7
            L_0x00a7:
                r7 = move-exception
                monitor-exit(r0)     // Catch:{ all -> 0x00a7 }
                throw r7
            */
            throw new UnsupportedOperationException("Method not decompiled: androidx.emoji2.text.FontRequestEmojiCompatConfig.FontRequestMetadataLoader.createMetadata():void");
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static class FontProviderHelper {
        @NonNull
        public FontsContractCompat.FontFamilyResult fetchFonts(@NonNull Context context, @NonNull FontRequest fontRequest) throws PackageManager.NameNotFoundException {
            return FontsContractCompat.fetchFonts(context, (CancellationSignal) null, fontRequest);
        }

        @Nullable
        public Typeface buildTypeface(@NonNull Context context, @NonNull FontsContractCompat.FontInfo fontInfo) throws PackageManager.NameNotFoundException {
            return FontsContractCompat.buildTypeface(context, (CancellationSignal) null, new FontsContractCompat.FontInfo[]{fontInfo});
        }

        public void registerObserver(@NonNull Context context, @NonNull Uri uri, @NonNull ContentObserver contentObserver) {
            context.getContentResolver().registerContentObserver(uri, false, contentObserver);
        }

        public void unregisterObserver(@NonNull Context context, @NonNull ContentObserver contentObserver) {
            context.getContentResolver().unregisterContentObserver(contentObserver);
        }
    }
}
