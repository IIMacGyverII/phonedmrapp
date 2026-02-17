package com.google.android.material.datepicker;

import android.os.Parcel;
import android.os.Parcelable;
import androidx.annotation.NonNull;
import androidx.core.util.Preconditions;
import com.google.android.material.datepicker.CalendarConstraints;
import java.util.ArrayList;
import java.util.List;

public final class CompositeDateValidator implements CalendarConstraints.DateValidator {
    /* access modifiers changed from: private */
    public static final Operator ALL_OPERATOR = new Operator() {
        public int getId() {
            return 2;
        }

        public boolean isValid(@NonNull List<CalendarConstraints.DateValidator> list, long j) {
            for (CalendarConstraints.DateValidator next : list) {
                if (next != null && !next.isValid(j)) {
                    return false;
                }
            }
            return true;
        }
    };
    /* access modifiers changed from: private */
    public static final Operator ANY_OPERATOR = new Operator() {
        public int getId() {
            return 1;
        }

        public boolean isValid(@NonNull List<CalendarConstraints.DateValidator> list, long j) {
            for (CalendarConstraints.DateValidator next : list) {
                if (next != null && next.isValid(j)) {
                    return true;
                }
            }
            return false;
        }
    };
    private static final int COMPARATOR_ALL_ID = 2;
    private static final int COMPARATOR_ANY_ID = 1;
    public static final Parcelable.Creator<CompositeDateValidator> CREATOR = new Parcelable.Creator<CompositeDateValidator>() {
        @NonNull
        public CompositeDateValidator createFromParcel(@NonNull Parcel parcel) {
            Operator operator;
            ArrayList readArrayList = parcel.readArrayList(CalendarConstraints.DateValidator.class.getClassLoader());
            int readInt = parcel.readInt();
            if (readInt == 2) {
                operator = CompositeDateValidator.ALL_OPERATOR;
            } else if (readInt == 1) {
                operator = CompositeDateValidator.ANY_OPERATOR;
            } else {
                operator = CompositeDateValidator.ALL_OPERATOR;
            }
            return new CompositeDateValidator((List) Preconditions.checkNotNull(readArrayList), operator);
        }

        @NonNull
        public CompositeDateValidator[] newArray(int i) {
            return new CompositeDateValidator[i];
        }
    };
    @NonNull
    private final Operator operator;
    @NonNull
    private final List<CalendarConstraints.DateValidator> validators;

    private interface Operator {
        int getId();

        boolean isValid(@NonNull List<CalendarConstraints.DateValidator> list, long j);
    }

    public int describeContents() {
        return 0;
    }

    private CompositeDateValidator(@NonNull List<CalendarConstraints.DateValidator> list, Operator operator2) {
        this.validators = list;
        this.operator = operator2;
    }

    @NonNull
    public static CalendarConstraints.DateValidator allOf(@NonNull List<CalendarConstraints.DateValidator> list) {
        return new CompositeDateValidator(list, ALL_OPERATOR);
    }

    @NonNull
    public static CalendarConstraints.DateValidator anyOf(@NonNull List<CalendarConstraints.DateValidator> list) {
        return new CompositeDateValidator(list, ANY_OPERATOR);
    }

    public boolean isValid(long j) {
        return this.operator.isValid(this.validators, j);
    }

    public void writeToParcel(@NonNull Parcel parcel, int i) {
        parcel.writeList(this.validators);
        parcel.writeInt(this.operator.getId());
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof CompositeDateValidator)) {
            return false;
        }
        CompositeDateValidator compositeDateValidator = (CompositeDateValidator) obj;
        if (!this.validators.equals(compositeDateValidator.validators) || this.operator.getId() != compositeDateValidator.operator.getId()) {
            return false;
        }
        return true;
    }

    public int hashCode() {
        return this.validators.hashCode();
    }
}
