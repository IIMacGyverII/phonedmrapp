.class public final synthetic Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

.field public final synthetic f$1:Ljava/lang/Runnable;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/SubscriptionInfoUpdater;Ljava/lang/Runnable;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iput-object p2, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda2;->f$1:Ljava/lang/Runnable;

    return-void
.end method


# virtual methods
.method public final run(Z)V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda2;->f$1:Ljava/lang/Runnable;

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->$r8$lambda$IxNVjurbv1JUDyNk7H4L_pvGQ2g(Lcom/android/internal/telephony/SubscriptionInfoUpdater;Ljava/lang/Runnable;Z)V

    return-void
.end method
