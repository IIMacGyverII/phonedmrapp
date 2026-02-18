package com.pri.prizeinterphone.activity;

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
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.UtilPicture;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.ContactData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilContactsData;
import com.pri.prizeinterphone.widget.CircleFramedDrawable;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
/* loaded from: classes4.dex */
public class FragmentNewContactsActivity extends AppCompatActivity implements View.OnClickListener {
    private static final int GROUP_NAME_INDEX = 2;
    private static final int GROUP_NUMBER_INDEX = 3;
    private static final int[] LIN_RES_ID = {R.id.interphone_people_name, R.id.interphone_people_number, R.id.interphone_group_name, R.id.interphone_group_number};
    private static final int PEOPLE_NAME_INDEX = 0;
    private static final int PEOPLE_NUMBER_INDEX = 1;
    private static final String TAG = "FragmentNewContactsActivity";
    private boolean isHasPicture;
    private Dialog mCameraDialog;
    private Uri mCropPictureUri;
    private ContactData mCurrentContactData;
    private int mCurrentSelect;
    private int mCurrentType;
    private Dialog mDialog;
    private ContactData mEditContactData;
    private EditText mEditGroupName;
    private EditText mEditGroupNumber;
    private EditText mEditPeopleName;
    private EditText mEditPeopleNumber;
    private ImageView mImgPhoto;
    private View mRelGroupName;
    private View mRelGroupNumber;
    private View mRelPeopleName;
    private View mRelPeopleNumber;
    private Uri mTakePictureUri;
    private Toast mToast;
    private TextView mTvTitle;
    private boolean isModifyData = false;
    private boolean isModifyImg = false;
    private int cropPhotoSize = 720;

    private void deltePicture() {
    }

    public Context getContext() {
        return this;
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.fragment_new_contacts_activity);
        initView();
        initData();
    }

    private void initView() {
        this.mTvTitle = (TextView) findViewById(R.id.interphone_contacts_title);
        this.mImgPhoto = (ImageView) findViewById(R.id.interphone_contacts_img);
        EditText editText = (EditText) findViewById(R.id.interphone_people_name_edit);
        this.mEditPeopleName = editText;
        editText.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.1
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                Log.e(FragmentNewContactsActivity.TAG, "mEditPeopleName onFocusChange  hasFocus = " + z);
                if (z) {
                    FragmentNewContactsActivity.this.updateSeletedItm(0);
                }
            }
        });
        EditText editText2 = (EditText) findViewById(R.id.interphone_people_number_edit);
        this.mEditPeopleNumber = editText2;
        editText2.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.2
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                Log.e(FragmentNewContactsActivity.TAG, "mEditPeopleNumber onFocusChange  hasFocus = " + z);
                if (z) {
                    FragmentNewContactsActivity.this.updateSeletedItm(1);
                }
            }
        });
        EditText editText3 = (EditText) findViewById(R.id.interphone_group_name_edit);
        this.mEditGroupName = editText3;
        editText3.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.3
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                Log.e(FragmentNewContactsActivity.TAG, "mEditGroupName onFocusChange  hasFocus = " + z);
                if (z) {
                    FragmentNewContactsActivity.this.updateSeletedItm(2);
                }
            }
        });
        EditText editText4 = (EditText) findViewById(R.id.interphone_group_number_edit);
        this.mEditGroupNumber = editText4;
        editText4.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.4
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                Log.e(FragmentNewContactsActivity.TAG, "mEditGroupNumber onFocusChange  hasFocus = " + z);
                if (z) {
                    FragmentNewContactsActivity.this.updateSeletedItm(3);
                }
            }
        });
        this.mRelPeopleName = findViewById(R.id.interphone_people_name);
        this.mRelPeopleNumber = findViewById(R.id.interphone_people_number);
        this.mRelGroupName = findViewById(R.id.interphone_group_name);
        this.mRelGroupNumber = findViewById(R.id.interphone_group_number);
    }

    private void initData() {
        ContactData contactData;
        Intent intent = getIntent();
        this.isModifyData = intent.getBooleanExtra("isedit", false);
        int intExtra = intent.getIntExtra(UtilContactsData.TABLE_TYPE, 0);
        int intExtra2 = intent.getIntExtra("_id", -1);
        Log.i(TAG, "initData: isModifyData " + this.isModifyData + "--type=" + intExtra + "--mEditContactDataId=" + intExtra2);
        this.mCurrentContactData = new ContactData();
        this.mCurrentType = intExtra;
        if (intExtra == 0) {
            this.mRelPeopleName.setVisibility(0);
            this.mRelPeopleNumber.setVisibility(0);
            this.mRelGroupName.setVisibility(8);
            this.mRelGroupNumber.setVisibility(8);
        } else {
            this.mRelPeopleName.setVisibility(8);
            this.mRelPeopleNumber.setVisibility(8);
            this.mRelGroupName.setVisibility(0);
            this.mRelGroupNumber.setVisibility(0);
        }
        Log.i(TAG, "mEditContactDataId = " + intExtra2);
        if (intExtra2 != -1) {
            this.mEditContactData = DmrManager.getInstance().getContact(intExtra2);
        }
        if (this.isModifyData && (contactData = this.mEditContactData) != null) {
            if (intExtra == 0) {
                this.mEditPeopleName.setText(contactData.getName());
                this.mEditPeopleNumber.setText(this.mEditContactData.getNumber());
            } else {
                this.mEditGroupName.setText(contactData.getName());
                this.mEditGroupNumber.setText(this.mEditContactData.getNumber());
            }
            Bitmap bitmap = this.mEditContactData.bitmap;
            if (bitmap != null) {
                this.mImgPhoto.setImageDrawable(CircleFramedDrawable.getInstance(this, bitmap));
                return;
            } else {
                this.mImgPhoto.setImageDrawable(getResources().getDrawable(R.drawable.interphone_big_contacts_default));
                return;
            }
        }
        this.mImgPhoto.setImageDrawable(getResources().getDrawable(R.drawable.interphone_big_contacts_default));
    }

    public void updateSeletedItm(int i) {
        this.mCurrentSelect = i;
        int i2 = 0;
        while (true) {
            int[] iArr = LIN_RES_ID;
            if (i2 >= iArr.length) {
                return;
            }
            if (i2 == i) {
                findViewById(iArr[i2]).setSelected(true);
            } else {
                findViewById(iArr[i2]).setSelected(false);
            }
            i2++;
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onResume() {
        super.onResume();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onPause() {
        super.onPause();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onDestroy() {
        super.onDestroy();
    }

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        if (R.id.interphone_contacts_back_button == view.getId()) {
            onBackPressed();
        } else if (isTalkSend()) {
        } else {
            switch (view.getId()) {
                case R.id.contacts_create_acitivyt_dialog_ok /* 2131296378 */:
                    dismissDialog();
                    return;
                case R.id.interphone_camera_seleted_picture /* 2131296515 */:
                    Dialog dialog = this.mCameraDialog;
                    if (dialog != null) {
                        dialog.dismiss();
                    }
                    choosePhoto();
                    return;
                case R.id.interphone_camera_take_picture /* 2131296516 */:
                    Dialog dialog2 = this.mCameraDialog;
                    if (dialog2 != null) {
                        dialog2.dismiss();
                    }
                    takePhoto();
                    return;
                case R.id.interphone_contacts_camera /* 2131296570 */:
                    showCameraDialog();
                    return;
                case R.id.interphone_contacts_save /* 2131296572 */:
                    saveData();
                    return;
                default:
                    return;
            }
        }
    }

    public String getName() {
        if (this.mCurrentType == 0) {
            return this.mEditPeopleName.getText().toString();
        }
        return this.mEditGroupName.getText().toString();
    }

    public String getId() {
        if (this.mCurrentType == 0) {
            return this.mEditPeopleNumber.getText().toString();
        }
        return this.mEditGroupNumber.getText().toString();
    }

    public void saveData() {
        Log.e(TAG, "mEditPeopleName.getText().toString() = " + this.mEditPeopleName.getText().toString());
        Log.e(TAG, "mEditPeopleNumber.getText().toString() = " + this.mEditPeopleNumber.getText().toString());
        Log.e(TAG, "mEditGroupName.getText().toString() = " + this.mEditGroupName.getText().toString());
        Log.e(TAG, "mEditGroupNumber.getText().toString() = " + this.mEditGroupNumber.getText().toString());
        int i = this.mCurrentType;
        if (i == 0) {
            if (getName().isEmpty()) {
                showToast(R.string.interphone_contacts_input_not_empty);
                return;
            }
            this.mCurrentContactData.setName(this.mEditPeopleName.getText().toString());
            if (this.isModifyData) {
                this.mEditContactData.setName(this.mEditPeopleName.getText().toString());
            }
            if (getId().isEmpty()) {
                showToast(getString(R.string.interphone_contacts_create_people_number) + getString(R.string.interphone_contacts_input_not_empty));
                return;
            }
            String obj = this.mEditPeopleNumber.getText().toString();
            if (!obj.matches("[0-9]+")) {
                showToast(R.string.fragment_local_setting_device_id_illegal_char_toast);
                return;
            } else if (Integer.parseInt(obj) < 1 || Integer.parseInt(obj) > 16776415) {
                showToast(R.string.fragment_local_setting_device_id_person_number_edit_limit_toast);
                return;
            } else {
                this.mCurrentContactData.setNumber(obj);
                this.mCurrentContactData.setBitmap(drawableToBitamp(this.mImgPhoto.getDrawable()));
                if (this.isModifyData) {
                    this.mEditContactData.setNumber(obj);
                }
            }
        } else if (i == 1) {
            if (getName().isEmpty()) {
                showToast(getString(R.string.interphone_contacts_create_group_name) + getString(R.string.interphone_contacts_input_not_empty));
                return;
            }
            this.mCurrentContactData.setName(this.mEditGroupName.getText().toString());
            if (this.isModifyData) {
                this.mEditContactData.setName(this.mEditGroupName.getText().toString());
            }
            if (getId().isEmpty()) {
                showToast(getString(R.string.interphone_contacts_create_group_number) + getString(R.string.interphone_contacts_input_not_empty));
                return;
            }
            String obj2 = this.mEditGroupNumber.getText().toString();
            if (!obj2.matches("[0-9]+")) {
                showToast(R.string.fragment_local_setting_device_id_illegal_char_toast);
                return;
            } else if (Integer.parseInt(obj2) < 1 || Integer.parseInt(obj2) > 16776415) {
                showToast(R.string.fragment_local_setting_device_id_person_number_edit_limit_toast);
                return;
            } else {
                this.mCurrentContactData.setNumber(obj2);
                if (this.isModifyData) {
                    this.mEditContactData.setNumber(obj2);
                }
            }
        }
        this.mCurrentContactData.setType(this.mCurrentType);
        if (this.isModifyData) {
            this.mEditContactData.setType(this.mCurrentType);
            this.mEditContactData.setBitmap(drawableToBitamp(this.mImgPhoto.getDrawable()));
        }
        if (this.isModifyData) {
            Log.i(TAG, "saveData: update contact " + this.mEditContactData.toString());
            DmrManager.getInstance().updateContact(this.mEditContactData);
            onBackPressed();
            return;
        }
        Log.i(TAG, "saveData: mc =" + this.mCurrentContactData.toString());
        if (DmrManager.getInstance().getContact(this.mCurrentContactData.getType(), Integer.parseInt(this.mCurrentContactData.getNumber())) != null) {
            showErrorTipDialog();
            return;
        }
        DmrManager.getInstance().saveContact(this.mCurrentContactData);
        onBackPressed();
    }

    private void showErrorTipDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.contacts_new_activity_create_error_dialog, (ViewGroup) null);
        ((TextView) inflate.findViewById(R.id.contacts_create_acitivyt_dialog_ok)).setOnClickListener(this);
        if (this.mDialog == null) {
            this.mDialog = new Dialog(this);
        }
        this.mDialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    private Bitmap drawableToBitamp(Drawable drawable) {
        int intrinsicWidth = drawable.getIntrinsicWidth();
        int intrinsicHeight = drawable.getIntrinsicHeight();
        Bitmap createBitmap = Bitmap.createBitmap(intrinsicWidth, intrinsicHeight, drawable.getOpacity() != -1 ? Bitmap.Config.ARGB_8888 : Bitmap.Config.RGB_565);
        Canvas canvas = new Canvas(createBitmap);
        drawable.setBounds(0, 0, intrinsicWidth, intrinsicHeight);
        drawable.draw(canvas);
        return createBitmap;
    }

    private void setDialogWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = dialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
    }

    private void dismissDialog() {
        Dialog dialog = this.mDialog;
        if (dialog != null) {
            dialog.dismiss();
            this.mDialog = null;
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, android.app.Activity
    public void onActivityResult(int i, int i2, @Nullable Intent intent) {
        super.onActivityResult(i, i2, intent);
        if ((i == 1002 || i == 1001 || i == 1003) && i2 == -1) {
            Log.e(TAG, "onActivityResult ok");
            Uri data = (intent == null || intent.getData() == null) ? this.mTakePictureUri : intent.getData();
            if (!"content".equals(data.getScheme())) {
                Log.e(TAG, "Invalid pictureUri scheme: " + data.getScheme());
                return;
            }
            Log.e(TAG, "onPrizeActivityResult requestCode = " + i);
            switch (i) {
                case 1001:
                case 1002:
                    if (this.mTakePictureUri.equals(data)) {
                        cropPhoto();
                        Log.e(TAG, "onPrizeActivityResult cropPhoto");
                        return;
                    }
                    Log.e(TAG, "onPrizeActivityResult copyAndCropPhoto");
                    copyAndCropPhoto(data);
                    return;
                case 1003:
                    onPhotoCropped(data, true);
                    return;
                default:
                    return;
            }
        }
    }

    private void showCameraDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.interphone_camera_dialog, (ViewGroup) null);
        if (this.mCameraDialog == null) {
            Dialog dialog = new Dialog(this);
            this.mCameraDialog = dialog;
            dialog.setContentView(inflate);
            setWindowLayoutParams(this.mCameraDialog);
        }
        this.mCameraDialog.show();
        ((TextView) inflate.findViewById(R.id.interphone_camera_take_picture)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.interphone_camera_seleted_picture)).setOnClickListener(this);
    }

    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mCameraDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mCameraDialog.dismiss();
            this.mCameraDialog = null;
            showCameraDialog();
        }
        Dialog dialog2 = this.mDialog;
        if (dialog2 != null && dialog2.isShowing()) {
            this.mDialog.dismiss();
            this.mDialog = null;
            showErrorTipDialog();
        }
        finish();
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

    private void takePhoto() {
        if (isTalkSend()) {
            return;
        }
        this.mTakePictureUri = createTempImageUri(this, UtilPicture.TAKE_PICTURE_FILE_NAME, false);
        Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
        appendOutputExtra(intent, this.mTakePictureUri);
        intent.addFlags(3);
        startActivityForResult(intent, 1002);
    }

    private void choosePhoto() {
        if (isTalkSend()) {
            return;
        }
        this.mTakePictureUri = createTempImageUri(this, UtilPicture.TAKE_PICTURE_FILE_NAME, false);
        Intent intent = new Intent("android.intent.action.GET_CONTENT", (Uri) null);
        intent.setType("image/*");
        appendOutputExtra(intent, this.mTakePictureUri);
        startActivityForResult(intent, 1001);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void cropPhoto() {
        if (isTalkSend()) {
            return;
        }
        this.mCropPictureUri = createTempImageUri(this, UtilPicture.CROP_PICTURE_FILE_NAME, false);
        Intent intent = new Intent(UtilPicture.ACTION_CROP);
        intent.setDataAndType(this.mTakePictureUri, "image/*");
        appendOutputExtra(intent, this.mCropPictureUri);
        appendCropExtras(intent);
        intent.resolveActivity(getPackageManager());
        startActivityForResult(intent, 1003);
    }

    private void copyAndCropPhoto(final Uri uri) {
        if (isTalkSend()) {
            return;
        }
        new AsyncTask<Void, Void, Void>() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.5
            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public Void doInBackground(Void... voidArr) {
                ContentResolver contentResolver = FragmentNewContactsActivity.this.getContext().getContentResolver();
                try {
                    InputStream openInputStream = contentResolver.openInputStream(uri);
                    OutputStream openOutputStream = contentResolver.openOutputStream(FragmentNewContactsActivity.this.mTakePictureUri);
                    FragmentNewContactsActivity.streamsCopy(openInputStream, openOutputStream);
                    if (openOutputStream != null) {
                        openOutputStream.close();
                    }
                    if (openInputStream != null) {
                        openInputStream.close();
                        return null;
                    }
                    return null;
                } catch (IOException e) {
                    Log.w(FragmentNewContactsActivity.TAG, "Failed to copy photo", e);
                    return null;
                }
            }

            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public void onPostExecute(Void r1) {
                FragmentNewContactsActivity.this.cropPhoto();
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
        if (isTalkSend()) {
            return;
        }
        new AsyncTask<Void, Void, Bitmap>() { // from class: com.pri.prizeinterphone.activity.FragmentNewContactsActivity.6
            /* JADX INFO: Access modifiers changed from: protected */
            /* JADX WARN: Multi-variable type inference failed */
            /* JADX WARN: Type inference failed for: r3v0 */
            /* JADX WARN: Type inference failed for: r3v1 */
            /* JADX WARN: Type inference failed for: r3v2, types: [java.io.InputStream] */
            @Override // android.os.AsyncTask
            public Bitmap doInBackground(Void... voidArr) {
                InputStream inputStream;
                return null; // TODO-FIX: JADX decompilation error in AsyncTask
            }

            /* JADX INFO: Access modifiers changed from: protected */
            @Override // android.os.AsyncTask
            public void onPostExecute(Bitmap bitmap) {
                FragmentNewContactsActivity.this.updateLocalImg(bitmap);
                new File(FragmentNewContactsActivity.this.getContext().getCacheDir(), UtilPicture.TAKE_PICTURE_FILE_NAME).delete();
                new File(FragmentNewContactsActivity.this.getContext().getCacheDir(), UtilPicture.CROP_PICTURE_FILE_NAME).delete();
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
            this.mCurrentContactData.bitmap = bitmap;
            this.isModifyImg = true;
            this.mImgPhoto.setImageDrawable(CircleFramedDrawable.getInstance(this, bitmap));
        }
    }

    private void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private void showToast(String str) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, str, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private boolean isTalkSend() {
        boolean z = PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
