.class public Lcom/mediatek/gnssdebugreport/DebugDataReport;
.super Ljava/lang/Object;
.source "DebugDataReport.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugDataAgpsSessionInfo;,
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugDataMPE1;,
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugData843;,
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugData842;,
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugData841;,
        Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugData840;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/mediatek/gnssdebugreport/DebugDataReport;",
            ">;"
        }
    .end annotation
.end field

.field public static final DATA_KEY:Ljava/lang/String; = "DebugDataReport"

.field public static final DATA_KEY_TYPE1:Ljava/lang/String; = "data_type1"

.field public static final JSON_TYPE:Ljava/lang/String; = "type"


# instance fields
.field private mCB:D

.field private mClkTemp:D

.field private mClkTempRate:D

.field private mCompCB:D

.field private mCompCdRate:D

.field private mEPOage:I

.field private mHaveEPO:I

.field private mInitGpsSec:D

.field private mInitLlhHeight:D

.field private mInitLlhLati:D

.field private mInitLlhLongi:D

.field private mInitPacc:D

.field private mInitSrc:I

.field private mInitTimeSource:I

.field private mLsvalid:I

.field private mMPEvalid:I

.field private mNoiseFloor:I

.field private mPga:I

.field private mSaturation:I

.field private mSensorHACC:D

.field private mSvnum:I

.field private mTT4SV:J

.field private mTop4CNR:D

.field private mTtff:J

.field private mXtalJumpDetec:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 234
    new-instance v0, Lcom/mediatek/gnssdebugreport/DebugDataReport$1;

    invoke-direct {v0}, Lcom/mediatek/gnssdebugreport/DebugDataReport$1;-><init>()V

    sput-object v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>(DDDIIJIJDDDDIDIIDIIIIDDDJ)V
    .locals 3

    move-object v0, p0

    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    move-wide v1, p1

    .line 43
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCB:D

    move-wide v1, p3

    .line 44
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCB:D

    move-wide v1, p5

    .line 45
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTemp:D

    move v1, p7

    .line 46
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSaturation:I

    move v1, p8

    .line 47
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mPga:I

    move-wide v1, p9

    .line 48
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTtff:J

    move v1, p11

    .line 49
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSvnum:I

    move-wide v1, p12

    .line 50
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTT4SV:J

    move-wide/from16 v1, p14

    .line 51
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTop4CNR:D

    move-wide/from16 v1, p16

    .line 52
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLongi:D

    move-wide/from16 v1, p18

    .line 53
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLati:D

    move-wide/from16 v1, p20

    .line 54
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhHeight:D

    move/from16 v1, p22

    .line 55
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitSrc:I

    move-wide/from16 v1, p23

    .line 56
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitPacc:D

    move/from16 v1, p25

    .line 57
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mHaveEPO:I

    move/from16 v1, p26

    .line 58
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mEPOage:I

    move-wide/from16 v1, p27

    .line 59
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSensorHACC:D

    move/from16 v1, p29

    .line 60
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mMPEvalid:I

    move/from16 v1, p30

    .line 61
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mLsvalid:I

    move/from16 v1, p31

    .line 62
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mNoiseFloor:I

    move/from16 v1, p32

    .line 63
    iput v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitTimeSource:I

    move-wide/from16 v1, p33

    .line 64
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitGpsSec:D

    move-wide/from16 v1, p35

    .line 65
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTempRate:D

    move-wide/from16 v1, p37

    .line 66
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCdRate:D

    move-wide/from16 v1, p39

    .line 67
    iput-wide v1, v0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mXtalJumpDetec:J

    return-void
.end method

.method public constructor <init>(Landroid/os/Parcel;)V
    .locals 2

    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 71
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCB:D

    .line 72
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCB:D

    .line 73
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTemp:D

    .line 74
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSaturation:I

    .line 75
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mPga:I

    .line 76
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTtff:J

    .line 77
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSvnum:I

    .line 78
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTT4SV:J

    .line 79
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTop4CNR:D

    .line 80
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLongi:D

    .line 81
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLati:D

    .line 82
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhHeight:D

    .line 83
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitSrc:I

    .line 84
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitPacc:D

    .line 85
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mHaveEPO:I

    .line 86
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mEPOage:I

    .line 87
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSensorHACC:D

    .line 88
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mMPEvalid:I

    .line 89
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mLsvalid:I

    .line 90
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mNoiseFloor:I

    .line 91
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitTimeSource:I

    .line 92
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitGpsSec:D

    .line 93
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTempRate:D

    .line 94
    invoke-virtual {p1}, Landroid/os/Parcel;->readDouble()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCdRate:D

    .line 95
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mXtalJumpDetec:J

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getCB()D
    .locals 2

    .line 99
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCB:D

    return-wide v0
.end method

.method public getClkTemp()D
    .locals 2

    .line 107
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTemp:D

    return-wide v0
.end method

.method public getClkTempRate()D
    .locals 2

    .line 187
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTempRate:D

    return-wide v0
.end method

.method public getCompCdRate()D
    .locals 2

    .line 191
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCdRate:D

    return-wide v0
.end method

.method public getEPOage()I
    .locals 0

    .line 159
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mEPOage:I

    return p0
.end method

.method public getHaveEPO()I
    .locals 0

    .line 155
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mHaveEPO:I

    return p0
.end method

.method public getInitGpsSec()D
    .locals 2

    .line 183
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitGpsSec:D

    return-wide v0
.end method

.method public getInitLlhHeight()D
    .locals 2

    .line 143
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhHeight:D

    return-wide v0
.end method

.method public getInitLlhLati()D
    .locals 2

    .line 139
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLati:D

    return-wide v0
.end method

.method public getInitLlhLongi()D
    .locals 2

    .line 135
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLongi:D

    return-wide v0
.end method

.method public getInitPacc()D
    .locals 2

    .line 151
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitPacc:D

    return-wide v0
.end method

.method public getInitSrc()I
    .locals 0

    .line 147
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitSrc:I

    return p0
.end method

.method public getInitTimeSource()I
    .locals 0

    .line 179
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitTimeSource:I

    return p0
.end method

.method public getLsvalid()I
    .locals 0

    .line 171
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mLsvalid:I

    return p0
.end method

.method public getMPEvalid()I
    .locals 0

    .line 167
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mMPEvalid:I

    return p0
.end method

.method public getNoiseFloor()I
    .locals 0

    .line 175
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mNoiseFloor:I

    return p0
.end method

.method public getPga()I
    .locals 0

    .line 115
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mPga:I

    return p0
.end method

.method public getSaturation()I
    .locals 0

    .line 111
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSaturation:I

    return p0
.end method

.method public getSensorHACC()D
    .locals 2

    .line 163
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSensorHACC:D

    return-wide v0
.end method

.method public getSvnum()I
    .locals 0

    .line 123
    iget p0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSvnum:I

    return p0
.end method

.method public getTT4SV()J
    .locals 2

    .line 127
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTT4SV:J

    return-wide v0
.end method

.method public getTop4CNR()D
    .locals 2

    .line 131
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTop4CNR:D

    return-wide v0
.end method

.method public getTtff()J
    .locals 2

    .line 119
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTtff:J

    return-wide v0
.end method

.method public getXtalJumpDetec()J
    .locals 2

    .line 195
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mXtalJumpDetec:J

    return-wide v0
.end method

.method public getmCompCB()D
    .locals 2

    .line 103
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCB:D

    return-wide v0
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 245
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    .line 246
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCB:D

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 247
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCB:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 248
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTemp:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 249
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSaturation:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 250
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mPga:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 251
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTtff:J

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 252
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSvnum:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 253
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTT4SV:J

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 254
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTop4CNR:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 255
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLongi:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 256
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLati:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 257
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhHeight:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 258
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitSrc:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 259
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitPacc:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 260
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mHaveEPO:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 261
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mEPOage:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 262
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSensorHACC:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 263
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mMPEvalid:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 264
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mLsvalid:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 265
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mNoiseFloor:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 266
    iget v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitTimeSource:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 267
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitGpsSec:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 268
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTempRate:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 269
    iget-wide v2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCdRate:D

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 270
    iget-wide v1, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mXtalJumpDetec:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 271
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 2

    .line 207
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCB:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 208
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCB:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 209
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTemp:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 210
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSaturation:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 211
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mPga:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 212
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTtff:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 213
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSvnum:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 214
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTT4SV:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 215
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mTop4CNR:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 216
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLongi:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 217
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhLati:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 218
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitLlhHeight:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 219
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitSrc:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 220
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitPacc:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 221
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mHaveEPO:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 222
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mEPOage:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 223
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mSensorHACC:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 224
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mMPEvalid:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 225
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mLsvalid:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 226
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mNoiseFloor:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 227
    iget p2, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitTimeSource:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 228
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mInitGpsSec:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 229
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mClkTempRate:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 230
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mCompCdRate:D

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeDouble(D)V

    .line 231
    iget-wide v0, p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;->mXtalJumpDetec:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    return-void
.end method
