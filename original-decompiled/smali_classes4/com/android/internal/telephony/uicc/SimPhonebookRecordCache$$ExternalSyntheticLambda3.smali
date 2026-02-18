.class public final synthetic Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/BiFunction;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Ljava/lang/Integer;

    check-cast p2, Lcom/android/internal/telephony/uicc/AdnRecord;

    invoke-static {p1, p2}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->$r8$lambda$vF-FsIKa3qlE5kH6r8Nrr9nz1x0(Ljava/lang/Integer;Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object p0

    return-object p0
.end method
