package com.pri.prizeinterphone.activity;

import android.widget.CompoundButton;
import com.pri.prizeinterphone.activity.RecordListActivity;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0 implements CompoundButton.OnCheckedChangeListener {
    public final /* synthetic */ RecordListActivity.AudioListAdapter f$0;
    public final /* synthetic */ int f$1;

    public /* synthetic */ RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0(RecordListActivity.AudioListAdapter audioListAdapter, int i) {
        this.f$0 = audioListAdapter;
        this.f$1 = i;
    }

    public final void onCheckedChanged(CompoundButton compoundButton, boolean z) {
        this.f$0.lambda$onBindViewHolder$0(this.f$1, compoundButton, z);
    }
}
