.class public Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;
.super Lcom/android/internal/telephony/ims/ImsServiceController;
.source "ImsServiceControllerCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ImsSCCompat"


# instance fields
.field private final mConfigCompatAdapters:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/ims/ImsConfigCompatAdapter;",
            ">;"
        }
    .end annotation
.end field

.field private final mMmTelCompatAdapters:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;",
            ">;"
        }
    .end annotation
.end field

.field private final mMmTelFeatureFactory:Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;

.field private final mRegCompatAdapters:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;",
            ">;"
        }
    .end annotation
.end field

.field private mServiceController:Lcom/android/ims/internal/IImsServiceController;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/content/ComponentName;Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;Landroid/os/Handler;Lcom/android/internal/telephony/ims/ImsServiceController$RebindRetry;Lcom/android/ims/ImsFeatureBinderRepository;Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 87
    invoke-direct/range {p0 .. p6}, Lcom/android/internal/telephony/ims/ImsServiceController;-><init>(Landroid/content/Context;Landroid/content/ComponentName;Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;Landroid/os/Handler;Lcom/android/internal/telephony/ims/ImsServiceController$RebindRetry;Lcom/android/ims/ImsFeatureBinderRepository;)V

    .line 57
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    .line 58
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mConfigCompatAdapters:Landroid/util/SparseArray;

    .line 59
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mRegCompatAdapters:Landroid/util/SparseArray;

    .line 88
    iput-object p7, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelFeatureFactory:Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/content/ComponentName;Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;Lcom/android/ims/ImsFeatureBinderRepository;)V
    .locals 0

    .line 79
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/ims/ImsServiceController;-><init>(Landroid/content/Context;Landroid/content/ComponentName;Lcom/android/internal/telephony/ims/ImsServiceController$ImsServiceControllerCallbacks;Lcom/android/ims/ImsFeatureBinderRepository;)V

    .line 57
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    .line 58
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mConfigCompatAdapters:Landroid/util/SparseArray;

    .line 59
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mRegCompatAdapters:Landroid/util/SparseArray;

    .line 80
    new-instance p1, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$$ExternalSyntheticLambda0;

    invoke-direct {p1}, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$$ExternalSyntheticLambda0;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelFeatureFactory:Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;

    return-void
.end method

.method private createMMTelCompat(I)Landroid/telephony/ims/aidl/IImsMmTelFeature;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 249
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->getInterface(I)Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    move-result-object v0

    .line 250
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelFeatureFactory:Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsServiceController;->mContext:Landroid/content/Context;

    invoke-interface {v1, v2, p1, v0}, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat$MmTelFeatureCompatFactory;->create(Landroid/content/Context;ILcom/android/internal/telephony/ims/MmTelInterfaceAdapter;)Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;

    move-result-object v0

    .line 252
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {v1, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 253
    new-instance v1, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-direct {v1}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;-><init>()V

    .line 254
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->addRegistrationAdapter(Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;)V

    .line 255
    iget-object v2, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mRegCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {v2, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 256
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mConfigCompatAdapters:Landroid/util/SparseArray;

    new-instance v1, Lcom/android/internal/telephony/ims/ImsConfigCompatAdapter;

    .line 257
    invoke-virtual {v0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->getOldConfigInterface()Lcom/android/ims/internal/IImsConfig;

    move-result-object v2

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/ims/ImsConfigCompatAdapter;-><init>(Lcom/android/ims/internal/IImsConfig;)V

    .line 256
    invoke-virtual {p0, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 258
    invoke-virtual {v0}, Landroid/telephony/ims/feature/MmTelFeature;->getBinder()Landroid/telephony/ims/aidl/IImsMmTelFeature;

    move-result-object p0

    return-object p0
.end method

.method private createRcsFeature(I)Landroid/telephony/ims/aidl/IImsRcsFeature;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method private getInterface(I)Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 239
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    invoke-interface {p0, p1}, Lcom/android/ims/internal/IImsServiceController;->createMMTelFeature(I)Lcom/android/ims/internal/IImsMMTelFeature;

    move-result-object p0

    if-nez p0, :cond_0

    const-string p0, "ImsSCCompat"

    const-string p1, "createMMTelCompat: createMMTelFeature returned null."

    .line 241
    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0

    .line 244
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-interface {p0}, Lcom/android/ims/internal/IImsMMTelFeature;->asBinder()Landroid/os/IBinder;

    move-result-object p0

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;-><init>(ILandroid/os/IBinder;)V

    return-object v0
.end method


# virtual methods
.method protected final createImsFeature(IIIJ)Landroid/os/IInterface;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const/4 p2, 0x1

    if-eq p3, p2, :cond_1

    const/4 p2, 0x2

    if-eq p3, p2, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 187
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->createRcsFeature(I)Landroid/telephony/ims/aidl/IImsRcsFeature;

    move-result-object p0

    return-object p0

    .line 183
    :cond_1
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->createMMTelCompat(I)Landroid/telephony/ims/aidl/IImsMmTelFeature;

    move-result-object p0

    return-object p0
.end method

.method public final disableIms(II)V
    .locals 1

    .line 119
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;

    const-string p2, "ImsSCCompat"

    if-nez p0, :cond_0

    .line 121
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "enableIms: adapter null for slot :"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 125
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->disableIms()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 127
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Couldn\'t enable IMS: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public final enableIms(II)V
    .locals 1

    .line 102
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;

    const-string p2, "ImsSCCompat"

    if-nez p0, :cond_0

    .line 104
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "enableIms: adapter null for slot :"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 108
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->enableIms()V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 110
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Couldn\'t enable IMS: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public final getConfig(II)Landroid/telephony/ims/aidl/IImsConfig;
    .locals 0

    .line 149
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mConfigCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/ImsConfigCompatAdapter;

    if-nez p0, :cond_0

    .line 151
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "getConfig: Config does not exist for slot "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ImsSCCompat"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0

    .line 154
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/ims/stub/ImsConfigImplBase;->getIImsConfig()Landroid/telephony/ims/aidl/IImsConfig;

    move-result-object p0

    return-object p0
.end method

.method public final getRegistration(II)Landroid/telephony/ims/aidl/IImsRegistration;
    .locals 0

    .line 136
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mRegCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    if-nez p0, :cond_0

    .line 138
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "getRegistration: Registration does not exist for slot "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ImsSCCompat"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0

    .line 141
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->getBinder()Landroid/telephony/ims/aidl/IImsRegistration;

    move-result-object p0

    return-object p0
.end method

.method protected final getServiceInterface()Ljava/lang/String;
    .locals 0

    const-string p0, "android.telephony.ims.compat.ImsService"

    return-object p0
.end method

.method public getSipTransport(I)Landroid/telephony/ims/aidl/ISipTransport;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method protected getStaticServiceCapabilities()J
    .locals 2

    const-wide/16 v0, 0x0

    return-wide v0
.end method

.method protected isServiceControllerAvailable()Z
    .locals 0

    .line 234
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected final notifyImsServiceReady()V
    .locals 1

    const-string p0, "ImsSCCompat"

    const-string v0, "notifyImsServiceReady"

    .line 174
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected registerImsFeatureStatusCallback(IILcom/android/ims/internal/IImsFeatureStatusCallback;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 197
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    invoke-interface {p0, p1, p2, p3}, Lcom/android/ims/internal/IImsServiceController;->addFeatureStatusCallback(IILcom/android/ims/internal/IImsFeatureStatusCallback;)V

    return-void
.end method

.method protected final removeImsFeature(IIZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const/4 p3, 0x1

    if-ne p2, p3, :cond_1

    .line 214
    iget-object p3, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    const/4 v0, 0x0

    invoke-virtual {p3, p1, v0}, Landroid/util/SparseArray;->get(ILjava/lang/Object;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;

    if-eqz p3, :cond_0

    .line 217
    invoke-virtual {p3}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->onFeatureRemoved()V

    .line 218
    :cond_0
    iget-object p3, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mMmTelCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->remove(I)V

    .line 219
    iget-object p3, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mRegCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->remove(I)V

    .line 220
    iget-object p3, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mConfigCompatAdapters:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->remove(I)V

    .line 222
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    if-eqz p0, :cond_2

    .line 223
    invoke-interface {p0, p1, p2}, Lcom/android/ims/internal/IImsServiceController;->removeImsFeature(II)V

    :cond_2
    return-void
.end method

.method protected setServiceController(Landroid/os/IBinder;)V
    .locals 0

    .line 229
    invoke-static {p1}, Lcom/android/ims/internal/IImsServiceController$Stub;->asInterface(Landroid/os/IBinder;)Lcom/android/ims/internal/IImsServiceController;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    return-void
.end method

.method protected unregisterImsFeatureStatusCallback(IILcom/android/ims/internal/IImsFeatureStatusCallback;)V
    .locals 0

    .line 204
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceControllerCompat;->mServiceController:Lcom/android/ims/internal/IImsServiceController;

    invoke-interface {p0, p1, p2, p3}, Lcom/android/ims/internal/IImsServiceController;->removeFeatureStatusCallback(IILcom/android/ims/internal/IImsFeatureStatusCallback;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 206
    :catch_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "compat - unregisterImsFeatureStatusCallback - couldn\'t remove "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ImsSCCompat"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method
