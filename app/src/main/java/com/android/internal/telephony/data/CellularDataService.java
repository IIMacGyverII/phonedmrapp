package com.android.internal.telephony.data;

import android.net.LinkProperties;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.SubscriptionManager;
import android.telephony.data.DataCallResponse;
import android.telephony.data.DataProfile;
import android.telephony.data.DataService;
import android.telephony.data.DataServiceCallback;
import android.telephony.data.NetworkSliceInfo;
import android.telephony.data.TrafficDescriptor;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.telephony.Rlog;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CellularDataService extends DataService {
    private static final int APN_UNTHROTTLED = 9;
    private static final int CANCEL_HANDOVER = 8;
    private static final int DATA_CALL_LIST_CHANGED = 6;
    private static final boolean DBG = false;
    private static final int DEACTIVATE_DATA_CALL_COMPLETE = 2;
    private static final int REQUEST_DATA_CALL_LIST_COMPLETE = 5;
    private static final int SETUP_DATA_CALL_COMPLETE = 1;
    private static final int SET_DATA_PROFILE_COMPLETE = 4;
    private static final int SET_INITIAL_ATTACH_APN_COMPLETE = 3;
    private static final int START_HANDOVER = 7;
    private static final String TAG = CellularDataService.class.getSimpleName();

    private class CellularDataServiceProvider extends DataService.DataServiceProvider {
        /* access modifiers changed from: private */
        public final Map<Message, DataServiceCallback> mCallbackMap;
        private final Handler mHandler;
        private final Phone mPhone;

        private CellularDataServiceProvider(int i) {
            super(CellularDataService.this, i);
            this.mCallbackMap = new HashMap();
            Phone phone = PhoneFactory.getPhone(getSlotIndex());
            this.mPhone = phone;
            AnonymousClass1 r0 = new Handler(Looper.myLooper(), CellularDataService.this) {
                public void handleMessage(Message message) {
                    List list;
                    DataServiceCallback dataServiceCallback = (DataServiceCallback) CellularDataServiceProvider.this.mCallbackMap.remove(message);
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    int i = 4;
                    switch (message.what) {
                        case 1:
                            DataCallResponse dataCallResponse = (DataCallResponse) asyncResult.result;
                            if (asyncResult.exception == null) {
                                i = 0;
                            }
                            dataServiceCallback.onSetupDataCallComplete(i, dataCallResponse);
                            return;
                        case 2:
                            if (asyncResult.exception == null) {
                                i = 0;
                            }
                            dataServiceCallback.onDeactivateDataCallComplete(i);
                            return;
                        case 3:
                            if (asyncResult.exception == null) {
                                i = 0;
                            }
                            dataServiceCallback.onSetInitialAttachApnComplete(i);
                            return;
                        case 4:
                            if (asyncResult.exception == null) {
                                i = 0;
                            }
                            dataServiceCallback.onSetDataProfileComplete(i);
                            return;
                        case 5:
                            if (asyncResult.exception == null) {
                                i = 0;
                            }
                            Object obj = asyncResult.result;
                            if (obj != null) {
                                list = (List) obj;
                            } else {
                                list = Collections.EMPTY_LIST;
                            }
                            dataServiceCallback.onRequestDataCallListComplete(i, list);
                            return;
                        case 6:
                            CellularDataServiceProvider.this.notifyDataCallListChanged((List) asyncResult.result);
                            return;
                        case 7:
                            dataServiceCallback.onHandoverStarted(CellularDataServiceProvider.this.toResultCode(asyncResult.exception));
                            return;
                        case 8:
                            dataServiceCallback.onHandoverCancelled(CellularDataServiceProvider.this.toResultCode(asyncResult.exception));
                            return;
                        case 9:
                            Object obj2 = asyncResult.result;
                            if (obj2 instanceof DataProfile) {
                                CellularDataServiceProvider.this.notifyDataProfileUnthrottled((DataProfile) obj2);
                                return;
                            } else {
                                CellularDataServiceProvider.this.notifyApnUnthrottled((String) obj2);
                                return;
                            }
                        default:
                            CellularDataService.this.loge("Unexpected event: " + message.what);
                            return;
                    }
                }
            };
            this.mHandler = r0;
            phone.mCi.registerForDataCallListChanged(r0, 6, (Object) null);
            phone.mCi.registerForApnUnthrottled(r0, 9, (Object) null);
        }

        /* access modifiers changed from: private */
        public int toResultCode(Throwable th) {
            if (th == null) {
                return 0;
            }
            if (!(th instanceof CommandException)) {
                CellularDataService cellularDataService = CellularDataService.this;
                cellularDataService.loge("Throwable is of type " + th.getClass().getSimpleName() + " but should be CommandException");
                return 4;
            } else if (((CommandException) th).getCommandError() == CommandException.Error.REQUEST_NOT_SUPPORTED) {
                return 1;
            } else {
                return 4;
            }
        }

        public void setupDataCall(int i, DataProfile dataProfile, boolean z, boolean z2, int i2, LinkProperties linkProperties, int i3, NetworkSliceInfo networkSliceInfo, TrafficDescriptor trafficDescriptor, boolean z3, DataServiceCallback dataServiceCallback) {
            Message message;
            DataServiceCallback dataServiceCallback2 = dataServiceCallback;
            if (dataServiceCallback2 != null) {
                message = Message.obtain(this.mHandler, 1);
                this.mCallbackMap.put(message, dataServiceCallback2);
            } else {
                message = null;
            }
            this.mPhone.mCi.setupDataCall(i, dataProfile, z, z2, i2, linkProperties, i3, networkSliceInfo, trafficDescriptor, z3, message);
        }

        public void deactivateDataCall(int i, int i2, DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 2);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.deactivateDataCall(i, i2, message);
        }

        public void setInitialAttachApn(DataProfile dataProfile, boolean z, DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 3);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.setInitialAttachApn(dataProfile, z, message);
        }

        public void setDataProfile(List<DataProfile> list, boolean z, DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 4);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.setDataProfile((DataProfile[]) list.toArray(new DataProfile[list.size()]), z, message);
        }

        public void requestDataCallList(DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 5);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.getDataCallList(message);
        }

        public void startHandover(int i, DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 7);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.startHandover(message, i);
        }

        public void cancelHandover(int i, DataServiceCallback dataServiceCallback) {
            Message message;
            if (dataServiceCallback != null) {
                message = Message.obtain(this.mHandler, 8);
                this.mCallbackMap.put(message, dataServiceCallback);
            } else {
                message = null;
            }
            this.mPhone.mCi.cancelHandover(message, i);
        }

        public void close() {
            this.mPhone.mCi.unregisterForDataCallListChanged(this.mHandler);
        }
    }

    public DataService.DataServiceProvider onCreateDataServiceProvider(int i) {
        log("Cellular data service created for slot " + i);
        if (SubscriptionManager.isValidSlotIndex(i)) {
            return new CellularDataServiceProvider(i);
        }
        loge("Tried to cellular data service with invalid slotId " + i);
        return null;
    }

    private void log(String str) {
        Rlog.d(TAG, str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e(TAG, str);
    }
}
