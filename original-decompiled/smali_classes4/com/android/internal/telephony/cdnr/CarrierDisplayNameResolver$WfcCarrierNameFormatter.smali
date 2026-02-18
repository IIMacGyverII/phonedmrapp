.class final Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;
.super Ljava/lang/Object;
.source "CarrierDisplayNameResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "WfcCarrierNameFormatter"
.end annotation


# instance fields
.field final mDataFormat:Ljava/lang/String;

.field final mVoiceFormat:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/os/PersistableBundle;[Ljava/lang/String;Z)V
    .locals 6

    .line 580
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string/jumbo v0, "wfc_spn_format_idx_int"

    .line 581
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v0

    const-string/jumbo v1, "wfc_data_spn_format_idx_int"

    .line 582
    invoke-virtual {p1, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v1

    const-string/jumbo v2, "wfc_flight_mode_spn_format_idx_int"

    .line 583
    invoke-virtual {p1, v2}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result p1

    const/4 v2, 0x0

    const-string v3, "CDNR"

    if-ltz v0, :cond_0

    .line 586
    array-length v4, p2

    if-lt v0, v4, :cond_1

    .line 587
    :cond_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateSpnDisplay: KEY_WFC_SPN_FORMAT_IDX_INT out of bounds: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v2

    :cond_1
    if-ltz v1, :cond_2

    .line 592
    array-length v4, p2

    if-lt v1, v4, :cond_3

    .line 593
    :cond_2
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateSpnDisplay: KEY_WFC_DATA_SPN_FORMAT_IDX_INT out of bounds: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v1, v2

    :cond_3
    if-ltz p1, :cond_4

    .line 598
    array-length v2, p2

    if-lt p1, v2, :cond_5

    :cond_4
    move p1, v0

    :cond_5
    if-eqz p3, :cond_6

    move v0, p1

    :cond_6
    const-string p1, ""

    const/4 p3, -0x1

    if-eq v0, p3, :cond_7

    .line 609
    aget-object v0, p2, v0

    goto :goto_0

    :cond_7
    move-object v0, p1

    :goto_0
    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->mVoiceFormat:Ljava/lang/String;

    if-eq v1, p3, :cond_8

    .line 610
    aget-object p1, p2, v1

    :cond_8
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->mDataFormat:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public formatDataName(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 629
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-object p1

    .line 630
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->mDataFormat:Ljava/lang/String;

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p0, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public formatVoiceName(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 619
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-object p1

    .line 620
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->mVoiceFormat:Ljava/lang/String;

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v1

    invoke-static {p0, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
