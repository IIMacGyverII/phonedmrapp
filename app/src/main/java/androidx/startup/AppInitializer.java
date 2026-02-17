package androidx.startup;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.tracing.Trace;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class AppInitializer {
    private static final String SECTION_NAME = "Startup";
    private static volatile AppInitializer sInstance;
    private static final Object sLock = new Object();
    @NonNull
    final Context mContext;
    @NonNull
    final Set<Class<? extends Initializer<?>>> mDiscovered = new HashSet();
    @NonNull
    final Map<Class<?>, Object> mInitialized = new HashMap();

    AppInitializer(@NonNull Context context) {
        this.mContext = context.getApplicationContext();
    }

    @NonNull
    public static AppInitializer getInstance(@NonNull Context context) {
        if (sInstance == null) {
            synchronized (sLock) {
                if (sInstance == null) {
                    sInstance = new AppInitializer(context);
                }
            }
        }
        return sInstance;
    }

    @NonNull
    public <T> T initializeComponent(@NonNull Class<? extends Initializer<T>> cls) {
        return doInitialize(cls, new HashSet());
    }

    public boolean isEagerlyInitialized(@NonNull Class<? extends Initializer<?>> cls) {
        return this.mDiscovered.contains(cls);
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public <T> T doInitialize(@NonNull Class<? extends Initializer<?>> cls, @NonNull Set<Class<?>> set) {
        T t;
        synchronized (sLock) {
            if (Trace.isEnabled()) {
                try {
                    Trace.beginSection(cls.getSimpleName());
                } catch (Throwable th) {
                    Trace.endSection();
                    throw th;
                }
            }
            if (!set.contains(cls)) {
                if (!this.mInitialized.containsKey(cls)) {
                    set.add(cls);
                    Initializer initializer = (Initializer) cls.getDeclaredConstructor(new Class[0]).newInstance(new Object[0]);
                    List<Class<? extends Initializer<?>>> dependencies = initializer.dependencies();
                    if (!dependencies.isEmpty()) {
                        for (Class next : dependencies) {
                            if (!this.mInitialized.containsKey(next)) {
                                doInitialize(next, set);
                            }
                        }
                    }
                    t = initializer.create(this.mContext);
                    set.remove(cls);
                    this.mInitialized.put(cls, t);
                } else {
                    t = this.mInitialized.get(cls);
                }
                Trace.endSection();
            } else {
                throw new IllegalStateException(String.format("Cannot initialize %s. Cycle detected.", new Object[]{cls.getName()}));
            }
        }
        return t;
    }

    /* access modifiers changed from: package-private */
    public void discoverAndInitialize() {
        try {
            Trace.beginSection(SECTION_NAME);
            Bundle bundle = this.mContext.getPackageManager().getProviderInfo(new ComponentName(this.mContext.getPackageName(), InitializationProvider.class.getName()), 128).metaData;
            String string = this.mContext.getString(R.string.androidx_startup);
            if (bundle != null) {
                HashSet hashSet = new HashSet();
                for (String str : bundle.keySet()) {
                    if (string.equals(bundle.getString(str, (String) null))) {
                        Class<?> cls = Class.forName(str);
                        if (Initializer.class.isAssignableFrom(cls)) {
                            this.mDiscovered.add(cls);
                            doInitialize(cls, hashSet);
                        }
                    }
                }
            }
            Trace.endSection();
        } catch (PackageManager.NameNotFoundException | ClassNotFoundException e) {
            throw new StartupException(e);
        } catch (Throwable th) {
            Trace.endSection();
            throw th;
        }
    }
}
