package com.google.android.material.datepicker;

import android.widget.BaseAdapter;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.util.Calendar;

class DaysOfWeekAdapter extends BaseAdapter {
    private static final int CALENDAR_DAY_STYLE = 4;
    private static final int NARROW_FORMAT = 4;
    @NonNull
    private final Calendar calendar;
    private final int daysInWeek;
    private final int firstDayOfWeek;

    public long getItemId(int i) {
        return 0;
    }

    public DaysOfWeekAdapter() {
        Calendar utcCalendar = UtcDates.getUtcCalendar();
        this.calendar = utcCalendar;
        this.daysInWeek = utcCalendar.getMaximum(7);
        this.firstDayOfWeek = utcCalendar.getFirstDayOfWeek();
    }

    @Nullable
    public Integer getItem(int i) {
        if (i >= this.daysInWeek) {
            return null;
        }
        return Integer.valueOf(positionToDayOfWeek(i));
    }

    public int getCount() {
        return this.daysInWeek;
    }

    /* JADX WARNING: type inference failed for: r6v8, types: [android.view.View] */
    /* JADX WARNING: Multi-variable type inference failed */
    @android.annotation.SuppressLint({"WrongConstant"})
    @androidx.annotation.Nullable
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.view.View getView(int r5, @androidx.annotation.Nullable android.view.View r6, @androidx.annotation.NonNull android.view.ViewGroup r7) {
        /*
            r4 = this;
            r0 = r6
            android.widget.TextView r0 = (android.widget.TextView) r0
            r1 = 0
            if (r6 != 0) goto L_0x0017
            android.content.Context r6 = r7.getContext()
            android.view.LayoutInflater r6 = android.view.LayoutInflater.from(r6)
            int r0 = com.google.android.material.R.layout.mtrl_calendar_day_of_week
            android.view.View r6 = r6.inflate(r0, r7, r1)
            r0 = r6
            android.widget.TextView r0 = (android.widget.TextView) r0
        L_0x0017:
            java.util.Calendar r6 = r4.calendar
            int r5 = r4.positionToDayOfWeek(r5)
            r2 = 7
            r6.set(r2, r5)
            android.content.res.Resources r5 = r0.getResources()
            android.content.res.Configuration r5 = r5.getConfiguration()
            java.util.Locale r5 = r5.locale
            java.util.Calendar r6 = r4.calendar
            int r3 = CALENDAR_DAY_STYLE
            java.lang.String r5 = r6.getDisplayName(r2, r3, r5)
            r0.setText(r5)
            android.content.Context r5 = r7.getContext()
            int r6 = com.google.android.material.R.string.mtrl_picker_day_of_week_column_header
            java.lang.String r5 = r5.getString(r6)
            r6 = 1
            java.lang.Object[] r6 = new java.lang.Object[r6]
            java.util.Calendar r4 = r4.calendar
            r7 = 2
            java.util.Locale r3 = java.util.Locale.getDefault()
            java.lang.String r4 = r4.getDisplayName(r2, r7, r3)
            r6[r1] = r4
            java.lang.String r4 = java.lang.String.format(r5, r6)
            r0.setContentDescription(r4)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.datepicker.DaysOfWeekAdapter.getView(int, android.view.View, android.view.ViewGroup):android.view.View");
    }

    private int positionToDayOfWeek(int i) {
        int i2 = i + this.firstDayOfWeek;
        int i3 = this.daysInWeek;
        return i2 > i3 ? i2 - i3 : i2;
    }
}
