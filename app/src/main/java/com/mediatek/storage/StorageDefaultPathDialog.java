package com.mediatek.storage;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import com.android.internal.app.AlertActivity;
import com.android.internal.app.AlertController;

public class StorageDefaultPathDialog extends AlertActivity implements DialogInterface.OnClickListener {
    private static final String INSERT_OTG = "insert_otg";
    private static final String SD_ACTION = "android.intent.action.MEDIA_BAD_REMOVAL";
    private static final String TAG = "StorageDefaultPathDialog";
    private Boolean mInsertOtg = Boolean.FALSE;
    private BroadcastReceiver mReceiver;
    private IntentFilter mSDCardStateFilter;
    private final BroadcastReceiver mSDStateReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(StorageDefaultPathDialog.SD_ACTION)) {
                StorageDefaultPathDialog.this.finish();
            }
        }
    };
    String path = null;

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        StorageDefaultPathDialog.super.onCreate(bundle);
        Log.d(TAG, "StorageDefaultPathDialog onCreate()");
        IntentFilter intentFilter = new IntentFilter(SD_ACTION);
        this.mSDCardStateFilter = intentFilter;
        intentFilter.addDataScheme("file");
        this.mReceiver = this.mSDStateReceiver;
        this.mInsertOtg = Boolean.valueOf(getIntent().getBooleanExtra(INSERT_OTG, false));
        createDialog();
    }

    private void createDialog() {
        String str;
        AlertController.AlertParams alertParams = this.mAlertParams;
        if (this.mInsertOtg.booleanValue()) {
            str = getString(134545539);
        } else {
            str = getString(134545527);
        }
        alertParams.mTitle = str;
        alertParams.mView = createView();
        alertParams.mViewSpacingSpecified = true;
        alertParams.mViewSpacingLeft = 15;
        alertParams.mViewSpacingRight = 15;
        alertParams.mViewSpacingTop = 5;
        alertParams.mViewSpacingBottom = 5;
        alertParams.mPositiveButtonText = getString(17039379);
        alertParams.mPositiveButtonListener = this;
        alertParams.mNegativeButtonText = getString(17039369);
        alertParams.mNegativeButtonListener = this;
        setupAlert();
    }

    /* JADX WARNING: type inference failed for: r2v0, types: [android.content.Context, com.mediatek.storage.StorageDefaultPathDialog] */
    private View createView() {
        TextView textView = new TextView(this);
        textView.setTextAppearance(textView.getContext(), 16973892);
        textView.setText(134545528);
        return textView;
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        StorageDefaultPathDialog.super.onResume();
        registerReceiver(this.mReceiver, this.mSDCardStateFilter);
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        Log.d(TAG, "onDestroy()");
        StorageDefaultPathDialog.super.onDestroy();
    }

    /* access modifiers changed from: protected */
    public void onPause() {
        StorageDefaultPathDialog.super.onPause();
        Log.e(TAG, "onPause entry");
        unregisterReceiver(this.mReceiver);
    }

    private void onOK() {
        Intent intent = new Intent();
        intent.setAction("android.settings.INTERNAL_STORAGE_SETTINGS");
        intent.setFlags(1409286144);
        Log.d(TAG, "onOK() start activity");
        startActivity(intent);
        finish();
    }

    private void onCancel() {
        finish();
    }

    public void onClick(DialogInterface dialogInterface, int i) {
        if (i == -2) {
            onCancel();
        } else if (i == -1) {
            onOK();
        }
    }
}
