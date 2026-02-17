.class public final synthetic Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/TelephonyNetworkRequest;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    check-cast p1, Landroid/telephony/data/DataProfile;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method
