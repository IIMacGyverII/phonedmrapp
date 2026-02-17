package com.google.android.material.datepicker;

import android.os.Parcel;
import android.os.Parcelable;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;

final class Month implements Comparable<Month>, Parcelable {
    public static final Parcelable.Creator<Month> CREATOR = new Parcelable.Creator<Month>() {
        @NonNull
        public Month createFromParcel(@NonNull Parcel parcel) {
            return Month.create(parcel.readInt(), parcel.readInt());
        }

        @NonNull
        public Month[] newArray(int i) {
            return new Month[i];
        }
    };
    final int daysInMonth;
    final int daysInWeek;
    @NonNull
    private final Calendar firstOfMonth;
    @Nullable
    private String longName;
    final int month;
    final long timeInMillis;
    final int year;

    public int describeContents() {
        return 0;
    }

    private Month(@NonNull Calendar calendar) {
        calendar.set(5, 1);
        Calendar dayCopy = UtcDates.getDayCopy(calendar);
        this.firstOfMonth = dayCopy;
        this.month = dayCopy.get(2);
        this.year = dayCopy.get(1);
        this.daysInWeek = dayCopy.getMaximum(7);
        this.daysInMonth = dayCopy.getActualMaximum(5);
        this.timeInMillis = dayCopy.getTimeInMillis();
    }

    @NonNull
    static Month create(long j) {
        Calendar utcCalendar = UtcDates.getUtcCalendar();
        utcCalendar.setTimeInMillis(j);
        return new Month(utcCalendar);
    }

    @NonNull
    static Month create(int i, int i2) {
        Calendar utcCalendar = UtcDates.getUtcCalendar();
        utcCalendar.set(1, i);
        utcCalendar.set(2, i2);
        return new Month(utcCalendar);
    }

    @NonNull
    static Month current() {
        return new Month(UtcDates.getTodayCalendar());
    }

    /* access modifiers changed from: package-private */
    public int daysFromStartOfWeekToFirstOfMonth() {
        int firstDayOfWeek = this.firstOfMonth.get(7) - this.firstOfMonth.getFirstDayOfWeek();
        return firstDayOfWeek < 0 ? firstDayOfWeek + this.daysInWeek : firstDayOfWeek;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof Month)) {
            return false;
        }
        Month month2 = (Month) obj;
        if (this.month == month2.month && this.year == month2.year) {
            return true;
        }
        return false;
    }

    public int hashCode() {
        return Arrays.hashCode(new Object[]{Integer.valueOf(this.month), Integer.valueOf(this.year)});
    }

    public int compareTo(@NonNull Month month2) {
        return this.firstOfMonth.compareTo(month2.firstOfMonth);
    }

    /* access modifiers changed from: package-private */
    public int monthsUntil(@NonNull Month month2) {
        if (this.firstOfMonth instanceof GregorianCalendar) {
            return ((month2.year - this.year) * 12) + (month2.month - this.month);
        }
        throw new IllegalArgumentException("Only Gregorian calendars are supported.");
    }

    /* access modifiers changed from: package-private */
    public long getStableId() {
        return this.firstOfMonth.getTimeInMillis();
    }

    /* access modifiers changed from: package-private */
    public long getDay(int i) {
        Calendar dayCopy = UtcDates.getDayCopy(this.firstOfMonth);
        dayCopy.set(5, i);
        return dayCopy.getTimeInMillis();
    }

    /* access modifiers changed from: package-private */
    public int getDayOfMonth(long j) {
        Calendar dayCopy = UtcDates.getDayCopy(this.firstOfMonth);
        dayCopy.setTimeInMillis(j);
        return dayCopy.get(5);
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public Month monthsLater(int i) {
        Calendar dayCopy = UtcDates.getDayCopy(this.firstOfMonth);
        dayCopy.add(2, i);
        return new Month(dayCopy);
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public String getLongName() {
        if (this.longName == null) {
            this.longName = DateStrings.getYearMonth(this.firstOfMonth.getTimeInMillis());
        }
        return this.longName;
    }

    public void writeToParcel(@NonNull Parcel parcel, int i) {
        parcel.writeInt(this.year);
        parcel.writeInt(this.month);
    }
}
