package com.android.internal.telephony.ims;

import android.content.ComponentName;
import android.content.Context;
import android.os.Handler;
import android.os.IBinder;
import android.os.IInterface;
import android.os.RemoteException;
import android.telephony.ims.aidl.IImsConfig;
import android.telephony.ims.aidl.IImsMmTelFeature;
import android.telephony.ims.aidl.IImsRcsFeature;
import android.telephony.ims.aidl.IImsRegistration;
import android.telephony.ims.aidl.ISipTransport;
import android.util.Log;
import android.util.SparseArray;
import com.android.ims.ImsFeatureBinderRepository;
import com.android.ims.internal.IImsFeatureStatusCallback;
import com.android.ims.internal.IImsMMTelFeature;
import com.android.ims.internal.IImsServiceController;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.ims.ImsServiceController;

public class ImsServiceControllerCompat extends ImsServiceController {
    private static final String TAG = "ImsSCCompat";
    private final SparseArray<ImsConfigCompatAdapter> mConfigCompatAdapters;
    private final SparseArray<MmTelFeatureCompatAdapter> mMmTelCompatAdapters;
    private final MmTelFeatureCompatFactory mMmTelFeatureFactory;
    private final SparseArray<ImsRegistrationCompatAdapter> mRegCompatAdapters;
    private IImsServiceController mServiceController;

    @VisibleForTesting
    public interface MmTelFeatureCompatFactory {
        MmTelFeatureCompatAdapter create(Context context, int i, MmTelInterfaceAdapter mmTelInterfaceAdapter);
    }

    private IImsRcsFeature createRcsFeature(int i) {
        return null;
    }

    /* access modifiers changed from: protected */
    public final String getServiceInterface() {
        return "android.telephony.ims.compat.ImsService";
    }

    public ISipTransport getSipTransport(int i) {
        return null;
    }

    /* access modifiers changed from: protected */
    public long getStaticServiceCapabilities() {
        return 0;
    }

    public ImsServiceControllerCompat(Context context, ComponentName componentName, ImsServiceController.ImsServiceControllerCallbacks imsServiceControllerCallbacks, ImsFeatureBinderRepository imsFeatureBinderRepository) {
        super(context, componentName, imsServiceControllerCallbacks, imsFeatureBinderRepository);
        this.mMmTelCompatAdapters = new SparseArray<>();
        this.mConfigCompatAdapters = new SparseArray<>();
        this.mRegCompatAdapters = new SparseArray<>();
        this.mMmTelFeatureFactory = new ImsServiceControllerCompat$$ExternalSyntheticLambda0();
    }

    @VisibleForTesting
    public ImsServiceControllerCompat(Context context, ComponentName componentName, ImsServiceController.ImsServiceControllerCallbacks imsServiceControllerCallbacks, Handler handler, ImsServiceController.RebindRetry rebindRetry, ImsFeatureBinderRepository imsFeatureBinderRepository, MmTelFeatureCompatFactory mmTelFeatureCompatFactory) {
        super(context, componentName, imsServiceControllerCallbacks, handler, rebindRetry, imsFeatureBinderRepository);
        this.mMmTelCompatAdapters = new SparseArray<>();
        this.mConfigCompatAdapters = new SparseArray<>();
        this.mRegCompatAdapters = new SparseArray<>();
        this.mMmTelFeatureFactory = mmTelFeatureCompatFactory;
    }

    public final void enableIms(int i, int i2) {
        MmTelFeatureCompatAdapter mmTelFeatureCompatAdapter = this.mMmTelCompatAdapters.get(i);
        if (mmTelFeatureCompatAdapter == null) {
            Log.w(TAG, "enableIms: adapter null for slot :" + i);
            return;
        }
        try {
            mmTelFeatureCompatAdapter.enableIms();
        } catch (RemoteException e) {
            Log.w(TAG, "Couldn't enable IMS: " + e.getMessage());
        }
    }

    public final void disableIms(int i, int i2) {
        MmTelFeatureCompatAdapter mmTelFeatureCompatAdapter = this.mMmTelCompatAdapters.get(i);
        if (mmTelFeatureCompatAdapter == null) {
            Log.w(TAG, "enableIms: adapter null for slot :" + i);
            return;
        }
        try {
            mmTelFeatureCompatAdapter.disableIms();
        } catch (RemoteException e) {
            Log.w(TAG, "Couldn't enable IMS: " + e.getMessage());
        }
    }

    public final IImsRegistration getRegistration(int i, int i2) {
        ImsRegistrationCompatAdapter imsRegistrationCompatAdapter = this.mRegCompatAdapters.get(i);
        if (imsRegistrationCompatAdapter != null) {
            return imsRegistrationCompatAdapter.getBinder();
        }
        Log.w(TAG, "getRegistration: Registration does not exist for slot " + i);
        return null;
    }

    public final IImsConfig getConfig(int i, int i2) {
        ImsConfigCompatAdapter imsConfigCompatAdapter = this.mConfigCompatAdapters.get(i);
        if (imsConfigCompatAdapter != null) {
            return imsConfigCompatAdapter.getIImsConfig();
        }
        Log.w(TAG, "getConfig: Config does not exist for slot " + i);
        return null;
    }

    /* access modifiers changed from: protected */
    public final void notifyImsServiceReady() {
        Log.d(TAG, "notifyImsServiceReady");
    }

    /* access modifiers changed from: protected */
    public final IInterface createImsFeature(int i, int i2, int i3, long j) throws RemoteException {
        if (i3 == 1) {
            return createMMTelCompat(i);
        }
        if (i3 != 2) {
            return null;
        }
        return createRcsFeature(i);
    }

    /* access modifiers changed from: protected */
    public void registerImsFeatureStatusCallback(int i, int i2, IImsFeatureStatusCallback iImsFeatureStatusCallback) throws RemoteException {
        this.mServiceController.addFeatureStatusCallback(i, i2, iImsFeatureStatusCallback);
    }

    /* access modifiers changed from: protected */
    public void unregisterImsFeatureStatusCallback(int i, int i2, IImsFeatureStatusCallback iImsFeatureStatusCallback) {
        try {
            this.mServiceController.removeFeatureStatusCallback(i, i2, iImsFeatureStatusCallback);
        } catch (RemoteException unused) {
            Log.w(TAG, "compat - unregisterImsFeatureStatusCallback - couldn't remove " + iImsFeatureStatusCallback);
        }
    }

    /* access modifiers changed from: protected */
    public final void removeImsFeature(int i, int i2, boolean z) throws RemoteException {
        if (i2 == 1) {
            MmTelFeatureCompatAdapter mmTelFeatureCompatAdapter = this.mMmTelCompatAdapters.get(i, (Object) null);
            if (mmTelFeatureCompatAdapter != null) {
                mmTelFeatureCompatAdapter.onFeatureRemoved();
            }
            this.mMmTelCompatAdapters.remove(i);
            this.mRegCompatAdapters.remove(i);
            this.mConfigCompatAdapters.remove(i);
        }
        IImsServiceController iImsServiceController = this.mServiceController;
        if (iImsServiceController != null) {
            iImsServiceController.removeImsFeature(i, i2);
        }
    }

    /* access modifiers changed from: protected */
    public void setServiceController(IBinder iBinder) {
        this.mServiceController = IImsServiceController.Stub.asInterface(iBinder);
    }

    /* access modifiers changed from: protected */
    public boolean isServiceControllerAvailable() {
        return this.mServiceController != null;
    }

    private MmTelInterfaceAdapter getInterface(int i) throws RemoteException {
        IImsMMTelFeature createMMTelFeature = this.mServiceController.createMMTelFeature(i);
        if (createMMTelFeature != null) {
            return new MmTelInterfaceAdapter(i, createMMTelFeature.asBinder());
        }
        Log.w(TAG, "createMMTelCompat: createMMTelFeature returned null.");
        return null;
    }

    private IImsMmTelFeature createMMTelCompat(int i) throws RemoteException {
        MmTelFeatureCompatAdapter create = this.mMmTelFeatureFactory.create(this.mContext, i, getInterface(i));
        this.mMmTelCompatAdapters.put(i, create);
        ImsRegistrationCompatAdapter imsRegistrationCompatAdapter = new ImsRegistrationCompatAdapter();
        create.addRegistrationAdapter(imsRegistrationCompatAdapter);
        this.mRegCompatAdapters.put(i, imsRegistrationCompatAdapter);
        this.mConfigCompatAdapters.put(i, new ImsConfigCompatAdapter(create.getOldConfigInterface()));
        return create.getBinder();
    }
}
