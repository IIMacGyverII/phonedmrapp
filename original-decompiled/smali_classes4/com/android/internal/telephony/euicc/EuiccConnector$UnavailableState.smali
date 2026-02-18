.class Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;
.super Lcom/android/internal/telephony/State;
.source "EuiccConnector.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccConnector;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "UnavailableState"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector;)V
    .locals 0

    .line 562
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-direct {p0}, Lcom/android/internal/telephony/State;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector;Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;-><init>(Lcom/android/internal/telephony/euicc/EuiccConnector;)V

    return-void
.end method


# virtual methods
.method public processMessage(Landroid/os/Message;)Z
    .locals 2

    .line 565
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_2

    .line 566
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-static {p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$mfindBestComponent(Lcom/android/internal/telephony/euicc/EuiccConnector;)Landroid/content/pm/ServiceInfo;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$fputmSelectedComponent(Lcom/android/internal/telephony/euicc/EuiccConnector;Landroid/content/pm/ServiceInfo;)V

    .line 567
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-static {p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$fgetmSelectedComponent(Lcom/android/internal/telephony/euicc/EuiccConnector;)Landroid/content/pm/ServiceInfo;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 568
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    iget-object v0, p1, Lcom/android/internal/telephony/euicc/EuiccConnector;->mAvailableState:Lcom/android/internal/telephony/euicc/EuiccConnector$AvailableState;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    .line 569
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$mupdateSubscriptionInfoListForAllAccessibleEuiccs(Lcom/android/internal/telephony/euicc/EuiccConnector;)V

    goto :goto_0

    .line 570
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector;->mUnavailableState:Lcom/android/internal/telephony/euicc/EuiccConnector$UnavailableState;

    if-eq p1, v0, :cond_1

    .line 571
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    :cond_1
    :goto_0
    return v1

    .line 574
    :cond_2
    invoke-static {v0}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$smisEuiccCommand(I)Z

    move-result p0

    if-eqz p0, :cond_3

    .line 575
    invoke-static {p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$smgetCallback(Landroid/os/Message;)Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    move-result-object p0

    .line 576
    invoke-interface {p0}, Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;->onEuiccServiceUnavailable()V

    return v1

    :cond_3
    const/4 p0, 0x0

    return p0
.end method
