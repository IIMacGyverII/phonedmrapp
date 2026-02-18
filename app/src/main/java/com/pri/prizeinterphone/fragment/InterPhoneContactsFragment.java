package com.pri.prizeinterphone.fragment;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.activity.FragmentNewContactsActivity;
import com.pri.prizeinterphone.manager.ContactLisenter;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.ContactData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilContactsData;
import com.pri.prizeinterphone.widget.CircleFramedDrawable;
import java.util.ArrayList;
/* loaded from: classes4.dex */
public class InterPhoneContactsFragment extends BaseViewPagerFragment implements View.OnClickListener, AdapterView.OnItemClickListener, ContactLisenter, DmrManager.UpdateListener {
    private static final int REQUEST_CREATE_CONTACT = 1004;
    private boolean isNoGroup;
    private boolean isNoPeople;
    private int mActiveContactId;
    private int mActiveContactType;
    private int mCurrentClick;
    private int mCurrentSeletedId;
    private int mCurrentSeletedType;
    private Dialog mDialog;
    private FragmentManager mFragmentManager;
    private ContactsListAdapter mGroupAdapter;
    private ArrayList<ContactData> mGroupList;
    private ListView mGroupListView;
    private LinearLayout mLinContactsNoPeople;
    private View mLocalView;
    private ContactsListAdapter mPeopleAdapter;
    private UtilContactsData mPeopleDB;
    private ArrayList<ContactData> mPeopleList;
    private ListView mPeopleListView;
    private View mRelContactsGroup;
    private View mRelContactsPeople;
    private Toast mToast;
    private TextView mTvContactsCreate;
    private TextView mTvContactsNoPeople;
    private final String TAG = "InterPhoneContactsFragment";
    private int mCurrentType = 0;
    private int mCurrentSeleted = -1;
    private Runnable mUpdateChannelListRunnable = new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneContactsFragment.1
        @Override // java.lang.Runnable
        public void run() {
            Log.i("InterPhoneContactsFragment", "run: mUpdateChannelListRunnable");
            InterPhoneContactsFragment.this.initData();
            InterPhoneContactsFragment interPhoneContactsFragment = InterPhoneContactsFragment.this;
            interPhoneContactsFragment.refreshUI(interPhoneContactsFragment.mCurrentType);
        }
    };

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public String getMyTag() {
        return "InterPhoneContactsFragment";
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.fragment_contacts_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        setAddButton(R.drawable.interphone_add_seletor);
        View findViewById = this.mLocalView.findViewById(R.id.fragment_contacts_people_rel);
        this.mRelContactsPeople = findViewById;
        findViewById.setOnClickListener(this);
        View findViewById2 = this.mLocalView.findViewById(R.id.fragment_contacts_group_rel);
        this.mRelContactsGroup = findViewById2;
        findViewById2.setOnClickListener(this);
        this.mLinContactsNoPeople = (LinearLayout) this.mLocalView.findViewById(R.id.fragment_contacts_nopeople_lin);
        this.mTvContactsNoPeople = (TextView) this.mLocalView.findViewById(R.id.fragment_contacts_no_people);
        TextView textView = (TextView) this.mLocalView.findViewById(R.id.fragment_contacts_create);
        this.mTvContactsCreate = textView;
        textView.setOnClickListener(this);
        this.mPeopleListView = (ListView) this.mLocalView.findViewById(R.id.fragment_contacts_people_list);
        this.mGroupListView = (ListView) this.mLocalView.findViewById(R.id.fragment_contacts_group_list);
        ContactsListAdapter contactsListAdapter = new ContactsListAdapter(getContext());
        this.mPeopleAdapter = contactsListAdapter;
        this.mPeopleListView.setAdapter((ListAdapter) contactsListAdapter);
        this.mPeopleListView.setOnItemClickListener(this);
        ContactsListAdapter contactsListAdapter2 = new ContactsListAdapter(getContext());
        this.mGroupAdapter = contactsListAdapter2;
        this.mGroupListView.setAdapter((ListAdapter) contactsListAdapter2);
        this.mGroupListView.setOnItemClickListener(this);
        DmrManager.getInstance().addContactListener(this);
        DmrManager.getInstance().registerUpdateListener(this);
        initData();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void initData() {
        try {
            this.mActiveContactId = DmrManager.getInstance().getCurrentChannel().getTxContact();
            this.mActiveContactType = DmrManager.getInstance().getCurrentChannel().getContactType();
            this.mPeopleList = DmrManager.getInstance().getAllContacts(0);
            Log.d("InterPhoneContactsFragment", "initData().mPeopleList.size()=" + this.mPeopleList.size());
            this.mPeopleAdapter.setList(this.mPeopleList);
            if (this.mPeopleList.size() > 0) {
                this.isNoPeople = false;
            } else {
                this.isNoPeople = true;
            }
            ArrayList<ContactData> allContacts = DmrManager.getInstance().getAllContacts(1);
            this.mGroupList = allContacts;
            this.mGroupAdapter.setList(allContacts);
            Log.d("InterPhoneContactsFragment", "initData().mGroupList.size()=" + this.mGroupList.size());
            if (this.mGroupList.size() > 0) {
                this.isNoGroup = false;
            } else {
                this.isNoGroup = true;
            }
            refreshUI(this.mCurrentType);
        } catch (Exception e) {
            Log.d("InterPhoneContactsFragment", "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null", e);
        }
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void doAddAction() {
        super.doAddAction();
        if (isTalkSend()) {
            return;
        }
        createActivity(this.mCurrentType, null);
    }

    @Override // androidx.fragment.app.Fragment
    public void onResume() {
        super.onResume();
        Log.d("InterPhoneContactsFragment", "onResume");
        if (isAdded()) {
            setTitle(getString(R.string.fragment_title_contacts));
        }
        initData();
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void updateView() {
        super.updateView();
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        if (isTalkSend()) {
            return;
        }
        switch (view.getId()) {
            case R.id.contacts_edit_dialog_delete /* 2131296379 */:
                deleteData();
                dismissDialog();
                return;
            case R.id.contacts_edit_dialog_edit /* 2131296380 */:
                showEditActivity();
                dismissDialog();
                return;
            case R.id.contacts_edit_dialog_use /* 2131296381 */:
                saveSelectedData();
                refreshList();
                dismissDialog();
                return;
            case R.id.contacts_no_edit_dialog_ok /* 2131296388 */:
                dismissDialog();
                return;
            case R.id.fragment_contacts_create /* 2131296459 */:
                createActivity(this.mCurrentType, null);
                return;
            case R.id.fragment_contacts_group_rel /* 2131296461 */:
                refreshUI(1);
                return;
            case R.id.fragment_contacts_people_rel /* 2131296465 */:
                refreshUI(0);
                return;
            default:
                return;
        }
    }

    private void showEditActivity() {
        ContactData contactData;
        int i = this.mCurrentType;
        if (i == 0) {
            contactData = this.mPeopleList.get(this.mCurrentClick);
        } else {
            contactData = i == 1 ? this.mGroupList.get(this.mCurrentClick) : null;
        }
        createActivity(this.mCurrentType, contactData);
    }

    private void deleteData() {
        ContactData contactData;
        if (this.mCurrentType == 0) {
            contactData = this.mPeopleList.get(this.mCurrentClick);
        } else {
            contactData = this.mGroupList.get(this.mCurrentClick);
        }
        DmrManager.getInstance().deleteContact(contactData);
    }

    private void saveSelectedData() {
        int i = this.mCurrentClick;
        this.mCurrentSeleted = i;
        int i2 = this.mCurrentType;
        if (i2 == 0) {
            this.mCurrentSeletedId = Integer.parseInt(this.mPeopleList.get(i).getNumber());
        } else if (i2 == 1) {
            this.mCurrentSeletedId = Integer.parseInt(this.mGroupList.get(i).getNumber());
        }
        ChannelData currentChannel = DmrManager.getInstance().getCurrentChannel();
        if (currentChannel != null) {
            currentChannel.setTxContact(this.mCurrentSeletedId);
            currentChannel.setContactType(this.mCurrentType);
        }
        DmrManager.getInstance().updateChannel(currentChannel);
        initData();
    }

    private void refreshList() {
        ContactsListAdapter contactsListAdapter = this.mPeopleAdapter;
        if (contactsListAdapter != null) {
            contactsListAdapter.notifyDataSetChanged();
        }
        ContactsListAdapter contactsListAdapter2 = this.mGroupAdapter;
        if (contactsListAdapter2 != null) {
            contactsListAdapter2.notifyDataSetChanged();
        }
    }

    private void createActivity(int i, ContactData contactData) {
        Intent intent = new Intent(getActivity(), FragmentNewContactsActivity.class);
        if (this.mCurrentType == 0) {
            intent.putExtra(UtilContactsData.TABLE_TYPE, 0);
        } else if (i == 1) {
            intent.putExtra(UtilContactsData.TABLE_TYPE, 1);
        }
        if (contactData != null) {
            intent.putExtra("_id", contactData.getId());
            intent.putExtra("isedit", true);
        }
        startActivityForResult(intent, 1004);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void refreshUI(int i) {
        if (isAdded()) {
            this.mCurrentType = i;
            this.mCurrentSeletedType = i;
            if (i == 0) {
                this.mRelContactsPeople.setSelected(true);
                this.mRelContactsGroup.setSelected(false);
                if (this.isNoPeople) {
                    this.mLinContactsNoPeople.setVisibility(0);
                    this.mTvContactsNoPeople.setText(getString(R.string.fragment_contacts_no_people));
                    this.mTvContactsCreate.setText(getString(R.string.fragment_contacts_create));
                } else {
                    this.mLinContactsNoPeople.setVisibility(8);
                }
                this.mPeopleListView.setVisibility(0);
                this.mGroupListView.setVisibility(8);
            } else if (i == 1) {
                this.mRelContactsPeople.setSelected(false);
                this.mRelContactsGroup.setSelected(true);
                if (this.isNoGroup) {
                    this.mLinContactsNoPeople.setVisibility(0);
                    this.mTvContactsNoPeople.setText(getString(R.string.fragment_contacts_no_group));
                    this.mTvContactsCreate.setText(getString(R.string.fragment_contacts_create_group));
                } else {
                    this.mLinContactsNoPeople.setVisibility(8);
                }
                this.mPeopleListView.setVisibility(8);
                this.mGroupListView.setVisibility(0);
            }
            refreshList();
        }
    }

    @Override // android.widget.AdapterView.OnItemClickListener
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (isTalkSend()) {
            return;
        }
        int i2 = this.mCurrentType;
        if (i2 == 0) {
            if (this.mActiveContactId == Integer.parseInt(this.mPeopleList.get(i).getNumber()) && this.mActiveContactType == this.mPeopleList.get(i).getType()) {
                showDialog();
            } else {
                showEditDialog(i);
            }
        } else if (i2 == 1) {
            if (this.mActiveContactId == Integer.parseInt(this.mGroupList.get(i).getNumber()) && this.mActiveContactType == this.mGroupList.get(i).getType()) {
                showDialog();
            } else {
                showEditDialog(i);
            }
        }
    }

    private void showDialog() {
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_contacts_no_edit_dialog, (ViewGroup) null);
        ((TextView) inflate.findViewById(R.id.contacts_no_edit_dialog_ok)).setOnClickListener(this);
        Dialog dialog = new Dialog(getActivity());
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    private void showEditDialog(int i) {
        this.mCurrentClick = i;
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_contacts_edit_dialog, (ViewGroup) null);
        ((TextView) inflate.findViewById(R.id.contacts_edit_dialog_use)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.contacts_edit_dialog_edit)).setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.contacts_edit_dialog_delete)).setOnClickListener(this);
        Dialog dialog = new Dialog(getActivity());
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    @Override // androidx.fragment.app.Fragment, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDialog;
        if (dialog == null || !dialog.isShowing()) {
            return;
        }
        this.mDialog.dismiss();
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

    @Override // com.pri.prizeinterphone.manager.ContactLisenter
    public void onContactAdded(ContactData contactData) {
        Log.i("InterPhoneContactsFragment", "onContactAdded: ");
        initData();
    }

    @Override // com.pri.prizeinterphone.manager.ContactLisenter
    public void onContactRemoved(ContactData contactData) {
        Log.i("InterPhoneContactsFragment", "onContactRemoved: ");
        initData();
    }

    @Override // com.pri.prizeinterphone.manager.ContactLisenter
    public void onContactUpdated(ContactData contactData) {
        Log.i("InterPhoneContactsFragment", "onContactUpdated: ");
        initData();
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
    public void updateTalkBackChannelList() {
        this.mHandler.post(this.mUpdateChannelListRunnable);
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
    public void updateModuleInit() {
        Log.i("InterPhoneContactsFragment", "updateModuleInit: ");
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class ContactsListAdapter extends BaseAdapter {
        private Context mContext;
        private ArrayList<ContactData> mList;

        @Override // android.widget.Adapter
        public Object getItem(int i) {
            return null;
        }

        @Override // android.widget.Adapter
        public long getItemId(int i) {
            return i;
        }

        public ContactsListAdapter(Context context) {
            Log.i("InterPhoneContactsFragment", "ContactsListAdapter: ");
            this.mContext = context;
        }

        @Override // android.widget.Adapter
        public int getCount() {
            ArrayList<ContactData> arrayList = this.mList;
            if (arrayList == null) {
                return 0;
            }
            return arrayList.size();
        }

        public void setList(ArrayList<ContactData> arrayList) {
            this.mList = arrayList;
        }

        @Override // android.widget.Adapter
        public View getView(int i, View view, ViewGroup viewGroup) {
            View view2;
            ViewHolder viewHolder;
            if (view == null) {
                viewHolder = new ViewHolder();
                view2 = LayoutInflater.from(this.mContext).inflate(R.layout.fragment_contacts_list_item, (ViewGroup) null);
                viewHolder.mTvListName = (TextView) view2.findViewById(R.id.contacts_list_item_name);
                viewHolder.mTvListNumber = (TextView) view2.findViewById(R.id.contacts_list_item_id);
                viewHolder.mImgIcon = (ImageView) view2.findViewById(R.id.contacts_list_item_icon);
                viewHolder.mImgListSelect = (ImageView) view2.findViewById(R.id.contacts_list_item_select);
                viewHolder.mLine = view2.findViewById(R.id.contacts_list_item_line);
                view2.setTag(viewHolder);
            } else {
                view2 = view;
                viewHolder = (ViewHolder) view.getTag();
            }
            ContactData contactData = this.mList.get(i);
            viewHolder.mTvListName.setText(contactData.getName());
            viewHolder.mTvListNumber.setText(contactData.getNumber());
            if (contactData.bitmap != null) {
                viewHolder.mImgIcon.setImageDrawable(CircleFramedDrawable.getInstance(InterPhoneContactsFragment.this.getContext(), contactData.bitmap));
            } else if (InterPhoneContactsFragment.this.mCurrentType == 0) {
                viewHolder.mImgIcon.setImageDrawable(InterPhoneContactsFragment.this.getResources().getDrawable(R.drawable.interphone_big_contacts_default));
            } else if (InterPhoneContactsFragment.this.mCurrentType == 1) {
                viewHolder.mImgIcon.setImageDrawable(InterPhoneContactsFragment.this.getResources().getDrawable(R.drawable.interphone_big_contacts_group_default));
            }
            if (i == this.mList.size() - 1) {
                viewHolder.mLine.setVisibility(8);
            }
            if (InterPhoneContactsFragment.this.mActiveContactId == Integer.parseInt(contactData.getNumber()) && InterPhoneContactsFragment.this.mActiveContactType == contactData.getType()) {
                viewHolder.mImgListSelect.setVisibility(0);
            } else {
                viewHolder.mImgListSelect.setVisibility(8);
            }
            return view2;
        }

        /* loaded from: classes4.dex */
        class ViewHolder {
            private ImageView mImgIcon;
            private ImageView mImgListSelect;
            private View mLine;
            private TextView mTvListName;
            private TextView mTvListNumber;

            ViewHolder() {
            }
        }
    }

    @Override // androidx.fragment.app.Fragment
    public void onDestroy() {
        super.onDestroy();
        DmrManager.getInstance().unregisterUpdateListener(this);
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
