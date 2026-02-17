.class public Lcom/mediatek/powerhalmgr/BoosterInfo;
.super Ljava/lang/Object;
.source "BoosterInfo.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final BOOSTER_ACTION_ADD_BY_LINKINFO:I = 0x4

.field public static final BOOSTER_ACTION_ADD_BY_UID:I = 0x1

.field public static final BOOSTER_ACTION_BASE:I = 0x0

.field public static final BOOSTER_ACTION_DEL_ALL:I = 0x7

.field public static final BOOSTER_ACTION_DEL_BY_LINKINFO:I = 0x5

.field public static final BOOSTER_ACTION_DEL_BY_LINKINFO_ALL:I = 0x6

.field public static final BOOSTER_ACTION_DEL_BY_UID:I = 0x2

.field public static final BOOSTER_ACTION_DEL_BY_UID_ALL:I = 0x3

.field public static final BOOSTER_GROUP_A:I

.field public static final BOOSTER_GROUP_B:I

.field public static BOOSTER_GROUP_BASE:I

.field public static final BOOSTER_GROUP_C:I

.field public static final BOOSTER_GROUP_D:I

.field public static final BOOSTER_GROUP_MAX:I

.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/mediatek/powerhalmgr/BoosterInfo;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mAction:I

.field private mDstIp:Ljava/lang/String;

.field private mDstPort:I

.field private mGroup:I

.field private mMoreInfo:[Ljava/lang/String;

.field private mMoreValue:[I

.field private mProto:I

.field private mSrcIp:Ljava/lang/String;

.field private mSrcPort:I

.field private mUid:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const/4 v0, 0x0

    add-int/lit8 v1, v0, 0x1

    .line 39
    sput v1, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_A:I

    add-int/lit8 v1, v0, 0x2

    .line 40
    sput v1, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_B:I

    add-int/lit8 v1, v0, 0x3

    .line 41
    sput v1, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_C:I

    add-int/lit8 v0, v0, 0x4

    .line 42
    sput v0, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_D:I

    .line 47
    sput v0, Lcom/mediatek/powerhalmgr/BoosterInfo;->BOOSTER_GROUP_MAX:I

    .line 285
    new-instance v0, Lcom/mediatek/powerhalmgr/BoosterInfo$1;

    invoke-direct {v0}, Lcom/mediatek/powerhalmgr/BoosterInfo$1;-><init>()V

    sput-object v0, Lcom/mediatek/powerhalmgr/BoosterInfo;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>(II)V
    .locals 11

    const/4 v3, -0x1

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, -0x1

    const/4 v7, -0x1

    const/4 v8, -0x1

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    .line 152
    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method public constructor <init>(III)V
    .locals 11

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, -0x1

    const/4 v7, -0x1

    const/4 v8, -0x1

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    .line 128
    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method public constructor <init>(IIILjava/lang/String;Ljava/lang/String;III)V
    .locals 11

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move-object v4, p4

    move-object/from16 v5, p5

    move/from16 v6, p6

    move/from16 v7, p7

    move/from16 v8, p8

    .line 168
    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method public constructor <init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V
    .locals 0

    .line 196
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 197
    iput p1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    .line 198
    iput p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    .line 199
    iput p3, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    .line 200
    iput-object p4, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    .line 201
    iput-object p5, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    .line 202
    iput p6, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    .line 203
    iput p7, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    .line 204
    iput p8, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    .line 205
    iput-object p9, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    .line 206
    iput-object p10, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    return-void
.end method

.method public constructor <init>(IILjava/lang/String;Ljava/lang/String;III)V
    .locals 11

    const/4 v3, -0x1

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-object v4, p3

    move-object v5, p4

    move/from16 v6, p5

    move/from16 v7, p6

    move/from16 v8, p7

    .line 143
    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method public constructor <init>(II[Ljava/lang/String;[I)V
    .locals 11

    const/4 v3, -0x1

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, -0x1

    const/4 v7, -0x1

    const/4 v8, -0x1

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-object v9, p3

    move-object v10, p4

    .line 179
    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method private constructor <init>(Landroid/os/Parcel;)V
    .locals 2

    .line 209
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, -0x1

    .line 92
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    .line 93
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    .line 94
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    const/4 v1, 0x0

    .line 99
    iput-object v1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    .line 100
    iput-object v1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    .line 104
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    .line 105
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    .line 109
    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    .line 110
    iput-object v1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    .line 111
    iput-object v1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    .line 210
    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/BoosterInfo;->readFromParcel(Landroid/os/Parcel;)V

    return-void
.end method

.method synthetic constructor <init>(Landroid/os/Parcel;Lcom/mediatek/powerhalmgr/BoosterInfo-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(Landroid/os/Parcel;)V

    return-void
.end method

.method public constructor <init>(Lcom/mediatek/powerhalmgr/BoosterInfo;)V
    .locals 11

    .line 117
    iget v1, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    iget v2, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    iget v3, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    iget-object v4, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    iget-object v5, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    iget v6, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    iget v7, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    iget v8, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    iget-object v9, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    iget-object v10, p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    move-object v0, p0

    invoke-direct/range {v0 .. v10}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(IIILjava/lang/String;Ljava/lang/String;III[Ljava/lang/String;[I)V

    return-void
.end method

.method private readFromParcel(Landroid/os/Parcel;)V
    .locals 1

    .line 273
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    .line 274
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    .line 275
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    .line 276
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    .line 277
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    .line 278
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    .line 279
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    .line 280
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    .line 281
    invoke-virtual {p1}, Landroid/os/Parcel;->createStringArray()[Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    .line 282
    invoke-virtual {p1}, Landroid/os/Parcel;->createIntArray()[I

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getAction()I
    .locals 0

    .line 223
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    return p0
.end method

.method public getDstIp()Ljava/lang/String;
    .locals 0

    .line 235
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    return-object p0
.end method

.method public getDstPort()I
    .locals 0

    .line 243
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    return p0
.end method

.method public getGroup()I
    .locals 0

    .line 219
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    return p0
.end method

.method public getMoreInfo()[Ljava/lang/String;
    .locals 0

    .line 251
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    return-object p0
.end method

.method public getMoreValue()[I
    .locals 0

    .line 255
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    return-object p0
.end method

.method public getProto()I
    .locals 0

    .line 247
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    return p0
.end method

.method public getSrcIp()Ljava/lang/String;
    .locals 0

    .line 231
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    return-object p0
.end method

.method public getSrcPort()I
    .locals 0

    .line 239
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    return p0
.end method

.method public getUid()I
    .locals 0

    .line 227
    iget p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 300
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "BoosterInfo("

    .line 301
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 302
    iget v1, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ","

    .line 303
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 304
    iget v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 305
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 306
    iget v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 307
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 308
    iget-object v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 309
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 310
    iget-object v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 311
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 312
    iget v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 313
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 314
    iget v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 315
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 316
    iget v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 317
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 318
    iget-object v2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    invoke-static {v2}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 319
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 320
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    invoke-static {p0}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    .line 321
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 322
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 260
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mGroup:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 261
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mAction:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 262
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mUid:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 263
    iget-object p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcIp:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 264
    iget-object p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstIp:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 265
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mSrcPort:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 266
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mDstPort:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 267
    iget p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mProto:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 268
    iget-object p2, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreInfo:[Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeStringArray([Ljava/lang/String;)V

    .line 269
    iget-object p0, p0, Lcom/mediatek/powerhalmgr/BoosterInfo;->mMoreValue:[I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeIntArray([I)V

    return-void
.end method
