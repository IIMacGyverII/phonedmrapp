.class Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;
.super Lcom/android/ims/ImsConfigListener$Stub;
.source "MmTelFeatureCompatAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "ConfigListener"
.end annotation


# instance fields
.field private final mCapability:I

.field private final mLatch:Ljava/util/concurrent/CountDownLatch;

.field private final mTech:I


# direct methods
.method public constructor <init>(IILjava/util/concurrent/CountDownLatch;)V
    .locals 0

    .line 93
    invoke-direct {p0}, Lcom/android/ims/ImsConfigListener$Stub;-><init>()V

    .line 94
    iput p1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mCapability:I

    .line 95
    iput p2, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mTech:I

    .line 96
    iput-object p3, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mLatch:Ljava/util/concurrent/CountDownLatch;

    return-void
.end method


# virtual methods
.method public getFeatureValueReceived(I)V
    .locals 0

    return-void
.end method

.method public onGetFeatureResponse(IIII)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 102
    iget p4, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mCapability:I

    if-ne p1, p4, :cond_0

    iget p4, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mTech:I

    if-ne p2, p4, :cond_0

    .line 103
    iget-object p1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 104
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->getFeatureValueReceived(I)V

    goto :goto_0

    .line 106
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "onGetFeatureResponse: response different than requested: feature="

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " and network="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MmTelFeatureCompat"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public onGetVideoQuality(II)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public onSetFeatureResponse(IIII)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 114
    iget p4, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mCapability:I

    if-ne p1, p4, :cond_0

    iget p4, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mTech:I

    if-ne p2, p4, :cond_0

    .line 115
    iget-object p1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->mLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p1}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    .line 116
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;->setFeatureValueReceived(I)V

    goto :goto_0

    .line 118
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "onSetFeatureResponse: response different than requested: feature="

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " and network="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MmTelFeatureCompat"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public onSetVideoQuality(I)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public setFeatureValueReceived(I)V
    .locals 0

    return-void
.end method
