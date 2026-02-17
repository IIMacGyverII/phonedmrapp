.class public final synthetic Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda6;->f$0:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$$ExternalSyntheticLambda6;->f$0:Ljava/lang/String;

    check-cast p1, Landroid/telephony/SubscriptionInfo;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->$r8$lambda$JZTKUvkYxZ-9hTbRgjJirAnSGn4(Ljava/lang/String;Landroid/telephony/SubscriptionInfo;)Z

    move-result p0

    return p0
.end method
