.class public final synthetic Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda0;
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

    check-cast p1, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    invoke-static {p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->$r8$lambda$-oMw9NAorlSWhtdad_xQOv577y4(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object p0

    return-object p0
.end method
