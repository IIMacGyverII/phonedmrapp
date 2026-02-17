package mediatek.app;

import android.app.SystemServiceRegistry;
import android.content.Context;
import android.os.Looper;
import android.os.ServiceManager;
import android.util.ArrayMap;
import android.util.Log;
import com.mediatek.search.SearchEngineManager;
import java.lang.reflect.Constructor;
import java.util.Optional;

public final class MtkSystemServiceRegistry {
    private static final String TAG = "MtkSystemServiceRegistry";
    private static ArrayMap<String, SystemServiceRegistry.ServiceFetcher<?>> sSystemServiceFetchers;
    private static ArrayMap<Class<?>, String> sSystemServiceNames;

    private MtkSystemServiceRegistry() {
    }

    public static void registerAllService() {
        Log.i(TAG, "registerAllService start");
        Log.i(TAG, "Comment out registerService");
        registerService(SearchEngineManager.SEARCH_ENGINE_SERVICE, SearchEngineManager.class, new SystemServiceRegistry.StaticServiceFetcher<SearchEngineManager>() {
            public SearchEngineManager createService() {
                return new SearchEngineManager();
            }
        });
        registerFmService();
        registerOmadmService();
    }

    public static void setMtkSystemServiceName(ArrayMap<Class<?>, String> arrayMap, ArrayMap<String, SystemServiceRegistry.ServiceFetcher<?>> arrayMap2) {
        Log.i(TAG, "setMtkSystemServiceName start names" + arrayMap + ",fetchers" + arrayMap2);
        sSystemServiceNames = arrayMap;
        sSystemServiceFetchers = arrayMap2;
    }

    private static <T> void registerService(String str, Class<T> cls, SystemServiceRegistry.ServiceFetcher<T> serviceFetcher) {
        sSystemServiceNames.put(cls, str);
        sSystemServiceFetchers.put(str, serviceFetcher);
    }

    public static void registerFmService() {
        try {
            final Constructor<?> constructor = Class.forName((String) Class.forName("com.mediatek.fmradio.FmRadioPackageManager").getMethod("getPackageName", (Class[]) null).invoke((Object) null, new Object[0])).getConstructor(new Class[]{Context.class, Looper.class});
            if (constructor != null) {
                registerService("fm_radio_service", Optional.class, new SystemServiceRegistry.StaticServiceFetcher<Optional>() {
                    public Optional createService() throws ServiceManager.ServiceNotFoundException {
                        Optional empty = Optional.empty();
                        try {
                            return Optional.of(constructor.newInstance(new Object[0]));
                        } catch (Exception unused) {
                            Log.e(MtkSystemServiceRegistry.TAG, "Exception while creating FmRadioManager object");
                            return empty;
                        }
                    }
                });
            }
        } catch (Exception unused) {
            Log.e(TAG, "Exception while getting FmRadioPackageManager class");
        }
    }

    public static void registerOmadmService() {
        try {
            final Constructor<?> constructor = Class.forName("com.mediatek.common.omadm.OmadmManager").getConstructor(new Class[]{Context.class});
            if (constructor != null) {
                registerService("omadm_service", Optional.class, new SystemServiceRegistry.StaticServiceFetcher<Optional>() {
                    public Optional createService() throws ServiceManager.ServiceNotFoundException {
                        Optional empty = Optional.empty();
                        try {
                            return Optional.of(constructor.newInstance(new Object[0]));
                        } catch (Exception unused) {
                            Log.e(MtkSystemServiceRegistry.TAG, "Exception while creating OmadmManager object");
                            return empty;
                        }
                    }
                });
            }
        } catch (Exception unused) {
            Log.e(TAG, "Exception while getting OmadmManager class");
        }
    }
}
