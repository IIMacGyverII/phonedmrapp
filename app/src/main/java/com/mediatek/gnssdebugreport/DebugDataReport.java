package com.mediatek.gnssdebugreport;

import android.os.Parcel;
import android.os.Parcelable;

public class DebugDataReport implements Parcelable {
    public static final Parcelable.Creator<DebugDataReport> CREATOR = new Parcelable.Creator<DebugDataReport>() {
        public DebugDataReport createFromParcel(Parcel parcel) {
            return new DebugDataReport(parcel);
        }

        public DebugDataReport[] newArray(int i) {
            return new DebugDataReport[i];
        }
    };
    public static final String DATA_KEY = "DebugDataReport";
    public static final String DATA_KEY_TYPE1 = "data_type1";
    public static final String JSON_TYPE = "type";
    private double mCB;
    private double mClkTemp;
    private double mClkTempRate;
    private double mCompCB;
    private double mCompCdRate;
    private int mEPOage;
    private int mHaveEPO;
    private double mInitGpsSec;
    private double mInitLlhHeight;
    private double mInitLlhLati;
    private double mInitLlhLongi;
    private double mInitPacc;
    private int mInitSrc;
    private int mInitTimeSource;
    private int mLsvalid;
    private int mMPEvalid;
    private int mNoiseFloor;
    private int mPga;
    private int mSaturation;
    private double mSensorHACC;
    private int mSvnum;
    private long mTT4SV;
    private double mTop4CNR;
    private long mTtff;
    private long mXtalJumpDetec;

    public static class DebugData840 {
        public static final String KEY_AID_HEIGHT = "aiding_height";
        public static final String KEY_AID_LAT = "aiding_lat";
        public static final String KEY_AID_LON = "aiding_lon";
        public static final String KEY_AID_SUMMARY = "aiding_summary";
        public static final String KEY_EPO = "epo";
        public static final String KEY_EPO_AGE = "epo_age";
        public static final String KEY_NLP = "nlp";
        public static final String KEY_NV = "nv";
        public static final String KEY_QEPO = "qepo";
        public static final String KEY_SUPL_INJECT = "supl_inject";
        public static final String KEY_VER = "ver";
    }

    public static class DebugData841 {
        public static final String KEY_BLANKING = "blanking";
        public static final String KEY_CHIP_SUMMARY = "chip_summary";
        public static final String KEY_CLKD = "clk_d";
        public static final String KEY_CLKD_RATE = "clk_d_rate";
        public static final String KEY_DCXO_TEMPER = "dcxo_temper";
        public static final String KEY_DCXO_TEMPER_RATE = "dcxo_temper_rate";
        public static final String KEY_DIGI_I = "digi_i";
        public static final String KEY_DIGI_Q = "digi_q";
        public static final String KEY_NOISE_FLOOR = "noise_floor";
        public static final String KEY_PGA_GAIN = "pga_gain";
        public static final String KEY_SENSOR = "sensor";
        public static final String KEY_VER = "ver";
        public static final String KEY_XO_TEMPER = "xo_temper";
        public static final String KEY_XO_TEMPER_RATE = "xo_temper_rate";
    }

    public static class DebugData842 {
        public static final String KEY_FAIL_EVENT = "fail_event";
        public static final String KEY_FAIL_PROCESS = "fail_process";
        public static final String KEY_TIME = "time";
        public static final String KEY_VER = "ver";
    }

    public static class DebugData843 {
        public static final String KEY_DOWNLOAD_STATUS = "download_status";
        public static final String KEY_NETWORK_CAPABILITY = "nw_capa";
        public static final String KEY_NETWORK_CONNECTION = "nw_conn";
        public static final String KEY_TYPE = "type";
        public static final String KEY_VER = "ver";
    }

    public static class DebugDataAgpsSessionInfo {
        public static final int JSON_TYPE_ID = 9001;
        public static final String KEY_HAS_ACQUISION = "has_acquision";
        public static final String KEY_HAS_ALMANAC = "has_almanac";
        public static final String KEY_HAS_AUX_INFO = "has_aux_info";
        public static final String KEY_HAS_DATA_BIT_ASSIST = "has_data_bit_assist";
        public static final String KEY_HAS_DGPS = "has_dgps";
        public static final String KEY_HAS_EOP = "has_eop";
        public static final String KEY_HAS_EPHEMERIS = "has_ephemeris";
        public static final String KEY_HAS_IONOSPHERE = "has_ionosphere";
        public static final String KEY_HAS_LOC_EST = "has_loc_est";
        public static final String KEY_HAS_REF_LOCATION = "has_ref_location";
        public static final String KEY_HAS_REF_TIME = "has_ref_time";
        public static final String KEY_HAS_RTI = "has_rti";
        public static final String KEY_HAS_SAT_MEAS = "has_sat_meas";
        public static final String KEY_HAS_TIME_MODEL = "has_time_model";
        public static final String KEY_HAS_TOW_ASSIST = "has_tow_assist";
        public static final String KEY_HAS_UTC = "has_utc";
        public static final String KEY_INITIATOR = "initiator";
        public static final String KEY_PLANE = "plane";
        public static final String KEY_PROTOCOL = "protocol";
        public static final String KEY_RESULT = "result";
        public static final String KEY_SESSION_ID = "session_id";
        public static final String KEY_SESSION_PERIOD = "session_period";
        public static final String KEY_VER = "ver";
    }

    public static class DebugDataMPE1 {
        public static final String KEY_ALTITUDE = "altitude";
        public static final String KEY_DELTA_TIME = "delta_time";
        public static final String KEY_DOWN_VELOCITY = "down_vel";
        public static final String KEY_EAST_VELOCITY = "east_vel";
        public static final String KEY_HEADING_ANGLE = "heading_angle";
        public static final String KEY_KERNAL_FLAG = "kernal_flag";
        public static final String KEY_LATITUDE = "latitude";
        public static final String KEY_LONGITUDE = "longitude";
        public static final String KEY_NORTH_VELOCITY = "nolth_vel";
        public static final String KEY_PDR_STATUS = "pdr_status";
        public static final String KEY_PICTH_ANGLE = "pitch_angle";
        public static final String KEY_ROLL_ANGLE = "roll_angle";
        public static final String KEY_STATIC_FLAG = "static_flag";
        public static final String KEY_STEP_SPEED = "step_speed";
        public static final String KEY_SYS_TIME = "sys_time";
        public static final String KEY_UDR_STATUS = "udr_status";
    }

    public int describeContents() {
        return 0;
    }

    public DebugDataReport(double d, double d2, double d3, int i, int i2, long j, int i3, long j2, double d4, double d5, double d6, double d7, int i4, double d8, int i5, int i6, double d9, int i7, int i8, int i9, int i10, double d10, double d11, double d12, long j3) {
        this.mCB = d;
        this.mCompCB = d2;
        this.mClkTemp = d3;
        this.mSaturation = i;
        this.mPga = i2;
        this.mTtff = j;
        this.mSvnum = i3;
        this.mTT4SV = j2;
        this.mTop4CNR = d4;
        this.mInitLlhLongi = d5;
        this.mInitLlhLati = d6;
        this.mInitLlhHeight = d7;
        this.mInitSrc = i4;
        this.mInitPacc = d8;
        this.mHaveEPO = i5;
        this.mEPOage = i6;
        this.mSensorHACC = d9;
        this.mMPEvalid = i7;
        this.mLsvalid = i8;
        this.mNoiseFloor = i9;
        this.mInitTimeSource = i10;
        this.mInitGpsSec = d10;
        this.mClkTempRate = d11;
        this.mCompCdRate = d12;
        this.mXtalJumpDetec = j3;
    }

    public DebugDataReport(Parcel parcel) {
        this.mCB = parcel.readDouble();
        this.mCompCB = parcel.readDouble();
        this.mClkTemp = parcel.readDouble();
        this.mSaturation = parcel.readInt();
        this.mPga = parcel.readInt();
        this.mTtff = parcel.readLong();
        this.mSvnum = parcel.readInt();
        this.mTT4SV = parcel.readLong();
        this.mTop4CNR = parcel.readDouble();
        this.mInitLlhLongi = parcel.readDouble();
        this.mInitLlhLati = parcel.readDouble();
        this.mInitLlhHeight = parcel.readDouble();
        this.mInitSrc = parcel.readInt();
        this.mInitPacc = parcel.readDouble();
        this.mHaveEPO = parcel.readInt();
        this.mEPOage = parcel.readInt();
        this.mSensorHACC = parcel.readDouble();
        this.mMPEvalid = parcel.readInt();
        this.mLsvalid = parcel.readInt();
        this.mNoiseFloor = parcel.readInt();
        this.mInitTimeSource = parcel.readInt();
        this.mInitGpsSec = parcel.readDouble();
        this.mClkTempRate = parcel.readDouble();
        this.mCompCdRate = parcel.readDouble();
        this.mXtalJumpDetec = parcel.readLong();
    }

    public double getCB() {
        return this.mCB;
    }

    public double getmCompCB() {
        return this.mCompCB;
    }

    public double getClkTemp() {
        return this.mClkTemp;
    }

    public int getSaturation() {
        return this.mSaturation;
    }

    public int getPga() {
        return this.mPga;
    }

    public long getTtff() {
        return this.mTtff;
    }

    public int getSvnum() {
        return this.mSvnum;
    }

    public long getTT4SV() {
        return this.mTT4SV;
    }

    public double getTop4CNR() {
        return this.mTop4CNR;
    }

    public double getInitLlhLongi() {
        return this.mInitLlhLongi;
    }

    public double getInitLlhLati() {
        return this.mInitLlhLati;
    }

    public double getInitLlhHeight() {
        return this.mInitLlhHeight;
    }

    public int getInitSrc() {
        return this.mInitSrc;
    }

    public double getInitPacc() {
        return this.mInitPacc;
    }

    public int getHaveEPO() {
        return this.mHaveEPO;
    }

    public int getEPOage() {
        return this.mEPOage;
    }

    public double getSensorHACC() {
        return this.mSensorHACC;
    }

    public int getMPEvalid() {
        return this.mMPEvalid;
    }

    public int getLsvalid() {
        return this.mLsvalid;
    }

    public int getNoiseFloor() {
        return this.mNoiseFloor;
    }

    public int getInitTimeSource() {
        return this.mInitTimeSource;
    }

    public double getInitGpsSec() {
        return this.mInitGpsSec;
    }

    public double getClkTempRate() {
        return this.mClkTempRate;
    }

    public double getCompCdRate() {
        return this.mCompCdRate;
    }

    public long getXtalJumpDetec() {
        return this.mXtalJumpDetec;
    }

    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeDouble(this.mCB);
        parcel.writeDouble(this.mCompCB);
        parcel.writeDouble(this.mClkTemp);
        parcel.writeInt(this.mSaturation);
        parcel.writeInt(this.mPga);
        parcel.writeLong(this.mTtff);
        parcel.writeInt(this.mSvnum);
        parcel.writeLong(this.mTT4SV);
        parcel.writeDouble(this.mTop4CNR);
        parcel.writeDouble(this.mInitLlhLongi);
        parcel.writeDouble(this.mInitLlhLati);
        parcel.writeDouble(this.mInitLlhHeight);
        parcel.writeInt(this.mInitSrc);
        parcel.writeDouble(this.mInitPacc);
        parcel.writeInt(this.mHaveEPO);
        parcel.writeInt(this.mEPOage);
        parcel.writeDouble(this.mSensorHACC);
        parcel.writeInt(this.mMPEvalid);
        parcel.writeInt(this.mLsvalid);
        parcel.writeInt(this.mNoiseFloor);
        parcel.writeInt(this.mInitTimeSource);
        parcel.writeDouble(this.mInitGpsSec);
        parcel.writeDouble(this.mClkTempRate);
        parcel.writeDouble(this.mCompCdRate);
        parcel.writeLong(this.mXtalJumpDetec);
    }

    public String toString() {
        return "[" + this.mCB + ", " + this.mCompCB + ", " + this.mClkTemp + ", " + this.mSaturation + ", " + this.mPga + ", " + this.mTtff + ", " + this.mSvnum + ", " + this.mTT4SV + ", " + this.mTop4CNR + ", " + this.mInitLlhLongi + ", " + this.mInitLlhLati + ", " + this.mInitLlhHeight + ", " + this.mInitSrc + ", " + this.mInitPacc + ", " + this.mHaveEPO + ", " + this.mEPOage + ", " + this.mSensorHACC + ", " + this.mMPEvalid + ", " + this.mLsvalid + ", " + this.mNoiseFloor + ", " + this.mInitTimeSource + ", " + this.mInitGpsSec + ", " + this.mClkTempRate + ", " + this.mCompCdRate + ", " + this.mXtalJumpDetec + "]";
    }
}
