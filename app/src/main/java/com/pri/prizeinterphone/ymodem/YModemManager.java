package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;
import androidx.collection.ArraySet;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.notification.MyNotificationManager;
import com.pri.prizeinterphone.serial.SerialManager;
import com.pri.prizeinterphone.serial.port.SerialPort;
import com.pri.prizeinterphone.ymodem.YModem;
import com.pri.prizeinterphone.ymodem.YModemTXMsg;
import java.io.File;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
/* loaded from: classes4.dex */
public class YModemManager {
    private static final String CUR_ASSETS_NAME;
    private static final String CUR_ASSETS_PATH;
    private static final String EXTERNAL_FILE_PATH;
    private static final String EXTERNAL_PATH_NAME = "/sdcard/DMR/DMRDEBUG.bin";
    public static final String TAG = "YModemManager";
    private static volatile YModemManager instance;
    private static ArraySet<Integer> mCanSendClientWhenOnDataReadySet;
    private Set<Messenger> mClientMessengers = Collections.synchronizedSet(new ArraySet());
    private Context mContext;
    private YModem mYModem;
    private YModemThread mYModemThread;

    static {
        String versionFromRes = DmrManager.getInstance().getVersionFromRes();
        CUR_ASSETS_NAME = versionFromRes;
        CUR_ASSETS_PATH = SourceScheme.ASSETS.getUriPrefix() + versionFromRes;
        EXTERNAL_FILE_PATH = SourceScheme.FILE.getUriPrefix() + EXTERNAL_PATH_NAME;
        ArraySet<Integer> arraySet = new ArraySet<>();
        mCanSendClientWhenOnDataReadySet = arraySet;
        arraySet.add(2);
        mCanSendClientWhenOnDataReadySet.add(4);
        mCanSendClientWhenOnDataReadySet.add(16);
        mCanSendClientWhenOnDataReadySet.add(32);
    }

    public void registerCallbackMessenger(Messenger messenger) {
        this.mClientMessengers.add(messenger);
    }

    public void unregisterCallbackMessenger(Messenger messenger) {
        this.mClientMessengers.remove(messenger);
    }

    public static YModemManager getInstance() {
        if (instance == null) {
            synchronized (SerialManager.class) {
                if (instance == null) {
                    instance = new YModemManager(PrizeInterPhoneApp.getContext());
                }
            }
        }
        return instance;
    }

    private YModemManager(Context context) {
        this.mContext = context;
    }

    private String getDmrFirmwarePath() {
        String str;
        if (isExternalSdcardHaveFirmware()) {
            str = EXTERNAL_FILE_PATH;
        } else {
            str = CUR_ASSETS_PATH;
        }
        Log.d(TAG, "getDmrFirmwarePath,path=" + str);
        return str;
    }

    private String getDmrFirmwareName() {
        String str = isExternalSdcardHaveFirmware() ? EXTERNAL_PATH_NAME : CUR_ASSETS_NAME;
        Log.d(TAG, "getDmrFirmwarePath,name=" + str);
        return str;
    }

    public boolean isExternalSdcardHaveFirmware() {
        return new File(EXTERNAL_PATH_NAME).exists();
    }

    public void setSerial(SerialPort serialPort) {
        YModemThread yModemThread = this.mYModemThread;
        if (yModemThread != null) {
            yModemThread.setSerial(serialPort);
        }
    }

    public void startUpdateFirmware() {
        Log.d(TAG, "startUpdateFirmware," + this);
        if (this.mYModemThread == null) {
            this.mYModemThread = new YModemThread(SerialManager.getInstance().getSerial());
        }
        if (this.mYModem == null) {
            YModem build = new YModem.Builder().with(this.mContext).filePath(getDmrFirmwarePath()).fileName(getDmrFirmwareName()).sendSize(1024).callback(new YModemListener() { // from class: com.pri.prizeinterphone.ymodem.YModemManager.1
                @Override // com.pri.prizeinterphone.ymodem.YModemListener
                public void onDataReady(byte[] bArr, int i) {
                    YModemManager.this.mYModemThread.write(bArr);
                    if (2 == i || 4 == i) {
                        YModemManager.this.notifyUpdate2Notification(i, 0);
                    }
                    if (YModemManager.this.mClientMessengers.isEmpty() || !YModemManager.mCanSendClientWhenOnDataReadySet.contains(Integer.valueOf(i))) {
                        return;
                    }
                    Message obtain = Message.obtain();
                    obtain.what = InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT;
                    obtain.obj = YModemTXMsg.YModemTXMsgBuilder.anYModemTXMsg().withStep(i).build();
                    Iterator it = YModemManager.this.mClientMessengers.iterator();
                    while (it.hasNext()) {
                        try {
                            ((Messenger) it.next()).send(obtain);
                        } catch (RemoteException e) {
                            it.remove();
                            Log.d(YModemManager.TAG, "onDataReady error", e);
                        }
                    }
                }

                @Override // com.pri.prizeinterphone.ymodem.YModemListener
                public void onProgress(int i, int i2) {
                    Log.d(YModemManager.TAG, "currentSent=" + i + ",total=" + i2);
                    int round = (int) Math.round((((double) i) / ((double) i2)) * 100.0d);
                    if (round != 100) {
                        YModemManager.this.notifyUpdate2Notification(8, round);
                    }
                    if (YModemManager.this.mClientMessengers.isEmpty()) {
                        return;
                    }
                    Message obtain = Message.obtain();
                    obtain.what = InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT;
                    obtain.obj = YModemTXMsg.YModemTXMsgBuilder.anYModemTXMsg().withStep(8).withTotal(i2).withCurrentSent(i).build();
                    Iterator it = YModemManager.this.mClientMessengers.iterator();
                    while (it.hasNext()) {
                        try {
                            ((Messenger) it.next()).send(obtain);
                        } catch (RemoteException e) {
                            it.remove();
                            Log.d(YModemManager.TAG, "onProgress error", e);
                        }
                    }
                }

                @Override // com.pri.prizeinterphone.ymodem.YModemListener
                public void onSuccess() {
                    Log.d(YModemManager.TAG, "onSuccess");
                    YModemManager.this.notifyUpdate2Notification(32, 100);
                    if (!YModemManager.this.mClientMessengers.isEmpty()) {
                        Message obtain = Message.obtain();
                        obtain.what = InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT;
                        obtain.obj = YModemTXMsg.YModemTXMsgBuilder.anYModemTXMsg().withStep(32).build();
                        Iterator it = YModemManager.this.mClientMessengers.iterator();
                        while (it.hasNext()) {
                            try {
                                ((Messenger) it.next()).send(obtain);
                            } catch (RemoteException e) {
                                it.remove();
                                Log.d(YModemManager.TAG, "onSuccess error", e);
                                Log.d(YModemManager.TAG, "onSuccess restart app");
                                DmrManager.getInstance().restartApp();
                            }
                        }
                    }
                    if (YModemManager.this.mYModemThread != null) {
                        YModemManager.this.mYModemThread.stopRead();
                    }
                    Util.setDMRUpdateStatusToNvram("1");
                }

                @Override // com.pri.prizeinterphone.ymodem.YModemListener
                public void onFailed(String str) {
                    Log.d(YModemManager.TAG, "onFailed,reason=" + str);
                    YModemManager.this.notifyUpdate2Notification(64, 100);
                    if (!YModemManager.this.mClientMessengers.isEmpty()) {
                        Message obtain = Message.obtain();
                        obtain.what = InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT;
                        obtain.obj = YModemTXMsg.YModemTXMsgBuilder.anYModemTXMsg().withStep(64).build();
                        Iterator it = YModemManager.this.mClientMessengers.iterator();
                        while (it.hasNext()) {
                            try {
                                ((Messenger) it.next()).send(obtain);
                            } catch (RemoteException e) {
                                it.remove();
                                Log.d(YModemManager.TAG, "onFailed error", e);
                                DmrManager.getInstance().restartApp();
                                Log.d(YModemManager.TAG, "onFailed restart app");
                            }
                        }
                    }
                    if (YModemManager.this.mYModemThread != null) {
                        YModemManager.this.mYModemThread.stopRead();
                    }
                    Util.setDMRUpdateStatusToNvram(Util.DMR_UPDATE_STATUS_ERROR);
                }
            }).build();
            this.mYModem = build;
            this.mYModemThread.setYModem(build);
        }
        if (!isRunning()) {
            Log.d(TAG, "start----------," + this);
            Util.setDMRUpdateStatusToNvram(Util.DMR_UPDATE_STATUS_UPDATING);
            ReadFileUtils.getInstance().setDmrUpdateCondition();
            this.mYModemThread.startRead();
            this.mYModem.start();
            return;
        }
        Log.d(TAG, "is already start----------," + this);
    }

    public boolean isRunning() {
        YModemThread yModemThread = this.mYModemThread;
        if (yModemThread != null) {
            return !yModemThread.isStop();
        }
        return false;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void notifyUpdate2Notification(int i, int i2) {
        MyNotificationManager.getInstance().notifyUpdate2Notification(i, i2);
    }

    public void releaseYModem() {
        YModemThread yModemThread = this.mYModemThread;
        if (yModemThread != null) {
            yModemThread.setYModem(null);
            this.mYModemThread.stopRead();
            this.mYModemThread = null;
        }
        YModem yModem = this.mYModem;
        if (yModem != null) {
            yModem.stop();
            this.mYModem = null;
        }
        if (this.mClientMessengers.isEmpty()) {
            return;
        }
        this.mClientMessengers.clear();
    }

    public boolean isNeedUpdateDmr() {
        int versionNumberFromModule = DmrManager.getInstance().getVersionNumberFromModule();
        Log.d(TAG, "isNeedUpdateDmr,versionNumberFromModule=" + versionNumberFromModule);
        int versionNumberFromRes = DmrManager.getInstance().getVersionNumberFromRes();
        Log.d(TAG, "isNeedUpdateDmr,versionNumberFromRes=" + versionNumberFromRes);
        return versionNumberFromRes > versionNumberFromModule;
    }
}
