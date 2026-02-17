.class public final synthetic Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Function;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    invoke-static {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->$r8$lambda$s7YDMSdLxrT99ZWSGr1_ypao1QM(Landroid/telephony/NetworkRegistrationInfo;)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method
