.class public Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;
.super Ljava/lang/Object;
.source "RequestBuilder.java"


# static fields
.field private static final CLA_STORE_DATA:I = 0x80

.field private static final INS_STORE_DATA:I = 0xe2

.field private static final MAX_APDU_DATA_LEN:I = 0xff

.field private static final MAX_EXT_APDU_DATA_LEN:I = 0xffff

.field private static final P1_STORE_DATA_END:I = 0x91

.field private static final P1_STORE_DATA_INTERM:I = 0x11


# instance fields
.field private final mChannel:I

.field private final mCommands:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;",
            ">;"
        }
    .end annotation
.end field

.field private final mMaxApduDataLen:I


# direct methods
.method constructor <init>(IZ)V
    .locals 1

    .line 95
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 44
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mCommands:Ljava/util/List;

    .line 96
    iput p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mChannel:I

    if-eqz p2, :cond_0

    const p1, 0xffff

    goto :goto_0

    :cond_0
    const/16 p1, 0xff

    .line 97
    :goto_0
    iput p1, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mMaxApduDataLen:I

    return-void
.end method


# virtual methods
.method public addApdu(IIII)V
    .locals 10

    .line 67
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mCommands:Ljava/util/List;

    new-instance v9, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v2, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mChannel:I

    const/4 v7, 0x0

    const-string v8, ""

    move-object v1, v9

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;-><init>(IIIIIILjava/lang/String;)V

    invoke-interface {v0, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addApdu(IIIIILjava/lang/String;)V
    .locals 11

    move-object v0, p0

    .line 51
    iget-object v1, v0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mCommands:Ljava/util/List;

    new-instance v10, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v3, v0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mChannel:I

    move-object v2, v10

    move v4, p1

    move v5, p2

    move v6, p3

    move v7, p4

    move/from16 v8, p5

    move-object/from16 v9, p6

    invoke-direct/range {v2 .. v9}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;-><init>(IIIIIILjava/lang/String;)V

    invoke-interface {v1, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addApdu(IIIILjava/lang/String;)V
    .locals 10

    .line 59
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mCommands:Ljava/util/List;

    new-instance v9, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;

    iget v2, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mChannel:I

    invoke-virtual {p5}, Ljava/lang/String;->length()I

    move-result p0

    div-int/lit8 v7, p0, 0x2

    move-object v1, v9

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move-object v8, p5

    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;-><init>(IIIIIILjava/lang/String;)V

    invoke-interface {v0, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addStoreData(Ljava/lang/String;)V
    .locals 12

    .line 78
    iget v0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mMaxApduDataLen:I

    mul-int/lit8 v0, v0, 0x2

    .line 80
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    div-int/lit8 v1, v1, 0x2

    const/4 v2, 0x1

    if-nez v1, :cond_0

    move v1, v2

    goto :goto_0

    .line 81
    :cond_0
    iget v3, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mMaxApduDataLen:I

    add-int/2addr v1, v3

    sub-int/2addr v1, v2

    div-int/2addr v1, v3

    :goto_0
    const/4 v3, 0x0

    move v4, v2

    :goto_1
    if-ge v4, v1, :cond_1

    add-int v5, v3, v0

    .line 83
    invoke-virtual {p1, v3, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v11

    const/16 v7, 0x80

    const/16 v8, 0xe2

    const/16 v9, 0x11

    add-int/lit8 v10, v4, -0x1

    move-object v6, p0

    .line 84
    invoke-virtual/range {v6 .. v11}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->addApdu(IIIILjava/lang/String;)V

    add-int/lit8 v4, v4, 0x1

    move v3, v5

    goto :goto_1

    .line 87
    :cond_1
    invoke-virtual {p1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v11

    const/16 v7, 0x80

    const/16 v8, 0xe2

    const/16 v9, 0x91

    add-int/lit8 v10, v1, -0x1

    move-object v6, p0

    .line 88
    invoke-virtual/range {v6 .. v11}, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->addApdu(IIIILjava/lang/String;)V

    return-void
.end method

.method getCommands()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/euicc/apdu/ApduCommand;",
            ">;"
        }
    .end annotation

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/apdu/RequestBuilder;->mCommands:Ljava/util/List;

    return-object p0
.end method
