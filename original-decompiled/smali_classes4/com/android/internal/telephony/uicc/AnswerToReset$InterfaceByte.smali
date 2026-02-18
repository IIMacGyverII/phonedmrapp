.class public Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;
.super Ljava/lang/Object;
.source "AnswerToReset.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/AnswerToReset;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "InterfaceByte"
.end annotation


# instance fields
.field private mTA:Ljava/lang/Byte;

.field private mTB:Ljava/lang/Byte;

.field private mTC:Ljava/lang/Byte;

.field private mTD:Ljava/lang/Byte;


# direct methods
.method private constructor <init>()V
    .locals 1

    .line 390
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 391
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    .line 392
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    .line 393
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    .line 394
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;-><init>()V

    return-void
.end method

.method public constructor <init>(Ljava/lang/Byte;Ljava/lang/Byte;Ljava/lang/Byte;Ljava/lang/Byte;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 398
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 399
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    .line 400
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    .line 401
    iput-object p3, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    .line 402
    iput-object p4, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    return-void
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    .line 410
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    if-eq v2, v3, :cond_1

    goto :goto_1

    .line 413
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;

    .line 414
    iget-object v2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->getTA()Ljava/lang/Byte;

    move-result-object v3

    invoke-static {v2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    .line 415
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->getTB()Ljava/lang/Byte;

    move-result-object v3

    invoke-static {v2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    .line 416
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->getTC()Ljava/lang/Byte;

    move-result-object v3

    invoke-static {v2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    .line 417
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->getTD()Ljava/lang/Byte;

    move-result-object p1

    invoke-static {p0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v1

    :goto_0
    return v0

    :cond_3
    :goto_1
    return v1
.end method

.method public getTA()Ljava/lang/Byte;
    .locals 0

    .line 356
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    return-object p0
.end method

.method public getTB()Ljava/lang/Byte;
    .locals 0

    .line 361
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    return-object p0
.end method

.method public getTC()Ljava/lang/Byte;
    .locals 0

    .line 366
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    return-object p0
.end method

.method public getTD()Ljava/lang/Byte;
    .locals 0

    .line 371
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    return-object p0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/Object;

    .line 422
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    const/4 v1, 0x3

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public setTA(Ljava/lang/Byte;)V
    .locals 0

    .line 375
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    return-void
.end method

.method public setTB(Ljava/lang/Byte;)V
    .locals 0

    .line 379
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    return-void
.end method

.method public setTC(Ljava/lang/Byte;)V
    .locals 0

    .line 383
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    return-void
.end method

.method public setTD(Ljava/lang/Byte;)V
    .locals 0

    .line 387
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 427
    new-instance v0, Ljava/lang/StringBuffer;

    invoke-direct {v0}, Ljava/lang/StringBuffer;-><init>()V

    const-string/jumbo v1, "{"

    .line 428
    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v1, "TA="

    .line 429
    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTA:Ljava/lang/Byte;

    invoke-static {v1}, Lcom/android/internal/telephony/uicc/AnswerToReset;->-$$Nest$smbyteToStringHex(Ljava/lang/Byte;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v1, ","

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v2, "TB="

    .line 430
    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTB:Ljava/lang/Byte;

    invoke-static {v2}, Lcom/android/internal/telephony/uicc/AnswerToReset;->-$$Nest$smbyteToStringHex(Ljava/lang/Byte;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v2, "TC="

    .line 431
    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTC:Ljava/lang/Byte;

    invoke-static {v2}, Lcom/android/internal/telephony/uicc/AnswerToReset;->-$$Nest$smbyteToStringHex(Ljava/lang/Byte;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v1, "TD="

    .line 432
    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/AnswerToReset$InterfaceByte;->mTD:Ljava/lang/Byte;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/AnswerToReset;->-$$Nest$smbyteToStringHex(Ljava/lang/Byte;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string/jumbo p0, "}"

    .line 433
    invoke-virtual {v0, p0}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    .line 434
    invoke-virtual {v0}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
