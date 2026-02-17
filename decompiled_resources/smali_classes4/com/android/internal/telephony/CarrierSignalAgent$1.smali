.class Lcom/android/internal/telephony/CarrierSignalAgent$1;
.super Ljava/util/HashMap;
.source "CarrierSignalAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierSignalAgent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/util/HashMap<",
        "Ljava/lang/String;",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 2

    .line 113
    invoke-direct {p0}, Ljava/util/HashMap;-><init>()V

    const-string v0, "android.telephony.action.CARRIER_SIGNAL_PCO_VALUE"

    const-string v1, "com.android.internal.telephony.CARRIER_SIGNAL_PCO_VALUE"

    .line 114
    invoke-virtual {p0, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "android.telephony.action.CARRIER_SIGNAL_REDIRECTED"

    const-string v1, "com.android.internal.telephony.CARRIER_SIGNAL_REDIRECTED"

    .line 116
    invoke-virtual {p0, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "android.telephony.action.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED"

    const-string v1, "com.android.internal.telephony.CARRIER_SIGNAL_REQUEST_NETWORK_FAILED"

    .line 118
    invoke-virtual {p0, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "android.telephony.action.CARRIER_SIGNAL_RESET"

    const-string v1, "com.android.internal.telephony.CARRIER_SIGNAL_RESET"

    .line 120
    invoke-virtual {p0, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "android.telephony.action.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE"

    const-string v1, "com.android.internal.telephony.CARRIER_SIGNAL_DEFAULT_NETWORK_AVAILABLE"

    .line 122
    invoke-virtual {p0, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method
