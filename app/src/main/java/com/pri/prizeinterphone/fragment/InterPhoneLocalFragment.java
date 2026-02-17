package com.pri.prizeinterphone.fragment;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Canvas;
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
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@SuppressLint({"StaticFieldLeak"})
public class InterPhoneLocalFragment extends BaseViewPagerFragment implements View.OnClickListener {
    private static final String TAG = "InterPhoneLocalFragment";
    private int cropPhotoSize = 720;
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
    /* access modifiers changed from: private */
    public View mLocalView;
    /* access modifiers changed from: private */
    public Uri mTakePictureUri;
    private Toast mToast;
    private Runnable updateAreaText = new Runnable() {
        public void run() {
            ((TextView) InterPhoneLocalFragment.this.mLocalView.findViewById(R.id.local_device_area_setings)).setText(Constants.getChannelAreaName(InterPhoneLocalFragment.this.getActivity()));
        }
    };

    public String getMyTag() {
        return TAG;
    }

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
        if (dialog3 != null && dialog3.isShowing()) {
            this.mFactoryResetDialog.dismiss();
            this.mExitApptDialog = null;
            showLocalExitAppDialog();
        }
    }

    private void setWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = dialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (((float) i) * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
    }

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

    /* access modifiers changed from: private */
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
        new AsyncTask<Void, Void, Void>() {
            /* access modifiers changed from: protected */
            public Void doInBackground(Void... voidArr) {
                OutputStream openOutputStream;
                ContentResolver contentResolver = InterPhoneLocalFragment.this.getActivity().getContentResolver();
                try {
                    InputStream openInputStream = contentResolver.openInputStream(uri);
                    try {
                        openOutputStream = contentResolver.openOutputStream(InterPhoneLocalFragment.this.mTakePictureUri);
                        InterPhoneLocalFragment.streamsCopy(openInputStream, openOutputStream);
                        if (openOutputStream != null) {
                            openOutputStream.close();
                        }
                        if (openInputStream == null) {
                            return null;
                        }
                        openInputStream.close();
                        return null;
                    } catch (Throwable th) {
                        if (openInputStream != null) {
                            openInputStream.close();
                        }
                        throw th;
                    }
                    throw th;
                } catch (IOException e) {
                    Log.w(InterPhoneLocalFragment.TAG, "Failed to copy photo", e);
                    return null;
                } catch (Throwable th2) {
                    th.addSuppressed(th2);
                }
            }

            /* access modifiers changed from: protected */
            public void onPostExecute(Void voidR) {
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
        new AsyncTask<Void, Void, Bitmap>() {
            /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v7, resolved type: android.graphics.Bitmap} */
            /* JADX WARNING: type inference failed for: r3v0 */
            /* JADX WARNING: type inference failed for: r3v5, types: [java.io.InputStream] */
            /* JADX WARNING: type inference failed for: r3v6 */
            /* JADX WARNING: type inference failed for: r3v9 */
            /* access modifiers changed from: protected */
            /* JADX WARNING: Multi-variable type inference failed */
            /* JADX WARNING: Removed duplicated region for block: B:20:0x0038 A[SYNTHETIC, Splitter:B:20:0x0038] */
            /* JADX WARNING: Removed duplicated region for block: B:28:0x0045 A[SYNTHETIC, Splitter:B:28:0x0045] */
            /* Code decompiled incorrectly, please refer to instructions dump. */
            public android.graphics.Bitmap doInBackground(java.lang.Void... r9) {
                /*
                    r8 = this;
                    java.lang.String r9 = "Cannot close image stream"
                    boolean r0 = r3
                    java.lang.String r1 = "Cannot find image file"
                    java.lang.String r2 = "InterPhoneLocalFragment"
                    r3 = 0
                    if (r0 == 0) goto L_0x004e
                    com.pri.prizeinterphone.fragment.InterPhoneLocalFragment r0 = com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.this     // Catch:{ FileNotFoundException -> 0x0031, all -> 0x002f }
                    androidx.fragment.app.FragmentActivity r0 = r0.getActivity()     // Catch:{ FileNotFoundException -> 0x0031, all -> 0x002f }
                    android.content.ContentResolver r0 = r0.getContentResolver()     // Catch:{ FileNotFoundException -> 0x0031, all -> 0x002f }
                    android.net.Uri r8 = r2     // Catch:{ FileNotFoundException -> 0x0031, all -> 0x002f }
                    java.io.InputStream r8 = r0.openInputStream(r8)     // Catch:{ FileNotFoundException -> 0x0031, all -> 0x002f }
                    if (r8 == 0) goto L_0x0024
                    android.graphics.Bitmap r3 = android.graphics.BitmapFactory.decodeStream(r8)     // Catch:{ FileNotFoundException -> 0x0022 }
                    goto L_0x0024
                L_0x0022:
                    r0 = move-exception
                    goto L_0x0033
                L_0x0024:
                    if (r8 == 0) goto L_0x002e
                    r8.close()     // Catch:{ IOException -> 0x002a }
                    goto L_0x002e
                L_0x002a:
                    r8 = move-exception
                    android.util.Log.w(r2, r9, r8)
                L_0x002e:
                    return r3
                L_0x002f:
                    r0 = move-exception
                    goto L_0x0043
                L_0x0031:
                    r0 = move-exception
                    r8 = r3
                L_0x0033:
                    android.util.Log.w(r2, r1, r0)     // Catch:{ all -> 0x0041 }
                    if (r8 == 0) goto L_0x0040
                    r8.close()     // Catch:{ IOException -> 0x003c }
                    goto L_0x0040
                L_0x003c:
                    r8 = move-exception
                    android.util.Log.w(r2, r9, r8)
                L_0x0040:
                    return r3
                L_0x0041:
                    r0 = move-exception
                    r3 = r8
                L_0x0043:
                    if (r3 == 0) goto L_0x004d
                    r3.close()     // Catch:{ IOException -> 0x0049 }
                    goto L_0x004d
                L_0x0049:
                    r8 = move-exception
                    android.util.Log.w(r2, r9, r8)
                L_0x004d:
                    throw r0
                L_0x004e:
                    com.pri.prizeinterphone.fragment.InterPhoneLocalFragment r9 = com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.this     // Catch:{ FileNotFoundException -> 0x00a9 }
                    androidx.fragment.app.FragmentActivity r9 = r9.getActivity()     // Catch:{ FileNotFoundException -> 0x00a9 }
                    android.content.ContentResolver r9 = r9.getContentResolver()     // Catch:{ FileNotFoundException -> 0x00a9 }
                    android.net.Uri r8 = r2     // Catch:{ FileNotFoundException -> 0x00a9 }
                    java.io.InputStream r8 = r9.openInputStream(r8)     // Catch:{ FileNotFoundException -> 0x00a9 }
                    if (r8 == 0) goto L_0x0065
                    android.graphics.Bitmap r8 = android.graphics.BitmapFactory.decodeStream(r8)     // Catch:{ FileNotFoundException -> 0x00a9 }
                    goto L_0x0066
                L_0x0065:
                    r8 = r3
                L_0x0066:
                    if (r8 == 0) goto L_0x00a8
                    android.graphics.Bitmap$Config r9 = android.graphics.Bitmap.Config.ARGB_8888
                    r0 = 640(0x280, float:8.97E-43)
                    r1 = 480(0x1e0, float:6.73E-43)
                    android.graphics.Bitmap r9 = android.graphics.Bitmap.createBitmap(r0, r1, r9)
                    android.graphics.Canvas r2 = new android.graphics.Canvas
                    r2.<init>(r9)
                    int r3 = r8.getWidth()
                    int r4 = r8.getHeight()
                    int r3 = java.lang.Math.min(r3, r4)
                    int r4 = r8.getWidth()
                    int r4 = r4 - r3
                    int r4 = r4 / 2
                    int r5 = r8.getHeight()
                    int r5 = r5 - r3
                    int r5 = r5 / 2
                    android.graphics.Rect r6 = new android.graphics.Rect
                    int r7 = r4 + r3
                    int r3 = r3 + r5
                    r6.<init>(r4, r5, r7, r3)
                    android.graphics.Rect r3 = new android.graphics.Rect
                    r4 = 0
                    r3.<init>(r4, r4, r0, r1)
                    android.graphics.Paint r0 = new android.graphics.Paint
                    r0.<init>()
                    r2.drawBitmap(r8, r6, r3, r0)
                    return r9
                L_0x00a8:
                    return r3
                L_0x00a9:
                    r8 = move-exception
                    android.util.Log.w(r2, r1, r8)
                    return r3
                */
                throw new UnsupportedOperationException("Method not decompiled: com.pri.prizeinterphone.fragment.InterPhoneLocalFragment.AnonymousClass2.doInBackground(java.lang.Void[]):android.graphics.Bitmap");
            }

            /* access modifiers changed from: protected */
            public void onPostExecute(Bitmap bitmap) {
                InterPhoneLocalFragment.this.updateLocalImg(bitmap);
                new File(InterPhoneLocalFragment.this.getActivity().getCacheDir(), UtilPicture.TAKE_PICTURE_FILE_NAME).delete();
                new File(InterPhoneLocalFragment.this.getActivity().getCacheDir(), UtilPicture.CROP_PICTURE_FILE_NAME).delete();
            }
        }.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, (Object[]) null);
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

    /* access modifiers changed from: private */
    public void updateLocalImg(Bitmap bitmap) {
        if (bitmap != null) {
            this.mLocalImg.setImageDrawable(CircleFramedDrawable.getInstance(getActivity(), bitmap));
            PersonSharePrefData.putImgData(getActivity(), "pref_person_icon", bitmap);
        }
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.fragment_local_camera:
                if (!isTalkSend()) {
                    showCameraDialog();
                    return;
                }
                return;
            case R.id.fragment_local_exit_app_cancle:
                Dialog dialog = this.mExitApptDialog;
                if (dialog != null) {
                    dialog.dismiss();
                    return;
                }
                return;
            case R.id.fragment_local_exit_app_ok:
                if (!isTalkSend()) {
                    Dialog dialog2 = this.mExitApptDialog;
                    if (dialog2 != null) {
                        dialog2.dismiss();
                    }
                    localmExitApp();
                    return;
                }
                return;
            case R.id.fragment_local_factory_reset_cancle:
                Dialog dialog3 = this.mFactoryResetDialog;
                if (dialog3 != null) {
                    dialog3.dismiss();
                    return;
                }
                return;
            case R.id.fragment_local_factory_reset_ok:
                if (!isTalkSend()) {
                    Dialog dialog4 = this.mFactoryResetDialog;
                    if (dialog4 != null) {
                        dialog4.dismiss();
                    }
                    localFactoryReset();
                    return;
                }
                return;
            case R.id.interphone_camera_seleted_picture:
                if (!isTalkSend()) {
                    Dialog dialog5 = this.mCameraDialog;
                    if (dialog5 != null) {
                        dialog5.dismiss();
                    }
                    choosePhoto();
                    return;
                }
                return;
            case R.id.interphone_camera_take_picture:
                if (!isTalkSend()) {
                    Dialog dialog6 = this.mCameraDialog;
                    if (dialog6 != null) {
                        dialog6.dismiss();
                    }
                    takePhoto();
                    return;
                }
                return;
            case R.id.local_device_area:
                if (!isTalkSend()) {
                    if (Util.isMonkeyRunning()) {
                        Log.d(TAG, "monkey is running, not let go come into FragmentLocalDeviceAreaActivity");
                        return;
                    }
                    getActivity().startActivity(new Intent(getContext(), FragmentLocalDeviceAreaActivity.class));
                    return;
                }
                return;
            case R.id.local_exit_app:
                if (!isTalkSend()) {
                    showLocalExitAppDialog();
                    return;
                }
                return;
            case R.id.local_factory_reset:
                if (!isTalkSend()) {
                    showLocalFactoryResetDialog();
                    return;
                }
                return;
            case R.id.local_information:
                getActivity().startActivity(new Intent(getContext(), FragmentLocalInformationActivity.class));
                return;
            case R.id.local_seting:
                if (!isTalkSend()) {
                    getActivity().startActivity(new Intent(getContext(), FragmentLocalSettingsActivity.class));
                    return;
                }
                return;
            case R.id.local_test_bite_error_rate:
                getActivity().startActivity(new Intent(getContext(), FragmentLocalTestBiteErrorRateActivity.class));
                return;
            case R.id.local_use_assistant:
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
        this.mHandler.postDelayed(this.mDismissRunnable, 1000);
        this.mHandler.postDelayed(this.updateAreaText, 1000);
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
        boolean z = false;
        if (PersonSharePrefData.getIntData(getActivity(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1) {
            z = true;
        }
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
