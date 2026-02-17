.class Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;
.super Ljava/lang/Object;
.source "CarrierServiceBindHelper.java"

# interfaces
.implements Landroid/telephony/TelephonyManager$CarrierPrivilegesCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierServiceBindHelper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "CarrierServiceChangeCallback"
.end annotation


# instance fields
.field final mPhoneId:I

.field final synthetic this$0:Lcom/android/internal/telephony/CarrierServiceBindHelper;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/CarrierServiceBindHelper;I)V
    .locals 0

    .line 102
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->this$0:Lcom/android/internal/telephony/CarrierServiceBindHelper;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 103
    iput p2, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->mPhoneId:I

    return-void
.end method


# virtual methods
.method public onCarrierPrivilegesChanged(Ljava/util/Set;Ljava/util/Set;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method public onCarrierServiceChanged(Ljava/lang/String;I)V
    .locals 3

    .line 115
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->this$0:Lcom/android/internal/telephony/CarrierServiceBindHelper;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onCarrierServiceChanged, carrierServicePackageName="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", carrierServiceUid="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", mPhoneId="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->mPhoneId:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/internal/telephony/CarrierServiceBindHelper;->-$$Nest$mlogdWithLocalLog(Lcom/android/internal/telephony/CarrierServiceBindHelper;Ljava/lang/String;)V

    .line 118
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->this$0:Lcom/android/internal/telephony/CarrierServiceBindHelper;

    iget-object p1, p1, Lcom/android/internal/telephony/CarrierServiceBindHelper;->mHandler:Landroid/os/Handler;

    iget p0, p0, Lcom/android/internal/telephony/CarrierServiceBindHelper$CarrierServiceChangeCallback;->mPhoneId:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 p2, 0x0

    invoke-virtual {p1, p2, p0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method
