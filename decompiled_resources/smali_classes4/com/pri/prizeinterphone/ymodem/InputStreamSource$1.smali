.class synthetic Lcom/pri/prizeinterphone/ymodem/InputStreamSource$1;
.super Ljava/lang/Object;
.source "InputStreamSource.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/InputStreamSource;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1008
    name = null
.end annotation


# static fields
.field static final synthetic $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme:[I


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 19
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->values()[Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    move-result-object v0

    array-length v0, v0

    new-array v0, v0, [I

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource$1;->$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme:[I

    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->FILE:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    const/4 v2, 0x1

    aput v2, v0, v1
    :try_end_0
    .catch Ljava/lang/NoSuchFieldError; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :try_start_1
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource$1;->$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme:[I

    sget-object v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->ASSETS:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    const/4 v2, 0x2

    aput v2, v0, v1
    :try_end_1
    .catch Ljava/lang/NoSuchFieldError; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    :try_start_2
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource$1;->$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme:[I

    sget-object v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->UNKNOWN:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    const/4 v2, 0x3

    aput v2, v0, v1
    :try_end_2
    .catch Ljava/lang/NoSuchFieldError; {:try_start_2 .. :try_end_2} :catch_2

    :catch_2
    return-void
.end method
