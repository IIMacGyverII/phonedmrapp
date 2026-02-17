.class public final synthetic Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$$ExternalSyntheticLambda3;->f$0:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$$ExternalSyntheticLambda3;->f$0:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;

    check-cast p1, Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;->$r8$lambda$F1zCNE1tdnQUGzwxKXNvkg0ZsCw(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;Lcom/android/internal/telephony/imsphone/ImsPhoneConnection;)V

    return-void
.end method
