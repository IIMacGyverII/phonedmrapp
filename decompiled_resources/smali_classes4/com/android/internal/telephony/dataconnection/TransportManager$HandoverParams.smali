.class public final Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;
.super Ljava/lang/Object;
.source "TransportManager.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/TransportManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "HandoverParams"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;
    }
.end annotation


# instance fields
.field public final apnType:I

.field public final callback:Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;

.field public final targetTransport:I


# direct methods
.method public constructor <init>(IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 132
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 133
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->apnType:I

    .line 134
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->targetTransport:I

    .line 135
    iput-object p3, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;->callback:Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;

    return-void
.end method
