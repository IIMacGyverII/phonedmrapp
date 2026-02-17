.class public final synthetic Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

.field public final synthetic f$1:Z

.field public final synthetic f$2:I

.field public final synthetic f$3:Landroid/os/AsyncResult;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/imsphone/ImsPhone;ZILandroid/os/AsyncResult;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    iput-boolean p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$1:Z

    iput p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$2:I

    iput-object p4, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$3:Landroid/os/AsyncResult;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    iget-boolean v1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$1:Z

    iget v2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$2:I

    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$$ExternalSyntheticLambda6;->f$3:Landroid/os/AsyncResult;

    invoke-static {v0, v1, v2, p0}, Lcom/android/internal/telephony/imsphone/ImsPhone;->$r8$lambda$l7Ye8PT4bVYgub6j7PPuM3prvhg(Lcom/android/internal/telephony/imsphone/ImsPhone;ZILandroid/os/AsyncResult;)V

    return-void
.end method
