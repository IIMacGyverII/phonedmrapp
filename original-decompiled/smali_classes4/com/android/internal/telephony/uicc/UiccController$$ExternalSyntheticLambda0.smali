.class public final synthetic Lcom/android/internal/telephony/uicc/UiccController$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/IntPredicate;


# instance fields
.field public final synthetic f$0:Ljava/lang/String;

.field public final synthetic f$1:Lcom/android/internal/telephony/uicc/UiccSlot;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/String;Lcom/android/internal/telephony/uicc/UiccSlot;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccController$$ExternalSyntheticLambda0;->f$0:Ljava/lang/String;

    iput-object p2, p0, Lcom/android/internal/telephony/uicc/UiccController$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/uicc/UiccSlot;

    return-void
.end method


# virtual methods
.method public final test(I)Z
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccController$$ExternalSyntheticLambda0;->f$0:Ljava/lang/String;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccController$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/uicc/UiccSlot;

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/uicc/UiccController;->$r8$lambda$e9y9b_fSaKiVpI4k9zUuJzfhetE(Ljava/lang/String;Lcom/android/internal/telephony/uicc/UiccSlot;I)Z

    move-result p0

    return p0
.end method
