package com.android.internal.telephony;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.telephony.Rlog;

public class MockModem {
    static final int BINDER_MAX_RETRY = 3;
    static final int BINDER_RETRY_MILLIS = 300;
    private static final String BIND_IRADIOCONFIG = "android.telephony.mockmodem.iradioconfig";
    private static final String BIND_IRADIODATA = "android.telephony.mockmodem.iradiodata";
    private static final String BIND_IRADIOMESSAGING = "android.telephony.mockmodem.iradiomessaging";
    private static final String BIND_IRADIOMODEM = "android.telephony.mockmodem.iradiomodem";
    private static final String BIND_IRADIONETWORK = "android.telephony.mockmodem.iradionetwork";
    private static final String BIND_IRADIOSIM = "android.telephony.mockmodem.iradiosim";
    private static final String BIND_IRADIOVOICE = "android.telephony.mockmodem.iradiovoice";
    private static final byte DEFAULT_PHONE_ID = 0;
    private static final String PHONE_ID = "phone_id";
    static final int RADIOCONFIG_SERVICE = 7;
    private static final String TAG = "MockModem";
    /* access modifiers changed from: private */
    public IBinder mConfigBinder;
    private ServiceConnection mConfigServiceConnection;
    private Context mContext;
    /* access modifiers changed from: private */
    public IBinder mDataBinder;
    private ServiceConnection mDataServiceConnection;
    /* access modifiers changed from: private */
    public IBinder mMessagingBinder;
    private ServiceConnection mMessagingServiceConnection;
    /* access modifiers changed from: private */
    public IBinder mModemBinder;
    private ServiceConnection mModemServiceConnection;
    /* access modifiers changed from: private */
    public IBinder mNetworkBinder;
    private ServiceConnection mNetworkServiceConnection;
    private String mPackageName;
    private byte mPhoneId;
    private String mServiceName;
    /* access modifiers changed from: private */
    public IBinder mSimBinder;
    private ServiceConnection mSimServiceConnection;
    /* access modifiers changed from: private */
    public IBinder mVoiceBinder;
    private ServiceConnection mVoiceServiceConnection;

    /* access modifiers changed from: private */
    public String getModuleName(int i) {
        switch (i) {
            case 1:
                return "data";
            case 2:
                return "messaging";
            case 3:
                return "modem";
            case 4:
                return "network";
            case 5:
                return NotificationChannelController.CHANNEL_ID_SIM;
            case 6:
                return "voice";
            case 7:
                return "config";
            default:
                return "none";
        }
    }

    MockModem(Context context, String str) {
        this(context, str, 0);
    }

    MockModem(Context context, String str, int i) {
        this.mPhoneId = (byte) i;
        this.mContext = context;
        String[] split = str.split("/", 2);
        this.mPackageName = split[0];
        this.mServiceName = split[1];
    }

    private class MockModemConnection implements ServiceConnection {
        private int mService;

        MockModemConnection(int i) {
            this.mService = i;
        }

        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            Rlog.d(MockModem.TAG, "IRadio " + MockModem.this.getModuleName(this.mService) + "  - onServiceConnected");
            int i = this.mService;
            if (i == 3) {
                MockModem.this.mModemBinder = iBinder;
            } else if (i == 5) {
                MockModem.this.mSimBinder = iBinder;
            } else if (i == 2) {
                MockModem.this.mMessagingBinder = iBinder;
            } else if (i == 1) {
                MockModem.this.mDataBinder = iBinder;
            } else if (i == 4) {
                MockModem.this.mNetworkBinder = iBinder;
            } else if (i == 6) {
                MockModem.this.mVoiceBinder = iBinder;
            } else if (i == 7) {
                MockModem.this.mConfigBinder = iBinder;
            }
        }

        public void onServiceDisconnected(ComponentName componentName) {
            Rlog.d(MockModem.TAG, "IRadio " + MockModem.this.getModuleName(this.mService) + "  - onServiceDisconnected");
            int i = this.mService;
            if (i == 3) {
                MockModem.this.mModemBinder = null;
            } else if (i == 5) {
                MockModem.this.mSimBinder = null;
            } else if (i == 2) {
                MockModem.this.mMessagingBinder = null;
            } else if (i == 1) {
                MockModem.this.mDataBinder = null;
            } else if (i == 4) {
                MockModem.this.mNetworkBinder = null;
            } else if (i == 6) {
                MockModem.this.mVoiceBinder = null;
            } else if (i == 7) {
                MockModem.this.mConfigBinder = null;
            }
        }
    }

    private boolean bindModuleToMockModemService(String str, ServiceConnection serviceConnection) {
        return bindModuleToMockModemService((byte) 0, str, serviceConnection);
    }

    private boolean bindModuleToMockModemService(byte b, String str, ServiceConnection serviceConnection) {
        Intent intent = new Intent();
        intent.setComponent(new ComponentName(this.mPackageName, this.mServiceName));
        intent.setAction(str);
        intent.putExtra(PHONE_ID, b);
        return this.mContext.bindService(intent, serviceConnection, 1);
    }

    public IBinder getServiceBinder(int i) {
        switch (i) {
            case 1:
                return this.mDataBinder;
            case 2:
                return this.mMessagingBinder;
            case 3:
                return this.mModemBinder;
            case 4:
                return this.mNetworkBinder;
            case 5:
                return this.mSimBinder;
            case 6:
                return this.mVoiceBinder;
            case 7:
                return this.mConfigBinder;
            default:
                return null;
        }
    }

    public void bindAllMockModemService() {
        for (int i = 0; i <= 6; i++) {
            bindToMockModemService(i);
        }
    }

    public void bindToMockModemService(int i) {
        if (i == 7) {
            if (this.mConfigBinder == null) {
                MockModemConnection mockModemConnection = new MockModemConnection(7);
                this.mConfigServiceConnection = mockModemConnection;
                if (!bindModuleToMockModemService(BIND_IRADIOCONFIG, mockModemConnection)) {
                    Rlog.d(TAG, "IRadio Config bind fail");
                    this.mConfigServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Config is bound");
        } else if (i == 3) {
            if (this.mModemBinder == null) {
                MockModemConnection mockModemConnection2 = new MockModemConnection(3);
                this.mModemServiceConnection = mockModemConnection2;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIOMODEM, mockModemConnection2)) {
                    Rlog.d(TAG, "IRadio Modem bind fail");
                    this.mModemServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Modem is bound");
        } else if (i == 5) {
            if (this.mSimBinder == null) {
                MockModemConnection mockModemConnection3 = new MockModemConnection(5);
                this.mSimServiceConnection = mockModemConnection3;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIOSIM, mockModemConnection3)) {
                    Rlog.d(TAG, "IRadio Sim bind fail");
                    this.mSimServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Sim is bound");
        } else if (i == 2) {
            if (this.mMessagingBinder == null) {
                MockModemConnection mockModemConnection4 = new MockModemConnection(2);
                this.mMessagingServiceConnection = mockModemConnection4;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIOMESSAGING, mockModemConnection4)) {
                    Rlog.d(TAG, "IRadio Messaging bind fail");
                    this.mMessagingServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Messaging is bound");
        } else if (i == 1) {
            if (this.mDataBinder == null) {
                MockModemConnection mockModemConnection5 = new MockModemConnection(1);
                this.mDataServiceConnection = mockModemConnection5;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIODATA, mockModemConnection5)) {
                    Rlog.d(TAG, "IRadio Data bind fail");
                    this.mDataServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Data is bound");
        } else if (i == 4) {
            if (this.mNetworkBinder == null) {
                MockModemConnection mockModemConnection6 = new MockModemConnection(4);
                this.mNetworkServiceConnection = mockModemConnection6;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIONETWORK, mockModemConnection6)) {
                    Rlog.d(TAG, "IRadio Network bind fail");
                    this.mNetworkServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Network is bound");
        } else if (i != 6) {
        } else {
            if (this.mVoiceBinder == null) {
                MockModemConnection mockModemConnection7 = new MockModemConnection(6);
                this.mVoiceServiceConnection = mockModemConnection7;
                if (!bindModuleToMockModemService(this.mPhoneId, BIND_IRADIOVOICE, mockModemConnection7)) {
                    Rlog.d(TAG, "IRadio Voice bind fail");
                    this.mVoiceServiceConnection = null;
                    return;
                }
                return;
            }
            Rlog.d(TAG, "IRadio Voice is bound");
        }
    }

    public void unbindMockModemService(int i) {
        ServiceConnection serviceConnection;
        if (i == 7) {
            ServiceConnection serviceConnection2 = this.mConfigServiceConnection;
            if (serviceConnection2 != null) {
                this.mContext.unbindService(serviceConnection2);
                this.mConfigServiceConnection = null;
                this.mConfigBinder = null;
                Rlog.d(TAG, "unbind IRadio Config");
            }
        } else if (i == 3) {
            ServiceConnection serviceConnection3 = this.mModemServiceConnection;
            if (serviceConnection3 != null) {
                this.mContext.unbindService(serviceConnection3);
                this.mModemServiceConnection = null;
                this.mModemBinder = null;
                Rlog.d(TAG, "unbind IRadio Modem");
            }
        } else if (i == 5) {
            ServiceConnection serviceConnection4 = this.mSimServiceConnection;
            if (serviceConnection4 != null) {
                this.mContext.unbindService(serviceConnection4);
                this.mSimServiceConnection = null;
                this.mSimBinder = null;
                Rlog.d(TAG, "unbind IRadio Sim");
            }
        } else if (i == 2) {
            ServiceConnection serviceConnection5 = this.mMessagingServiceConnection;
            if (serviceConnection5 != null) {
                this.mContext.unbindService(serviceConnection5);
                this.mMessagingServiceConnection = null;
                this.mMessagingBinder = null;
                Rlog.d(TAG, "unbind IRadio Messaging");
            }
        } else if (i == 1) {
            ServiceConnection serviceConnection6 = this.mDataServiceConnection;
            if (serviceConnection6 != null) {
                this.mContext.unbindService(serviceConnection6);
                this.mDataServiceConnection = null;
                this.mDataBinder = null;
                Rlog.d(TAG, "unbind IRadio Data");
            }
        } else if (i == 4) {
            ServiceConnection serviceConnection7 = this.mNetworkServiceConnection;
            if (serviceConnection7 != null) {
                this.mContext.unbindService(serviceConnection7);
                this.mNetworkServiceConnection = null;
                this.mNetworkBinder = null;
                Rlog.d(TAG, "unbind IRadio Network");
            }
        } else if (i == 6 && (serviceConnection = this.mVoiceServiceConnection) != null) {
            this.mContext.unbindService(serviceConnection);
            this.mVoiceServiceConnection = null;
            this.mVoiceBinder = null;
            Rlog.d(TAG, "unbind IRadio Voice");
        }
    }

    public String getServiceName() {
        return this.mServiceName;
    }
}
