.class public final synthetic Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

.field public final synthetic f$1:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;->f$1:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$$ExternalSyntheticLambda1;->f$1:I

    invoke-static {v0, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->$r8$lambda$m6uSxr-dpLvazQSZ6ECF72L3BzU(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;I)V

    return-void
.end method
