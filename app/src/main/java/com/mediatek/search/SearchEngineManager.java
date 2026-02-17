package com.mediatek.search;

import android.annotation.ProductApi;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.util.Slog;
import com.mediatek.common.search.SearchEngine;
import com.mediatek.search.ISearchEngineManagerService;
import java.util.List;

public class SearchEngineManager {
    public static final String ACTION_SEARCH_ENGINE_CHANGED = "com.mediatek.search.SEARCH_ENGINE_CHANGED";
    private static final boolean DBG = false;
    public static final String SEARCH_ENGINE_SERVICE = "search_engine_service";
    private static final String TAG = "SearchEngineManager";
    private static ISearchEngineManagerService mService;

    public SearchEngineManager() {
        mService = ISearchEngineManagerService.Stub.asInterface(ServiceManager.getService(SEARCH_ENGINE_SERVICE));
    }

    @ProductApi
    public List<SearchEngine> getAvailables() {
        try {
            return mService.getAvailables();
        } catch (RemoteException e) {
            Slog.e(TAG, "getSearchEngineInfos() failed: " + e);
            return null;
        }
    }

    @ProductApi
    public SearchEngine getBestMatch(String str, String str2) {
        try {
            return mService.getBestMatch(str, str2);
        } catch (RemoteException e) {
            Slog.e(TAG, "getBestMatch() failed: " + e);
            return null;
        }
    }

    public SearchEngine getByFavicon(String str) {
        return getSearchEngine(2, str);
    }

    @ProductApi
    public SearchEngine getByName(String str) {
        return getSearchEngine(-1, str);
    }

    public SearchEngine getSearchEngine(int i, String str) {
        try {
            return mService.getSearchEngine(i, str);
        } catch (RemoteException e) {
            Slog.e(TAG, "getSearchEngine(int field, String value) failed: " + e);
            return null;
        }
    }

    @ProductApi
    public SearchEngine getDefault() {
        try {
            return mService.getDefault();
        } catch (RemoteException e) {
            Slog.e(TAG, "getSystemDefaultSearchEngine() failed: " + e);
            return null;
        }
    }

    public boolean setDefault(SearchEngine searchEngine) {
        try {
            return mService.setDefault(searchEngine);
        } catch (RemoteException e) {
            Slog.e(TAG, "getSystemDefaultSearchEngine() failed: " + e);
            return false;
        }
    }
}
