package com.pri.prizeinterphone.ymodem;

import android.os.Parcel;
import android.os.Parcelable;
/* loaded from: classes4.dex */
public class YModemTXMsg implements Parcelable {
    public static final Parcelable.Creator<YModemTXMsg> CREATOR = new Parcelable.Creator<YModemTXMsg>() { // from class: com.pri.prizeinterphone.ymodem.YModemTXMsg.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public YModemTXMsg createFromParcel(Parcel parcel) {
            return new YModemTXMsg(parcel);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public YModemTXMsg[] newArray(int i) {
            return new YModemTXMsg[i];
        }
    };
    private int currentSent;
    private int step;
    private int total;

    public static String step2Str(int i) {
        return i != 2 ? i != 4 ? i != 8 ? i != 16 ? i != 32 ? i != 64 ? "STEP_UNKNOWN" : "STEP_ERROR" : "STEP_END" : "STEP_EOT" : "STEP_FILE_BODY" : "STEP_FILE_NAME" : "STEP_HELLO";
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    public int getStep() {
        return this.step;
    }

    public int getCurrentSent() {
        return this.currentSent;
    }

    public int getTotal() {
        return this.total;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(this.step);
        parcel.writeInt(this.currentSent);
        parcel.writeInt(this.total);
    }

    public void readFromParcel(Parcel parcel) {
        this.step = parcel.readInt();
        this.currentSent = parcel.readInt();
        this.total = parcel.readInt();
    }

    private YModemTXMsg() {
    }

    protected YModemTXMsg(Parcel parcel) {
        this.step = parcel.readInt();
        this.currentSent = parcel.readInt();
        this.total = parcel.readInt();
    }

    /* loaded from: classes4.dex */
    public static final class YModemTXMsgBuilder {
        private int currentSent;
        private int step;
        private int total;

        private YModemTXMsgBuilder() {
        }

        public static YModemTXMsgBuilder anYModemTXMsg() {
            return new YModemTXMsgBuilder();
        }

        public YModemTXMsgBuilder withStep(int i) {
            this.step = i;
            return this;
        }

        public YModemTXMsgBuilder withCurrentSent(int i) {
            this.currentSent = i;
            return this;
        }

        public YModemTXMsgBuilder withTotal(int i) {
            this.total = i;
            return this;
        }

        public YModemTXMsg build() {
            YModemTXMsg yModemTXMsg = new YModemTXMsg();
            yModemTXMsg.total = this.total;
            yModemTXMsg.currentSent = this.currentSent;
            yModemTXMsg.step = this.step;
            return yModemTXMsg;
        }
    }

    public String toString() {
        return "YModemTXMsg{step=" + step2Str(this.step) + ", currentSent=" + this.currentSent + ", total=" + this.total + '}';
    }
}
