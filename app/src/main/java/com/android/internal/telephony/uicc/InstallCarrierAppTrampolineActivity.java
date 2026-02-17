package com.android.internal.telephony.uicc;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import java.util.concurrent.TimeUnit;

public class InstallCarrierAppTrampolineActivity extends Activity {
    private static final String BUNDLE_KEY_PACKAGE_NAME = "package_name";
    private static final String CARRIER_NAME = "carrier_name";
    private static final int DOWNLOAD_RESULT = 2;
    private static final int INSTALL_CARRIER_APP_DIALOG_REQUEST = 1;
    private static final String LOG_TAG = "CarrierAppInstall";
    private String mPackageName;

    public static Intent get(Context context, String str) {
        Intent intent = new Intent(context, InstallCarrierAppTrampolineActivity.class);
        intent.putExtra(BUNDLE_KEY_PACKAGE_NAME, str);
        return intent;
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Intent intent = getIntent();
        if (intent != null) {
            this.mPackageName = intent.getStringExtra(BUNDLE_KEY_PACKAGE_NAME);
        }
        if (bundle == null) {
            long j = Settings.Global.getLong(getContentResolver(), "install_carrier_app_notification_sleep_millis", TimeUnit.HOURS.toMillis(24));
            Log.d(LOG_TAG, "Sleeping carrier app install notification for : " + j + " millis");
            InstallCarrierAppUtils.showNotificationIfNotInstalledDelayed(this, this.mPackageName, j);
        }
        Intent intent2 = new Intent();
        intent2.setComponent(ComponentName.unflattenFromString(Resources.getSystem().getString(17039901)));
        String appNameFromPackageName = InstallCarrierAppUtils.getAppNameFromPackageName((Context) this, this.mPackageName);
        if (!TextUtils.isEmpty(appNameFromPackageName)) {
            intent2.putExtra(CARRIER_NAME, appNameFromPackageName);
        }
        if (intent2.resolveActivity(getPackageManager()) == null) {
            Log.d(LOG_TAG, "Could not resolve activity for installing the carrier app");
            finishNoAnimation();
            return;
        }
        startActivityForResult(intent2, 1);
    }

    /* access modifiers changed from: protected */
    public void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
        if (i == 1) {
            if (i2 == 2) {
                startActivity(InstallCarrierAppUtils.getPlayStoreIntent(this.mPackageName));
            }
            finishNoAnimation();
        }
    }

    private void finishNoAnimation() {
        finish();
        overridePendingTransition(0, 0);
    }
}
