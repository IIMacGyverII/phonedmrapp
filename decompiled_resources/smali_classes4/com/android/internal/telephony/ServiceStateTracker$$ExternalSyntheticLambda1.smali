.class public final synthetic Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->$r8$lambda$ihEATESr5EHnRVF5kzfTdYbTI8c(Landroid/telephony/NetworkRegistrationInfo;)Z

    move-result p0

    return p0
.end method
