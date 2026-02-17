package androidx.preference;

import android.content.Context;
import android.text.TextUtils;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.TimeUtils;
import java.util.ArrayList;
import java.util.List;

final class ExpandButton extends Preference {
    private long mId;

    ExpandButton(Context context, List<Preference> list, long j) {
        super(context);
        initLayout();
        setSummary(list);
        this.mId = j + TimeUtils.NANOS_PER_MS;
    }

    private void initLayout() {
        setLayoutResource(R.layout.expand_button);
        setIcon(R.drawable.ic_arrow_down_24dp);
        setTitle(R.string.expand_button_title);
        setOrder(ServiceStateTracker.CS_NOTIFICATION);
    }

    private void setSummary(List<Preference> list) {
        ArrayList arrayList = new ArrayList();
        CharSequence charSequence = null;
        for (Preference next : list) {
            CharSequence title = next.getTitle();
            boolean z = next instanceof PreferenceGroup;
            if (z && !TextUtils.isEmpty(title)) {
                arrayList.add((PreferenceGroup) next);
            }
            if (arrayList.contains(next.getParent())) {
                if (z) {
                    arrayList.add((PreferenceGroup) next);
                }
            } else if (!TextUtils.isEmpty(title)) {
                if (charSequence == null) {
                    charSequence = title;
                } else {
                    charSequence = getContext().getString(R.string.summary_collapsed_preference_list, new Object[]{charSequence, title});
                }
            }
        }
        setSummary(charSequence);
    }

    public void onBindViewHolder(PreferenceViewHolder preferenceViewHolder) {
        super.onBindViewHolder(preferenceViewHolder);
        preferenceViewHolder.setDividerAllowedAbove(false);
    }

    /* access modifiers changed from: package-private */
    public long getId() {
        return this.mId;
    }
}
