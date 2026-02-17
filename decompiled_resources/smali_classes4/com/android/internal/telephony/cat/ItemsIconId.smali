.class public Lcom/android/internal/telephony/cat/ItemsIconId;
.super Lcom/android/internal/telephony/cat/ValueObject;
.source "ItemsIconId.java"


# instance fields
.field public recordNumbers:[I

.field public selfExplanatory:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Lcom/android/internal/telephony/cat/ValueObject;-><init>()V

    return-void
.end method


# virtual methods
.method getTag()Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .locals 0

    .line 25
    sget-object p0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ITEM_ICON_ID_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    return-object p0
.end method
