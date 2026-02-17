package com.android.internal.telephony;

import android.content.Context;
import android.os.Binder;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.telephony.CarrierConfigManager;
import android.telephony.SmsMessage;
import android.telephony.ims.ImsMmTelManager;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.RegistrationManager;
import android.telephony.ims.aidl.IImsSmsListener;
import android.telephony.ims.feature.MmTelFeature;
import androidx.core.os.EnvironmentCompat;
import com.android.ims.FeatureConnector;
import com.android.ims.ImsException;
import com.android.ims.ImsManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.SMSDispatcher;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.util.SMSDispatcherUtil;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicInteger;

public class ImsSmsDispatcher extends SMSDispatcher {
    private static final int CONNECT_DELAY_MS = 5000;
    private static final String TAG = "ImsSmsDispatcher";
    private ImsMmTelManager.CapabilityCallback mCapabilityCallback = new ImsMmTelManager.CapabilityCallback() {
        public void onCapabilitiesStatusChanged(MmTelFeature.MmTelCapabilities mmTelCapabilities) {
            synchronized (ImsSmsDispatcher.this.mLock) {
                ImsSmsDispatcher.this.mIsSmsCapable = mmTelCapabilities.isCapable(8);
            }
        }
    };
    /* access modifiers changed from: private */
    public Runnable mConnectRunnable = new Runnable() {
        public void run() {
            ImsSmsDispatcher.this.mImsManagerConnector.connect();
        }
    };
    private FeatureConnectorFactory mConnectorFactory;
    /* access modifiers changed from: private */
    public ImsManager mImsManager;
    /* access modifiers changed from: private */
    public final FeatureConnector<ImsManager> mImsManagerConnector;
    private final IImsSmsListener mImsSmsListener = new IImsSmsListener.Stub() {
        public void onSendSmsResult(int i, int i2, int i3, int i4, int i5) {
            int i6 = i2;
            int i7 = i3;
            int i8 = i4;
            int i9 = i5;
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                ImsSmsDispatcher.this.logd("onSendSmsResult token=" + i + " messageRef=" + i6 + " status=" + i7 + " reason=" + i8 + " networkReasonCode=" + i9);
                SMSDispatcher.SmsTracker smsTracker = ImsSmsDispatcher.this.mTrackers.get(Integer.valueOf(i));
                ImsSmsDispatcher.this.mMetrics.writeOnImsServiceSmsSolicitedResponse(ImsSmsDispatcher.this.mPhone.getPhoneId(), i3, i4, smsTracker != null ? smsTracker.mMessageId : 0);
                if (smsTracker != null) {
                    smsTracker.mMessageRef = i6;
                    if (i7 == 1) {
                        if (smsTracker.mDeliveryIntent != null) {
                            ImsSmsDispatcher.this.mSmsDispatchersController.putDeliveryPendingTracker(smsTracker);
                        }
                        smsTracker.onSent(ImsSmsDispatcher.this.mContext);
                        ImsSmsDispatcher.this.mTrackers.remove(Integer.valueOf(i));
                        ImsSmsDispatcher.this.mPhone.notifySmsSent(smsTracker.mDestAddress);
                    } else if (i7 == 2) {
                        smsTracker.onFailed(ImsSmsDispatcher.this.mContext, i8, i9);
                        ImsSmsDispatcher.this.mTrackers.remove(Integer.valueOf(i));
                    } else if (i7 == 3) {
                        int i10 = smsTracker.mRetryCount;
                        if (i10 < 3) {
                            smsTracker.mRetryCount = i10 + 1;
                            ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
                            imsSmsDispatcher.sendMessageDelayed(imsSmsDispatcher.obtainMessage(3, smsTracker), LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
                        } else {
                            smsTracker.onFailed(ImsSmsDispatcher.this.mContext, i8, i9);
                            ImsSmsDispatcher.this.mTrackers.remove(Integer.valueOf(i));
                        }
                    } else if (i7 == 4) {
                        smsTracker.mRetryCount++;
                        ImsSmsDispatcher.this.mTrackers.remove(Integer.valueOf(i));
                        ImsSmsDispatcher.this.fallbackToPstn(smsTracker);
                    }
                    ImsSmsDispatcher.this.mPhone.getSmsStats().onOutgoingSms(true, "3gpp2".equals(ImsSmsDispatcher.this.getFormat()), i7 == 4, i4, smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(ImsSmsDispatcher.this.mContext), smsTracker.getInterval());
                    return;
                }
                throw new IllegalArgumentException("Invalid token.");
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        public void onSmsStatusReportReceived(int i, String str, byte[] bArr) throws RemoteException {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                ImsSmsDispatcher.this.logd("Status report received.");
                SmsMessage createFromPdu = SmsMessage.createFromPdu(bArr, str);
                if (createFromPdu == null || createFromPdu.mWrappedSmsMessage == null) {
                    throw new RemoteException("Status report received with a PDU that could not be parsed.");
                }
                ImsSmsDispatcher.this.mSmsDispatchersController.handleSmsStatusReport(str, bArr);
                ImsSmsDispatcher.this.getImsManager().acknowledgeSmsReport(i, createFromPdu.mWrappedSmsMessage.mMessageRef, 1);
                Binder.restoreCallingIdentity(clearCallingIdentity);
            } catch (ImsException e) {
                ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
                imsSmsDispatcher.loge("Failed to acknowledgeSmsReport(). Error: " + e.getMessage());
            } catch (Throwable th) {
                Binder.restoreCallingIdentity(clearCallingIdentity);
                throw th;
            }
        }

        public void onSmsReceived(int i, String str, byte[] bArr) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                ImsSmsDispatcher.this.logd("SMS received.");
                SmsMessage createFromPdu = SmsMessage.createFromPdu(bArr, str);
                ImsSmsDispatcher.this.mSmsDispatchersController.injectSmsPdu(createFromPdu, str, new ImsSmsDispatcher$4$$ExternalSyntheticLambda0(this, createFromPdu, i), true, true);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$onSmsReceived$0(SmsMessage smsMessage, int i, int i2) {
            ImsSmsDispatcher.this.logd("SMS handled result: " + i2);
            int i3 = 4;
            if (i2 == 1) {
                i3 = 1;
            } else if (i2 == 3) {
                i3 = 3;
            } else if (i2 != 4) {
                i3 = 2;
            }
            if (smsMessage != null) {
                try {
                    if (smsMessage.mWrappedSmsMessage != null) {
                        ImsSmsDispatcher.this.getImsManager().acknowledgeSms(i, smsMessage.mWrappedSmsMessage.mMessageRef, i3);
                        return;
                    }
                } catch (ImsException e) {
                    ImsSmsDispatcher.this.loge("Failed to acknowledgeSms(). Error: " + e.getMessage());
                    return;
                }
            }
            ImsSmsDispatcher.this.logw("SMS Received with a PDU that could not be parsed.");
            ImsSmsDispatcher.this.getImsManager().acknowledgeSms(i, 0, i3);
        }
    };
    /* access modifiers changed from: private */
    public volatile boolean mIsImsServiceUp;
    /* access modifiers changed from: private */
    public volatile boolean mIsRegistered;
    /* access modifiers changed from: private */
    public volatile boolean mIsSmsCapable;
    /* access modifiers changed from: private */
    public final Object mLock = new Object();
    /* access modifiers changed from: private */
    public TelephonyMetrics mMetrics = TelephonyMetrics.getInstance();
    @VisibleForTesting
    public AtomicInteger mNextToken = new AtomicInteger();
    private RegistrationManager.RegistrationCallback mRegistrationCallback = new RegistrationManager.RegistrationCallback() {
        public void onRegistered(int i) {
            ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
            imsSmsDispatcher.logd("onImsConnected imsRadioTech=" + i);
            synchronized (ImsSmsDispatcher.this.mLock) {
                ImsSmsDispatcher.this.mIsRegistered = true;
            }
        }

        public void onRegistering(int i) {
            ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
            imsSmsDispatcher.logd("onImsProgressing imsRadioTech=" + i);
            synchronized (ImsSmsDispatcher.this.mLock) {
                ImsSmsDispatcher.this.mIsRegistered = false;
            }
        }

        public void onUnregistered(ImsReasonInfo imsReasonInfo) {
            ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
            imsSmsDispatcher.logd("onImsDisconnected imsReasonInfo=" + imsReasonInfo);
            synchronized (ImsSmsDispatcher.this.mLock) {
                ImsSmsDispatcher.this.mIsRegistered = false;
            }
        }
    };
    @VisibleForTesting
    public Map<Integer, SMSDispatcher.SmsTracker> mTrackers = new ConcurrentHashMap();

    @VisibleForTesting
    public interface FeatureConnectorFactory {
        FeatureConnector<ImsManager> create(Context context, int i, String str, FeatureConnector.Listener<ImsManager> listener, Executor executor);
    }

    /* access modifiers changed from: protected */
    public boolean shouldBlockSmsForEcbm() {
        return false;
    }

    public void handleMessage(Message message) {
        if (message.what != 3) {
            super.handleMessage(message);
            return;
        }
        logd("SMS retry..");
        sendSms((SMSDispatcher.SmsTracker) message.obj);
    }

    public ImsSmsDispatcher(Phone phone, SmsDispatchersController smsDispatchersController, FeatureConnectorFactory featureConnectorFactory) {
        super(phone, smsDispatchersController);
        this.mConnectorFactory = featureConnectorFactory;
        this.mImsManagerConnector = featureConnectorFactory.create(this.mContext, this.mPhone.getPhoneId(), TAG, new FeatureConnector.Listener<ImsManager>() {
            public void connectionReady(ImsManager imsManager, int i) throws ImsException {
                ImsSmsDispatcher.this.logd("ImsManager: connection ready.");
                synchronized (ImsSmsDispatcher.this.mLock) {
                    ImsSmsDispatcher.this.mImsManager = imsManager;
                    ImsSmsDispatcher.this.setListeners();
                    ImsSmsDispatcher.this.mIsImsServiceUp = true;
                }
            }

            public void connectionUnavailable(int i) {
                ImsSmsDispatcher imsSmsDispatcher = ImsSmsDispatcher.this;
                imsSmsDispatcher.logd("ImsManager: connection unavailable, reason=" + i);
                if (i == 3) {
                    ImsSmsDispatcher.this.loge("connectionUnavailable: unexpected, received server error");
                    ImsSmsDispatcher imsSmsDispatcher2 = ImsSmsDispatcher.this;
                    imsSmsDispatcher2.removeCallbacks(imsSmsDispatcher2.mConnectRunnable);
                    ImsSmsDispatcher imsSmsDispatcher3 = ImsSmsDispatcher.this;
                    imsSmsDispatcher3.postDelayed(imsSmsDispatcher3.mConnectRunnable, 5000);
                }
                synchronized (ImsSmsDispatcher.this.mLock) {
                    ImsSmsDispatcher.this.mImsManager = null;
                    ImsSmsDispatcher.this.mIsImsServiceUp = false;
                }
            }
        }, new ImsSmsDispatcher$$ExternalSyntheticLambda0(this));
        post(this.mConnectRunnable);
    }

    /* access modifiers changed from: private */
    public void setListeners() throws ImsException {
        getImsManager().addRegistrationCallback(this.mRegistrationCallback, new ImsSmsDispatcher$$ExternalSyntheticLambda0(this));
        getImsManager().addCapabilitiesCallback(this.mCapabilityCallback, new ImsSmsDispatcher$$ExternalSyntheticLambda0(this));
        getImsManager().setSmsListener(getSmsListener());
        getImsManager().onSmsReady();
    }

    private boolean isLteService() {
        return this.mPhone.getServiceState().getRilDataRadioTechnology() == 14 && this.mPhone.getServiceState().getDataRegistrationState() == 0;
    }

    private boolean isLimitedLteService() {
        return this.mPhone.getServiceState().getRilVoiceRadioTechnology() == 14 && this.mPhone.getServiceState().isEmergencyOnly();
    }

    private boolean isEmergencySmsPossible() {
        return isLteService() || isLimitedLteService();
    }

    public boolean isEmergencySmsSupport(String str) {
        boolean z = false;
        if (!this.mTelephonyManager.isEmergencyNumber(str)) {
            logi(Rlog.pii(TAG, str) + " is not emergency number");
            return false;
        }
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mContext.getSystemService("carrier_config");
            if (carrierConfigManager == null) {
                loge("configManager is null");
                return false;
            }
            PersistableBundle configForSubId = carrierConfigManager.getConfigForSubId(getSubId());
            if (configForSubId == null) {
                loge("PersistableBundle is null");
                Binder.restoreCallingIdentity(clearCallingIdentity);
                return false;
            }
            boolean z2 = configForSubId.getBoolean("support_emergency_sms_over_ims_bool");
            boolean isEmergencySmsPossible = isEmergencySmsPossible();
            logi("isEmergencySmsSupport emergencySmsCarrierSupport: " + z2 + " destAddr: " + Rlog.pii(TAG, str) + " mIsImsServiceUp: " + this.mIsImsServiceUp + " lteOrLimitedLte: " + isEmergencySmsPossible);
            if (z2 && this.mIsImsServiceUp && isEmergencySmsPossible) {
                z = true;
            }
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return z;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public boolean isAvailable() {
        boolean z;
        synchronized (this.mLock) {
            logd("isAvailable: up=" + this.mIsImsServiceUp + ", reg= " + this.mIsRegistered + ", cap= " + this.mIsSmsCapable);
            z = this.mIsImsServiceUp && this.mIsRegistered && this.mIsSmsCapable;
        }
        return z;
    }

    public String getFormat() {
        if (this.mLock == null) {
            return EnvironmentCompat.MEDIA_UNKNOWN;
        }
        try {
            return getImsManager().getSmsFormat();
        } catch (ImsException e) {
            loge("Failed to get sms format. Error: " + e.getMessage());
            return EnvironmentCompat.MEDIA_UNKNOWN;
        }
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, String str3, boolean z, SmsHeader smsHeader, int i, int i2) {
        return SMSDispatcherUtil.getSubmitPdu(isCdmaMo(), str, str2, str3, z, smsHeader, i, i2);
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, int i, byte[] bArr, boolean z) {
        return SMSDispatcherUtil.getSubmitPdu(isCdmaMo(), str, str2, i, bArr, z);
    }

    /* access modifiers changed from: protected */
    public GsmAlphabet.TextEncodingDetails calculateLength(CharSequence charSequence, boolean z) {
        return SMSDispatcherUtil.calculateLength(isCdmaMo(), charSequence, z);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r4v1, resolved type: java.lang.Object} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r11v0, resolved type: byte[]} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void sendSms(com.android.internal.telephony.SMSDispatcher.SmsTracker r20) {
        /*
            r19 = this;
            r1 = r19
            r2 = r20
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r3 = "sendSms:  mRetryCount="
            r0.append(r3)
            int r3 = r2.mRetryCount
            r0.append(r3)
            java.lang.String r3 = " mMessageRef="
            r0.append(r3)
            int r3 = r2.mMessageRef
            r0.append(r3)
            java.lang.String r3 = " SS="
            r0.append(r3)
            com.android.internal.telephony.Phone r3 = r1.mPhone
            android.telephony.ServiceState r3 = r3.getServiceState()
            int r3 = r3.getState()
            r0.append(r3)
            java.lang.String r0 = r0.toString()
            r1.logd(r0)
            r0 = 1
            r2.mUsesImsServiceForIms = r0
            java.util.HashMap r3 = r20.getData()
            java.lang.String r4 = "pdu"
            java.lang.Object r4 = r3.get(r4)
            r11 = r4
            byte[] r11 = (byte[]) r11
            java.lang.String r4 = "smsc"
            java.lang.Object r3 = r3.get(r4)
            byte[] r3 = (byte[]) r3
            int r4 = r2.mRetryCount
            r5 = 0
            if (r4 <= 0) goto L_0x0056
            r10 = r0
            goto L_0x0057
        L_0x0056:
            r10 = r5
        L_0x0057:
            java.lang.String r4 = r19.getFormat()
            java.lang.String r6 = "3gpp"
            boolean r6 = r6.equals(r4)
            if (r6 == 0) goto L_0x0075
            if (r10 == 0) goto L_0x0075
            byte r6 = r11[r5]
            r7 = r6 & 1
            if (r7 != r0) goto L_0x0075
            r6 = r6 | 4
            byte r6 = (byte) r6
            r11[r5] = r6
            int r5 = r2.mMessageRef
            byte r5 = (byte) r5
            r11[r0] = r5
        L_0x0075:
            java.util.concurrent.atomic.AtomicInteger r0 = r1.mNextToken
            int r18 = r0.incrementAndGet()
            java.util.Map<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r0 = r1.mTrackers
            java.lang.Integer r5 = java.lang.Integer.valueOf(r18)
            r0.put(r5, r2)
            com.android.ims.ImsManager r5 = r19.getImsManager()     // Catch:{ ImsException -> 0x00ab }
            int r7 = r2.mMessageRef     // Catch:{ ImsException -> 0x00ab }
            if (r3 == 0) goto L_0x0091
            java.lang.String r0 = com.android.internal.telephony.uicc.IccUtils.bytesToHexString(r3)     // Catch:{ ImsException -> 0x00ab }
            goto L_0x0092
        L_0x0091:
            r0 = 0
        L_0x0092:
            r9 = r0
            r6 = r18
            r8 = r4
            r5.sendSms(r6, r7, r8, r9, r10, r11)     // Catch:{ ImsException -> 0x00ab }
            com.android.internal.telephony.metrics.TelephonyMetrics r12 = r1.mMetrics     // Catch:{ ImsException -> 0x00ab }
            com.android.internal.telephony.Phone r0 = r1.mPhone     // Catch:{ ImsException -> 0x00ab }
            int r13 = r0.getPhoneId()     // Catch:{ ImsException -> 0x00ab }
            r15 = 1
            long r5 = r2.mMessageId     // Catch:{ ImsException -> 0x00ab }
            r14 = r4
            r16 = r5
            r12.writeImsServiceSendSms(r13, r14, r15, r16)     // Catch:{ ImsException -> 0x00ab }
            goto L_0x0100
        L_0x00ab:
            r0 = move-exception
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r5 = "sendSms failed. Falling back to PSTN. Error: "
            r3.append(r5)
            java.lang.String r0 = r0.getMessage()
            r3.append(r0)
            java.lang.String r0 = r3.toString()
            r1.loge(r0)
            java.util.Map<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r0 = r1.mTrackers
            java.lang.Integer r3 = java.lang.Integer.valueOf(r18)
            r0.remove(r3)
            r19.fallbackToPstn(r20)
            com.android.internal.telephony.metrics.TelephonyMetrics r12 = r1.mMetrics
            com.android.internal.telephony.Phone r0 = r1.mPhone
            int r13 = r0.getPhoneId()
            r15 = 4
            long r5 = r2.mMessageId
            r14 = r4
            r16 = r5
            r12.writeImsServiceSendSms(r13, r14, r15, r16)
            com.android.internal.telephony.Phone r0 = r1.mPhone
            com.android.internal.telephony.metrics.SmsStats r5 = r0.getSmsStats()
            r6 = 1
            java.lang.String r0 = "3gpp2"
            boolean r7 = r0.equals(r4)
            r8 = 1
            r9 = 15
            long r10 = r2.mMessageId
            android.content.Context r0 = r1.mContext
            boolean r12 = r2.isFromDefaultSmsApplication(r0)
            long r13 = r20.getInterval()
            r5.onOutgoingSms(r6, r7, r8, r9, r10, r12, r13)
        L_0x0100:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.ImsSmsDispatcher.sendSms(com.android.internal.telephony.SMSDispatcher$SmsTracker):void");
    }

    /* access modifiers changed from: private */
    public ImsManager getImsManager() throws ImsException {
        ImsManager imsManager;
        synchronized (this.mLock) {
            imsManager = this.mImsManager;
            if (imsManager == null) {
                throw new ImsException("ImsManager not up", 106);
            }
        }
        return imsManager;
    }

    @VisibleForTesting
    public void fallbackToPstn(SMSDispatcher.SmsTracker smsTracker) {
        this.mSmsDispatchersController.sendRetrySms(smsTracker);
    }

    /* access modifiers changed from: protected */
    public boolean isCdmaMo() {
        return this.mSmsDispatchersController.isCdmaFormat(getFormat());
    }

    @VisibleForTesting
    public IImsSmsListener getSmsListener() {
        return this.mImsSmsListener;
    }

    /* access modifiers changed from: private */
    public void logd(String str) {
        Rlog.d("ImsSmsDispatcher [" + getPhoneId(this.mPhone) + "]", str);
    }

    private void logi(String str) {
        Rlog.i("ImsSmsDispatcher [" + getPhoneId(this.mPhone) + "]", str);
    }

    /* access modifiers changed from: private */
    public void logw(String str) {
        Rlog.w("ImsSmsDispatcher [" + getPhoneId(this.mPhone) + "]", str);
    }

    /* access modifiers changed from: private */
    public void loge(String str) {
        Rlog.e("ImsSmsDispatcher [" + getPhoneId(this.mPhone) + "]", str);
    }

    private static String getPhoneId(Phone phone) {
        return phone != null ? Integer.toString(phone.getPhoneId()) : "?";
    }
}
