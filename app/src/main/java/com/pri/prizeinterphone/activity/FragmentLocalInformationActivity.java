package com.pri.prizeinterphone.activity;

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;

public class FragmentLocalInformationActivity extends AppCompatActivity implements View.OnClickListener {
    private TextView mTvDmrFirmwareVersion;
    private TextView mTvModVersion;
    private TextView mTvSoftwareVersion;

    private void initValue() {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.fragment_local_information_activity);
        initView();
        initValue();
    }

    public void onBackPressed() {
        super.onBackPressed();
    }

    private void initView() {
        this.mTvSoftwareVersion = (TextView) findViewById(R.id.local_information_software_version_value);
        this.mTvDmrFirmwareVersion = (TextView) findViewById(R.id.local_information_dmrfirmware_version_value);
        this.mTvModVersion = (TextView) findViewById(R.id.local_information_mod_version_value);
        String versionName = getVersionName();
        TextView textView = this.mTvSoftwareVersion;
        if (versionName == null) {
            versionName = "V1.0";
        }
        textView.setText(versionName);
        this.mTvDmrFirmwareVersion.setText(getDmrVersion());
        this.mTvModVersion.setText(getString(R.string.fragment_local_information_mod_version));
    }

    public void onClick(View view) {
        if (view.getId() == R.id.back_button) {
            onBackPressed();
        }
    }

    public String getVersionName() {
        try {
            return PrizeInterPhoneApp.getContext().getPackageManager().getPackageInfo(getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getDmrVersion() {
        return PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_DEVICE_DMR_VERSION, Constants.DEF_MODULE_VERSION);
    }
}
