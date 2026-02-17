package com.pri.prizeinterphone.activity;

import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.R;

public class FragmentLocalUseAssistantActivity extends AppCompatActivity implements View.OnClickListener {
    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.fragment_local_use_assistant_activity);
    }

    public void onBackPressed() {
        super.onBackPressed();
    }

    public void onClick(View view) {
        if (view.getId() == R.id.back_button) {
            onBackPressed();
        }
    }
}
