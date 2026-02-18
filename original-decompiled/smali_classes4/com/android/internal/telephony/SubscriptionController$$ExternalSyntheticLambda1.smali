.class public final synthetic Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/ToIntFunction;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final applyAsInt(Ljava/lang/Object;)I
    .locals 0

    check-cast p1, Landroid/telephony/SubscriptionInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/SubscriptionController;->$r8$lambda$_K74DbWkG1zIbjcYl6-bYrVQFCo(Landroid/telephony/SubscriptionInfo;)I

    move-result p0

    return p0
.end method
