package com.android.internal.telephony.ims;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.telephony.ims.aidl.IImsServiceController;
import android.telephony.ims.stub.ImsFeatureConfiguration;
import android.util.Log;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class ImsServiceFeatureQueryManager {
    /* access modifiers changed from: private */
    public final Map<ComponentName, ImsServiceFeatureQuery> mActiveQueries = new HashMap();
    /* access modifiers changed from: private */
    public final Context mContext;
    /* access modifiers changed from: private */
    public final Listener mListener;
    /* access modifiers changed from: private */
    public final Object mLock = new Object();

    public interface Listener {
        void onComplete(ComponentName componentName, Set<ImsFeatureConfiguration.FeatureSlotPair> set);

        void onError(ComponentName componentName);

        void onPermanentError(ComponentName componentName);
    }

    private final class ImsServiceFeatureQuery implements ServiceConnection {
        private static final String LOG_TAG = "ImsServiceFeatureQuery";
        private final String mIntentFilter;
        private boolean mIsServiceConnectionDead = false;
        private final ComponentName mName;

        ImsServiceFeatureQuery(ComponentName componentName, String str) {
            this.mName = componentName;
            this.mIntentFilter = str;
        }

        public boolean start() {
            Log.d(LOG_TAG, "start: intent filter=" + this.mIntentFilter + ", name=" + this.mName);
            boolean bindService = ImsServiceFeatureQueryManager.this.mContext.bindService(new Intent(this.mIntentFilter).setComponent(this.mName), this, 67108929);
            if (!bindService) {
                cleanup();
            }
            return bindService;
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            Log.i(LOG_TAG, "onServiceConnected for component: " + componentName);
            if (iBinder != null) {
                queryImsFeatures(IImsServiceController.Stub.asInterface(iBinder));
                return;
            }
            Log.w(LOG_TAG, "onServiceConnected: " + componentName + " binder null.");
            cleanup();
            ImsServiceFeatureQueryManager.this.mListener.onPermanentError(componentName);
        }

        public void onServiceDisconnected(ComponentName componentName) {
            Log.w(LOG_TAG, "onServiceDisconnected for component: " + componentName);
        }

        public void onBindingDied(ComponentName componentName) {
            this.mIsServiceConnectionDead = true;
            Log.w(LOG_TAG, "onBindingDied: " + componentName);
            cleanup();
            ImsServiceFeatureQueryManager.this.mListener.onError(componentName);
        }

        public void onNullBinding(ComponentName componentName) {
            Log.w(LOG_TAG, "onNullBinding: " + componentName);
            if (!this.mIsServiceConnectionDead) {
                cleanup();
                ImsServiceFeatureQueryManager.this.mListener.onPermanentError(componentName);
            }
        }

        private void queryImsFeatures(IImsServiceController iImsServiceController) {
            Set set;
            try {
                ImsFeatureConfiguration querySupportedImsFeatures = iImsServiceController.querySupportedImsFeatures();
                if (querySupportedImsFeatures == null) {
                    set = Collections.emptySet();
                } else {
                    set = querySupportedImsFeatures.getServiceFeatures();
                }
                cleanup();
                ImsServiceFeatureQueryManager.this.mListener.onComplete(this.mName, set);
            } catch (Exception e) {
                Log.w(LOG_TAG, "queryImsFeatures - error: " + e);
                cleanup();
                ImsServiceFeatureQueryManager.this.mListener.onError(this.mName);
            }
        }

        private void cleanup() {
            ImsServiceFeatureQueryManager.this.mContext.unbindService(this);
            synchronized (ImsServiceFeatureQueryManager.this.mLock) {
                ImsServiceFeatureQueryManager.this.mActiveQueries.remove(this.mName);
            }
        }
    }

    public ImsServiceFeatureQueryManager(Context context, Listener listener) {
        this.mContext = context;
        this.mListener = listener;
    }

    public boolean startQuery(ComponentName componentName, String str) {
        synchronized (this.mLock) {
            if (this.mActiveQueries.containsKey(componentName)) {
                return true;
            }
            ImsServiceFeatureQuery imsServiceFeatureQuery = new ImsServiceFeatureQuery(componentName, str);
            this.mActiveQueries.put(componentName, imsServiceFeatureQuery);
            boolean start = imsServiceFeatureQuery.start();
            return start;
        }
    }

    public boolean isQueryInProgress() {
        boolean z;
        synchronized (this.mLock) {
            z = !this.mActiveQueries.isEmpty();
        }
        return z;
    }
}
