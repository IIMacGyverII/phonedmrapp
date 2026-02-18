.class Lcom/android/internal/telephony/euicc/EuiccConnector$DownloadRequest;
.super Ljava/lang/Object;
.source "EuiccConnector.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccConnector;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "DownloadRequest"
.end annotation


# instance fields
.field mCallback:Lcom/android/internal/telephony/euicc/EuiccConnector$DownloadCommandCallback;

.field mForceDeactivateSim:Z

.field mPortIndex:I

.field mResolvedBundle:Landroid/os/Bundle;

.field mSubscription:Landroid/telephony/euicc/DownloadableSubscription;

.field mSwitchAfterDownload:Z


# direct methods
.method constructor <init>()V
    .locals 0

    .line 238
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
