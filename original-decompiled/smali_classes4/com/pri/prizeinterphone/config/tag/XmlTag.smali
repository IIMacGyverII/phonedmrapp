.class public abstract Lcom/pri/prizeinterphone/config/tag/XmlTag;
.super Ljava/lang/Object;
.source "XmlTag.java"


# instance fields
.field private mTag:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;)V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 14
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/tag/XmlTag;->mTag:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public getTag()Ljava/lang/String;
    .locals 0

    .line 34
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTag;->mTag:Ljava/lang/String;

    return-object p0
.end method

.method public isAvailable(Ljava/lang/String;)Z
    .locals 1

    .line 7
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isForceFilter()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 8
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTag;->mTag:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    .line 10
    :cond_0
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isFilter(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTag;->mTag:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public abstract isFilter(Ljava/lang/String;)Z
.end method

.method public isForceFilter()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method
