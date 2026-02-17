.class public final synthetic Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/SubscriptionController;

.field public final synthetic f$1:Landroid/os/ParcelUuid;

.field public final synthetic f$2:Ljava/lang/String;

.field public final synthetic f$3:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/SubscriptionController;Landroid/os/ParcelUuid;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/SubscriptionController;

    iput-object p2, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$1:Landroid/os/ParcelUuid;

    iput-object p3, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$2:Ljava/lang/String;

    iput-object p4, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$3:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v1, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$1:Landroid/os/ParcelUuid;

    iget-object v2, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$2:Ljava/lang/String;

    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda4;->f$3:Ljava/lang/String;

    check-cast p1, Landroid/telephony/SubscriptionInfo;

    invoke-static {v0, v1, v2, p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->$r8$lambda$0hAFAhkNKSxW-p6CGt1QO3XTQ2o(Lcom/android/internal/telephony/SubscriptionController;Landroid/os/ParcelUuid;Ljava/lang/String;Ljava/lang/String;Landroid/telephony/SubscriptionInfo;)Z

    move-result p0

    return p0
.end method
