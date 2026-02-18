.class public interface abstract Lcom/android/internal/telephony/euicc/EuiccConnector$RetainSubscriptionsCommandCallback;
.super Ljava/lang/Object;
.source "EuiccConnector.java"

# interfaces
.implements Lcom/android/internal/telephony/euicc/EuiccConnector$BaseEuiccCommandCallback;


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
    visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PACKAGE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccConnector;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "RetainSubscriptionsCommandCallback"
.end annotation


# virtual methods
.method public abstract onRetainSubscriptionsComplete(I)V
.end method
