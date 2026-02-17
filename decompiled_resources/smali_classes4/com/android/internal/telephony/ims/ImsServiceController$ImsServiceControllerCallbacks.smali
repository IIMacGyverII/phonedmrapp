.class public interface abstract Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;
.super Ljava/lang/Object;
.source "ImsServiceController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/ImsServiceController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "ImsServiceControllerCallbacks"
.end annotation


# virtual methods
.method public abstract imsServiceBindPermanentError(Landroid/content/ComponentName;)V
.end method

.method public abstract imsServiceFeatureCreated(IILcom/android/internal/telephony/ims/ImsServiceController;)V
.end method

.method public abstract imsServiceFeatureRemoved(IILcom/android/internal/telephony/ims/ImsServiceController;)V
.end method

.method public abstract imsServiceFeaturesChanged(Landroid/telephony/ims/stub/ImsFeatureConfiguration;Lcom/android/internal/telephony/ims/ImsServiceController;)V
.end method
