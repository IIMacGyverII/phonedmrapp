.class public final synthetic Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;

.field public final synthetic f$1:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

.field public final synthetic f$2:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$1:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    iput p3, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$2:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;

    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$1:Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;

    iget p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14$$ExternalSyntheticLambda1;->f$2:I

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;->$r8$lambda$Av1ObqIr9QkcyfV2pzduOvydkvA(Lcom/android/internal/telephony/euicc/EuiccConnector$ConnectedState$14;Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;I)V

    return-void
.end method
