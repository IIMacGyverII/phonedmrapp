.class Lcom/android/internal/telephony/data/KeepaliveTracker$KeepaliveRecord;
.super Ljava/lang/Object;
.source "KeepaliveTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/KeepaliveTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "KeepaliveRecord"
.end annotation


# instance fields
.field public currentStatus:I
    .annotation build Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
    .end annotation
.end field

.field public slotIndex:I


# direct methods
.method constructor <init>(II)V
    .locals 0
    .param p2    # I
        .annotation build Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
        .end annotation
    .end param

    .line 89
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 90
    iput p1, p0, Lcom/android/internal/telephony/data/KeepaliveTracker$KeepaliveRecord;->slotIndex:I

    .line 91
    iput p2, p0, Lcom/android/internal/telephony/data/KeepaliveTracker$KeepaliveRecord;->currentStatus:I

    return-void
.end method
