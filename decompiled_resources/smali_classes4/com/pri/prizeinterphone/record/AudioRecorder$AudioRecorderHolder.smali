.class Lcom/pri/prizeinterphone/record/AudioRecorder$AudioRecorderHolder;
.super Ljava/lang/Object;
.source "AudioRecorder.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/record/AudioRecorder;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "AudioRecorderHolder"
.end annotation


# static fields
.field private static instance:Lcom/pri/prizeinterphone/record/AudioRecorder;


# direct methods
.method static bridge synthetic -$$Nest$sfgetinstance()Lcom/pri/prizeinterphone/record/AudioRecorder;
    .locals 1

    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$AudioRecorderHolder;->instance:Lcom/pri/prizeinterphone/record/AudioRecorder;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 57
    new-instance v0, Lcom/pri/prizeinterphone/record/AudioRecorder;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/record/AudioRecorder;-><init>(Lcom/pri/prizeinterphone/record/AudioRecorder-IA;)V

    sput-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$AudioRecorderHolder;->instance:Lcom/pri/prizeinterphone/record/AudioRecorder;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
