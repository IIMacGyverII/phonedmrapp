package com.pri.prizeinterphone.fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentManager;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.UtilDensity;
import com.pri.prizeinterphone.activity.MessageContentActivity;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.manager.MessageLisenter;
import com.pri.prizeinterphone.serial.data.ConversationData;
import com.pri.prizeinterphone.serial.data.MessageData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilContactsData;
import com.pri.prizeinterphone.serial.data.UtilConversationData;
import com.pri.prizeinterphone.widget.SpinerPopWindow;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class InterPhoneMessageFragment extends BaseViewPagerFragment implements AdapterView.OnItemClickListener, AdapterView.OnItemLongClickListener, AdapterView.OnItemSelectedListener, MessageLisenter, SpinerPopWindow.PrizeOnItemClickListener {
    private static final int REQUEST_CODE_ADD_MESSAGE = 1001;
    private static final int REQUEST_CODE_EDIT_CONV = 1004;
    private static final int REQUEST_CODE_EDIT_MESSAGE = 1002;
    private static final String TAG = "InterPhoneMessageFragment";
    public int deleteIndex = -1;
    private ArrayList<ConversationData> mConversationDataList;
    private TextView mEmptyMessageWarning;
    private FragmentManager mFragmentManager;
    public Handler mHandler = new Handler() {
        public void handleMessage(Message message) {
            super.handleMessage(message);
            if (message.what == 11111) {
                InterPhoneMessageFragment.this.reFreshUI();
            }
        }
    };
    private View mLocalView;
    private MessageListAdapter mMessageListAdapter;
    private ListView mMessagetListView;
    private SpinerPopWindow mPopWindow;
    private Toast mToast;
    private UtilContactsData mUtilContactsDataPeople;
    private UtilConversationData mUtilConversationData;

    public String getMyTag() {
        return TAG;
    }

    public void onConversationClean(ConversationData conversationData) {
    }

    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.fragment_message_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        setAddButton(R.drawable.interphone_add_seletor);
        this.mEmptyMessageWarning = (TextView) this.mLocalView.findViewById(R.id.empty_message_warning);
        ListView listView = (ListView) this.mLocalView.findViewById(R.id.fragment_message_listview);
        this.mMessagetListView = listView;
        listView.setOnItemClickListener(this);
        this.mMessagetListView.setOnItemLongClickListener(this);
        this.mMessagetListView.setOnItemSelectedListener(this);
        this.mConversationDataList = new ArrayList<>();
        MessageListAdapter messageListAdapter = new MessageListAdapter(getContext(), this.mConversationDataList);
        this.mMessageListAdapter = messageListAdapter;
        this.mMessagetListView.setAdapter(messageListAdapter);
        DmrManager.getInstance().addMessageListener(this);
        SpinerPopWindow spinerPopWindow = new SpinerPopWindow(getContext());
        this.mPopWindow = spinerPopWindow;
        spinerPopWindow.setPrizeOnItemClickListener(this);
    }

    public void onResume() {
        super.onResume();
        if (isAdded()) {
            setTitle(getString(R.string.fragment_title_message));
        }
        reFreshUI();
    }

    public void onDestroy() {
        super.onDestroy();
        DmrManager.getInstance().removeMessageListener((MessageLisenter) this);
    }

    /* access modifiers changed from: private */
    public void reFreshUI() {
        if (isAdded() && this.mMessageListAdapter != null) {
            this.mConversationDataList = DmrManager.getInstance().getAllConversations();
            int i = 0;
            while (i < this.mConversationDataList.size()) {
                if (this.mConversationDataList.get(i).getName().equals("")) {
                    this.mConversationDataList.remove(i);
                } else {
                    i++;
                }
            }
            this.mMessageListAdapter.setList(this.mConversationDataList);
            this.mMessageListAdapter.notifyDataSetChanged();
            if (this.mConversationDataList.size() == 0) {
                this.mEmptyMessageWarning.setVisibility(0);
                this.mEmptyMessageWarning.setText(R.string.empty_message_warning);
                this.mMessagetListView.setVisibility(8);
                return;
            }
            this.mEmptyMessageWarning.setVisibility(8);
            this.mMessagetListView.setVisibility(0);
        }
    }

    public void doAddAction() {
        super.doAddAction();
        if (!isTalkSend()) {
            getActivity().startActivityForResult(new Intent(getActivity(), MessageContentActivity.class), 1001);
        }
    }

    public void onActivityResult(int i, int i2, @Nullable Intent intent) {
        super.onActivityResult(i, i2, intent);
        Log.i(TAG, "onActivityResult: resultCode ");
    }

    public void updateView() {
        super.updateView();
        reFreshUI();
    }

    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (!isTalkSend()) {
            ConversationData conversationData = this.mConversationDataList.get(i);
            conversationData.setUnReadCount(0);
            DmrManager.getInstance().updateConversation(conversationData);
            Intent intent = new Intent(getActivity(), MessageContentActivity.class);
            intent.putExtra("isedit", true);
            Log.i(TAG, "onItemClick: " + conversationData.toString());
            intent.putExtra(UtilConversationData.TABLE_CONVTYPE, conversationData.getConvType());
            intent.putExtra(UtilConversationData.TABLE_CONVTARGET, conversationData.getConvTarget());
            getActivity().startActivity(intent);
        }
    }

    public void onItemClick(int i) {
        if (!isTalkSend()) {
            ConversationData conversationData = this.mConversationDataList.get(i);
            conversationData.setUnReadCount(0);
            DmrManager.getInstance().updateConversation(conversationData);
            Intent intent = new Intent(getActivity(), MessageContentActivity.class);
            intent.putExtra("isedit", true);
            Log.i(TAG, "onItemClick: " + conversationData.toString());
            intent.putExtra(UtilConversationData.TABLE_CONVTYPE, conversationData.getConvType());
            intent.putExtra(UtilConversationData.TABLE_CONVTARGET, conversationData.getConvTarget());
            getActivity().startActivity(intent);
        }
    }

    public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (isTalkSend()) {
            return false;
        }
        Log.i(TAG, "onItemLongClick: position " + i);
        this.deleteIndex = i;
        showPopupWindow(view);
        return true;
    }

    public void setOnItemClick(String str) {
        if (!isTalkSend()) {
            this.mPopWindow.dismiss();
            if (this.deleteIndex != -1) {
                DmrManager.getInstance().deleteConverList(this.mConversationDataList.get(this.deleteIndex));
                DmrManager.getInstance().deleteAllSms(this.mConversationDataList.get(this.deleteIndex).getConvType(), this.mConversationDataList.get(this.deleteIndex).getConvTarget());
                showToast(R.string.messagelist_have_delete);
            }
            reFreshUI();
            this.deleteIndex = -1;
        }
    }

    private void showPopupWindow(View view) {
        if (!isTalkSend()) {
            int dip2px = UtilDensity.dip2px(getContext(), 50.0f);
            ArrayList arrayList = new ArrayList();
            arrayList.add(getString(R.string.interphone_message_list_dialog_delete));
            this.mPopWindow.refreshData(arrayList, getString(R.string.interphone_message_list_dialog_delete));
            this.mPopWindow.setNotShowSelect(true);
            this.mPopWindow.setWidth((int) (((double) dip2px) * 3.3d));
            this.mPopWindow.setHeight(dip2px);
            this.mPopWindow.showAsDropDown(view);
        }
    }

    public void onMessageReceived() {
        Log.i(TAG, "onMessageReceived: ");
        this.mHandler.post(new Runnable() {
            public void run() {
                InterPhoneMessageFragment.this.reFreshUI();
            }
        });
    }

    public void onUnreadStatusUpdated() {
        Log.i(TAG, "onUnreadStatusUpdated: ");
    }

    public void onMessageSend(MessageData messageData) {
        Log.i(TAG, "onMessageSend: ");
        this.mHandler.post(new Runnable() {
            public void run() {
                InterPhoneMessageFragment.this.reFreshUI();
            }
        });
    }

    public void onMessageDelete(MessageData messageData) {
        Log.i(TAG, "onMessageDelete: ");
    }

    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long j) {
        Log.i(TAG, "onItemSelected: ");
    }

    public void onNothingSelected(AdapterView<?> adapterView) {
        Log.i(TAG, "onNothingSelected: ");
    }

    private class MessageListAdapter extends BaseAdapter {
        private Context mContext;
        private int mDeleteItemIndex = 0;
        private ArrayList<ConversationData> mList;

        public Object getItem(int i) {
            return null;
        }

        public long getItemId(int i) {
            return 0;
        }

        public MessageListAdapter(Context context, ArrayList<ConversationData> arrayList) {
            this.mContext = context;
            this.mList = arrayList;
        }

        public int getDeleteItemIndex() {
            return this.mDeleteItemIndex;
        }

        public void setDeleteItemIndex(int i) {
            this.mDeleteItemIndex = i;
        }

        public int getCount() {
            return this.mList.size();
        }

        public void setList(ArrayList<ConversationData> arrayList) {
            this.mList = arrayList;
        }

        public View getView(int i, View view, ViewGroup viewGroup) {
            ViewHolder viewHolder = new ViewHolder();
            LayoutInflater from = LayoutInflater.from(this.mContext);
            if (view == null) {
                view = from.inflate(R.layout.fragment_message_list_item, (ViewGroup) null);
                viewHolder.mItemview = (LinearLayout) view.findViewById(R.id.message_list_item_view);
                viewHolder.mTvListName = (TextView) view.findViewById(R.id.message_list_item_name);
                viewHolder.mTvListContent = (TextView) view.findViewById(R.id.message_list_item_content);
                viewHolder.mTvListUnread = (TextView) view.findViewById(R.id.message_list_item_unread);
                viewHolder.mTvListTime = (TextView) view.findViewById(R.id.message_list_item_time);
                viewHolder.mImgIcon = (ImageView) view.findViewById(R.id.message_list_item_icon);
                viewHolder.mLine = view.findViewById(R.id.message_list_item_line);
                view.setTag(viewHolder);
            }
            ViewHolder viewHolder2 = (ViewHolder) view.getTag();
            ConversationData conversationData = this.mList.get(i);
            Log.i(InterPhoneMessageFragment.TAG, "getView: conver " + conversationData.toString());
            if (conversationData.getUnReadCount() > 0) {
                viewHolder2.mTvListUnread.setVisibility(0);
                if (conversationData.getUnReadCount() > 99) {
                    viewHolder2.mTvListUnread.setText("99+");
                } else {
                    TextView r0 = viewHolder2.mTvListUnread;
                    r0.setText(conversationData.getUnReadCount() + "");
                }
            } else {
                viewHolder2.mTvListUnread.setVisibility(8);
            }
            MessageData lastSms = DmrManager.getInstance().getLastSms(conversationData.getConvType(), conversationData.getConvTarget());
            if (lastSms != null) {
                viewHolder2.mTvListContent.setText(lastSms.getContent());
            }
            if (conversationData.getConvType() == 0) {
                viewHolder2.mImgIcon.setImageDrawable(this.mContext.getDrawable(R.drawable.interphone_contacts_people_icon));
            } else {
                viewHolder2.mImgIcon.setImageDrawable(this.mContext.getDrawable(R.drawable.interphone_contacts_group_icon));
            }
            viewHolder2.mTvListName.setText(conversationData.getName());
            viewHolder2.mTvListTime.setText(new SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(conversationData.getTimestamp()));
            return view;
        }

        class ViewHolder {
            /* access modifiers changed from: private */
            public ImageView mImgIcon;
            /* access modifiers changed from: private */
            public LinearLayout mItemview;
            /* access modifiers changed from: private */
            public View mLine;
            /* access modifiers changed from: private */
            public TextView mTvListContent;
            /* access modifiers changed from: private */
            public TextView mTvListName;
            /* access modifiers changed from: private */
            public TextView mTvListTime;
            /* access modifiers changed from: private */
            public TextView mTvListUnread;

            ViewHolder() {
            }
        }
    }

    public String getMessageListItemId(String str) {
        String[] split = str.split("_");
        return split.length > 1 ? split[1] : "1";
    }

    public int getMessageListItemType(String str) {
        String[] split = str.split("_");
        if (split.length <= 1) {
            return 0;
        }
        String str2 = split[1];
        return Integer.parseInt(split[0]) == 0 ? 0 : 1;
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
