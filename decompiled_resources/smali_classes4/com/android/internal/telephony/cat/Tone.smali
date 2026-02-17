.class public final enum Lcom/android/internal/telephony/cat/Tone;
.super Ljava/lang/Enum;
.source "Tone.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/Tone;",
        ">;",
        "Landroid/os/Parcelable;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/Tone;

.field public static final enum BUSY:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum CALL_WAITING:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum CONGESTION:Lcom/android/internal/telephony/cat/Tone;

.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/android/internal/telephony/cat/Tone;",
            ">;"
        }
    .end annotation
.end field

.field public static final enum CRITICAL_ALERT:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum DIAL:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum ERROR_SPECIAL_INFO:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum GENERAL_BEEP:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum HAPPY:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum INCOMING_SMS:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum INCOMING_SPEECH_CALL:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_1:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_2:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_3:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_4:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_5:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_6:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_7:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MELODY_8:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum MESSAGE_RECEIVED:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum NEGATIVE_ACK:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum POSITIVE_ACK:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum QUESTION:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum RADIO_PATH_ACK:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum RADIO_PATH_NOT_AVAILABLE:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum RINGING:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum SAD:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum URGENT:Lcom/android/internal/telephony/cat/Tone;

.field public static final enum VIBRATE_ONLY:Lcom/android/internal/telephony/cat/Tone;


# instance fields
.field private mValue:I


# direct methods
.method static constructor <clinit>()V
    .locals 31

    .line 34
    new-instance v0, Lcom/android/internal/telephony/cat/Tone;

    const-string v1, "DIAL"

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lcom/android/internal/telephony/cat/Tone;->DIAL:Lcom/android/internal/telephony/cat/Tone;

    .line 39
    new-instance v1, Lcom/android/internal/telephony/cat/Tone;

    const-string v4, "BUSY"

    const/4 v5, 0x2

    invoke-direct {v1, v4, v3, v5}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v1, Lcom/android/internal/telephony/cat/Tone;->BUSY:Lcom/android/internal/telephony/cat/Tone;

    .line 44
    new-instance v4, Lcom/android/internal/telephony/cat/Tone;

    const-string v6, "CONGESTION"

    const/4 v7, 0x3

    invoke-direct {v4, v6, v5, v7}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v4, Lcom/android/internal/telephony/cat/Tone;->CONGESTION:Lcom/android/internal/telephony/cat/Tone;

    .line 49
    new-instance v6, Lcom/android/internal/telephony/cat/Tone;

    const-string v8, "RADIO_PATH_ACK"

    const/4 v9, 0x4

    invoke-direct {v6, v8, v7, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/Tone;->RADIO_PATH_ACK:Lcom/android/internal/telephony/cat/Tone;

    .line 54
    new-instance v8, Lcom/android/internal/telephony/cat/Tone;

    const-string v10, "RADIO_PATH_NOT_AVAILABLE"

    const/4 v11, 0x5

    invoke-direct {v8, v10, v9, v11}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v8, Lcom/android/internal/telephony/cat/Tone;->RADIO_PATH_NOT_AVAILABLE:Lcom/android/internal/telephony/cat/Tone;

    .line 59
    new-instance v10, Lcom/android/internal/telephony/cat/Tone;

    const-string v12, "ERROR_SPECIAL_INFO"

    const/4 v13, 0x6

    invoke-direct {v10, v12, v11, v13}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/Tone;->ERROR_SPECIAL_INFO:Lcom/android/internal/telephony/cat/Tone;

    .line 64
    new-instance v12, Lcom/android/internal/telephony/cat/Tone;

    const-string v14, "CALL_WAITING"

    const/4 v15, 0x7

    invoke-direct {v12, v14, v13, v15}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v12, Lcom/android/internal/telephony/cat/Tone;->CALL_WAITING:Lcom/android/internal/telephony/cat/Tone;

    .line 69
    new-instance v14, Lcom/android/internal/telephony/cat/Tone;

    const-string v13, "RINGING"

    const/16 v11, 0x8

    invoke-direct {v14, v13, v15, v11}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v14, Lcom/android/internal/telephony/cat/Tone;->RINGING:Lcom/android/internal/telephony/cat/Tone;

    .line 76
    new-instance v13, Lcom/android/internal/telephony/cat/Tone;

    const-string v15, "GENERAL_BEEP"

    const/16 v9, 0x10

    invoke-direct {v13, v15, v11, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v13, Lcom/android/internal/telephony/cat/Tone;->GENERAL_BEEP:Lcom/android/internal/telephony/cat/Tone;

    .line 81
    new-instance v15, Lcom/android/internal/telephony/cat/Tone;

    const-string v11, "POSITIVE_ACK"

    const/16 v7, 0x9

    const/16 v5, 0x11

    invoke-direct {v15, v11, v7, v5}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v15, Lcom/android/internal/telephony/cat/Tone;->POSITIVE_ACK:Lcom/android/internal/telephony/cat/Tone;

    .line 86
    new-instance v11, Lcom/android/internal/telephony/cat/Tone;

    const-string v7, "NEGATIVE_ACK"

    const/16 v3, 0xa

    const/16 v2, 0x12

    invoke-direct {v11, v7, v3, v2}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v11, Lcom/android/internal/telephony/cat/Tone;->NEGATIVE_ACK:Lcom/android/internal/telephony/cat/Tone;

    .line 91
    new-instance v7, Lcom/android/internal/telephony/cat/Tone;

    const-string v3, "INCOMING_SPEECH_CALL"

    const/16 v2, 0xb

    const/16 v5, 0x13

    invoke-direct {v7, v3, v2, v5}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v7, Lcom/android/internal/telephony/cat/Tone;->INCOMING_SPEECH_CALL:Lcom/android/internal/telephony/cat/Tone;

    .line 96
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v2, "INCOMING_SMS"

    const/16 v5, 0xc

    const/16 v9, 0x14

    invoke-direct {v3, v2, v5, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->INCOMING_SMS:Lcom/android/internal/telephony/cat/Tone;

    .line 104
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "CRITICAL_ALERT"

    const/16 v9, 0xd

    move-object/from16 v16, v3

    const/16 v3, 0x15

    invoke-direct {v2, v5, v9, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->CRITICAL_ALERT:Lcom/android/internal/telephony/cat/Tone;

    .line 109
    new-instance v5, Lcom/android/internal/telephony/cat/Tone;

    const-string v9, "VIBRATE_ONLY"

    const/16 v3, 0xe

    move-object/from16 v17, v2

    const/16 v2, 0x20

    invoke-direct {v5, v9, v3, v2}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v5, Lcom/android/internal/telephony/cat/Tone;->VIBRATE_ONLY:Lcom/android/internal/telephony/cat/Tone;

    .line 116
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v9, "HAPPY"

    const/16 v3, 0xf

    move-object/from16 v18, v5

    const/16 v5, 0x30

    invoke-direct {v2, v9, v3, v5}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->HAPPY:Lcom/android/internal/telephony/cat/Tone;

    .line 121
    new-instance v5, Lcom/android/internal/telephony/cat/Tone;

    const-string v9, "SAD"

    const/16 v3, 0x31

    move-object/from16 v19, v2

    const/16 v2, 0x10

    invoke-direct {v5, v9, v2, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v5, Lcom/android/internal/telephony/cat/Tone;->SAD:Lcom/android/internal/telephony/cat/Tone;

    .line 126
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v3, "URGENT"

    const/16 v9, 0x32

    move-object/from16 v20, v5

    const/16 v5, 0x11

    invoke-direct {v2, v3, v5, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->URGENT:Lcom/android/internal/telephony/cat/Tone;

    .line 131
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "QUESTION"

    const/16 v9, 0x33

    move-object/from16 v21, v2

    const/16 v2, 0x12

    invoke-direct {v3, v5, v2, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->QUESTION:Lcom/android/internal/telephony/cat/Tone;

    .line 136
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MESSAGE_RECEIVED"

    const/16 v9, 0x34

    move-object/from16 v22, v3

    const/16 v3, 0x13

    invoke-direct {v2, v5, v3, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->MESSAGE_RECEIVED:Lcom/android/internal/telephony/cat/Tone;

    .line 139
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_1"

    const/16 v9, 0x40

    move-object/from16 v23, v2

    const/16 v2, 0x14

    invoke-direct {v3, v5, v2, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->MELODY_1:Lcom/android/internal/telephony/cat/Tone;

    .line 140
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_2"

    const/16 v9, 0x41

    move-object/from16 v24, v3

    const/16 v3, 0x15

    invoke-direct {v2, v5, v3, v9}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->MELODY_2:Lcom/android/internal/telephony/cat/Tone;

    .line 141
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_3"

    const/16 v9, 0x16

    move-object/from16 v25, v2

    const/16 v2, 0x42

    invoke-direct {v3, v5, v9, v2}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->MELODY_3:Lcom/android/internal/telephony/cat/Tone;

    .line 142
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_4"

    const/16 v9, 0x17

    move-object/from16 v26, v3

    const/16 v3, 0x43

    invoke-direct {v2, v5, v9, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->MELODY_4:Lcom/android/internal/telephony/cat/Tone;

    .line 143
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_5"

    const/16 v9, 0x18

    move-object/from16 v27, v2

    const/16 v2, 0x44

    invoke-direct {v3, v5, v9, v2}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->MELODY_5:Lcom/android/internal/telephony/cat/Tone;

    .line 144
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_6"

    const/16 v9, 0x19

    move-object/from16 v28, v3

    const/16 v3, 0x45

    invoke-direct {v2, v5, v9, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->MELODY_6:Lcom/android/internal/telephony/cat/Tone;

    .line 145
    new-instance v3, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_7"

    const/16 v9, 0x1a

    move-object/from16 v29, v2

    const/16 v2, 0x46

    invoke-direct {v3, v5, v9, v2}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->MELODY_7:Lcom/android/internal/telephony/cat/Tone;

    .line 146
    new-instance v2, Lcom/android/internal/telephony/cat/Tone;

    const-string v5, "MELODY_8"

    const/16 v9, 0x1b

    move-object/from16 v30, v3

    const/16 v3, 0x47

    invoke-direct {v2, v5, v9, v3}, Lcom/android/internal/telephony/cat/Tone;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/Tone;->MELODY_8:Lcom/android/internal/telephony/cat/Tone;

    const/16 v3, 0x1c

    new-array v3, v3, [Lcom/android/internal/telephony/cat/Tone;

    const/4 v5, 0x0

    aput-object v0, v3, v5

    const/4 v0, 0x1

    aput-object v1, v3, v0

    const/4 v0, 0x2

    aput-object v4, v3, v0

    const/4 v0, 0x3

    aput-object v6, v3, v0

    const/4 v0, 0x4

    aput-object v8, v3, v0

    const/4 v0, 0x5

    aput-object v10, v3, v0

    const/4 v0, 0x6

    aput-object v12, v3, v0

    const/4 v0, 0x7

    aput-object v14, v3, v0

    const/16 v0, 0x8

    aput-object v13, v3, v0

    const/16 v0, 0x9

    aput-object v15, v3, v0

    const/16 v0, 0xa

    aput-object v11, v3, v0

    const/16 v0, 0xb

    aput-object v7, v3, v0

    const/16 v0, 0xc

    aput-object v16, v3, v0

    const/16 v0, 0xd

    aput-object v17, v3, v0

    const/16 v0, 0xe

    aput-object v18, v3, v0

    const/16 v0, 0xf

    aput-object v19, v3, v0

    const/16 v0, 0x10

    aput-object v20, v3, v0

    const/16 v0, 0x11

    aput-object v21, v3, v0

    const/16 v0, 0x12

    aput-object v22, v3, v0

    const/16 v0, 0x13

    aput-object v23, v3, v0

    const/16 v0, 0x14

    aput-object v24, v3, v0

    const/16 v0, 0x15

    aput-object v25, v3, v0

    const/16 v0, 0x16

    aput-object v26, v3, v0

    const/16 v0, 0x17

    aput-object v27, v3, v0

    const/16 v0, 0x18

    aput-object v28, v3, v0

    const/16 v0, 0x19

    aput-object v29, v3, v0

    const/16 v0, 0x1a

    aput-object v30, v3, v0

    const/16 v0, 0x1b

    aput-object v2, v3, v0

    .line 28
    sput-object v3, Lcom/android/internal/telephony/cat/Tone;->$VALUES:[Lcom/android/internal/telephony/cat/Tone;

    .line 183
    new-instance v0, Lcom/android/internal/telephony/cat/Tone$1;

    invoke-direct {v0}, Lcom/android/internal/telephony/cat/Tone$1;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/cat/Tone;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)V"
        }
    .end annotation

    .line 150
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 151
    iput p3, p0, Lcom/android/internal/telephony/cat/Tone;->mValue:I

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILandroid/os/Parcel;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/os/Parcel;",
            ")V"
        }
    .end annotation

    .line 169
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 170
    invoke-virtual {p3}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/cat/Tone;->mValue:I

    return-void
.end method

.method public static fromInt(I)Lcom/android/internal/telephony/cat/Tone;
    .locals 5

    .line 161
    invoke-static {}, Lcom/android/internal/telephony/cat/Tone;->values()[Lcom/android/internal/telephony/cat/Tone;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 162
    iget v4, v3, Lcom/android/internal/telephony/cat/Tone;->mValue:I

    if-ne v4, p0, :cond_0

    return-object v3

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/Tone;
    .locals 1

    .line 28
    const-class v0, Lcom/android/internal/telephony/cat/Tone;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/Tone;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/Tone;
    .locals 1

    .line 28
    sget-object v0, Lcom/android/internal/telephony/cat/Tone;->$VALUES:[Lcom/android/internal/telephony/cat/Tone;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/Tone;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/Tone;

    return-object v0
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 175
    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
