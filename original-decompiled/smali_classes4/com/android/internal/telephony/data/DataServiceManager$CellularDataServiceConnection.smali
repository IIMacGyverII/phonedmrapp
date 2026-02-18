.class final Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;
.super Ljava/lang/Object;
.source "DataServiceManager.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataServiceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "CellularDataServiceConnection"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataServiceManager;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/data/DataServiceManager;)V
    .locals 0

    .line 224
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/data/DataServiceManager;Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;-><init>(Lcom/android/internal/telephony/data/DataServiceManager;)V

    return-void
.end method


# virtual methods
.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .locals 3

    .line 227
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onServiceConnected: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 228
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p2}, Landroid/telephony/data/IDataService$Stub;->asInterface(Landroid/os/IBinder;)Landroid/telephony/data/IDataService;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmIDataService(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/telephony/data/IDataService;)V

    .line 229
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceManagerDeathRecipient;

    const/4 v1, 0x0

    invoke-direct {v0, p1, v1}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceManagerDeathRecipient;-><init>(Lcom/android/internal/telephony/data/DataServiceManager;Lcom/android/internal/telephony/data/DataServiceManager$DataServiceManagerDeathRecipient-IA;)V

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmDeathRecipient(Lcom/android/internal/telephony/data/DataServiceManager;Lcom/android/internal/telephony/data/DataServiceManager$DataServiceManagerDeathRecipient;)V

    .line 230
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v0, 0x1

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmBound(Lcom/android/internal/telephony/data/DataServiceManager;Z)V

    .line 231
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->getDataServicePackageName()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmLastBoundPackageName(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 232
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v0, 0x2

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 235
    :try_start_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmDeathRecipient(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/data/DataServiceManager$DataServiceManagerDeathRecipient;

    move-result-object p1

    const/4 v0, 0x0

    invoke-interface {p2, p1, v0}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V

    .line 236
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmIDataService(Lcom/android/internal/telephony/data/DataServiceManager;)Landroid/telephony/data/IDataService;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p2}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/Phone;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p2

    invoke-interface {p1, p2}, Landroid/telephony/data/IDataService;->createDataServiceProvider(I)V

    .line 237
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmIDataService(Lcom/android/internal/telephony/data/DataServiceManager;)Landroid/telephony/data/IDataService;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p2}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/Phone;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p2

    new-instance v0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string v2, "dataCallListChanged"

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;-><init>(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    invoke-interface {p1, p2, v0}, Landroid/telephony/data/IDataService;->registerForDataCallListChanged(ILandroid/telephony/data/IDataServiceCallback;)V

    .line 239
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmIDataService(Lcom/android/internal/telephony/data/DataServiceManager;)Landroid/telephony/data/IDataService;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p2}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/Phone;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p2

    new-instance v0, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string/jumbo v2, "unthrottleApn"

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/DataServiceManager$DataServiceCallbackWrapper;-><init>(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    invoke-interface {p1, p2, v0}, Landroid/telephony/data/IDataService;->registerForUnthrottleApn(ILandroid/telephony/data/IDataServiceCallback;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 245
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmServiceBindingChangedRegistrants(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p0

    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void

    :catch_0
    move-exception p1

    .line 242
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Remote exception. "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mloge(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    return-void
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .locals 2

    .line 249
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const-string v0, "onServiceDisconnected"

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$mlog(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    .line 250
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v0, 0x2

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 251
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v0, 0x0

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmIDataService(Lcom/android/internal/telephony/data/DataServiceManager;Landroid/telephony/data/IDataService;)V

    .line 252
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x0

    invoke-static {p1, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmBound(Lcom/android/internal/telephony/data/DataServiceManager;Z)V

    .line 253
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fgetmServiceBindingChangedRegistrants(Lcom/android/internal/telephony/data/DataServiceManager;)Lcom/android/internal/telephony/RegistrantList;

    move-result-object p1

    sget-object v1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    .line 254
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataServiceManager$CellularDataServiceConnection;->this$0:Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->-$$Nest$fputmTargetBindingPackageName(Lcom/android/internal/telephony/data/DataServiceManager;Ljava/lang/String;)V

    return-void
.end method
