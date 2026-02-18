.class Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;
.super Landroid/service/euicc/IOtaStatusChangedCallback$Stub;
.source "EuiccConnector.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;->processMessage(Landroid/os/Message;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;

.field final synthetic val$callback:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;


# direct methods
.method public static synthetic $r8$lambda$Av1ObqIr9QkcyfV2pzduOvydkvA(Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->lambda$onOtaStatusChanged$1(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$PUzUIxrcvd4sRK2rV-BJXnlDTDU(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->lambda$onOtaStatusChanged$0(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;)V
    .locals 0

    .line 943
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->this$1:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->val$callback:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    invoke-direct {p0}, Landroid/service/euicc/IOtaStatusChangedCallback$Stub;-><init>()V

    return-void
.end method

.method private static synthetic lambda$onOtaStatusChanged$0(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V
    .locals 0

    .line 949
    check-cast p0, Lcom/android/internal/telephony/euicc/EuiccConnector$OtaStatusChangedCallback;

    .line 950
    invoke-interface {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$OtaStatusChangedCallback;->onOtaStatusChanged(I)V

    return-void
.end method

.method private synthetic lambda$onOtaStatusChanged$1(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V
    .locals 1

    .line 954
    move-object v0, p1

    check-cast v0, Lcom/android/internal/telephony/euicc/EuiccConnector$OtaStatusChangedCallback;

    .line 955
    invoke-interface {v0, p2}, Lcom/android/internal/telephony/euicc/EuiccConnector$OtaStatusChangedCallback;->onOtaStatusChanged(I)V

    .line 956
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->this$1:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->-$$Nest$monCommandEnd(Lcom/android/internal/telephony/euicc/EuiccConnector;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;)V

    return-void
.end method


# virtual methods
.method public onOtaStatusChanged(I)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const/4 v0, 0x6

    const/4 v1, 0x1

    if-ne p1, v1, :cond_0

    .line 948
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->this$1:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;

    iget-object v1, v1, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->val$callback:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    new-instance v2, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V

    invoke-virtual {v1, v0, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    goto :goto_0

    .line 953
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->this$1:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;

    iget-object v1, v1, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->val$callback:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;

    invoke-direct {v3, p0, v2, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V

    invoke-virtual {v1, v0, v3}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method
