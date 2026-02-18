package com.pri.prizeinterphone.activity;

import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.message.TestBiteErrorRateMessage;
import java.io.UnsupportedEncodingException;
/* loaded from: classes4.dex */
public class FragmentLocalTestBiteErrorRateActivity extends AppCompatActivity implements DmrManager.MessageListener {
    private static final String TAG = "FragmentLocalTestBiteErrorRateAc";
    private TextView mTvInfo;
    private StringBuilder stringBuilder = new StringBuilder();

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        getWindow().addFlags(128);
        setContentView(R.layout.fragment_local_test_bite_error_rate_activity);
        this.mTvInfo = (TextView) findViewById(R.id.tv_info);
        DmrManager.getInstance().setTestBitErrorRate(true);
        DmrManager.getInstance().registerEventListener((byte) 63, this);
        TestBiteErrorRateMessage testBiteErrorRateMessage = new TestBiteErrorRateMessage();
        testBiteErrorRateMessage.protocol = (byte) 2;
        testBiteErrorRateMessage.send();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onResume() {
        super.onResume();
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
    public void dealEvent(BaseMessage baseMessage) {
        if (baseMessage.packet != null) {
            Log.d(TAG, "baseMessage.packet.body=" + Util.bytesToHex(baseMessage.packet.body));
            try {
                StringBuilder sb = this.stringBuilder;
                sb.append(new String(baseMessage.packet.body, "GBK"));
                sb.append("\n");
            } catch (UnsupportedEncodingException e) {
                Log.d(TAG, "baseMessage.packet.body transform GBK error", e);
            }
            runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.activity.FragmentLocalTestBiteErrorRateActivity$$ExternalSyntheticLambda0
                @Override // java.lang.Runnable
                public final void run() {
                    FragmentLocalTestBiteErrorRateActivity.this.lambda$dealEvent$0();
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$dealEvent$0() {
        TextView textView = this.mTvInfo;
        if (textView != null) {
            textView.setText(this.stringBuilder.toString());
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onDestroy() {
        super.onDestroy();
        DmrManager.getInstance().unregisterEventListener((byte) 63, this);
    }
}
