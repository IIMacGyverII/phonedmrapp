package com.google.android.material.datepicker;

import android.content.Context;
import android.widget.BaseAdapter;
import android.widget.TextView;
import androidx.annotation.Nullable;
import java.util.Collection;

class MonthAdapter extends BaseAdapter {
    static final int MAXIMUM_WEEKS = UtcDates.getUtcCalendar().getMaximum(4);
    final CalendarConstraints calendarConstraints;
    CalendarStyle calendarStyle;
    final DateSelector<?> dateSelector;
    final Month month;
    private Collection<Long> previouslySelectedDates;

    public boolean hasStableIds() {
        return true;
    }

    MonthAdapter(Month month2, DateSelector<?> dateSelector2, CalendarConstraints calendarConstraints2) {
        this.month = month2;
        this.dateSelector = dateSelector2;
        this.calendarConstraints = calendarConstraints2;
        this.previouslySelectedDates = dateSelector2.getSelectedDays();
    }

    @Nullable
    public Long getItem(int i) {
        if (i < this.month.daysFromStartOfWeekToFirstOfMonth() || i > lastPositionInMonth()) {
            return null;
        }
        return Long.valueOf(this.month.getDay(positionToDay(i)));
    }

    public long getItemId(int i) {
        return (long) (i / this.month.daysInWeek);
    }

    public int getCount() {
        return this.month.daysInMonth + firstPositionInMonth();
    }

    /* JADX WARNING: type inference failed for: r7v10, types: [android.view.View] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* JADX WARNING: Removed duplicated region for block: B:15:0x0083 A[RETURN] */
    /* JADX WARNING: Removed duplicated region for block: B:16:0x0084  */
    @androidx.annotation.NonNull
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public android.widget.TextView getView(int r6, @androidx.annotation.Nullable android.view.View r7, @androidx.annotation.NonNull android.view.ViewGroup r8) {
        /*
            r5 = this;
            android.content.Context r0 = r8.getContext()
            r5.initializeStyles(r0)
            r0 = r7
            android.widget.TextView r0 = (android.widget.TextView) r0
            r1 = 0
            if (r7 != 0) goto L_0x001e
            android.content.Context r7 = r8.getContext()
            android.view.LayoutInflater r7 = android.view.LayoutInflater.from(r7)
            int r0 = com.google.android.material.R.layout.mtrl_calendar_day
            android.view.View r7 = r7.inflate(r0, r8, r1)
            r0 = r7
            android.widget.TextView r0 = (android.widget.TextView) r0
        L_0x001e:
            int r7 = r5.firstPositionInMonth()
            int r7 = r6 - r7
            if (r7 < 0) goto L_0x0075
            com.google.android.material.datepicker.Month r8 = r5.month
            int r2 = r8.daysInMonth
            if (r7 < r2) goto L_0x002d
            goto L_0x0075
        L_0x002d:
            r2 = 1
            int r7 = r7 + r2
            r0.setTag(r8)
            android.content.res.Resources r8 = r0.getResources()
            android.content.res.Configuration r8 = r8.getConfiguration()
            java.util.Locale r8 = r8.locale
            java.lang.Object[] r3 = new java.lang.Object[r2]
            java.lang.Integer r4 = java.lang.Integer.valueOf(r7)
            r3[r1] = r4
            java.lang.String r4 = "%d"
            java.lang.String r8 = java.lang.String.format(r8, r4, r3)
            r0.setText(r8)
            com.google.android.material.datepicker.Month r8 = r5.month
            long r7 = r8.getDay(r7)
            com.google.android.material.datepicker.Month r3 = r5.month
            int r3 = r3.year
            com.google.android.material.datepicker.Month r4 = com.google.android.material.datepicker.Month.current()
            int r4 = r4.year
            if (r3 != r4) goto L_0x0067
            java.lang.String r7 = com.google.android.material.datepicker.DateStrings.getMonthDayOfWeekDay(r7)
            r0.setContentDescription(r7)
            goto L_0x006e
        L_0x0067:
            java.lang.String r7 = com.google.android.material.datepicker.DateStrings.getYearMonthDayOfWeekDay(r7)
            r0.setContentDescription(r7)
        L_0x006e:
            r0.setVisibility(r1)
            r0.setEnabled(r2)
            goto L_0x007d
        L_0x0075:
            r7 = 8
            r0.setVisibility(r7)
            r0.setEnabled(r1)
        L_0x007d:
            java.lang.Long r6 = r5.getItem((int) r6)
            if (r6 != 0) goto L_0x0084
            return r0
        L_0x0084:
            long r6 = r6.longValue()
            r5.updateSelectedState(r0, r6)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.datepicker.MonthAdapter.getView(int, android.view.View, android.view.ViewGroup):android.widget.TextView");
    }

    public void updateSelectedStates(MaterialCalendarGridView materialCalendarGridView) {
        for (Long longValue : this.previouslySelectedDates) {
            updateSelectedStateForDate(materialCalendarGridView, longValue.longValue());
        }
        DateSelector<?> dateSelector2 = this.dateSelector;
        if (dateSelector2 != null) {
            for (Long longValue2 : dateSelector2.getSelectedDays()) {
                updateSelectedStateForDate(materialCalendarGridView, longValue2.longValue());
            }
            this.previouslySelectedDates = this.dateSelector.getSelectedDays();
        }
    }

    private void updateSelectedStateForDate(MaterialCalendarGridView materialCalendarGridView, long j) {
        if (Month.create(j).equals(this.month)) {
            updateSelectedState((TextView) materialCalendarGridView.getChildAt(materialCalendarGridView.getAdapter().dayToPosition(this.month.getDayOfMonth(j)) - materialCalendarGridView.getFirstVisiblePosition()), j);
        }
    }

    private void updateSelectedState(@Nullable TextView textView, long j) {
        CalendarItemStyle calendarItemStyle;
        if (textView != null) {
            if (this.calendarConstraints.getDateValidator().isValid(j)) {
                textView.setEnabled(true);
                if (isSelected(j)) {
                    calendarItemStyle = this.calendarStyle.selectedDay;
                } else if (UtcDates.getTodayCalendar().getTimeInMillis() == j) {
                    calendarItemStyle = this.calendarStyle.todayDay;
                } else {
                    calendarItemStyle = this.calendarStyle.day;
                }
            } else {
                textView.setEnabled(false);
                calendarItemStyle = this.calendarStyle.invalidDay;
            }
            calendarItemStyle.styleItem(textView);
        }
    }

    private boolean isSelected(long j) {
        for (Long longValue : this.dateSelector.getSelectedDays()) {
            if (UtcDates.canonicalYearMonthDay(j) == UtcDates.canonicalYearMonthDay(longValue.longValue())) {
                return true;
            }
        }
        return false;
    }

    private void initializeStyles(Context context) {
        if (this.calendarStyle == null) {
            this.calendarStyle = new CalendarStyle(context);
        }
    }

    /* access modifiers changed from: package-private */
    public int firstPositionInMonth() {
        return this.month.daysFromStartOfWeekToFirstOfMonth();
    }

    /* access modifiers changed from: package-private */
    public int lastPositionInMonth() {
        return (this.month.daysFromStartOfWeekToFirstOfMonth() + this.month.daysInMonth) - 1;
    }

    /* access modifiers changed from: package-private */
    public int positionToDay(int i) {
        return (i - this.month.daysFromStartOfWeekToFirstOfMonth()) + 1;
    }

    /* access modifiers changed from: package-private */
    public int dayToPosition(int i) {
        return firstPositionInMonth() + (i - 1);
    }

    /* access modifiers changed from: package-private */
    public boolean withinMonth(int i) {
        return i >= firstPositionInMonth() && i <= lastPositionInMonth();
    }

    /* access modifiers changed from: package-private */
    public boolean isFirstInRow(int i) {
        return i % this.month.daysInWeek == 0;
    }

    /* access modifiers changed from: package-private */
    public boolean isLastInRow(int i) {
        return (i + 1) % this.month.daysInWeek == 0;
    }
}
