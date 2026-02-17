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
import com.pri.prizeinterphone.audio.PCMAudioPlayer;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.AudioRecordData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class RecordListActivity extends AppCompatActivity {
    public static final String TAG = "TAG_RecordListActivity";
    /* access modifiers changed from: private */
    public List<AudioRecordData> deleteList;
    private ImageButton deleteSelect;
    private Toast mToast;
    private PCMAudioPlayer pcmAudioPlayer;
    /* access modifiers changed from: private */
    public AudioListAdapter recordAdapter;
    /* access modifiers changed from: private */
    public List<AudioRecordData> recordItemList;
    private RecyclerView recordList;
    /* access modifiers changed from: private */
    public CheckBox selectAll;

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_record_list);
        ((TextView) findViewById(R.id.title)).setText(R.string.interphone_record_list_title);
        this.recordList = (RecyclerView) findViewById(R.id.record_list);
        this.recordAdapter = new AudioListAdapter();
        this.recordList.setLayoutManager(new LinearLayoutManager(this));
        this.recordList.setAdapter(this.recordAdapter);
        this.deleteSelect = (ImageButton) findViewById(R.id.delete_select);
        this.selectAll = (CheckBox) findViewById(R.id.select_all);
        this.deleteSelect.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                if (!RecordListActivity.this.isTalkSend() || RecordListActivity.this.deleteList.size() <= 0) {
                    RecordListActivity.this.recordAdapter.deleteSelectFiles();
                    RecordListActivity.this.selectAll.setChecked(false);
                    return;
                }
                RecordListActivity.this.showToast(R.string.interphone_talk_send_status_toast);
            }
        });
        this.selectAll.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
                if (z) {
                    RecordListActivity.this.recordAdapter.selectAll();
                } else {
                    RecordListActivity.this.recordAdapter.unSelectAll();
                }
            }
        });
    }

    /* access modifiers changed from: protected */
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

    public class AudioListAdapter extends RecyclerView.Adapter<ItemViewHolder> {
        public AudioListAdapter() {
            RecordListActivity.this.recordItemList = DmrManager.getInstance().getAllRecordList();
            RecordListActivity.this.deleteList = new ArrayList();
        }

        public ItemViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            return new ItemViewHolder(LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.record_item_layout, viewGroup, false));
        }

        public void onBindViewHolder(ItemViewHolder itemViewHolder, int i) {
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
            itemViewHolder.fileSelect.setOnCheckedChangeListener(new RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0(this, i));
            itemViewHolder.fileSelect.setChecked(RecordListActivity.this.deleteList.contains(RecordListActivity.this.recordItemList.get(i)));
            itemViewHolder.itemView.setOnClickListener(new RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda1(this, i));
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$onBindViewHolder$0(int i, CompoundButton compoundButton, boolean z) {
            if (z) {
                addToDeleteList((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
            } else {
                unSelectFromDelete((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
            }
        }

        /* access modifiers changed from: private */
        public /* synthetic */ void lambda$onBindViewHolder$1(int i, View view) {
            RecordListActivity.this.stopPlayAudio();
            String filePath = ((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getFilePath();
            Log.d(RecordListActivity.TAG, "click filePath=" + filePath);
            Log.d(RecordListActivity.TAG, "click position=" + i);
            if (TextUtils.isEmpty(filePath) || !new File(((AudioRecordData) RecordListActivity.this.recordItemList.get(i)).getFilePath()).exists()) {
                DmrManager.getInstance().deleteRecordFile((AudioRecordData) RecordListActivity.this.recordItemList.get(i));
                RecordListActivity.this.recordItemList = DmrManager.getInstance().getAllRecordList();
                notifyDataSetChanged();
                RecordListActivity.this.showToast(R.string.record_file_notexist);
            } else if (!RecordListActivity.this.isTalkSend()) {
                RecordListActivity recordListActivity = RecordListActivity.this;
                recordListActivity.startPlayAudio(((AudioRecordData) recordListActivity.recordItemList.get(i)).getFilePath());
            }
        }

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
        Calendar instance = Calendar.getInstance();
        instance.setTimeInMillis(Long.valueOf(str).longValue());
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(instance.getTime());
    }

    /* access modifiers changed from: private */
    public void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    /* access modifiers changed from: private */
    public boolean isTalkSend() {
        return PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
    }
}
