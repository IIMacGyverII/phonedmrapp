.class public final enum Lcom/pri/prizeinterphone/record/AudioRecorder$Status;
.super Ljava/lang/Enum;
.source "AudioRecorder.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/record/AudioRecorder;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "Status"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/pri/prizeinterphone/record/AudioRecorder$Status;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

.field public static final enum STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

.field public static final enum STATUS_PAUSE:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

.field public static final enum STATUS_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

.field public static final enum STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

.field public static final enum STATUS_STOP:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;


# direct methods
.method static constructor <clinit>()V
    .locals 11

    .line 314
    new-instance v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const-string v1, "STATUS_NO_READY"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 316
    new-instance v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const-string v3, "STATUS_READY"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 318
    new-instance v3, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const-string v5, "STATUS_START"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 320
    new-instance v5, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const-string v7, "STATUS_PAUSE"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_PAUSE:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 322
    new-instance v7, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const-string v9, "STATUS_STOP"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_STOP:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    const/4 v9, 0x5

    new-array v9, v9, [Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    aput-object v0, v9, v2

    aput-object v1, v9, v4

    aput-object v3, v9, v6

    aput-object v5, v9, v8

    aput-object v7, v9, v10

    .line 312
    sput-object v9, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->$VALUES:[Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 312
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/pri/prizeinterphone/record/AudioRecorder$Status;
    .locals 1

    .line 312
    const-class v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-object p0
.end method

.method public static values()[Lcom/pri/prizeinterphone/record/AudioRecorder$Status;
    .locals 1

    .line 312
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->$VALUES:[Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    invoke-virtual {v0}, [Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-object v0
.end method
