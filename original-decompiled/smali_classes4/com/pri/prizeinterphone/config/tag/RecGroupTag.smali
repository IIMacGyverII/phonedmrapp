.class public Lcom/pri/prizeinterphone/config/tag/RecGroupTag;
.super Lcom/pri/prizeinterphone/config/tag/XmlTag;
.source "RecGroupTag.java"


# direct methods
.method public constructor <init>()V
    .locals 1

    const-string v0, "recgroup"

    .line 9
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTag;-><init>(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;)V
    .locals 0

    .line 5
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/config/tag/XmlTag;-><init>(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public isFilter(Ljava/lang/String;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method
