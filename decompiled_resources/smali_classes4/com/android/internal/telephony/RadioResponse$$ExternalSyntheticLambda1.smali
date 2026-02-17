.class public final synthetic Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/RadioResponse;

.field public final synthetic f$1:I

.field public final synthetic f$2:Landroid/os/Message;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/RadioResponse;ILandroid/os/Message;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/RadioResponse;

    iput p2, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$1:I

    iput-object p3, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$2:Landroid/os/Message;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/RadioResponse;

    iget v1, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$1:I

    iget-object p0, p0, Lcom/android/internal/telephony/RadioResponse$$ExternalSyntheticLambda1;->f$2:Landroid/os/Message;

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/RadioResponse;->$r8$lambda$FBul5me2fB3ttmxxl40BIc-2Q0o(Lcom/android/internal/telephony/RadioResponse;ILandroid/os/Message;)V

    return-void
.end method
