package com.mediatek.widget;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.util.Log;
import android.widget.RemoteViews;
import com.mediatek.internal.R;
import java.util.List;

public class CustomAccountRemoteViews {
    private static final int MOSTACCOUNTNUMBER = 8;
    private static final int ROWACCOUNTNUMBER = 4;
    private static final String TAG = "CustomAccountRemoteViews";
    private final int[][] RESOURCE_ID;
    private RemoteViews mBigRemoteViews;
    private Context mContext;
    private List<AccountInfo> mData;
    private RemoteViews mNormalRemoteViews;
    private int mRequestCode;

    private final class IdIndex {
        public static final int CONTAINER_ID = 0;
        public static final int HIGHTLIGHT_DIVIDER_ID = 5;
        public static final int IMG_ID = 1;
        public static final int NAME_ID = 2;
        public static final int NORMAL_DIVIDER_ID = 4;
        public static final int NUMBER_ID = 3;

        private IdIndex() {
        }
    }

    public CustomAccountRemoteViews(Context context, String str) {
        this(context, str, (List<AccountInfo>) null);
    }

    public CustomAccountRemoteViews(Context context, String str, List<AccountInfo> list) {
        this.RESOURCE_ID = new int[][]{new int[]{R.id.account_zero_container, R.id.account_zero_img, R.id.account_zero_name, R.id.account_zero_number, R.id.account_zero_normal_divider, R.id.account_zero_highlight_divider}, new int[]{R.id.account_one_container, R.id.account_one_img, R.id.account_one_name, R.id.account_one_number, R.id.account_one_normal_divider, R.id.account_one_highlight_divider}, new int[]{R.id.account_two_container, R.id.account_two_img, R.id.account_two_name, R.id.account_two_number, R.id.account_two_normal_divider, R.id.account_two_highlight_divider}, new int[]{R.id.account_three_container, R.id.account_three_img, R.id.account_three_name, R.id.account_three_number, R.id.account_three_normal_divider, R.id.account_three_highlight_divider}, new int[]{R.id.account_four_container, R.id.account_four_img, R.id.account_four_name, R.id.account_four_number, R.id.account_four_normal_divider, R.id.account_four_highlight_divider}, new int[]{R.id.account_five_container, R.id.account_five_img, R.id.account_five_name, R.id.account_five_number, R.id.account_five_normal_divider, R.id.account_five_highlight_divider}, new int[]{R.id.account_six_container, R.id.account_six_img, R.id.account_six_name, R.id.account_six_number, R.id.account_six_normal_divider, R.id.account_six_highlight_divider}, new int[]{R.id.account_seven_container, R.id.account_seven_img, R.id.account_seven_name, R.id.account_seven_number, R.id.account_seven_normal_divider, R.id.account_seven_highlight_divider}};
        this.mNormalRemoteViews = new RemoteViews(str, R.layout.normal_default_account_select_title);
        this.mBigRemoteViews = new RemoteViews(str, R.layout.custom_select_default_account_notification);
        this.mData = list;
        this.mContext = context;
        this.mRequestCode = 0;
    }

    public RemoteViews getNormalRemoteViews() {
        return this.mNormalRemoteViews;
    }

    public RemoteViews getBigRemoteViews() {
        return this.mBigRemoteViews;
    }

    public void setData(List<AccountInfo> list) {
        this.mData = list;
    }

    public void configureView() {
        if (this.mData != null) {
            Log.d(TAG, "---configureView---view size = " + this.mData.size());
            int i = 4;
            if (this.mData.size() > 4) {
                this.mBigRemoteViews.setViewVisibility(R.id.select_account_row_two_container, 0);
            }
            int i2 = 0;
            while (i2 < this.mData.size() && i2 < 8) {
                Log.d(TAG, "--- configure account id: " + i2);
                configureAccount(this.RESOURCE_ID[i2], this.mData.get(i2));
                i2++;
            }
            if (this.mData.size() <= 4) {
                this.mBigRemoteViews.setViewVisibility(R.id.select_account_row_two_container, 8);
            } else {
                i = 8;
            }
            for (int size = this.mData.size(); size < i; size++) {
                this.mBigRemoteViews.setViewVisibility(this.RESOURCE_ID[size][0], 8);
            }
            return;
        }
        Log.w(TAG, "Data can not be null");
    }

    private void configureAccount(int[] iArr, AccountInfo accountInfo) {
        if (accountInfo.getIcon() != null) {
            this.mBigRemoteViews.setViewVisibility(iArr[0], 0);
            this.mBigRemoteViews.setImageViewBitmap(iArr[1], accountInfo.getIcon());
        } else if (accountInfo.getIconId() != 0) {
            this.mBigRemoteViews.setViewVisibility(iArr[0], 0);
            this.mBigRemoteViews.setImageViewResource(iArr[1], accountInfo.getIconId());
        } else {
            Log.w(TAG, "--- The icon of account is null ---");
        }
        if (accountInfo.getLabel() == null) {
            this.mBigRemoteViews.setViewVisibility(iArr[2], 8);
        } else {
            this.mBigRemoteViews.setTextViewText(iArr[2], accountInfo.getLabel());
        }
        if (accountInfo.getNumber() == null) {
            this.mBigRemoteViews.setViewVisibility(iArr[3], 8);
        } else {
            this.mBigRemoteViews.setTextViewText(iArr[3], accountInfo.getNumber());
        }
        Log.d(TAG, "active: " + accountInfo.isActive());
        if (accountInfo.isActive()) {
            this.mBigRemoteViews.setViewVisibility(iArr[4], 8);
            this.mBigRemoteViews.setViewVisibility(iArr[5], 0);
        } else {
            this.mBigRemoteViews.setViewVisibility(iArr[4], 0);
            this.mBigRemoteViews.setViewVisibility(iArr[5], 8);
        }
        if (accountInfo.getIntent() != null) {
            Context context = this.mContext;
            int i = this.mRequestCode;
            this.mRequestCode = i + 1;
            this.mBigRemoteViews.setOnClickPendingIntent(iArr[0], PendingIntent.getBroadcast(context, i, accountInfo.getIntent(), 134217728));
        }
    }

    public static class AccountInfo {
        private Bitmap mIcon;
        private int mIconId;
        private Intent mIntent;
        private boolean mIsActive;
        private String mLabel;
        private String mNumber;

        public AccountInfo(Bitmap bitmap, String str, String str2, Intent intent) {
            this(0, bitmap, str, str2, intent, false);
        }

        public AccountInfo(int i, String str, String str2, Intent intent) {
            this(i, (Bitmap) null, str, str2, intent, false);
        }

        public AccountInfo(int i, Bitmap bitmap, String str, String str2, Intent intent, boolean z) {
            this.mIconId = i;
            this.mIcon = bitmap;
            this.mLabel = str;
            this.mNumber = str2;
            this.mIntent = intent;
            this.mIsActive = z;
        }

        public int getIconId() {
            int i = this.mIconId;
            if (i != 0) {
                return i;
            }
            return 0;
        }

        public Bitmap getIcon() {
            Bitmap bitmap = this.mIcon;
            if (bitmap != null) {
                return bitmap;
            }
            return null;
        }

        public String getLabel() {
            return this.mLabel;
        }

        public String getNumber() {
            return this.mNumber;
        }

        public Intent getIntent() {
            return this.mIntent;
        }

        public boolean isActive() {
            return this.mIsActive;
        }

        public void setActiveStatus(boolean z) {
            this.mIsActive = z;
        }
    }
}
