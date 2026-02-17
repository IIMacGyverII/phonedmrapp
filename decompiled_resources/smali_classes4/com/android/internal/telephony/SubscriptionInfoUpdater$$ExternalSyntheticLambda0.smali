.class public final synthetic Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

.field public final synthetic f$1:I

.field public final synthetic f$2:Ljava/lang/String;

.field public final synthetic f$3:Landroid/os/PersistableBundle;

.field public final synthetic f$4:Landroid/os/Message;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/SubscriptionInfoUpdater;ILjava/lang/String;Landroid/os/PersistableBundle;Landroid/os/Message;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iput p2, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$1:I

    iput-object p3, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$2:Ljava/lang/String;

    iput-object p4, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$3:Landroid/os/PersistableBundle;

    iput-object p5, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$4:Landroid/os/Message;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iget v1, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$1:I

    iget-object v2, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$2:Ljava/lang/String;

    iget-object v3, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$3:Landroid/os/PersistableBundle;

    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda0;->f$4:Landroid/os/Message;

    invoke-static {v0, v1, v2, v3, p0}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->$r8$lambda$V_FxNZ6EUzV7_EqJK_uFOjkdAkY(Lcom/android/internal/telephony/SubscriptionInfoUpdater;ILjava/lang/String;Landroid/os/PersistableBundle;Landroid/os/Message;)V

    return-void
.end method
