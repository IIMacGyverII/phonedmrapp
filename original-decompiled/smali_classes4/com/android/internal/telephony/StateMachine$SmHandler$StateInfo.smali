.class Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;
.super Ljava/lang/Object;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/StateMachine$SmHandler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "StateInfo"
.end annotation


# instance fields
.field active:Z

.field parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

.field state:Lcom/android/internal/telephony/State;

.field final synthetic this$0:Lcom/android/internal/telephony/StateMachine$SmHandler;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    .line 727
    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->this$0:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 2

    .line 742
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {v1}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ",active="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->active:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",parent="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 743
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->parentStateInfo:Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;

    if-nez p0, :cond_0

    const-string p0, "null"

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$StateInfo;->state:Lcom/android/internal/telephony/State;

    invoke-virtual {p0}, Lcom/android/internal/telephony/State;->getName()Ljava/lang/String;

    move-result-object p0

    :goto_0
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
