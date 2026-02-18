.class Lcom/mediatek/amsAal/AalUtils$AalIndex;
.super Ljava/lang/Object;
.source "AalUtils.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/amsAal/AalUtils;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "AalIndex"
.end annotation


# instance fields
.field private mMode:I

.field private mName:Ljava/lang/String;

.field final synthetic this$0:Lcom/mediatek/amsAal/AalUtils;


# direct methods
.method constructor <init>(Lcom/mediatek/amsAal/AalUtils;ILjava/lang/String;)V
    .locals 0

    .line 377
    iput-object p1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->this$0:Lcom/mediatek/amsAal/AalUtils;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 378
    invoke-direct {p0, p2, p3}, Lcom/mediatek/amsAal/AalUtils$AalIndex;->set(ILjava/lang/String;)V

    return-void
.end method

.method private set(ILjava/lang/String;)V
    .locals 0

    .line 382
    iput p1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    .line 383
    iput-object p2, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x0

    if-nez p1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x1

    if-ne p1, p0, :cond_1

    return v1

    .line 407
    :cond_1
    instance-of v2, p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    if-nez v2, :cond_2

    return v0

    .line 411
    :cond_2
    check-cast p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    .line 412
    iget-object v2, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    if-nez v2, :cond_4

    iget-object v3, p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    if-nez v3, :cond_4

    .line 413
    iget p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    iget p1, p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    if-ne p0, p1, :cond_3

    move v0, v1

    :cond_3
    return v0

    :cond_4
    if-eqz v2, :cond_6

    .line 414
    iget-object v3, p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    if-nez v3, :cond_5

    goto :goto_0

    .line 417
    :cond_5
    iget p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    iget p1, p1, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    if-ne p0, p1, :cond_6

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_6

    move v0, v1

    :cond_6
    :goto_0
    return v0
.end method

.method public getIndexName()Ljava/lang/String;
    .locals 0

    .line 391
    iget-object p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    return-object p0
.end method

.method public getMode()I
    .locals 0

    .line 387
    iget p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    return p0
.end method

.method public hashCode()I
    .locals 2

    .line 422
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget v1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 423
    iget-object v1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    if-eqz v1, :cond_0

    .line 424
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 426
    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 396
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ": "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->this$0:Lcom/mediatek/amsAal/AalUtils;

    iget v2, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mMode:I

    invoke-static {v1, v2}, Lcom/mediatek/amsAal/AalUtils;->-$$Nest$mmodeToString(Lcom/mediatek/amsAal/AalUtils;I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/amsAal/AalUtils$AalIndex;->mName:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
