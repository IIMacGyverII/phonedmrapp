package com.android.internal.telephony;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkCapabilities;
import android.net.NetworkProvider;
import android.net.NetworkRequest;
import android.net.NetworkScore;
import android.os.Looper;
import android.os.Message;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.Executor;

class NetworkFactoryImpl extends NetworkFactoryLegacyImpl {
    private static final int CMD_CANCEL_REQUEST = 2;
    private static final int CMD_LISTEN_TO_ALL_REQUESTS = 6;
    private static final int CMD_OFFER_NETWORK = 5;
    private static final int CMD_REQUEST_NETWORK = 1;
    private static final int CMD_SET_FILTER = 4;
    private static final int CMD_SET_SCORE = 3;
    private static final boolean DBG = true;
    private static final NetworkScore INVINCIBLE_SCORE = new NetworkScore.Builder().setLegacyInt(1000).build();
    private static final boolean VDBG = false;
    private final Executor mExecutor;
    private final Map<NetworkRequest, NetworkRequestInfo> mNetworkRequests;
    private final NetworkProvider.NetworkOfferCallback mRequestCallback;
    private NetworkScore mScore;

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$new$0(Runnable runnable) {
        post(runnable);
    }

    /* JADX INFO: super call moved to the top of the method (can break code semantics) */
    NetworkFactoryImpl(NetworkFactory networkFactory, Looper looper, Context context, NetworkCapabilities networkCapabilities) {
        super(networkFactory, looper, context, networkCapabilities == null ? NetworkCapabilities.Builder.withoutDefaultCapabilities().build() : networkCapabilities);
        this.mNetworkRequests = new LinkedHashMap();
        this.mScore = new NetworkScore.Builder().setLegacyInt(0).build();
        this.mRequestCallback = new NetworkProvider.NetworkOfferCallback() {
            public void onNetworkNeeded(NetworkRequest networkRequest) {
                NetworkFactoryImpl.this.handleAddRequest(networkRequest);
            }

            public void onNetworkUnneeded(NetworkRequest networkRequest) {
                NetworkFactoryImpl.this.handleRemoveRequest(networkRequest);
            }
        };
        this.mExecutor = new NetworkFactoryImpl$$ExternalSyntheticLambda0(this);
    }

    public void register(String str) {
        register(str, false);
    }

    public void registerIgnoringScore(String str) {
        register(str, true);
    }

    private void register(String str, boolean z) {
        if (this.mProvider == null) {
            this.mParent.log("Registering NetworkFactory");
            this.mProvider = new NetworkProvider(this.mContext, getLooper(), str) {
                public void onNetworkRequested(NetworkRequest networkRequest, int i, int i2) {
                    NetworkFactoryImpl.this.handleAddRequest(networkRequest);
                }

                public void onNetworkRequestWithdrawn(NetworkRequest networkRequest) {
                    NetworkFactoryImpl.this.handleRemoveRequest(networkRequest);
                }
            };
            ((ConnectivityManager) this.mContext.getSystemService("connectivity")).registerNetworkProvider(this.mProvider);
            if (z) {
                sendMessage(obtainMessage(6));
            } else {
                sendMessage(obtainMessage(5));
            }
        } else {
            throw new IllegalStateException("A NetworkFactory must only be registered once");
        }
    }

    private void handleOfferNetwork(NetworkScore networkScore) {
        this.mProvider.registerNetworkOffer(networkScore, this.mCapabilityFilter, this.mExecutor, this.mRequestCallback);
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                handleAddRequest((NetworkRequest) message.obj);
                return;
            case 2:
                handleRemoveRequest((NetworkRequest) message.obj);
                return;
            case 3:
                handleSetScore((NetworkScore) message.obj);
                return;
            case 4:
                handleSetFilter((NetworkCapabilities) message.obj);
                return;
            case 5:
                handleOfferNetwork(this.mScore);
                return;
            case 6:
                handleOfferNetwork(INVINCIBLE_SCORE);
                return;
            default:
                return;
        }
    }

    private static class NetworkRequestInfo {
        public final NetworkRequest request;
        public boolean requested = false;

        NetworkRequestInfo(NetworkRequest networkRequest) {
            this.request = networkRequest;
        }

        public String toString() {
            return "{" + this.request + ", requested=" + this.requested + "}";
        }
    }

    /* access modifiers changed from: private */
    public void handleAddRequest(NetworkRequest networkRequest) {
        NetworkRequestInfo networkRequestInfo = this.mNetworkRequests.get(networkRequest);
        if (networkRequestInfo == null) {
            NetworkFactory networkFactory = this.mParent;
            networkFactory.log("got request " + networkRequest);
            networkRequestInfo = new NetworkRequestInfo(networkRequest);
            this.mNetworkRequests.put(networkRequestInfo.request, networkRequestInfo);
        }
        if (this.mParent.acceptRequest(networkRequest)) {
            networkRequestInfo.requested = true;
            this.mParent.needNetworkFor(networkRequest);
        }
    }

    /* access modifiers changed from: private */
    public void handleRemoveRequest(NetworkRequest networkRequest) {
        NetworkRequestInfo networkRequestInfo = this.mNetworkRequests.get(networkRequest);
        if (networkRequestInfo != null) {
            this.mNetworkRequests.remove(networkRequest);
            if (networkRequestInfo.requested) {
                this.mParent.releaseNetworkFor(networkRequestInfo.request);
            }
        }
    }

    private void handleSetScore(NetworkScore networkScore) {
        if (!this.mScore.equals(networkScore)) {
            this.mScore = networkScore;
            this.mParent.reevaluateAllRequests();
        }
    }

    private void handleSetFilter(NetworkCapabilities networkCapabilities) {
        if (!networkCapabilities.equals(this.mCapabilityFilter)) {
            this.mCapabilityFilter = networkCapabilities;
            this.mParent.reevaluateAllRequests();
        }
    }

    public final void reevaluateAllRequests() {
        NetworkProvider networkProvider = this.mProvider;
        if (networkProvider != null) {
            networkProvider.registerNetworkOffer(this.mScore, this.mCapabilityFilter, this.mExecutor, this.mRequestCallback);
        }
    }

    @Deprecated
    public void setScoreFilter(int i) {
        setScoreFilter(new NetworkScore.Builder().setLegacyInt(i).build());
    }

    public void setScoreFilter(NetworkScore networkScore) {
        sendMessage(obtainMessage(3, networkScore));
    }

    public void setCapabilityFilter(NetworkCapabilities networkCapabilities) {
        sendMessage(obtainMessage(4, new NetworkCapabilities(networkCapabilities)));
    }

    public int getRequestCount() {
        return this.mNetworkRequests.size();
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println(toString());
        for (NetworkRequestInfo networkRequestInfo : this.mNetworkRequests.values()) {
            printWriter.println("  " + networkRequestInfo);
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("providerId=");
        NetworkProvider networkProvider = this.mProvider;
        sb.append(networkProvider != null ? Integer.valueOf(networkProvider.getProviderId()) : "null");
        sb.append(", ScoreFilter=");
        sb.append(this.mScore);
        sb.append(", Filter=");
        sb.append(this.mCapabilityFilter);
        sb.append(", requests=");
        sb.append(this.mNetworkRequests.size());
        return sb.toString();
    }
}
