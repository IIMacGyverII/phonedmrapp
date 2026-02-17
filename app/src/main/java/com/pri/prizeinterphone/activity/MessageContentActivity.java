package com.pri.prizeinterphone.activity;

import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.InterPhoneService;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.manager.MessageLisenter;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.ContactData;
import com.pri.prizeinterphone.serial.data.ConversationData;
import com.pri.prizeinterphone.serial.data.MessageData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilConversationData;
import com.pri.prizeinterphone.widget.CircleFramedDrawable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class MessageContentActivity extends AppCompatActivity implements View.OnClickListener, MessageLisenter {
    private static final String TAG = "InterPhoneMessageActivity";
    Runnable freshSendBtnRunn = new Runnable() {
        public void run() {
            MessageContentActivity.this.freshSendButton(true);
        }
    };
    private boolean isEdit = false;
    private ChannelData mActiveChannelData;
    private ContactData mActiveContactData;
    private Button mBtSend;
    private ContactData mContactData;
    private String mContactSeletedId;
    private int mConvTarget = -1;
    private int mConvType = -1;
    private ArrayList<ConversationData> mConverListData;
    private String mConverSeletedTarget;
    private ConversationData mConversation;
    private int mCurrentPosition;
    /* access modifiers changed from: private */
    public int mCurrentScrollPosition;
    private Dialog mDialog;
    private EditText mEdit;
    private RelativeLayout mEditRel;
    public Handler mHandler = new Handler() {
        public void handleMessage(Message message) {
            super.handleMessage(message);
            if (message.what == 11111) {
                MessageContentActivity.this.reFreshUI();
            }
        }
    };
    /* access modifiers changed from: private */
    public ListView mListView;
    private MessageListAdapter mMessageListAdapter;
    /* access modifiers changed from: private */
    public ArrayList<MessageData> mMessageListData;
    /* access modifiers changed from: private */
    public Drawable mRecieveIconDrawable;
    /* access modifiers changed from: private */
    public Drawable mSendIconDrawable;
    private Toast mToast;
    private TextView mTvTitle;

    public void onConversationClean(ConversationData conversationData) {
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.interphone_message_activity);
        initView();
        initData();
        DmrManager.getInstance().addMessageListener(this);
    }

    public void initView() {
        this.mTvTitle = (TextView) findViewById(R.id.interphone_message_title);
        this.mEdit = (EditText) findViewById(R.id.interphone_message_edit);
        this.mEditRel = (RelativeLayout) findViewById(R.id.interphone_message_edit_rel);
        this.mBtSend = (Button) findViewById(R.id.interphone_message_send);
        freshSendButton(true);
        this.mBtSend.setOnClickListener(this);
        this.mListView = (ListView) findViewById(R.id.interphone_message_listview);
        this.mMessageListData = new ArrayList<>();
        MessageListAdapter messageListAdapter = new MessageListAdapter(this);
        this.mMessageListAdapter = messageListAdapter;
        this.mListView.setAdapter(messageListAdapter);
        this.mListView.setOnScrollListener(new AbsListView.OnScrollListener() {
            public void onScroll(AbsListView absListView, int i, int i2, int i3) {
            }

            public void onScrollStateChanged(AbsListView absListView, int i) {
                if (i == 0) {
                    MessageContentActivity messageContentActivity = MessageContentActivity.this;
                    messageContentActivity.mCurrentScrollPosition = messageContentActivity.mListView.getFirstVisiblePosition();
                }
            }
        });
    }

    /* access modifiers changed from: private */
    public void freshSendButton(boolean z) {
        if (!z) {
            this.mBtSend.setEnabled(false);
            this.mBtSend.setBackground(getDrawable(R.drawable.interphone_message_send_unselected));
            return;
        }
        this.mBtSend.setEnabled(true);
        this.mBtSend.setBackground(getDrawable(R.drawable.interphone_message_send_selector));
    }

    /* access modifiers changed from: private */
    public void reFreshUI() {
        reFreshListUI();
    }

    private void reFreshListUI() {
        if (!(this.mConvType == -1 || this.mConvTarget == -1)) {
            this.mMessageListData.clear();
            DmrManager.getInstance().getAllSms(this.mConvType, this.mConvTarget);
            this.mMessageListData.addAll(DmrManager.getInstance().getAllSms(this.mConvType, this.mConvTarget));
        }
        this.mMessageListAdapter.notifyDataSetChanged();
        this.mListView.setSelection(InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT);
    }

    public void initData() {
        this.mActiveChannelData = DmrManager.getInstance().getCurrentChannel();
        this.mActiveContactData = DmrManager.getInstance().getContact(this.mActiveChannelData.getContactType(), this.mActiveChannelData.getTxContact());
        Intent intent = getIntent();
        boolean booleanExtra = intent.getBooleanExtra("isedit", false);
        this.isEdit = booleanExtra;
        if (booleanExtra) {
            this.mConvType = intent.getIntExtra(UtilConversationData.TABLE_CONVTYPE, 0);
            this.mConvTarget = intent.getIntExtra(UtilConversationData.TABLE_CONVTARGET, 1);
            this.mContactData = DmrManager.getInstance().getContact(this.mConvType, this.mConvTarget);
            if (!(this.mConvType == this.mActiveChannelData.getContactType() && this.mConvTarget == this.mActiveChannelData.getTxContact())) {
                hideEditBar();
            }
        } else {
            ContactData contactData = this.mActiveContactData;
            this.mContactData = contactData;
            if (contactData == null) {
                this.mConvType = this.mActiveChannelData.getContactType();
                this.mConvTarget = this.mActiveChannelData.getTxContact();
            } else {
                this.mConvType = contactData.getType();
                this.mConvTarget = Integer.parseInt(this.mContactData.getNumber());
            }
        }
        ContactData contactData2 = this.mContactData;
        if (contactData2 != null) {
            Bitmap bitmap = contactData2.getBitmap();
            if (bitmap != null) {
                this.mRecieveIconDrawable = CircleFramedDrawable.getInstance(this, bitmap);
            } else if (this.mContactData.getType() == 0) {
                this.mRecieveIconDrawable = getResources().getDrawable(R.drawable.interphone_big_contacts_default);
            } else {
                this.mRecieveIconDrawable = getResources().getDrawable(R.drawable.interphone_big_contacts_group_default);
            }
            if (this.mContactData.getName() == null || this.mContactData.getName().isEmpty()) {
                this.mTvTitle.setText(this.mContactData.getNumber());
            } else {
                this.mTvTitle.setText(this.mContactData.getName());
            }
        } else {
            this.mRecieveIconDrawable = getResources().getDrawable(R.drawable.interphone_big_contacts_default);
            TextView textView = this.mTvTitle;
            textView.setText(this.mConvTarget + "");
        }
        this.mConverListData = DmrManager.getInstance().getAllConversations();
        reFreshListUI();
        Bitmap imgData = PersonSharePrefData.getImgData(this, "pref_person_icon", (Bitmap) null);
        if (imgData == null) {
            this.mSendIconDrawable = getResources().getDrawable(R.drawable.interphone_big_contacts_default);
        } else {
            this.mSendIconDrawable = CircleFramedDrawable.getInstance(this, imgData);
        }
    }

    public void hideEditBar() {
        RelativeLayout relativeLayout = this.mEditRel;
        if (relativeLayout != null) {
            relativeLayout.setVisibility(8);
        }
    }

    private void saveAndSendMsg() {
        MessageData messageData = new MessageData();
        messageData.setContent(this.mEdit.getText().toString());
        messageData.setFrom(PersonSharePrefData.getIntData(this, "pref_person_device_id", 1));
        messageData.setTo(this.mConvTarget);
        messageData.setTimestamp(System.currentTimeMillis());
        messageData.setDirection(0);
        messageData.setConvType(this.mConvType);
        messageData.setConv_target(this.mConvTarget);
        DmrManager.getInstance().saveSms(messageData);
    }

    private void deleteData() {
        ConversationData conversationData;
        if (this.mMessageListData.size() == 1 && (conversationData = DmrManager.getInstance().getConversationData(this.mMessageListData.get(this.mCurrentPosition).getConvType(), this.mMessageListData.get(this.mCurrentPosition).getConv_target())) != null) {
            DmrManager.getInstance().deleteConverList(conversationData);
        }
        DmrManager.getInstance().deleteSms(this.mMessageListData.get(this.mCurrentPosition));
        this.mMessageListData.remove(this.mCurrentPosition);
        this.mMessageListAdapter.notifyDataSetChanged();
        this.mListView.setSelection(this.mCurrentScrollPosition);
    }

    private void deleteAllData() {
        ConversationData conversationData = DmrManager.getInstance().getConversationData(this.mMessageListData.get(this.mCurrentPosition).getConvType(), this.mMessageListData.get(this.mCurrentPosition).getConv_target());
        DmrManager.getInstance().deleteAllSms(this.mMessageListData.get(this.mCurrentPosition).getConvType(), this.mMessageListData.get(this.mCurrentPosition).getConv_target());
        this.mMessageListData.clear();
        this.mMessageListAdapter.notifyDataSetChanged();
        if (conversationData != null) {
            DmrManager.getInstance().deleteConverList(conversationData);
        }
        onBackPressed();
    }

    private void copy() {
        ((ClipboardManager) getSystemService("clipboard")).setPrimaryClip(ClipData.newPlainText((CharSequence) null, this.mMessageListData.get(this.mCurrentPosition).getContent()));
    }

    public void onBackPressed() {
        super.onBackPressed();
    }

    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.back_button) {
            onBackPressed();
        } else if (id != R.id.interphone_message_send) {
            switch (id) {
                case R.id.interphone_message_list_dialog_copy /*2131296580*/:
                    copy();
                    dismissDialog();
                    return;
                case R.id.interphone_message_list_dialog_delete /*2131296581*/:
                    if (!isTalkSend()) {
                        deleteData();
                        dismissDialog();
                        showToast(R.string.message_have_delete);
                        return;
                    }
                    return;
                case R.id.interphone_message_list_dialog_delete_all /*2131296582*/:
                    if (!isTalkSend()) {
                        deleteAllData();
                        dismissDialog();
                        showToast(R.string.message_have_delete);
                        return;
                    }
                    return;
                default:
                    return;
            }
        } else if (!this.mEdit.getText().toString().isEmpty() && !isTalkSend()) {
            saveAndSendMsg();
            this.mEdit.setText("");
            freshSendButton(false);
            this.mHandler.postDelayed(this.freshSendBtnRunn, 3500);
        }
    }

    public void onMessageReceived() {
        Log.i(TAG, "onMessageReceived: ");
        this.mHandler.post(new Runnable() {
            public void run() {
                MessageContentActivity.this.reFreshUI();
            }
        });
    }

    public void onUnreadStatusUpdated() {
        Log.i(TAG, "onUnreadStatusUpdated: ");
    }

    public void onMessageSend(final MessageData messageData) {
        Log.i(TAG, "onMessageSend: msg " + messageData.getStatus());
        this.mHandler.post(new Runnable() {
            public void run() {
                if (messageData.getStatus() == 2 || messageData.getStatus() == 3) {
                    MessageContentActivity.this.freshSendButton(true);
                    MessageContentActivity messageContentActivity = MessageContentActivity.this;
                    messageContentActivity.mHandler.removeCallbacks(messageContentActivity.freshSendBtnRunn);
                }
                MessageContentActivity.this.reFreshUI();
            }
        });
    }

    public void onMessageDelete(MessageData messageData) {
        Log.i(TAG, "onMessageDelete: ");
    }

    private class MessageListAdapter extends BaseAdapter {
        private final int VIEWTYPE_RECEIVE = 0;
        private final int VIEWTYPE_SEND = 1;
        private Context mContext;
        private String mLastTime;

        public Object getItem(int i) {
            return null;
        }

        public long getItemId(int i) {
            return 0;
        }

        public int getViewTypeCount() {
            return 2;
        }

        public MessageListAdapter(Context context) {
            this.mContext = context;
        }

        public int getCount() {
            return MessageContentActivity.this.mMessageListData.size();
        }

        public View getView(final int i, View view, ViewGroup viewGroup) {
            Log.i(MessageContentActivity.TAG, "position = " + i + "getView: " + ((MessageData) MessageContentActivity.this.mMessageListData.get(i)).toString());
            LayoutInflater from = LayoutInflater.from(this.mContext);
            int itemViewType = getItemViewType(i);
            if (itemViewType != 0) {
                if (itemViewType == 1 && view == null) {
                    view = from.inflate(R.layout.interphone_message_list_item_right, (ViewGroup) null);
                    ViewHolder viewHolder = new ViewHolder();
                    viewHolder.mTvListTime = (TextView) view.findViewById(R.id.interphone_message_list_right_time);
                    viewHolder.mTvValues = (TextView) view.findViewById(R.id.interphone_message_list_right_value);
                    viewHolder.mImgIcon = (ImageView) view.findViewById(R.id.interphone_message_list_right_icon);
                    view.setTag(viewHolder);
                }
            } else if (view == null) {
                view = from.inflate(R.layout.interphone_message_list_item_left, (ViewGroup) null);
                ViewHolder viewHolder2 = new ViewHolder();
                viewHolder2.mTvName = (TextView) view.findViewById(R.id.interphone_message_list_left_name);
                viewHolder2.mTvListTime = (TextView) view.findViewById(R.id.interphone_message_list_left_time);
                viewHolder2.mTvValues = (TextView) view.findViewById(R.id.interphone_message_list_left_value);
                viewHolder2.mImgIcon = (ImageView) view.findViewById(R.id.interphone_message_list_left_icon);
                view.setTag(viewHolder2);
            }
            ViewHolder viewHolder3 = (ViewHolder) view.getTag();
            if (i > 0) {
                String str = ((MessageData) MessageContentActivity.this.mMessageListData.get(i - 1)).getTimestamp() + "";
                this.mLastTime = str;
                if (MessageContentActivity.this.isInThreeMins(str, ((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getTimestamp() + "")) {
                    viewHolder3.mTvListTime.setVisibility(8);
                } else {
                    viewHolder3.mTvListTime.setVisibility(0);
                }
            }
            viewHolder3.mTvListTime.setText(MessageContentActivity.this.formatTime(((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getTimestamp() + ""));
            viewHolder3.mTvValues.setText(((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getContent());
            viewHolder3.mTvValues.setOnClickListener(new View.OnClickListener() {
                public void onClick(View view) {
                    MessageContentActivity.this.showListDialog(i);
                }
            });
            if (((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getDirection() == 1) {
                if (viewHolder3.mTvName != null) {
                    viewHolder3.mTvName.setText(((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getFrom() + "");
                }
                viewHolder3.mImgIcon.setImageDrawable(MessageContentActivity.this.mRecieveIconDrawable);
            } else {
                viewHolder3.mImgIcon.setImageDrawable(MessageContentActivity.this.mSendIconDrawable);
            }
            return view;
        }

        public int getItemViewType(int i) {
            return ((MessageData) MessageContentActivity.this.mMessageListData.get(i)).getDirection() == 1 ? 0 : 1;
        }

        class ViewHolder {
            /* access modifiers changed from: private */
            public ImageView mImgIcon;
            /* access modifiers changed from: private */
            public TextView mTvListTime;
            /* access modifiers changed from: private */
            public TextView mTvName;
            /* access modifiers changed from: private */
            public TextView mTvValues;

            ViewHolder() {
            }
        }
    }

    public boolean isInThreeMins(String str, String str2) {
        return Long.valueOf(str2).longValue() - Long.valueOf(str).longValue() < 18000;
    }

    public String formatTime(String str) {
        return new SimpleDateFormat("yyyy.MM.dd  ahh:mm").format(Long.valueOf(Long.valueOf(str).longValue()));
    }

    public void showListDialog(int i) {
        this.mCurrentPosition = i;
        View inflate = LayoutInflater.from(this).inflate(R.layout.interphone_message_list_dialog, (ViewGroup) null);
        ((TextView) inflate.findViewById(R.id.interphone_message_list_dialog_copy)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.interphone_message_list_dialog_delete)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.interphone_message_list_dialog_delete_all)).setOnClickListener(this);
        Dialog dialog = new Dialog(this);
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mDialog.dismiss();
            this.mDialog = null;
            showListDialog(this.mCurrentPosition);
        }
    }

    private void setDialogWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = dialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (((float) i) * 0.9f);
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

    private void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private boolean isTalkSend() {
        boolean z = false;
        if (PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1) {
            z = true;
        }
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
