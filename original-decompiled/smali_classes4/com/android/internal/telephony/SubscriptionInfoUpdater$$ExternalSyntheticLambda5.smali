.class public final synthetic Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

.field public final synthetic f$1:Ljava/util/List;

.field public final synthetic f$2:Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/SubscriptionInfoUpdater;Ljava/util/List;Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iput-object p2, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$1:Ljava/util/List;

    iput-object p3, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$2:Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/SubscriptionInfoUpdater;

    iget-object v1, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$1:Ljava/util/List;

    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionInfoUpdater$$ExternalSyntheticLambda5;->f$2:Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->$r8$lambda$BQY_I7UtehepCDgMyAbgR4CqnaU(Lcom/android/internal/telephony/SubscriptionInfoUpdater;Ljava/util/List;Lcom/android/internal/telephony/SubscriptionInfoUpdater$UpdateEmbeddedSubsCallback;)V

    return-void
.end method
