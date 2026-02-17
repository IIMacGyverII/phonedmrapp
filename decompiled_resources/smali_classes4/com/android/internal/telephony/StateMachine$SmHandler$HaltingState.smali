.class Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;
.super Lcom/android/internal/telephony/State;
.source "StateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/StateMachine$SmHandler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "HaltingState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/StateMachine$SmHandler;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/StateMachine$SmHandler;)V
    .locals 0

    .line 770
    iput-object p1, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;->this$0:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/StateMachine$SmHandler;Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;-><init>(Lcom/android/internal/telephony/StateMachine$SmHandler;)V

    return-void
.end method


# virtual methods
.method public processMessage(Landroid/os/Message;)Z
    .locals 0

    .line 773
    iget-object p0, p0, Lcom/android/internal/telephony/StateMachine$SmHandler$HaltingState;->this$0:Lcom/android/internal/telephony/StateMachine$SmHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/StateMachine$SmHandler;->-$$Nest$fgetmSm(Lcom/android/internal/telephony/StateMachine$SmHandler;)Lcom/android/internal/telephony/StateMachine;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->haltedProcessMessage(Landroid/os/Message;)V

    const/4 p0, 0x1

    return p0
.end method
