.class public Lcom/pri/prizeinterphone/config/data/ParseConfig;
.super Ljava/lang/Object;
.source "ParseConfig.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;
    }
.end annotation


# instance fields
.field private insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

.field private isError:Z


# direct methods
.method private constructor <init>()V
    .locals 1

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 4
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError:Z

    const/4 v0, 0x0

    .line 5
    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)V
    .locals 1

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 4
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError:Z

    const/4 v0, 0x0

    .line 5
    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    .line 12
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->-$$Nest$fgetisError(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError:Z

    .line 14
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->-$$Nest$fgetinsertConfig(Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;)Lcom/pri/prizeinterphone/config/data/InsertConfig;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-void
.end method


# virtual methods
.method public getInsertConfig()Lcom/pri/prizeinterphone/config/data/InsertConfig;
    .locals 0

    .line 26
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-object p0
.end method

.method public isError()Z
    .locals 0

    .line 18
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError:Z

    return p0
.end method

.method public setError(Z)V
    .locals 0

    .line 22
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError:Z

    return-void
.end method

.method public setInsertConfig(Lcom/pri/prizeinterphone/config/data/InsertConfig;)V
    .locals 0

    .line 30
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/ParseConfig;->insertConfig:Lcom/pri/prizeinterphone/config/data/InsertConfig;

    return-void
.end method
