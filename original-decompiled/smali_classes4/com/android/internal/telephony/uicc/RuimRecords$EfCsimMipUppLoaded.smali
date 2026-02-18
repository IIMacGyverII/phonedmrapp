.class Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;
.super Ljava/lang/Object;
.source "RuimRecords.java"

# interfaces
.implements Lcom/android/internal/telephony/uicc/IccRecords$IccRecordLoaded;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/RuimRecords;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "EfCsimMipUppLoaded"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/RuimRecords;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/uicc/RuimRecords;)V
    .locals 0

    .line 533
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->this$0:Lcom/android/internal/telephony/uicc/RuimRecords;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/uicc/RuimRecords;Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;-><init>(Lcom/android/internal/telephony/uicc/RuimRecords;)V

    return-void
.end method


# virtual methods
.method checkLengthLegal(II)Z
    .locals 1

    if-ge p1, p2, :cond_0

    .line 541
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "CSIM MIPUPP format error, length = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "expected length at least ="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "RuimRecords"

    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method public getEfName()Ljava/lang/String;
    .locals 0

    const-string p0, "EF_CSIM_MIPUPP"

    return-object p0
.end method

.method public onRecordLoaded(Landroid/os/AsyncResult;)V
    .locals 11

    .line 552
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [B

    .line 554
    array-length v0, p1

    const-string v1, "RuimRecords"

    const/4 v2, 0x1

    if-ge v0, v2, :cond_0

    const-string p0, "MIPUPP read error"

    .line 555
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 559
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/BitwiseInputStream;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/BitwiseInputStream;-><init>([B)V

    const/16 p1, 0x8

    .line 561
    :try_start_0
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v3

    shl-int/lit8 v3, v3, 0x3

    .line 565
    invoke-virtual {p0, v3, v2}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v4

    if-nez v4, :cond_1

    return-void

    .line 569
    :cond_1
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v4

    add-int/lit8 v3, v3, -0x1

    if-ne v4, v2, :cond_3

    const/16 v4, 0xb

    .line 573
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v5

    if-nez v5, :cond_2

    return-void

    .line 576
    :cond_2
    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/BitwiseInputStream;->skip(I)V

    add-int/lit8 v3, v3, -0xb

    :cond_3
    const/4 v4, 0x4

    .line 581
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v5

    if-nez v5, :cond_4

    return-void

    .line 584
    :cond_4
    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v5

    add-int/lit8 v3, v3, -0x4

    const/4 v6, 0x0

    move v7, v6

    :goto_0
    if-ge v7, v5, :cond_11

    .line 589
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v8

    if-nez v8, :cond_5

    return-void

    .line 592
    :cond_5
    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v8

    add-int/lit8 v3, v3, -0x4

    .line 595
    invoke-virtual {p0, v3, p1}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v9

    if-nez v9, :cond_6

    return-void

    .line 598
    :cond_6
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v9

    add-int/lit8 v3, v3, -0x8

    if-nez v8, :cond_a

    shl-int/lit8 v2, v9, 0x3

    .line 603
    invoke-virtual {p0, v3, v2}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v2

    if-nez v2, :cond_7

    return-void

    .line 606
    :cond_7
    new-array v2, v9, [C

    :goto_1
    if-ge v6, v9, :cond_8

    .line 608
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v3

    and-int/lit16 v3, v3, 0xff

    int-to-char v3, v3

    aput-char v3, v2, v6

    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 610
    :cond_8
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->this$0:Lcom/android/internal/telephony/uicc/RuimRecords;

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v2}, Ljava/lang/String;-><init>([C)V

    invoke-static {p1, v0}, Lcom/android/internal/telephony/uicc/RuimRecords;->-$$Nest$fputmNai(Lcom/android/internal/telephony/uicc/RuimRecords;Ljava/lang/String;)V

    const/4 p1, 0x2

    .line 611
    invoke-static {v1, p1}, Landroid/util/Log;->isLoggable(Ljava/lang/String;I)Z

    move-result p1

    if-eqz p1, :cond_9

    .line 612
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MIPUPP Nai = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->this$0:Lcom/android/internal/telephony/uicc/RuimRecords;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/RuimRecords;->-$$Nest$fgetmNai(Lcom/android/internal/telephony/uicc/RuimRecords;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    :cond_9
    return-void

    :cond_a
    shl-int/lit8 v8, v9, 0x3

    add-int/lit8 v9, v8, 0x66

    .line 617
    invoke-virtual {p0, v3, v9}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v10

    if-nez v10, :cond_b

    return-void

    :cond_b
    add-int/lit8 v8, v8, 0x65

    .line 620
    invoke-virtual {v0, v8}, Lcom/android/internal/telephony/BitwiseInputStream;->skip(I)V

    .line 621
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v8

    sub-int/2addr v3, v9

    const/16 v9, 0x20

    if-ne v8, v2, :cond_d

    .line 625
    invoke-virtual {p0, v3, v9}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v8

    if-nez v8, :cond_c

    return-void

    .line 628
    :cond_c
    invoke-virtual {v0, v9}, Lcom/android/internal/telephony/BitwiseInputStream;->skip(I)V

    add-int/lit8 v3, v3, -0x20

    :cond_d
    const/4 v8, 0x5

    .line 633
    invoke-virtual {p0, v3, v8}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v8

    if-nez v8, :cond_e

    return-void

    .line 636
    :cond_e
    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/BitwiseInputStream;->skip(I)V

    add-int/lit8 v3, v3, -0x4

    .line 638
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/BitwiseInputStream;->read(I)I

    move-result v8

    add-int/lit8 v3, v3, -0x1

    if-ne v8, v2, :cond_10

    .line 642
    invoke-virtual {p0, v3, v9}, Lcom/android/internal/telephony/uicc/RuimRecords$EfCsimMipUppLoaded;->checkLengthLegal(II)Z

    move-result v8

    if-nez v8, :cond_f

    return-void

    .line 645
    :cond_f
    invoke-virtual {v0, v9}, Lcom/android/internal/telephony/BitwiseInputStream;->skip(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v3, v3, -0x20

    :cond_10
    add-int/lit8 v7, v7, 0x1

    goto/16 :goto_0

    :cond_11
    return-void

    :catch_0
    const-string p0, "MIPUPP read Exception error!"

    .line 651
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
