.class Lcom/android/internal/telephony/data/DataNetworkController$11;
.super Landroid/telephony/ims/ImsStateCallback;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetworkController;->lambda$registerImsStateCallback$19(ILjava/lang/Integer;)Landroid/telephony/ims/ImsStateCallback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetworkController;

.field final synthetic val$imsFeature:Ljava/lang/Integer;

.field final synthetic val$subId:I


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;ILjava/lang/Integer;)V
    .locals 0

    .line 2184
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iput p2, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$subId:I

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$imsFeature:Ljava/lang/Integer;

    invoke-direct {p0}, Landroid/telephony/ims/ImsStateCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onAvailable()V
    .locals 5

    .line 2193
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$fgetmImsFeaturePackageName(Lcom/android/internal/telephony/data/DataNetworkController;)Landroid/util/SparseArray;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$imsFeature:Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {}, Lcom/android/internal/telephony/ims/ImsResolver;->getInstance()Lcom/android/internal/telephony/ims/ImsResolver;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iget-object v3, v3, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2194
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$imsFeature:Ljava/lang/Integer;

    .line 2195
    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 2194
    invoke-virtual {v2, v3, v4}, Lcom/android/internal/telephony/ims/ImsResolver;->getConfiguredImsServicePackageName(II)Ljava/lang/String;

    move-result-object v2

    .line 2193
    invoke-virtual {v0, v1, v2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2197
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$subId:I

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$imsFeature:Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$mregisterImsFeatureRegistrationState(Lcom/android/internal/telephony/data/DataNetworkController;II)V

    return-void
.end method

.method public onError()V
    .locals 0

    return-void
.end method

.method public onUnavailable(I)V
    .locals 1

    .line 2188
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$subId:I

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$11;->val$imsFeature:Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-static {p1, v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$munregisterImsFeatureRegistrationState(Lcom/android/internal/telephony/data/DataNetworkController;II)V

    return-void
.end method
