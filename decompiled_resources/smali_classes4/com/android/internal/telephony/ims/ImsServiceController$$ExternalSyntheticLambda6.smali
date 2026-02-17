.class public final synthetic Lcom/android/internal/telephony/ims/ImsServiceController$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:I


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/android/internal/telephony/ims/ImsServiceController$$ExternalSyntheticLambda6;->f$0:I

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/ims/ImsServiceController$$ExternalSyntheticLambda6;->f$0:I

    check-cast p1, Landroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/ims/ImsServiceController;->$r8$lambda$8bAk-TWEhmttqXdd0QYdh-bc_Tw(ILandroid/telephony/ims/stub/ImsFeatureConfiguration$FeatureSlotPair;)Z

    move-result p0

    return p0
.end method
