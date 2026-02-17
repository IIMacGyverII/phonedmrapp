.class public Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;
.super Ljava/lang/Object;
.source "DataConnection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "UpdateLinkPropertyResult"
.end annotation


# instance fields
.field public newLp:Landroid/net/LinkProperties;

.field public oldLp:Landroid/net/LinkProperties;

.field public setupResult:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;


# direct methods
.method public constructor <init>(Landroid/net/LinkProperties;)V
    .locals 1

    .line 560
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 557
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->setupResult:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 561
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->oldLp:Landroid/net/LinkProperties;

    .line 562
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    return-void
.end method
