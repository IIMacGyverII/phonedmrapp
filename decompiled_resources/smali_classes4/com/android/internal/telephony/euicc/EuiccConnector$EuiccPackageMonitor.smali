.class Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;
.super Lcom/android/internal/telephony/PackageChangeReceiver;
.source "EuiccConnector.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccConnector;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "EuiccPackageMonitor"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector;)V
    .locals 0

    .line 1189
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-direct {p0}, Lcom/android/internal/telephony/PackageChangeReceiver;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/euicc/EuiccConnector;Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;-><init>(Lcom/android/internal/telephony/euicc/EuiccConnector;)V

    return-void
.end method

.method private sendPackageChange(Ljava/lang/String;Z)V
    .locals 0

    .line 1220
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->this$0:Lcom/android/internal/telephony/euicc/EuiccConnector;

    if-eqz p2, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    const/4 p2, 0x1

    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return-void
.end method


# virtual methods
.method public onHandleForceStop([Ljava/lang/String;Z)V
    .locals 3

    if-eqz p2, :cond_0

    .line 1213
    array-length p2, p1

    const/4 v0, 0x0

    :goto_0
    if-ge v0, p2, :cond_0

    aget-object v1, p1, v0

    const/4 v2, 0x1

    .line 1214
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->sendPackageChange(Ljava/lang/String;Z)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method public onPackageAdded(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x1

    .line 1192
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->sendPackageChange(Ljava/lang/String;Z)V

    return-void
.end method

.method public onPackageModified(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    .line 1207
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->sendPackageChange(Ljava/lang/String;Z)V

    return-void
.end method

.method public onPackageRemoved(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x1

    .line 1197
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->sendPackageChange(Ljava/lang/String;Z)V

    return-void
.end method

.method public onPackageUpdateFinished(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x1

    .line 1202
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector$EuiccPackageMonitor;->sendPackageChange(Ljava/lang/String;Z)V

    return-void
.end method
