package com.pri.prizeinterphone;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.RemoteException;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.view.WindowManagerGlobal;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentManager;
import androidx.viewpager.widget.ViewPager;
import com.google.android.material.snackbar.Snackbar;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.activity.UpdateFirmwareActivity;
import com.pri.prizeinterphone.fragment.BaseViewPagerFragment;
import com.pri.prizeinterphone.fragment.InterPhoneChannelFragment;
import com.pri.prizeinterphone.fragment.InterPhoneContactsFragment;
import com.pri.prizeinterphone.fragment.InterPhoneLocalFragment;
import com.pri.prizeinterphone.fragment.InterPhoneMessageFragment;
import com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment;
import com.pri.prizeinterphone.fragment.ViewPagerFragmentAdapter;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.manager.MessageLisenter;
import com.pri.prizeinterphone.manager.PCMReceiveManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.ConversationData;
import com.pri.prizeinterphone.serial.data.MessageData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import com.pri.prizeinterphone.ymodem.YModemManager;
import java.util.ArrayList;
import java.util.List;

public class InterPhoneHomeActivity extends AppCompatActivity implements DmrManager.UpdateChannelDataNotificationListener, MessageLisenter, DmrManager.UpdateListener, CmdStateMachine.InitializedFeedBack {
    private static final String TAG = "InterPhoneHomeAct";
    private String[] dangrousPermissions = {"android.permission.READ_EXTERNAL_STORAGE", "android.permission.WRITE_EXTERNAL_STORAGE", "android.permission.READ_PHONE_STATE", "android.permission.RECORD_AUDIO"};
    /* access modifiers changed from: private */
    public ViewPagerFragmentAdapter mAdapter;
    public Runnable mDismissRunnable = new Runnable() {
        public void run() {
            InterPhoneHomeActivity.this.dismissProgressDialog();
        }
    };
    private BaseViewPagerFragment mFmChannel;
    private BaseViewPagerFragment mFmContacts;
    private InterPhoneLocalFragment mFmLocal;
    private BaseViewPagerFragment mFmMessage;
    private InterPhoneTalkBackFragment mFmTalkBack;
    private FragmentManager mFragmentManager = getSupportFragmentManager();
    /* access modifiers changed from: private */
    public DmrManager.MessageListener mGlobalSetChannelMessageListener = new DmrManager.MessageListener() {
        public void errorEvent(Byte b) {
            if (b.byteValue() == 34 || b.byteValue() == 35) {
                Snackbar.make((View) InterPhoneHomeActivity.this.mLlInterPhoneTapView, (int) R.string.operate_set_channel_fail_and_restart, -2).show();
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneHomeActivity.this.mGlobalSetChannelMessageListener);
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneHomeActivity.this.mGlobalSetChannelMessageListener);
            }
        }

        public void dealEvent(BaseMessage baseMessage) {
            byte b = baseMessage.packet.cmd;
            if (b == 34 || b == 35) {
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneHomeActivity.this.mGlobalSetChannelMessageListener);
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneHomeActivity.this.mGlobalSetChannelMessageListener);
                Log.d(InterPhoneHomeActivity.TAG, "remove the mGlobalSetChannelMessageListener");
            }
        }
    };
    /* access modifiers changed from: private */
    public Handler mHandler = new Handler();
    private ImageView mImgChannel;
    private ImageView mImgContacts;
    private List<ImageView> mImgList;
    private ImageView mImgLocal;
    private ImageView mImgMessage;
    private ImageView mImgTalkBack;
    private ViewPager mInterPhoneViewPager;
    /* access modifiers changed from: private */
    public LinearLayout mLlInterPhoneTapView;
    private Runnable mModulePowerOn = new Runnable() {
        public void run() {
            InterPhoneHomeActivity.this.init();
        }
    };
    private ProgressDialog mProgressDialog;
    private Runnable mStartUpdateActivity = new Runnable() {
        public void run() {
            InterPhoneHomeActivity.this.mHandler.post(InterPhoneHomeActivity.this.mDismissRunnable);
            InterPhoneHomeActivity.this.startActivity(new Intent(InterPhoneHomeActivity.this, UpdateFirmwareActivity.class));
        }
    };
    private Runnable mToastInitFail = new Runnable() {
        public void run() {
            Clog.d(InterPhoneHomeActivity.TAG, "mToastInitFail,fail !!!!!!!!!!!!!");
            PCMReceiveManager.getInstance().stopPcmRead();
            InterPhoneHomeActivity.this.mHandler.post(InterPhoneHomeActivity.this.mDismissRunnable);
        }
    };
    private Runnable mToastInitTry = new Runnable() {
        public void run() {
            CmdStateMachine instance = CmdStateMachine.getInstance();
            instance.sendMessage(instance.obtainMessage(1));
        }
    };
    private TextView mTvChannel;
    private TextView mTvContacts;
    private List<TextView> mTvList;
    private TextView mTvLocal;
    private TextView mTvMessage;
    private TextView mTvTalkBack;
    /* access modifiers changed from: private */
    public TextView mTvUnread;

    public void onMessageSend(MessageData messageData) {
    }

    public void updateNotification(ChannelData channelData) {
    }

    public void updateTalkBackChannelList() {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Log.d(TAG, "onCreate");
        requestWindowFeature(1);
        setDefaultDisplay(this);
        setContentView((int) R.layout.activity_interphone_home);
        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
        builder.detectFileUriExposure();
        DmrManager.getInstance().registerUpdateListener(this);
        DmrManager.getInstance().addMessageListener(this);
        DmrManager.getInstance().setTestBitErrorRate(false);
        showProgressDialog(getString(R.string.module_initializing));
        if (YModemManager.getInstance().isRunning() || !Util.isDmrUpdateIdle() || YModemManager.getInstance().isExternalSdcardHaveFirmware()) {
            this.mHandler.post(this.mDismissRunnable);
            startActivity(new Intent(this, UpdateFirmwareActivity.class));
        } else {
            CmdStateMachine.getInstance().setInitializedFeedBack(this);
            CmdStateMachine.getInstance().startCmdMachine();
            PCMReceiveManager.getInstance().startPcmRead();
            this.mHandler.postDelayed(this.mModulePowerOn, 1000);
            this.mHandler.postDelayed(this.mToastInitTry, 6000);
            this.mHandler.postDelayed(this.mToastInitFail, 10000);
        }
        this.mLlInterPhoneTapView = (LinearLayout) findViewById(R.id.interphone_tap_view);
        DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.mGlobalSetChannelMessageListener);
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.mGlobalSetChannelMessageListener);
    }

    private void showProgressDialog(String str) {
        if (this.mProgressDialog == null) {
            this.mProgressDialog = new ProgressDialog(this);
        }
        this.mProgressDialog.setMessage(str);
        this.mProgressDialog.setCancelable(false);
        this.mProgressDialog.show();
    }

    public void dismissProgressDialog() {
        ProgressDialog progressDialog = this.mProgressDialog;
        if (progressDialog != null) {
            progressDialog.dismiss();
        }
    }

    private boolean checkHasPermissions() {
        for (String checkSelfPermission : this.dangrousPermissions) {
            if (ContextCompat.checkSelfPermission(this, checkSelfPermission) != 0) {
                return false;
            }
        }
        return true;
    }

    public void init() {
        ReadFileUtils.getInstance().pullUpPwdFoot();
    }

    /* access modifiers changed from: protected */
    public void onStart() {
        super.onStart();
        Log.d(TAG, "onStart");
    }

    /* access modifiers changed from: protected */
    public void onStop() {
        super.onStop();
        Log.d(TAG, "onStop");
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        CmdStateMachine.getInstance().setInitializedFeedBack((CmdStateMachine.InitializedFeedBack) null);
        CmdStateMachine.getInstance().quitCmdMachine();
        this.mHandler.removeCallbacksAndMessages((Object) null);
        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), this.mGlobalSetChannelMessageListener);
        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), this.mGlobalSetChannelMessageListener);
        DmrManager.getInstance().unregisterUpdateListener(this);
        DmrManager.getInstance().removeMessageListener((MessageLisenter) this);
        if (!YModemManager.getInstance().isRunning()) {
            ReadFileUtils.getInstance().pullDownPwdFoot();
        }
        PCMReceiveManager.getInstance().stopPcmRead();
        super.onDestroy();
    }

    private void initFragmentList() {
        this.mFmTalkBack = new InterPhoneTalkBackFragment();
        this.mFmChannel = new InterPhoneChannelFragment();
        this.mFmContacts = new InterPhoneContactsFragment();
        this.mFmMessage = new InterPhoneMessageFragment();
        this.mFmLocal = new InterPhoneLocalFragment();
    }

    private void initViewPager() {
        ViewPagerFragmentAdapter viewPagerFragmentAdapter = new ViewPagerFragmentAdapter(this.mFragmentManager);
        this.mAdapter = viewPagerFragmentAdapter;
        viewPagerFragmentAdapter.add(this.mFmTalkBack);
        this.mAdapter.add(this.mFmChannel);
        this.mAdapter.add(this.mFmContacts);
        this.mAdapter.add(this.mFmMessage);
        this.mAdapter.add(this.mFmLocal);
        ViewPager viewPager = (ViewPager) findViewById(R.id.interphone_viewpager);
        this.mInterPhoneViewPager = viewPager;
        viewPager.setAdapter(this.mAdapter);
        this.mInterPhoneViewPager.setOnPageChangeListener(new ViewPageChangeListener());
        this.mInterPhoneViewPager.setOffscreenPageLimit(4);
        setCurrentViewPagerItem(0);
    }

    private void initTapView() {
        TextView textView = (TextView) findViewById(R.id.talkback_title);
        this.mTvTalkBack = textView;
        textView.setTextColor(getResources().getColor(R.color.pri_tap_text_color_selected));
        this.mTvChannel = (TextView) findViewById(R.id.channel_title);
        this.mTvContacts = (TextView) findViewById(R.id.contacts_title);
        this.mTvMessage = (TextView) findViewById(R.id.message_title);
        this.mTvLocal = (TextView) findViewById(R.id.local_title);
        ArrayList arrayList = new ArrayList();
        this.mTvList = arrayList;
        arrayList.add(this.mTvTalkBack);
        this.mTvList.add(this.mTvChannel);
        this.mTvList.add(this.mTvContacts);
        this.mTvList.add(this.mTvMessage);
        this.mTvList.add(this.mTvLocal);
        ImageView imageView = (ImageView) findViewById(R.id.talkback_img);
        this.mImgTalkBack = imageView;
        imageView.setSelected(true);
        this.mImgChannel = (ImageView) findViewById(R.id.channel_img);
        this.mImgContacts = (ImageView) findViewById(R.id.contacts_img);
        this.mImgMessage = (ImageView) findViewById(R.id.message_img);
        this.mTvUnread = (TextView) findViewById(R.id.message_unread);
        this.mImgLocal = (ImageView) findViewById(R.id.local_img);
        ArrayList arrayList2 = new ArrayList();
        this.mImgList = arrayList2;
        arrayList2.add(this.mImgTalkBack);
        this.mImgList.add(this.mImgChannel);
        this.mImgList.add(this.mImgContacts);
        this.mImgList.add(this.mImgMessage);
        this.mImgList.add(this.mImgLocal);
    }

    private void updateAllTapViewText() {
        TextView textView = this.mTvTalkBack;
        if (textView != null) {
            textView.setText(R.string.fragment_title_tap_talkback);
        }
        TextView textView2 = this.mTvChannel;
        if (textView2 != null) {
            textView2.setText(R.string.fragment_title_tap_channel);
        }
        TextView textView3 = this.mTvContacts;
        if (textView3 != null) {
            textView3.setText(R.string.fragment_title_tap_contacts);
        }
        TextView textView4 = this.mTvMessage;
        if (textView4 != null) {
            textView4.setText(R.string.fragment_title_tap_message);
        }
        TextView textView5 = this.mTvLocal;
        if (textView5 != null) {
            textView5.setText(R.string.fragment_title_tap_local);
        }
    }

    /* access modifiers changed from: private */
    public void updateTapView(int i) {
        List<TextView> list = this.mTvList;
        if (list != null && list.size() > 0) {
            for (int i2 = 0; i2 < this.mTvList.size(); i2++) {
                if (i == i2) {
                    this.mTvList.get(i2).setTextColor(getResources().getColor(R.color.pri_tap_text_color_selected));
                    this.mImgList.get(i2).setSelected(true);
                } else {
                    this.mTvList.get(i2).setTextColor(getResources().getColor(R.color.pri_tap_text_color_unselected));
                    this.mImgList.get(i2).setSelected(false);
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        super.onResume();
        Log.d(TAG, "onResume");
        updateUnreadDot();
    }

    /* access modifiers changed from: protected */
    public void onPause() {
        super.onPause();
        Log.d(TAG, "onPause");
    }

    private void updateFragmentView() {
        ViewPagerFragmentAdapter viewPagerFragmentAdapter = this.mAdapter;
        if (viewPagerFragmentAdapter != null) {
            viewPagerFragmentAdapter.updateFragmentView();
        }
    }

    public void tapOnClick(View view) {
        int i;
        switch (view.getId()) {
            case R.id.channel:
                i = 1;
                break;
            case R.id.contacts:
                i = 2;
                break;
            case R.id.local:
                i = 4;
                break;
            case R.id.message:
                i = 3;
                break;
            default:
                i = 0;
                break;
        }
        setCurrentViewPagerItem(i);
    }

    /* access modifiers changed from: private */
    public void setCurrentViewPagerItem(int i) {
        ViewPagerFragmentAdapter viewPagerFragmentAdapter;
        ViewPager viewPager = this.mInterPhoneViewPager;
        if ((viewPager == null || i != viewPager.getCurrentItem()) && (viewPagerFragmentAdapter = this.mAdapter) != null && this.mInterPhoneViewPager != null && viewPagerFragmentAdapter.getCount() > 0) {
            this.mInterPhoneViewPager.setCurrentItem(i);
            updateTapView(i);
        }
    }

    public void updateModuleInit() {
        Log.d(TAG, "updateModuleInit");
        PCMReceiveManager.getInstance().stopPcmRead();
        this.mHandler.post(this.mDismissRunnable);
        this.mHandler.removeCallbacks(this.mToastInitTry);
        this.mHandler.removeCallbacks(this.mToastInitFail);
        this.mHandler.removeCallbacks(this.mStartUpdateActivity);
        runOnUiThread(new InterPhoneHomeActivity$$ExternalSyntheticLambda0(this));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateModuleInit$0() {
        initTapView();
        updateAllTapViewText();
        initFragmentList();
        initViewPager();
        if (YModemManager.getInstance().isNeedUpdateDmr()) {
            startActivity(new Intent(this, UpdateFirmwareActivity.class));
        }
    }

    public void initializedNotify() {
        this.mHandler.removeCallbacks(this.mToastInitTry);
    }

    private class ViewPageChangeListener implements ViewPager.OnPageChangeListener {
        public void onPageScrollStateChanged(int i) {
        }

        public void onPageScrolled(int i, float f, int i2) {
        }

        private ViewPageChangeListener() {
        }

        public void onPageSelected(int i) {
            InterPhoneHomeActivity.this.setCurrentViewPagerItem(i);
            InterPhoneHomeActivity.this.updateTapView(i);
            InterPhoneHomeActivity.this.mAdapter.updateFragmentView(i);
        }
    }

    /* access modifiers changed from: protected */
    public void onActivityResult(int i, int i2, @Nullable Intent intent) {
        super.onActivityResult(i, i2, intent);
        if ((i == 1002 || i == 1001 || i == 1003) && i2 == -1) {
            Log.e(TAG, "onActivityResult mFmLocal = " + this.mFmLocal);
            InterPhoneLocalFragment interPhoneLocalFragment = this.mFmLocal;
            if (interPhoneLocalFragment != null) {
                interPhoneLocalFragment.onPrizeActivityResult(i, i2, intent);
            }
        }
    }

    public void onMessageReceived() {
        Clog.i(TAG, "onMessageReceived: ");
        updateUnreadDot();
    }

    public void onUnreadStatusUpdated() {
        updateUnreadDot();
    }

    public void onMessageDelete(MessageData messageData) {
        updateUnreadDot();
    }

    public void onConversationClean(ConversationData conversationData) {
        updateUnreadDot();
    }

    public void updateUnreadDot() {
        this.mHandler.post(new Runnable() {
            public void run() {
                if (InterPhoneHomeActivity.this.mTvUnread == null) {
                    Log.d(InterPhoneHomeActivity.TAG, "updateUnreadDot is failed because of mTvUnread is null");
                    return;
                }
                ArrayList<ConversationData> allConversations = DmrManager.getInstance().getAllConversations();
                int i = 0;
                for (int i2 = 0; i2 < allConversations.size(); i2++) {
                    i += allConversations.get(i2).getUnReadCount();
                }
                if (i > 0) {
                    InterPhoneHomeActivity.this.mTvUnread.setVisibility(0);
                    InterPhoneHomeActivity.this.mTvUnread.setText("" + i);
                    return;
                }
                InterPhoneHomeActivity.this.mTvUnread.setVisibility(8);
            }
        });
    }

    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        setDefaultDisplayWhenDensityAndFontChange(configuration);
        Log.d(TAG, "onConfigurationChanged,updateAllTapViewText");
        updateAllTapViewText();
    }

    public void onSaveInstanceState(Bundle bundle) {
        super.onSaveInstanceState(bundle);
        Clog.i(TAG, "onSaveInstanceState");
    }

    public void onRestoreInstanceState(Bundle bundle) {
        Clog.i(TAG, "onRestoreInstanceState");
    }

    public void onRequestPermissionsResult(int i, @NonNull String[] strArr, @NonNull int[] iArr) {
        super.onRequestPermissionsResult(i, strArr, iArr);
        if (i == 1000) {
            boolean z = false;
            int i2 = 0;
            while (true) {
                if (i2 >= strArr.length) {
                    z = true;
                    break;
                } else if (iArr[i2] != 0) {
                    break;
                } else {
                    i2++;
                }
            }
            Clog.i(TAG, "onRequestPermissionsResult: allGrant " + z);
            if (z) {
                init();
            } else {
                finish();
            }
        }
    }

    public static int getDefaultDisplayDensity(int i) {
        try {
            return WindowManagerGlobal.getWindowManagerService().getInitialDisplayDensity(i);
        } catch (RemoteException unused) {
            return -1;
        }
    }

    private void setDefaultDisplay(Context context) {
        Configuration configuration = context.getResources().getConfiguration();
        configuration.densityDpi = getDefaultDisplayDensity(0);
        configuration.fontScale = 1.0f;
        context.getResources().updateConfiguration(configuration, context.getResources().getDisplayMetrics());
    }

    private void setDefaultDisplayWhenDensityAndFontChange(Configuration configuration) {
        if (configuration.densityDpi != getDefaultDisplayDensity(0) || ((double) configuration.fontScale) != 1.0d) {
            setDefaultDisplay(this);
        }
    }
}
