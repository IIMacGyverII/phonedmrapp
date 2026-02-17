package com.pri.prizeinterphone.widget;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.pri.prizeinterphone.R;

public class CameraDialog extends AlertDialog implements View.OnClickListener {
    private Button mCameraDialogDelete;
    private Button mCameraDialogSelete;
    private Button mCameraDialogTake;
    private Context mContext;
    private onClickCameraDialogListener onClickCameraDialogListener;

    public interface onClickCameraDialogListener {
        void onDeletePhoto();

        void onSelectPhoto();

        void onTakePhoto();
    }

    public CameraDialog(@NonNull Context context) {
        super(context);
    }

    public CameraDialog(@NonNull Context context, int i) {
        super(context, i);
    }

    public CameraDialog(@NonNull Context context, boolean z, @Nullable DialogInterface.OnCancelListener onCancelListener) {
        super(context, z, onCancelListener);
        this.mContext = context;
    }

    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.local_delete_photo) {
            this.onClickCameraDialogListener.onDeletePhoto();
        } else if (id == R.id.local_select_photo) {
            this.onClickCameraDialogListener.onSelectPhoto();
        } else if (id == R.id.local_take_photo) {
            this.onClickCameraDialogListener.onTakePhoto();
        }
        cancel();
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        View inflate = LayoutInflater.from(this.mContext).inflate(R.layout.fragment_camera_dialog, (ViewGroup) null);
        setContentView(inflate);
        initView(inflate);
    }

    private void initView(View view) {
        Button button = (Button) view.findViewById(R.id.local_delete_photo);
        this.mCameraDialogDelete = button;
        button.setOnClickListener(this);
        Button button2 = (Button) view.findViewById(R.id.local_take_photo);
        this.mCameraDialogTake = button2;
        button2.setOnClickListener(this);
        Button button3 = (Button) view.findViewById(R.id.local_select_photo);
        this.mCameraDialogSelete = button3;
        button3.setOnClickListener(this);
        WindowManager.LayoutParams attributes = getWindow().getAttributes();
        attributes.height = 480;
        attributes.width = 400;
    }

    public void setOnClickCameraDialogListener(onClickCameraDialogListener onclickcameradialoglistener) {
        this.onClickCameraDialogListener = onclickcameradialoglistener;
    }
}
