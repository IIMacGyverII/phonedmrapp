package com.pri.prizeinterphone.activity;

import android.app.Instrumentation;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.widget.NumberProgressBar;
import com.pri.prizeinterphone.ymodem.YModemManager;
import com.pri.prizeinterphone.ymodem.YModemTXMsg;

public class UpdateFirmwareActivity extends AppCompatActivity implements View.OnClickListener {
    private static final int MSG_CONNECTED_SVC_FAILED = 81;
    private static final int MSG_CONNECTED_SVC_SUCCEED = 80;
    private static final String TAG = "UpdateFirmwareAct";
    private boolean isEnd = false;
    /* access modifiers changed from: private */
    public boolean isRunning = false;
    private Messenger mClientMessenger = new Messenger(this.mHandler);
    /* access modifiers changed from: private */
    public Handler mHandler = new Handler() {
        public void handleMessage(@NonNull Message message) {
            int i = message.what;
            if (i == 80) {
                if (YModemManager.getInstance().isRunning() || !Util.isDmrUpdateIdle() || YModemManager.getInstance().isExternalSdcardHaveFirmware()) {
                    UpdateFirmwareActivity.this.mTvContent.setText(R.string.interphone_update_firmware_content2);
                    UpdateFirmwareActivity.this.mLeftBt.setVisibility(8);
                    UpdateFirmwareActivity.this.mRightBt.setText(R.string.interphone_update_firmware_right_text2);
                    UpdateFirmwareActivity.this.mNumberProgressBar.setVisibility(0);
                    UpdateFirmwareActivity.this.mNumberProgressBar.setProgress(0);
                    UpdateFirmwareActivity.this.startUpdateFirmware();
                    UpdateFirmwareActivity.this.isRunning = true;
                }
                UpdateFirmwareActivity.this.mRightBt.setEnabled(true);
            } else if (i != 81) {
                if (i == 130) {
                    UpdateFirmwareActivity.this.handleMsgFromSvc((YModemTXMsg) message.obj);
                }
            } else if (!UpdateFirmwareActivity.this.mIsSvcBind && UpdateFirmwareActivity.this.mMessenger == null) {
                Log.e(UpdateFirmwareActivity.TAG, "can not bind interphone service,finish()");
                UpdateFirmwareActivity.this.finish();
            }
        }
    };
    /* access modifiers changed from: private */
    public boolean mIsSvcBind = false;
    /* access modifiers changed from: private */
    public Button mLeftBt;
    /* access modifiers changed from: private */
    public Messenger mMessenger = null;
    /* access modifiers changed from: private */
    public NumberProgressBar mNumberProgressBar;
    /* access modifiers changed from: private */
    public Button mRightBt;
    private final ServiceConnection mServiceConnection = new ServiceConnection() {
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            UpdateFirmwareActivity.this.mMessenger = new Messenger(iBinder);
            UpdateFirmwareActivity.this.mIsSvcBind = true;
            UpdateFirmwareActivity.this.mHandler.removeMessages(81);
            UpdateFirmwareActivity.this.mHandler.sendEmptyMessageDelayed(80, 0);
            Log.d(UpdateFirmwareActivity.TAG, "onServiceConnected,connect to bind service ");
        }

        public void onServiceDisconnected(ComponentName componentName) {
            UpdateFirmwareActivity.this.mMessenger = null;
            UpdateFirmwareActivity.this.mIsSvcBind = false;
            Log.d(UpdateFirmwareActivity.TAG, "onServiceDisconnected, name = " + componentName);
        }
    };
    /* access modifiers changed from: private */
    public TextView mTvContent;

    public void onBackPressed() {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Log.d(TAG, "onCreate");
        setContentView((int) R.layout.activity_update_firmware);
        setTitle("");
        this.mHandler.sendEmptyMessageDelayed(81, 1500);
        setWindowLayoutParams();
        initView();
        setFinishOnTouchOutside(false);
    }

    private void initView() {
        Button button = (Button) findViewById(R.id.left_bt);
        this.mLeftBt = button;
        button.setOnClickListener(this);
        Button button2 = (Button) findViewById(R.id.right_bt);
        this.mRightBt = button2;
        button2.setOnClickListener(this);
        this.mRightBt.setEnabled(false);
        this.mNumberProgressBar = (NumberProgressBar) findViewById(R.id.update_bar);
        this.mTvContent = (TextView) findViewById(R.id.tv_content);
    }

    private void bindInterPhoneService() {
        if (!this.mIsSvcBind || this.mMessenger == null) {
            bindService(new Intent(this, InterPhoneService.class), this.mServiceConnection, 1);
        }
    }

    private void unbindInterPhoneService() {
        if (this.mIsSvcBind || this.mMessenger != null) {
            unbindService(this.mServiceConnection);
            this.mMessenger = null;
            this.mIsSvcBind = false;
        }
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        Log.d(TAG, "onResume");
        bindInterPhoneService();
        super.onResume();
    }

    /* access modifiers changed from: protected */
    public void onPause() {
        Log.d(TAG, "onPause");
        super.onPause();
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        super.onDestroy();
        updateActivityDestroy();
        unbindInterPhoneService();
        this.mHandler.removeCallbacksAndMessages((Object) null);
    }

    private void setWindowLayoutParams() {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (((float) i) * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
        window.addFlags(128);
    }

    public void onClick(View view) {
        int id = view.getId();
        if (id != R.id.left_bt) {
            if (id == R.id.right_bt) {
                if (this.isRunning) {
                    new Thread(new UpdateFirmwareActivity$$ExternalSyntheticLambda0(new Instrumentation())).start();
                    return;
                }
                this.mRightBt.setEnabled(false);
                startUpdateFirmware();
            }
        } else if (this.isEnd) {
            DmrManager.getInstance().restartApp();
        } else {
            stopService(new Intent(this, InterPhoneService.class));
            YModemManager.getInstance().releaseYModem();
            ReadFileUtils.getInstance().pullDownPwdFoot();
            DmrManager.getInstance().releaseSerialPort();
            System.exit(0);
        }
    }

    /* access modifiers changed from: private */
    public void startUpdateFirmware() {
        if (this.mMessenger != null) {
            Message obtain = Message.obtain();
            obtain.replyTo = this.mClientMessenger;
            obtain.what = 129;
            try {
                this.mMessenger.send(obtain);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }

    private void updateActivityDestroy() {
        if (this.mMessenger != null) {
            Message obtain = Message.obtain();
            obtain.replyTo = this.mClientMessenger;
            obtain.what = InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC;
            try {
                this.mMessenger.send(obtain);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }

    /* access modifiers changed from: private */
    public void handleMsgFromSvc(YModemTXMsg yModemTXMsg) {
        if (yModemTXMsg != null) {
            int step = yModemTXMsg.getStep();
            if (step == 2) {
                this.mTvContent.setText(R.string.interphone_update_firmware_content2);
                this.mLeftBt.setVisibility(8);
                this.mRightBt.setText(R.string.interphone_update_firmware_right_text2);
                this.mNumberProgressBar.setVisibility(0);
                this.mNumberProgressBar.setProgress(0);
                this.mRightBt.setEnabled(true);
            } else if (step == 4) {
                this.mNumberProgressBar.setProgress(0);
            } else if (step == 8) {
                double currentSent = (((double) yModemTXMsg.getCurrentSent()) / ((double) yModemTXMsg.getTotal())) * 100.0d;
                if (Math.round(currentSent) != 100) {
                    this.mNumberProgressBar.setProgress((int) Math.round(currentSent));
                }
            } else if (step == 32) {
                this.isEnd = true;
                this.mTvContent.setText(R.string.interphone_update_firmware_content3);
                this.mNumberProgressBar.setProgress(100);
                this.mLeftBt.setVisibility(0);
                this.mRightBt.setVisibility(8);
                this.mNumberProgressBar.setVisibility(8);
                this.mLeftBt.setText(R.string.interphone_update_firmware_left_text2);
            } else if (step == 64) {
                this.isEnd = true;
                this.mNumberProgressBar.setVisibility(8);
                this.mTvContent.setText(R.string.interphone_update_firmware_content4);
                this.mLeftBt.setVisibility(0);
                this.mRightBt.setVisibility(8);
                this.mLeftBt.setText(R.string.interphone_update_firmware_left_text3);
            }
        }
    }
}
