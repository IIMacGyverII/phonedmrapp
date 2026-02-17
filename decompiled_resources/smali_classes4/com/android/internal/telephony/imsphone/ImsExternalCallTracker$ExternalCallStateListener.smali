.class public Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;
.super Lcom/android/ims/ImsExternalCallStateListener;
.source "ImsExternalCallTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "ExternalCallStateListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;


# direct methods
.method public static synthetic $r8$lambda$QgfVb4w4do9l7dhb4vONpqYpJHI(Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;->lambda$onImsExternalCallStateUpdate$0(Ljava/util/List;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 75
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;->this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;

    .line 76
    invoke-direct {p0, p2}, Lcom/android/ims/ImsExternalCallStateListener;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method

.method private synthetic lambda$onImsExternalCallStateUpdate$0(Ljava/util/List;)V
    .locals 0

    .line 83
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;->this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;->refreshExternalCallState(Ljava/util/List;)V

    return-void
.end method


# virtual methods
.method public onImsExternalCallStateUpdate(Ljava/util/List;Ljava/util/concurrent/Executor;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/ims/ImsExternalCallState;",
            ">;",
            "Ljava/util/concurrent/Executor;",
            ")V"
        }
    .end annotation

    .line 82
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$ExternalCallStateListener;Ljava/util/List;)V

    invoke-static {v0, p2}, Lcom/android/internal/telephony/util/TelephonyUtils;->runWithCleanCallingIdentity(Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V

    return-void
.end method
