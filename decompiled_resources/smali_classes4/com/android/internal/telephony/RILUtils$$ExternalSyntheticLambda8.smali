.class public final synthetic Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda8;
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

    check-cast p1, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;

    invoke-static {p1}, Lcom/android/internal/telephony/RILUtils;->$r8$lambda$gBWeFKs6ffSMrG_kLr7al9gL2fo(Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;)Landroid/telephony/data/RouteSelectionDescriptor;

    move-result-object p0

    return-object p0
.end method
