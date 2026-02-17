.class public Lcom/pri/prizeinterphone/serial/data/ChannelData;
.super Ljava/lang/Object;
.source "ChannelData.java"

# interfaces
.implements Landroid/os/Parcelable;
.implements Ljava/lang/Cloneable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/serial/data/ChannelData$ChannelInterrupt;,
        Lcom/pri/prizeinterphone/serial/data/ChannelData$ChannelContactType;,
        Lcom/pri/prizeinterphone/serial/data/ChannelData$ChannelPower;,
        Lcom/pri/prizeinterphone/serial/data/ChannelData$ChannelType;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public _id:I

.field public active:I

.field public band:I

.field public cc:I

.field public channelMode:I

.field public contactType:I

.field public encryptKey:Ljava/lang/String;

.field public encryptSw:I

.field public groups:[I

.field public inBoundSlot:I

.field public interrupt:I

.field public mic:I

.field public name:Ljava/lang/String;

.field public number:I

.field public outBoundSlot:I

.field public power:I

.field public relay:I

.field public rxFreq:I

.field public rxSubCode:I

.field public rxType:I

.field public sq:I

.field public txContact:I

.field public txFreq:I

.field public txSubCode:I

.field public txType:I

.field public type:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 401
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/ChannelData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 4

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 23
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 24
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    const v1, 0x17e727e8

    .line 25
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 26
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    const/4 v1, 0x1

    .line 27
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 28
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    .line 33
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    .line 34
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    .line 35
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    .line 36
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    .line 37
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    const/4 v2, 0x2

    .line 38
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    const-string v3, ""

    .line 39
    iput-object v3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    .line 40
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->mic:I

    .line 41
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    .line 42
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    .line 44
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    .line 45
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    .line 46
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    .line 47
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    .line 48
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    .line 49
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    .line 50
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    const/16 v2, 0x20

    new-array v2, v2, [I

    .line 51
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    .line 17
    invoke-static {v2, v0}, Ljava/util/Arrays;->fill([II)V

    .line 18
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    aput v1, p0, v0

    return-void
.end method

.method public constructor <init>(ILjava/lang/String;IIIIIIIIIIIILjava/lang/String;IIIIIIIII[I)V
    .locals 2

    move-object v0, p0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v1, 0x0

    .line 40
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->mic:I

    move v1, p1

    .line 54
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    move-object v1, p2

    .line 55
    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    move v1, p3

    .line 56
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    move v1, p4

    .line 57
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    move v1, p5

    .line 58
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    move v1, p6

    .line 59
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    move v1, p7

    .line 60
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    move v1, p8

    .line 61
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    move v1, p9

    .line 62
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    move v1, p10

    .line 63
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    move v1, p11

    .line 64
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    move v1, p12

    .line 65
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    move v1, p13

    .line 66
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    move/from16 v1, p14

    .line 67
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    move-object/from16 v1, p15

    .line 68
    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    move/from16 v1, p16

    .line 70
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    move/from16 v1, p17

    .line 71
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    move/from16 v1, p18

    .line 72
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    move/from16 v1, p19

    .line 73
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    move/from16 v1, p20

    .line 74
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    move/from16 v1, p21

    .line 75
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    move/from16 v1, p22

    .line 76
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    move/from16 v1, p23

    .line 77
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    move/from16 v1, p24

    .line 78
    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    move-object/from16 v1, p25

    .line 79
    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 3

    .line 325
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 23
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 24
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    const v1, 0x17e727e8

    .line 25
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 26
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    const/4 v1, 0x1

    .line 27
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 28
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    .line 33
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    .line 34
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    .line 35
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    .line 36
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    .line 37
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    const/4 v1, 0x2

    .line 38
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    const-string v2, ""

    .line 39
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    .line 40
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->mic:I

    .line 41
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    .line 42
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    .line 44
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    .line 45
    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    .line 46
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    .line 47
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    .line 48
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    .line 49
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    .line 50
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    const/16 v0, 0x20

    new-array v1, v0, [I

    .line 51
    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    .line 326
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 327
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    .line 328
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 329
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    .line 330
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 331
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 332
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 333
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    .line 334
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    .line 335
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    .line 336
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    .line 337
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    .line 338
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    .line 339
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    .line 340
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    .line 341
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    .line 343
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    .line 344
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    .line 345
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    .line 346
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    .line 347
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    .line 348
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    .line 349
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    .line 350
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    new-array v0, v0, [I

    .line 351
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    .line 352
    invoke-virtual {p1, v0}, Landroid/os/Parcel;->readIntArray([I)V

    return-void
.end method


# virtual methods
.method public clone()Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 4
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/CloneNotSupportedException;
        }
    .end annotation

    .line 447
    invoke-super {p0}, Ljava/lang/Object;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 448
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 449
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    .line 450
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 451
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    .line 452
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 453
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 454
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 455
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    .line 457
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    .line 458
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    .line 459
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    .line 460
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    .line 461
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    .line 462
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    .line 463
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    .line 466
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    .line 467
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    .line 468
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    .line 469
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    .line 470
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    .line 471
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    .line 472
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    .line 473
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    .line 475
    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    const/4 v1, 0x0

    .line 476
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    array-length v3, v2

    if-ge v1, v3, :cond_0

    .line 477
    iget-object v3, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    aget v2, v2, v1

    aput v2, v3, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public bridge synthetic clone()Ljava/lang/Object;
    .locals 0
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/CloneNotSupportedException;
        }
    .end annotation

    .line 14
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->clone()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p0

    return-object p0
.end method

.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getActive()I
    .locals 0

    .line 275
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    return p0
.end method

.method public getBand()I
    .locals 0

    .line 227
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    return p0
.end method

.method public getCc()I
    .locals 0

    .line 139
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    return p0
.end method

.method public getChannelMode()I
    .locals 0

    .line 163
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    return p0
.end method

.method public getContactType()I
    .locals 0

    .line 171
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    return p0
.end method

.method public getEncryptKey()Ljava/lang/String;
    .locals 0

    .line 195
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    return-object p0
.end method

.method public getEncryptSw()I
    .locals 0

    .line 187
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    return p0
.end method

.method public getGroups()[I
    .locals 0

    .line 283
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    return-object p0
.end method

.method public getId()I
    .locals 0

    .line 83
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    return p0
.end method

.method public getInBoundSlot()I
    .locals 0

    .line 147
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    return p0
.end method

.method public getInterrupt()I
    .locals 0

    .line 219
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    return p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 91
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    return-object p0
.end method

.method public getNumber()I
    .locals 0

    .line 107
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return p0
.end method

.method public getOutBoundSlot()I
    .locals 0

    .line 155
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    return p0
.end method

.method public getPower()I
    .locals 0

    .line 131
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    return p0
.end method

.method public getRelay()I
    .locals 0

    .line 211
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    return p0
.end method

.method public getRxFreq()I
    .locals 0

    .line 123
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    return p0
.end method

.method public getRxSubCode()I
    .locals 0

    .line 251
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    return p0
.end method

.method public getRxType()I
    .locals 0

    .line 243
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    return p0
.end method

.method public getSq()I
    .locals 0

    .line 235
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    return p0
.end method

.method public getTxContact()I
    .locals 0

    .line 179
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    return p0
.end method

.method public getTxFreq()I
    .locals 0

    .line 115
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    return p0
.end method

.method public getTxSubCode()I
    .locals 0

    .line 267
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    return p0
.end method

.method public getTxType()I
    .locals 0

    .line 259
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    return p0
.end method

.method public getType()I
    .locals 0

    .line 99
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    return p0
.end method

.method public intListToString(Ljava/util/List;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 369
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const-string p1, ""

    move-object v0, p1

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    .line 370
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 371
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 373
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ","

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method public setActive(I)V
    .locals 0

    .line 279
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    return-void
.end method

.method public setBand(I)V
    .locals 0

    .line 231
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    return-void
.end method

.method public setCc(I)V
    .locals 0

    .line 143
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    return-void
.end method

.method public setChannelMode(I)V
    .locals 0

    .line 167
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    return-void
.end method

.method public setContactType(I)V
    .locals 0

    .line 175
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    return-void
.end method

.method public setEncryptKey(Ljava/lang/String;)V
    .locals 0

    .line 199
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    return-void
.end method

.method public setEncryptSw(I)V
    .locals 0

    .line 191
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    return-void
.end method

.method public setGroups([I)V
    .locals 0

    .line 287
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    return-void
.end method

.method public setId(I)V
    .locals 0

    .line 87
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    return-void
.end method

.method public setInBoundSlot(I)V
    .locals 0

    .line 151
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    return-void
.end method

.method public setInterrupt(I)V
    .locals 0

    .line 223
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 95
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    return-void
.end method

.method public setNumber(I)V
    .locals 0

    .line 111
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return-void
.end method

.method public setOutBoundSlot(I)V
    .locals 0

    .line 159
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    return-void
.end method

.method public setPower(I)V
    .locals 0

    .line 135
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    return-void
.end method

.method public setRelay(I)V
    .locals 0

    .line 215
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    return-void
.end method

.method public setRxFreq(I)V
    .locals 0

    .line 127
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    return-void
.end method

.method public setRxSubCode(I)V
    .locals 0

    .line 255
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    return-void
.end method

.method public setRxType(I)V
    .locals 0

    .line 247
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    return-void
.end method

.method public setSq(I)V
    .locals 0

    .line 239
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    return-void
.end method

.method public setTxContact(I)V
    .locals 0

    .line 183
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    return-void
.end method

.method public setTxFreq(I)V
    .locals 0

    .line 119
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    return-void
.end method

.method public setTxSubCode(I)V
    .locals 0

    .line 271
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    return-void
.end method

.method public setTxType(I)V
    .locals 0

    .line 263
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    return-void
.end method

.method public setType(I)V
    .locals 0

    .line 103
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    return-void
.end method

.method public stringToIntList(Ljava/lang/String;)Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 357
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-nez p0, :cond_0

    const-string p0, ","

    .line 358
    invoke-virtual {p1, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 359
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 360
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 361
    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {p1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :cond_1
    return-object p1
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 414
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ChannelData{_id="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", type="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", number="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", txFreq="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", rxFreq="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", power="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", cc="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", inBoundSlot="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", outBoundSlot="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", channelMode="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", contactType="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", txContact="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", encryptSw="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", encryptKey=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", relay="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", interrupt="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", band="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", sq="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rxType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rxSubCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", txSubCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", active="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", groups="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    .line 440
    invoke-static {p0}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 297
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 298
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 299
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 300
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 301
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 302
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 303
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 304
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 305
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->inBoundSlot:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 306
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->outBoundSlot:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 307
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->channelMode:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 308
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 309
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 310
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptSw:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 311
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->encryptKey:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 312
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->relay:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 313
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 315
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 316
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 317
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 318
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 319
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 320
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 321
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 322
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeIntArray([I)V

    return-void
.end method
