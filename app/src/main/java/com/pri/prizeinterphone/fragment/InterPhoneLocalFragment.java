package com.pri.prizeinterphone.fragment;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.ReadFileUtils;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.Util.UtilPicture;
import com.pri.prizeinterphone.activity.FragmentLocalDeviceAreaActivity;
import com.pri.prizeinterphone.activity.FragmentLocalInformationActivity;
import com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity;
import com.pri.prizeinterphone.activity.FragmentLocalTestBiteErrorRateActivity;
import com.pri.prizeinterphone.activity.FragmentLocalUseAssistantActivity;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.widget.CircleFramedDrawable;
import com.pri.prizeinterphone.ymodem.YModemManager;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
@SuppressLint({"StaticFieldLeak"})
/* loaded from: classes4.dex */
public class InterPhoneLocalFragment extends BaseViewPagerFragment implements View.OnClickListener {
    private static final String TAG = "InterPhoneLocalFragment";
    private Dialog mCameraDialog;
    private Uri mCropPictureUri;
    private Dialog mExitApptDialog;
    private Dialog mFactoryResetDialog;
    private Button mLocalCamera;
    private View mLocalDeviceArea;
    private View mLocalExitApp;
    private View mLocalFactoryTest;
    private ImageView mLocalImg;
    private ImageView mLocalImgShow;
    private View mLocalInformation;
    private View mLocalSetting;
    private View mLocalTestBitErrorRate;
    private View mLocalUseAssistant;
    private View mLocalView;
    private Uri mTakePictureUri;
    private Toast mToast;
    private int cropPhotoSize = 720;
    private Runnable updateAreaText = new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.3
        @Override // java.lang.Runnable
        public void run() {
            ((TextView) InterPhoneLocalFragment.this.mLocalView.findViewById(R.id.local_device_area_setings)).setText(Constants.getChannelAreaName(InterPhoneLocalFragment.this.getActivity()));
        }
    };

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public String getMyTag() {
        return TAG;
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.fragment_local_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        Button button = (Button) this.mLocalView.findViewById(R.id.fragment_local_camera);
        this.mLocalCamera = button;
        button.setOnClickListener(this);
        ImageView imageView = (ImageView) this.mLocalView.findViewById(R.id.fragment_local_img);
        this.mLocalImg = imageView;
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        this.mLocalImgShow = (ImageView) this.mLocalView.findViewById(R.id.fragment_local_img_show);
        View findViewById = this.mLocalView.findViewById(R.id.local_seting);
        this.mLocalSetting = findViewById;
        findViewById.setOnClickListener(this);
        View findViewById2 = this.mLocalView.findViewById(R.id.local_information);
        this.mLocalInformation = findViewById2;
        findViewById2.setOnClickListener(this);
        View findViewById3 = this.mLocalView.findViewById(R.id.local_device_area);
        this.mLocalDeviceArea = findViewById3;
        findViewById3.setOnClickListener(this);
        View findViewById4 = this.mLocalView.findViewById(R.id.local_factory_reset);
        this.mLocalFactoryTest = findViewById4;
        findViewById4.setOnClickListener(this);
        View findViewById5 = this.mLocalView.findViewById(R.id.local_use_assistant);
        this.mLocalUseAssistant = findViewById5;
        findViewById5.setOnClickListener(this);
        View findViewById6 = this.mLocalView.findViewById(R.id.local_exit_app);
        this.mLocalExitApp = findViewById6;
        findViewById6.setOnClickListener(this);
        View findViewById7 = this.mLocalView.findViewById(R.id.local_test_bite_error_rate);
        this.mLocalTestBitErrorRate = findViewById7;
        findViewById7.setOnClickListener(this);
        this.cropPhotoSize = (int) getActivity().getResources().getDimension(R.dimen.interphone_circle_view_size);
        initData();
    }

    private void initData() {
        updateLocalImg(PersonSharePrefData.getImgData(getActivity(), "pref_person_icon", getDefauteBitmap()));
    }

    public void onPrizeActivityResult(int i, int i2, Intent intent) {
        Uri data = (intent == null || intent.getData() == null) ? this.mTakePictureUri : intent.getData();
        if (data == null) {
            Log.e(TAG, "Invalid pictureUri null");
        } else if (!"content".equals(data.getScheme())) {
            Log.e(TAG, "Invalid pictureUri scheme: " + data.getScheme());
        } else {
            switch (i) {
                case 1001:
                case 1002:
                    if (this.mTakePictureUri.equals(data)) {
                        cropPhoto();
                        return;
                    } else {
                        copyAndCropPhoto(data);
                        return;
                    }
                case 1003:
                    onPhotoCropped(data, true);
                    return;
                default:
                    return;
            }
        }
    }

    private void showCameraDialog() {
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.interphone_camera_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(getActivity());
        this.mCameraDialog = dialog;
        dialog.setContentView(inflate);
        setWindowLayoutParams(this.mCameraDialog);
        this.mCameraDialog.show();
        ((TextView) inflate.findViewById(R.id.interphone_camera_take_picture)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.interphone_camera_seleted_picture)).setOnClickListener(this);
    }

    @Override // androidx.fragment.app.Fragment, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Log.d(TAG, "onConfigurationChanged");
        Dialog dialog = this.mCameraDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mCameraDialog.dismiss();
            this.mCameraDialog = null;
            showCameraDialog();
        }
        Dialog dialog2 = this.mFactoryResetDialog;
        if (dialog2 != null && dialog2.isShowing()) {
            this.mFactoryResetDialog.dismiss();
            this.mFactoryResetDialog = null;
            showLocalFactoryResetDialog();
        }
        Dialog dialog3 = this.mExitApptDialog;
        if (dialog3 == null || !dialog3.isShowing()) {
            return;
        }
        this.mFactoryResetDialog.dismiss();
        this.mExitApptDialog = null;
        showLocalExitAppDialog();
    }

    private void setWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = dialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
    }

    @Override // androidx.fragment.app.Fragment
    public void onResume() {
        super.onResume();
        if (isAdded()) {
            setTitle(getString(R.string.fragment_title_local));
        }
        ((TextView) this.mLocalView.findViewById(R.id.local_seting_title)).setText(getString(R.string.fragment_local_setting));
        ((TextView) this.mLocalView.findViewById(R.id.local_information_title)).setText(getString(R.string.fragment_local_information));
        ((TextView) this.mLocalView.findViewById(R.id.local_device_area_title)).setText(getString(R.string.fragment_local_device_area));
        updateLanguageArea();
        ((TextView) this.mLocalView.findViewById(R.id.local_factory_reset_title)).setText(getString(R.string.fragment_local_factory_reset));
        ((TextView) this.mLocalView.findViewById(R.id.local_use_assistant_title)).setText(getString(R.string.fragment_local_use_assistant));
        ((TextView) this.mLocalView.findViewById(R.id.local_exit_app_title)).setText(getString(R.string.fragment_local_exit_app));
    }

    private void updateLanguageArea() {
        ((TextView) this.mLocalView.findViewById(R.id.local_device_area_setings)).setText(Constants.getChannelAreaName(getActivity()));
    }

    private void takePhoto() {
        this.mTakePictureUri = createTempImageUri(getActivity(), UtilPicture.TAKE_PICTURE_FILE_NAME, false);
        Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
        appendOutputExtra(intent, this.mTakePictureUri);
        intent.addFlags(3);
        getActivity().startActivityForResult(intent, 1002);
    }

    private void choosePhoto() {
        this.mTakePictureUri = createTempImageUri(getActivity(), UtilPicture.TAKE_PICTURE_FILE_NAME, false);
        Intent intent = new Intent("android.intent.action.GET_CONTENT", (Uri) null);
        intent.setType("image/*");
        appendOutputExtra(intent, this.mTakePictureUri);
        getActivity().startActivityForResult(intent, 1001);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void cropPhoto() {
        this.mCropPictureUri = createTempImageUri(getActivity(), UtilPicture.CROP_PICTURE_FILE_NAME, false);
        Intent intent = new Intent(UtilPicture.ACTION_CROP);
        intent.setDataAndType(this.mTakePictureUri, "image/*");
        appendOutputExtra(intent, this.mCropPictureUri);
        appendCropExtras(intent);
        intent.resolveActivity(getActivity().getPackageManager());
        getActivity().startActivityForResult(intent, 1003);
    }

    private void copyAndCropPhoto(final Uri uri) {
        new AsyncTask<Void, Void, Void>() { // from class: com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.1
            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public Void doInBackground(Void... voidArr) {
                ContentResolver contentResolver = InterPhoneLocalFragment.this.getActivity().getContentResolver();
                try {
                    InputStream openInputStream = contentResolver.openInputStream(uri);
                    OutputStream openOutputStream = contentResolver.openOutputStream(InterPhoneLocalFragment.this.mTakePictureUri);
                    InterPhoneLocalFragment.streamsCopy(openInputStream, openOutputStream);
                    if (openOutputStream != null) {
                        openOutputStream.close();
                    }
                    if (openInputStream != null) {
                        openInputStream.close();
                        return null;
                    }
                    return null;
                } catch (IOException e) {
                    Log.w(InterPhoneLocalFragment.TAG, "Failed to copy photo", e);
                    return null;
                }
            }

            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public void onPostExecute(Void r1) {
                if (InterPhoneLocalFragment.this.isAdded()) {
                    InterPhoneLocalFragment.this.cropPhoto();
                }
            }
        }.execute(new Void[0]);
    }

    public static int streamsCopy(InputStream inputStream, OutputStream outputStream) throws IOException {
        byte[] bArr = new byte[8192];
        int i = 0;
        while (true) {
            int read = inputStream.read(bArr);
            if (read == -1) {
                return i;
            }
            i += read;
            outputStream.write(bArr, 0, read);
        }
    }

    private void onPhotoCropped(final Uri uri, final boolean z) {
        new AsyncTask<Void, Void, Bitmap>() { // from class: com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.2
            /* JADX INFO: Access modifiers changed from: protected */
            /* JADX WARN: Multi-variable type inference failed */
            /* JADX WARN: Type inference failed for: r3v0 */
            /* JADX WARN: Type inference failed for: r3v1 */
            /* JADX WARN: Type inference failed for: r3v2, types: [java.io.InputStream] */
            @Override // android.os.AsyncTask
            public Bitmap doInBackground(Void... voidArr) {
                InputStream inputStream;
                return null; // TODO-FIX: JADX decompilation error
            }
            @Override // android.os.AsyncTask
            public void onPostExecute(Bitmap bitmap) {
                InterPhoneLocalFragment.this.updateLocalImg(bitmap);
                new File(InterPhoneLocalFragment.this.getActivity().getCacheDir(), UtilPicture.TAKE_PICTURE_FILE_NAME).delete();
                new File(InterPhoneLocalFragment.this.getActivity().getCacheDir(), UtilPicture.CROP_PICTURE_FILE_NAME).delete();
            }
        }.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, null);
    }

    private void appendCropExtras(Intent intent) {
        intent.putExtra("crop", "true");
        intent.putExtra("scale", true);
        intent.putExtra("scaleUpIfNeeded", true);
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        intent.putExtra("outputX", this.cropPhotoSize);
        intent.putExtra("outputY", this.cropPhotoSize);
    }

    private void appendOutputExtra(Intent intent, Uri uri) {
        intent.putExtra("output", uri);
        intent.addFlags(3);
        intent.setClipData(ClipData.newRawUri("output", uri));
    }

    private Uri createTempImageUri(Context context, String str, boolean z) {
        File cacheDir = context.getCacheDir();
        cacheDir.mkdirs();
        File file = new File(cacheDir, str);
        if (z) {
            file.delete();
        }
        return FileProvider.getUriForFile(context, UtilPicture.FILE_PATH, file);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void updateLocalImg(Bitmap bitmap) {
        if (bitmap != null) {
            this.mLocalImg.setImageDrawable(CircleFramedDrawable.getInstance(getActivity(), bitmap));
            PersonSharePrefData.putImgData(getActivity(), "pref_person_icon", bitmap);
        }
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.fragment_local_camera /* 2131296468 */:
                if (isTalkSend()) {
                    return;
                }
                showCameraDialog();
                return;
            case R.id.fragment_local_exit_app_cancle /* 2131296470 */:
                Dialog dialog = this.mExitApptDialog;
                if (dialog != null) {
                    dialog.dismiss();
                    return;
                }
                return;
            case R.id.fragment_local_exit_app_ok /* 2131296471 */:
                if (isTalkSend()) {
                    return;
                }
                Dialog dialog2 = this.mExitApptDialog;
                if (dialog2 != null) {
                    dialog2.dismiss();
                }
                localmExitApp();
                return;
            case R.id.fragment_local_factory_reset_cancle /* 2131296472 */:
                Dialog dialog3 = this.mFactoryResetDialog;
                if (dialog3 != null) {
                    dialog3.dismiss();
                    return;
                }
                return;
            case R.id.fragment_local_factory_reset_ok /* 2131296473 */:
                if (isTalkSend()) {
                    return;
                }
                Dialog dialog4 = this.mFactoryResetDialog;
                if (dialog4 != null) {
                    dialog4.dismiss();
                }
                localFactoryReset();
                return;
            case R.id.interphone_camera_seleted_picture /* 2131296515 */:
                if (isTalkSend()) {
                    return;
                }
                Dialog dialog5 = this.mCameraDialog;
                if (dialog5 != null) {
                    dialog5.dismiss();
                }
                choosePhoto();
                return;
            case R.id.interphone_camera_take_picture /* 2131296516 */:
                if (isTalkSend()) {
                    return;
                }
                Dialog dialog6 = this.mCameraDialog;
                if (dialog6 != null) {
                    dialog6.dismiss();
                }
                takePhoto();
                return;
            case R.id.local_device_area /* 2131296622 */:
                if (isTalkSend()) {
                    return;
                }
                if (Util.isMonkeyRunning()) {
                    Log.d(TAG, "monkey is running, not let go come into FragmentLocalDeviceAreaActivity");
                    return;
                }
                getActivity().startActivity(new Intent(getContext(), FragmentLocalDeviceAreaActivity.class));
                return;
            case R.id.local_exit_app /* 2131296640 */:
                if (isTalkSend()) {
                    return;
                }
                showLocalExitAppDialog();
                return;
            case R.id.local_factory_reset /* 2131296642 */:
                if (isTalkSend()) {
                    return;
                }
                showLocalFactoryResetDialog();
                return;
            case R.id.local_information /* 2131296645 */:
                getActivity().startActivity(new Intent(getContext(), FragmentLocalInformationActivity.class));
                return;
            case R.id.local_seting /* 2131296657 */:
                if (isTalkSend()) {
                    return;
                }
                getActivity().startActivity(new Intent(getContext(), FragmentLocalSettingsActivity.class));
                return;
            case R.id.local_test_bite_error_rate /* 2131296675 */:
                getActivity().startActivity(new Intent(getContext(), FragmentLocalTestBiteErrorRateActivity.class));
                return;
            case R.id.local_use_assistant /* 2131296678 */:
                getActivity().startActivity(new Intent(getContext(), FragmentLocalUseAssistantActivity.class));
                return;
            default:
                return;
        }
    }

    private void showLocalFactoryResetDialog() {
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_local_factoryreset_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(getActivity());
        this.mFactoryResetDialog = dialog;
        dialog.setContentView(inflate);
        setWindowLayoutParams(this.mFactoryResetDialog);
        this.mFactoryResetDialog.show();
        ((Button) inflate.findViewById(R.id.fragment_local_factory_reset_cancle)).setOnClickListener(this);
        ((Button) inflate.findViewById(R.id.fragment_local_factory_reset_ok)).setOnClickListener(this);
    }

    private void localFactoryReset() {
        showProgressDialog(getString(R.string.fragment_local_factory_reset_progress_dialog_title));
        DmrManager.getInstance().resetData(true);
        updateLocalImg(getDefauteBitmap());
        this.mHandler.postDelayed(this.mDismissRunnable, 1000L);
        this.mHandler.postDelayed(this.updateAreaText, 1000L);
    }

    private Bitmap getDefauteBitmap() {
        Drawable drawable = getActivity().getDrawable(R.drawable.interphone_big_contacts_default);
        Bitmap createBitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(createBitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return createBitmap;
    }

    private void showLocalExitAppDialog() {
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_local_exitapp_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(getActivity());
        this.mExitApptDialog = dialog;
        dialog.setContentView(inflate);
        setWindowLayoutParams(this.mExitApptDialog);
        this.mExitApptDialog.show();
        ((Button) inflate.findViewById(R.id.fragment_local_exit_app_cancle)).setOnClickListener(this);
        ((Button) inflate.findViewById(R.id.fragment_local_exit_app_ok)).setOnClickListener(this);
    }

    private void localmExitApp() {
        YModemManager.getInstance().releaseYModem();
        ReadFileUtils.getInstance().pullDownPwdFoot();
        DmrManager.getInstance().releaseSerialPort();
        getActivity().stopService(new Intent(getActivity(), InterPhoneService.class));
        getActivity().finishAffinity();
        getActivity().finish();
        System.exit(0);
    }

    private void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(getActivity(), i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private boolean isTalkSend() {
        boolean z = PersonSharePrefData.getIntData(getActivity(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
