package com.android.internal.telephony;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.telephony.CellInfo;
import android.telephony.LocationAccessPolicy;
import android.telephony.NetworkScanRequest;
import android.telephony.RadioAccessSpecifier;
import android.telephony.SubscriptionInfo;
import android.util.Log;
import com.android.internal.telephony.CommandException;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class NetworkScanRequestTracker {
    private static final int CMD_INTERRUPT_NETWORK_SCAN = 6;
    private static final int CMD_START_NETWORK_SCAN = 1;
    private static final int CMD_STOP_NETWORK_SCAN = 4;
    private static final int EVENT_INTERRUPT_NETWORK_SCAN_DONE = 7;
    private static final int EVENT_MODEM_RESET = 8;
    private static final int EVENT_RADIO_UNAVAILABLE = 9;
    private static final int EVENT_RECEIVE_NETWORK_SCAN_RESULT = 3;
    private static final int EVENT_START_NETWORK_SCAN_DONE = 2;
    private static final int EVENT_STOP_NETWORK_SCAN_DONE = 5;
    private static final String TAG = "ScanRequestTracker";
    /* access modifiers changed from: private */
    public final Handler mHandler = new Handler() {
        public void handleMessage(Message message) {
            Log.d(NetworkScanRequestTracker.TAG, "Received Event :" + message.what);
            switch (message.what) {
                case 1:
                    NetworkScanRequestTracker.this.mScheduler.doStartScan((NetworkScanRequestInfo) message.obj);
                    return;
                case 2:
                    NetworkScanRequestTracker.this.mScheduler.startScanDone((AsyncResult) message.obj);
                    return;
                case 3:
                    NetworkScanRequestTracker.this.mScheduler.receiveResult((AsyncResult) message.obj);
                    return;
                case 4:
                    NetworkScanRequestTracker.this.mScheduler.doStopScan(message.arg1);
                    return;
                case 5:
                    NetworkScanRequestTracker.this.mScheduler.stopScanDone((AsyncResult) message.obj);
                    return;
                case 6:
                    NetworkScanRequestTracker.this.mScheduler.doInterruptScan(message.arg1);
                    return;
                case 7:
                    NetworkScanRequestTracker.this.mScheduler.interruptScanDone((AsyncResult) message.obj);
                    return;
                case 8:
                case 9:
                    NetworkScanRequestTracker.this.mScheduler.deleteScanAndMayNotify((NetworkScanRequestInfo) ((AsyncResult) message.obj).userObj, 1, true);
                    return;
                default:
                    return;
            }
        }
    };
    private final AtomicInteger mNextNetworkScanRequestId = new AtomicInteger(1);
    /* access modifiers changed from: private */
    public final NetworkScanRequestScheduler mScheduler = new NetworkScanRequestScheduler();

    /* access modifiers changed from: private */
    public void logEmptyResultOrException(AsyncResult asyncResult) {
        if (asyncResult.result == null) {
            Log.e(TAG, "NetworkScanResult: Empty result");
            return;
        }
        Log.e(TAG, "NetworkScanResult: Exception: " + asyncResult.exception);
    }

    /* access modifiers changed from: private */
    public boolean isValidScan(NetworkScanRequestInfo networkScanRequestInfo) {
        if (networkScanRequestInfo.mRequest == null || networkScanRequestInfo.mRequest.getSpecifiers() == null || networkScanRequestInfo.mRequest.getSpecifiers().length > 8) {
            return false;
        }
        for (RadioAccessSpecifier radioAccessSpecifier : networkScanRequestInfo.mRequest.getSpecifiers()) {
            if (radioAccessSpecifier.getRadioAccessNetwork() != 1 && radioAccessSpecifier.getRadioAccessNetwork() != 2 && radioAccessSpecifier.getRadioAccessNetwork() != 3 && radioAccessSpecifier.getRadioAccessNetwork() != 6) {
                return false;
            }
            if (radioAccessSpecifier.getBands() != null && radioAccessSpecifier.getBands().length > 8) {
                return false;
            }
            if (radioAccessSpecifier.getChannels() != null && radioAccessSpecifier.getChannels().length > 32) {
                return false;
            }
        }
        if (networkScanRequestInfo.mRequest.getSearchPeriodicity() >= 5 && networkScanRequestInfo.mRequest.getSearchPeriodicity() <= 300 && networkScanRequestInfo.mRequest.getMaxSearchTime() >= 60 && networkScanRequestInfo.mRequest.getMaxSearchTime() <= 3600 && networkScanRequestInfo.mRequest.getIncrementalResultsPeriodicity() >= 1 && networkScanRequestInfo.mRequest.getIncrementalResultsPeriodicity() <= 10 && networkScanRequestInfo.mRequest.getSearchPeriodicity() <= networkScanRequestInfo.mRequest.getMaxSearchTime() && networkScanRequestInfo.mRequest.getIncrementalResultsPeriodicity() <= networkScanRequestInfo.mRequest.getMaxSearchTime()) {
            if (networkScanRequestInfo.mRequest.getPlmns() == null || networkScanRequestInfo.mRequest.getPlmns().size() <= 20) {
                return true;
            }
            return false;
        }
        return false;
    }

    /* access modifiers changed from: private */
    public static boolean doesCellInfoCorrespondToKnownMccMnc(CellInfo cellInfo, Collection<String> collection) {
        return collection.contains(cellInfo.getCellIdentity().getMccString() + cellInfo.getCellIdentity().getMncString());
    }

    public static Set<String> getAllowedMccMncsForLocationRestrictedScan(Context context) {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return (Set) SubscriptionController.getInstance().getAvailableSubscriptionInfoList(context.getOpPackageName(), context.getAttributionTag()).stream().flatMap(new NetworkScanRequestTracker$$ExternalSyntheticLambda1()).collect(Collectors.toSet());
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: private */
    public static Stream<String> getAllowableMccMncsFromSubscriptionInfo(SubscriptionInfo subscriptionInfo) {
        Stream<String> flatMap = Stream.of(new List[]{subscriptionInfo.getEhplmns(), subscriptionInfo.getHplmns()}).flatMap(new NetworkScanRequestTracker$$ExternalSyntheticLambda0());
        if (subscriptionInfo.getMccString() == null || subscriptionInfo.getMncString() == null) {
            return flatMap;
        }
        return Stream.concat(flatMap, Stream.of(subscriptionInfo.getMccString() + subscriptionInfo.getMncString()));
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v12, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r5v2, resolved type: java.util.List<android.telephony.CellInfo>} */
    /* access modifiers changed from: private */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void notifyMessenger(com.android.internal.telephony.NetworkScanRequestTracker.NetworkScanRequestInfo r2, int r3, int r4, java.util.List<android.telephony.CellInfo> r5) {
        /*
            r1 = this;
            android.os.Messenger r1 = r2.mMessenger
            android.os.Message r0 = android.os.Message.obtain()
            r0.what = r3
            r0.arg1 = r4
            int r4 = r2.mScanId
            r0.arg2 = r4
            if (r5 == 0) goto L_0x005e
            r4 = 4
            if (r3 != r4) goto L_0x0044
            com.android.internal.telephony.Phone r2 = r2.mPhone
            android.content.Context r2 = r2.getContext()
            java.util.Set r2 = getAllowedMccMncsForLocationRestrictedScan(r2)
            java.util.stream.Stream r3 = r5.stream()
            com.android.internal.telephony.NetworkScanRequestTracker$$ExternalSyntheticLambda2 r4 = new com.android.internal.telephony.NetworkScanRequestTracker$$ExternalSyntheticLambda2
            r4.<init>()
            java.util.stream.Stream r3 = r3.map(r4)
            com.android.internal.telephony.NetworkScanRequestTracker$$ExternalSyntheticLambda3 r4 = new com.android.internal.telephony.NetworkScanRequestTracker$$ExternalSyntheticLambda3
            r4.<init>(r2)
            java.util.stream.Stream r2 = r3.filter(r4)
            java.util.stream.Collector r3 = java.util.stream.Collectors.toList()
            java.lang.Object r2 = r2.collect(r3)
            r5 = r2
            java.util.List r5 = (java.util.List) r5
        L_0x0044:
            int r2 = r5.size()
            android.telephony.CellInfo[] r2 = new android.telephony.CellInfo[r2]
            java.lang.Object[] r2 = r5.toArray(r2)
            android.telephony.CellInfo[] r2 = (android.telephony.CellInfo[]) r2
            android.os.Bundle r3 = new android.os.Bundle
            r3.<init>()
            java.lang.String r4 = "scanResult"
            r3.putParcelableArray(r4, r2)
            r0.setData(r3)
            goto L_0x0061
        L_0x005e:
            r2 = 0
            r0.obj = r2
        L_0x0061:
            r1.send(r0)     // Catch:{ RemoteException -> 0x0065 }
            goto L_0x007c
        L_0x0065:
            r1 = move-exception
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "Exception in notifyMessenger: "
            r2.append(r3)
            r2.append(r1)
            java.lang.String r1 = r2.toString()
            java.lang.String r2 = "ScanRequestTracker"
            android.util.Log.e(r2, r1)
        L_0x007c:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.NetworkScanRequestTracker.notifyMessenger(com.android.internal.telephony.NetworkScanRequestTracker$NetworkScanRequestInfo, int, int, java.util.List):void");
    }

    class NetworkScanRequestInfo implements IBinder.DeathRecipient {
        private final IBinder mBinder;
        /* access modifiers changed from: private */
        public final String mCallingPackage;
        private boolean mIsBinderDead = false;
        /* access modifiers changed from: private */
        public final Messenger mMessenger;
        /* access modifiers changed from: private */
        public final Phone mPhone;
        /* access modifiers changed from: private */
        public final int mPid;
        /* access modifiers changed from: private */
        public boolean mRenounceFineLocationAccess;
        /* access modifiers changed from: private */
        public final NetworkScanRequest mRequest;
        /* access modifiers changed from: private */
        public final int mScanId;
        /* access modifiers changed from: private */
        public final int mUid;

        NetworkScanRequestInfo(NetworkScanRequest networkScanRequest, Messenger messenger, IBinder iBinder, int i, Phone phone, int i2, int i3, String str, boolean z) {
            this.mRequest = networkScanRequest;
            this.mMessenger = messenger;
            this.mBinder = iBinder;
            this.mScanId = i;
            this.mPhone = phone;
            this.mUid = i2;
            this.mPid = i3;
            this.mCallingPackage = str;
            this.mRenounceFineLocationAccess = z;
            try {
                iBinder.linkToDeath(this, 0);
            } catch (RemoteException unused) {
                binderDied();
            }
        }

        /* access modifiers changed from: package-private */
        public synchronized void setIsBinderDead(boolean z) {
            this.mIsBinderDead = z;
        }

        /* access modifiers changed from: package-private */
        public synchronized boolean getIsBinderDead() {
            return this.mIsBinderDead;
        }

        /* access modifiers changed from: package-private */
        public NetworkScanRequest getRequest() {
            return this.mRequest;
        }

        /* access modifiers changed from: package-private */
        public void unlinkDeathRecipient() {
            IBinder iBinder = this.mBinder;
            if (iBinder != null) {
                iBinder.unlinkToDeath(this, 0);
            }
        }

        public void binderDied() {
            Log.e(NetworkScanRequestTracker.TAG, "PhoneInterfaceManager NetworkScanRequestInfo binderDied(" + this.mRequest + ", " + this.mBinder + ")");
            setIsBinderDead(true);
            NetworkScanRequestTracker.this.interruptNetworkScan(this.mScanId);
        }
    }

    private class NetworkScanRequestScheduler {
        /* access modifiers changed from: private */
        public NetworkScanRequestInfo mLiveRequestInfo;
        /* access modifiers changed from: private */
        public NetworkScanRequestInfo mPendingRequestInfo;

        private boolean cacheScan(NetworkScanRequestInfo networkScanRequestInfo) {
            return false;
        }

        private NetworkScanRequestScheduler() {
        }

        private int rilErrorToScanError(int i) {
            if (i == 0) {
                return 0;
            }
            if (i == 1) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: RADIO_NOT_AVAILABLE");
                return 1;
            } else if (i == 6) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: REQUEST_NOT_SUPPORTED");
                return 4;
            } else if (i == 40) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: MODEM_ERR");
                return 1;
            } else if (i == 44) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: INVALID_ARGUMENTS");
                return 2;
            } else if (i == 54) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: OPERATION_NOT_ALLOWED");
                return 1;
            } else if (i == 64) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: DEVICE_IN_USE");
                return 3;
            } else if (i == 37) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: NO_MEMORY");
                return 1;
            } else if (i != 38) {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: Unexpected RadioError " + i);
                return 10000;
            } else {
                Log.e(NetworkScanRequestTracker.TAG, "rilErrorToScanError: INTERNAL_ERR");
                return 1;
            }
        }

        private int commandExceptionErrorToScanError(CommandException.Error error) {
            switch (AnonymousClass2.$SwitchMap$com$android$internal$telephony$CommandException$Error[error.ordinal()]) {
                case 1:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: RADIO_NOT_AVAILABLE");
                    return 1;
                case 2:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: REQUEST_NOT_SUPPORTED");
                    return 4;
                case 3:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: NO_MEMORY");
                    return 1;
                case 4:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: INTERNAL_ERR");
                    return 1;
                case 5:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: MODEM_ERR");
                    return 1;
                case 6:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: OPERATION_NOT_ALLOWED");
                    return 1;
                case 7:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: INVALID_ARGUMENTS");
                    return 2;
                case 8:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: DEVICE_IN_USE");
                    return 3;
                default:
                    Log.e(NetworkScanRequestTracker.TAG, "commandExceptionErrorToScanError: Unexpected CommandExceptionError " + error);
                    return 10000;
            }
        }

        /* access modifiers changed from: private */
        public void doStartScan(NetworkScanRequestInfo networkScanRequestInfo) {
            if (networkScanRequestInfo == null) {
                Log.e(NetworkScanRequestTracker.TAG, "CMD_START_NETWORK_SCAN: nsri is null");
            } else if (!NetworkScanRequestTracker.this.isValidScan(networkScanRequestInfo)) {
                NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, 2, 2, (List<CellInfo>) null);
            } else if (networkScanRequestInfo.getIsBinderDead()) {
                Log.e(NetworkScanRequestTracker.TAG, "CMD_START_NETWORK_SCAN: Binder has died");
            } else if (!startNewScan(networkScanRequestInfo) && !interruptLiveScan(networkScanRequestInfo) && !cacheScan(networkScanRequestInfo)) {
                NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, 2, 3, (List<CellInfo>) null);
            }
        }

        /* access modifiers changed from: private */
        /* JADX WARNING: Code restructure failed: missing block: B:23:0x005a, code lost:
            return;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public synchronized void startScanDone(android.os.AsyncResult r4) {
            /*
                r3 = this;
                monitor-enter(r3)
                java.lang.Object r0 = r4.userObj     // Catch:{ all -> 0x0064 }
                com.android.internal.telephony.NetworkScanRequestTracker$NetworkScanRequestInfo r0 = (com.android.internal.telephony.NetworkScanRequestTracker.NetworkScanRequestInfo) r0     // Catch:{ all -> 0x0064 }
                if (r0 != 0) goto L_0x0010
                java.lang.String r4 = "ScanRequestTracker"
                java.lang.String r0 = "EVENT_START_NETWORK_SCAN_DONE: nsri is null"
                android.util.Log.e(r4, r0)     // Catch:{ all -> 0x0064 }
                monitor-exit(r3)
                return
            L_0x0010:
                com.android.internal.telephony.NetworkScanRequestTracker$NetworkScanRequestInfo r1 = r3.mLiveRequestInfo     // Catch:{ all -> 0x0064 }
                if (r1 == 0) goto L_0x005b
                int r1 = r0.mScanId     // Catch:{ all -> 0x0064 }
                com.android.internal.telephony.NetworkScanRequestTracker$NetworkScanRequestInfo r2 = r3.mLiveRequestInfo     // Catch:{ all -> 0x0064 }
                int r2 = r2.mScanId     // Catch:{ all -> 0x0064 }
                if (r1 == r2) goto L_0x0021
                goto L_0x005b
            L_0x0021:
                java.lang.Throwable r1 = r4.exception     // Catch:{ all -> 0x0064 }
                if (r1 != 0) goto L_0x003a
                java.lang.Object r1 = r4.result     // Catch:{ all -> 0x0064 }
                if (r1 == 0) goto L_0x003a
                com.android.internal.telephony.Phone r4 = r0.mPhone     // Catch:{ all -> 0x0064 }
                com.android.internal.telephony.CommandsInterface r4 = r4.mCi     // Catch:{ all -> 0x0064 }
                com.android.internal.telephony.NetworkScanRequestTracker r1 = com.android.internal.telephony.NetworkScanRequestTracker.this     // Catch:{ all -> 0x0064 }
                android.os.Handler r1 = r1.mHandler     // Catch:{ all -> 0x0064 }
                r2 = 3
                r4.registerForNetworkScanResult(r1, r2, r0)     // Catch:{ all -> 0x0064 }
                goto L_0x0059
            L_0x003a:
                com.android.internal.telephony.NetworkScanRequestTracker r1 = com.android.internal.telephony.NetworkScanRequestTracker.this     // Catch:{ all -> 0x0064 }
                r1.logEmptyResultOrException(r4)     // Catch:{ all -> 0x0064 }
                java.lang.Throwable r4 = r4.exception     // Catch:{ all -> 0x0064 }
                if (r4 == 0) goto L_0x0052
                com.android.internal.telephony.CommandException r4 = (com.android.internal.telephony.CommandException) r4     // Catch:{ all -> 0x0064 }
                com.android.internal.telephony.CommandException$Error r4 = r4.getCommandError()     // Catch:{ all -> 0x0064 }
                int r4 = r3.commandExceptionErrorToScanError(r4)     // Catch:{ all -> 0x0064 }
                r1 = 1
                r3.deleteScanAndMayNotify(r0, r4, r1)     // Catch:{ all -> 0x0064 }
                goto L_0x0059
            L_0x0052:
                java.lang.String r4 = "ScanRequestTracker"
                java.lang.String r0 = "EVENT_START_NETWORK_SCAN_DONE: ar.exception can not be null!"
                android.util.Log.wtf(r4, r0)     // Catch:{ all -> 0x0064 }
            L_0x0059:
                monitor-exit(r3)
                return
            L_0x005b:
                java.lang.String r4 = "ScanRequestTracker"
                java.lang.String r0 = "EVENT_START_NETWORK_SCAN_DONE: nsri does not match mLiveRequestInfo"
                android.util.Log.e(r4, r0)     // Catch:{ all -> 0x0064 }
                monitor-exit(r3)
                return
            L_0x0064:
                r4 = move-exception
                monitor-exit(r3)
                throw r4
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.NetworkScanRequestTracker.NetworkScanRequestScheduler.startScanDone(android.os.AsyncResult):void");
        }

        /* access modifiers changed from: private */
        public void receiveResult(AsyncResult asyncResult) {
            Object obj;
            NetworkScanRequestInfo networkScanRequestInfo = (NetworkScanRequestInfo) asyncResult.userObj;
            if (networkScanRequestInfo == null) {
                Log.e(NetworkScanRequestTracker.TAG, "EVENT_RECEIVE_NETWORK_SCAN_RESULT: nsri is null");
                return;
            }
            LocationAccessPolicy.LocationPermissionQuery build = new LocationAccessPolicy.LocationPermissionQuery.Builder().setCallingPackage(networkScanRequestInfo.mCallingPackage).setCallingPid(networkScanRequestInfo.mPid).setCallingUid(networkScanRequestInfo.mUid).setCallingFeatureId(networkScanRequestInfo.mPhone.getContext().getAttributionTag()).setMinSdkVersionForFine(29).setMinSdkVersionForCoarse(29).setMinSdkVersionForEnforcement(29).setMethod("NetworkScanTracker#onResult").build();
            if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
                NetworkScanRequestTracker.this.logEmptyResultOrException(asyncResult);
                deleteScanAndMayNotify(networkScanRequestInfo, 10000, true);
                networkScanRequestInfo.mPhone.mCi.unregisterForNetworkScanResult(NetworkScanRequestTracker.this.mHandler);
                return;
            }
            NetworkScanResult networkScanResult = (NetworkScanResult) obj;
            int i = !networkScanRequestInfo.mRenounceFineLocationAccess && LocationAccessPolicy.checkLocationPermission(networkScanRequestInfo.mPhone.getContext(), build) == LocationAccessPolicy.LocationPermissionResult.ALLOWED ? 1 : 4;
            int i2 = networkScanResult.scanError;
            if (i2 == 0) {
                if (networkScanRequestInfo.mPhone.getServiceStateTracker() != null) {
                    networkScanRequestInfo.mPhone.getServiceStateTracker().updateOperatorNameForCellInfo(networkScanResult.networkInfos);
                }
                NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, i, rilErrorToScanError(networkScanResult.scanError), networkScanResult.networkInfos);
                if (networkScanResult.scanStatus == 2) {
                    deleteScanAndMayNotify(networkScanRequestInfo, 0, true);
                    networkScanRequestInfo.mPhone.mCi.unregisterForNetworkScanResult(NetworkScanRequestTracker.this.mHandler);
                    return;
                }
                return;
            }
            if (networkScanResult.networkInfos != null) {
                NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, i, rilErrorToScanError(i2), networkScanResult.networkInfos);
            }
            deleteScanAndMayNotify(networkScanRequestInfo, rilErrorToScanError(networkScanResult.scanError), true);
            networkScanRequestInfo.mPhone.mCi.unregisterForNetworkScanResult(NetworkScanRequestTracker.this.mHandler);
        }

        /* access modifiers changed from: private */
        public synchronized void doStopScan(int i) {
            NetworkScanRequestInfo networkScanRequestInfo = this.mLiveRequestInfo;
            if (networkScanRequestInfo == null || i != networkScanRequestInfo.mScanId) {
                NetworkScanRequestInfo networkScanRequestInfo2 = this.mPendingRequestInfo;
                if (networkScanRequestInfo2 == null || i != networkScanRequestInfo2.mScanId) {
                    Log.e(NetworkScanRequestTracker.TAG, "stopScan: scan " + i + " does not exist!");
                } else {
                    NetworkScanRequestTracker.this.notifyMessenger(this.mPendingRequestInfo, 3, 0, (List<CellInfo>) null);
                    this.mPendingRequestInfo = null;
                }
            } else {
                this.mLiveRequestInfo.mPhone.stopNetworkScan(NetworkScanRequestTracker.this.mHandler.obtainMessage(5, this.mLiveRequestInfo));
            }
        }

        /* access modifiers changed from: private */
        public void stopScanDone(AsyncResult asyncResult) {
            NetworkScanRequestInfo networkScanRequestInfo = (NetworkScanRequestInfo) asyncResult.userObj;
            if (networkScanRequestInfo == null) {
                Log.e(NetworkScanRequestTracker.TAG, "EVENT_STOP_NETWORK_SCAN_DONE: nsri is null");
                return;
            }
            if (asyncResult.exception != null || asyncResult.result == null) {
                NetworkScanRequestTracker.this.logEmptyResultOrException(asyncResult);
                Throwable th = asyncResult.exception;
                if (th != null) {
                    deleteScanAndMayNotify(networkScanRequestInfo, commandExceptionErrorToScanError(((CommandException) th).getCommandError()), true);
                } else {
                    Log.wtf(NetworkScanRequestTracker.TAG, "EVENT_STOP_NETWORK_SCAN_DONE: ar.exception can not be null!");
                }
            } else {
                deleteScanAndMayNotify(networkScanRequestInfo, 0, true);
            }
            networkScanRequestInfo.mPhone.mCi.unregisterForNetworkScanResult(NetworkScanRequestTracker.this.mHandler);
        }

        /* access modifiers changed from: private */
        public synchronized void doInterruptScan(int i) {
            NetworkScanRequestInfo networkScanRequestInfo = this.mLiveRequestInfo;
            if (networkScanRequestInfo == null || i != networkScanRequestInfo.mScanId) {
                Log.e(NetworkScanRequestTracker.TAG, "doInterruptScan: scan " + i + " does not exist!");
            } else {
                this.mLiveRequestInfo.mPhone.stopNetworkScan(NetworkScanRequestTracker.this.mHandler.obtainMessage(7, this.mLiveRequestInfo));
            }
        }

        /* access modifiers changed from: private */
        public void interruptScanDone(AsyncResult asyncResult) {
            NetworkScanRequestInfo networkScanRequestInfo = (NetworkScanRequestInfo) asyncResult.userObj;
            if (networkScanRequestInfo == null) {
                Log.e(NetworkScanRequestTracker.TAG, "EVENT_INTERRUPT_NETWORK_SCAN_DONE: nsri is null");
                return;
            }
            networkScanRequestInfo.mPhone.mCi.unregisterForNetworkScanResult(NetworkScanRequestTracker.this.mHandler);
            deleteScanAndMayNotify(networkScanRequestInfo, 0, false);
        }

        private synchronized boolean interruptLiveScan(NetworkScanRequestInfo networkScanRequestInfo) {
            if (this.mLiveRequestInfo == null || this.mPendingRequestInfo != null || networkScanRequestInfo.mUid != 1000 || this.mLiveRequestInfo.mUid == 1000) {
                return false;
            }
            doInterruptScan(this.mLiveRequestInfo.mScanId);
            this.mPendingRequestInfo = networkScanRequestInfo;
            NetworkScanRequestTracker.this.notifyMessenger(this.mLiveRequestInfo, 2, 10002, (List<CellInfo>) null);
            return true;
        }

        private synchronized boolean startNewScan(NetworkScanRequestInfo networkScanRequestInfo) {
            if (this.mLiveRequestInfo != null) {
                return false;
            }
            this.mLiveRequestInfo = networkScanRequestInfo;
            networkScanRequestInfo.mPhone.startNetworkScan(networkScanRequestInfo.getRequest(), NetworkScanRequestTracker.this.mHandler.obtainMessage(2, networkScanRequestInfo));
            networkScanRequestInfo.mPhone.mCi.registerForModemReset(NetworkScanRequestTracker.this.mHandler, 8, networkScanRequestInfo);
            networkScanRequestInfo.mPhone.mCi.registerForNotAvailable(NetworkScanRequestTracker.this.mHandler, 9, networkScanRequestInfo);
            return true;
        }

        /* access modifiers changed from: private */
        public synchronized void deleteScanAndMayNotify(NetworkScanRequestInfo networkScanRequestInfo, int i, boolean z) {
            if (this.mLiveRequestInfo != null && networkScanRequestInfo.mScanId == this.mLiveRequestInfo.mScanId) {
                if (z) {
                    if (i == 0) {
                        NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, 3, i, (List<CellInfo>) null);
                    } else {
                        NetworkScanRequestTracker.this.notifyMessenger(networkScanRequestInfo, 2, i, (List<CellInfo>) null);
                    }
                }
                this.mLiveRequestInfo.mPhone.mCi.unregisterForModemReset(NetworkScanRequestTracker.this.mHandler);
                this.mLiveRequestInfo.mPhone.mCi.unregisterForNotAvailable(NetworkScanRequestTracker.this.mHandler);
                this.mLiveRequestInfo = null;
                NetworkScanRequestInfo networkScanRequestInfo2 = this.mPendingRequestInfo;
                if (networkScanRequestInfo2 != null) {
                    startNewScan(networkScanRequestInfo2);
                    this.mPendingRequestInfo = null;
                }
            }
        }
    }

    /* renamed from: com.android.internal.telephony.NetworkScanRequestTracker$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$CommandException$Error;

        /* JADX WARNING: Can't wrap try/catch for region: R(18:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|18) */
        /* JADX WARNING: Code restructure failed: missing block: B:19:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.CommandException$Error[] r0 = com.android.internal.telephony.CommandException.Error.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$CommandException$Error = r0
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.RADIO_NOT_AVAILABLE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.REQUEST_NOT_SUPPORTED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NO_MEMORY     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INTERNAL_ERR     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.MODEM_ERR     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.OPERATION_NOT_ALLOWED     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INVALID_ARGUMENTS     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.DEVICE_IN_USE     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.NetworkScanRequestTracker.AnonymousClass2.<clinit>():void");
        }
    }

    /* access modifiers changed from: private */
    public void interruptNetworkScan(int i) {
        this.mHandler.obtainMessage(6, i, 0).sendToTarget();
    }

    public int startNetworkScan(boolean z, NetworkScanRequest networkScanRequest, Messenger messenger, IBinder iBinder, Phone phone, int i, int i2, String str) {
        int andIncrement = this.mNextNetworkScanRequestId.getAndIncrement();
        this.mHandler.obtainMessage(1, new NetworkScanRequestInfo(networkScanRequest, messenger, iBinder, andIncrement, phone, i, i2, str, z)).sendToTarget();
        return andIncrement;
    }

    public void stopNetworkScan(int i, int i2) {
        synchronized (this.mScheduler) {
            if ((this.mScheduler.mLiveRequestInfo != null && i == this.mScheduler.mLiveRequestInfo.mScanId && i2 == this.mScheduler.mLiveRequestInfo.mUid) || (this.mScheduler.mPendingRequestInfo != null && i == this.mScheduler.mPendingRequestInfo.mScanId && i2 == this.mScheduler.mPendingRequestInfo.mUid)) {
                this.mHandler.obtainMessage(4, i, 0).sendToTarget();
            } else {
                throw new IllegalArgumentException("Scan with id: " + i + " does not exist!");
            }
        }
    }
}
