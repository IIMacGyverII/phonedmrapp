package com.pri.prizeinterphone.activity;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.activity.RecordListActivity;
import com.pri.prizeinterphone.audio.PCMAudioPlayer;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.AudioRecordData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
/* loaded from: classes4.dex */
public class RecordListActivity extends AppCompatActivity {
    public static final String TAG = "TAG_RecordListActivity";
    private List<AudioRecordData> deleteList;
    private ImageButton deleteSelect;
    private Toast mToast;
    private PCMAudioPlayer pcmAudioPlayer;
    private AudioListAdapter recordAdapter;
    private List<AudioRecordData> recordItemList;
    private RecyclerView recordList;
    private CheckBox selectAll;

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.activity_record_list);
        ((TextView) findViewById(R.id.title)).setText(R.string.interphone_record_list_title);
        this.recordList = (RecyclerView) findViewById(R.id.record_list);
        this.recordAdapter = new AudioListAdapter();
        this.recordList.setLayoutManager(new LinearLayoutManager(this));
        this.recordList.setAdapter(this.recordAdapter);
        this.deleteSelect = (ImageButton) findViewById(R.id.delete_select);
        this.selectAll = (CheckBox) findViewById(R.id.select_all);
        this.deleteSelect.setOnClickListener(new View.OnClickListener() { // from class: com.pri.prizeinterphone.activity.RecordListActivity.1
            @Override // android.view.View.OnClickListener
            public void onClick(View view) {
                if (RecordListActivity.this.isTalkSend() && RecordListActivity.this.deleteList.size() > 0) {
                    RecordListActivity.this.showToast(R.string.interphone_talk_send_status_toast);
                    return;
                }
                RecordListActivity.this.recordAdapter.deleteSelectFiles();
                RecordListActivity.this.selectAll.setChecked(false);
            }
        });
        this.selectAll.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() { // from class: com.pri.prizeinterphone.activity.RecordListActivity.2
            @Override // android.widget.CompoundButton.OnCheckedChangeListener
            public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                if (z) {
                    RecordListActivity.this.recordAdapter.selectAll();
                } else {
                    RecordListActivity.this.recordAdapter.unSelectAll();
                }
            }
        });
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onStop() {
        super.onStop();
        stopPlayAudio();
    }

    public void stopPlayAudio() {
        PCMAudioPlayer pCMAudioPlayer = this.pcmAudioPlayer;
        if (pCMAudioPlayer != null) {
            pCMAudioPlayer.stopPlay();
            this.pcmAudioPlayer.release();
            this.pcmAudioPlayer = null;
        }
    }

    public void startPlayAudio(String str) {
        if (this.pcmAudioPlayer == null) {
            this.pcmAudioPlayer = new PCMAudioPlayer();
        }
        this.pcmAudioPlayer.startPlay(str);
    }

    /* loaded from: classes4.dex */
    public class ItemViewHolder extends RecyclerView.ViewHolder {
        TextView fileChannel;
        TextView fileName;
        CheckBox fileSelect;
        TextView fileTimestamp;
        TextView fileType;

        public ItemViewHolder(View view) {
            super(view);
            this.fileName = (TextView) view.findViewById(R.id.record_file_name);
            this.fileChannel = (TextView) view.findViewById(R.id.record_file_channel);
            this.fileType = (TextView) view.findViewById(R.id.record_file_type);
            this.fileTimestamp = (TextView) view.findViewById(R.id.record_file_timestamp);
            this.fileSelect = (CheckBox) view.findViewById(R.id.record_file_select);
        }
    }

    /* loaded from: classes4.dex */
    public class AudioListAdapter extends RecyclerView.Adapter<ItemViewHolder> {
        public AudioListAdapter() {
            RecordListActivity.this.recordItemList = DmrManager.getInstance().getAllRecordList();
            RecordListActivity.this.deleteList = new ArrayList();
        }

        @Override // androidx.recyclerview.widget.RecyclerView.Adapter
        public ItemViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            return new ItemViewHolder(LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.record_item_layout, viewGroup, false));
        }

        @Override // androidx.recyclerview.widget.RecyclerView.Adapter
        public void onBindViewHolder(ItemViewHolder itemViewHolder, final int i) {
            itemViewHolder.fileName.setText(((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getName());
            String string = RecordListActivity.this.getResources().getString(R.string.fragment_title_tap_channel);
            TextView textView = itemViewHolder.fileChannel;
            textView.setText(string + ((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getChannelName());
            if (((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getDirection() == 0) {
                itemViewHolder.fileType.setText(R.string.interphone_record_type_send);
            } else {
                itemViewHolder.fileType.setText(R.string.interphone_record_type_receive);
            }
            TextView textView2 = itemViewHolder.fileTimestamp;
            textView2.setText(RecordListActivity.timetodate(((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getTimestamp() + ""));
            itemViewHolder.fileSelect.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() { // from class: com.pri.prizeinterphone.activity.RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0
                @Override // android.widget.CompoundButton.OnCheckedChangeListener
                public final void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                    RecordListActivity.AudioListAdapter.this.lambda$onBindViewHolder$0(i, compoundButton, z);
                }
            });
            itemViewHolder.fileSelect.setChecked(RecordListActivity.this.deleteList.contains(RecordListActivity.this.recordItemList.get(i)));
            itemViewHolder.itemView.setOnClickListener(new View.OnClickListener() { // from class: com.pri.prizeinterphone.activity.RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda1
                @Override // android.view.View.OnClickListener
                public final void onClick(View view) {
                    RecordListActivity.AudioListAdapter.this.lambda$onBindViewHolder$1(i, view);
                }
            });
        }

        /* JADX INFO: Access modifiers changed from: private */
        public /* synthetic */ void lambda$onBindViewHolder$0(int i, CompoundButton compoundButton, boolean z) {
            if (z) {
                addToDeleteList((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
            } else {
                unSelectFromDelete((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
            }
        }

        /* JADX INFO: Access modifiers changed from: private */
        public /* synthetic */ void lambda$onBindViewHolder$1(int i, View view) {
            RecordListActivity.this.stopPlayAudio();
            String filePath = ((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getFilePath();
            Log.d(RecordListActivity.TAG, "click filePath=" + filePath);
            Log.d(RecordListActivity.TAG, "click position=" + i);
            if (!TextUtils.isEmpty(filePath) && new File(((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getFilePath()).exists()) {
                if (RecordListActivity.this.isTalkSend()) {
                    return;
                }
                RecordListActivity recordListActivity = RecordListActivity.this;
                recordListActivity.startPlayAudio(((AudioRecordData) recordListActivity.recordItemList.get(i)).getFilePath());
                return;
            }
            DmrManager.getInstance().deleteRecordFile((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
            RecordListActivity.this.recordItemList = DmrManager.getInstance().getAllRecordList();
            notifyDataSetChanged();
            RecordListActivity.this.showToast(R.string.record_file_notexist);
        }

        @Override // androidx.recyclerview.widget.RecyclerView.Adapter
        public int getItemCount() {
            return RecordListActivity.this.recordItemList.size();
        }

        private void addToDeleteList(AudioRecordData audioRecordData) {
            RecordListActivity.this.deleteList.add(audioRecordData);
        }

        private void unSelectFromDelete(AudioRecordData audioRecordData) {
            RecordListActivity.this.deleteList.remove(audioRecordData);
        }

        public void deleteSelectFiles() {
            if (RecordListActivity.this.deleteList.size() > 0) {
                RecordListActivity.this.stopPlayAudio();
                for (int i = 0; i < RecordListActivity.this.deleteList.size(); i++) {
                    File file = new File(((AudioRecordData) RecordListActivity.this.deleteList.get(i)).getFilePath());
                    if (file.exists()) {
                        file.delete();
                    }
                    DmrManager.getInstance().deleteRecordFile((AudioRecordData) RecordListActivity.this.deleteList.get(i));
                }
                RecordListActivity.this.recordItemList = DmrManager.getInstance().getAllRecordList();
                notifyDataSetChanged();
                RecordListActivity.this.showToast(R.string.record_have_delete);
            }
        }

        public void selectAll() {
            RecordListActivity.this.deleteList.clear();
            RecordListActivity.this.deleteList.addAll(RecordListActivity.this.recordItemList);
            notifyDataSetChanged();
        }

        public void unSelectAll() {
            RecordListActivity.this.deleteList.clear();
            notifyDataSetChanged();
        }
    }

    public static String timetodate(String str) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(Long.valueOf(str).longValue());
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(calendar.getTime());
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean isTalkSend() {
        return PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
    }
}
