.class Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;
.super Ljava/lang/Object;
.source "DcNetworkAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "KeepaliveRecord"
.end annotation


# instance fields
.field public currentStatus:I

.field public slotId:I

.field final synthetic this$1:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;II)V
    .locals 0

    .line 502
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->this$1:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 503
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    .line 504
    iput p3, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    return-void
.end method
