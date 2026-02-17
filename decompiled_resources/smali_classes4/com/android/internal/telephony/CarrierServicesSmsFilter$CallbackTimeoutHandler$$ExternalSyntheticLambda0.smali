.class public final synthetic Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler$$ExternalSyntheticLambda0;
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

    check-cast p1, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;

    invoke-static {p1}, Lcom/android/internal/telephony/CarrierServicesSmsFilter$CallbackTimeoutHandler;->$r8$lambda$T-oAK7r9a6q8d-nHpovn5Gwv1wQ(Lcom/android/internal/telephony/CarrierServicesSmsFilter$CarrierSmsFilterCallback;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
