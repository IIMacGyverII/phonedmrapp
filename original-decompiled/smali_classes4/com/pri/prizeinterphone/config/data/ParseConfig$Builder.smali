.class public final Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;
.super Ljava/lang/Object;
.source "ParseConfig.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/config/data/ParseConfig;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation


# instance fields
.field private insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

.field private isError:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetinsertConfig(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)Lcom/pri/prizeinterphone/config/data/InsertConfig;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetisError(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->isError:Z

    return p0
.end method

.method public constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public build()Lcom/pri/prizeinterphone/config/data/ParseConfig;
    .locals 1

    .line 53
    new-instance v0, Lcom/pri/prizeinterphone/config/data/ParseConfig;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/config/data/ParseConfig;-><init>(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)V

    return-object v0
.end method

.method public withInsertConfig(Lcom/pri/prizeinterphone/config/data/InsertConfig;)Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;
    .locals 0

    .line 47
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-object p0
.end method

.method public withIsError(Z)Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;
    .locals 0

    .line 42
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->isError:Z

    return-object p0
.end method
