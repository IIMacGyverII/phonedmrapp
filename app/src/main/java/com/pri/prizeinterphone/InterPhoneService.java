package com.pri.prizeinterphone;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.PowerManager;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.notification.MyNotificationManager;
import com.pri.prizeinterphone.serial.SerialManager;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.ymodem.YModemManager;
/* loaded from: classes4.dex */
public class InterPhoneService extends Service {
    public static final int MSG_UPDATE_ACTIVITY_DESTROY_2_SVC = 131;
    public static final int MSG_UPDATE_FIRMWARE_2_CLT = 130;
    public static final int MSG_UPDATE_FIRMWARE_2_SVC = 129;
    public static final int MSG_UPDATE_NOTIFICATION = 128;
    private static final String TAG = "InterPhoneService";
    private Handler mHandler = new Handler() { // from class: com.pri.prizeinterphone.InterPhoneService.1
        @Override // android.os.Handler
        public void handleMessage(@NonNull Message message) {
            super.handleMessage(message);
            int i = message.what;
            if (i == 128) {
                InterPhoneService interPhoneService = InterPhoneService.this;
                interPhoneService.startForegroundNotification(interPhoneService.getChannelDataStr((ChannelData) message.obj));
            } else if (i == 129) {
                YModemManager.getInstance().registerCallbackMessenger(message.replyTo);
                InterPhoneService.this.startUpdateFirmware();
            } else if (i != 131) {
            } else {
                YModemManager.getInstance().unregisterCallbackMessenger(message.replyTo);
            }
        }
    };
    private Messenger mMessengerServices = new Messenger(this.mHandler);
    private PowerManager mPowerManager;
    private PowerManager.WakeLock mWakeLock;

    @Override // android.app.Service
    @Nullable
    public IBinder onBind(Intent intent) {
        Log.d(TAG, "onBind,");
        return this.mMessengerServices.getBinder();
    }

    @Override // android.app.Service
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate," + this);
        startForegroundNotification(getString(R.string.interphone_service_running));
        DmrManager.getInstance().initSerialPort();
        PowerManager powerManager = (PowerManager) getSystemService(XmlTagConst.TAG_POWER);
        this.mPowerManager = powerManager;
        PowerManager.WakeLock newWakeLock = powerManager.newWakeLock(1, "dmr_service");
        this.mWakeLock = newWakeLock;
        newWakeLock.acquire();
    }

    @Override // android.app.Service
    public int onStartCommand(Intent intent, int i, int i2) {
        Log.d(TAG, "onStartCommand," + this);
        return super.onStartCommand(intent, i, i2);
    }

    @Override // android.app.Service
    public void onDestroy() {
        Log.d(TAG, "onDestroy," + this);
        if (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
        if (!YModemManager.getInstance().isRunning()) {
            ReadFileUtils.getInstance().pullDownPwdFoot();
        }
        stopForegroundService();
        super.onDestroy();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public String getChannelDataStr(ChannelData channelData) {
        Log.d(TAG, "updateNotification channelData = " + channelData);
        String str = channelData.name;
        if (str == null || str.equals("")) {
            if (channelData.type == 0) {
                str = getString(R.string.interphone_channel_type_digital) + " " + (channelData.number + 1);
            } else {
                str = getString(R.string.interphone_channel_type_analog) + " " + (channelData.number + 1);
            }
        }
        String str2 = channelData.txFreq + "";
        String str3 = channelData.rxFreq + "";
        return str + "\n" + Constants.getChannelAreaName(this) + "  " + ("TX:" + str2.substring(0, 3) + "." + str2.substring(3, str2.length())) + ("  RX:" + str3.substring(0, 3) + "." + str3.substring(3, str3.length()));
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void startForegroundNotification(String str) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
            startForeground(1, MyNotificationManager.getInstance().getStartHomeLauncherNotification(str), 
                android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE);
        } else {
            startForeground(1, MyNotificationManager.getInstance().getStartHomeLauncherNotification(str));
        }
    }

    public void stopForegroundService() {
        stopForeground(true);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void startUpdateFirmware() {
        SerialManager.getInstance().releaseReader();
        SerialManager.getInstance().releaseWriter();
        YModemManager.getInstance().startUpdateFirmware();
    }
}
