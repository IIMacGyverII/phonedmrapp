package com.android.internal.telephony;

import android.content.Context;
import android.net.NetworkCapabilities;
import android.net.NetworkProvider;
import android.net.NetworkRequest;
import android.net.NetworkScore;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.build.SdkLevel;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class NetworkFactory {
    public static final int CMD_CANCEL_REQUEST = 2;
    public static final int CMD_REQUEST_NETWORK = 1;
    static final boolean DBG = true;
    static final boolean VDBG = false;
    private final String LOG_TAG;
    final NetworkFactoryShim mImpl;
    private int mRefCount = 0;

    public boolean acceptRequest(NetworkRequest networkRequest) {
        return true;
    }

    /* access modifiers changed from: protected */
    public void startNetwork() {
    }

    /* access modifiers changed from: protected */
    public void stopNetwork() {
    }

    public NetworkFactory(Looper looper, Context context, String str, NetworkCapabilities networkCapabilities) {
        this.LOG_TAG = str;
        if (SdkLevel.isAtLeastS()) {
            this.mImpl = new NetworkFactoryImpl(this, looper, context, networkCapabilities);
        } else {
            this.mImpl = new NetworkFactoryLegacyImpl(this, looper, context, networkCapabilities);
        }
    }

    @VisibleForTesting
    public Message obtainMessage(int i, int i2, int i3, Object obj) {
        return this.mImpl.obtainMessage(i, i2, i3, obj);
    }

    public final Looper getLooper() {
        return this.mImpl.getLooper();
    }

    public void register() {
        this.mImpl.register(this.LOG_TAG);
    }

    public void registerIgnoringScore() {
        this.mImpl.registerIgnoringScore(this.LOG_TAG);
    }

    public void terminate() {
        this.mImpl.terminate();
    }

    /* access modifiers changed from: protected */
    public final void reevaluateAllRequests() {
        this.mImpl.reevaluateAllRequests();
    }

    /* access modifiers changed from: protected */
    public void releaseRequestAsUnfulfillableByAnyFactory(NetworkRequest networkRequest) {
        this.mImpl.releaseRequestAsUnfulfillableByAnyFactory(networkRequest);
    }

    /* access modifiers changed from: protected */
    public void needNetworkFor(NetworkRequest networkRequest) {
        int i = this.mRefCount + 1;
        this.mRefCount = i;
        if (i == 1) {
            startNetwork();
        }
    }

    /* access modifiers changed from: protected */
    public void releaseNetworkFor(NetworkRequest networkRequest) {
        int i = this.mRefCount - 1;
        this.mRefCount = i;
        if (i == 0) {
            stopNetwork();
        }
    }

    @Deprecated
    public void setScoreFilter(int i) {
        this.mImpl.setScoreFilter(i);
    }

    public void setScoreFilter(NetworkScore networkScore) {
        this.mImpl.setScoreFilter(networkScore);
    }

    public void setCapabilityFilter(NetworkCapabilities networkCapabilities) {
        this.mImpl.setCapabilityFilter(networkCapabilities);
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public int getRequestCount() {
        return this.mImpl.getRequestCount();
    }

    public int getSerialNumber() {
        return this.mImpl.getSerialNumber();
    }

    public NetworkProvider getProvider() {
        return this.mImpl.getProvider();
    }

    /* access modifiers changed from: protected */
    public void log(String str) {
        Log.d(this.LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        this.mImpl.dump(fileDescriptor, printWriter, strArr);
    }

    public String toString() {
        return "{" + this.LOG_TAG + " " + this.mImpl.toString() + "}";
    }
}
