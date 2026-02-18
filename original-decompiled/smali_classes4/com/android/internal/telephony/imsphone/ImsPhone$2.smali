.class Lcom/android/internal/telephony/imsphone/ImsPhone$2;
.super Lcom/android/ims/ImsEcbmStateListener;
.source "ImsPhone.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;


# direct methods
.method public static synthetic $r8$lambda$uK7xVXkmlOyl6UzUyPES8wBWxmM(Lcom/android/internal/telephony/imsphone/ImsPhone$2;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->lambda$onECBMExited$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$wqJnOv_mEk7ZLRHhobmnJFzkRoE(Lcom/android/internal/telephony/imsphone/ImsPhone$2;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->lambda$onECBMEntered$0()V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/imsphone/ImsPhone;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 1994
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    invoke-direct {p0, p2}, Lcom/android/ims/ImsEcbmStateListener;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method

.method private synthetic lambda$onECBMEntered$0()V
    .locals 0

    .line 2000
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    invoke-static {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone;->-$$Nest$mhandleEnterEmergencyCallbackMode(Lcom/android/internal/telephony/imsphone/ImsPhone;)V

    return-void
.end method

.method private synthetic lambda$onECBMExited$1()V
    .locals 0

    .line 2009
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone;->handleExitEmergencyCallbackMode()V

    return-void
.end method


# virtual methods
.method public onECBMEntered(Ljava/util/concurrent/Executor;)V
    .locals 2

    .line 1997
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    const-string v1, "onECBMEntered"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/imsphone/ImsPhone;->logd(Ljava/lang/String;)V

    .line 1999
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhone$2$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/imsphone/ImsPhone$2$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone$2;)V

    invoke-static {v0, p1}, Lcom/android/internal/telephony/util/TelephonyUtils;->runWithCleanCallingIdentity(Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V

    return-void
.end method

.method public onECBMExited(Ljava/util/concurrent/Executor;)V
    .locals 2

    .line 2007
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$2;->this$0:Lcom/android/internal/telephony/imsphone/ImsPhone;

    const-string v1, "onECBMExited"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/imsphone/ImsPhone;->logd(Ljava/lang/String;)V

    .line 2008
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhone$2$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/imsphone/ImsPhone$2$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone$2;)V

    invoke-static {v0, p1}, Lcom/android/internal/telephony/util/TelephonyUtils;->runWithCleanCallingIdentity(Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V

    return-void
.end method
