.class public Lcom/android/internal/telephony/RILUtils;
.super Ljava/lang/Object;
.source "RILUtils.java"


# static fields
.field public static final CDMA_BROADCAST_SMS_NO_OF_SERVICE_CATEGORIES:I = 0x1f

.field public static final CDMA_BSI_NO_OF_INTS_STRUCT:I = 0x3

.field public static final RADIO_POWER_FAILURE_BUGREPORT_UUID:Ljava/lang/String; = "316f3801-fa21-4954-a42f-0041eada3b31"

.field public static final RADIO_POWER_FAILURE_NO_RF_CALIBRATION_UUID:Ljava/lang/String; = "316f3801-fa21-4954-a42f-0041eada3b33"

.field public static final RADIO_POWER_FAILURE_RF_HARDWARE_ISSUE_UUID:Ljava/lang/String; = "316f3801-fa21-4954-a42f-0041eada3b32"

.field private static final TAG:Ljava/lang/String; = "RILUtils"

.field private static final WRAPPER_CLASSES:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Class;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$08CLzOYCTOaVE6nc5IrxCdQOstE(Landroid/hardware/radio/V1_6/QosSession;)Landroid/telephony/data/QosBearerSession;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBearerSession(Landroid/hardware/radio/V1_6/QosSession;)Landroid/telephony/data/QosBearerSession;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$WWHHz2xJCx3S91T2rF8c21CTWF4(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->lambda$convertHalDataCallResult$1(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$gBWeFKs6ffSMrG_kLr7al9gL2fo(Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;)Landroid/telephony/data/RouteSelectionDescriptor;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->lambda$convertHalSlicingConfig$3(Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;)Landroid/telephony/data/RouteSelectionDescriptor;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$j6Jvnrv7UYMwUCcLayxOXthp21M(Landroid/hardware/radio/V1_6/UrspRule;)Landroid/telephony/data/UrspRule;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->lambda$convertHalSlicingConfig$4(Landroid/hardware/radio/V1_6/UrspRule;)Landroid/telephony/data/UrspRule;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$prYlqErHcbcum-1TE8okhXth0w4(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->lambda$convertHalSlicingConfig$2(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$sD3Qk8-Ug-TFRudr_OoB-Qioe9k(Landroid/hardware/radio/V1_6/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalSliceInfo(Landroid/hardware/radio/V1_6/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$yppQZCFQbdkwLZE9aAeDCr6o0BU(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->lambda$convertHalDataCallResult$0(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 4

    .line 394
    new-instance v0, Ljava/util/HashSet;

    const/16 v1, 0x8

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    const-class v3, Ljava/lang/Boolean;

    aput-object v3, v1, v2

    const/4 v2, 0x1

    const-class v3, Ljava/lang/Character;

    aput-object v3, v1, v2

    const/4 v2, 0x2

    const-class v3, Ljava/lang/Byte;

    aput-object v3, v1, v2

    const/4 v2, 0x3

    const-class v3, Ljava/lang/Short;

    aput-object v3, v1, v2

    const/4 v2, 0x4

    const-class v3, Ljava/lang/Integer;

    aput-object v3, v1, v2

    const/4 v2, 0x5

    const-class v3, Ljava/lang/Long;

    aput-object v3, v1, v2

    const/4 v2, 0x6

    const-class v3, Ljava/lang/Float;

    aput-object v3, v1, v2

    const/4 v2, 0x7

    const-class v3, Ljava/lang/Double;

    aput-object v3, v1, v2

    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    sput-object v0, Lcom/android/internal/telephony/RILUtils;->WRAPPER_CLASSES:Ljava/util/Set;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 378
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static appendPrimitiveArrayToArrayList([BLjava/util/ArrayList;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Byte;",
            ">;)V"
        }
    .end annotation

    .line 4605
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_0

    aget-byte v2, p0, v1

    .line 4606
    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method public static arrayListToPrimitiveArray(Ljava/util/ArrayList;)[B
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Byte;",
            ">;)[B"
        }
    .end annotation

    .line 4635
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    new-array v1, v0, [B

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_0

    .line 4637
    invoke-virtual {p0, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Byte;

    invoke-virtual {v3}, Ljava/lang/Byte;->byteValue()B

    move-result v3

    aput-byte v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v1
.end method

.method public static convertHalBarringInfoList(Ljava/util/List;)Landroid/util/SparseArray;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/hardware/radio/V1_5/BarringInfo;",
            ">;)",
            "Landroid/util/SparseArray<",
            "Landroid/telephony/BarringInfo$BarringServiceInfo;",
            ">;"
        }
    .end annotation

    .line 3313
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    .line 3314
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/hardware/radio/V1_5/BarringInfo;

    .line 3315
    iget v2, v1, Landroid/hardware/radio/V1_5/BarringInfo;->barringType:I

    const/4 v3, 0x1

    if-ne v2, v3, :cond_1

    .line 3317
    iget-object v2, v1, Landroid/hardware/radio/V1_5/BarringInfo;->barringTypeSpecificInfo:Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo;

    invoke-virtual {v2}, Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo;->getDiscriminator()B

    move-result v2

    if-eq v2, v3, :cond_0

    goto :goto_0

    .line 3325
    :cond_0
    iget-object v2, v1, Landroid/hardware/radio/V1_5/BarringInfo;->barringTypeSpecificInfo:Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo;

    .line 3326
    invoke-virtual {v2}, Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo;->conditional()Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo$Conditional;

    move-result-object v2

    .line 3327
    iget v3, v1, Landroid/hardware/radio/V1_5/BarringInfo;->serviceType:I

    new-instance v4, Landroid/telephony/BarringInfo$BarringServiceInfo;

    iget v1, v1, Landroid/hardware/radio/V1_5/BarringInfo;->barringType:I

    iget-boolean v5, v2, Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo$Conditional;->isBarred:Z

    iget v6, v2, Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo$Conditional;->factor:I

    iget v2, v2, Landroid/hardware/radio/V1_5/BarringInfo$BarringTypeSpecificInfo$Conditional;->timeSeconds:I

    invoke-direct {v4, v1, v5, v6, v2}, Landroid/telephony/BarringInfo$BarringServiceInfo;-><init>(IZII)V

    invoke-virtual {v0, v3, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_0

    .line 3335
    :cond_1
    iget v2, v1, Landroid/hardware/radio/V1_5/BarringInfo;->serviceType:I

    new-instance v3, Landroid/telephony/BarringInfo$BarringServiceInfo;

    iget v1, v1, Landroid/hardware/radio/V1_5/BarringInfo;->barringType:I

    const/4 v4, 0x0

    invoke-direct {v3, v1, v4, v4, v4}, Landroid/telephony/BarringInfo$BarringServiceInfo;-><init>(IZII)V

    invoke-virtual {v0, v2, v3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method public static convertHalBarringInfoList([Landroid/hardware/radio/network/BarringInfo;)Landroid/util/SparseArray;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/hardware/radio/network/BarringInfo;",
            ")",
            "Landroid/util/SparseArray<",
            "Landroid/telephony/BarringInfo$BarringServiceInfo;",
            ">;"
        }
    .end annotation

    .line 3351
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    .line 3352
    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, p0, v3

    .line 3353
    iget v5, v4, Landroid/hardware/radio/network/BarringInfo;->barringType:I

    const/4 v6, 0x1

    if-ne v5, v6, :cond_1

    .line 3355
    iget-object v5, v4, Landroid/hardware/radio/network/BarringInfo;->barringTypeSpecificInfo:Landroid/hardware/radio/network/BarringTypeSpecificInfo;

    if-nez v5, :cond_0

    goto :goto_1

    .line 3360
    :cond_0
    iget v5, v4, Landroid/hardware/radio/network/BarringInfo;->serviceType:I

    new-instance v6, Landroid/telephony/BarringInfo$BarringServiceInfo;

    iget v7, v4, Landroid/hardware/radio/network/BarringInfo;->barringType:I

    iget-object v4, v4, Landroid/hardware/radio/network/BarringInfo;->barringTypeSpecificInfo:Landroid/hardware/radio/network/BarringTypeSpecificInfo;

    iget-boolean v8, v4, Landroid/hardware/radio/network/BarringTypeSpecificInfo;->isBarred:Z

    iget v9, v4, Landroid/hardware/radio/network/BarringTypeSpecificInfo;->factor:I

    iget v4, v4, Landroid/hardware/radio/network/BarringTypeSpecificInfo;->timeSeconds:I

    invoke-direct {v6, v7, v8, v9, v4}, Landroid/telephony/BarringInfo$BarringServiceInfo;-><init>(IZII)V

    invoke-virtual {v0, v5, v6}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_1

    .line 3368
    :cond_1
    iget v5, v4, Landroid/hardware/radio/network/BarringInfo;->serviceType:I

    new-instance v6, Landroid/telephony/BarringInfo$BarringServiceInfo;

    iget v4, v4, Landroid/hardware/radio/network/BarringInfo;->barringType:I

    invoke-direct {v6, v4, v2, v2, v2}, Landroid/telephony/BarringInfo$BarringServiceInfo;-><init>(IZII)V

    invoke-virtual {v0, v5, v6}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method public static convertHalCardStatus(Landroid/hardware/radio/sim/CardStatus;)Lcom/android/internal/telephony/uicc/IccCardStatus;
    .locals 6

    .line 4342
    new-instance v0, Lcom/android/internal/telephony/uicc/IccCardStatus;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/IccCardStatus;-><init>()V

    .line 4343
    iget v1, p0, Landroid/hardware/radio/sim/CardStatus;->cardState:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/IccCardStatus;->setCardState(I)V

    .line 4344
    iget v1, p0, Landroid/hardware/radio/sim/CardStatus;->universalPinState:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/IccCardStatus;->setUniversalPinState(I)V

    .line 4345
    iget v1, p0, Landroid/hardware/radio/sim/CardStatus;->gsmUmtsSubscriptionAppIndex:I

    iput v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mGsmUmtsSubscriptionAppIndex:I

    .line 4346
    iget v1, p0, Landroid/hardware/radio/sim/CardStatus;->cdmaSubscriptionAppIndex:I

    iput v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mCdmaSubscriptionAppIndex:I

    .line 4347
    iget v1, p0, Landroid/hardware/radio/sim/CardStatus;->imsSubscriptionAppIndex:I

    iput v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mImsSubscriptionAppIndex:I

    .line 4348
    iget-object v1, p0, Landroid/hardware/radio/sim/CardStatus;->atr:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->atr:Ljava/lang/String;

    .line 4349
    iget-object v1, p0, Landroid/hardware/radio/sim/CardStatus;->iccid:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->iccid:Ljava/lang/String;

    .line 4350
    iget-object v1, p0, Landroid/hardware/radio/sim/CardStatus;->eid:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->eid:Ljava/lang/String;

    .line 4352
    iget-object v1, p0, Landroid/hardware/radio/sim/CardStatus;->applications:[Landroid/hardware/radio/sim/AppStatus;

    array-length v1, v1

    const/16 v2, 0x8

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 4354
    new-array v2, v1, [Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    iput-object v2, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    .line 4356
    iget-object v3, p0, Landroid/hardware/radio/sim/CardStatus;->applications:[Landroid/hardware/radio/sim/AppStatus;

    aget-object v3, v3, v2

    .line 4357
    new-instance v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    invoke-direct {v4}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;-><init>()V

    .line 4358
    iget v5, v3, Landroid/hardware/radio/sim/AppStatus;->appType:I

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppTypeFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v5

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_type:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    .line 4359
    iget v5, v3, Landroid/hardware/radio/sim/AppStatus;->appState:I

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v5

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_state:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    .line 4360
    iget v5, v3, Landroid/hardware/radio/sim/AppStatus;->persoSubstate:I

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PersoSubstateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    move-result-object v5

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->perso_substate:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    .line 4362
    iget-object v5, v3, Landroid/hardware/radio/sim/AppStatus;->aidPtr:Ljava/lang/String;

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->aid:Ljava/lang/String;

    .line 4363
    iget-object v5, v3, Landroid/hardware/radio/sim/AppStatus;->appLabelPtr:Ljava/lang/String;

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_label:Ljava/lang/String;

    .line 4364
    iget-boolean v5, v3, Landroid/hardware/radio/sim/AppStatus;->pin1Replaced:Z

    iput-boolean v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1_replaced:Z

    .line 4365
    iget v5, v3, Landroid/hardware/radio/sim/AppStatus;->pin1:I

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v5

    iput-object v5, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4366
    iget v3, v3, Landroid/hardware/radio/sim/AppStatus;->pin2:I

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v3

    iput-object v3, v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin2:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4367
    iget-object v3, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    aput-object v4, v3, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 4369
    :cond_0
    new-instance v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;

    invoke-direct {v1}, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;-><init>()V

    .line 4370
    iget-object p0, p0, Landroid/hardware/radio/sim/CardStatus;->slotMap:Landroid/hardware/radio/config/SlotPortMapping;

    iget v2, p0, Landroid/hardware/radio/config/SlotPortMapping;->physicalSlotId:I

    iput v2, v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;->mPhysicalSlotIndex:I

    .line 4371
    iget p0, p0, Landroid/hardware/radio/config/SlotPortMapping;->portId:I

    iput p0, v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;->mPortIndex:I

    .line 4372
    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mSlotPortMapping:Lcom/android/internal/telephony/uicc/IccSlotPortMapping;

    return-object v0
.end method

.method public static convertHalCardStatus(Ljava/lang/Object;)Lcom/android/internal/telephony/uicc/IccCardStatus;
    .locals 11

    .line 4261
    instance-of v0, p0, Landroid/hardware/radio/V1_5/CardStatus;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 4262
    move-object v1, p0

    check-cast v1, Landroid/hardware/radio/V1_5/CardStatus;

    .line 4263
    iget-object p0, v1, Landroid/hardware/radio/V1_5/CardStatus;->base:Landroid/hardware/radio/V1_4/CardStatus;

    iget-object p0, p0, Landroid/hardware/radio/V1_4/CardStatus;->base:Landroid/hardware/radio/V1_2/CardStatus;

    iget-object p0, p0, Landroid/hardware/radio/V1_2/CardStatus;->base:Landroid/hardware/radio/V1_0/CardStatus;

    :goto_0
    move-object v10, v1

    move-object v1, p0

    move-object p0, v10

    goto :goto_1

    .line 4264
    :cond_0
    instance-of v0, p0, Landroid/hardware/radio/V1_0/CardStatus;

    if-eqz v0, :cond_1

    .line 4266
    check-cast p0, Landroid/hardware/radio/V1_0/CardStatus;

    goto :goto_0

    :cond_1
    move-object p0, v1

    .line 4272
    :goto_1
    new-instance v0, Lcom/android/internal/telephony/uicc/IccCardStatus;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/IccCardStatus;-><init>()V

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/16 v4, 0x8

    if-eqz v1, :cond_4

    .line 4274
    iget v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->cardState:I

    invoke-virtual {v0, v5}, Lcom/android/internal/telephony/uicc/IccCardStatus;->setCardState(I)V

    .line 4275
    iget v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->universalPinState:I

    invoke-virtual {v0, v5}, Lcom/android/internal/telephony/uicc/IccCardStatus;->setUniversalPinState(I)V

    .line 4276
    iget v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->gsmUmtsSubscriptionAppIndex:I

    iput v5, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mGsmUmtsSubscriptionAppIndex:I

    .line 4277
    iget v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->cdmaSubscriptionAppIndex:I

    iput v5, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mCdmaSubscriptionAppIndex:I

    .line 4278
    iget v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->imsSubscriptionAppIndex:I

    iput v5, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mImsSubscriptionAppIndex:I

    .line 4279
    iget-object v5, v1, Landroid/hardware/radio/V1_0/CardStatus;->applications:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    if-le v5, v4, :cond_2

    move v5, v4

    .line 4285
    :cond_2
    new-array v6, v5, [Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    iput-object v6, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    move v6, v3

    :goto_2
    if-ge v6, v5, :cond_4

    .line 4287
    iget-object v7, v1, Landroid/hardware/radio/V1_0/CardStatus;->applications:Ljava/util/ArrayList;

    .line 4288
    invoke-virtual {v7, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/hardware/radio/V1_0/AppStatus;

    .line 4289
    new-instance v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    invoke-direct {v8}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;-><init>()V

    .line 4290
    iget v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->appType:I

    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppTypeFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v9

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_type:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    .line 4291
    iget v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->appState:I

    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v9

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_state:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    .line 4292
    iget v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->persoSubstate:I

    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PersoSubstateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    move-result-object v9

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->perso_substate:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    .line 4294
    iget-object v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->aidPtr:Ljava/lang/String;

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->aid:Ljava/lang/String;

    .line 4295
    iget-object v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->appLabelPtr:Ljava/lang/String;

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_label:Ljava/lang/String;

    .line 4296
    iget v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->pin1Replaced:I

    if-eqz v9, :cond_3

    move v9, v2

    goto :goto_3

    :cond_3
    move v9, v3

    :goto_3
    iput-boolean v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1_replaced:Z

    .line 4297
    iget v9, v7, Landroid/hardware/radio/V1_0/AppStatus;->pin1:I

    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v9

    iput-object v9, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4298
    iget v7, v7, Landroid/hardware/radio/V1_0/AppStatus;->pin2:I

    invoke-virtual {v8, v7}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v7

    iput-object v7, v8, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin2:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4299
    iget-object v7, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    aput-object v8, v7, v6

    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    :cond_4
    if-eqz p0, :cond_7

    .line 4303
    new-instance v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;

    invoke-direct {v1}, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;-><init>()V

    .line 4304
    iget-object v5, p0, Landroid/hardware/radio/V1_5/CardStatus;->base:Landroid/hardware/radio/V1_4/CardStatus;

    iget-object v6, v5, Landroid/hardware/radio/V1_4/CardStatus;->base:Landroid/hardware/radio/V1_2/CardStatus;

    iget v7, v6, Landroid/hardware/radio/V1_2/CardStatus;->physicalSlotId:I

    iput v7, v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;->mPhysicalSlotIndex:I

    .line 4305
    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mSlotPortMapping:Lcom/android/internal/telephony/uicc/IccSlotPortMapping;

    .line 4306
    iget-object v1, v6, Landroid/hardware/radio/V1_2/CardStatus;->atr:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->atr:Ljava/lang/String;

    .line 4307
    iget-object v1, v6, Landroid/hardware/radio/V1_2/CardStatus;->iccid:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->iccid:Ljava/lang/String;

    .line 4308
    iget-object v1, v5, Landroid/hardware/radio/V1_4/CardStatus;->eid:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->eid:Ljava/lang/String;

    .line 4309
    iget-object v1, p0, Landroid/hardware/radio/V1_5/CardStatus;->applications:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-le v1, v4, :cond_5

    goto :goto_4

    :cond_5
    move v4, v1

    .line 4315
    :goto_4
    new-array v1, v4, [Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    iput-object v1, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    move v1, v3

    :goto_5
    if-ge v1, v4, :cond_7

    .line 4317
    iget-object v5, p0, Landroid/hardware/radio/V1_5/CardStatus;->applications:Ljava/util/ArrayList;

    .line 4318
    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/hardware/radio/V1_5/AppStatus;

    .line 4319
    new-instance v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    invoke-direct {v6}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;-><init>()V

    .line 4320
    iget-object v7, v5, Landroid/hardware/radio/V1_5/AppStatus;->base:Landroid/hardware/radio/V1_0/AppStatus;

    iget v7, v7, Landroid/hardware/radio/V1_0/AppStatus;->appType:I

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppTypeFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    move-result-object v7

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_type:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;

    .line 4321
    iget-object v7, v5, Landroid/hardware/radio/V1_5/AppStatus;->base:Landroid/hardware/radio/V1_0/AppStatus;

    iget v7, v7, Landroid/hardware/radio/V1_0/AppStatus;->appState:I

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->AppStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v7

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_state:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    .line 4322
    iget v7, v5, Landroid/hardware/radio/V1_5/AppStatus;->persoSubstate:I

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PersoSubstateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    move-result-object v7

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->perso_substate:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;

    .line 4324
    iget-object v7, v5, Landroid/hardware/radio/V1_5/AppStatus;->base:Landroid/hardware/radio/V1_0/AppStatus;

    iget-object v8, v7, Landroid/hardware/radio/V1_0/AppStatus;->aidPtr:Ljava/lang/String;

    iput-object v8, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->aid:Ljava/lang/String;

    .line 4325
    iget-object v8, v7, Landroid/hardware/radio/V1_0/AppStatus;->appLabelPtr:Ljava/lang/String;

    iput-object v8, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->app_label:Ljava/lang/String;

    .line 4326
    iget v8, v7, Landroid/hardware/radio/V1_0/AppStatus;->pin1Replaced:I

    if-eqz v8, :cond_6

    move v8, v2

    goto :goto_6

    :cond_6
    move v8, v3

    :goto_6
    iput-boolean v8, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1_replaced:Z

    .line 4327
    iget v7, v7, Landroid/hardware/radio/V1_0/AppStatus;->pin1:I

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v7

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin1:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4328
    iget-object v5, v5, Landroid/hardware/radio/V1_5/AppStatus;->base:Landroid/hardware/radio/V1_0/AppStatus;

    iget v5, v5, Landroid/hardware/radio/V1_0/AppStatus;->pin2:I

    invoke-virtual {v6, v5}, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->PinStateFromRILInt(I)Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object v5

    iput-object v5, v6, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;->pin2:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    .line 4329
    iget-object v5, v0, Lcom/android/internal/telephony/uicc/IccCardStatus;->mApplications:[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus;

    aput-object v6, v5, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_5

    :cond_7
    return-object v0
.end method

.method public static convertHalCarrierList(Ljava/util/List;)Ljava/util/List;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/hardware/radio/V1_0/Carrier;",
            ">;)",
            "Ljava/util/List<",
            "Landroid/service/carrier/CarrierIdentifier;",
            ">;"
        }
    .end annotation

    .line 4204
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    .line 4205
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_4

    .line 4206
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_0/Carrier;

    iget-object v4, v2, Landroid/hardware/radio/V1_0/Carrier;->mcc:Ljava/lang/String;

    .line 4207
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_0/Carrier;

    iget-object v5, v2, Landroid/hardware/radio/V1_0/Carrier;->mnc:Ljava/lang/String;

    .line 4209
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_0/Carrier;

    iget v2, v2, Landroid/hardware/radio/V1_0/Carrier;->matchType:I

    .line 4210
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/hardware/radio/V1_0/Carrier;

    iget-object v3, v3, Landroid/hardware/radio/V1_0/Carrier;->matchData:Ljava/lang/String;

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-ne v2, v6, :cond_0

    move-object v6, v3

    move-object v8, v7

    :goto_1
    move-object v9, v8

    goto :goto_2

    :cond_0
    const/4 v6, 0x2

    if-ne v2, v6, :cond_1

    move-object v6, v7

    move-object v8, v6

    move-object v9, v8

    move-object v7, v3

    goto :goto_2

    :cond_1
    const/4 v6, 0x3

    if-ne v2, v6, :cond_2

    move-object v8, v3

    move-object v6, v7

    move-object v9, v6

    goto :goto_2

    :cond_2
    const/4 v6, 0x4

    if-ne v2, v6, :cond_3

    move-object v9, v3

    move-object v6, v7

    move-object v8, v6

    goto :goto_2

    :cond_3
    move-object v6, v7

    move-object v8, v6

    goto :goto_1

    .line 4220
    :goto_2
    new-instance v2, Landroid/service/carrier/CarrierIdentifier;

    move-object v3, v2

    invoke-direct/range {v3 .. v9}, Landroid/service/carrier/CarrierIdentifier;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_4
    return-object v0
.end method

.method public static convertHalCarrierList([Landroid/hardware/radio/sim/Carrier;)Ljava/util/List;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/hardware/radio/sim/Carrier;",
            ")",
            "Ljava/util/List<",
            "Landroid/service/carrier/CarrierIdentifier;",
            ">;"
        }
    .end annotation

    .line 4232
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    .line 4233
    :goto_0
    array-length v2, p0

    if-ge v1, v2, :cond_4

    .line 4234
    aget-object v2, p0, v1

    iget-object v4, v2, Landroid/hardware/radio/sim/Carrier;->mcc:Ljava/lang/String;

    .line 4235
    iget-object v5, v2, Landroid/hardware/radio/sim/Carrier;->mnc:Ljava/lang/String;

    .line 4237
    iget v3, v2, Landroid/hardware/radio/sim/Carrier;->matchType:I

    .line 4238
    iget-object v2, v2, Landroid/hardware/radio/sim/Carrier;->matchData:Ljava/lang/String;

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-ne v3, v6, :cond_0

    move-object v6, v2

    move-object v8, v7

    :goto_1
    move-object v9, v8

    goto :goto_2

    :cond_0
    const/4 v6, 0x2

    if-ne v3, v6, :cond_1

    move-object v6, v7

    move-object v8, v6

    move-object v9, v8

    move-object v7, v2

    goto :goto_2

    :cond_1
    const/4 v6, 0x3

    if-ne v3, v6, :cond_2

    move-object v8, v2

    move-object v6, v7

    move-object v9, v6

    goto :goto_2

    :cond_2
    const/4 v6, 0x4

    if-ne v3, v6, :cond_3

    move-object v9, v2

    move-object v6, v7

    move-object v8, v6

    goto :goto_2

    :cond_3
    move-object v6, v7

    move-object v8, v6

    goto :goto_1

    .line 4248
    :goto_2
    new-instance v2, Landroid/service/carrier/CarrierIdentifier;

    move-object v3, v2

    invoke-direct/range {v3 .. v9}, Landroid/service/carrier/CarrierIdentifier;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_4
    return-object v0
.end method

.method public static convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;
    .locals 7

    .line 3090
    new-instance v6, Landroid/telephony/CellSignalStrengthCdma;

    iget v0, p0, Landroid/hardware/radio/V1_0/CdmaSignalStrength;->dbm:I

    neg-int v1, v0

    iget p0, p0, Landroid/hardware/radio/V1_0/CdmaSignalStrength;->ecio:I

    neg-int v2, p0

    iget p0, p1, Landroid/hardware/radio/V1_0/EvdoSignalStrength;->dbm:I

    neg-int v3, p0

    iget p0, p1, Landroid/hardware/radio/V1_0/EvdoSignalStrength;->ecio:I

    neg-int v4, p0

    iget v5, p1, Landroid/hardware/radio/V1_0/EvdoSignalStrength;->signalNoiseRatio:I

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Landroid/telephony/CellSignalStrengthCdma;-><init>(IIIII)V

    return-object v6
.end method

.method public static convertHalCdmaSignalStrength(Landroid/hardware/radio/network/CdmaSignalStrength;Landroid/hardware/radio/network/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;
    .locals 7

    .line 3104
    new-instance v6, Landroid/telephony/CellSignalStrengthCdma;

    iget v0, p0, Landroid/hardware/radio/network/CdmaSignalStrength;->dbm:I

    neg-int v1, v0

    iget p0, p0, Landroid/hardware/radio/network/CdmaSignalStrength;->ecio:I

    neg-int v2, p0

    iget p0, p1, Landroid/hardware/radio/network/EvdoSignalStrength;->dbm:I

    neg-int v3, p0

    iget p0, p1, Landroid/hardware/radio/network/EvdoSignalStrength;->ecio:I

    neg-int v4, p0

    iget v5, p1, Landroid/hardware/radio/network/EvdoSignalStrength;->signalNoiseRatio:I

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Landroid/telephony/CellSignalStrengthCdma;-><init>(IIIII)V

    return-object v6
.end method

.method public static convertHalCdmaSmsMessage(Landroid/hardware/radio/V1_0/CdmaSmsMessage;)Lcom/android/internal/telephony/cdma/SmsMessage;
    .locals 9

    .line 701
    new-instance v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;-><init>()V

    .line 702
    new-instance v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;

    invoke-direct {v1}, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;-><init>()V

    .line 703
    new-instance v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;

    invoke-direct {v2}, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;-><init>()V

    .line 710
    iget v3, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->teleserviceId:I

    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->teleService:I

    .line 712
    iget-boolean v4, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->isServicePresent:Z

    const/4 v5, 0x0

    if-eqz v4, :cond_0

    const/4 v3, 0x1

    .line 713
    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    goto :goto_0

    :cond_0
    if-nez v3, :cond_1

    const/4 v3, 0x2

    .line 717
    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    goto :goto_0

    .line 719
    :cond_1
    iput v5, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    .line 722
    :goto_0
    iget v3, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->serviceCategory:I

    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->serviceCategory:I

    .line 725
    iget-object v3, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    iget v4, v3, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->digitMode:I

    and-int/lit16 v6, v4, 0xff

    int-to-byte v6, v6

    .line 726
    iput v6, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->digitMode:I

    .line 727
    iget v6, v3, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberMode:I

    and-int/lit16 v6, v6, 0xff

    int-to-byte v6, v6

    iput v6, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberMode:I

    .line 728
    iget v6, v3, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberType:I

    iput v6, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->ton:I

    .line 729
    iget v6, v3, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberPlan:I

    and-int/lit16 v6, v6, 0xff

    int-to-byte v6, v6

    iput v6, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberPlan:I

    .line 730
    iget-object v3, v3, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    int-to-byte v3, v3

    .line 731
    iput v3, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberOfDigits:I

    .line 732
    new-array v6, v3, [B

    move v7, v5

    :goto_1
    if-ge v7, v3, :cond_3

    .line 734
    iget-object v8, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    iget-object v8, v8, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {v8, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/Byte;

    invoke-virtual {v8}, Ljava/lang/Byte;->byteValue()B

    move-result v8

    aput-byte v8, v6, v7

    if-nez v4, :cond_2

    .line 738
    invoke-static {v8}, Lcom/android/internal/telephony/cdma/SmsMessage;->convertDtmfToAscii(B)B

    move-result v8

    aput-byte v8, v6, v7

    :cond_2
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 742
    :cond_3
    iput-object v6, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->origBytes:[B

    .line 744
    iget-object v3, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;

    iget v4, v3, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->subaddressType:I

    iput v4, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->type:I

    .line 745
    iget-boolean v4, v3, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->odd:Z

    int-to-byte v4, v4

    iput-byte v4, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->odd:B

    .line 746
    iget-object v3, v3, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    int-to-byte v3, v3

    if-gez v3, :cond_4

    move v3, v5

    .line 754
    :cond_4
    new-array v4, v3, [B

    move v6, v5

    :goto_2
    if-ge v6, v3, :cond_5

    .line 757
    iget-object v7, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;

    iget-object v7, v7, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {v7, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Byte;

    invoke-virtual {v7}, Ljava/lang/Byte;->byteValue()B

    move-result v7

    aput-byte v7, v4, v6

    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    .line 760
    :cond_5
    iput-object v4, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->origBytes:[B

    .line 770
    iget-object v3, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->bearerData:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    if-gez v3, :cond_6

    move v3, v5

    .line 775
    :cond_6
    new-array v4, v3, [B

    :goto_3
    if-ge v5, v3, :cond_7

    .line 777
    iget-object v6, p0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->bearerData:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Byte;

    invoke-virtual {v6}, Ljava/lang/Byte;->byteValue()B

    move-result v6

    aput-byte v6, v4, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_3

    .line 780
    :cond_7
    iput-object v4, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->bearerData:[B

    .line 783
    iput-object v1, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->origAddress:Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;

    .line 784
    iput-object v2, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->origSubaddress:Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;

    .line 786
    new-instance p0, Lcom/android/internal/telephony/cdma/SmsMessage;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/cdma/SmsMessage;-><init>(Lcom/android/internal/telephony/SmsAddress;Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;)V

    return-object p0
.end method

.method public static convertHalCdmaSmsMessage(Landroid/hardware/radio/messaging/CdmaSmsMessage;)Lcom/android/internal/telephony/cdma/SmsMessage;
    .locals 9

    .line 800
    new-instance v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;-><init>()V

    .line 801
    new-instance v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;

    invoke-direct {v1}, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;-><init>()V

    .line 802
    new-instance v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;

    invoke-direct {v2}, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;-><init>()V

    .line 805
    iget-object v3, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    iget v4, v3, Landroid/hardware/radio/messaging/CdmaSmsAddress;->digitMode:I

    and-int/lit16 v5, v4, 0xff

    int-to-byte v5, v5

    .line 806
    iput v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->digitMode:I

    .line 807
    iget-boolean v5, v3, Landroid/hardware/radio/messaging/CdmaSmsAddress;->isNumberModeDataNetwork:Z

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    iput v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberMode:I

    .line 808
    iget v5, v3, Landroid/hardware/radio/messaging/CdmaSmsAddress;->numberType:I

    iput v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->ton:I

    .line 809
    iget v5, v3, Landroid/hardware/radio/messaging/CdmaSmsAddress;->numberPlan:I

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    iput v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberPlan:I

    .line 810
    iget-object v3, v3, Landroid/hardware/radio/messaging/CdmaSmsAddress;->digits:[B

    array-length v5, v3

    iput v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->numberOfDigits:I

    .line 811
    array-length v3, v3

    new-array v5, v3, [B

    const/4 v6, 0x0

    move v7, v6

    :goto_0
    if-ge v7, v3, :cond_1

    .line 813
    iget-object v8, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    iget-object v8, v8, Landroid/hardware/radio/messaging/CdmaSmsAddress;->digits:[B

    aget-byte v8, v8, v7

    aput-byte v8, v5, v7

    if-nez v4, :cond_0

    .line 816
    invoke-static {v8}, Lcom/android/internal/telephony/cdma/SmsMessage;->convertDtmfToAscii(B)B

    move-result v8

    aput-byte v8, v5, v7

    :cond_0
    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    .line 819
    :cond_1
    iput-object v5, v1, Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;->origBytes:[B

    .line 822
    iget-object v3, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    iget v4, v3, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->subaddressType:I

    iput v4, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->type:I

    .line 823
    iget-boolean v4, v3, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->odd:Z

    int-to-byte v4, v4

    iput-byte v4, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->odd:B

    .line 824
    iget-object v3, v3, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->digits:[B

    iput-object v3, v2, Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;->origBytes:[B

    .line 829
    iget v3, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->teleserviceId:I

    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->teleService:I

    .line 830
    iget-boolean v4, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->isServicePresent:Z

    if-eqz v4, :cond_2

    const/4 v3, 0x1

    .line 831
    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    goto :goto_1

    :cond_2
    if-nez v3, :cond_3

    const/4 v3, 0x2

    .line 835
    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    goto :goto_1

    .line 837
    :cond_3
    iput v6, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->messageType:I

    .line 840
    :goto_1
    iget v3, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->serviceCategory:I

    iput v3, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->serviceCategory:I

    .line 843
    iget-object p0, p0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->bearerData:[B

    iput-object p0, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->bearerData:[B

    .line 846
    iput-object v1, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->origAddress:Lcom/android/internal/telephony/cdma/sms/CdmaSmsAddress;

    .line 847
    iput-object v2, v0, Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;->origSubaddress:Lcom/android/internal/telephony/cdma/sms/CdmaSmsSubaddress;

    .line 849
    new-instance p0, Lcom/android/internal/telephony/cdma/SmsMessage;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/cdma/SmsMessage;-><init>(Lcom/android/internal/telephony/SmsAddress;Lcom/android/internal/telephony/cdma/sms/SmsEnvelope;)V

    return-object p0
.end method

.method public static convertHalCellConnectionStatus(I)I
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    return v0
.end method

.method public static convertHalCellIdentity(Landroid/hardware/radio/network/CellIdentity;)Landroid/telephony/CellIdentity;
    .locals 2

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2717
    :cond_0
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getTag()I

    move-result v1

    packed-switch v1, :pswitch_data_0

    return-object v0

    .line 2729
    :pswitch_0
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getNr()Landroid/hardware/radio/network/CellIdentityNr;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Landroid/hardware/radio/network/CellIdentityNr;)Landroid/telephony/CellIdentityNr;

    move-result-object p0

    return-object p0

    .line 2723
    :pswitch_1
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getLte()Landroid/hardware/radio/network/CellIdentityLte;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Landroid/hardware/radio/network/CellIdentityLte;)Landroid/telephony/CellIdentityLte;

    move-result-object p0

    return-object p0

    .line 2721
    :pswitch_2
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getCdma()Landroid/hardware/radio/network/CellIdentityCdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Landroid/hardware/radio/network/CellIdentityCdma;)Landroid/telephony/CellIdentityCdma;

    move-result-object p0

    return-object p0

    .line 2727
    :pswitch_3
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getTdscdma()Landroid/hardware/radio/network/CellIdentityTdscdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Landroid/hardware/radio/network/CellIdentityTdscdma;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object p0

    return-object p0

    .line 2725
    :pswitch_4
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getWcdma()Landroid/hardware/radio/network/CellIdentityWcdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Landroid/hardware/radio/network/CellIdentityWcdma;)Landroid/telephony/CellIdentityWcdma;

    move-result-object p0

    return-object p0

    .line 2719
    :pswitch_5
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellIdentity;->getGsm()Landroid/hardware/radio/network/CellIdentityGsm;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Landroid/hardware/radio/network/CellIdentityGsm;)Landroid/telephony/CellIdentityGsm;

    move-result-object p0

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertHalCellIdentity(Ljava/lang/Object;)Landroid/telephony/CellIdentity;
    .locals 8

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2628
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;

    const/4 v2, 0x5

    const/4 v3, 0x4

    const/4 v4, 0x3

    const/4 v5, 0x2

    const/4 v6, 0x0

    const/4 v7, 0x1

    if-eqz v1, :cond_6

    .line 2629
    check-cast p0, Landroid/hardware/radio/V1_0/CellIdentity;

    .line 2631
    iget v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellInfoType:I

    if-eq v1, v7, :cond_5

    if-eq v1, v5, :cond_4

    if-eq v1, v4, :cond_3

    if-eq v1, v3, :cond_2

    if-eq v1, v2, :cond_1

    goto/16 :goto_0

    .line 2653
    :cond_1
    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityTdscdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2654
    iget-object p0, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityTdscdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object p0

    return-object p0

    .line 2648
    :cond_2
    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityWcdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2649
    iget-object p0, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityWcdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object p0

    return-object p0

    .line 2643
    :cond_3
    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityLte:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2644
    iget-object p0, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityLte:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object p0

    return-object p0

    .line 2638
    :cond_4
    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityCdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2639
    iget-object p0, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityCdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object p0

    return-object p0

    .line 2633
    :cond_5
    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityGsm:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2634
    iget-object p0, p0, Landroid/hardware/radio/V1_0/CellIdentity;->cellIdentityGsm:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object p0

    return-object p0

    .line 2658
    :cond_6
    instance-of v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;

    if-eqz v1, :cond_c

    .line 2659
    check-cast p0, Landroid/hardware/radio/V1_2/CellIdentity;

    .line 2661
    iget v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellInfoType:I

    if-eq v1, v7, :cond_b

    if-eq v1, v5, :cond_a

    if-eq v1, v4, :cond_9

    if-eq v1, v3, :cond_8

    if-eq v1, v2, :cond_7

    goto/16 :goto_0

    .line 2683
    :cond_7
    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityTdscdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2684
    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityTdscdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object p0

    return-object p0

    .line 2678
    :cond_8
    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityWcdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2679
    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityWcdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object p0

    return-object p0

    .line 2673
    :cond_9
    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityLte:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2674
    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityLte:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object p0

    return-object p0

    .line 2668
    :cond_a
    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityCdma:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2669
    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityCdma:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object p0

    return-object p0

    .line 2663
    :cond_b
    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityGsm:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-ne v1, v7, :cond_d

    .line 2664
    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentity;->cellIdentityGsm:Ljava/util/ArrayList;

    invoke-virtual {p0, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object p0

    return-object p0

    .line 2688
    :cond_c
    instance-of v1, p0, Landroid/hardware/radio/V1_5/CellIdentity;

    if-eqz v1, :cond_d

    .line 2689
    check-cast p0, Landroid/hardware/radio/V1_5/CellIdentity;

    .line 2691
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->getDiscriminator()B

    move-result v1

    packed-switch v1, :pswitch_data_0

    goto :goto_0

    .line 2703
    :pswitch_0
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->nr()Landroid/hardware/radio/V1_5/CellIdentityNr;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Ljava/lang/Object;)Landroid/telephony/CellIdentityNr;

    move-result-object p0

    return-object p0

    .line 2697
    :pswitch_1
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->lte()Landroid/hardware/radio/V1_5/CellIdentityLte;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object p0

    return-object p0

    .line 2695
    :pswitch_2
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->cdma()Landroid/hardware/radio/V1_2/CellIdentityCdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object p0

    return-object p0

    .line 2701
    :pswitch_3
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->tdscdma()Landroid/hardware/radio/V1_5/CellIdentityTdscdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object p0

    return-object p0

    .line 2699
    :pswitch_4
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->wcdma()Landroid/hardware/radio/V1_5/CellIdentityWcdma;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object p0

    return-object p0

    .line 2693
    :pswitch_5
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/CellIdentity;->gsm()Landroid/hardware/radio/V1_5/CellIdentityGsm;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object p0

    return-object p0

    :cond_d
    :goto_0
    return-object v0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertHalCellIdentityCdma(Landroid/hardware/radio/network/CellIdentityCdma;)Landroid/telephony/CellIdentityCdma;
    .locals 9

    .line 2809
    new-instance v8, Landroid/telephony/CellIdentityCdma;

    iget v1, p0, Landroid/hardware/radio/network/CellIdentityCdma;->networkId:I

    iget v2, p0, Landroid/hardware/radio/network/CellIdentityCdma;->systemId:I

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityCdma;->baseStationId:I

    iget v4, p0, Landroid/hardware/radio/network/CellIdentityCdma;->longitude:I

    iget v5, p0, Landroid/hardware/radio/network/CellIdentityCdma;->latitude:I

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityCdma;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v6, p0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v7, p0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    move-object v0, v8

    invoke-direct/range {v0 .. v7}, Landroid/telephony/CellIdentityCdma;-><init>(IIIIILjava/lang/String;Ljava/lang/String;)V

    return-object v8
.end method

.method public static convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;
    .locals 9

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2786
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;

    if-eqz v1, :cond_1

    .line 2787
    check-cast p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;

    .line 2789
    new-instance v8, Landroid/telephony/CellIdentityCdma;

    iget v1, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->networkId:I

    iget v2, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->systemId:I

    iget v3, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->baseStationId:I

    iget v4, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->longitude:I

    iget v5, p0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->latitude:I

    const-string v6, ""

    const-string v7, ""

    move-object v0, v8

    invoke-direct/range {v0 .. v7}, Landroid/telephony/CellIdentityCdma;-><init>(IIIIILjava/lang/String;Ljava/lang/String;)V

    return-object v8

    .line 2791
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/CellIdentityCdma;

    if-eqz v1, :cond_2

    .line 2792
    check-cast p0, Landroid/hardware/radio/V1_2/CellIdentityCdma;

    .line 2794
    new-instance v8, Landroid/telephony/CellIdentityCdma;

    iget-object v0, p0, Landroid/hardware/radio/V1_2/CellIdentityCdma;->base:Landroid/hardware/radio/V1_0/CellIdentityCdma;

    iget v1, v0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->networkId:I

    iget v2, v0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->systemId:I

    iget v3, v0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->baseStationId:I

    iget v4, v0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->longitude:I

    iget v5, v0, Landroid/hardware/radio/V1_0/CellIdentityCdma;->latitude:I

    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentityCdma;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v6, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v7, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    move-object v0, v8

    invoke-direct/range {v0 .. v7}, Landroid/telephony/CellIdentityCdma;-><init>(IIIIILjava/lang/String;Ljava/lang/String;)V

    return-object v8

    :cond_2
    return-object v0
.end method

.method public static convertHalCellIdentityGsm(Landroid/hardware/radio/network/CellIdentityGsm;)Landroid/telephony/CellIdentityGsm;
    .locals 11

    .line 2774
    new-instance v10, Landroid/telephony/CellIdentityGsm;

    iget v1, p0, Landroid/hardware/radio/network/CellIdentityGsm;->lac:I

    iget v2, p0, Landroid/hardware/radio/network/CellIdentityGsm;->cid:I

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityGsm;->arfcn:I

    .line 2775
    iget-byte v0, p0, Landroid/hardware/radio/network/CellIdentityGsm;->bsic:B

    const/4 v4, -0x1

    if-ne v0, v4, :cond_0

    const v0, 0x7fffffff

    :cond_0
    move v4, v0

    iget-object v5, p0, Landroid/hardware/radio/network/CellIdentityGsm;->mcc:Ljava/lang/String;

    iget-object v6, p0, Landroid/hardware/radio/network/CellIdentityGsm;->mnc:Ljava/lang/String;

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityGsm;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v7, p0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v8, p0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    new-instance v9, Landroid/util/ArraySet;

    invoke-direct {v9}, Landroid/util/ArraySet;-><init>()V

    move-object v0, v10

    invoke-direct/range {v0 .. v9}, Landroid/telephony/CellIdentityGsm;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v10
.end method

.method public static convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;
    .locals 14

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2741
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;

    const v2, 0x7fffffff

    const/4 v3, -0x1

    if-eqz v1, :cond_2

    .line 2742
    check-cast p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;

    .line 2744
    new-instance v0, Landroid/telephony/CellIdentityGsm;

    iget v5, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->lac:I

    iget v6, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->cid:I

    iget v7, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->arfcn:I

    .line 2745
    iget-byte v1, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->bsic:B

    if-ne v1, v3, :cond_1

    move v8, v2

    goto :goto_0

    :cond_1
    move v8, v1

    :goto_0
    iget-object v9, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mcc:Ljava/lang/String;

    iget-object v10, p0, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mnc:Ljava/lang/String;

    new-instance v13, Landroid/util/ArraySet;

    invoke-direct {v13}, Landroid/util/ArraySet;-><init>()V

    const-string v11, ""

    const-string v12, ""

    move-object v4, v0

    invoke-direct/range {v4 .. v13}, Landroid/telephony/CellIdentityGsm;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v0

    .line 2747
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_2/CellIdentityGsm;

    if-eqz v1, :cond_4

    .line 2748
    check-cast p0, Landroid/hardware/radio/V1_2/CellIdentityGsm;

    .line 2750
    new-instance v0, Landroid/telephony/CellIdentityGsm;

    iget-object v1, p0, Landroid/hardware/radio/V1_2/CellIdentityGsm;->base:Landroid/hardware/radio/V1_0/CellIdentityGsm;

    iget v5, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->lac:I

    iget v6, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->cid:I

    iget v7, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->arfcn:I

    .line 2751
    iget-byte v4, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->bsic:B

    if-ne v4, v3, :cond_3

    move v8, v2

    goto :goto_1

    :cond_3
    move v8, v4

    :goto_1
    iget-object v9, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mcc:Ljava/lang/String;

    iget-object v10, v1, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mnc:Ljava/lang/String;

    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentityGsm;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v11, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v12, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    new-instance v13, Landroid/util/ArraySet;

    invoke-direct {v13}, Landroid/util/ArraySet;-><init>()V

    move-object v4, v0

    invoke-direct/range {v4 .. v13}, Landroid/telephony/CellIdentityGsm;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v0

    .line 2754
    :cond_4
    instance-of v1, p0, Landroid/hardware/radio/V1_5/CellIdentityGsm;

    if-eqz v1, :cond_6

    .line 2755
    check-cast p0, Landroid/hardware/radio/V1_5/CellIdentityGsm;

    .line 2757
    new-instance v0, Landroid/telephony/CellIdentityGsm;

    iget-object v1, p0, Landroid/hardware/radio/V1_5/CellIdentityGsm;->base:Landroid/hardware/radio/V1_2/CellIdentityGsm;

    iget-object v4, v1, Landroid/hardware/radio/V1_2/CellIdentityGsm;->base:Landroid/hardware/radio/V1_0/CellIdentityGsm;

    iget v5, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->lac:I

    iget v6, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->cid:I

    iget v7, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->arfcn:I

    .line 2758
    iget-byte v8, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->bsic:B

    if-ne v8, v3, :cond_5

    move v8, v2

    .line 2759
    :cond_5
    iget-object v9, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mcc:Ljava/lang/String;

    iget-object v10, v4, Landroid/hardware/radio/V1_0/CellIdentityGsm;->mnc:Ljava/lang/String;

    iget-object v1, v1, Landroid/hardware/radio/V1_2/CellIdentityGsm;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v11, v1, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v12, v1, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    iget-object v13, p0, Landroid/hardware/radio/V1_5/CellIdentityGsm;->additionalPlmns:Ljava/util/ArrayList;

    move-object v4, v0

    invoke-direct/range {v4 .. v13}, Landroid/telephony/CellIdentityGsm;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    :cond_6
    return-object v0
.end method

.method public static convertHalCellIdentityLte(Landroid/hardware/radio/network/CellIdentityLte;)Landroid/telephony/CellIdentityLte;
    .locals 14

    .line 2852
    new-instance v13, Landroid/telephony/CellIdentityLte;

    iget v1, p0, Landroid/hardware/radio/network/CellIdentityLte;->ci:I

    iget v2, p0, Landroid/hardware/radio/network/CellIdentityLte;->pci:I

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityLte;->tac:I

    iget v4, p0, Landroid/hardware/radio/network/CellIdentityLte;->earfcn:I

    iget-object v5, p0, Landroid/hardware/radio/network/CellIdentityLte;->bands:[I

    iget v6, p0, Landroid/hardware/radio/network/CellIdentityLte;->bandwidth:I

    iget-object v7, p0, Landroid/hardware/radio/network/CellIdentityLte;->mcc:Ljava/lang/String;

    iget-object v8, p0, Landroid/hardware/radio/network/CellIdentityLte;->mnc:Ljava/lang/String;

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityLte;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v9, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v10, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityLte;->additionalPlmns:[Ljava/lang/String;

    .line 2854
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v11

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityLte;->csgInfo:Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;

    .line 2855
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object v12

    move-object v0, v13

    invoke-direct/range {v0 .. v12}, Landroid/telephony/CellIdentityLte;-><init>(IIII[IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v13
.end method

.method public static convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;
    .locals 17

    move-object/from16 v0, p0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 2820
    :cond_0
    instance-of v2, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;

    const/4 v3, 0x0

    if-eqz v2, :cond_1

    .line 2821
    check-cast v0, Landroid/hardware/radio/V1_0/CellIdentityLte;

    .line 2823
    new-instance v1, Landroid/telephony/CellIdentityLte;

    iget v5, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->ci:I

    iget v6, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->pci:I

    iget v7, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->tac:I

    iget v8, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->earfcn:I

    new-array v9, v3, [I

    const v10, 0x7fffffff

    iget-object v11, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->mcc:Ljava/lang/String;

    iget-object v12, v0, Landroid/hardware/radio/V1_0/CellIdentityLte;->mnc:Ljava/lang/String;

    new-instance v15, Landroid/util/ArraySet;

    invoke-direct {v15}, Landroid/util/ArraySet;-><init>()V

    const/16 v16, 0x0

    const-string v13, ""

    const-string v14, ""

    move-object v4, v1

    invoke-direct/range {v4 .. v16}, Landroid/telephony/CellIdentityLte;-><init>(IIII[IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v1

    .line 2825
    :cond_1
    instance-of v2, v0, Landroid/hardware/radio/V1_2/CellIdentityLte;

    if-eqz v2, :cond_2

    .line 2826
    check-cast v0, Landroid/hardware/radio/V1_2/CellIdentityLte;

    .line 2828
    new-instance v1, Landroid/telephony/CellIdentityLte;

    iget-object v2, v0, Landroid/hardware/radio/V1_2/CellIdentityLte;->base:Landroid/hardware/radio/V1_0/CellIdentityLte;

    iget v5, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->ci:I

    iget v6, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->pci:I

    iget v7, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->tac:I

    iget v8, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->earfcn:I

    new-array v9, v3, [I

    iget v10, v0, Landroid/hardware/radio/V1_2/CellIdentityLte;->bandwidth:I

    iget-object v11, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->mcc:Ljava/lang/String;

    iget-object v12, v2, Landroid/hardware/radio/V1_0/CellIdentityLte;->mnc:Ljava/lang/String;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellIdentityLte;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v13, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v14, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    new-instance v15, Landroid/util/ArraySet;

    invoke-direct {v15}, Landroid/util/ArraySet;-><init>()V

    const/16 v16, 0x0

    move-object v4, v1

    invoke-direct/range {v4 .. v16}, Landroid/telephony/CellIdentityLte;-><init>(IIII[IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v1

    .line 2832
    :cond_2
    instance-of v2, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;

    if-eqz v2, :cond_3

    .line 2833
    check-cast v0, Landroid/hardware/radio/V1_5/CellIdentityLte;

    .line 2835
    new-instance v14, Landroid/telephony/CellIdentityLte;

    iget-object v1, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;->base:Landroid/hardware/radio/V1_2/CellIdentityLte;

    iget-object v1, v1, Landroid/hardware/radio/V1_2/CellIdentityLte;->base:Landroid/hardware/radio/V1_0/CellIdentityLte;

    iget v2, v1, Landroid/hardware/radio/V1_0/CellIdentityLte;->ci:I

    iget v3, v1, Landroid/hardware/radio/V1_0/CellIdentityLte;->pci:I

    iget v4, v1, Landroid/hardware/radio/V1_0/CellIdentityLte;->tac:I

    iget v5, v1, Landroid/hardware/radio/V1_0/CellIdentityLte;->earfcn:I

    iget-object v1, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;->bands:Ljava/util/ArrayList;

    .line 2836
    invoke-virtual {v1}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v6, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;

    invoke-direct {v6}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;-><init>()V

    invoke-interface {v1, v6}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object v6

    iget-object v1, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;->base:Landroid/hardware/radio/V1_2/CellIdentityLte;

    iget v7, v1, Landroid/hardware/radio/V1_2/CellIdentityLte;->bandwidth:I

    iget-object v8, v1, Landroid/hardware/radio/V1_2/CellIdentityLte;->base:Landroid/hardware/radio/V1_0/CellIdentityLte;

    iget-object v9, v8, Landroid/hardware/radio/V1_0/CellIdentityLte;->mcc:Ljava/lang/String;

    iget-object v10, v8, Landroid/hardware/radio/V1_0/CellIdentityLte;->mnc:Ljava/lang/String;

    iget-object v1, v1, Landroid/hardware/radio/V1_2/CellIdentityLte;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v11, v1, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v12, v1, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    iget-object v13, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;->additionalPlmns:Ljava/util/ArrayList;

    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellIdentityLte;->optionalCsgInfo:Landroid/hardware/radio/V1_5/OptionalCsgInfo;

    .line 2839
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/V1_5/OptionalCsgInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object v0

    move-object v1, v14

    move-object v8, v9

    move-object v9, v10

    move-object v10, v11

    move-object v11, v12

    move-object v12, v13

    move-object v13, v0

    invoke-direct/range {v1 .. v13}, Landroid/telephony/CellIdentityLte;-><init>(IIII[IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v14

    :cond_3
    return-object v1
.end method

.method public static convertHalCellIdentityNr(Landroid/hardware/radio/network/CellIdentityNr;)Landroid/telephony/CellIdentityNr;
    .locals 13

    .line 2976
    new-instance v12, Landroid/telephony/CellIdentityNr;

    iget v1, p0, Landroid/hardware/radio/network/CellIdentityNr;->pci:I

    iget v2, p0, Landroid/hardware/radio/network/CellIdentityNr;->tac:I

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityNr;->nrarfcn:I

    iget-object v4, p0, Landroid/hardware/radio/network/CellIdentityNr;->bands:[I

    iget-object v5, p0, Landroid/hardware/radio/network/CellIdentityNr;->mcc:Ljava/lang/String;

    iget-object v6, p0, Landroid/hardware/radio/network/CellIdentityNr;->mnc:Ljava/lang/String;

    iget-wide v7, p0, Landroid/hardware/radio/network/CellIdentityNr;->nci:J

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityNr;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v9, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v10, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityNr;->additionalPlmns:[Ljava/lang/String;

    .line 2978
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v11

    move-object v0, v12

    invoke-direct/range {v0 .. v11}, Landroid/telephony/CellIdentityNr;-><init>(III[ILjava/lang/String;Ljava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v12
.end method

.method public static convertHalCellIdentityNr(Ljava/lang/Object;)Landroid/telephony/CellIdentityNr;
    .locals 13

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2951
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;

    if-eqz v1, :cond_1

    .line 2952
    check-cast p0, Landroid/hardware/radio/V1_4/CellIdentityNr;

    .line 2954
    new-instance v12, Landroid/telephony/CellIdentityNr;

    iget v1, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->pci:I

    iget v2, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->tac:I

    iget v3, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->nrarfcn:I

    const/4 v0, 0x0

    new-array v4, v0, [I

    iget-object v5, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->mcc:Ljava/lang/String;

    iget-object v6, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->mnc:Ljava/lang/String;

    iget-wide v7, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->nci:J

    iget-object p0, p0, Landroid/hardware/radio/V1_4/CellIdentityNr;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v9, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v10, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    new-instance v11, Landroid/util/ArraySet;

    invoke-direct {v11}, Landroid/util/ArraySet;-><init>()V

    move-object v0, v12

    invoke-direct/range {v0 .. v11}, Landroid/telephony/CellIdentityNr;-><init>(III[ILjava/lang/String;Ljava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v12

    .line 2957
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_5/CellIdentityNr;

    if-eqz v1, :cond_2

    .line 2958
    check-cast p0, Landroid/hardware/radio/V1_5/CellIdentityNr;

    .line 2960
    new-instance v12, Landroid/telephony/CellIdentityNr;

    iget-object v0, p0, Landroid/hardware/radio/V1_5/CellIdentityNr;->base:Landroid/hardware/radio/V1_4/CellIdentityNr;

    iget v1, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->pci:I

    iget v2, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->tac:I

    iget v3, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->nrarfcn:I

    iget-object v0, p0, Landroid/hardware/radio/V1_5/CellIdentityNr;->bands:Ljava/util/ArrayList;

    .line 2961
    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v4, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;

    invoke-direct {v4}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;-><init>()V

    invoke-interface {v0, v4}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object v4

    iget-object v0, p0, Landroid/hardware/radio/V1_5/CellIdentityNr;->base:Landroid/hardware/radio/V1_4/CellIdentityNr;

    iget-object v5, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->mcc:Ljava/lang/String;

    iget-object v6, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->mnc:Ljava/lang/String;

    iget-wide v7, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->nci:J

    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellIdentityNr;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v9, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v10, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    iget-object v11, p0, Landroid/hardware/radio/V1_5/CellIdentityNr;->additionalPlmns:Ljava/util/ArrayList;

    move-object v0, v12

    invoke-direct/range {v0 .. v11}, Landroid/telephony/CellIdentityNr;-><init>(III[ILjava/lang/String;Ljava/lang/String;JLjava/lang/String;Ljava/lang/String;Ljava/util/Collection;)V

    return-object v12

    :cond_2
    return-object v0
.end method

.method public static convertHalCellIdentityTdscdma(Landroid/hardware/radio/network/CellIdentityTdscdma;)Landroid/telephony/CellIdentityTdscdma;
    .locals 12

    .line 2938
    new-instance v11, Landroid/telephony/CellIdentityTdscdma;

    iget-object v1, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->mcc:Ljava/lang/String;

    iget-object v2, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->mnc:Ljava/lang/String;

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->lac:I

    iget v4, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->cid:I

    iget v5, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->cpid:I

    iget v6, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->uarfcn:I

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v7, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v8, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->additionalPlmns:[Ljava/lang/String;

    .line 2940
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v9

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityTdscdma;->csgInfo:Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;

    .line 2941
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object v10

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityTdscdma;-><init>(Ljava/lang/String;Ljava/lang/String;IIIILjava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11
.end method

.method public static convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;
    .locals 12

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2908
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;

    if-eqz v1, :cond_1

    .line 2909
    check-cast p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;

    .line 2911
    new-instance v11, Landroid/telephony/CellIdentityTdscdma;

    iget-object v1, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mcc:Ljava/lang/String;

    iget-object v2, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mnc:Ljava/lang/String;

    iget v3, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->lac:I

    iget v4, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cid:I

    iget v5, p0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cpid:I

    const v6, 0x7fffffff

    .line 2912
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v9

    const/4 v10, 0x0

    const-string v7, ""

    const-string v8, ""

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityTdscdma;-><init>(Ljava/lang/String;Ljava/lang/String;IIIILjava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    .line 2913
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;

    if-eqz v1, :cond_2

    .line 2914
    check-cast p0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;

    .line 2916
    new-instance v11, Landroid/telephony/CellIdentityTdscdma;

    iget-object v0, p0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->base:Landroid/hardware/radio/V1_0/CellIdentityTdscdma;

    iget-object v1, v0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mcc:Ljava/lang/String;

    iget-object v2, v0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mnc:Ljava/lang/String;

    iget v3, v0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->lac:I

    iget v4, v0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cid:I

    iget v5, v0, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cpid:I

    iget v6, p0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->uarfcn:I

    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v7, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v8, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    .line 2918
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v9

    const/4 v10, 0x0

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityTdscdma;-><init>(Ljava/lang/String;Ljava/lang/String;IIIILjava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    .line 2919
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_5/CellIdentityTdscdma;

    if-eqz v1, :cond_3

    .line 2920
    check-cast p0, Landroid/hardware/radio/V1_5/CellIdentityTdscdma;

    .line 2922
    new-instance v11, Landroid/telephony/CellIdentityTdscdma;

    iget-object v0, p0, Landroid/hardware/radio/V1_5/CellIdentityTdscdma;->base:Landroid/hardware/radio/V1_2/CellIdentityTdscdma;

    iget-object v1, v0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->base:Landroid/hardware/radio/V1_0/CellIdentityTdscdma;

    iget-object v2, v1, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mcc:Ljava/lang/String;

    iget-object v3, v1, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->mnc:Ljava/lang/String;

    iget v4, v1, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->lac:I

    iget v5, v1, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cid:I

    iget v6, v1, Landroid/hardware/radio/V1_0/CellIdentityTdscdma;->cpid:I

    iget v7, v0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->uarfcn:I

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellIdentityTdscdma;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v8, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v9, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    iget-object v10, p0, Landroid/hardware/radio/V1_5/CellIdentityTdscdma;->additionalPlmns:Ljava/util/ArrayList;

    iget-object p0, p0, Landroid/hardware/radio/V1_5/CellIdentityTdscdma;->optionalCsgInfo:Landroid/hardware/radio/V1_5/OptionalCsgInfo;

    .line 2925
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/V1_5/OptionalCsgInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object p0

    move-object v0, v11

    move-object v1, v2

    move-object v2, v3

    move v3, v4

    move v4, v5

    move v5, v6

    move v6, v7

    move-object v7, v8

    move-object v8, v9

    move-object v9, v10

    move-object v10, p0

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityTdscdma;-><init>(Ljava/lang/String;Ljava/lang/String;IIIILjava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    :cond_3
    return-object v0
.end method

.method public static convertHalCellIdentityWcdma(Landroid/hardware/radio/network/CellIdentityWcdma;)Landroid/telephony/CellIdentityWcdma;
    .locals 12

    .line 2895
    new-instance v11, Landroid/telephony/CellIdentityWcdma;

    iget v1, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->lac:I

    iget v2, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->cid:I

    iget v3, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->psc:I

    iget v4, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->uarfcn:I

    iget-object v5, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->mcc:Ljava/lang/String;

    iget-object v6, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->mnc:Ljava/lang/String;

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->operatorNames:Landroid/hardware/radio/network/OperatorInfo;

    iget-object v7, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaLong:Ljava/lang/String;

    iget-object v8, v0, Landroid/hardware/radio/network/OperatorInfo;->alphaShort:Ljava/lang/String;

    iget-object v0, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->additionalPlmns:[Ljava/lang/String;

    .line 2897
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v9

    iget-object p0, p0, Landroid/hardware/radio/network/CellIdentityWcdma;->csgInfo:Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;

    .line 2898
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object v10

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityWcdma;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11
.end method

.method public static convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;
    .locals 12

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2865
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;

    if-eqz v1, :cond_1

    .line 2866
    check-cast p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;

    .line 2868
    new-instance v11, Landroid/telephony/CellIdentityWcdma;

    iget v1, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->lac:I

    iget v2, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->cid:I

    iget v3, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->psc:I

    iget v4, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->uarfcn:I

    iget-object v5, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mcc:Ljava/lang/String;

    iget-object v6, p0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mnc:Ljava/lang/String;

    new-instance v9, Landroid/util/ArraySet;

    invoke-direct {v9}, Landroid/util/ArraySet;-><init>()V

    const/4 v10, 0x0

    const-string v7, ""

    const-string v8, ""

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityWcdma;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    .line 2870
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;

    if-eqz v1, :cond_2

    .line 2871
    check-cast p0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;

    .line 2873
    new-instance v11, Landroid/telephony/CellIdentityWcdma;

    iget-object v0, p0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;->base:Landroid/hardware/radio/V1_0/CellIdentityWcdma;

    iget v1, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->lac:I

    iget v2, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->cid:I

    iget v3, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->psc:I

    iget v4, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->uarfcn:I

    iget-object v5, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mcc:Ljava/lang/String;

    iget-object v6, v0, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mnc:Ljava/lang/String;

    iget-object p0, p0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v7, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v8, p0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    new-instance v9, Landroid/util/ArraySet;

    invoke-direct {v9}, Landroid/util/ArraySet;-><init>()V

    const/4 v10, 0x0

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityWcdma;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    .line 2876
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_5/CellIdentityWcdma;

    if-eqz v1, :cond_3

    .line 2877
    check-cast p0, Landroid/hardware/radio/V1_5/CellIdentityWcdma;

    .line 2879
    new-instance v11, Landroid/telephony/CellIdentityWcdma;

    iget-object v0, p0, Landroid/hardware/radio/V1_5/CellIdentityWcdma;->base:Landroid/hardware/radio/V1_2/CellIdentityWcdma;

    iget-object v1, v0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;->base:Landroid/hardware/radio/V1_0/CellIdentityWcdma;

    iget v2, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->lac:I

    iget v3, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->cid:I

    iget v4, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->psc:I

    iget v5, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->uarfcn:I

    iget-object v6, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mcc:Ljava/lang/String;

    iget-object v7, v1, Landroid/hardware/radio/V1_0/CellIdentityWcdma;->mnc:Ljava/lang/String;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellIdentityWcdma;->operatorNames:Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;

    iget-object v8, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaLong:Ljava/lang/String;

    iget-object v9, v0, Landroid/hardware/radio/V1_2/CellIdentityOperatorNames;->alphaShort:Ljava/lang/String;

    iget-object v10, p0, Landroid/hardware/radio/V1_5/CellIdentityWcdma;->additionalPlmns:Ljava/util/ArrayList;

    iget-object p0, p0, Landroid/hardware/radio/V1_5/CellIdentityWcdma;->optionalCsgInfo:Landroid/hardware/radio/V1_5/OptionalCsgInfo;

    .line 2882
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/V1_5/OptionalCsgInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;

    move-result-object p0

    move-object v0, v11

    move v1, v2

    move v2, v3

    move v3, v4

    move v4, v5

    move-object v5, v6

    move-object v6, v7

    move-object v7, v8

    move-object v8, v9

    move-object v9, v10

    move-object v10, p0

    invoke-direct/range {v0 .. v10}, Landroid/telephony/CellIdentityWcdma;-><init>(IIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Collection;Landroid/telephony/ClosedSubscriberGroupInfo;)V

    return-object v11

    :cond_3
    return-object v0
.end method

.method private static convertHalCellInfo(Landroid/hardware/radio/network/CellInfo;J)Landroid/telephony/CellInfo;
    .locals 9

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2579
    :cond_0
    iget v2, p0, Landroid/hardware/radio/network/CellInfo;->connectionStatus:I

    .line 2580
    iget-boolean v3, p0, Landroid/hardware/radio/network/CellInfo;->registered:Z

    .line 2581
    iget-object v1, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    invoke-virtual {v1}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getTag()I

    move-result v1

    if-eqz v1, :cond_6

    const/4 v4, 0x1

    if-eq v1, v4, :cond_5

    const/4 v4, 0x2

    if-eq v1, v4, :cond_4

    const/4 v4, 0x3

    if-eq v1, v4, :cond_3

    const/4 v4, 0x4

    if-eq v1, v4, :cond_2

    const/4 v4, 0x5

    if-eq v1, v4, :cond_1

    return-object v0

    .line 2588
    :cond_1
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    .line 2589
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getCdma()Landroid/hardware/radio/network/CellInfoCdma;

    move-result-object p0

    .line 2590
    new-instance v0, Landroid/telephony/CellInfoCdma;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/network/CellIdentityCdma;

    .line 2591
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Landroid/hardware/radio/network/CellIdentityCdma;)Landroid/telephony/CellIdentityCdma;

    move-result-object v6

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/network/CdmaSignalStrength;

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/network/EvdoSignalStrength;

    .line 2592
    invoke-static {v1, p0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/network/CdmaSignalStrength;Landroid/hardware/radio/network/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v7

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v7}, Landroid/telephony/CellInfoCdma;-><init>(IZJLandroid/telephony/CellIdentityCdma;Landroid/telephony/CellSignalStrengthCdma;)V

    return-object v0

    .line 2612
    :cond_2
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getNr()Landroid/hardware/radio/network/CellInfoNr;

    move-result-object p0

    .line 2613
    new-instance v0, Landroid/telephony/CellInfoNr;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoNr;->cellIdentityNr:Landroid/hardware/radio/network/CellIdentityNr;

    .line 2614
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Landroid/hardware/radio/network/CellIdentityNr;)Landroid/telephony/CellIdentityNr;

    move-result-object v6

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoNr;->signalStrengthNr:Landroid/hardware/radio/network/NrSignalStrength;

    .line 2615
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Landroid/hardware/radio/network/NrSignalStrength;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v7

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v7}, Landroid/telephony/CellInfoNr;-><init>(IZJLandroid/telephony/CellIdentityNr;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v0

    .line 2595
    :cond_3
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getLte()Landroid/hardware/radio/network/CellInfoLte;

    move-result-object p0

    .line 2596
    new-instance v0, Landroid/telephony/CellInfoLte;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/network/CellIdentityLte;

    .line 2597
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Landroid/hardware/radio/network/CellIdentityLte;)Landroid/telephony/CellIdentityLte;

    move-result-object v6

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/network/LteSignalStrength;

    .line 2598
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Landroid/hardware/radio/network/LteSignalStrength;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v7

    new-instance v8, Landroid/telephony/CellConfigLte;

    invoke-direct {v8}, Landroid/telephony/CellConfigLte;-><init>()V

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v8}, Landroid/telephony/CellInfoLte;-><init>(IZJLandroid/telephony/CellIdentityLte;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellConfigLte;)V

    return-object v0

    .line 2606
    :cond_4
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    .line 2607
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getTdscdma()Landroid/hardware/radio/network/CellInfoTdscdma;

    move-result-object p0

    .line 2608
    new-instance v0, Landroid/telephony/CellInfoTdscdma;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/network/CellIdentityTdscdma;

    .line 2609
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Landroid/hardware/radio/network/CellIdentityTdscdma;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v6

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/network/TdscdmaSignalStrength;

    .line 2610
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Landroid/hardware/radio/network/TdscdmaSignalStrength;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v7

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v7}, Landroid/telephony/CellInfoTdscdma;-><init>(IZJLandroid/telephony/CellIdentityTdscdma;Landroid/telephony/CellSignalStrengthTdscdma;)V

    return-object v0

    .line 2600
    :cond_5
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    .line 2601
    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getWcdma()Landroid/hardware/radio/network/CellInfoWcdma;

    move-result-object p0

    .line 2602
    new-instance v0, Landroid/telephony/CellInfoWcdma;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/network/CellIdentityWcdma;

    .line 2603
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Landroid/hardware/radio/network/CellIdentityWcdma;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v6

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/network/WcdmaSignalStrength;

    .line 2604
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Landroid/hardware/radio/network/WcdmaSignalStrength;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v7

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v7}, Landroid/telephony/CellInfoWcdma;-><init>(IZJLandroid/telephony/CellIdentityWcdma;Landroid/telephony/CellSignalStrengthWcdma;)V

    return-object v0

    .line 2583
    :cond_6
    iget-object p0, p0, Landroid/hardware/radio/network/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/network/CellInfoRatSpecificInfo;

    invoke-virtual {p0}, Landroid/hardware/radio/network/CellInfoRatSpecificInfo;->getGsm()Landroid/hardware/radio/network/CellInfoGsm;

    move-result-object p0

    .line 2584
    new-instance v0, Landroid/telephony/CellInfoGsm;

    iget-object v1, p0, Landroid/hardware/radio/network/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/network/CellIdentityGsm;

    .line 2585
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Landroid/hardware/radio/network/CellIdentityGsm;)Landroid/telephony/CellIdentityGsm;

    move-result-object v6

    iget-object p0, p0, Landroid/hardware/radio/network/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/network/GsmSignalStrength;

    .line 2586
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/network/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v7

    move-object v1, v0

    move-wide v4, p1

    invoke-direct/range {v1 .. v7}, Landroid/telephony/CellInfoGsm;-><init>(IZJLandroid/telephony/CellIdentityGsm;Landroid/telephony/CellSignalStrengthGsm;)V

    return-object v0
.end method

.method private static convertHalCellInfo(Ljava/lang/Object;J)Landroid/telephony/CellInfo;
    .locals 25

    move-object/from16 v0, p0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 2312
    :cond_0
    instance-of v2, v0, Landroid/hardware/radio/V1_0/CellInfo;

    const/4 v3, 0x0

    const/4 v4, 0x5

    const/4 v5, 0x4

    const/4 v6, 0x3

    const/4 v7, 0x2

    const/4 v8, 0x1

    if-eqz v2, :cond_6

    .line 2313
    check-cast v0, Landroid/hardware/radio/V1_0/CellInfo;

    const v2, 0x7fffffff

    .line 2316
    iget-boolean v9, v0, Landroid/hardware/radio/V1_0/CellInfo;->registered:Z

    .line 2317
    iget v10, v0, Landroid/hardware/radio/V1_0/CellInfo;->cellInfoType:I

    if-eq v10, v8, :cond_5

    if-eq v10, v7, :cond_4

    if-eq v10, v6, :cond_3

    if-eq v10, v5, :cond_2

    if-eq v10, v4, :cond_1

    return-object v1

    .line 2346
    :cond_1
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfo;->tdscdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/CellInfoTdscdma;

    .line 2347
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/V1_0/CellIdentityTdscdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v3

    .line 2348
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v0

    move-object v6, v0

    move-object v0, v1

    move-object v5, v0

    move-object v7, v5

    move-object v8, v7

    move-object v10, v8

    move-object v11, v10

    move-object v14, v11

    move-object v12, v3

    move v13, v4

    move-object v3, v14

    move-object v4, v3

    goto/16 :goto_0

    .line 2340
    :cond_2
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfo;->wcdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/CellInfoWcdma;

    .line 2341
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/V1_0/CellIdentityWcdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v3

    .line 2342
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/V1_0/WcdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v0

    move-object v4, v1

    move-object v6, v4

    move-object v7, v6

    move-object v8, v7

    move-object v10, v8

    move-object v12, v10

    move-object v14, v12

    move-object v11, v3

    move v13, v5

    move-object v5, v0

    move-object v0, v14

    move-object v3, v0

    goto/16 :goto_0

    .line 2333
    :cond_3
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfo;->lte:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/CellInfoLte;

    .line 2334
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/V1_0/CellIdentityLte;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object v3

    .line 2335
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v0

    .line 2336
    new-instance v4, Landroid/telephony/CellConfigLte;

    invoke-direct {v4}, Landroid/telephony/CellConfigLte;-><init>()V

    move-object v5, v1

    move-object v7, v5

    move-object v8, v7

    move-object v11, v8

    move-object v12, v11

    move-object v10, v3

    move-object v14, v4

    move v13, v6

    move-object v4, v0

    move-object v0, v12

    move-object v3, v0

    move-object v6, v3

    goto :goto_0

    .line 2326
    :cond_4
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfo;->cdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/CellInfoCdma;

    .line 2327
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/V1_0/CellIdentityCdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object v3

    .line 2328
    iget-object v4, v0, Landroid/hardware/radio/V1_0/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    invoke-static {v4, v0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v0

    move-object v4, v1

    move-object v5, v4

    move-object v6, v5

    move-object v10, v6

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v8, v3

    move v13, v7

    move-object v3, v0

    move-object v0, v14

    move-object v7, v0

    goto :goto_0

    .line 2320
    :cond_5
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfo;->gsm:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/CellInfoGsm;

    .line 2321
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/V1_0/CellIdentityGsm;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    .line 2322
    iget-object v0, v0, Landroid/hardware/radio/V1_0/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v0

    move-object v4, v1

    move-object v5, v4

    move-object v6, v5

    move-object v10, v6

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v7, v3

    move v13, v8

    move-object v3, v14

    move-object v8, v3

    :goto_0
    move-object/from16 v23, v0

    move-object/from16 v22, v7

    move-object v7, v8

    move-object v0, v11

    move-object v15, v12

    move-object/from16 v16, v14

    move-object v8, v3

    move-object v3, v6

    move v11, v9

    move-object v14, v10

    move v10, v2

    move-object v6, v4

    move-object v2, v1

    move-object v4, v2

    goto/16 :goto_b

    .line 2352
    :cond_6
    instance-of v2, v0, Landroid/hardware/radio/V1_2/CellInfo;

    if-eqz v2, :cond_c

    .line 2353
    check-cast v0, Landroid/hardware/radio/V1_2/CellInfo;

    .line 2355
    iget v2, v0, Landroid/hardware/radio/V1_2/CellInfo;->connectionStatus:I

    .line 2356
    iget-boolean v9, v0, Landroid/hardware/radio/V1_2/CellInfo;->registered:Z

    .line 2357
    iget v10, v0, Landroid/hardware/radio/V1_2/CellInfo;->cellInfoType:I

    if-eq v10, v8, :cond_b

    if-eq v10, v7, :cond_a

    if-eq v10, v6, :cond_9

    if-eq v10, v5, :cond_8

    if-eq v10, v4, :cond_7

    return-object v1

    .line 2386
    :cond_7
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfo;->tdscdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_2/CellInfoTdscdma;

    .line 2387
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/V1_2/CellIdentityTdscdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v3

    .line 2388
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v0

    move-object v7, v0

    move-object v0, v1

    move-object v5, v0

    move-object v6, v5

    move-object v8, v6

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v13, v3

    goto/16 :goto_1

    .line 2380
    :cond_8
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfo;->wcdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_2/CellInfoWcdma;

    .line 2381
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/V1_2/CellIdentityWcdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v3

    .line 2382
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v0

    move-object v6, v0

    move-object v0, v1

    move-object v7, v0

    move-object v8, v7

    move-object v10, v8

    move-object v11, v10

    move-object v13, v11

    move-object v14, v13

    move-object v12, v3

    move v4, v5

    move-object v3, v14

    move-object v5, v3

    goto/16 :goto_2

    .line 2373
    :cond_9
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfo;->lte:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_2/CellInfoLte;

    .line 2374
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/V1_2/CellIdentityLte;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object v3

    .line 2375
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v0

    .line 2376
    new-instance v4, Landroid/telephony/CellConfigLte;

    invoke-direct {v4}, Landroid/telephony/CellConfigLte;-><init>()V

    move-object v5, v0

    move-object v0, v1

    move-object v7, v0

    move-object v8, v7

    move-object v10, v8

    move-object v12, v10

    move-object v13, v12

    move-object v11, v3

    move-object v14, v4

    move v4, v6

    move-object v3, v13

    move-object v6, v3

    goto :goto_2

    .line 2366
    :cond_a
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfo;->cdma:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_2/CellInfoCdma;

    .line 2367
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/V1_2/CellIdentityCdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object v3

    .line 2368
    iget-object v4, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    invoke-static {v4, v0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v0

    move-object v5, v1

    move-object v6, v5

    move-object v8, v6

    move-object v11, v8

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object v10, v3

    move v4, v7

    move-object v3, v0

    move-object v0, v14

    move-object v7, v0

    goto :goto_2

    .line 2360
    :cond_b
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfo;->gsm:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_2/CellInfoGsm;

    .line 2361
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/V1_2/CellIdentityGsm;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    .line 2362
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v0

    move-object v5, v1

    move-object v6, v5

    move-object v7, v6

    move-object v10, v7

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move v4, v8

    move-object v8, v3

    :goto_1
    move-object v3, v14

    :goto_2
    move-object/from16 v23, v0

    move-object/from16 v22, v8

    move-object v0, v12

    move-object v15, v13

    move-object/from16 v16, v14

    move-object v8, v3

    move v13, v4

    move-object v3, v7

    move-object v7, v10

    move-object v14, v11

    move-object v4, v1

    move v10, v2

    move v11, v9

    move-object v2, v4

    move-object/from16 v24, v6

    move-object v6, v5

    move-object/from16 v5, v24

    goto/16 :goto_b

    .line 2392
    :cond_c
    instance-of v2, v0, Landroid/hardware/radio/V1_4/CellInfo;

    const/4 v3, 0x6

    if-eqz v2, :cond_13

    .line 2393
    check-cast v0, Landroid/hardware/radio/V1_4/CellInfo;

    .line 2395
    iget v2, v0, Landroid/hardware/radio/V1_4/CellInfo;->connectionStatus:I

    .line 2396
    iget-boolean v9, v0, Landroid/hardware/radio/V1_4/CellInfo;->isRegistered:Z

    .line 2397
    iget-object v10, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v10}, Landroid/hardware/radio/V1_4/CellInfo$Info;->getDiscriminator()B

    move-result v10

    if-eqz v10, :cond_12

    if-eq v10, v8, :cond_11

    if-eq v10, v7, :cond_10

    if-eq v10, v6, :cond_f

    if-eq v10, v5, :cond_e

    if-eq v10, v4, :cond_d

    return-object v1

    .line 2432
    :cond_d
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->nr()Landroid/hardware/radio/V1_4/CellInfoNr;

    move-result-object v0

    .line 2433
    iget-object v4, v0, Landroid/hardware/radio/V1_4/CellInfoNr;->cellidentity:Landroid/hardware/radio/V1_4/CellIdentityNr;

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Ljava/lang/Object;)Landroid/telephony/CellIdentityNr;

    move-result-object v4

    .line 2434
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfoNr;->signalStrength:Landroid/hardware/radio/V1_4/NrSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v0

    move-object v6, v1

    move-object v8, v6

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move v5, v3

    move-object v7, v4

    move-object v3, v0

    move-object/from16 v0, v16

    move-object v4, v0

    goto/16 :goto_4

    .line 2413
    :cond_e
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->lte()Landroid/hardware/radio/V1_4/CellInfoLte;

    move-result-object v0

    .line 2414
    iget-object v3, v0, Landroid/hardware/radio/V1_4/CellInfoLte;->base:Landroid/hardware/radio/V1_2/CellInfoLte;

    iget-object v3, v3, Landroid/hardware/radio/V1_2/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/V1_2/CellIdentityLte;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object v3

    .line 2415
    iget-object v4, v0, Landroid/hardware/radio/V1_4/CellInfoLte;->base:Landroid/hardware/radio/V1_2/CellInfoLte;

    iget-object v4, v4, Landroid/hardware/radio/V1_2/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v4

    .line 2416
    new-instance v5, Landroid/telephony/CellConfigLte;

    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfoLte;->cellConfig:Landroid/hardware/radio/V1_4/CellConfigLte;

    iget-boolean v0, v0, Landroid/hardware/radio/V1_4/CellConfigLte;->isEndcAvailable:Z

    invoke-direct {v5, v0}, Landroid/telephony/CellConfigLte;-><init>(Z)V

    move-object v0, v1

    move-object v7, v0

    move-object v8, v7

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v15, v14

    move-object v13, v3

    move-object/from16 v16, v5

    move v5, v6

    move-object v3, v15

    move-object v6, v4

    goto :goto_3

    .line 2426
    :cond_f
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->tdscdma()Landroid/hardware/radio/V1_2/CellInfoTdscdma;

    move-result-object v0

    .line 2427
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/V1_2/CellIdentityTdscdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v3

    .line 2428
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v0

    move-object v10, v0

    move-object v0, v1

    move-object v6, v0

    move-object v7, v6

    move-object v8, v7

    move-object v11, v8

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object/from16 v16, v14

    move-object v15, v3

    move v5, v4

    move-object/from16 v3, v16

    :goto_3
    move-object v4, v3

    goto/16 :goto_4

    .line 2420
    :cond_10
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->wcdma()Landroid/hardware/radio/V1_2/CellInfoWcdma;

    move-result-object v0

    .line 2421
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/V1_2/CellIdentityWcdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v3

    .line 2422
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v0

    move-object v8, v0

    move-object v0, v1

    move-object v4, v0

    move-object v6, v4

    move-object v7, v6

    move-object v10, v7

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v15, v13

    move-object/from16 v16, v15

    move-object v14, v3

    move-object/from16 v3, v16

    goto :goto_4

    .line 2406
    :cond_11
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->cdma()Landroid/hardware/radio/V1_2/CellInfoCdma;

    move-result-object v0

    .line 2407
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/V1_2/CellIdentityCdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object v3

    .line 2408
    iget-object v4, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    invoke-static {v4, v0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v0

    move-object v4, v0

    move-object v0, v1

    move-object v6, v0

    move-object v8, v6

    move-object v10, v8

    move-object v11, v10

    move-object v13, v11

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move-object v12, v3

    move v5, v7

    move-object/from16 v3, v16

    move-object v7, v3

    goto :goto_4

    .line 2400
    :cond_12
    iget-object v0, v0, Landroid/hardware/radio/V1_4/CellInfo;->info:Landroid/hardware/radio/V1_4/CellInfo$Info;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_4/CellInfo$Info;->gsm()Landroid/hardware/radio/V1_2/CellInfoGsm;

    move-result-object v0

    .line 2401
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/V1_2/CellIdentityGsm;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    .line 2402
    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v0

    move-object v4, v1

    move-object v6, v4

    move-object v7, v6

    move-object v10, v7

    move-object v12, v10

    move-object v13, v12

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move-object v11, v3

    move v5, v8

    move-object/from16 v3, v16

    move-object v8, v3

    :goto_4
    move-object/from16 v23, v0

    move-object/from16 v22, v11

    move-object v0, v14

    move v11, v9

    move-object v14, v13

    move v13, v5

    move-object v5, v8

    move-object v8, v4

    move-object v4, v3

    move-object v3, v10

    move v10, v2

    move-object v2, v7

    move-object v7, v12

    goto/16 :goto_b

    .line 2438
    :cond_13
    instance-of v2, v0, Landroid/hardware/radio/V1_5/CellInfo;

    if-eqz v2, :cond_1a

    .line 2439
    check-cast v0, Landroid/hardware/radio/V1_5/CellInfo;

    .line 2441
    iget v2, v0, Landroid/hardware/radio/V1_5/CellInfo;->connectionStatus:I

    .line 2442
    iget-boolean v9, v0, Landroid/hardware/radio/V1_5/CellInfo;->registered:Z

    .line 2443
    iget-object v10, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v10}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->getDiscriminator()B

    move-result v10

    if-eqz v10, :cond_19

    if-eq v10, v8, :cond_18

    if-eq v10, v7, :cond_17

    if-eq v10, v6, :cond_16

    if-eq v10, v5, :cond_15

    if-eq v10, v4, :cond_14

    return-object v1

    .line 2454
    :cond_14
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->cdma()Landroid/hardware/radio/V1_2/CellInfoCdma;

    move-result-object v0

    .line 2455
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/V1_2/CellIdentityCdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object v3

    .line 2456
    iget-object v4, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    invoke-static {v4, v0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v0

    :goto_5
    move-object v4, v1

    move-object v6, v4

    move-object v8, v6

    move-object v10, v8

    move-object v11, v10

    move-object v13, v11

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move-object v12, v3

    move v5, v7

    move-object v3, v0

    move-object/from16 v0, v16

    move-object v7, v0

    goto/16 :goto_a

    .line 2486
    :cond_15
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->nr()Landroid/hardware/radio/V1_5/CellInfoNr;

    move-result-object v0

    .line 2487
    iget-object v4, v0, Landroid/hardware/radio/V1_5/CellInfoNr;->cellIdentityNr:Landroid/hardware/radio/V1_5/CellIdentityNr;

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Ljava/lang/Object;)Landroid/telephony/CellIdentityNr;

    move-result-object v4

    .line 2488
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoNr;->signalStrengthNr:Landroid/hardware/radio/V1_4/NrSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v0

    :goto_6
    move-object v6, v1

    move-object v7, v6

    move-object v8, v7

    move-object v10, v8

    move-object v12, v10

    move-object v13, v12

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move v5, v3

    move-object v11, v4

    move-object v4, v0

    move-object/from16 v0, v16

    move-object v3, v0

    goto/16 :goto_a

    .line 2462
    :cond_16
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->lte()Landroid/hardware/radio/V1_5/CellInfoLte;

    move-result-object v0

    .line 2463
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/V1_5/CellIdentityLte;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object v3

    .line 2464
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v0

    .line 2465
    new-instance v4, Landroid/telephony/CellConfigLte;

    invoke-direct {v4}, Landroid/telephony/CellConfigLte;-><init>()V

    move-object v7, v1

    move-object v8, v7

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v15, v14

    move-object v13, v3

    move-object/from16 v16, v4

    move v5, v6

    move-object v6, v0

    move-object v0, v15

    move-object v3, v0

    goto :goto_7

    .line 2478
    :cond_17
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    .line 2479
    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->tdscdma()Landroid/hardware/radio/V1_5/CellInfoTdscdma;

    move-result-object v0

    .line 2480
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/V1_5/CellIdentityTdscdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v3

    .line 2481
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v0

    move-object v8, v0

    move-object v0, v1

    move-object v6, v0

    move-object v7, v6

    move-object v10, v7

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object/from16 v16, v14

    move-object v15, v3

    move v5, v4

    move-object/from16 v3, v16

    :goto_7
    move-object v4, v3

    goto :goto_a

    .line 2470
    :cond_18
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    .line 2471
    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->wcdma()Landroid/hardware/radio/V1_5/CellInfoWcdma;

    move-result-object v0

    .line 2472
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/V1_5/CellIdentityWcdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v3

    .line 2473
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v0

    :goto_8
    move-object v7, v0

    move-object v0, v1

    move-object v4, v0

    move-object v6, v4

    move-object v8, v6

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v15, v13

    move-object/from16 v16, v15

    move-object v14, v3

    move-object/from16 v3, v16

    goto :goto_a

    .line 2447
    :cond_19
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/CellInfo$CellInfoRatSpecificInfo;->gsm()Landroid/hardware/radio/V1_5/CellInfoGsm;

    move-result-object v0

    .line 2448
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/V1_5/CellIdentityGsm;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    .line 2449
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v0

    :goto_9
    move-object v4, v1

    move-object v6, v4

    move-object v7, v6

    move-object v11, v7

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object v15, v14

    move-object/from16 v16, v15

    move-object v10, v3

    move v5, v8

    move-object/from16 v3, v16

    move-object v8, v3

    :goto_a
    move-object/from16 v23, v0

    move-object/from16 v22, v10

    move-object v0, v14

    move v10, v2

    move-object v2, v11

    move-object v14, v13

    move v13, v5

    move-object v5, v7

    move v11, v9

    move-object v7, v12

    move-object/from16 v24, v8

    move-object v8, v3

    move-object/from16 v3, v24

    goto/16 :goto_b

    .line 2492
    :cond_1a
    instance-of v2, v0, Landroid/hardware/radio/V1_6/CellInfo;

    if-eqz v2, :cond_21

    .line 2493
    check-cast v0, Landroid/hardware/radio/V1_6/CellInfo;

    .line 2495
    iget v2, v0, Landroid/hardware/radio/V1_6/CellInfo;->connectionStatus:I

    .line 2496
    iget-boolean v9, v0, Landroid/hardware/radio/V1_6/CellInfo;->registered:Z

    .line 2497
    iget-object v10, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v10}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->getDiscriminator()B

    move-result v10

    if-eqz v10, :cond_20

    if-eq v10, v8, :cond_1f

    if-eq v10, v7, :cond_1e

    if-eq v10, v6, :cond_1d

    if-eq v10, v5, :cond_1c

    if-eq v10, v4, :cond_1b

    return-object v1

    .line 2508
    :cond_1b
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->cdma()Landroid/hardware/radio/V1_2/CellInfoCdma;

    move-result-object v0

    .line 2509
    iget-object v3, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->cellIdentityCdma:Landroid/hardware/radio/V1_2/CellIdentityCdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityCdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityCdma;

    move-result-object v3

    .line 2510
    iget-object v4, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthCdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v0, v0, Landroid/hardware/radio/V1_2/CellInfoCdma;->signalStrengthEvdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    invoke-static {v4, v0}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v0

    goto/16 :goto_5

    .line 2540
    :cond_1c
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->nr()Landroid/hardware/radio/V1_6/CellInfoNr;

    move-result-object v0

    .line 2541
    iget-object v4, v0, Landroid/hardware/radio/V1_6/CellInfoNr;->cellIdentityNr:Landroid/hardware/radio/V1_5/CellIdentityNr;

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityNr(Ljava/lang/Object;)Landroid/telephony/CellIdentityNr;

    move-result-object v4

    .line 2542
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfoNr;->signalStrengthNr:Landroid/hardware/radio/V1_6/NrSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v0

    goto/16 :goto_6

    .line 2516
    :cond_1d
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->lte()Landroid/hardware/radio/V1_6/CellInfoLte;

    move-result-object v0

    .line 2517
    iget-object v3, v0, Landroid/hardware/radio/V1_6/CellInfoLte;->cellIdentityLte:Landroid/hardware/radio/V1_5/CellIdentityLte;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityLte(Ljava/lang/Object;)Landroid/telephony/CellIdentityLte;

    move-result-object v3

    .line 2518
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfoLte;->signalStrengthLte:Landroid/hardware/radio/V1_6/LteSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v0

    .line 2519
    new-instance v4, Landroid/telephony/CellConfigLte;

    invoke-direct {v4}, Landroid/telephony/CellConfigLte;-><init>()V

    move-object v7, v1

    move-object v8, v7

    move-object v10, v8

    move-object v11, v10

    move-object v12, v11

    move-object v14, v12

    move-object v15, v14

    move-object v13, v3

    move-object/from16 v16, v4

    move v5, v6

    move-object v6, v0

    move-object v0, v15

    move-object v3, v0

    goto/16 :goto_7

    .line 2532
    :cond_1e
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    .line 2533
    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->tdscdma()Landroid/hardware/radio/V1_5/CellInfoTdscdma;

    move-result-object v0

    .line 2534
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoTdscdma;->cellIdentityTdscdma:Landroid/hardware/radio/V1_5/CellIdentityTdscdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityTdscdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityTdscdma;

    move-result-object v3

    .line 2535
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoTdscdma;->signalStrengthTdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v0

    move-object v8, v0

    move-object v0, v1

    move-object v6, v0

    move-object v7, v6

    move-object v10, v7

    move-object v11, v10

    move-object v12, v11

    move-object v13, v12

    move-object v14, v13

    move-object/from16 v16, v14

    move-object v15, v3

    move v5, v4

    move-object/from16 v3, v16

    goto/16 :goto_7

    .line 2524
    :cond_1f
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    .line 2525
    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->wcdma()Landroid/hardware/radio/V1_5/CellInfoWcdma;

    move-result-object v0

    .line 2526
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoWcdma;->cellIdentityWcdma:Landroid/hardware/radio/V1_5/CellIdentityWcdma;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityWcdma(Ljava/lang/Object;)Landroid/telephony/CellIdentityWcdma;

    move-result-object v3

    .line 2527
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoWcdma;->signalStrengthWcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v0

    goto/16 :goto_8

    .line 2501
    :cond_20
    iget-object v0, v0, Landroid/hardware/radio/V1_6/CellInfo;->ratSpecificInfo:Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/CellInfo$CellInfoRatSpecificInfo;->gsm()Landroid/hardware/radio/V1_5/CellInfoGsm;

    move-result-object v0

    .line 2502
    iget-object v3, v0, Landroid/hardware/radio/V1_5/CellInfoGsm;->cellIdentityGsm:Landroid/hardware/radio/V1_5/CellIdentityGsm;

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalCellIdentityGsm(Ljava/lang/Object;)Landroid/telephony/CellIdentityGsm;

    move-result-object v3

    .line 2503
    iget-object v0, v0, Landroid/hardware/radio/V1_5/CellInfoGsm;->signalStrengthGsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v0

    goto/16 :goto_9

    :goto_b
    packed-switch v13, :pswitch_data_0

    return-object v1

    .line 2563
    :pswitch_0
    new-instance v0, Landroid/telephony/CellInfoNr;

    move-object v9, v0

    move-wide/from16 v12, p1

    move-object v14, v2

    move-object v15, v4

    invoke-direct/range {v9 .. v15}, Landroid/telephony/CellInfoNr;-><init>(IZJLandroid/telephony/CellIdentityNr;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v0

    .line 2560
    :pswitch_1
    new-instance v0, Landroid/telephony/CellInfoTdscdma;

    move-object v9, v0

    move-wide/from16 v12, p1

    move-object v14, v15

    move-object v15, v3

    invoke-direct/range {v9 .. v15}, Landroid/telephony/CellInfoTdscdma;-><init>(IZJLandroid/telephony/CellIdentityTdscdma;Landroid/telephony/CellSignalStrengthTdscdma;)V

    return-object v0

    .line 2558
    :pswitch_2
    new-instance v1, Landroid/telephony/CellInfoWcdma;

    move-object v9, v1

    move-wide/from16 v12, p1

    move-object v14, v0

    move-object v15, v5

    invoke-direct/range {v9 .. v15}, Landroid/telephony/CellInfoWcdma;-><init>(IZJLandroid/telephony/CellIdentityWcdma;Landroid/telephony/CellSignalStrengthWcdma;)V

    return-object v1

    .line 2556
    :pswitch_3
    new-instance v0, Landroid/telephony/CellInfoLte;

    move-object v9, v0

    move-wide/from16 v12, p1

    move-object v15, v6

    invoke-direct/range {v9 .. v16}, Landroid/telephony/CellInfoLte;-><init>(IZJLandroid/telephony/CellIdentityLte;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellConfigLte;)V

    return-object v0

    .line 2554
    :pswitch_4
    new-instance v0, Landroid/telephony/CellInfoCdma;

    move-object v2, v0

    move v3, v10

    move v4, v11

    move-wide/from16 v5, p1

    invoke-direct/range {v2 .. v8}, Landroid/telephony/CellInfoCdma;-><init>(IZJLandroid/telephony/CellIdentityCdma;Landroid/telephony/CellSignalStrengthCdma;)V

    return-object v0

    .line 2552
    :pswitch_5
    new-instance v0, Landroid/telephony/CellInfoGsm;

    move-object/from16 v17, v0

    move/from16 v18, v10

    move/from16 v19, v11

    move-wide/from16 v20, p1

    invoke-direct/range {v17 .. v23}, Landroid/telephony/CellInfoGsm;-><init>(IZJLandroid/telephony/CellIdentityGsm;Landroid/telephony/CellSignalStrengthGsm;)V

    return-object v0

    :cond_21
    return-object v1

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertHalCellInfoList(Ljava/util/ArrayList;)Ljava/util/ArrayList;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Landroid/telephony/CellInfo;",
            ">;"
        }
    .end annotation

    .line 2263
    new-instance v0, Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 2264
    invoke-virtual {p0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v0

    .line 2265
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtimeNanos()J

    move-result-wide v1

    .line 2266
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    .line 2267
    invoke-static {v3, v1, v2}, Lcom/android/internal/telephony/RILUtils;->convertHalCellInfo(Ljava/lang/Object;J)Landroid/telephony/CellInfo;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method public static convertHalCellInfoList([Landroid/hardware/radio/network/CellInfo;)Ljava/util/ArrayList;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/hardware/radio/network/CellInfo;",
            ")",
            "Ljava/util/ArrayList<",
            "Landroid/telephony/CellInfo;",
            ">;"
        }
    .end annotation

    .line 2279
    new-instance v0, Ljava/util/ArrayList;

    array-length v1, p0

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 2280
    array-length v1, p0

    if-nez v1, :cond_0

    return-object v0

    .line 2281
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtimeNanos()J

    move-result-wide v1

    .line 2282
    array-length v3, p0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_1

    aget-object v5, p0, v4

    .line 2283
    invoke-static {v5, v1, v2}, Lcom/android/internal/telephony/RILUtils;->convertHalCellInfo(Landroid/hardware/radio/network/CellInfo;J)Landroid/telephony/CellInfo;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method private static convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/V1_5/OptionalCsgInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;
    .locals 3

    .line 3290
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/OptionalCsgInfo;->getDiscriminator()B

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    .line 3292
    invoke-virtual {p0}, Landroid/hardware/radio/V1_5/OptionalCsgInfo;->csgInfo()Landroid/hardware/radio/V1_5/ClosedSubscriberGroupInfo;

    move-result-object p0

    goto :goto_0

    :cond_0
    move-object p0, v1

    :goto_0
    if-nez p0, :cond_1

    return-object v1

    .line 3294
    :cond_1
    new-instance v0, Landroid/telephony/ClosedSubscriberGroupInfo;

    iget-boolean v1, p0, Landroid/hardware/radio/V1_5/ClosedSubscriberGroupInfo;->csgIndication:Z

    iget-object v2, p0, Landroid/hardware/radio/V1_5/ClosedSubscriberGroupInfo;->homeNodebName:Ljava/lang/String;

    iget p0, p0, Landroid/hardware/radio/V1_5/ClosedSubscriberGroupInfo;->csgIdentity:I

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/ClosedSubscriberGroupInfo;-><init>(ZLjava/lang/String;I)V

    return-object v0
.end method

.method private static convertHalClosedSubscriberGroupInfo(Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;)Landroid/telephony/ClosedSubscriberGroupInfo;
    .locals 3

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 3301
    :cond_0
    new-instance v0, Landroid/telephony/ClosedSubscriberGroupInfo;

    iget-boolean v1, p0, Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;->csgIndication:Z

    iget-object v2, p0, Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;->homeNodebName:Ljava/lang/String;

    iget p0, p0, Landroid/hardware/radio/network/ClosedSubscriberGroupInfo;->csgIdentity:I

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/ClosedSubscriberGroupInfo;-><init>(ZLjava/lang/String;I)V

    return-object v0
.end method

.method public static convertHalDataCallResult(Landroid/hardware/radio/data/SetupDataCallResult;)Landroid/telephony/data/DataCallResponse;
    .locals 14
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 3613
    :cond_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 3614
    iget-object v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->addresses:[Landroid/hardware/radio/data/LinkAddress;

    array-length v3, v2

    const/4 v4, 0x0

    move v5, v4

    :goto_0
    if-ge v5, v3, :cond_1

    aget-object v6, v2, v5

    .line 3615
    iget-object v7, v6, Landroid/hardware/radio/data/LinkAddress;->address:Ljava/lang/String;

    iget v8, v6, Landroid/hardware/radio/data/LinkAddress;->addressProperties:I

    iget-wide v9, v6, Landroid/hardware/radio/data/LinkAddress;->deprecationTime:J

    iget-wide v11, v6, Landroid/hardware/radio/data/LinkAddress;->expirationTime:J

    invoke-static/range {v7 .. v12}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;IJJ)Landroid/net/LinkAddress;

    move-result-object v6

    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 3618
    :cond_1
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 3619
    iget-object v3, p0, Landroid/hardware/radio/data/SetupDataCallResult;->dnses:[Ljava/lang/String;

    const-string v5, "RILUtils"

    if-eqz v3, :cond_2

    .line 3620
    array-length v6, v3

    move v7, v4

    :goto_1
    if-ge v7, v6, :cond_2

    aget-object v8, v3, v7

    .line 3621
    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    .line 3624
    :try_start_0
    invoke-static {v8}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v9

    .line 3625
    invoke-interface {v2, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception v9

    .line 3627
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "Unknown dns: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v5, v8, v9}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_2
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 3631
    :cond_2
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 3632
    iget-object v6, p0, Landroid/hardware/radio/data/SetupDataCallResult;->gateways:[Ljava/lang/String;

    if-eqz v6, :cond_3

    .line 3633
    array-length v7, v6

    move v8, v4

    :goto_3
    if-ge v8, v7, :cond_3

    aget-object v9, v6, v8

    .line 3634
    invoke-virtual {v9}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    .line 3637
    :try_start_1
    invoke-static {v9}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v10

    .line 3638
    invoke-interface {v3, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_4

    :catch_1
    move-exception v10

    .line 3640
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Unknown gateway: "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v5, v9, v10}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_4
    add-int/lit8 v8, v8, 0x1

    goto :goto_3

    .line 3644
    :cond_3
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6}, Ljava/util/ArrayList;-><init>()V

    .line 3645
    iget-object v7, p0, Landroid/hardware/radio/data/SetupDataCallResult;->pcscf:[Ljava/lang/String;

    if-eqz v7, :cond_4

    .line 3646
    array-length v8, v7

    move v9, v4

    :goto_5
    if-ge v9, v8, :cond_4

    aget-object v10, v7, v9

    .line 3647
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v10

    .line 3650
    :try_start_2
    invoke-static {v10}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v11

    .line 3651
    invoke-interface {v6, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_2
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_6

    :catch_2
    move-exception v11

    .line 3653
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "Unknown pcscf: "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v5, v10, v11}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_6
    add-int/lit8 v9, v9, 0x1

    goto :goto_5

    .line 3657
    :cond_4
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 3658
    iget-object v7, p0, Landroid/hardware/radio/data/SetupDataCallResult;->qosSessions:[Landroid/hardware/radio/data/QosSession;

    array-length v8, v7

    move v9, v4

    :goto_7
    if-ge v9, v8, :cond_5

    aget-object v10, v7, v9

    .line 3659
    invoke-static {v10}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBearerSession(Landroid/hardware/radio/data/QosSession;)Landroid/telephony/data/QosBearerSession;

    move-result-object v10

    invoke-interface {v5, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v9, v9, 0x1

    goto :goto_7

    .line 3661
    :cond_5
    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    .line 3662
    iget-object v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->trafficDescriptors:[Landroid/hardware/radio/data/TrafficDescriptor;

    array-length v9, v8

    :goto_8
    if-ge v4, v9, :cond_6

    aget-object v10, v8, v4

    .line 3664
    :try_start_3
    invoke-static {v10}, Lcom/android/internal/telephony/RILUtils;->convertHalTrafficDescriptor(Landroid/hardware/radio/data/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object v10

    invoke-interface {v7, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_3 .. :try_end_3} :catch_3

    goto :goto_9

    :catch_3
    move-exception v10

    .line 3666
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "convertHalDataCallResult: Failed to convert traffic descriptor. e="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v10}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :goto_9
    add-int/lit8 v4, v4, 0x1

    goto :goto_8

    .line 3670
    :cond_6
    new-instance v4, Landroid/telephony/data/DataCallResponse$Builder;

    invoke-direct {v4}, Landroid/telephony/data/DataCallResponse$Builder;-><init>()V

    iget v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->cause:I

    .line 3671
    invoke-virtual {v4, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setCause(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    iget-wide v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->suggestedRetryTime:J

    .line 3672
    invoke-virtual {v4, v8, v9}, Landroid/telephony/data/DataCallResponse$Builder;->setRetryDurationMillis(J)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    iget v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->cid:I

    .line 3673
    invoke-virtual {v4, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setId(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    iget v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->active:I

    .line 3674
    invoke-virtual {v4, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setLinkStatus(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    iget v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->type:I

    .line 3675
    invoke-virtual {v4, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setProtocolType(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    iget-object v8, p0, Landroid/hardware/radio/data/SetupDataCallResult;->ifname:Ljava/lang/String;

    .line 3676
    invoke-virtual {v4, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setInterfaceName(Ljava/lang/String;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v4

    .line 3677
    invoke-virtual {v4, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    .line 3678
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setDnsAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    .line 3679
    invoke-virtual {v1, v3}, Landroid/telephony/data/DataCallResponse$Builder;->setGatewayAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    .line 3680
    invoke-virtual {v1, v6}, Landroid/telephony/data/DataCallResponse$Builder;->setPcscfAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->mtuV4:I

    iget v3, p0, Landroid/hardware/radio/data/SetupDataCallResult;->mtuV6:I

    .line 3681
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setMtu(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->mtuV4:I

    .line 3682
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV4(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->mtuV6:I

    .line 3683
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV6(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget-byte v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->handoverFailureMode:B

    .line 3684
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setHandoverFailureMode(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->pduSessionId:I

    .line 3685
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setPduSessionId(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    iget-object v2, p0, Landroid/hardware/radio/data/SetupDataCallResult;->defaultQos:Landroid/hardware/radio/data/Qos;

    .line 3686
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalQos(Landroid/hardware/radio/data/Qos;)Landroid/telephony/data/Qos;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setDefaultQos(Landroid/telephony/data/Qos;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    .line 3687
    invoke-virtual {v1, v5}, Landroid/telephony/data/DataCallResponse$Builder;->setQosBearerSessions(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v1

    .line 3688
    iget-object p0, p0, Landroid/hardware/radio/data/SetupDataCallResult;->sliceInfo:Landroid/hardware/radio/data/SliceInfo;

    if-nez p0, :cond_7

    goto :goto_a

    .line 3689
    :cond_7
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalSliceInfo(Landroid/hardware/radio/data/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v0

    .line 3688
    :goto_a
    invoke-virtual {v1, v0}, Landroid/telephony/data/DataCallResponse$Builder;->setSliceInfo(Landroid/telephony/data/NetworkSliceInfo;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object p0

    .line 3690
    invoke-virtual {p0, v7}, Landroid/telephony/data/DataCallResponse$Builder;->setTrafficDescriptors(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object p0

    .line 3691
    invoke-virtual {p0}, Landroid/telephony/data/DataCallResponse$Builder;->build()Landroid/telephony/data/DataCallResponse;

    move-result-object p0

    return-object p0
.end method

.method public static convertHalDataCallResult(Ljava/lang/Object;)Landroid/telephony/data/DataCallResponse;
    .locals 30
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    move-object/from16 v0, p0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 3429
    :cond_0
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 3430
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 3432
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 3434
    instance-of v5, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;

    if-eqz v5, :cond_7

    .line 3435
    check-cast v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;

    .line 3437
    iget v5, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->status:I

    .line 3438
    iget v7, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->suggestedRetryTime:I

    int-to-long v7, v7

    .line 3439
    iget v9, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->cid:I

    .line 3440
    iget v10, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->active:I

    .line 3441
    iget-object v11, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->type:Ljava/lang/String;

    invoke-static {v11}, Landroid/telephony/data/ApnSetting;->getProtocolIntFromString(Ljava/lang/String;)I

    move-result v11

    .line 3442
    iget-object v12, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->ifname:Ljava/lang/String;

    .line 3443
    iget-object v13, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->addresses:Ljava/lang/String;

    invoke-static {v13}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v13

    const-string v14, "\\s+"

    if-nez v13, :cond_1

    .line 3444
    iget-object v13, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->addresses:Ljava/lang/String;

    invoke-virtual {v13, v14}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v13

    goto :goto_0

    :cond_1
    move-object v13, v1

    .line 3446
    :goto_0
    iget-object v15, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->dnses:Ljava/lang/String;

    invoke-static {v15}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v15

    if-nez v15, :cond_2

    .line 3447
    iget-object v15, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->dnses:Ljava/lang/String;

    invoke-virtual {v15, v14}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v15

    goto :goto_1

    :cond_2
    move-object v15, v1

    .line 3449
    :goto_1
    iget-object v1, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->gateways:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 3450
    iget-object v1, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->gateways:Ljava/lang/String;

    invoke-virtual {v1, v14}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    goto :goto_2

    :cond_3
    const/4 v1, 0x0

    .line 3452
    :goto_2
    iget-object v6, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->pcscf:Ljava/lang/String;

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_4

    .line 3453
    iget-object v6, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->pcscf:Ljava/lang/String;

    invoke-virtual {v6, v14}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    goto :goto_3

    :cond_4
    const/4 v6, 0x0

    .line 3455
    :goto_3
    iget v0, v0, Landroid/hardware/radio/V1_0/SetupDataCallResult;->mtu:I

    if-eqz v13, :cond_5

    .line 3457
    array-length v14, v13

    move/from16 p0, v0

    const/4 v0, 0x0

    :goto_4
    if-ge v0, v14, :cond_6

    aget-object v18, v13, v0

    move-object/from16 v19, v1

    .line 3458
    invoke-static/range {v18 .. v18}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v1

    invoke-interface {v2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    move-object/from16 v1, v19

    goto :goto_4

    :cond_5
    move/from16 p0, v0

    :cond_6
    move-object/from16 v19, v1

    move/from16 v13, p0

    move-object/from16 v18, v4

    move v4, v9

    move-object/from16 v1, v19

    const/16 v16, 0x0

    const/16 v20, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    move-object/from16 v19, v3

    move v9, v5

    move v5, v10

    move v3, v13

    move-object v10, v6

    move v6, v3

    goto/16 :goto_6

    .line 3461
    :cond_7
    instance-of v1, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;

    if-eqz v1, :cond_9

    .line 3462
    check-cast v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;

    .line 3464
    iget v5, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->cause:I

    .line 3465
    iget v1, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->suggestedRetryTime:I

    int-to-long v7, v1

    .line 3466
    iget v9, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->cid:I

    .line 3467
    iget v10, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->active:I

    .line 3468
    iget v11, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->type:I

    .line 3469
    iget-object v12, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->ifname:Ljava/lang/String;

    .line 3470
    iget-object v1, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->addresses:Ljava/util/ArrayList;

    const/4 v6, 0x0

    new-array v13, v6, [Ljava/lang/String;

    invoke-virtual {v1, v13}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Ljava/lang/String;

    .line 3471
    iget-object v13, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->dnses:Ljava/util/ArrayList;

    new-array v14, v6, [Ljava/lang/String;

    invoke-virtual {v13, v14}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v13

    move-object v15, v13

    check-cast v15, [Ljava/lang/String;

    .line 3472
    iget-object v13, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->gateways:Ljava/util/ArrayList;

    new-array v14, v6, [Ljava/lang/String;

    invoke-virtual {v13, v14}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v13

    check-cast v13, [Ljava/lang/String;

    .line 3473
    iget-object v14, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->pcscf:Ljava/util/ArrayList;

    move-object/from16 v18, v3

    new-array v3, v6, [Ljava/lang/String;

    invoke-virtual {v14, v3}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v3

    move-object v6, v3

    check-cast v6, [Ljava/lang/String;

    .line 3474
    iget v0, v0, Landroid/hardware/radio/V1_4/SetupDataCallResult;->mtu:I

    if-eqz v1, :cond_8

    .line 3476
    array-length v3, v1

    const/4 v14, 0x0

    :goto_5
    if-ge v14, v3, :cond_8

    aget-object v19, v1, v14

    move/from16 p0, v0

    .line 3477
    invoke-static/range {v19 .. v19}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v0

    invoke-interface {v2, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v14, v14, 0x1

    move/from16 v0, p0

    goto :goto_5

    :cond_8
    move/from16 p0, v0

    move/from16 v3, p0

    move-object v1, v13

    move-object/from16 v19, v18

    const/16 v16, 0x0

    const/16 v20, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    move v13, v3

    move-object/from16 v18, v4

    move v4, v9

    move v9, v5

    move v5, v10

    move-object v10, v6

    move v6, v13

    goto :goto_6

    :cond_9
    move-object/from16 v18, v3

    .line 3480
    instance-of v1, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;

    if-eqz v1, :cond_a

    .line 3481
    check-cast v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;

    .line 3483
    iget v5, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->cause:I

    .line 3484
    iget v1, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->suggestedRetryTime:I

    int-to-long v7, v1

    .line 3485
    iget v9, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->cid:I

    .line 3486
    iget v10, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->active:I

    .line 3487
    iget v11, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->type:I

    .line 3488
    iget-object v12, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->ifname:Ljava/lang/String;

    .line 3489
    iget-object v1, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->addresses:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda2;

    invoke-direct {v2}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda2;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 3491
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Ljava/util/List;

    .line 3492
    iget-object v1, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->dnses:Ljava/util/ArrayList;

    const/4 v3, 0x0

    new-array v6, v3, [Ljava/lang/String;

    invoke-virtual {v1, v6}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    move-object v15, v1

    check-cast v15, [Ljava/lang/String;

    .line 3493
    iget-object v1, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->gateways:Ljava/util/ArrayList;

    new-array v6, v3, [Ljava/lang/String;

    invoke-virtual {v1, v6}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Ljava/lang/String;

    .line 3494
    iget-object v6, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->pcscf:Ljava/util/ArrayList;

    new-array v13, v3, [Ljava/lang/String;

    invoke-virtual {v6, v13}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v3

    move-object v6, v3

    check-cast v6, [Ljava/lang/String;

    .line 3495
    iget v3, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->mtuV4:I

    iget v13, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->mtuV6:I

    invoke-static {v3, v13}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 3496
    iget v13, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->mtuV4:I

    .line 3497
    iget v0, v0, Landroid/hardware/radio/V1_5/SetupDataCallResult;->mtuV6:I

    move-object/from16 v19, v18

    const/16 v16, 0x0

    const/16 v20, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    move-object/from16 v18, v4

    move v4, v9

    move v9, v5

    move v5, v10

    move-object v10, v6

    move v6, v0

    :goto_6
    move-wide/from16 v28, v7

    move-object v7, v2

    move v8, v11

    move-object v2, v12

    move-object v12, v15

    move-wide/from16 v14, v28

    goto/16 :goto_a

    .line 3498
    :cond_a
    instance-of v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;

    if-eqz v1, :cond_11

    .line 3499
    check-cast v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;

    .line 3501
    iget v5, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->cause:I

    .line 3502
    iget-wide v7, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->suggestedRetryTime:J

    .line 3503
    iget v9, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->cid:I

    .line 3504
    iget v10, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->active:I

    .line 3505
    iget v11, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->type:I

    .line 3506
    iget-object v12, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->ifname:Ljava/lang/String;

    .line 3507
    iget-object v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->addresses:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda3;

    invoke-direct {v2}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 3509
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Ljava/util/List;

    .line 3510
    iget-object v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->dnses:Ljava/util/ArrayList;

    const/4 v6, 0x0

    new-array v3, v6, [Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    move-object v15, v1

    check-cast v15, [Ljava/lang/String;

    .line 3511
    iget-object v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->gateways:Ljava/util/ArrayList;

    new-array v3, v6, [Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Ljava/lang/String;

    .line 3512
    iget-object v3, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->pcscf:Ljava/util/ArrayList;

    new-array v13, v6, [Ljava/lang/String;

    invoke-virtual {v3, v13}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Ljava/lang/String;

    .line 3513
    iget v13, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->mtuV4:I

    iget v14, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->mtuV6:I

    invoke-static {v13, v14}, Ljava/lang/Math;->max(II)I

    move-result v13

    .line 3514
    iget v14, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->mtuV4:I

    .line 3515
    iget v6, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->mtuV6:I

    move-object/from16 p0, v1

    .line 3516
    iget-byte v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->handoverFailureMode:B

    move/from16 v18, v1

    .line 3517
    iget v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->pduSessionId:I

    move/from16 v19, v1

    .line 3518
    iget-object v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->defaultQos:Landroid/hardware/radio/V1_6/Qos;

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalQos(Landroid/hardware/radio/V1_6/Qos;)Landroid/telephony/data/Qos;

    move-result-object v1

    move-object/from16 v20, v1

    .line 3519
    iget-object v1, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->qosSessions:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    move-object/from16 v21, v2

    new-instance v2, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda4;

    invoke-direct {v2}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda4;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 3520
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/List;

    .line 3522
    iget-object v2, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->sliceInfo:Landroid/hardware/radio/V1_6/OptionalSliceInfo;

    .line 3521
    invoke-virtual {v2}, Landroid/hardware/radio/V1_6/OptionalSliceInfo;->getDiscriminator()B

    move-result v2

    if-nez v2, :cond_b

    const/16 v16, 0x0

    goto :goto_7

    .line 3523
    :cond_b
    iget-object v2, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->sliceInfo:Landroid/hardware/radio/V1_6/OptionalSliceInfo;

    invoke-virtual {v2}, Landroid/hardware/radio/V1_6/OptionalSliceInfo;->value()Landroid/hardware/radio/V1_6/SliceInfo;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalSliceInfo(Landroid/hardware/radio/V1_6/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v2

    move-object/from16 v16, v2

    .line 3524
    :goto_7
    iget-object v0, v0, Landroid/hardware/radio/V1_6/SetupDataCallResult;->trafficDescriptors:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_8
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_c

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_6/TrafficDescriptor;

    .line 3526
    :try_start_0
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTrafficDescriptor(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0

    invoke-interface {v4, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    move-object/from16 v22, v1

    move-object/from16 v23, v2

    goto :goto_9

    :catch_0
    move-exception v0

    move-object/from16 v22, v1

    .line 3528
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v23, v2

    const-string v2, "convertHalDataCallResult: Failed to convert traffic descriptor. e="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :goto_9
    move-object/from16 v1, v22

    move-object/from16 v2, v23

    goto :goto_8

    :cond_c
    move-object/from16 v22, v1

    move-object/from16 v1, p0

    move-object v2, v12

    move-object v12, v15

    move/from16 v28, v10

    move-object v10, v3

    move v3, v13

    move v13, v14

    move-wide v14, v7

    move v8, v11

    move-object/from16 v7, v21

    move/from16 v21, v19

    move-object/from16 v19, v22

    move/from16 v22, v18

    move-object/from16 v18, v4

    move v4, v9

    move v9, v5

    move/from16 v5, v28

    .line 3537
    :goto_a
    new-instance v11, Ljava/util/ArrayList;

    invoke-direct {v11}, Ljava/util/ArrayList;-><init>()V

    move/from16 v23, v6

    const-string v6, "RILUtils"

    if-eqz v12, :cond_e

    move/from16 p0, v13

    .line 3539
    array-length v13, v12

    move/from16 v24, v3

    const/4 v3, 0x0

    :goto_b
    if-ge v3, v13, :cond_d

    aget-object v0, v12, v3

    move-object/from16 v25, v12

    .line 3540
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v12

    .line 3543
    :try_start_1
    invoke-static {v12}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    .line 3544
    invoke-interface {v11, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_1

    move-object/from16 v27, v11

    move/from16 v26, v13

    goto :goto_c

    :catch_1
    move-exception v0

    move/from16 v26, v13

    .line 3546
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v27, v11

    const-string v11, "Unknown dns: "

    invoke-virtual {v13, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-static {v6, v11, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_c
    add-int/lit8 v3, v3, 0x1

    move-object/from16 v12, v25

    move/from16 v13, v26

    move-object/from16 v11, v27

    goto :goto_b

    :cond_d
    move-object/from16 v27, v11

    goto :goto_d

    :cond_e
    move/from16 v24, v3

    move-object/from16 v27, v11

    move/from16 p0, v13

    .line 3552
    :goto_d
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    if-eqz v1, :cond_f

    .line 3554
    array-length v11, v1

    const/4 v12, 0x0

    :goto_e
    if-ge v12, v11, :cond_f

    aget-object v0, v1, v12

    .line 3555
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    .line 3558
    :try_start_2
    invoke-static {v13}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    .line 3559
    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_2
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_2

    move-object/from16 v25, v1

    move/from16 v26, v11

    goto :goto_f

    :catch_2
    move-exception v0

    move-object/from16 v25, v1

    .line 3561
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    move/from16 v26, v11

    const-string v11, "Unknown gateway: "

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v6, v1, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_f
    add-int/lit8 v12, v12, 0x1

    move-object/from16 v1, v25

    move/from16 v11, v26

    goto :goto_e

    .line 3567
    :cond_f
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz v10, :cond_10

    .line 3569
    array-length v11, v10

    const/4 v12, 0x0

    :goto_10
    if-ge v12, v11, :cond_10

    aget-object v0, v10, v12

    .line 3570
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    .line 3573
    :try_start_3
    invoke-static {v13}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0

    .line 3574
    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_3 .. :try_end_3} :catch_3

    move-object/from16 v17, v10

    move/from16 v25, v11

    goto :goto_11

    :catch_3
    move-exception v0

    move-object/from16 v17, v10

    .line 3576
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    move/from16 v25, v11

    const-string v11, "Unknown pcscf: "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v6, v10, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_11
    add-int/lit8 v12, v12, 0x1

    move-object/from16 v10, v17

    move/from16 v11, v25

    goto :goto_10

    .line 3581
    :cond_10
    new-instance v0, Landroid/telephony/data/DataCallResponse$Builder;

    invoke-direct {v0}, Landroid/telephony/data/DataCallResponse$Builder;-><init>()V

    .line 3582
    invoke-virtual {v0, v9}, Landroid/telephony/data/DataCallResponse$Builder;->setCause(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3583
    invoke-virtual {v0, v14, v15}, Landroid/telephony/data/DataCallResponse$Builder;->setRetryDurationMillis(J)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3584
    invoke-virtual {v0, v4}, Landroid/telephony/data/DataCallResponse$Builder;->setId(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3585
    invoke-virtual {v0, v5}, Landroid/telephony/data/DataCallResponse$Builder;->setLinkStatus(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3586
    invoke-virtual {v0, v8}, Landroid/telephony/data/DataCallResponse$Builder;->setProtocolType(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3587
    invoke-virtual {v0, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setInterfaceName(Ljava/lang/String;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3588
    invoke-virtual {v0, v7}, Landroid/telephony/data/DataCallResponse$Builder;->setAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move-object/from16 v2, v27

    .line 3589
    invoke-virtual {v0, v2}, Landroid/telephony/data/DataCallResponse$Builder;->setDnsAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3590
    invoke-virtual {v0, v3}, Landroid/telephony/data/DataCallResponse$Builder;->setGatewayAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3591
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setPcscfAddresses(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move/from16 v3, v24

    .line 3592
    invoke-virtual {v0, v3}, Landroid/telephony/data/DataCallResponse$Builder;->setMtu(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move/from16 v13, p0

    .line 3593
    invoke-virtual {v0, v13}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV4(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move/from16 v6, v23

    .line 3594
    invoke-virtual {v0, v6}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV6(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move/from16 v1, v22

    .line 3595
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setHandoverFailureMode(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move/from16 v1, v21

    .line 3596
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setPduSessionId(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move-object/from16 v1, v20

    .line 3597
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setDefaultQos(Landroid/telephony/data/Qos;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move-object/from16 v3, v19

    .line 3598
    invoke-virtual {v0, v3}, Landroid/telephony/data/DataCallResponse$Builder;->setQosBearerSessions(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move-object/from16 v1, v16

    .line 3599
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setSliceInfo(Landroid/telephony/data/NetworkSliceInfo;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    move-object/from16 v1, v18

    .line 3600
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataCallResponse$Builder;->setTrafficDescriptors(Ljava/util/List;)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 3601
    invoke-virtual {v0}, Landroid/telephony/data/DataCallResponse$Builder;->build()Landroid/telephony/data/DataCallResponse;

    move-result-object v0

    return-object v0

    .line 3532
    :cond_11
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unsupported SetupDataCallResult "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    const/4 v0, 0x0

    return-object v0
.end method

.method public static convertHalDataCallResultList(Ljava/util/List;)Ljava/util/ArrayList;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "+",
            "Ljava/lang/Object;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;"
        }
    .end annotation

    .line 3999
    new-instance v0, Ljava/util/ArrayList;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 4001
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    .line 4002
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalDataCallResult(Ljava/lang/Object;)Landroid/telephony/data/DataCallResponse;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static convertHalDataCallResultList([Landroid/hardware/radio/data/SetupDataCallResult;)Ljava/util/ArrayList;
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/hardware/radio/data/SetupDataCallResult;",
            ")",
            "Ljava/util/ArrayList<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;"
        }
    .end annotation

    .line 4016
    new-instance v0, Ljava/util/ArrayList;

    array-length v1, p0

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 4018
    array-length v1, p0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, p0, v2

    .line 4019
    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalDataCallResult(Landroid/hardware/radio/data/SetupDataCallResult;)Landroid/telephony/data/DataCallResponse;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;
    .locals 3

    .line 3053
    new-instance v0, Landroid/telephony/CellSignalStrengthGsm;

    iget v1, p0, Landroid/hardware/radio/V1_0/GsmSignalStrength;->signalStrength:I

    .line 3054
    invoke-static {v1}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v1

    iget v2, p0, Landroid/hardware/radio/V1_0/GsmSignalStrength;->bitErrorRate:I

    iget p0, p0, Landroid/hardware/radio/V1_0/GsmSignalStrength;->timingAdvance:I

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/CellSignalStrengthGsm;-><init>(III)V

    .line 3056
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthGsm;->getRssi()I

    move-result p0

    const v1, 0x7fffffff

    if-ne p0, v1, :cond_0

    .line 3057
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthGsm;->setDefaultValues()V

    const/4 p0, 0x0

    .line 3058
    invoke-virtual {v0, p0, p0}, Landroid/telephony/CellSignalStrengthGsm;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_0
    return-object v0
.end method

.method public static convertHalGsmSignalStrength(Landroid/hardware/radio/network/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;
    .locals 3

    .line 3070
    new-instance v0, Landroid/telephony/CellSignalStrengthGsm;

    iget v1, p0, Landroid/hardware/radio/network/GsmSignalStrength;->signalStrength:I

    .line 3071
    invoke-static {v1}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v1

    iget v2, p0, Landroid/hardware/radio/network/GsmSignalStrength;->bitErrorRate:I

    iget p0, p0, Landroid/hardware/radio/network/GsmSignalStrength;->timingAdvance:I

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/CellSignalStrengthGsm;-><init>(III)V

    .line 3073
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthGsm;->getRssi()I

    move-result p0

    const v1, 0x7fffffff

    if-ne p0, v1, :cond_0

    .line 3074
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthGsm;->setDefaultValues()V

    const/4 p0, 0x0

    .line 3075
    invoke-virtual {v0, p0, p0}, Landroid/telephony/CellSignalStrengthGsm;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_0
    return-object v0
.end method

.method public static convertHalHardwareConfigList(Ljava/util/ArrayList;)Ljava/util/ArrayList;
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/hardware/radio/V1_0/HardwareConfig;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/HardwareConfig;",
            ">;"
        }
    .end annotation

    .line 2068
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    .line 2069
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 2071
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/HardwareConfig;

    .line 2072
    iget v2, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->type:I

    const/4 v3, 0x0

    if-eqz v2, :cond_1

    const/4 v4, 0x1

    if-ne v2, v4, :cond_0

    .line 2082
    new-instance v4, Lcom/android/internal/telephony/HardwareConfig;

    invoke-direct {v4, v2}, Lcom/android/internal/telephony/HardwareConfig;-><init>(I)V

    .line 2083
    iget-object v2, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->uuid:Ljava/lang/String;

    iget v5, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->state:I

    iget-object v0, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->sim:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/radio/V1_0/HardwareConfigSim;

    iget-object v0, v0, Landroid/hardware/radio/V1_0/HardwareConfigSim;->modemUuid:Ljava/lang/String;

    invoke-virtual {v4, v2, v5, v0}, Lcom/android/internal/telephony/HardwareConfig;->assignSim(Ljava/lang/String;ILjava/lang/String;)V

    goto :goto_1

    .line 2087
    :cond_0
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "RIL_REQUEST_GET_HARDWARE_CONFIG invalid hardware type:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 2075
    :cond_1
    new-instance v10, Lcom/android/internal/telephony/HardwareConfig;

    invoke-direct {v10, v2}, Lcom/android/internal/telephony/HardwareConfig;-><init>(I)V

    .line 2076
    iget-object v2, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->modem:Ljava/util/ArrayList;

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;

    .line 2077
    iget-object v3, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->uuid:Ljava/lang/String;

    iget v4, v0, Landroid/hardware/radio/V1_0/HardwareConfig;->state:I

    iget v5, v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;->rilModel:I

    iget v6, v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;->rat:I

    iget v7, v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;->maxVoice:I

    iget v8, v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;->maxData:I

    iget v9, v2, Landroid/hardware/radio/V1_0/HardwareConfigModem;->maxStandby:I

    move-object v2, v10

    invoke-virtual/range {v2 .. v9}, Lcom/android/internal/telephony/HardwareConfig;->assignModem(Ljava/lang/String;IIIIII)V

    move-object v4, v10

    .line 2091
    :goto_1
    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_2
    return-object v1
.end method

.method public static convertHalHardwareConfigList([Landroid/hardware/radio/modem/HardwareConfig;)Ljava/util/ArrayList;
    .locals 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Landroid/hardware/radio/modem/HardwareConfig;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/HardwareConfig;",
            ">;"
        }
    .end annotation

    .line 2103
    new-instance v0, Ljava/util/ArrayList;

    array-length v1, p0

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 2106
    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, p0, v3

    .line 2107
    iget v5, v4, Landroid/hardware/radio/modem/HardwareConfig;->type:I

    if-eqz v5, :cond_1

    const/4 v6, 0x1

    if-ne v5, v6, :cond_0

    .line 2117
    new-instance v6, Lcom/android/internal/telephony/HardwareConfig;

    invoke-direct {v6, v5}, Lcom/android/internal/telephony/HardwareConfig;-><init>(I)V

    .line 2118
    iget-object v5, v4, Landroid/hardware/radio/modem/HardwareConfig;->uuid:Ljava/lang/String;

    iget v7, v4, Landroid/hardware/radio/modem/HardwareConfig;->state:I

    iget-object v4, v4, Landroid/hardware/radio/modem/HardwareConfig;->sim:[Landroid/hardware/radio/modem/HardwareConfigSim;

    aget-object v4, v4, v2

    iget-object v4, v4, Landroid/hardware/radio/modem/HardwareConfigSim;->modemUuid:Ljava/lang/String;

    invoke-virtual {v6, v5, v7, v4}, Lcom/android/internal/telephony/HardwareConfig;->assignSim(Ljava/lang/String;ILjava/lang/String;)V

    goto :goto_1

    .line 2122
    :cond_0
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "RIL_REQUEST_GET_HARDWARE_CONFIG invalid hardware type:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 2110
    :cond_1
    new-instance v12, Lcom/android/internal/telephony/HardwareConfig;

    invoke-direct {v12, v5}, Lcom/android/internal/telephony/HardwareConfig;-><init>(I)V

    .line 2111
    iget-object v5, v4, Landroid/hardware/radio/modem/HardwareConfig;->modem:[Landroid/hardware/radio/modem/HardwareConfigModem;

    aget-object v5, v5, v2

    .line 2112
    iget-object v6, v4, Landroid/hardware/radio/modem/HardwareConfig;->uuid:Ljava/lang/String;

    iget v7, v4, Landroid/hardware/radio/modem/HardwareConfig;->state:I

    iget v8, v5, Landroid/hardware/radio/modem/HardwareConfigModem;->rilModel:I

    iget v9, v5, Landroid/hardware/radio/modem/HardwareConfigModem;->rat:I

    iget v10, v5, Landroid/hardware/radio/modem/HardwareConfigModem;->maxVoiceCalls:I

    iget v11, v5, Landroid/hardware/radio/modem/HardwareConfigModem;->maxDataCalls:I

    iget v13, v5, Landroid/hardware/radio/modem/HardwareConfigModem;->maxStandby:I

    move-object v4, v12

    move-object v5, v6

    move v6, v7

    move v7, v8

    move v8, v9

    move v9, v10

    move v10, v11

    move v11, v13

    invoke-virtual/range {v4 .. v11}, Lcom/android/internal/telephony/HardwareConfig;->assignModem(Ljava/lang/String;IIIIII)V

    move-object v6, v12

    .line 2126
    :goto_1
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method public static convertHalKeepaliveStatusCode(I)I
    .locals 1
    .annotation build Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
    .end annotation

    if-eqz p0, :cond_1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    return v0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public static convertHalLceData(Landroid/hardware/radio/network/LceDataInfo;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/hardware/radio/network/LceDataInfo;",
            ")",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;"
        }
    .end annotation

    .line 2221
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 2222
    new-instance v1, Landroid/telephony/LinkCapacityEstimate;

    iget p0, p0, Landroid/hardware/radio/network/LceDataInfo;->lastHopCapacityKbps:I

    const/4 v2, 0x2

    const/4 v3, -0x1

    invoke-direct {v1, v2, p0, v3}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method

.method public static convertHalLceData(Landroid/hardware/radio/network/LinkCapacityEstimate;)Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/hardware/radio/network/LinkCapacityEstimate;",
            ")",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;"
        }
    .end annotation

    .line 2235
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 2236
    iget v1, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->downlinkCapacityKbps:I

    .line 2237
    iget v2, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->uplinkCapacityKbps:I

    const/4 v3, -0x1

    if-eq v1, v3, :cond_0

    .line 2238
    iget v4, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->secondaryDownlinkCapacityKbps:I

    if-eq v4, v3, :cond_0

    sub-int/2addr v1, v4

    :cond_0
    if-eq v2, v3, :cond_1

    .line 2243
    iget v4, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->secondaryUplinkCapacityKbps:I

    if-eq v4, v3, :cond_1

    sub-int/2addr v2, v4

    .line 2248
    :cond_1
    new-instance v3, Landroid/telephony/LinkCapacityEstimate;

    const/4 v4, 0x0

    invoke-direct {v3, v4, v1, v2}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 2250
    new-instance v1, Landroid/telephony/LinkCapacityEstimate;

    const/4 v2, 0x1

    iget v3, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->secondaryDownlinkCapacityKbps:I

    iget p0, p0, Landroid/hardware/radio/network/LinkCapacityEstimate;->secondaryUplinkCapacityKbps:I

    invoke-direct {v1, v2, v3, p0}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method

.method public static convertHalLceData(Ljava/lang/Object;)Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;"
        }
    .end annotation

    .line 2179
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    if-nez p0, :cond_0

    return-object v0

    .line 2181
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/LceDataInfo;

    const/4 v2, 0x2

    const/4 v3, -0x1

    if-eqz v1, :cond_1

    .line 2182
    check-cast p0, Landroid/hardware/radio/V1_0/LceDataInfo;

    .line 2184
    new-instance v1, Landroid/telephony/LinkCapacityEstimate;

    iget p0, p0, Landroid/hardware/radio/V1_0/LceDataInfo;->lastHopCapacityKbps:I

    invoke-direct {v1, v2, p0, v3}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 2186
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/LinkCapacityEstimate;

    if-eqz v1, :cond_2

    .line 2187
    check-cast p0, Landroid/hardware/radio/V1_2/LinkCapacityEstimate;

    .line 2189
    new-instance v1, Landroid/telephony/LinkCapacityEstimate;

    iget v3, p0, Landroid/hardware/radio/V1_2/LinkCapacityEstimate;->downlinkCapacityKbps:I

    iget p0, p0, Landroid/hardware/radio/V1_2/LinkCapacityEstimate;->uplinkCapacityKbps:I

    invoke-direct {v1, v2, v3, p0}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 2191
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;

    if-eqz v1, :cond_5

    .line 2192
    check-cast p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;

    .line 2194
    iget v1, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->downlinkCapacityKbps:I

    .line 2195
    iget v2, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->uplinkCapacityKbps:I

    if-eq v1, v3, :cond_3

    .line 2196
    iget v4, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->secondaryDownlinkCapacityKbps:I

    if-eq v4, v3, :cond_3

    sub-int/2addr v1, v4

    :cond_3
    if-eq v2, v3, :cond_4

    .line 2201
    iget v4, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->secondaryUplinkCapacityKbps:I

    if-eq v4, v3, :cond_4

    sub-int/2addr v2, v4

    .line 2206
    :cond_4
    new-instance v3, Landroid/telephony/LinkCapacityEstimate;

    const/4 v4, 0x0

    invoke-direct {v3, v4, v1, v2}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 2208
    new-instance v1, Landroid/telephony/LinkCapacityEstimate;

    const/4 v2, 0x1

    iget v3, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->secondaryDownlinkCapacityKbps:I

    iget p0, p0, Landroid/hardware/radio/V1_6/LinkCapacityEstimate;->secondaryUplinkCapacityKbps:I

    invoke-direct {v1, v2, v3, p0}, Landroid/telephony/LinkCapacityEstimate;-><init>(III)V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_5
    :goto_0
    return-object v0
.end method

.method public static convertHalLteSignalStrength(Landroid/hardware/radio/network/LteSignalStrength;)Landroid/telephony/CellSignalStrengthLte;
    .locals 9

    .line 3145
    new-instance v8, Landroid/telephony/CellSignalStrengthLte;

    iget v0, p0, Landroid/hardware/radio/network/LteSignalStrength;->signalStrength:I

    .line 3146
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthLte;->convertRssiAsuToDBm(I)I

    move-result v1

    .line 3147
    iget v0, p0, Landroid/hardware/radio/network/LteSignalStrength;->rsrp:I

    const v2, 0x7fffffff

    if-eq v0, v2, :cond_0

    neg-int v0, v0

    :cond_0
    move v3, v0

    .line 3148
    iget v0, p0, Landroid/hardware/radio/network/LteSignalStrength;->rsrq:I

    if-eq v0, v2, :cond_1

    neg-int v0, v0

    :cond_1
    move v4, v0

    iget v0, p0, Landroid/hardware/radio/network/LteSignalStrength;->rssnr:I

    .line 3149
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthLte;->convertRssnrUnitFromTenDbToDB(I)I

    move-result v5

    iget v6, p0, Landroid/hardware/radio/network/LteSignalStrength;->cqiTableIndex:I

    iget v7, p0, Landroid/hardware/radio/network/LteSignalStrength;->cqi:I

    iget p0, p0, Landroid/hardware/radio/network/LteSignalStrength;->timingAdvance:I

    move-object v0, v8

    move v2, v3

    move v3, v4

    move v4, v5

    move v5, v6

    move v6, v7

    move v7, p0

    invoke-direct/range {v0 .. v7}, Landroid/telephony/CellSignalStrengthLte;-><init>(IIIIIII)V

    return-object v8
.end method

.method public static convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;
    .locals 11

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 3115
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;

    const v2, 0x7fffffff

    if-eqz v1, :cond_3

    .line 3116
    check-cast p0, Landroid/hardware/radio/V1_0/LteSignalStrength;

    .line 3118
    new-instance v0, Landroid/telephony/CellSignalStrengthLte;

    iget v1, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->signalStrength:I

    .line 3119
    invoke-static {v1}, Landroid/telephony/CellSignalStrengthLte;->convertRssiAsuToDBm(I)I

    move-result v4

    .line 3120
    iget v1, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->rsrp:I

    if-eq v1, v2, :cond_1

    neg-int v1, v1

    :cond_1
    move v5, v1

    .line 3121
    iget v1, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->rsrq:I

    if-eq v1, v2, :cond_2

    neg-int v1, v1

    :cond_2
    move v6, v1

    iget v1, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->rssnr:I

    .line 3122
    invoke-static {v1}, Landroid/telephony/CellSignalStrengthLte;->convertRssnrUnitFromTenDbToDB(I)I

    move-result v7

    iget v8, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->cqi:I

    iget v9, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->timingAdvance:I

    move-object v3, v0

    invoke-direct/range {v3 .. v9}, Landroid/telephony/CellSignalStrengthLte;-><init>(IIIIII)V

    return-object v0

    .line 3124
    :cond_3
    instance-of v1, p0, Landroid/hardware/radio/V1_6/LteSignalStrength;

    if-eqz v1, :cond_6

    .line 3125
    check-cast p0, Landroid/hardware/radio/V1_6/LteSignalStrength;

    .line 3127
    new-instance v0, Landroid/telephony/CellSignalStrengthLte;

    iget-object v1, p0, Landroid/hardware/radio/V1_6/LteSignalStrength;->base:Landroid/hardware/radio/V1_0/LteSignalStrength;

    iget v1, v1, Landroid/hardware/radio/V1_0/LteSignalStrength;->signalStrength:I

    .line 3128
    invoke-static {v1}, Landroid/telephony/CellSignalStrengthLte;->convertRssiAsuToDBm(I)I

    move-result v4

    .line 3129
    iget-object v1, p0, Landroid/hardware/radio/V1_6/LteSignalStrength;->base:Landroid/hardware/radio/V1_0/LteSignalStrength;

    iget v3, v1, Landroid/hardware/radio/V1_0/LteSignalStrength;->rsrp:I

    if-eq v3, v2, :cond_4

    neg-int v3, v3

    :cond_4
    move v5, v3

    .line 3130
    iget v3, v1, Landroid/hardware/radio/V1_0/LteSignalStrength;->rsrq:I

    if-eq v3, v2, :cond_5

    neg-int v2, v3

    move v6, v2

    goto :goto_0

    :cond_5
    move v6, v3

    :goto_0
    iget v1, v1, Landroid/hardware/radio/V1_0/LteSignalStrength;->rssnr:I

    .line 3131
    invoke-static {v1}, Landroid/telephony/CellSignalStrengthLte;->convertRssnrUnitFromTenDbToDB(I)I

    move-result v7

    iget v8, p0, Landroid/hardware/radio/V1_6/LteSignalStrength;->cqiTableIndex:I

    iget-object p0, p0, Landroid/hardware/radio/V1_6/LteSignalStrength;->base:Landroid/hardware/radio/V1_0/LteSignalStrength;

    iget v9, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->cqi:I

    iget v10, p0, Landroid/hardware/radio/V1_0/LteSignalStrength;->timingAdvance:I

    move-object v3, v0

    invoke-direct/range {v3 .. v10}, Landroid/telephony/CellSignalStrengthLte;-><init>(IIIIIII)V

    :cond_6
    return-object v0
.end method

.method public static convertHalNetworkTypeBitMask(I)I
    .locals 7

    const/high16 v0, 0x10000

    and-int/2addr v0, p0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    int-to-long v2, v1

    const-wide/32 v4, 0x8000

    or-long/2addr v2, v4

    long-to-int v0, v2

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    and-int/lit8 v2, p0, 0x2

    if-eqz v2, :cond_1

    int-to-long v2, v0

    const-wide/16 v4, 0x1

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_1
    and-int/lit8 v2, p0, 0x4

    if-eqz v2, :cond_2

    int-to-long v2, v0

    const-wide/16 v4, 0x2

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_2
    and-int/lit8 v2, p0, 0x10

    const-wide/16 v3, 0x8

    if-eqz v2, :cond_3

    int-to-long v5, v0

    or-long/2addr v5, v3

    long-to-int v0, v5

    :cond_3
    and-int/lit8 v2, p0, 0x20

    if-eqz v2, :cond_4

    int-to-long v5, v0

    or-long v2, v5, v3

    long-to-int v0, v2

    :cond_4
    and-int/lit8 v2, p0, 0x40

    if-eqz v2, :cond_5

    int-to-long v2, v0

    const-wide/16 v4, 0x40

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_5
    and-int/lit16 v2, p0, 0x80

    if-eqz v2, :cond_6

    int-to-long v2, v0

    const-wide/16 v4, 0x10

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_6
    and-int/lit16 v2, p0, 0x100

    if-eqz v2, :cond_7

    int-to-long v2, v0

    const-wide/16 v4, 0x20

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_7
    and-int/lit16 v2, p0, 0x1000

    if-eqz v2, :cond_8

    int-to-long v2, v0

    const-wide/16 v4, 0x800

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_8
    and-int/lit16 v2, p0, 0x2000

    if-eqz v2, :cond_9

    int-to-long v2, v0

    const-wide/16 v4, 0x2000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_9
    and-int/lit16 v2, p0, 0x400

    if-eqz v2, :cond_a

    int-to-long v2, v0

    const-wide/16 v4, 0x100

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_a
    and-int/lit16 v2, p0, 0x200

    if-eqz v2, :cond_b

    int-to-long v2, v0

    const-wide/16 v4, 0x80

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_b
    and-int/lit16 v2, p0, 0x800

    if-eqz v2, :cond_c

    int-to-long v2, v0

    const-wide/16 v4, 0x200

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_c
    const v2, 0x8000

    and-int/2addr v2, p0

    if-eqz v2, :cond_d

    int-to-long v2, v0

    const-wide/16 v4, 0x4000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_d
    and-int/lit8 v2, p0, 0x8

    if-eqz v2, :cond_e

    int-to-long v2, v0

    const-wide/16 v4, 0x4

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_e
    const/high16 v2, 0x20000

    and-int/2addr v2, p0

    if-eqz v2, :cond_f

    int-to-long v2, v0

    const-wide/32 v4, 0x10000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_f
    and-int/lit16 v2, p0, 0x4000

    if-eqz v2, :cond_10

    int-to-long v2, v0

    const-wide/16 v4, 0x1000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_10
    const/high16 v2, 0x80000

    and-int/2addr v2, p0

    if-eqz v2, :cond_11

    int-to-long v2, v0

    const-wide/32 v4, 0x40000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_11
    const/high16 v2, 0x100000

    and-int/2addr v2, p0

    if-eqz v2, :cond_12

    int-to-long v2, v0

    const-wide/32 v4, 0x80000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_12
    const/high16 v2, 0x40000

    and-int/2addr p0, v2

    if-eqz p0, :cond_13

    int-to-long v2, v0

    const-wide/32 v4, 0x20000

    or-long/2addr v2, v4

    long-to-int v0, v2

    :cond_13
    if-nez v0, :cond_14

    goto :goto_1

    :cond_14
    move v1, v0

    :goto_1
    return v1
.end method

.method public static convertHalNrSignalStrength(Landroid/hardware/radio/network/NrSignalStrength;)Landroid/telephony/CellSignalStrengthNr;
    .locals 10

    .line 3281
    new-instance v9, Landroid/telephony/CellSignalStrengthNr;

    iget v0, p0, Landroid/hardware/radio/network/NrSignalStrength;->csiRsrp:I

    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v1

    iget v0, p0, Landroid/hardware/radio/network/NrSignalStrength;->csiRsrq:I

    .line 3282
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v2

    iget v3, p0, Landroid/hardware/radio/network/NrSignalStrength;->csiSinr:I

    iget v4, p0, Landroid/hardware/radio/network/NrSignalStrength;->csiCqiTableIndex:I

    iget-object v0, p0, Landroid/hardware/radio/network/NrSignalStrength;->csiCqiReport:[B

    .line 3283
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([B)Ljava/util/ArrayList;

    move-result-object v5

    iget v0, p0, Landroid/hardware/radio/network/NrSignalStrength;->ssRsrp:I

    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v6

    iget v0, p0, Landroid/hardware/radio/network/NrSignalStrength;->ssRsrq:I

    .line 3284
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v7

    iget v8, p0, Landroid/hardware/radio/network/NrSignalStrength;->ssSinr:I

    move-object v0, v9

    invoke-direct/range {v0 .. v8}, Landroid/telephony/CellSignalStrengthNr;-><init>(IIIILjava/util/List;III)V

    return-object v9
.end method

.method public static convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;
    .locals 10

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 3256
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;

    if-eqz v1, :cond_1

    .line 3257
    check-cast p0, Landroid/hardware/radio/V1_4/NrSignalStrength;

    .line 3259
    new-instance v7, Landroid/telephony/CellSignalStrengthNr;

    iget v0, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiRsrp:I

    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v1

    iget v0, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiRsrq:I

    .line 3260
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v2

    iget v3, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiSinr:I

    iget v0, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssRsrp:I

    .line 3261
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v4

    iget v0, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssRsrq:I

    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v5

    iget v6, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssSinr:I

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/CellSignalStrengthNr;-><init>(IIIIII)V

    return-object v7

    .line 3263
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;

    if-eqz v1, :cond_2

    .line 3264
    check-cast p0, Landroid/hardware/radio/V1_6/NrSignalStrength;

    .line 3266
    new-instance v9, Landroid/telephony/CellSignalStrengthNr;

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->base:Landroid/hardware/radio/V1_4/NrSignalStrength;

    iget v0, v0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiRsrp:I

    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v1

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->base:Landroid/hardware/radio/V1_4/NrSignalStrength;

    iget v0, v0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiRsrq:I

    .line 3267
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v2

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->base:Landroid/hardware/radio/V1_4/NrSignalStrength;

    iget v3, v0, Landroid/hardware/radio/V1_4/NrSignalStrength;->csiSinr:I

    iget v4, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->csiCqiTableIndex:I

    iget-object v5, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->csiCqiReport:Ljava/util/ArrayList;

    iget v0, v0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssRsrp:I

    .line 3268
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v6

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->base:Landroid/hardware/radio/V1_4/NrSignalStrength;

    iget v0, v0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssRsrq:I

    .line 3269
    invoke-static {v0}, Landroid/telephony/CellSignalStrengthNr;->flip(I)I

    move-result v7

    iget-object p0, p0, Landroid/hardware/radio/V1_6/NrSignalStrength;->base:Landroid/hardware/radio/V1_4/NrSignalStrength;

    iget v8, p0, Landroid/hardware/radio/V1_4/NrSignalStrength;->ssSinr:I

    move-object v0, v9

    invoke-direct/range {v0 .. v8}, Landroid/telephony/CellSignalStrengthNr;-><init>(IIIILjava/util/List;III)V

    return-object v9

    :cond_2
    return-object v0
.end method

.method public static convertHalOperatorStatus(I)Ljava/lang/String;
    .locals 1

    if-nez p0, :cond_0

    const-string/jumbo p0, "unknown"

    return-object p0

    :cond_0
    const/4 v0, 0x1

    if-ne p0, v0, :cond_1

    const-string p0, "available"

    return-object p0

    :cond_1
    const/4 v0, 0x2

    if-ne p0, v0, :cond_2

    const-string p0, "current"

    return-object p0

    :cond_2
    const/4 v0, 0x3

    if-ne p0, v0, :cond_3

    const-string p0, "forbidden"

    return-object p0

    :cond_3
    const-string p0, ""

    return-object p0
.end method

.method public static convertHalPhoneCapability([ILjava/lang/Object;)Landroid/telephony/PhoneCapability;
    .locals 7

    .line 4580
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 4581
    instance-of v0, p1, Landroid/hardware/radio/config/PhoneCapability;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 4582
    check-cast p1, Landroid/hardware/radio/config/PhoneCapability;

    .line 4584
    iget-byte v0, p1, Landroid/hardware/radio/config/PhoneCapability;->maxActiveData:B

    .line 4585
    iget-boolean v2, p1, Landroid/hardware/radio/config/PhoneCapability;->isInternetLingeringSupported:Z

    .line 4586
    iget-object p1, p1, Landroid/hardware/radio/config/PhoneCapability;->logicalModemIds:[B

    array-length v4, p1

    :goto_0
    if-ge v1, v4, :cond_0

    aget-byte v5, p1, v1

    .line 4587
    new-instance v6, Landroid/telephony/ModemInfo;

    invoke-direct {v6, v5}, Landroid/telephony/ModemInfo;-><init>(I)V

    invoke-interface {v3, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    move v4, v2

    move v2, v0

    goto :goto_2

    .line 4589
    :cond_1
    instance-of v0, p1, Landroid/hardware/radio/config/V1_1/PhoneCapability;

    if-eqz v0, :cond_3

    .line 4590
    check-cast p1, Landroid/hardware/radio/config/V1_1/PhoneCapability;

    .line 4592
    iget-byte v0, p1, Landroid/hardware/radio/config/V1_1/PhoneCapability;->maxActiveData:B

    .line 4593
    iget-boolean v1, p1, Landroid/hardware/radio/config/V1_1/PhoneCapability;->isInternetLingeringSupported:Z

    .line 4595
    iget-object p1, p1, Landroid/hardware/radio/config/V1_1/PhoneCapability;->logicalModemList:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/config/V1_1/ModemInfo;

    .line 4596
    new-instance v4, Landroid/telephony/ModemInfo;

    iget-byte v2, v2, Landroid/hardware/radio/config/V1_1/ModemInfo;->modemId:B

    invoke-direct {v4, v2}, Landroid/telephony/ModemInfo;-><init>(I)V

    invoke-interface {v3, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_2
    move v2, v0

    move v4, v1

    goto :goto_2

    :cond_3
    move v2, v1

    move v4, v2

    .line 4599
    :goto_2
    new-instance p1, Landroid/telephony/PhoneCapability;

    const/4 v1, 0x0

    move-object v0, p1

    move-object v5, p0

    invoke-direct/range {v0 .. v5}, Landroid/telephony/PhoneCapability;-><init>(IILjava/util/List;Z[I)V

    return-object p1
.end method

.method public static convertHalPhonebookCapacity(Landroid/hardware/radio/V1_6/PhonebookCapacity;)Lcom/android/internal/telephony/uicc/AdnCapacity;
    .locals 12

    if-eqz p0, :cond_0

    .line 4384
    new-instance v11, Lcom/android/internal/telephony/uicc/AdnCapacity;

    iget v1, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxAdnRecords:I

    iget v2, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->usedAdnRecords:I

    iget v3, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxEmailRecords:I

    iget v4, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->usedEmailRecords:I

    iget v5, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxAdditionalNumberRecords:I

    iget v6, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->usedAdditionalNumberRecords:I

    iget v7, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxNameLen:I

    iget v8, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxNumberLen:I

    iget v9, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxEmailLen:I

    iget v10, p0, Landroid/hardware/radio/V1_6/PhonebookCapacity;->maxAdditionalNumberLen:I

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/uicc/AdnCapacity;-><init>(IIIIIIIIII)V

    return-object v11

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static convertHalPhonebookCapacity(Landroid/hardware/radio/sim/PhonebookCapacity;)Lcom/android/internal/telephony/uicc/AdnCapacity;
    .locals 12

    if-eqz p0, :cond_0

    .line 4400
    new-instance v11, Lcom/android/internal/telephony/uicc/AdnCapacity;

    iget v1, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxAdnRecords:I

    iget v2, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->usedAdnRecords:I

    iget v3, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxEmailRecords:I

    iget v4, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->usedEmailRecords:I

    iget v5, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxAdditionalNumberRecords:I

    iget v6, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->usedAdditionalNumberRecords:I

    iget v7, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxNameLen:I

    iget v8, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxNumberLen:I

    iget v9, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxEmailLen:I

    iget v10, p0, Landroid/hardware/radio/sim/PhonebookCapacity;->maxAdditionalNumberLen:I

    move-object v0, v11

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/uicc/AdnCapacity;-><init>(IIIIIIIIII)V

    return-object v11

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static convertHalPhonebookRecordInfo(Landroid/hardware/radio/V1_6/PhonebookRecordInfo;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord;
    .locals 8

    .line 4415
    iget-object v0, p0, Landroid/hardware/radio/V1_6/PhonebookRecordInfo;->emails:Ljava/util/ArrayList;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    move-object v6, v1

    goto :goto_0

    .line 4416
    :cond_0
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    new-array v2, v2, [Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    move-object v6, v0

    .line 4417
    :goto_0
    iget-object v0, p0, Landroid/hardware/radio/V1_6/PhonebookRecordInfo;->additionalNumbers:Ljava/util/ArrayList;

    if-nez v0, :cond_1

    goto :goto_1

    .line 4418
    :cond_1
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    new-array v1, v1, [Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    move-object v1, v0

    check-cast v1, [Ljava/lang/String;

    :goto_1
    move-object v7, v1

    .line 4419
    new-instance v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    iget v3, p0, Landroid/hardware/radio/V1_6/PhonebookRecordInfo;->recordId:I

    iget-object v4, p0, Landroid/hardware/radio/V1_6/PhonebookRecordInfo;->name:Ljava/lang/String;

    iget-object v5, p0, Landroid/hardware/radio/V1_6/PhonebookRecordInfo;->number:Ljava/lang/String;

    move-object v2, v0

    invoke-direct/range {v2 .. v7}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;-><init>(ILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    return-object v0
.end method

.method public static convertHalPhonebookRecordInfo(Landroid/hardware/radio/sim/PhonebookRecordInfo;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord;
    .locals 7

    .line 4430
    new-instance v6, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    iget v1, p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;->recordId:I

    iget-object v2, p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;->name:Ljava/lang/String;

    iget-object v3, p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;->number:Ljava/lang/String;

    iget-object v4, p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;->emails:[Ljava/lang/String;

    iget-object v5, p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;->additionalNumbers:[Ljava/lang/String;

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;-><init>(ILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    return-object v6
.end method

.method private static convertHalQos(Landroid/hardware/radio/V1_6/Qos;)Landroid/telephony/data/Qos;
    .locals 7

    .line 3826
    invoke-virtual {p0}, Landroid/hardware/radio/V1_6/Qos;->getDiscriminator()B

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 3832
    :cond_0
    invoke-virtual {p0}, Landroid/hardware/radio/V1_6/Qos;->nr()Landroid/hardware/radio/V1_6/NrQos;

    move-result-object p0

    .line 3833
    new-instance v6, Landroid/telephony/data/NrQos;

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrQos;->downlink:Landroid/hardware/radio/V1_6/QosBandwidth;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/V1_6/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/V1_6/NrQos;->uplink:Landroid/hardware/radio/V1_6/QosBandwidth;

    .line 3834
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/V1_6/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v2

    iget-byte v3, p0, Landroid/hardware/radio/V1_6/NrQos;->qfi:B

    iget-short v4, p0, Landroid/hardware/radio/V1_6/NrQos;->fiveQi:S

    iget-short v5, p0, Landroid/hardware/radio/V1_6/NrQos;->averagingWindowMs:S

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Landroid/telephony/data/NrQos;-><init>(Landroid/telephony/data/Qos$QosBandwidth;Landroid/telephony/data/Qos$QosBandwidth;III)V

    return-object v6

    .line 3828
    :cond_1
    invoke-virtual {p0}, Landroid/hardware/radio/V1_6/Qos;->eps()Landroid/hardware/radio/V1_6/EpsQos;

    move-result-object p0

    .line 3829
    new-instance v0, Landroid/telephony/data/EpsQos;

    iget-object v1, p0, Landroid/hardware/radio/V1_6/EpsQos;->downlink:Landroid/hardware/radio/V1_6/QosBandwidth;

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/V1_6/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v1

    iget-object v2, p0, Landroid/hardware/radio/V1_6/EpsQos;->uplink:Landroid/hardware/radio/V1_6/QosBandwidth;

    .line 3830
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/V1_6/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v2

    iget-short p0, p0, Landroid/hardware/radio/V1_6/EpsQos;->qci:S

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/data/EpsQos;-><init>(Landroid/telephony/data/Qos$QosBandwidth;Landroid/telephony/data/Qos$QosBandwidth;I)V

    return-object v0
.end method

.method private static convertHalQos(Landroid/hardware/radio/data/Qos;)Landroid/telephony/data/Qos;
    .locals 7

    .line 3841
    invoke-virtual {p0}, Landroid/hardware/radio/data/Qos;->getTag()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 3847
    :cond_0
    invoke-virtual {p0}, Landroid/hardware/radio/data/Qos;->getNr()Landroid/hardware/radio/data/NrQos;

    move-result-object p0

    .line 3848
    new-instance v6, Landroid/telephony/data/NrQos;

    iget-object v0, p0, Landroid/hardware/radio/data/NrQos;->downlink:Landroid/hardware/radio/data/QosBandwidth;

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/data/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/data/NrQos;->uplink:Landroid/hardware/radio/data/QosBandwidth;

    .line 3849
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/data/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v2

    iget-byte v3, p0, Landroid/hardware/radio/data/NrQos;->qfi:B

    iget v4, p0, Landroid/hardware/radio/data/NrQos;->fiveQi:I

    iget-char v5, p0, Landroid/hardware/radio/data/NrQos;->averagingWindowMs:C

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Landroid/telephony/data/NrQos;-><init>(Landroid/telephony/data/Qos$QosBandwidth;Landroid/telephony/data/Qos$QosBandwidth;III)V

    return-object v6

    .line 3843
    :cond_1
    invoke-virtual {p0}, Landroid/hardware/radio/data/Qos;->getEps()Landroid/hardware/radio/data/EpsQos;

    move-result-object p0

    .line 3844
    new-instance v0, Landroid/telephony/data/EpsQos;

    iget-object v1, p0, Landroid/hardware/radio/data/EpsQos;->downlink:Landroid/hardware/radio/data/QosBandwidth;

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/data/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v1

    iget-object v2, p0, Landroid/hardware/radio/data/EpsQos;->uplink:Landroid/hardware/radio/data/QosBandwidth;

    .line 3845
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBandwidth(Landroid/hardware/radio/data/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;

    move-result-object v2

    iget p0, p0, Landroid/hardware/radio/data/EpsQos;->qci:I

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/data/EpsQos;-><init>(Landroid/telephony/data/Qos$QosBandwidth;Landroid/telephony/data/Qos$QosBandwidth;I)V

    return-object v0
.end method

.method private static convertHalQosBandwidth(Landroid/hardware/radio/V1_6/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;
    .locals 2

    .line 3817
    new-instance v0, Landroid/telephony/data/Qos$QosBandwidth;

    iget v1, p0, Landroid/hardware/radio/V1_6/QosBandwidth;->maxBitrateKbps:I

    iget p0, p0, Landroid/hardware/radio/V1_6/QosBandwidth;->guaranteedBitrateKbps:I

    invoke-direct {v0, v1, p0}, Landroid/telephony/data/Qos$QosBandwidth;-><init>(II)V

    return-object v0
.end method

.method private static convertHalQosBandwidth(Landroid/hardware/radio/data/QosBandwidth;)Landroid/telephony/data/Qos$QosBandwidth;
    .locals 2

    .line 3822
    new-instance v0, Landroid/telephony/data/Qos$QosBandwidth;

    iget v1, p0, Landroid/hardware/radio/data/QosBandwidth;->maxBitrateKbps:I

    iget p0, p0, Landroid/hardware/radio/data/QosBandwidth;->guaranteedBitrateKbps:I

    invoke-direct {v0, v1, p0}, Landroid/telephony/data/Qos$QosBandwidth;-><init>(II)V

    return-object v0
.end method

.method private static convertHalQosBearerFilter(Landroid/hardware/radio/V1_6/QosFilter;)Landroid/telephony/data/QosBearerFilter;
    .locals 17

    move-object/from16 v0, p0

    .line 3858
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 3859
    iget-object v2, v0, Landroid/hardware/radio/V1_6/QosFilter;->localAddresses:Ljava/util/ArrayList;

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 3861
    array-length v4, v2

    move v5, v3

    :goto_0
    if-ge v5, v4, :cond_0

    aget-object v6, v2, v5

    .line 3862
    invoke-static {v6}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v6

    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 3865
    :cond_0
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 3866
    iget-object v4, v0, Landroid/hardware/radio/V1_6/QosFilter;->remoteAddresses:Ljava/util/ArrayList;

    new-array v5, v3, [Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v4

    check-cast v4, [Ljava/lang/String;

    if-eqz v4, :cond_1

    .line 3868
    array-length v5, v4

    :goto_1
    if-ge v3, v5, :cond_1

    aget-object v6, v4, v3

    .line 3869
    invoke-static {v6}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v6

    invoke-interface {v2, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 3873
    :cond_1
    iget-object v3, v0, Landroid/hardware/radio/V1_6/QosFilter;->localPort:Landroid/hardware/radio/V1_6/MaybePort;

    const/4 v4, 0x0

    const/4 v5, 0x1

    if-eqz v3, :cond_2

    .line 3874
    invoke-virtual {v3}, Landroid/hardware/radio/V1_6/MaybePort;->getDiscriminator()B

    move-result v3

    if-ne v3, v5, :cond_2

    .line 3876
    iget-object v3, v0, Landroid/hardware/radio/V1_6/QosFilter;->localPort:Landroid/hardware/radio/V1_6/MaybePort;

    invoke-virtual {v3}, Landroid/hardware/radio/V1_6/MaybePort;->range()Landroid/hardware/radio/V1_6/PortRange;

    move-result-object v3

    .line 3877
    new-instance v6, Landroid/telephony/data/QosBearerFilter$PortRange;

    iget v7, v3, Landroid/hardware/radio/V1_6/PortRange;->start:I

    iget v3, v3, Landroid/hardware/radio/V1_6/PortRange;->end:I

    invoke-direct {v6, v7, v3}, Landroid/telephony/data/QosBearerFilter$PortRange;-><init>(II)V

    move-object v3, v6

    goto :goto_2

    :cond_2
    move-object v3, v4

    .line 3881
    :goto_2
    iget-object v6, v0, Landroid/hardware/radio/V1_6/QosFilter;->remotePort:Landroid/hardware/radio/V1_6/MaybePort;

    if-eqz v6, :cond_3

    .line 3882
    invoke-virtual {v6}, Landroid/hardware/radio/V1_6/MaybePort;->getDiscriminator()B

    move-result v6

    if-ne v6, v5, :cond_3

    .line 3884
    iget-object v4, v0, Landroid/hardware/radio/V1_6/QosFilter;->remotePort:Landroid/hardware/radio/V1_6/MaybePort;

    .line 3885
    invoke-virtual {v4}, Landroid/hardware/radio/V1_6/MaybePort;->range()Landroid/hardware/radio/V1_6/PortRange;

    move-result-object v4

    .line 3886
    new-instance v6, Landroid/telephony/data/QosBearerFilter$PortRange;

    iget v7, v4, Landroid/hardware/radio/V1_6/PortRange;->start:I

    iget v4, v4, Landroid/hardware/radio/V1_6/PortRange;->end:I

    invoke-direct {v6, v7, v4}, Landroid/telephony/data/QosBearerFilter$PortRange;-><init>(II)V

    move-object v4, v6

    :cond_3
    const/4 v6, -0x1

    .line 3890
    iget-object v7, v0, Landroid/hardware/radio/V1_6/QosFilter;->tos:Landroid/hardware/radio/V1_6/QosFilter$TypeOfService;

    if-eqz v7, :cond_4

    .line 3891
    invoke-virtual {v7}, Landroid/hardware/radio/V1_6/QosFilter$TypeOfService;->getDiscriminator()B

    move-result v7

    if-ne v7, v5, :cond_4

    .line 3893
    iget-object v6, v0, Landroid/hardware/radio/V1_6/QosFilter;->tos:Landroid/hardware/radio/V1_6/QosFilter$TypeOfService;

    invoke-virtual {v6}, Landroid/hardware/radio/V1_6/QosFilter$TypeOfService;->value()B

    move-result v6

    .line 3897
    :cond_4
    iget-object v7, v0, Landroid/hardware/radio/V1_6/QosFilter;->flowLabel:Landroid/hardware/radio/V1_6/QosFilter$Ipv6FlowLabel;

    const-wide/16 v8, -0x1

    if-eqz v7, :cond_5

    .line 3898
    invoke-virtual {v7}, Landroid/hardware/radio/V1_6/QosFilter$Ipv6FlowLabel;->getDiscriminator()B

    move-result v7

    if-ne v7, v5, :cond_5

    .line 3900
    iget-object v7, v0, Landroid/hardware/radio/V1_6/QosFilter;->flowLabel:Landroid/hardware/radio/V1_6/QosFilter$Ipv6FlowLabel;

    invoke-virtual {v7}, Landroid/hardware/radio/V1_6/QosFilter$Ipv6FlowLabel;->value()I

    move-result v7

    int-to-long v10, v7

    goto :goto_3

    :cond_5
    move-wide v10, v8

    .line 3904
    :goto_3
    iget-object v7, v0, Landroid/hardware/radio/V1_6/QosFilter;->spi:Landroid/hardware/radio/V1_6/QosFilter$IpsecSpi;

    if-eqz v7, :cond_6

    .line 3905
    invoke-virtual {v7}, Landroid/hardware/radio/V1_6/QosFilter$IpsecSpi;->getDiscriminator()B

    move-result v7

    if-ne v7, v5, :cond_6

    .line 3907
    iget-object v5, v0, Landroid/hardware/radio/V1_6/QosFilter;->spi:Landroid/hardware/radio/V1_6/QosFilter$IpsecSpi;

    invoke-virtual {v5}, Landroid/hardware/radio/V1_6/QosFilter$IpsecSpi;->value()I

    move-result v5

    int-to-long v7, v5

    move-wide v12, v7

    goto :goto_4

    :cond_6
    move-wide v12, v8

    .line 3910
    :goto_4
    new-instance v14, Landroid/telephony/data/QosBearerFilter;

    iget-byte v5, v0, Landroid/hardware/radio/V1_6/QosFilter;->protocol:B

    iget-byte v15, v0, Landroid/hardware/radio/V1_6/QosFilter;->direction:B

    iget v9, v0, Landroid/hardware/radio/V1_6/QosFilter;->precedence:I

    move-object v0, v14

    move-wide v7, v10

    move/from16 v16, v9

    move-wide v9, v12

    move v11, v15

    move/from16 v12, v16

    invoke-direct/range {v0 .. v12}, Landroid/telephony/data/QosBearerFilter;-><init>(Ljava/util/List;Ljava/util/List;Landroid/telephony/data/QosBearerFilter$PortRange;Landroid/telephony/data/QosBearerFilter$PortRange;IIJJII)V

    return-object v14
.end method

.method private static convertHalQosBearerFilter(Landroid/hardware/radio/data/QosFilter;)Landroid/telephony/data/QosBearerFilter;
    .locals 15

    .line 3916
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 3917
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->localAddresses:[Ljava/lang/String;

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    .line 3919
    array-length v3, v0

    move v4, v2

    :goto_0
    if-ge v4, v3, :cond_0

    aget-object v5, v0, v4

    .line 3920
    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v5

    invoke-interface {v1, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 3923
    :cond_0
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 3924
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->remoteAddresses:[Ljava/lang/String;

    if-eqz v0, :cond_1

    .line 3926
    array-length v4, v0

    :goto_1
    if-ge v2, v4, :cond_1

    aget-object v5, v0, v2

    .line 3927
    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;

    move-result-object v5

    invoke-interface {v3, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 3931
    :cond_1
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->localPort:Landroid/hardware/radio/data/PortRange;

    const/4 v2, 0x0

    if-eqz v0, :cond_2

    .line 3932
    new-instance v0, Landroid/telephony/data/QosBearerFilter$PortRange;

    iget-object v4, p0, Landroid/hardware/radio/data/QosFilter;->localPort:Landroid/hardware/radio/data/PortRange;

    iget v5, v4, Landroid/hardware/radio/data/PortRange;->start:I

    iget v4, v4, Landroid/hardware/radio/data/PortRange;->end:I

    invoke-direct {v0, v5, v4}, Landroid/telephony/data/QosBearerFilter$PortRange;-><init>(II)V

    move-object v4, v0

    goto :goto_2

    :cond_2
    move-object v4, v2

    .line 3936
    :goto_2
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->remotePort:Landroid/hardware/radio/data/PortRange;

    if-eqz v0, :cond_3

    .line 3937
    new-instance v0, Landroid/telephony/data/QosBearerFilter$PortRange;

    iget-object v2, p0, Landroid/hardware/radio/data/QosFilter;->remotePort:Landroid/hardware/radio/data/PortRange;

    iget v5, v2, Landroid/hardware/radio/data/PortRange;->start:I

    iget v2, v2, Landroid/hardware/radio/data/PortRange;->end:I

    invoke-direct {v0, v5, v2}, Landroid/telephony/data/QosBearerFilter$PortRange;-><init>(II)V

    move-object v5, v0

    goto :goto_3

    :cond_3
    move-object v5, v2

    :goto_3
    const/4 v0, -0x1

    .line 3941
    iget-object v2, p0, Landroid/hardware/radio/data/QosFilter;->tos:Landroid/hardware/radio/data/QosFilterTypeOfService;

    const/4 v6, 0x1

    if-eqz v2, :cond_4

    .line 3942
    invoke-virtual {v2}, Landroid/hardware/radio/data/QosFilterTypeOfService;->getTag()I

    move-result v2

    if-ne v2, v6, :cond_4

    move v7, v6

    goto :goto_4

    :cond_4
    move v7, v0

    .line 3948
    :goto_4
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->flowLabel:Landroid/hardware/radio/data/QosFilterIpv6FlowLabel;

    const-wide/16 v8, 0x1

    const-wide/16 v10, -0x1

    if-eqz v0, :cond_5

    .line 3949
    invoke-virtual {v0}, Landroid/hardware/radio/data/QosFilterIpv6FlowLabel;->getTag()I

    move-result v0

    if-ne v0, v6, :cond_5

    move-wide v12, v8

    goto :goto_5

    :cond_5
    move-wide v12, v10

    .line 3955
    :goto_5
    iget-object v0, p0, Landroid/hardware/radio/data/QosFilter;->spi:Landroid/hardware/radio/data/QosFilterIpsecSpi;

    if-eqz v0, :cond_6

    .line 3956
    invoke-virtual {v0}, Landroid/hardware/radio/data/QosFilterIpsecSpi;->getTag()I

    move-result v0

    if-ne v0, v6, :cond_6

    move-wide v9, v8

    goto :goto_6

    :cond_6
    move-wide v9, v10

    .line 3961
    :goto_6
    new-instance v14, Landroid/telephony/data/QosBearerFilter;

    iget-byte v6, p0, Landroid/hardware/radio/data/QosFilter;->protocol:B

    iget-byte v11, p0, Landroid/hardware/radio/data/QosFilter;->direction:B

    iget p0, p0, Landroid/hardware/radio/data/QosFilter;->precedence:I

    move-object v0, v14

    move-object v2, v3

    move-object v3, v4

    move-object v4, v5

    move v5, v6

    move v6, v7

    move-wide v7, v12

    move v12, p0

    invoke-direct/range {v0 .. v12}, Landroid/telephony/data/QosBearerFilter;-><init>(Ljava/util/List;Ljava/util/List;Landroid/telephony/data/QosBearerFilter$PortRange;Landroid/telephony/data/QosBearerFilter$PortRange;IIJJII)V

    return-object v14
.end method

.method private static convertHalQosBearerSession(Landroid/hardware/radio/V1_6/QosSession;)Landroid/telephony/data/QosBearerSession;
    .locals 3

    .line 3967
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 3968
    iget-object v1, p0, Landroid/hardware/radio/V1_6/QosSession;->qosFilters:Ljava/util/ArrayList;

    if-eqz v1, :cond_0

    .line 3969
    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_6/QosFilter;

    .line 3970
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBearerFilter(Landroid/hardware/radio/V1_6/QosFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 3973
    :cond_0
    new-instance v1, Landroid/telephony/data/QosBearerSession;

    iget v2, p0, Landroid/hardware/radio/V1_6/QosSession;->qosSessionId:I

    iget-object p0, p0, Landroid/hardware/radio/V1_6/QosSession;->qos:Landroid/hardware/radio/V1_6/Qos;

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalQos(Landroid/hardware/radio/V1_6/Qos;)Landroid/telephony/data/Qos;

    move-result-object p0

    invoke-direct {v1, v2, p0, v0}, Landroid/telephony/data/QosBearerSession;-><init>(ILandroid/telephony/data/Qos;Ljava/util/List;)V

    return-object v1
.end method

.method private static convertHalQosBearerSession(Landroid/hardware/radio/data/QosSession;)Landroid/telephony/data/QosBearerSession;
    .locals 5

    .line 3979
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 3980
    iget-object v1, p0, Landroid/hardware/radio/data/QosSession;->qosFilters:[Landroid/hardware/radio/data/QosFilter;

    if-eqz v1, :cond_0

    .line 3981
    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 3982
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalQosBearerFilter(Landroid/hardware/radio/data/QosFilter;)Landroid/telephony/data/QosBearerFilter;

    move-result-object v4

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 3985
    :cond_0
    new-instance v1, Landroid/telephony/data/QosBearerSession;

    iget v2, p0, Landroid/hardware/radio/data/QosSession;->qosSessionId:I

    iget-object p0, p0, Landroid/hardware/radio/data/QosSession;->qos:Landroid/hardware/radio/data/Qos;

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalQos(Landroid/hardware/radio/data/Qos;)Landroid/telephony/data/Qos;

    move-result-object p0

    invoke-direct {v1, v2, p0, v0}, Landroid/telephony/data/QosBearerSession;-><init>(ILandroid/telephony/data/Qos;Ljava/util/List;)V

    return-object v1
.end method

.method public static convertHalRadioAccessNetworks(I)I
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_2

    const/4 v0, 0x4

    if-eq p0, v0, :cond_1

    const/4 v1, 0x5

    if-eq p0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0

    :cond_1
    const/4 p0, 0x6

    return p0

    :cond_2
    return v0
.end method

.method public static convertHalRadioAccessSpecifier(Landroid/hardware/radio/V1_5/RadioAccessSpecifier;)Landroid/telephony/RadioAccessSpecifier;
    .locals 4

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1249
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1250
    iget-object v1, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-virtual {v1}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->getDiscriminator()B

    move-result v1

    if-eqz v1, :cond_4

    const/4 v2, 0x1

    if-eq v1, v2, :cond_3

    const/4 v2, 0x2

    if-eq v1, v2, :cond_2

    const/4 v2, 0x3

    if-eq v1, v2, :cond_1

    goto :goto_0

    .line 1265
    :cond_1
    iget-object v0, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->ngranBands()Ljava/util/ArrayList;

    move-result-object v0

    goto :goto_0

    .line 1261
    :cond_2
    iget-object v0, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->eutranBands()Ljava/util/ArrayList;

    move-result-object v0

    goto :goto_0

    .line 1257
    :cond_3
    iget-object v0, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->utranBands()Ljava/util/ArrayList;

    move-result-object v0

    goto :goto_0

    .line 1253
    :cond_4
    iget-object v0, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->geranBands()Ljava/util/ArrayList;

    move-result-object v0

    .line 1268
    :goto_0
    new-instance v1, Landroid/telephony/RadioAccessSpecifier;

    iget v2, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->radioAccessNetwork:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertHalRadioAccessNetworks(I)I

    move-result v2

    .line 1269
    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v3, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;

    invoke-direct {v3}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;-><init>()V

    invoke-interface {v0, v3}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object v0

    iget-object p0, p0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->channels:Ljava/util/ArrayList;

    .line 1270
    invoke-virtual {p0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v3, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;

    invoke-direct {v3}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;-><init>()V

    invoke-interface {p0, v3}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object p0

    invoke-direct {v1, v2, v0, p0}, Landroid/telephony/RadioAccessSpecifier;-><init>(I[I[I)V

    return-object v1
.end method

.method public static convertHalRadioAccessSpecifier(Landroid/hardware/radio/network/RadioAccessSpecifier;)Landroid/telephony/RadioAccessSpecifier;
    .locals 3

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 1282
    :cond_0
    iget-object v1, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-virtual {v1}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->getTag()I

    move-result v1

    const/4 v2, 0x1

    if-eq v1, v2, :cond_4

    const/4 v2, 0x2

    if-eq v1, v2, :cond_3

    const/4 v2, 0x3

    if-eq v1, v2, :cond_2

    const/4 v2, 0x4

    if-eq v1, v2, :cond_1

    goto :goto_0

    .line 1293
    :cond_1
    iget-object v0, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-virtual {v0}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->getNgranBands()[I

    move-result-object v0

    goto :goto_0

    .line 1290
    :cond_2
    iget-object v0, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-virtual {v0}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->getEutranBands()[I

    move-result-object v0

    goto :goto_0

    .line 1287
    :cond_3
    iget-object v0, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-virtual {v0}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->getUtranBands()[I

    move-result-object v0

    goto :goto_0

    .line 1284
    :cond_4
    iget-object v0, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-virtual {v0}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->getGeranBands()[I

    move-result-object v0

    .line 1296
    :goto_0
    new-instance v1, Landroid/telephony/RadioAccessSpecifier;

    iget v2, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->accessNetwork:I

    iget-object p0, p0, Landroid/hardware/radio/network/RadioAccessSpecifier;->channels:[I

    invoke-direct {v1, v2, v0, p0}, Landroid/telephony/RadioAccessSpecifier;-><init>(I[I[I)V

    return-object v1
.end method

.method public static convertHalRadioCapability(Landroid/hardware/radio/V1_0/RadioCapability;Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioCapability;
    .locals 7

    .line 2139
    iget v2, p0, Landroid/hardware/radio/V1_0/RadioCapability;->session:I

    .line 2140
    iget v3, p0, Landroid/hardware/radio/V1_0/RadioCapability;->phase:I

    .line 2141
    iget v0, p0, Landroid/hardware/radio/V1_0/RadioCapability;->raf:I

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalNetworkTypeBitMask(I)I

    move-result v4

    .line 2142
    iget-object v5, p0, Landroid/hardware/radio/V1_0/RadioCapability;->logicalModemUuid:Ljava/lang/String;

    .line 2143
    iget v6, p0, Landroid/hardware/radio/V1_0/RadioCapability;->status:I

    .line 2145
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "convertHalRadioCapability: session="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", phase="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rat="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", logicModemUuid="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", status="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rcRil.raf="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Landroid/hardware/radio/V1_0/RadioCapability;->raf:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 2148
    new-instance p0, Lcom/android/internal/telephony/RadioCapability;

    iget-object p1, p1, Lcom/android/internal/telephony/RIL;->mPhoneId:Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    move-object v0, p0

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/RadioCapability;-><init>(IIIILjava/lang/String;I)V

    return-object p0
.end method

.method public static convertHalRadioCapability(Landroid/hardware/radio/modem/RadioCapability;Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioCapability;
    .locals 7

    .line 2159
    iget v2, p0, Landroid/hardware/radio/modem/RadioCapability;->session:I

    .line 2160
    iget v3, p0, Landroid/hardware/radio/modem/RadioCapability;->phase:I

    .line 2161
    iget v0, p0, Landroid/hardware/radio/modem/RadioCapability;->raf:I

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalNetworkTypeBitMask(I)I

    move-result v4

    .line 2162
    iget-object v5, p0, Landroid/hardware/radio/modem/RadioCapability;->logicalModemUuid:Ljava/lang/String;

    .line 2163
    iget v6, p0, Landroid/hardware/radio/modem/RadioCapability;->status:I

    .line 2165
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "convertHalRadioCapability: session="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", phase="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rat="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", logicModemUuid="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", status="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", rcRil.raf="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Landroid/hardware/radio/modem/RadioCapability;->raf:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 2168
    new-instance p0, Lcom/android/internal/telephony/RadioCapability;

    iget-object p1, p1, Lcom/android/internal/telephony/RIL;->mPhoneId:Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    move-object v0, p0

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/RadioCapability;-><init>(IIIILjava/lang/String;I)V

    return-object p0
.end method

.method public static convertHalRadioState(I)I
    .locals 3

    const/4 v0, 0x1

    if-eqz p0, :cond_2

    if-eq p0, v0, :cond_1

    const/16 v1, 0xa

    if-ne p0, v1, :cond_0

    goto :goto_0

    .line 4061
    :cond_0
    new-instance v0, Ljava/lang/RuntimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unrecognized RadioState: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    const/4 v0, 0x2

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public static convertHalSignalStrength(Landroid/hardware/radio/network/SignalStrength;)Landroid/telephony/SignalStrength;
    .locals 8

    .line 3037
    new-instance v7, Landroid/telephony/SignalStrength;

    iget-object v0, p0, Landroid/hardware/radio/network/SignalStrength;->cdma:Landroid/hardware/radio/network/CdmaSignalStrength;

    iget-object v1, p0, Landroid/hardware/radio/network/SignalStrength;->evdo:Landroid/hardware/radio/network/EvdoSignalStrength;

    .line 3038
    invoke-static {v0, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/network/CdmaSignalStrength;Landroid/hardware/radio/network/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/network/SignalStrength;->gsm:Landroid/hardware/radio/network/GsmSignalStrength;

    .line 3039
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/network/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v2

    iget-object v0, p0, Landroid/hardware/radio/network/SignalStrength;->wcdma:Landroid/hardware/radio/network/WcdmaSignalStrength;

    .line 3040
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Landroid/hardware/radio/network/WcdmaSignalStrength;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v3

    iget-object v0, p0, Landroid/hardware/radio/network/SignalStrength;->tdscdma:Landroid/hardware/radio/network/TdscdmaSignalStrength;

    .line 3041
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Landroid/hardware/radio/network/TdscdmaSignalStrength;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v4

    iget-object v0, p0, Landroid/hardware/radio/network/SignalStrength;->lte:Landroid/hardware/radio/network/LteSignalStrength;

    .line 3042
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Landroid/hardware/radio/network/LteSignalStrength;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v5

    iget-object p0, p0, Landroid/hardware/radio/network/SignalStrength;->nr:Landroid/hardware/radio/network/NrSignalStrength;

    .line 3043
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Landroid/hardware/radio/network/NrSignalStrength;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v6

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/SignalStrength;-><init>(Landroid/telephony/CellSignalStrengthCdma;Landroid/telephony/CellSignalStrengthGsm;Landroid/telephony/CellSignalStrengthWcdma;Landroid/telephony/CellSignalStrengthTdscdma;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v7
.end method

.method public static convertHalSignalStrength(Ljava/lang/Object;)Landroid/telephony/SignalStrength;
    .locals 8

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 2988
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/SignalStrength;

    if-eqz v1, :cond_1

    .line 2989
    check-cast p0, Landroid/hardware/radio/V1_0/SignalStrength;

    .line 2991
    new-instance v7, Landroid/telephony/SignalStrength;

    iget-object v0, p0, Landroid/hardware/radio/V1_0/SignalStrength;->cdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v1, p0, Landroid/hardware/radio/V1_0/SignalStrength;->evdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    .line 2992
    invoke-static {v0, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/V1_0/SignalStrength;->gw:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    .line 2993
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v2

    new-instance v3, Landroid/telephony/CellSignalStrengthWcdma;

    invoke-direct {v3}, Landroid/telephony/CellSignalStrengthWcdma;-><init>()V

    iget-object v0, p0, Landroid/hardware/radio/V1_0/SignalStrength;->tdScdma:Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;

    .line 2994
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v4

    iget-object p0, p0, Landroid/hardware/radio/V1_0/SignalStrength;->lte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    .line 2995
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v5

    new-instance v6, Landroid/telephony/CellSignalStrengthNr;

    invoke-direct {v6}, Landroid/telephony/CellSignalStrengthNr;-><init>()V

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/SignalStrength;-><init>(Landroid/telephony/CellSignalStrengthCdma;Landroid/telephony/CellSignalStrengthGsm;Landroid/telephony/CellSignalStrengthWcdma;Landroid/telephony/CellSignalStrengthTdscdma;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v7

    .line 2997
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/SignalStrength;

    if-eqz v1, :cond_2

    .line 2998
    check-cast p0, Landroid/hardware/radio/V1_2/SignalStrength;

    .line 3000
    new-instance v7, Landroid/telephony/SignalStrength;

    iget-object v0, p0, Landroid/hardware/radio/V1_2/SignalStrength;->cdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v1, p0, Landroid/hardware/radio/V1_2/SignalStrength;->evdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    .line 3001
    invoke-static {v0, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/V1_2/SignalStrength;->gsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    .line 3002
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v2

    iget-object v0, p0, Landroid/hardware/radio/V1_2/SignalStrength;->wcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    .line 3003
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v3

    iget-object v0, p0, Landroid/hardware/radio/V1_2/SignalStrength;->tdScdma:Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;

    .line 3004
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v4

    iget-object p0, p0, Landroid/hardware/radio/V1_2/SignalStrength;->lte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    .line 3005
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v5

    new-instance v6, Landroid/telephony/CellSignalStrengthNr;

    invoke-direct {v6}, Landroid/telephony/CellSignalStrengthNr;-><init>()V

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/SignalStrength;-><init>(Landroid/telephony/CellSignalStrengthCdma;Landroid/telephony/CellSignalStrengthGsm;Landroid/telephony/CellSignalStrengthWcdma;Landroid/telephony/CellSignalStrengthTdscdma;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v7

    .line 3006
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_4/SignalStrength;

    if-eqz v1, :cond_3

    .line 3007
    check-cast p0, Landroid/hardware/radio/V1_4/SignalStrength;

    .line 3009
    new-instance v7, Landroid/telephony/SignalStrength;

    iget-object v0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->cdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v1, p0, Landroid/hardware/radio/V1_4/SignalStrength;->evdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    .line 3010
    invoke-static {v0, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->gsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    .line 3011
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v2

    iget-object v0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->wcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    .line 3012
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v3

    iget-object v0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->tdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    .line 3013
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v4

    iget-object v0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->lte:Landroid/hardware/radio/V1_0/LteSignalStrength;

    .line 3014
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v5

    iget-object p0, p0, Landroid/hardware/radio/V1_4/SignalStrength;->nr:Landroid/hardware/radio/V1_4/NrSignalStrength;

    .line 3015
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v6

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/SignalStrength;-><init>(Landroid/telephony/CellSignalStrengthCdma;Landroid/telephony/CellSignalStrengthGsm;Landroid/telephony/CellSignalStrengthWcdma;Landroid/telephony/CellSignalStrengthTdscdma;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v7

    .line 3016
    :cond_3
    instance-of v1, p0, Landroid/hardware/radio/V1_6/SignalStrength;

    if-eqz v1, :cond_4

    .line 3017
    check-cast p0, Landroid/hardware/radio/V1_6/SignalStrength;

    .line 3019
    new-instance v7, Landroid/telephony/SignalStrength;

    iget-object v0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->cdma:Landroid/hardware/radio/V1_0/CdmaSignalStrength;

    iget-object v1, p0, Landroid/hardware/radio/V1_6/SignalStrength;->evdo:Landroid/hardware/radio/V1_0/EvdoSignalStrength;

    .line 3020
    invoke-static {v0, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalCdmaSignalStrength(Landroid/hardware/radio/V1_0/CdmaSignalStrength;Landroid/hardware/radio/V1_0/EvdoSignalStrength;)Landroid/telephony/CellSignalStrengthCdma;

    move-result-object v1

    iget-object v0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->gsm:Landroid/hardware/radio/V1_0/GsmSignalStrength;

    .line 3021
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalGsmSignalStrength(Landroid/hardware/radio/V1_0/GsmSignalStrength;)Landroid/telephony/CellSignalStrengthGsm;

    move-result-object v2

    iget-object v0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->wcdma:Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    .line 3022
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;

    move-result-object v3

    iget-object v0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->tdscdma:Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    .line 3023
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;

    move-result-object v4

    iget-object v0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->lte:Landroid/hardware/radio/V1_6/LteSignalStrength;

    .line 3024
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalLteSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthLte;

    move-result-object v5

    iget-object p0, p0, Landroid/hardware/radio/V1_6/SignalStrength;->nr:Landroid/hardware/radio/V1_6/NrSignalStrength;

    .line 3025
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalNrSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthNr;

    move-result-object v6

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Landroid/telephony/SignalStrength;-><init>(Landroid/telephony/CellSignalStrengthCdma;Landroid/telephony/CellSignalStrengthGsm;Landroid/telephony/CellSignalStrengthWcdma;Landroid/telephony/CellSignalStrengthTdscdma;Landroid/telephony/CellSignalStrengthLte;Landroid/telephony/CellSignalStrengthNr;)V

    return-object v7

    :cond_4
    return-object v0
.end method

.method private static convertHalSliceInfo(Landroid/hardware/radio/V1_6/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;
    .locals 3

    .line 3695
    new-instance v0, Landroid/telephony/data/NetworkSliceInfo$Builder;

    invoke-direct {v0}, Landroid/telephony/data/NetworkSliceInfo$Builder;-><init>()V

    iget-byte v1, p0, Landroid/hardware/radio/V1_6/SliceInfo;->sst:B

    .line 3696
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setSliceServiceType(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v0

    iget-byte v1, p0, Landroid/hardware/radio/V1_6/SliceInfo;->mappedHplmnSst:B

    .line 3697
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setMappedHplmnSliceServiceType(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v0

    .line 3698
    iget v1, p0, Landroid/hardware/radio/V1_6/SliceInfo;->sliceDifferentiator:I

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    .line 3699
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setSliceDifferentiator(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v1

    iget p0, p0, Landroid/hardware/radio/V1_6/SliceInfo;->mappedHplmnSD:I

    .line 3700
    invoke-virtual {v1, p0}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setMappedHplmnSliceDifferentiator(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    .line 3702
    :cond_0
    invoke-virtual {v0}, Landroid/telephony/data/NetworkSliceInfo$Builder;->build()Landroid/telephony/data/NetworkSliceInfo;

    move-result-object p0

    return-object p0
.end method

.method private static convertHalSliceInfo(Landroid/hardware/radio/data/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;
    .locals 3

    .line 3706
    new-instance v0, Landroid/telephony/data/NetworkSliceInfo$Builder;

    invoke-direct {v0}, Landroid/telephony/data/NetworkSliceInfo$Builder;-><init>()V

    iget-byte v1, p0, Landroid/hardware/radio/data/SliceInfo;->sliceServiceType:B

    .line 3707
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setSliceServiceType(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v0

    iget-byte v1, p0, Landroid/hardware/radio/data/SliceInfo;->mappedHplmnSst:B

    .line 3708
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setMappedHplmnSliceServiceType(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v0

    .line 3709
    iget v1, p0, Landroid/hardware/radio/data/SliceInfo;->sliceDifferentiator:I

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    .line 3710
    invoke-virtual {v0, v1}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setSliceDifferentiator(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    move-result-object v1

    iget p0, p0, Landroid/hardware/radio/data/SliceInfo;->mappedHplmnSd:I

    .line 3711
    invoke-virtual {v1, p0}, Landroid/telephony/data/NetworkSliceInfo$Builder;->setMappedHplmnSliceDifferentiator(I)Landroid/telephony/data/NetworkSliceInfo$Builder;

    .line 3713
    :cond_0
    invoke-virtual {v0}, Landroid/telephony/data/NetworkSliceInfo$Builder;->build()Landroid/telephony/data/NetworkSliceInfo;

    move-result-object p0

    return-object p0
.end method

.method public static convertHalSlicingConfig(Landroid/hardware/radio/V1_6/SlicingConfig;)Landroid/telephony/data/NetworkSlicingConfig;
    .locals 3

    .line 3756
    iget-object v0, p0, Landroid/hardware/radio/V1_6/SlicingConfig;->urspRules:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda1;

    invoke-direct {v1}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda1;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 3774
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    .line 3775
    new-instance v1, Landroid/telephony/data/NetworkSlicingConfig;

    iget-object p0, p0, Landroid/hardware/radio/V1_6/SlicingConfig;->sliceInfo:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v2, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda0;

    invoke-direct {v2}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda0;-><init>()V

    .line 3776
    invoke-interface {p0, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {p0, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    invoke-direct {v1, v0, p0}, Landroid/telephony/data/NetworkSlicingConfig;-><init>(Ljava/util/List;Ljava/util/List;)V

    return-object v1
.end method

.method public static convertHalSlicingConfig(Landroid/hardware/radio/data/SlicingConfig;)Landroid/telephony/data/NetworkSlicingConfig;
    .locals 20

    move-object/from16 v1, p0

    .line 3786
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 3787
    iget-object v3, v1, Landroid/hardware/radio/data/SlicingConfig;->urspRules:[Landroid/hardware/radio/data/UrspRule;

    array-length v4, v3

    const/4 v6, 0x0

    :goto_0
    if-ge v6, v4, :cond_3

    aget-object v7, v3, v6

    .line 3788
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    .line 3789
    iget-object v9, v7, Landroid/hardware/radio/data/UrspRule;->trafficDescriptors:[Landroid/hardware/radio/data/TrafficDescriptor;

    array-length v10, v9

    const/4 v11, 0x0

    :goto_1
    if-ge v11, v10, :cond_0

    aget-object v0, v9, v11

    .line 3791
    :try_start_0
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertHalTrafficDescriptor(Landroid/hardware/radio/data/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0

    invoke-interface {v8, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception v0

    .line 3793
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "convertHalTrafficDescriptor: "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :goto_2
    add-int/lit8 v11, v11, 0x1

    goto :goto_1

    .line 3796
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 3798
    iget-object v9, v7, Landroid/hardware/radio/data/UrspRule;->routeSelectionDescriptor:[Landroid/hardware/radio/data/RouteSelectionDescriptor;

    array-length v10, v9

    const/4 v11, 0x0

    :goto_3
    if-ge v11, v10, :cond_2

    aget-object v12, v9, v11

    .line 3799
    new-instance v15, Ljava/util/ArrayList;

    invoke-direct {v15}, Ljava/util/ArrayList;-><init>()V

    .line 3800
    iget-object v13, v12, Landroid/hardware/radio/data/RouteSelectionDescriptor;->sliceInfo:[Landroid/hardware/radio/data/SliceInfo;

    array-length v14, v13

    const/4 v5, 0x0

    :goto_4
    if-ge v5, v14, :cond_1

    aget-object v16, v13, v5

    move-object/from16 v19, v3

    .line 3801
    invoke-static/range {v16 .. v16}, Lcom/android/internal/telephony/RILUtils;->convertHalSliceInfo(Landroid/hardware/radio/data/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v3

    invoke-interface {v15, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    move-object/from16 v3, v19

    goto :goto_4

    :cond_1
    move-object/from16 v19, v3

    .line 3803
    new-instance v3, Landroid/telephony/data/RouteSelectionDescriptor;

    iget-byte v14, v12, Landroid/hardware/radio/data/RouteSelectionDescriptor;->precedence:B

    iget v5, v12, Landroid/hardware/radio/data/RouteSelectionDescriptor;->sessionType:I

    iget-byte v13, v12, Landroid/hardware/radio/data/RouteSelectionDescriptor;->sscMode:B

    iget-object v12, v12, Landroid/hardware/radio/data/RouteSelectionDescriptor;->dnn:[Ljava/lang/String;

    .line 3804
    invoke-static {v12}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v18

    move v12, v13

    move-object v13, v3

    move-object/from16 v17, v15

    move v15, v5

    move/from16 v16, v12

    invoke-direct/range {v13 .. v18}, Landroid/telephony/data/RouteSelectionDescriptor;-><init>(IIILjava/util/List;Ljava/util/List;)V

    .line 3803
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v11, v11, 0x1

    move-object/from16 v3, v19

    goto :goto_3

    :cond_2
    move-object/from16 v19, v3

    .line 3806
    new-instance v3, Landroid/telephony/data/UrspRule;

    iget v5, v7, Landroid/hardware/radio/data/UrspRule;->precedence:I

    invoke-direct {v3, v5, v8, v0}, Landroid/telephony/data/UrspRule;-><init>(ILjava/util/List;Ljava/util/List;)V

    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v6, v6, 0x1

    move-object/from16 v3, v19

    goto/16 :goto_0

    .line 3808
    :cond_3
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 3809
    iget-object v1, v1, Landroid/hardware/radio/data/SlicingConfig;->sliceInfo:[Landroid/hardware/radio/data/SliceInfo;

    array-length v3, v1

    const/4 v5, 0x0

    :goto_5
    if-ge v5, v3, :cond_4

    aget-object v4, v1, v5

    .line 3810
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertHalSliceInfo(Landroid/hardware/radio/data/SliceInfo;)Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v4

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_5

    .line 3812
    :cond_4
    new-instance v1, Landroid/telephony/data/NetworkSlicingConfig;

    invoke-direct {v1, v2, v0}, Landroid/telephony/data/NetworkSlicingConfig;-><init>(Ljava/util/List;Ljava/util/List;)V

    return-object v1
.end method

.method public static convertHalSlotStatus(Ljava/lang/Object;)Ljava/util/ArrayList;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/uicc/IccSlotStatus;",
            ">;"
        }
    .end annotation

    .line 4466
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, -0x1

    const/4 v2, 0x0

    .line 4468
    :try_start_0
    move-object v3, p0

    check-cast v3, [Landroid/hardware/radio/config/SimSlotStatus;

    .line 4470
    array-length v4, v3

    move v5, v2

    :goto_0
    if-ge v5, v4, :cond_2

    aget-object v6, v3, v5

    .line 4471
    new-instance v7, Lcom/android/internal/telephony/uicc/IccSlotStatus;

    invoke-direct {v7}, Lcom/android/internal/telephony/uicc/IccSlotStatus;-><init>()V

    .line 4472
    iget v8, v6, Landroid/hardware/radio/config/SimSlotStatus;->cardState:I

    invoke-virtual {v7, v8}, Lcom/android/internal/telephony/uicc/IccSlotStatus;->setCardState(I)V

    .line 4473
    iget-object v8, v6, Landroid/hardware/radio/config/SimSlotStatus;->portInfo:[Landroid/hardware/radio/config/SimPortInfo;

    array-length v8, v8

    .line 4474
    new-array v9, v8, [Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    iput-object v9, v7, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    move v9, v2

    :goto_1
    if-ge v9, v8, :cond_1

    .line 4476
    new-instance v10, Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    invoke-direct {v10}, Lcom/android/internal/telephony/uicc/IccSimPortInfo;-><init>()V

    .line 4477
    iget-object v11, v6, Landroid/hardware/radio/config/SimSlotStatus;->portInfo:[Landroid/hardware/radio/config/SimPortInfo;

    aget-object v11, v11, v9

    iget-object v12, v11, Landroid/hardware/radio/config/SimPortInfo;->iccId:Ljava/lang/String;

    iput-object v12, v10, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mIccId:Ljava/lang/String;

    .line 4480
    iget-boolean v12, v11, Landroid/hardware/radio/config/SimPortInfo;->portActive:Z

    if-eqz v12, :cond_0

    .line 4481
    iget v11, v11, Landroid/hardware/radio/config/SimPortInfo;->logicalSlotId:I

    goto :goto_2

    :cond_0
    move v11, v1

    :goto_2
    iput v11, v10, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mLogicalSlotIndex:I

    .line 4482
    iput-boolean v12, v10, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mPortActive:Z

    .line 4483
    iget-object v11, v7, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    aput-object v10, v11, v9

    add-int/lit8 v9, v9, 0x1

    goto :goto_1

    .line 4485
    :cond_1
    iget-object v8, v6, Landroid/hardware/radio/config/SimSlotStatus;->atr:Ljava/lang/String;

    iput-object v8, v7, Lcom/android/internal/telephony/uicc/IccSlotStatus;->atr:Ljava/lang/String;

    .line 4486
    iget-object v6, v6, Landroid/hardware/radio/config/SimSlotStatus;->eid:Ljava/lang/String;

    iput-object v6, v7, Lcom/android/internal/telephony/uicc/IccSlotStatus;->eid:Ljava/lang/String;

    .line 4487
    invoke-virtual {v0, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/ClassCastException; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_2
    return-object v0

    :catch_0
    const/4 v3, 0x1

    .line 4493
    :try_start_1
    move-object v4, p0

    check-cast v4, Ljava/util/ArrayList;

    .line 4496
    invoke-virtual {v4}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_3
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_5

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/hardware/radio/config/V1_2/SimSlotStatus;

    .line 4497
    new-instance v6, Lcom/android/internal/telephony/uicc/IccSlotStatus;

    invoke-direct {v6}, Lcom/android/internal/telephony/uicc/IccSlotStatus;-><init>()V

    .line 4498
    iget-object v7, v5, Landroid/hardware/radio/config/V1_2/SimSlotStatus;->base:Landroid/hardware/radio/config/V1_0/SimSlotStatus;

    iget v7, v7, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->cardState:I

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/uicc/IccSlotStatus;->setCardState(I)V

    new-array v7, v3, [Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    .line 4500
    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    .line 4501
    new-instance v7, Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    invoke-direct {v7}, Lcom/android/internal/telephony/uicc/IccSimPortInfo;-><init>()V

    .line 4502
    iget-object v8, v5, Landroid/hardware/radio/config/V1_2/SimSlotStatus;->base:Landroid/hardware/radio/config/V1_0/SimSlotStatus;

    iget-object v9, v8, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->iccid:Ljava/lang/String;

    iput-object v9, v7, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mIccId:Ljava/lang/String;

    .line 4503
    iget v9, v8, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->slotState:I

    if-ne v9, v3, :cond_3

    move v9, v3

    goto :goto_4

    :cond_3
    move v9, v2

    :goto_4
    iput-boolean v9, v7, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mPortActive:Z

    if-eqz v9, :cond_4

    .line 4507
    iget v9, v8, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->logicalSlotId:I

    goto :goto_5

    :cond_4
    move v9, v1

    :goto_5
    iput v9, v7, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mLogicalSlotIndex:I

    .line 4508
    iget-object v9, v6, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    aput-object v7, v9, v2

    .line 4509
    iget-object v7, v8, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->atr:Ljava/lang/String;

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccSlotStatus;->atr:Ljava/lang/String;

    .line 4510
    iget-object v5, v5, Landroid/hardware/radio/config/V1_2/SimSlotStatus;->eid:Ljava/lang/String;

    iput-object v5, v6, Lcom/android/internal/telephony/uicc/IccSlotStatus;->eid:Ljava/lang/String;

    .line 4511
    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/ClassCastException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_3

    :cond_5
    return-object v0

    .line 4517
    :catch_1
    :try_start_2
    check-cast p0, Ljava/util/ArrayList;

    .line 4520
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_6
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_8

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;

    .line 4521
    new-instance v5, Lcom/android/internal/telephony/uicc/IccSlotStatus;

    invoke-direct {v5}, Lcom/android/internal/telephony/uicc/IccSlotStatus;-><init>()V

    .line 4522
    iget v6, v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->cardState:I

    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/uicc/IccSlotStatus;->setCardState(I)V

    new-array v6, v3, [Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    .line 4524
    iput-object v6, v5, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    .line 4525
    new-instance v6, Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    invoke-direct {v6}, Lcom/android/internal/telephony/uicc/IccSimPortInfo;-><init>()V

    .line 4526
    iget-object v7, v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->iccid:Ljava/lang/String;

    iput-object v7, v6, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mIccId:Ljava/lang/String;

    .line 4527
    iget v7, v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->slotState:I

    if-ne v7, v3, :cond_6

    move v7, v3

    goto :goto_7

    :cond_6
    move v7, v2

    :goto_7
    iput-boolean v7, v6, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mPortActive:Z

    if-eqz v7, :cond_7

    .line 4531
    iget v7, v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->logicalSlotId:I

    goto :goto_8

    :cond_7
    move v7, v1

    :goto_8
    iput v7, v6, Lcom/android/internal/telephony/uicc/IccSimPortInfo;->mLogicalSlotIndex:I

    .line 4532
    iget-object v7, v5, Lcom/android/internal/telephony/uicc/IccSlotStatus;->mSimPortInfos:[Lcom/android/internal/telephony/uicc/IccSimPortInfo;

    aput-object v6, v7, v2

    .line 4533
    iget-object v4, v4, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->atr:Ljava/lang/String;

    iput-object v4, v5, Lcom/android/internal/telephony/uicc/IccSlotStatus;->atr:Ljava/lang/String;

    .line 4534
    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_2
    .catch Ljava/lang/ClassCastException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_6

    :catch_2
    :cond_8
    return-object v0
.end method

.method public static convertHalTdscdmaSignalStrength(Landroid/hardware/radio/network/TdscdmaSignalStrength;)Landroid/telephony/CellSignalStrengthTdscdma;
    .locals 3

    .line 3239
    new-instance v0, Landroid/telephony/CellSignalStrengthTdscdma;

    iget v1, p0, Landroid/hardware/radio/network/TdscdmaSignalStrength;->signalStrength:I

    .line 3240
    invoke-static {v1}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v1

    iget v2, p0, Landroid/hardware/radio/network/TdscdmaSignalStrength;->bitErrorRate:I

    iget p0, p0, Landroid/hardware/radio/network/TdscdmaSignalStrength;->rscp:I

    .line 3241
    invoke-static {p0}, Landroid/telephony/CellSignalStrength;->getRscpDbmFromAsu(I)I

    move-result p0

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/CellSignalStrengthTdscdma;-><init>(III)V

    .line 3242
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthTdscdma;->getRssi()I

    move-result p0

    const v1, 0x7fffffff

    if-ne p0, v1, :cond_0

    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthTdscdma;->getRscp()I

    move-result p0

    if-ne p0, v1, :cond_0

    .line 3243
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthTdscdma;->setDefaultValues()V

    const/4 p0, 0x0

    .line 3244
    invoke-virtual {v0, p0, p0}, Landroid/telephony/CellSignalStrengthTdscdma;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_0
    return-object v0
.end method

.method public static convertHalTdscdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthTdscdma;
    .locals 5

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 3211
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;

    const v2, 0x7fffffff

    if-eqz v1, :cond_2

    .line 3212
    check-cast p0, Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;

    .line 3214
    new-instance v1, Landroid/telephony/CellSignalStrengthTdscdma;

    .line 3215
    iget p0, p0, Landroid/hardware/radio/V1_0/TdScdmaSignalStrength;->rscp:I

    if-eq p0, v2, :cond_1

    neg-int p0, p0

    :cond_1
    invoke-direct {v1, v2, v2, p0}, Landroid/telephony/CellSignalStrengthTdscdma;-><init>(III)V

    goto :goto_0

    .line 3216
    :cond_2
    instance-of v1, p0, Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    if-eqz v1, :cond_3

    .line 3217
    check-cast p0, Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;

    .line 3219
    new-instance v1, Landroid/telephony/CellSignalStrengthTdscdma;

    iget v3, p0, Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;->signalStrength:I

    .line 3220
    invoke-static {v3}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v3

    iget v4, p0, Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;->bitErrorRate:I

    iget p0, p0, Landroid/hardware/radio/V1_2/TdscdmaSignalStrength;->rscp:I

    .line 3221
    invoke-static {p0}, Landroid/telephony/CellSignalStrength;->getRscpDbmFromAsu(I)I

    move-result p0

    invoke-direct {v1, v3, v4, p0}, Landroid/telephony/CellSignalStrengthTdscdma;-><init>(III)V

    goto :goto_0

    :cond_3
    move-object v1, v0

    :goto_0
    if-eqz v1, :cond_4

    .line 3223
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthTdscdma;->getRssi()I

    move-result p0

    if-ne p0, v2, :cond_4

    .line 3224
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthTdscdma;->getRscp()I

    move-result p0

    if-ne p0, v2, :cond_4

    .line 3225
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthTdscdma;->setDefaultValues()V

    .line 3226
    invoke-virtual {v1, v0, v0}, Landroid/telephony/CellSignalStrengthTdscdma;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_4
    return-object v1
.end method

.method private static convertHalTrafficDescriptor(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 3719
    iget-object v0, p0, Landroid/hardware/radio/V1_6/TrafficDescriptor;->dnn:Landroid/hardware/radio/V1_6/OptionalDnn;

    .line 3718
    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/OptionalDnn;->getDiscriminator()B

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    move-object v0, v1

    goto :goto_0

    .line 3720
    :cond_0
    iget-object v0, p0, Landroid/hardware/radio/V1_6/TrafficDescriptor;->dnn:Landroid/hardware/radio/V1_6/OptionalDnn;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/OptionalDnn;->value()Ljava/lang/String;

    move-result-object v0

    .line 3722
    :goto_0
    iget-object v2, p0, Landroid/hardware/radio/V1_6/TrafficDescriptor;->osAppId:Landroid/hardware/radio/V1_6/OptionalOsAppId;

    .line 3721
    invoke-virtual {v2}, Landroid/hardware/radio/V1_6/OptionalOsAppId;->getDiscriminator()B

    move-result v2

    if-nez v2, :cond_1

    goto :goto_1

    .line 3723
    :cond_1
    iget-object p0, p0, Landroid/hardware/radio/V1_6/TrafficDescriptor;->osAppId:Landroid/hardware/radio/V1_6/OptionalOsAppId;

    invoke-virtual {p0}, Landroid/hardware/radio/V1_6/OptionalOsAppId;->value()Landroid/hardware/radio/V1_6/OsAppId;

    move-result-object p0

    iget-object p0, p0, Landroid/hardware/radio/V1_6/OsAppId;->osAppId:Ljava/util/ArrayList;

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->arrayListToPrimitiveArray(Ljava/util/ArrayList;)[B

    move-result-object v1

    .line 3725
    :goto_1
    new-instance p0, Landroid/telephony/data/TrafficDescriptor$Builder;

    invoke-direct {p0}, Landroid/telephony/data/TrafficDescriptor$Builder;-><init>()V

    if-eqz v0, :cond_2

    .line 3727
    invoke-virtual {p0, v0}, Landroid/telephony/data/TrafficDescriptor$Builder;->setDataNetworkName(Ljava/lang/String;)Landroid/telephony/data/TrafficDescriptor$Builder;

    :cond_2
    if-eqz v1, :cond_3

    .line 3730
    invoke-virtual {p0, v1}, Landroid/telephony/data/TrafficDescriptor$Builder;->setOsAppId([B)Landroid/telephony/data/TrafficDescriptor$Builder;

    .line 3732
    :cond_3
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor$Builder;->build()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0

    return-object p0
.end method

.method private static convertHalTrafficDescriptor(Landroid/hardware/radio/data/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation

    .line 3737
    iget-object v0, p0, Landroid/hardware/radio/data/TrafficDescriptor;->dnn:Ljava/lang/String;

    .line 3738
    iget-object p0, p0, Landroid/hardware/radio/data/TrafficDescriptor;->osAppId:Landroid/hardware/radio/data/OsAppId;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Landroid/hardware/radio/data/OsAppId;->osAppId:[B

    .line 3739
    :goto_0
    new-instance v1, Landroid/telephony/data/TrafficDescriptor$Builder;

    invoke-direct {v1}, Landroid/telephony/data/TrafficDescriptor$Builder;-><init>()V

    if-eqz v0, :cond_1

    .line 3741
    invoke-virtual {v1, v0}, Landroid/telephony/data/TrafficDescriptor$Builder;->setDataNetworkName(Ljava/lang/String;)Landroid/telephony/data/TrafficDescriptor$Builder;

    :cond_1
    if-eqz p0, :cond_2

    .line 3744
    invoke-virtual {v1, p0}, Landroid/telephony/data/TrafficDescriptor$Builder;->setOsAppId([B)Landroid/telephony/data/TrafficDescriptor$Builder;

    .line 3746
    :cond_2
    invoke-virtual {v1}, Landroid/telephony/data/TrafficDescriptor$Builder;->build()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0

    return-object p0
.end method

.method public static convertHalWcdmaSignalStrength(Landroid/hardware/radio/network/WcdmaSignalStrength;)Landroid/telephony/CellSignalStrengthWcdma;
    .locals 4

    .line 3190
    new-instance v0, Landroid/telephony/CellSignalStrengthWcdma;

    iget v1, p0, Landroid/hardware/radio/network/WcdmaSignalStrength;->signalStrength:I

    .line 3191
    invoke-static {v1}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v1

    iget v2, p0, Landroid/hardware/radio/network/WcdmaSignalStrength;->bitErrorRate:I

    iget v3, p0, Landroid/hardware/radio/network/WcdmaSignalStrength;->rscp:I

    .line 3192
    invoke-static {v3}, Landroid/telephony/CellSignalStrength;->getRscpDbmFromAsu(I)I

    move-result v3

    iget p0, p0, Landroid/hardware/radio/network/WcdmaSignalStrength;->ecno:I

    .line 3193
    invoke-static {p0}, Landroid/telephony/CellSignalStrength;->getEcNoDbFromAsu(I)I

    move-result p0

    invoke-direct {v0, v1, v2, v3, p0}, Landroid/telephony/CellSignalStrengthWcdma;-><init>(IIII)V

    .line 3194
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthWcdma;->getRssi()I

    move-result p0

    const v1, 0x7fffffff

    if-ne p0, v1, :cond_0

    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthWcdma;->getRscp()I

    move-result p0

    if-ne p0, v1, :cond_0

    .line 3195
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthWcdma;->setDefaultValues()V

    const/4 p0, 0x0

    .line 3196
    invoke-virtual {v0, p0, p0}, Landroid/telephony/CellSignalStrengthWcdma;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_0
    return-object v0
.end method

.method public static convertHalWcdmaSignalStrength(Ljava/lang/Object;)Landroid/telephony/CellSignalStrengthWcdma;
    .locals 6

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 3161
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;

    const v2, 0x7fffffff

    if-eqz v1, :cond_1

    .line 3162
    check-cast p0, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;

    .line 3164
    new-instance v1, Landroid/telephony/CellSignalStrengthWcdma;

    iget v3, p0, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;->signalStrength:I

    .line 3165
    invoke-static {v3}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v3

    iget p0, p0, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;->bitErrorRate:I

    invoke-direct {v1, v3, p0, v2, v2}, Landroid/telephony/CellSignalStrengthWcdma;-><init>(IIII)V

    goto :goto_0

    .line 3167
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    if-eqz v1, :cond_2

    .line 3168
    check-cast p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;

    .line 3170
    new-instance v1, Landroid/telephony/CellSignalStrengthWcdma;

    iget-object v3, p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;->base:Landroid/hardware/radio/V1_0/WcdmaSignalStrength;

    iget v3, v3, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;->signalStrength:I

    .line 3171
    invoke-static {v3}, Landroid/telephony/CellSignalStrength;->getRssiDbmFromAsu(I)I

    move-result v3

    iget-object v4, p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;->base:Landroid/hardware/radio/V1_0/WcdmaSignalStrength;

    iget v4, v4, Landroid/hardware/radio/V1_0/WcdmaSignalStrength;->bitErrorRate:I

    iget v5, p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;->rscp:I

    .line 3172
    invoke-static {v5}, Landroid/telephony/CellSignalStrength;->getRscpDbmFromAsu(I)I

    move-result v5

    iget p0, p0, Landroid/hardware/radio/V1_2/WcdmaSignalStrength;->ecno:I

    .line 3173
    invoke-static {p0}, Landroid/telephony/CellSignalStrength;->getEcNoDbFromAsu(I)I

    move-result p0

    invoke-direct {v1, v3, v4, v5, p0}, Landroid/telephony/CellSignalStrengthWcdma;-><init>(IIII)V

    goto :goto_0

    :cond_2
    move-object v1, v0

    :goto_0
    if-eqz v1, :cond_3

    .line 3175
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthWcdma;->getRssi()I

    move-result p0

    if-ne p0, v2, :cond_3

    .line 3176
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthWcdma;->getRscp()I

    move-result p0

    if-ne p0, v2, :cond_3

    .line 3177
    invoke-virtual {v1}, Landroid/telephony/CellSignalStrengthWcdma;->setDefaultValues()V

    .line 3178
    invoke-virtual {v1, v0, v0}, Landroid/telephony/CellSignalStrengthWcdma;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    :cond_3
    return-object v1
.end method

.method public static convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method public static convertSimSlotsMapping(Ljava/util/List;)[Landroid/hardware/radio/config/SlotPortMapping;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/UiccSlotMapping;",
            ">;)[",
            "Landroid/hardware/radio/config/SlotPortMapping;"
        }
    .end annotation

    .line 4549
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    new-array v0, v0, [Landroid/hardware/radio/config/SlotPortMapping;

    .line 4550
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/UiccSlotMapping;

    .line 4551
    invoke-virtual {v1}, Landroid/telephony/UiccSlotMapping;->getLogicalSlotIndex()I

    move-result v2

    .line 4552
    new-instance v3, Landroid/hardware/radio/config/SlotPortMapping;

    invoke-direct {v3}, Landroid/hardware/radio/config/SlotPortMapping;-><init>()V

    aput-object v3, v0, v2

    .line 4553
    invoke-virtual {v1}, Landroid/telephony/UiccSlotMapping;->getPhysicalSlotIndex()I

    move-result v4

    iput v4, v3, Landroid/hardware/radio/config/SlotPortMapping;->physicalSlotId:I

    .line 4554
    aget-object v2, v0, v2

    invoke-virtual {v1}, Landroid/telephony/UiccSlotMapping;->getPortIndex()I

    move-result v1

    iput v1, v2, Landroid/hardware/radio/config/SlotPortMapping;->portId:I

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static convertSlotMappingToList(Ljava/util/List;)Ljava/util/ArrayList;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/UiccSlotMapping;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 4562
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    new-array v0, v0, [I

    .line 4563
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/UiccSlotMapping;

    .line 4564
    invoke-virtual {v1}, Landroid/telephony/UiccSlotMapping;->getLogicalSlotIndex()I

    move-result v2

    invoke-virtual {v1}, Landroid/telephony/UiccSlotMapping;->getPhysicalSlotIndex()I

    move-result v1

    aput v1, v0, v2

    goto :goto_0

    .line 4566
    :cond_0
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public static convertToCensoredTerminalResponse(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 1444
    :try_start_0
    invoke-static {p0}, Lcom/android/internal/telephony/uicc/IccUtils;->hexStringToBytes(Ljava/lang/String;)[B

    move-result-object v0

    if-eqz v0, :cond_1

    const/4 v1, 0x0

    .line 1446
    invoke-static {v0, v1}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->decodeMany([BI)Ljava/util/List;

    move-result-object v0

    .line 1448
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/cat/ComprehensionTlv;

    .line 1451
    sget-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->TEXT_STRING:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-virtual {v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->value()I

    move-result v3

    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getTag()I

    move-result v4

    if-ne v3, v4, :cond_0

    .line 1452
    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getRawValue()[B

    move-result-object v3

    .line 1453
    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getValueIndex()I

    move-result v4

    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getLength()I

    move-result v5

    add-int/2addr v4, v5

    .line 1452
    invoke-static {v3, v1, v4}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v1

    .line 1454
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 1455
    invoke-static {v1}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v1

    const-string v3, "********"

    .line 1454
    invoke-virtual {p0, v1, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    .line 1458
    :cond_0
    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getValueIndex()I

    move-result v1

    invoke-virtual {v2}, Lcom/android/internal/telephony/cat/ComprehensionTlv;->getLength()I

    move-result v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/2addr v1, v2

    goto :goto_0

    :catch_0
    const/4 p0, 0x0

    :cond_1
    return-object p0
.end method

.method public static convertToDataProfile(Landroid/hardware/radio/data/DataProfileInfo;)Landroid/telephony/data/DataProfile;
    .locals 4

    .line 1014
    new-instance v0, Landroid/telephony/data/ApnSetting$Builder;

    invoke-direct {v0}, Landroid/telephony/data/ApnSetting$Builder;-><init>()V

    iget-object v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->apn:Ljava/lang/String;

    .line 1015
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setEntryName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-object v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->apn:Ljava/lang/String;

    .line 1016
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setApnName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->supportedApnTypesBitmap:I

    .line 1017
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setApnTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->authType:I

    .line 1018
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setAuthType(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->maxConnsTime:I

    .line 1019
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setMaxConnsTime(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->maxConns:I

    .line 1020
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setMaxConns(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->waitTime:I

    .line 1021
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setWaitTime(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-boolean v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->enabled:Z

    .line 1022
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setCarrierEnabled(Z)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-boolean v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->persistent:Z

    .line 1023
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setModemCognitive(Z)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->mtuV4:I

    .line 1024
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setMtuV4(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->mtuV6:I

    .line 1025
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setMtuV6(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->bearerBitmap:I

    .line 1026
    invoke-static {v1}, Landroid/telephony/ServiceState;->convertBearerBitmaskToNetworkTypeBitmask(I)I

    move-result v1

    shr-int/lit8 v1, v1, 0x1

    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setNetworkTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->profileId:I

    .line 1028
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setProfileId(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-object v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->password:Ljava/lang/String;

    .line 1029
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setPassword(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->protocol:I

    .line 1030
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->roamingProtocol:I

    .line 1031
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setRoamingProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-object v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->user:Ljava/lang/String;

    .line 1032
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setUser(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    iget-boolean v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->alwaysOn:Z

    .line 1033
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting$Builder;->setAlwaysOn(Z)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object v0

    .line 1034
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting$Builder;->build()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    .line 1038
    :try_start_0
    iget-object v1, p0, Landroid/hardware/radio/data/DataProfileInfo;->trafficDescriptor:Landroid/hardware/radio/data/TrafficDescriptor;

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertHalTrafficDescriptor(Landroid/hardware/radio/data/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 1040
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "convertToDataProfile: Failed to convert traffic descriptor. e="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    const/4 v1, 0x0

    .line 1044
    :goto_0
    new-instance v2, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v2}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    iget v3, p0, Landroid/hardware/radio/data/DataProfileInfo;->type:I

    .line 1045
    invoke-virtual {v2, v3}, Landroid/telephony/data/DataProfile$Builder;->setType(I)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v2

    iget-boolean p0, p0, Landroid/hardware/radio/data/DataProfileInfo;->preferred:Z

    .line 1046
    invoke-virtual {v2, p0}, Landroid/telephony/data/DataProfile$Builder;->setPreferred(Z)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    .line 1047
    invoke-virtual {p0, v1}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    .line 1048
    invoke-virtual {p0, v0}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    .line 1049
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object p0

    return-object p0
.end method

.method public static convertToDriverCall(Landroid/hardware/radio/voice/Call;)Lcom/android/internal/telephony/DriverCall;
    .locals 4

    .line 4150
    new-instance v0, Lcom/android/internal/telephony/DriverCall;

    invoke-direct {v0}, Lcom/android/internal/telephony/DriverCall;-><init>()V

    .line 4151
    iget v1, p0, Landroid/hardware/radio/voice/Call;->state:I

    invoke-static {v1}, Lcom/android/internal/telephony/DriverCall;->stateFromCLCC(I)Lcom/android/internal/telephony/DriverCall$State;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/DriverCall;->state:Lcom/android/internal/telephony/DriverCall$State;

    .line 4152
    iget v1, p0, Landroid/hardware/radio/voice/Call;->index:I

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->index:I

    .line 4153
    iget v1, p0, Landroid/hardware/radio/voice/Call;->toa:I

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->TOA:I

    .line 4154
    iget-boolean v1, p0, Landroid/hardware/radio/voice/Call;->isMpty:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/DriverCall;->isMpty:Z

    .line 4155
    iget-boolean v1, p0, Landroid/hardware/radio/voice/Call;->isMT:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/DriverCall;->isMT:Z

    .line 4156
    iget-byte v1, p0, Landroid/hardware/radio/voice/Call;->als:B

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->als:I

    .line 4157
    iget-boolean v1, p0, Landroid/hardware/radio/voice/Call;->isVoice:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/DriverCall;->isVoice:Z

    .line 4158
    iget-boolean v1, p0, Landroid/hardware/radio/voice/Call;->isVoicePrivacy:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/DriverCall;->isVoicePrivacy:Z

    .line 4159
    iget-object v1, p0, Landroid/hardware/radio/voice/Call;->number:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    .line 4160
    iget v1, p0, Landroid/hardware/radio/voice/Call;->numberPresentation:I

    invoke-static {v1}, Lcom/android/internal/telephony/DriverCall;->presentationFromCLIP(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->numberPresentation:I

    .line 4161
    iget-object v1, p0, Landroid/hardware/radio/voice/Call;->name:Ljava/lang/String;

    iput-object v1, v0, Lcom/android/internal/telephony/DriverCall;->name:Ljava/lang/String;

    .line 4162
    iget v1, p0, Landroid/hardware/radio/voice/Call;->namePresentation:I

    invoke-static {v1}, Lcom/android/internal/telephony/DriverCall;->presentationFromCLIP(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->namePresentation:I

    .line 4163
    iget-object v1, p0, Landroid/hardware/radio/voice/Call;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    array-length v1, v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_0

    .line 4164
    new-instance v1, Lcom/android/internal/telephony/UUSInfo;

    invoke-direct {v1}, Lcom/android/internal/telephony/UUSInfo;-><init>()V

    iput-object v1, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    .line 4165
    iget-object v2, p0, Landroid/hardware/radio/voice/Call;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    const/4 v3, 0x0

    aget-object v2, v2, v3

    iget v2, v2, Landroid/hardware/radio/voice/UusInfo;->uusType:I

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/UUSInfo;->setType(I)V

    .line 4166
    iget-object v1, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    iget-object v2, p0, Landroid/hardware/radio/voice/Call;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    aget-object v2, v2, v3

    iget v2, v2, Landroid/hardware/radio/voice/UusInfo;->uusDcs:I

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/UUSInfo;->setDcs(I)V

    .line 4167
    iget-object v1, p0, Landroid/hardware/radio/voice/Call;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    aget-object v1, v1, v3

    iget-object v1, v1, Landroid/hardware/radio/voice/UusInfo;->uusData:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 4168
    iget-object v1, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    iget-object v2, p0, Landroid/hardware/radio/voice/Call;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    aget-object v2, v2, v3

    iget-object v2, v2, Landroid/hardware/radio/voice/UusInfo;->uusData:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/UUSInfo;->setUserData([B)V

    .line 4172
    :cond_0
    iget-object v1, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    iget v2, v0, Lcom/android/internal/telephony/DriverCall;->TOA:I

    invoke-static {v1, v2}, Landroid/telephony/PhoneNumberUtils;->stringFromStringAndTOA(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    .line 4173
    iget v1, p0, Landroid/hardware/radio/voice/Call;->audioQuality:I

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->audioQuality:I

    .line 4174
    iget-object p0, p0, Landroid/hardware/radio/voice/Call;->forwardedNumber:Ljava/lang/String;

    iput-object p0, v0, Lcom/android/internal/telephony/DriverCall;->forwardedNumber:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToDriverCall(Ljava/lang/Object;)Lcom/android/internal/telephony/DriverCall;
    .locals 7

    .line 4088
    new-instance v0, Lcom/android/internal/telephony/DriverCall;

    invoke-direct {v0}, Lcom/android/internal/telephony/DriverCall;-><init>()V

    .line 4092
    instance-of v1, p0, Landroid/hardware/radio/V1_6/Call;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 4093
    move-object v2, p0

    check-cast v2, Landroid/hardware/radio/V1_6/Call;

    .line 4094
    iget-object p0, v2, Landroid/hardware/radio/V1_6/Call;->base:Landroid/hardware/radio/V1_2/Call;

    .line 4095
    iget-object v1, p0, Landroid/hardware/radio/V1_2/Call;->base:Landroid/hardware/radio/V1_0/Call;

    :goto_0
    move-object v6, v1

    move-object v1, p0

    move-object p0, v2

    move-object v2, v6

    goto :goto_1

    .line 4096
    :cond_0
    instance-of v1, p0, Landroid/hardware/radio/V1_2/Call;

    if-eqz v1, :cond_1

    .line 4098
    check-cast p0, Landroid/hardware/radio/V1_2/Call;

    .line 4099
    iget-object v1, p0, Landroid/hardware/radio/V1_2/Call;->base:Landroid/hardware/radio/V1_0/Call;

    goto :goto_0

    .line 4100
    :cond_1
    instance-of v1, p0, Landroid/hardware/radio/V1_0/Call;

    if-eqz v1, :cond_2

    .line 4103
    check-cast p0, Landroid/hardware/radio/V1_0/Call;

    move-object v1, v2

    move-object v2, p0

    move-object p0, v1

    goto :goto_1

    :cond_2
    move-object p0, v2

    move-object v1, p0

    :goto_1
    if-eqz v2, :cond_4

    .line 4110
    iget v3, v2, Landroid/hardware/radio/V1_0/Call;->state:I

    invoke-static {v3}, Lcom/android/internal/telephony/DriverCall;->stateFromCLCC(I)Lcom/android/internal/telephony/DriverCall$State;

    move-result-object v3

    iput-object v3, v0, Lcom/android/internal/telephony/DriverCall;->state:Lcom/android/internal/telephony/DriverCall$State;

    .line 4111
    iget v3, v2, Landroid/hardware/radio/V1_0/Call;->index:I

    iput v3, v0, Lcom/android/internal/telephony/DriverCall;->index:I

    .line 4112
    iget v3, v2, Landroid/hardware/radio/V1_0/Call;->toa:I

    iput v3, v0, Lcom/android/internal/telephony/DriverCall;->TOA:I

    .line 4113
    iget-boolean v3, v2, Landroid/hardware/radio/V1_0/Call;->isMpty:Z

    iput-boolean v3, v0, Lcom/android/internal/telephony/DriverCall;->isMpty:Z

    .line 4114
    iget-boolean v3, v2, Landroid/hardware/radio/V1_0/Call;->isMT:Z

    iput-boolean v3, v0, Lcom/android/internal/telephony/DriverCall;->isMT:Z

    .line 4115
    iget-byte v3, v2, Landroid/hardware/radio/V1_0/Call;->als:B

    iput v3, v0, Lcom/android/internal/telephony/DriverCall;->als:I

    .line 4116
    iget-boolean v3, v2, Landroid/hardware/radio/V1_0/Call;->isVoice:Z

    iput-boolean v3, v0, Lcom/android/internal/telephony/DriverCall;->isVoice:Z

    .line 4117
    iget-boolean v3, v2, Landroid/hardware/radio/V1_0/Call;->isVoicePrivacy:Z

    iput-boolean v3, v0, Lcom/android/internal/telephony/DriverCall;->isVoicePrivacy:Z

    .line 4118
    iget-object v3, v2, Landroid/hardware/radio/V1_0/Call;->number:Ljava/lang/String;

    iput-object v3, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    .line 4119
    iget v3, v2, Landroid/hardware/radio/V1_0/Call;->numberPresentation:I

    invoke-static {v3}, Lcom/android/internal/telephony/DriverCall;->presentationFromCLIP(I)I

    move-result v3

    iput v3, v0, Lcom/android/internal/telephony/DriverCall;->numberPresentation:I

    .line 4121
    iget-object v3, v2, Landroid/hardware/radio/V1_0/Call;->name:Ljava/lang/String;

    iput-object v3, v0, Lcom/android/internal/telephony/DriverCall;->name:Ljava/lang/String;

    .line 4122
    iget v3, v2, Landroid/hardware/radio/V1_0/Call;->namePresentation:I

    invoke-static {v3}, Lcom/android/internal/telephony/DriverCall;->presentationFromCLIP(I)I

    move-result v3

    iput v3, v0, Lcom/android/internal/telephony/DriverCall;->namePresentation:I

    .line 4123
    iget-object v3, v2, Landroid/hardware/radio/V1_0/Call;->uusInfo:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :cond_3

    .line 4124
    new-instance v3, Lcom/android/internal/telephony/UUSInfo;

    invoke-direct {v3}, Lcom/android/internal/telephony/UUSInfo;-><init>()V

    iput-object v3, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    .line 4125
    iget-object v4, v2, Landroid/hardware/radio/V1_0/Call;->uusInfo:Ljava/util/ArrayList;

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/hardware/radio/V1_0/UusInfo;

    iget v4, v4, Landroid/hardware/radio/V1_0/UusInfo;->uusType:I

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/UUSInfo;->setType(I)V

    .line 4126
    iget-object v3, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    iget-object v4, v2, Landroid/hardware/radio/V1_0/Call;->uusInfo:Ljava/util/ArrayList;

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/hardware/radio/V1_0/UusInfo;

    iget v4, v4, Landroid/hardware/radio/V1_0/UusInfo;->uusDcs:I

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/UUSInfo;->setDcs(I)V

    .line 4127
    iget-object v3, v2, Landroid/hardware/radio/V1_0/Call;->uusInfo:Ljava/util/ArrayList;

    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/hardware/radio/V1_0/UusInfo;

    iget-object v3, v3, Landroid/hardware/radio/V1_0/UusInfo;->uusData:Ljava/lang/String;

    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_3

    .line 4128
    iget-object v2, v2, Landroid/hardware/radio/V1_0/Call;->uusInfo:Ljava/util/ArrayList;

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/hardware/radio/V1_0/UusInfo;

    iget-object v2, v2, Landroid/hardware/radio/V1_0/UusInfo;->uusData:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    .line 4129
    iget-object v3, v0, Lcom/android/internal/telephony/DriverCall;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    invoke-virtual {v3, v2}, Lcom/android/internal/telephony/UUSInfo;->setUserData([B)V

    .line 4133
    :cond_3
    iget-object v2, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    iget v3, v0, Lcom/android/internal/telephony/DriverCall;->TOA:I

    invoke-static {v2, v3}, Landroid/telephony/PhoneNumberUtils;->stringFromStringAndTOA(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v2

    iput-object v2, v0, Lcom/android/internal/telephony/DriverCall;->number:Ljava/lang/String;

    :cond_4
    if-eqz v1, :cond_5

    .line 4136
    iget v1, v1, Landroid/hardware/radio/V1_2/Call;->audioQuality:I

    iput v1, v0, Lcom/android/internal/telephony/DriverCall;->audioQuality:I

    :cond_5
    if-eqz p0, :cond_6

    .line 4139
    iget-object p0, p0, Landroid/hardware/radio/V1_6/Call;->forwardedNumber:Ljava/lang/String;

    iput-object p0, v0, Lcom/android/internal/telephony/DriverCall;->forwardedNumber:Ljava/lang/String;

    :cond_6
    return-object v0
.end method

.method public static convertToHalAccessNetwork(I)I
    .locals 0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x6

    return p0

    :pswitch_1
    const/4 p0, 0x5

    return p0

    :pswitch_2
    const/4 p0, 0x4

    return p0

    :pswitch_3
    const/4 p0, 0x3

    return p0

    :pswitch_4
    const/4 p0, 0x2

    return p0

    :pswitch_5
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertToHalAccessNetworkAidl(I)I
    .locals 0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x6

    return p0

    :pswitch_1
    const/4 p0, 0x5

    return p0

    :pswitch_2
    const/4 p0, 0x4

    return p0

    :pswitch_3
    const/4 p0, 0x3

    return p0

    :pswitch_4
    const/4 p0, 0x2

    return p0

    :pswitch_5
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertToHalCarrierRestrictionList(Ljava/util/List;)Ljava/util/ArrayList;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/service/carrier/CarrierIdentifier;",
            ">;)",
            "Ljava/util/ArrayList<",
            "Landroid/hardware/radio/V1_0/Carrier;",
            ">;"
        }
    .end annotation

    .line 1872
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1873
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/service/carrier/CarrierIdentifier;

    .line 1874
    new-instance v2, Landroid/hardware/radio/V1_0/Carrier;

    invoke-direct {v2}, Landroid/hardware/radio/V1_0/Carrier;-><init>()V

    .line 1875
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getMcc()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_0/Carrier;->mcc:Ljava/lang/String;

    .line 1876
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getMnc()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_0/Carrier;->mnc:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    .line 1879
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getSpn()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_0

    const/4 v3, 0x1

    .line 1881
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getSpn()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    .line 1882
    :cond_0
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getImsi()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_1

    const/4 v3, 0x2

    .line 1884
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getImsi()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    .line 1885
    :cond_1
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getGid1()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_2

    const/4 v3, 0x3

    .line 1887
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getGid1()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    .line 1888
    :cond_2
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getGid2()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_3

    const/4 v3, 0x4

    .line 1890
    invoke-virtual {v1}, Landroid/service/carrier/CarrierIdentifier;->getGid2()Ljava/lang/String;

    move-result-object v4

    .line 1892
    :cond_3
    :goto_1
    iput v3, v2, Landroid/hardware/radio/V1_0/Carrier;->matchType:I

    .line 1893
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Landroid/hardware/radio/V1_0/Carrier;->matchData:Ljava/lang/String;

    .line 1894
    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_4
    return-object v0
.end method

.method public static convertToHalCarrierRestrictionListAidl(Ljava/util/List;)[Landroid/hardware/radio/sim/Carrier;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/service/carrier/CarrierIdentifier;",
            ">;)[",
            "Landroid/hardware/radio/sim/Carrier;"
        }
    .end annotation

    .line 1907
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v0

    new-array v0, v0, [Landroid/hardware/radio/sim/Carrier;

    const/4 v1, 0x0

    move v2, v1

    .line 1908
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v3

    if-ge v2, v3, :cond_4

    .line 1909
    invoke-interface {p0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/service/carrier/CarrierIdentifier;

    .line 1910
    new-instance v4, Landroid/hardware/radio/sim/Carrier;

    invoke-direct {v4}, Landroid/hardware/radio/sim/Carrier;-><init>()V

    .line 1911
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getMcc()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v4, Landroid/hardware/radio/sim/Carrier;->mcc:Ljava/lang/String;

    .line 1912
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getMnc()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v4, Landroid/hardware/radio/sim/Carrier;->mnc:Ljava/lang/String;

    const/4 v5, 0x0

    .line 1915
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getSpn()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 1917
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getSpn()Ljava/lang/String;

    move-result-object v5

    const/4 v3, 0x1

    goto :goto_2

    .line 1918
    :cond_0
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getImsi()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_1

    const/4 v5, 0x2

    .line 1920
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getImsi()Ljava/lang/String;

    move-result-object v3

    :goto_1
    move v7, v5

    move-object v5, v3

    move v3, v7

    goto :goto_2

    .line 1921
    :cond_1
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getGid1()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_2

    const/4 v5, 0x3

    .line 1923
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getGid1()Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    .line 1924
    :cond_2
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getGid2()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_3

    const/4 v5, 0x4

    .line 1926
    invoke-virtual {v3}, Landroid/service/carrier/CarrierIdentifier;->getGid2()Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    :cond_3
    move v3, v1

    .line 1928
    :goto_2
    iput v3, v4, Landroid/hardware/radio/sim/Carrier;->matchType:I

    .line 1929
    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v4, Landroid/hardware/radio/sim/Carrier;->matchData:Ljava/lang/String;

    .line 1930
    aput-object v4, v0, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_4
    return-object v0
.end method

.method public static convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;
    .locals 7

    .line 597
    new-instance v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/CdmaSmsMessage;-><init>()V

    .line 602
    new-instance v1, Ljava/io/ByteArrayInputStream;

    invoke-direct {v1, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    .line 603
    new-instance p0, Ljava/io/DataInputStream;

    invoke-direct {p0, v1}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    .line 606
    :try_start_0
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->teleserviceId:I

    .line 607
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    int-to-byte v1, v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-ne v1, v3, :cond_0

    move v1, v3

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    iput-boolean v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->isServicePresent:Z

    .line 608
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->serviceCategory:I

    .line 609
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->digitMode:I

    .line 610
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberMode:I

    .line 611
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberType:I

    .line 612
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->numberPlan:I

    .line 613
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    int-to-byte v1, v1

    move v4, v2

    :goto_1
    if-ge v4, v1, :cond_1

    .line 615
    iget-object v5, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->address:Landroid/hardware/radio/V1_0/CdmaSmsAddress;

    iget-object v5, v5, Landroid/hardware/radio/V1_0/CdmaSmsAddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v6

    invoke-static {v6}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 617
    :cond_1
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->subaddressType:I

    .line 618
    iget-object v1, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    int-to-byte v4, v4

    if-ne v4, v3, :cond_2

    goto :goto_2

    :cond_2
    move v3, v2

    :goto_2
    iput-boolean v3, v1, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->odd:Z

    .line 619
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    int-to-byte v1, v1

    move v3, v2

    :goto_3
    if-ge v3, v1, :cond_3

    .line 621
    iget-object v4, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;

    iget-object v4, v4, Landroid/hardware/radio/V1_0/CdmaSmsSubaddress;->digits:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v5

    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_3

    .line 624
    :cond_3
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    :goto_4
    if-ge v2, v1, :cond_4

    .line 626
    iget-object v3, v0, Landroid/hardware/radio/V1_0/CdmaSmsMessage;->bearerData:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v4

    invoke-static {v4}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v2, v2, 0x1

    goto :goto_4

    :catch_0
    :cond_4
    return-object v0
.end method

.method public static convertToHalCdmaSmsMessageAidl([B)Landroid/hardware/radio/messaging/CdmaSmsMessage;
    .locals 7

    .line 640
    new-instance v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/CdmaSmsMessage;-><init>()V

    .line 642
    new-instance v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;

    invoke-direct {v1}, Landroid/hardware/radio/messaging/CdmaSmsAddress;-><init>()V

    iput-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    .line 643
    new-instance v1, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    invoke-direct {v1}, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;-><init>()V

    iput-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    .line 647
    new-instance v1, Ljava/io/ByteArrayInputStream;

    invoke-direct {v1, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    .line 648
    new-instance p0, Ljava/io/DataInputStream;

    invoke-direct {p0, v1}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    .line 651
    :try_start_0
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->teleserviceId:I

    .line 652
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    int-to-byte v1, v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-ne v1, v3, :cond_0

    move v1, v3

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    iput-boolean v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->isServicePresent:Z

    .line 653
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readInt()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->serviceCategory:I

    .line 656
    new-instance v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;

    invoke-direct {v1}, Landroid/hardware/radio/messaging/CdmaSmsAddress;-><init>()V

    iput-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    .line 658
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;->digitMode:I

    .line 659
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    .line 660
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    if-ne v4, v3, :cond_1

    move v4, v3

    goto :goto_1

    :cond_1
    move v4, v2

    :goto_1
    iput-boolean v4, v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;->isNumberModeDataNetwork:Z

    .line 661
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;->numberType:I

    .line 662
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;->numberPlan:I

    .line 663
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    int-to-byte v1, v1

    .line 664
    new-array v4, v1, [B

    move v5, v2

    :goto_2
    if-ge v5, v1, :cond_2

    .line 666
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v6

    aput-byte v6, v4, v5

    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 668
    :cond_2
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->address:Landroid/hardware/radio/messaging/CdmaSmsAddress;

    iput-object v4, v1, Landroid/hardware/radio/messaging/CdmaSmsAddress;->digits:[B

    .line 670
    new-instance v1, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    invoke-direct {v1}, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;-><init>()V

    iput-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    .line 672
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    iput v4, v1, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->subaddressType:I

    .line 673
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v4

    int-to-byte v4, v4

    if-ne v4, v3, :cond_3

    goto :goto_3

    :cond_3
    move v3, v2

    :goto_3
    iput-boolean v3, v1, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->odd:Z

    .line 674
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    int-to-byte v1, v1

    .line 675
    new-array v3, v1, [B

    move v4, v2

    :goto_4
    if-ge v4, v1, :cond_4

    .line 677
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v5

    aput-byte v5, v3, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_4

    .line 679
    :cond_4
    iget-object v1, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->subAddress:Landroid/hardware/radio/messaging/CdmaSmsSubaddress;

    iput-object v3, v1, Landroid/hardware/radio/messaging/CdmaSmsSubaddress;->digits:[B

    .line 681
    invoke-virtual {p0}, Ljava/io/DataInputStream;->read()I

    move-result v1

    .line 682
    new-array v3, v1, [B

    :goto_5
    if-ge v2, v1, :cond_5

    .line 684
    invoke-virtual {p0}, Ljava/io/DataInputStream;->readByte()B

    move-result v4

    aput-byte v4, v3, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_5

    .line 686
    :cond_5
    iput-object v3, v0, Landroid/hardware/radio/messaging/CdmaSmsMessage;->bearerData:[B
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-object v0
.end method

.method public static convertToHalDataProfile(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/data/DataProfileInfo;
    .locals 2

    .line 971
    new-instance v0, Landroid/hardware/radio/data/DataProfileInfo;

    invoke-direct {v0}, Landroid/hardware/radio/data/DataProfileInfo;-><init>()V

    .line 974
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->apn:Ljava/lang/String;

    .line 975
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->protocol:I

    .line 976
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getRoamingProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->roamingProtocol:I

    .line 977
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getAuthType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->authType:I

    .line 978
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getUserName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->user:Ljava/lang/String;

    .line 979
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getPassword()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->password:Ljava/lang/String;

    .line 980
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->type:I

    .line 981
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnectionsTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->maxConnsTime:I

    .line 982
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnections()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->maxConns:I

    .line 983
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getWaitTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->waitTime:I

    .line 984
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isEnabled()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->enabled:Z

    .line 985
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getSupportedApnTypesBitmask()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->supportedApnTypesBitmap:I

    .line 989
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getBearerBitmask()I

    move-result v1

    .line 988
    invoke-static {v1}, Landroid/telephony/ServiceState;->convertNetworkTypeBitmaskToBearerBitmask(I)I

    move-result v1

    shl-int/lit8 v1, v1, 0x1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->bearerBitmap:I

    .line 990
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV4()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->mtuV4:I

    .line 991
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV6()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->mtuV6:I

    .line 992
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->persistent:Z

    .line 993
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPreferred()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->preferred:Z

    const/4 v1, 0x0

    .line 994
    iput-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->alwaysOn:Z

    .line 995
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 996
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->isAlwaysOn()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->alwaysOn:Z

    .line 998
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertToHalTrafficDescriptorAidl(Landroid/telephony/data/TrafficDescriptor;)Landroid/hardware/radio/data/TrafficDescriptor;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->trafficDescriptor:Landroid/hardware/radio/data/TrafficDescriptor;

    .line 1001
    iget-boolean v1, v0, Landroid/hardware/radio/data/DataProfileInfo;->persistent:Z

    if-eqz v1, :cond_1

    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result p0

    goto :goto_0

    :cond_1
    const/4 p0, -0x1

    .line 1002
    :goto_0
    iput p0, v0, Landroid/hardware/radio/data/DataProfileInfo;->profileId:I

    return-object v0
.end method

.method public static convertToHalDataProfile10(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_0/DataProfileInfo;
    .locals 2

    .line 859
    new-instance v0, Landroid/hardware/radio/V1_0/DataProfileInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/DataProfileInfo;-><init>()V

    .line 862
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->profileId:I

    .line 863
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->apn:Ljava/lang/String;

    .line 864
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getProtocolStringFromInt(I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->protocol:Ljava/lang/String;

    .line 865
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getRoamingProtocolType()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getProtocolStringFromInt(I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->roamingProtocol:Ljava/lang/String;

    .line 866
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getAuthType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->authType:I

    .line 867
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getUserName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->user:Ljava/lang/String;

    .line 868
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getPassword()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->password:Ljava/lang/String;

    .line 869
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->type:I

    .line 870
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnectionsTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->maxConnsTime:I

    .line 871
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnections()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->maxConns:I

    .line 872
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getWaitTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->waitTime:I

    .line 873
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isEnabled()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->enabled:Z

    .line 874
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getSupportedApnTypesBitmask()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->supportedApnTypesBitmap:I

    .line 879
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getBearerBitmask()I

    move-result v1

    .line 878
    invoke-static {v1}, Landroid/telephony/ServiceState;->convertNetworkTypeBitmaskToBearerBitmask(I)I

    move-result v1

    shl-int/lit8 v1, v1, 0x1

    iput v1, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->bearerBitmap:I

    .line 880
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV4()I

    move-result p0

    iput p0, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->mtu:I

    const/4 p0, 0x0

    .line 881
    iput p0, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->mvnoType:I

    const-string p0, ""

    .line 882
    iput-object p0, v0, Landroid/hardware/radio/V1_0/DataProfileInfo;->mvnoMatchData:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToHalDataProfile14(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_4/DataProfileInfo;
    .locals 2

    .line 894
    new-instance v0, Landroid/hardware/radio/V1_4/DataProfileInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_4/DataProfileInfo;-><init>()V

    .line 897
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->apn:Ljava/lang/String;

    .line 898
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->protocol:I

    .line 899
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getRoamingProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->roamingProtocol:I

    .line 900
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getAuthType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->authType:I

    .line 901
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getUserName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->user:Ljava/lang/String;

    .line 902
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getPassword()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->password:Ljava/lang/String;

    .line 903
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->type:I

    .line 904
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnectionsTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->maxConnsTime:I

    .line 905
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnections()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->maxConns:I

    .line 906
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getWaitTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->waitTime:I

    .line 907
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isEnabled()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->enabled:Z

    .line 908
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getSupportedApnTypesBitmask()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->supportedApnTypesBitmap:I

    .line 913
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getBearerBitmask()I

    move-result v1

    .line 912
    invoke-static {v1}, Landroid/telephony/ServiceState;->convertNetworkTypeBitmaskToBearerBitmask(I)I

    move-result v1

    shl-int/lit8 v1, v1, 0x1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->bearerBitmap:I

    .line 914
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV4()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->mtu:I

    .line 915
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->persistent:Z

    .line 916
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPreferred()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->preferred:Z

    .line 919
    iget-boolean v1, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->persistent:Z

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, -0x1

    .line 920
    :goto_0
    iput p0, v0, Landroid/hardware/radio/V1_4/DataProfileInfo;->profileId:I

    return-object v0
.end method

.method public static convertToHalDataProfile15(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_5/DataProfileInfo;
    .locals 2

    .line 932
    new-instance v0, Landroid/hardware/radio/V1_5/DataProfileInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_5/DataProfileInfo;-><init>()V

    .line 935
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->apn:Ljava/lang/String;

    .line 936
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->protocol:I

    .line 937
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getRoamingProtocolType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->roamingProtocol:I

    .line 938
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getAuthType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->authType:I

    .line 939
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getUserName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->user:Ljava/lang/String;

    .line 940
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getPassword()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->password:Ljava/lang/String;

    .line 941
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->type:I

    .line 942
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnectionsTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->maxConnsTime:I

    .line 943
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMaxConnections()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->maxConns:I

    .line 944
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getWaitTime()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->waitTime:I

    .line 945
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isEnabled()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->enabled:Z

    .line 946
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getSupportedApnTypesBitmask()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->supportedApnTypesBitmap:I

    .line 951
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getBearerBitmask()I

    move-result v1

    .line 950
    invoke-static {v1}, Landroid/telephony/ServiceState;->convertNetworkTypeBitmaskToBearerBitmask(I)I

    move-result v1

    shl-int/lit8 v1, v1, 0x1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->bearerBitmap:I

    .line 952
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV4()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->mtuV4:I

    .line 953
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getMtuV6()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->mtuV6:I

    .line 954
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->persistent:Z

    .line 955
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->isPreferred()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->preferred:Z

    .line 958
    iget-boolean v1, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->persistent:Z

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, -0x1

    .line 959
    :goto_0
    iput p0, v0, Landroid/hardware/radio/V1_5/DataProfileInfo;->profileId:I

    return-object v0
.end method

.method public static convertToHalDial(Ljava/lang/String;ILcom/android/internal/telephony/UUSInfo;)Landroid/hardware/radio/V1_0/Dial;
    .locals 1

    .line 1944
    new-instance v0, Landroid/hardware/radio/V1_0/Dial;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/Dial;-><init>()V

    .line 1945
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/V1_0/Dial;->address:Ljava/lang/String;

    .line 1946
    iput p1, v0, Landroid/hardware/radio/V1_0/Dial;->clir:I

    if-eqz p2, :cond_0

    .line 1948
    new-instance p0, Landroid/hardware/radio/V1_0/UusInfo;

    invoke-direct {p0}, Landroid/hardware/radio/V1_0/UusInfo;-><init>()V

    .line 1949
    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getType()I

    move-result p1

    iput p1, p0, Landroid/hardware/radio/V1_0/UusInfo;->uusType:I

    .line 1950
    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getDcs()I

    move-result p1

    iput p1, p0, Landroid/hardware/radio/V1_0/UusInfo;->uusDcs:I

    .line 1951
    new-instance p1, Ljava/lang/String;

    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getUserData()[B

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/lang/String;-><init>([B)V

    iput-object p1, p0, Landroid/hardware/radio/V1_0/UusInfo;->uusData:Ljava/lang/String;

    .line 1952
    iget-object p1, v0, Landroid/hardware/radio/V1_0/Dial;->uusInfo:Ljava/util/ArrayList;

    invoke-virtual {p1, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_0
    return-object v0
.end method

.method public static convertToHalDialAidl(Ljava/lang/String;ILcom/android/internal/telephony/UUSInfo;)Landroid/hardware/radio/voice/Dial;
    .locals 2

    .line 1966
    new-instance v0, Landroid/hardware/radio/voice/Dial;

    invoke-direct {v0}, Landroid/hardware/radio/voice/Dial;-><init>()V

    .line 1967
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/voice/Dial;->address:Ljava/lang/String;

    .line 1968
    iput p1, v0, Landroid/hardware/radio/voice/Dial;->clir:I

    const/4 p0, 0x0

    if-eqz p2, :cond_0

    .line 1970
    new-instance p1, Landroid/hardware/radio/voice/UusInfo;

    invoke-direct {p1}, Landroid/hardware/radio/voice/UusInfo;-><init>()V

    .line 1971
    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getType()I

    move-result v1

    iput v1, p1, Landroid/hardware/radio/voice/UusInfo;->uusType:I

    .line 1972
    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getDcs()I

    move-result v1

    iput v1, p1, Landroid/hardware/radio/voice/UusInfo;->uusDcs:I

    .line 1973
    new-instance v1, Ljava/lang/String;

    invoke-virtual {p2}, Lcom/android/internal/telephony/UUSInfo;->getUserData()[B

    move-result-object p2

    invoke-direct {v1, p2}, Ljava/lang/String;-><init>([B)V

    iput-object v1, p1, Landroid/hardware/radio/voice/UusInfo;->uusData:Ljava/lang/String;

    const/4 p2, 0x1

    new-array p2, p2, [Landroid/hardware/radio/voice/UusInfo;

    aput-object p1, p2, p0

    .line 1974
    iput-object p2, v0, Landroid/hardware/radio/voice/Dial;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    goto :goto_0

    :cond_0
    new-array p0, p0, [Landroid/hardware/radio/voice/UusInfo;

    .line 1976
    iput-object p0, v0, Landroid/hardware/radio/voice/Dial;->uusInfo:[Landroid/hardware/radio/voice/UusInfo;

    :goto_0
    return-object v0
.end method

.method public static convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;
    .locals 2

    .line 568
    new-instance v0, Landroid/hardware/radio/V1_0/GsmSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/GsmSmsMessage;-><init>()V

    const-string v1, ""

    if-nez p0, :cond_0

    move-object p0, v1

    .line 570
    :cond_0
    iput-object p0, v0, Landroid/hardware/radio/V1_0/GsmSmsMessage;->smscPdu:Ljava/lang/String;

    if-nez p1, :cond_1

    move-object p1, v1

    .line 571
    :cond_1
    iput-object p1, v0, Landroid/hardware/radio/V1_0/GsmSmsMessage;->pdu:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToHalGsmSmsMessageAidl(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/messaging/GsmSmsMessage;
    .locals 1

    .line 583
    new-instance v0, Landroid/hardware/radio/messaging/GsmSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/GsmSmsMessage;-><init>()V

    .line 585
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/messaging/GsmSmsMessage;->smscPdu:Ljava/lang/String;

    .line 586
    invoke-static {p1}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/messaging/GsmSmsMessage;->pdu:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToHalLinkProperties(Landroid/net/LinkProperties;)[Landroid/hardware/radio/data/LinkAddress;
    .locals 6

    const/4 v0, 0x0

    if-nez p0, :cond_0

    new-array p0, v0, [Landroid/hardware/radio/data/LinkAddress;

    return-object p0

    .line 1227
    :cond_0
    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAllLinkAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    new-array v1, v1, [Landroid/hardware/radio/data/LinkAddress;

    .line 1228
    :goto_0
    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAllLinkAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v0, v2, :cond_1

    .line 1229
    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAllLinkAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/LinkAddress;

    .line 1230
    new-instance v3, Landroid/hardware/radio/data/LinkAddress;

    invoke-direct {v3}, Landroid/hardware/radio/data/LinkAddress;-><init>()V

    .line 1232
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v4

    invoke-virtual {v4}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Landroid/hardware/radio/data/LinkAddress;->address:Ljava/lang/String;

    .line 1233
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getFlags()I

    move-result v4

    iput v4, v3, Landroid/hardware/radio/data/LinkAddress;->addressProperties:I

    .line 1234
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getDeprecationTime()J

    move-result-wide v4

    iput-wide v4, v3, Landroid/hardware/radio/data/LinkAddress;->deprecationTime:J

    .line 1235
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getExpirationTime()J

    move-result-wide v4

    iput-wide v4, v3, Landroid/hardware/radio/data/LinkAddress;->expirationTime:J

    .line 1236
    aput-object v3, v1, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return-object v1
.end method

.method public static convertToHalLinkProperties15(Landroid/net/LinkProperties;)Ljava/util/ArrayList;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/net/LinkProperties;",
            ")",
            "Ljava/util/ArrayList<",
            "Landroid/hardware/radio/V1_5/LinkAddress;",
            ">;"
        }
    .end annotation

    .line 1200
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    if-eqz p0, :cond_0

    .line 1202
    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAllLinkAddresses()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/net/LinkAddress;

    .line 1203
    new-instance v2, Landroid/hardware/radio/V1_5/LinkAddress;

    invoke-direct {v2}, Landroid/hardware/radio/V1_5/LinkAddress;-><init>()V

    .line 1205
    invoke-virtual {v1}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v3

    invoke-virtual {v3}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v3

    iput-object v3, v2, Landroid/hardware/radio/V1_5/LinkAddress;->address:Ljava/lang/String;

    .line 1206
    invoke-virtual {v1}, Landroid/net/LinkAddress;->getFlags()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/V1_5/LinkAddress;->properties:I

    .line 1207
    invoke-virtual {v1}, Landroid/net/LinkAddress;->getDeprecationTime()J

    move-result-wide v3

    iput-wide v3, v2, Landroid/hardware/radio/V1_5/LinkAddress;->deprecationTime:J

    .line 1208
    invoke-virtual {v1}, Landroid/net/LinkAddress;->getExpirationTime()J

    move-result-wide v3

    iput-wide v3, v2, Landroid/hardware/radio/V1_5/LinkAddress;->expirationTime:J

    .line 1209
    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static convertToHalPersoType(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;)I
    .locals 1

    .line 405
    sget-object v0, Lcom/android/internal/telephony/RILUtils$1;->$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState:[I

    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    aget p0, v0, p0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/16 p0, 0x22

    return p0

    :pswitch_1
    const/16 p0, 0x21

    return p0

    :pswitch_2
    const/16 p0, 0x20

    return p0

    :pswitch_3
    const/16 p0, 0x1f

    return p0

    :pswitch_4
    const/16 p0, 0x1e

    return p0

    :pswitch_5
    const/16 p0, 0x1d

    return p0

    :pswitch_6
    const/16 p0, 0x1c

    return p0

    :pswitch_7
    const/16 p0, 0x1b

    return p0

    :pswitch_8
    const/16 p0, 0x1a

    return p0

    :pswitch_9
    const/16 p0, 0x19

    return p0

    :pswitch_a
    const/16 p0, 0x18

    return p0

    :pswitch_b
    const/16 p0, 0x17

    return p0

    :pswitch_c
    const/16 p0, 0x16

    return p0

    :pswitch_d
    const/16 p0, 0x15

    return p0

    :pswitch_e
    const/16 p0, 0x14

    return p0

    :pswitch_f
    const/16 p0, 0x13

    return p0

    :pswitch_10
    const/16 p0, 0x12

    return p0

    :pswitch_11
    const/16 p0, 0x11

    return p0

    :pswitch_12
    const/16 p0, 0x10

    return p0

    :pswitch_13
    const/16 p0, 0xf

    return p0

    :pswitch_14
    const/16 p0, 0xe

    return p0

    :pswitch_15
    const/16 p0, 0xd

    return p0

    :pswitch_16
    const/16 p0, 0xc

    return p0

    :pswitch_17
    const/16 p0, 0xb

    return p0

    :pswitch_18
    const/16 p0, 0xa

    return p0

    :pswitch_19
    const/16 p0, 0x9

    return p0

    :pswitch_1a
    const/16 p0, 0x8

    return p0

    :pswitch_1b
    const/4 p0, 0x7

    return p0

    :pswitch_1c
    const/4 p0, 0x6

    return p0

    :pswitch_1d
    const/4 p0, 0x5

    return p0

    :pswitch_1e
    const/4 p0, 0x4

    return p0

    :pswitch_1f
    const/4 p0, 0x3

    return p0

    :pswitch_20
    const/4 p0, 0x2

    return p0

    :pswitch_21
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertToHalPersoTypeAidl(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;)I
    .locals 1

    .line 486
    sget-object v0, Lcom/android/internal/telephony/RILUtils$1;->$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState:[I

    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    aget p0, v0, p0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/16 p0, 0x22

    return p0

    :pswitch_1
    const/16 p0, 0x21

    return p0

    :pswitch_2
    const/16 p0, 0x20

    return p0

    :pswitch_3
    const/16 p0, 0x1f

    return p0

    :pswitch_4
    const/16 p0, 0x1e

    return p0

    :pswitch_5
    const/16 p0, 0x1d

    return p0

    :pswitch_6
    const/16 p0, 0x1c

    return p0

    :pswitch_7
    const/16 p0, 0x1b

    return p0

    :pswitch_8
    const/16 p0, 0x1a

    return p0

    :pswitch_9
    const/16 p0, 0x19

    return p0

    :pswitch_a
    const/16 p0, 0x18

    return p0

    :pswitch_b
    const/16 p0, 0x17

    return p0

    :pswitch_c
    const/16 p0, 0x16

    return p0

    :pswitch_d
    const/16 p0, 0x15

    return p0

    :pswitch_e
    const/16 p0, 0x14

    return p0

    :pswitch_f
    const/16 p0, 0x13

    return p0

    :pswitch_10
    const/16 p0, 0x12

    return p0

    :pswitch_11
    const/16 p0, 0x11

    return p0

    :pswitch_12
    const/16 p0, 0x10

    return p0

    :pswitch_13
    const/16 p0, 0xf

    return p0

    :pswitch_14
    const/16 p0, 0xe

    return p0

    :pswitch_15
    const/16 p0, 0xd

    return p0

    :pswitch_16
    const/16 p0, 0xc

    return p0

    :pswitch_17
    const/16 p0, 0xb

    return p0

    :pswitch_18
    const/16 p0, 0xa

    return p0

    :pswitch_19
    const/16 p0, 0x9

    return p0

    :pswitch_1a
    const/16 p0, 0x8

    return p0

    :pswitch_1b
    const/4 p0, 0x7

    return p0

    :pswitch_1c
    const/4 p0, 0x6

    return p0

    :pswitch_1d
    const/4 p0, 0x5

    return p0

    :pswitch_1e
    const/4 p0, 0x4

    return p0

    :pswitch_1f
    const/4 p0, 0x3

    return p0

    :pswitch_20
    const/4 p0, 0x2

    return p0

    :pswitch_21
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static convertToHalPhonebookRecordInfo(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Landroid/hardware/radio/V1_6/PhonebookRecordInfo;
    .locals 0

    if-eqz p0, :cond_0

    .line 4442
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->toPhonebookRecordInfo()Landroid/hardware/radio/V1_6/PhonebookRecordInfo;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public static convertToHalPhonebookRecordInfoAidl(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Landroid/hardware/radio/sim/PhonebookRecordInfo;
    .locals 0

    if-eqz p0, :cond_0

    .line 4455
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->toPhonebookRecordInfoAidl()Landroid/hardware/radio/sim/PhonebookRecordInfo;

    move-result-object p0

    return-object p0

    .line 4457
    :cond_0
    new-instance p0, Landroid/hardware/radio/sim/PhonebookRecordInfo;

    invoke-direct {p0}, Landroid/hardware/radio/sim/PhonebookRecordInfo;-><init>()V

    return-object p0
.end method

.method public static convertToHalRadioAccessFamily(I)I
    .locals 6

    int-to-long v0, p0

    const-wide/32 v2, 0x8000

    and-long/2addr v2, v0

    const-wide/16 v4, 0x0

    cmp-long p0, v2, v4

    if-eqz p0, :cond_0

    const/high16 p0, 0x10000

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    const-wide/16 v2, 0x1

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_1

    or-int/lit8 p0, p0, 0x2

    :cond_1
    const-wide/16 v2, 0x2

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_2

    or-int/lit8 p0, p0, 0x4

    :cond_2
    const-wide/16 v2, 0x8

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_3

    or-int/lit8 p0, p0, 0x10

    :cond_3
    const-wide/16 v2, 0x40

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_4

    or-int/lit8 p0, p0, 0x40

    :cond_4
    const-wide/16 v2, 0x10

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_5

    or-int/lit16 p0, p0, 0x80

    :cond_5
    const-wide/16 v2, 0x20

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_6

    or-int/lit16 p0, p0, 0x100

    :cond_6
    const-wide/16 v2, 0x800

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_7

    or-int/lit16 p0, p0, 0x1000

    :cond_7
    const-wide/16 v2, 0x2000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_8

    or-int/lit16 p0, p0, 0x2000

    :cond_8
    const-wide/16 v2, 0x100

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_9

    or-int/lit16 p0, p0, 0x400

    :cond_9
    const-wide/16 v2, 0x80

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_a

    or-int/lit16 p0, p0, 0x200

    :cond_a
    const-wide/16 v2, 0x200

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_b

    or-int/lit16 p0, p0, 0x800

    :cond_b
    const-wide/16 v2, 0x4000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_c

    const v2, 0x8000

    or-int/2addr p0, v2

    :cond_c
    const-wide/16 v2, 0x4

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_d

    or-int/lit8 p0, p0, 0x8

    :cond_d
    const-wide/32 v2, 0x10000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_e

    const/high16 v2, 0x20000

    or-int/2addr p0, v2

    :cond_e
    const-wide/32 v2, 0x20000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_f

    const/high16 v2, 0x40000

    or-int/2addr p0, v2

    :cond_f
    const-wide/16 v2, 0x1000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_10

    or-int/lit16 p0, p0, 0x4000

    :cond_10
    const-wide/32 v2, 0x40000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_11

    const/high16 v2, 0x80000

    or-int/2addr p0, v2

    :cond_11
    const-wide/32 v2, 0x80000

    and-long/2addr v0, v2

    cmp-long v0, v0, v4

    if-eqz v0, :cond_12

    const/high16 v0, 0x100000

    or-int/2addr p0, v0

    :cond_12
    if-nez p0, :cond_13

    const/4 p0, 0x1

    :cond_13
    return p0
.end method

.method public static convertToHalRadioAccessFamilyAidl(I)I
    .locals 6

    int-to-long v0, p0

    const-wide/32 v2, 0x8000

    and-long/2addr v2, v0

    const-wide/16 v4, 0x0

    cmp-long p0, v2, v4

    if-eqz p0, :cond_0

    const/high16 p0, 0x10000

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    const-wide/16 v2, 0x1

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_1

    or-int/lit8 p0, p0, 0x2

    :cond_1
    const-wide/16 v2, 0x2

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_2

    or-int/lit8 p0, p0, 0x4

    :cond_2
    const-wide/16 v2, 0x8

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_3

    or-int/lit8 p0, p0, 0x10

    :cond_3
    const-wide/16 v2, 0x40

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_4

    or-int/lit8 p0, p0, 0x40

    :cond_4
    const-wide/16 v2, 0x10

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_5

    or-int/lit16 p0, p0, 0x80

    :cond_5
    const-wide/16 v2, 0x20

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_6

    or-int/lit16 p0, p0, 0x100

    :cond_6
    const-wide/16 v2, 0x800

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_7

    or-int/lit16 p0, p0, 0x1000

    :cond_7
    const-wide/16 v2, 0x2000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_8

    or-int/lit16 p0, p0, 0x2000

    :cond_8
    const-wide/16 v2, 0x100

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_9

    or-int/lit16 p0, p0, 0x400

    :cond_9
    const-wide/16 v2, 0x80

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_a

    or-int/lit16 p0, p0, 0x200

    :cond_a
    const-wide/16 v2, 0x200

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_b

    or-int/lit16 p0, p0, 0x800

    :cond_b
    const-wide/16 v2, 0x4000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_c

    const v2, 0x8000

    or-int/2addr p0, v2

    :cond_c
    const-wide/16 v2, 0x4

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_d

    or-int/lit8 p0, p0, 0x8

    :cond_d
    const-wide/32 v2, 0x10000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_e

    const/high16 v2, 0x20000

    or-int/2addr p0, v2

    :cond_e
    const-wide/32 v2, 0x20000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_f

    const/high16 v2, 0x40000

    or-int/2addr p0, v2

    :cond_f
    const-wide/16 v2, 0x1000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_10

    or-int/lit16 p0, p0, 0x4000

    :cond_10
    const-wide/32 v2, 0x40000

    and-long/2addr v2, v0

    cmp-long v2, v2, v4

    if-eqz v2, :cond_11

    const/high16 v2, 0x80000

    or-int/2addr p0, v2

    :cond_11
    const-wide/32 v2, 0x80000

    and-long/2addr v0, v2

    cmp-long v0, v0, v4

    if-eqz v0, :cond_12

    const/high16 v0, 0x100000

    or-int/2addr p0, v0

    :cond_12
    if-nez p0, :cond_13

    const/4 p0, 0x1

    :cond_13
    return p0
.end method

.method public static convertToHalRadioAccessNetworks(I)I
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_2

    const/4 v0, 0x4

    if-eq p0, v0, :cond_1

    const/4 v1, 0x6

    if-eq p0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0

    :cond_1
    const/4 p0, 0x5

    return p0

    :cond_2
    return v0
.end method

.method public static convertToHalRadioAccessSpecifier11(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/V1_1/RadioAccessSpecifier;
    .locals 7

    .line 1306
    new-instance v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;

    invoke-direct {v0}, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;-><init>()V

    .line 1308
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;->radioAccessNetwork:I

    .line 1309
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 1310
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v2

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    .line 1311
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v2

    array-length v4, v2

    move v5, v3

    :goto_0
    if-ge v5, v4, :cond_0

    aget v6, v2, v5

    .line 1312
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 1315
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v2

    const/4 v4, 0x1

    if-eq v2, v4, :cond_3

    const/4 v4, 0x2

    if-eq v2, v4, :cond_2

    const/4 v4, 0x3

    if-eq v2, v4, :cond_1

    const/4 p0, 0x0

    return-object p0

    .line 1323
    :cond_1
    iput-object v1, v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;->eutranBands:Ljava/util/ArrayList;

    goto :goto_1

    .line 1320
    :cond_2
    iput-object v1, v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;->utranBands:Ljava/util/ArrayList;

    goto :goto_1

    .line 1317
    :cond_3
    iput-object v1, v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;->geranBands:Ljava/util/ArrayList;

    .line 1329
    :goto_1
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v1

    if-eqz v1, :cond_4

    .line 1330
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object p0

    array-length v1, p0

    :goto_2
    if-ge v3, v1, :cond_4

    aget v2, p0, v3

    .line 1331
    iget-object v4, v0, Landroid/hardware/radio/V1_1/RadioAccessSpecifier;->channels:Ljava/util/ArrayList;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    :cond_4
    return-object v0
.end method

.method public static convertToHalRadioAccessSpecifier15(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/V1_5/RadioAccessSpecifier;
    .locals 8

    .line 1345
    new-instance v0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;

    invoke-direct {v0}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;-><init>()V

    .line 1347
    new-instance v1, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    invoke-direct {v1}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;-><init>()V

    .line 1350
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v2

    .line 1349
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessNetworks(I)I

    move-result v2

    iput v2, v0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->radioAccessNetwork:I

    .line 1351
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 1352
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v3

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    .line 1353
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v3

    array-length v5, v3

    move v6, v4

    :goto_0
    if-ge v6, v5, :cond_0

    aget v7, v3, v6

    .line 1354
    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 1357
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v3

    const/4 v5, 0x1

    if-eq v3, v5, :cond_4

    const/4 v5, 0x2

    if-eq v3, v5, :cond_3

    const/4 v5, 0x3

    if-eq v3, v5, :cond_2

    const/4 v5, 0x6

    if-eq v3, v5, :cond_1

    const/4 p0, 0x0

    return-object p0

    .line 1368
    :cond_1
    invoke-virtual {v1, v2}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->ngranBands(Ljava/util/ArrayList;)V

    goto :goto_1

    .line 1365
    :cond_2
    invoke-virtual {v1, v2}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->eutranBands(Ljava/util/ArrayList;)V

    goto :goto_1

    .line 1362
    :cond_3
    invoke-virtual {v1, v2}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->utranBands(Ljava/util/ArrayList;)V

    goto :goto_1

    .line 1359
    :cond_4
    invoke-virtual {v1, v2}, Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;->geranBands(Ljava/util/ArrayList;)V

    .line 1373
    :goto_1
    iput-object v1, v0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->bands:Landroid/hardware/radio/V1_5/RadioAccessSpecifier$Bands;

    .line 1375
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v1

    if-eqz v1, :cond_5

    .line 1376
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object p0

    array-length v1, p0

    :goto_2
    if-ge v4, v1, :cond_5

    aget v2, p0, v4

    .line 1377
    iget-object v3, v0, Landroid/hardware/radio/V1_5/RadioAccessSpecifier;->channels:Ljava/util/ArrayList;

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    :cond_5
    return-object v0
.end method

.method public static convertToHalRadioAccessSpecifierAidl(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/network/RadioAccessSpecifier;
    .locals 6

    .line 1391
    new-instance v0, Landroid/hardware/radio/network/RadioAccessSpecifier;

    invoke-direct {v0}, Landroid/hardware/radio/network/RadioAccessSpecifier;-><init>()V

    .line 1393
    new-instance v1, Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    invoke-direct {v1}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;-><init>()V

    .line 1395
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v2

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetworkAidl(I)I

    move-result v2

    iput v2, v0, Landroid/hardware/radio/network/RadioAccessSpecifier;->accessNetwork:I

    .line 1397
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v2

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    .line 1398
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v2

    array-length v2, v2

    new-array v2, v2, [I

    move v4, v3

    .line 1399
    :goto_0
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v5

    array-length v5, v5

    if-ge v4, v5, :cond_1

    .line 1400
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getBands()[I

    move-result-object v5

    aget v5, v5, v4

    aput v5, v2, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_0
    new-array v2, v3, [I

    .line 1405
    :cond_1
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getRadioAccessNetwork()I

    move-result v4

    const/4 v5, 0x1

    if-eq v4, v5, :cond_5

    const/4 v5, 0x2

    if-eq v4, v5, :cond_4

    const/4 v5, 0x3

    if-eq v4, v5, :cond_3

    const/4 v5, 0x6

    if-eq v4, v5, :cond_2

    const/4 p0, 0x0

    return-object p0

    .line 1416
    :cond_2
    invoke-virtual {v1, v2}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->setNgranBands([I)V

    goto :goto_1

    .line 1413
    :cond_3
    invoke-virtual {v1, v2}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->setEutranBands([I)V

    goto :goto_1

    .line 1410
    :cond_4
    invoke-virtual {v1, v2}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->setUtranBands([I)V

    goto :goto_1

    .line 1407
    :cond_5
    invoke-virtual {v1, v2}, Landroid/hardware/radio/network/RadioAccessSpecifierBands;->setGeranBands([I)V

    .line 1421
    :goto_1
    iput-object v1, v0, Landroid/hardware/radio/network/RadioAccessSpecifier;->bands:Landroid/hardware/radio/network/RadioAccessSpecifierBands;

    .line 1424
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v1

    if-eqz v1, :cond_6

    .line 1425
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v1

    array-length v1, v1

    new-array v1, v1, [I

    .line 1426
    :goto_2
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v2

    array-length v2, v2

    if-ge v3, v2, :cond_7

    .line 1427
    invoke-virtual {p0}, Landroid/telephony/RadioAccessSpecifier;->getChannels()[I

    move-result-object v2

    aget v2, v2, v3

    aput v2, v1, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    :cond_6
    new-array v1, v3, [I

    .line 1432
    :cond_7
    iput-object v1, v0, Landroid/hardware/radio/network/RadioAccessSpecifier;->channels:[I

    return-object v0
.end method

.method public static convertToHalResetNvType(I)I
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v1, 0x2

    if-eq p0, v1, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    return v1

    :cond_1
    return v0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public static convertToHalResetNvTypeAidl(I)I
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v1, 0x2

    if-eq p0, v1, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    return v1

    :cond_1
    return v0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public static convertToHalSignalThresholdInfo(Landroid/telephony/SignalThresholdInfo;)Landroid/hardware/radio/V1_5/SignalThresholdInfo;
    .locals 2

    .line 1988
    new-instance v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_5/SignalThresholdInfo;-><init>()V

    .line 1990
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getSignalMeasurementType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;->signalMeasurement:I

    .line 1991
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisMs()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;->hysteresisMs:I

    .line 1992
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisDb()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;->hysteresisDb:I

    .line 1994
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getThresholds()[I

    move-result-object v1

    .line 1993
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;->thresholds:Ljava/util/ArrayList;

    .line 1995
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->isEnabled()Z

    move-result p0

    iput-boolean p0, v0, Landroid/hardware/radio/V1_5/SignalThresholdInfo;->isEnabled:Z

    return-object v0
.end method

.method public static convertToHalSignalThresholdInfoAidl(Landroid/telephony/SignalThresholdInfo;)Landroid/hardware/radio/network/SignalThresholdInfo;
    .locals 2

    .line 2006
    new-instance v0, Landroid/hardware/radio/network/SignalThresholdInfo;

    invoke-direct {v0}, Landroid/hardware/radio/network/SignalThresholdInfo;-><init>()V

    .line 2008
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getSignalMeasurementType()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->signalMeasurement:I

    .line 2009
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisMs()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->hysteresisMs:I

    .line 2010
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisDb()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->hysteresisDb:I

    .line 2011
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getThresholds()[I

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->thresholds:[I

    .line 2012
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->isEnabled()Z

    move-result v1

    iput-boolean v1, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->isEnabled:Z

    .line 2013
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo;->getRadioAccessNetworkType()I

    move-result p0

    iput p0, v0, Landroid/hardware/radio/network/SignalThresholdInfo;->ran:I

    return-object v0
.end method

.method public static convertToHalSimApdu(IIIIIILjava/lang/String;)Landroid/hardware/radio/V1_0/SimApdu;
    .locals 1

    .line 1794
    new-instance v0, Landroid/hardware/radio/V1_0/SimApdu;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/SimApdu;-><init>()V

    .line 1795
    iput p0, v0, Landroid/hardware/radio/V1_0/SimApdu;->sessionId:I

    .line 1796
    iput p1, v0, Landroid/hardware/radio/V1_0/SimApdu;->cla:I

    .line 1797
    iput p2, v0, Landroid/hardware/radio/V1_0/SimApdu;->instruction:I

    .line 1798
    iput p3, v0, Landroid/hardware/radio/V1_0/SimApdu;->p1:I

    .line 1799
    iput p4, v0, Landroid/hardware/radio/V1_0/SimApdu;->p2:I

    .line 1800
    iput p5, v0, Landroid/hardware/radio/V1_0/SimApdu;->p3:I

    .line 1801
    invoke-static {p6}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/V1_0/SimApdu;->data:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToHalSimApduAidl(IIIIIILjava/lang/String;)Landroid/hardware/radio/sim/SimApdu;
    .locals 1

    .line 1818
    new-instance v0, Landroid/hardware/radio/sim/SimApdu;

    invoke-direct {v0}, Landroid/hardware/radio/sim/SimApdu;-><init>()V

    .line 1819
    iput p0, v0, Landroid/hardware/radio/sim/SimApdu;->sessionId:I

    .line 1820
    iput p1, v0, Landroid/hardware/radio/sim/SimApdu;->cla:I

    .line 1821
    iput p2, v0, Landroid/hardware/radio/sim/SimApdu;->instruction:I

    .line 1822
    iput p3, v0, Landroid/hardware/radio/sim/SimApdu;->p1:I

    .line 1823
    iput p4, v0, Landroid/hardware/radio/sim/SimApdu;->p2:I

    .line 1824
    iput p5, v0, Landroid/hardware/radio/sim/SimApdu;->p3:I

    .line 1825
    invoke-static {p6}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Landroid/hardware/radio/sim/SimApdu;->data:Ljava/lang/String;

    return-object v0
.end method

.method public static convertToHalSimLockMultiSimPolicy(I)I
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0
.end method

.method public static convertToHalSimLockMultiSimPolicyAidl(I)I
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0
.end method

.method public static convertToHalSliceInfo(Landroid/telephony/data/NetworkSliceInfo;)Landroid/hardware/radio/V1_6/OptionalSliceInfo;
    .locals 3

    .line 1059
    new-instance v0, Landroid/hardware/radio/V1_6/OptionalSliceInfo;

    invoke-direct {v0}, Landroid/hardware/radio/V1_6/OptionalSliceInfo;-><init>()V

    if-nez p0, :cond_0

    return-object v0

    .line 1065
    :cond_0
    new-instance v1, Landroid/hardware/radio/V1_6/SliceInfo;

    invoke-direct {v1}, Landroid/hardware/radio/V1_6/SliceInfo;-><init>()V

    .line 1066
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getSliceServiceType()I

    move-result v2

    int-to-byte v2, v2

    iput-byte v2, v1, Landroid/hardware/radio/V1_6/SliceInfo;->sst:B

    .line 1067
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getMappedHplmnSliceServiceType()I

    move-result v2

    int-to-byte v2, v2

    iput-byte v2, v1, Landroid/hardware/radio/V1_6/SliceInfo;->mappedHplmnSst:B

    .line 1068
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getSliceDifferentiator()I

    move-result v2

    iput v2, v1, Landroid/hardware/radio/V1_6/SliceInfo;->sliceDifferentiator:I

    .line 1069
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getMappedHplmnSliceDifferentiator()I

    move-result p0

    iput p0, v1, Landroid/hardware/radio/V1_6/SliceInfo;->mappedHplmnSD:I

    .line 1070
    invoke-virtual {v0, v1}, Landroid/hardware/radio/V1_6/OptionalSliceInfo;->value(Landroid/hardware/radio/V1_6/SliceInfo;)V

    return-object v0
.end method

.method public static convertToHalSliceInfoAidl(Landroid/telephony/data/NetworkSliceInfo;)Landroid/hardware/radio/data/SliceInfo;
    .locals 2

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 1085
    :cond_0
    new-instance v0, Landroid/hardware/radio/data/SliceInfo;

    invoke-direct {v0}, Landroid/hardware/radio/data/SliceInfo;-><init>()V

    .line 1086
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getSliceServiceType()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Landroid/hardware/radio/data/SliceInfo;->sliceServiceType:B

    .line 1087
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getMappedHplmnSliceServiceType()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Landroid/hardware/radio/data/SliceInfo;->mappedHplmnSst:B

    .line 1088
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getSliceDifferentiator()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/data/SliceInfo;->sliceDifferentiator:I

    .line 1089
    invoke-virtual {p0}, Landroid/telephony/data/NetworkSliceInfo;->getMappedHplmnSliceDifferentiator()I

    move-result p0

    iput p0, v0, Landroid/hardware/radio/data/SliceInfo;->mappedHplmnSd:I

    return-object v0
.end method

.method public static convertToHalSmsWriteArgsStatus(I)I
    .locals 3

    const/4 v0, 0x7

    and-int/2addr p0, v0

    const/4 v1, 0x3

    if-eq p0, v1, :cond_2

    const/4 v2, 0x5

    if-eq p0, v2, :cond_1

    if-eq p0, v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x2

    return p0

    :cond_1
    return v1

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public static convertToHalSmsWriteArgsStatusAidl(I)I
    .locals 3

    const/4 v0, 0x7

    and-int/2addr p0, v0

    const/4 v1, 0x3

    if-eq p0, v1, :cond_2

    const/4 v2, 0x5

    if-eq p0, v2, :cond_1

    if-eq p0, v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x2

    return p0

    :cond_1
    return v1

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public static convertToHalTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;
    .locals 4

    .line 1100
    new-instance v0, Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;

    invoke-direct {v0}, Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;-><init>()V

    if-nez p0, :cond_0

    return-object v0

    .line 1106
    :cond_0
    new-instance v1, Landroid/hardware/radio/V1_6/TrafficDescriptor;

    invoke-direct {v1}, Landroid/hardware/radio/V1_6/TrafficDescriptor;-><init>()V

    .line 1109
    new-instance v2, Landroid/hardware/radio/V1_6/OptionalDnn;

    invoke-direct {v2}, Landroid/hardware/radio/V1_6/OptionalDnn;-><init>()V

    .line 1111
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getDataNetworkName()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_1

    .line 1112
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getDataNetworkName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/hardware/radio/V1_6/OptionalDnn;->value(Ljava/lang/String;)V

    .line 1114
    :cond_1
    iput-object v2, v1, Landroid/hardware/radio/V1_6/TrafficDescriptor;->dnn:Landroid/hardware/radio/V1_6/OptionalDnn;

    .line 1116
    new-instance v2, Landroid/hardware/radio/V1_6/OptionalOsAppId;

    invoke-direct {v2}, Landroid/hardware/radio/V1_6/OptionalOsAppId;-><init>()V

    .line 1118
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v3

    if-eqz v3, :cond_2

    .line 1119
    new-instance v3, Landroid/hardware/radio/V1_6/OsAppId;

    invoke-direct {v3}, Landroid/hardware/radio/V1_6/OsAppId;-><init>()V

    .line 1120
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([B)Ljava/util/ArrayList;

    move-result-object p0

    iput-object p0, v3, Landroid/hardware/radio/V1_6/OsAppId;->osAppId:Ljava/util/ArrayList;

    .line 1121
    invoke-virtual {v2, v3}, Landroid/hardware/radio/V1_6/OptionalOsAppId;->value(Landroid/hardware/radio/V1_6/OsAppId;)V

    .line 1123
    :cond_2
    iput-object v2, v1, Landroid/hardware/radio/V1_6/TrafficDescriptor;->osAppId:Landroid/hardware/radio/V1_6/OptionalOsAppId;

    .line 1125
    invoke-virtual {v0, v1}, Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;->value(Landroid/hardware/radio/V1_6/TrafficDescriptor;)V

    return-object v0
.end method

.method public static convertToHalTrafficDescriptorAidl(Landroid/telephony/data/TrafficDescriptor;)Landroid/hardware/radio/data/TrafficDescriptor;
    .locals 2

    if-nez p0, :cond_0

    .line 1137
    new-instance p0, Landroid/hardware/radio/data/TrafficDescriptor;

    invoke-direct {p0}, Landroid/hardware/radio/data/TrafficDescriptor;-><init>()V

    return-object p0

    .line 1140
    :cond_0
    new-instance v0, Landroid/hardware/radio/data/TrafficDescriptor;

    invoke-direct {v0}, Landroid/hardware/radio/data/TrafficDescriptor;-><init>()V

    .line 1142
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getDataNetworkName()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/data/TrafficDescriptor;->dnn:Ljava/lang/String;

    .line 1143
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v1

    if-nez v1, :cond_1

    const/4 p0, 0x0

    .line 1144
    iput-object p0, v0, Landroid/hardware/radio/data/TrafficDescriptor;->osAppId:Landroid/hardware/radio/data/OsAppId;

    goto :goto_0

    .line 1146
    :cond_1
    new-instance v1, Landroid/hardware/radio/data/OsAppId;

    invoke-direct {v1}, Landroid/hardware/radio/data/OsAppId;-><init>()V

    .line 1147
    invoke-virtual {p0}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object p0

    iput-object p0, v1, Landroid/hardware/radio/data/OsAppId;->osAppId:[B

    .line 1148
    iput-object v1, v0, Landroid/hardware/radio/data/TrafficDescriptor;->osAppId:Landroid/hardware/radio/data/OsAppId;

    :goto_0
    return-object v0
.end method

.method private static convertToLinkAddress(Ljava/lang/String;)Landroid/net/LinkAddress;
    .locals 6

    const/4 v1, 0x0

    const-wide/16 v2, -0x1

    const-wide/16 v4, -0x1

    move-object v0, p0

    .line 3376
    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;IJJ)Landroid/net/LinkAddress;

    move-result-object p0

    return-object p0
.end method

.method private static convertToLinkAddress(Ljava/lang/String;IJJ)Landroid/net/LinkAddress;
    .locals 12

    .line 3382
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const/4 v1, -0x1

    const/4 v2, 0x0

    :try_start_0
    const-string v3, "/"

    const/4 v4, 0x2

    .line 3386
    invoke-virtual {v0, v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    .line 3387
    aget-object v5, v3, v5

    invoke-static {v5}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v2

    .line 3388
    array-length v5, v3

    const/4 v6, 0x1

    if-ne v5, v6, :cond_1

    .line 3389
    instance-of v3, v2, Ljava/net/Inet4Address;

    if-eqz v3, :cond_0

    const/16 v3, 0x20

    goto :goto_0

    :cond_0
    const/16 v3, 0x80

    goto :goto_0

    .line 3390
    :cond_1
    array-length v5, v3

    if-ne v5, v4, :cond_2

    .line 3391
    aget-object v3, v3, v6

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :cond_2
    move v3, v1

    :goto_0
    move-object v4, v2

    move v5, v3

    goto :goto_1

    :catch_0
    move v5, v1

    move-object v4, v2

    :goto_1
    if-eqz v4, :cond_3

    if-eq v5, v1, :cond_3

    .line 3403
    new-instance v0, Landroid/net/LinkAddress;

    const/4 v7, 0x0

    move-object v3, v0

    move v6, p1

    move-wide v8, p2

    move-wide/from16 v10, p4

    invoke-direct/range {v3 .. v11}, Landroid/net/LinkAddress;-><init>(Ljava/net/InetAddress;IIIJJ)V

    return-object v0

    .line 3400
    :cond_3
    new-instance v1, Ljava/lang/IllegalArgumentException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Invalid link address "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1
.end method

.method public static convertToString(Ljava/lang/Object;)Ljava/lang/String;
    .locals 11

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 5278
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string/jumbo v3, "toString"

    new-array v4, v1, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;

    move-result-object v2

    const-class v3, Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0

    if-eq v2, v3, :cond_0

    move v2, v0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 5280
    invoke-virtual {v2}, Ljava/lang/NoSuchMethodException;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :cond_0
    move v2, v1

    :goto_0
    if-nez v2, :cond_c

    .line 5282
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->isPrimitiveOrWrapper(Ljava/lang/Class;)Z

    move-result v2

    if-nez v2, :cond_c

    instance-of v2, p0, Ljava/util/ArrayList;

    if-eqz v2, :cond_1

    goto/16 :goto_a

    .line 5285
    :cond_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->isArray()Z

    move-result v2

    const-string v3, ", "

    if-eqz v2, :cond_6

    .line 5287
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v4, "["

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 5289
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getComponentType()Ljava/lang/Class;

    move-result-object v4

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->isPrimitiveOrWrapper(Ljava/lang/Class;)Z

    move-result v4

    if-eqz v4, :cond_2

    move v4, v1

    .line 5290
    :goto_1
    invoke-static {p0}, Ljava/lang/reflect/Array;->getLength(Ljava/lang/Object;)I

    move-result v5

    if-ge v1, v5, :cond_4

    .line 5291
    invoke-static {p0, v1}, Ljava/lang/reflect/Array;->get(Ljava/lang/Object;I)Ljava/lang/Object;

    move-result-object v4

    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertToString(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    move v4, v0

    goto :goto_1

    .line 5295
    :cond_2
    check-cast p0, [Ljava/lang/Object;

    array-length v4, p0

    move v5, v1

    :goto_2
    if-ge v1, v4, :cond_3

    aget-object v5, p0, v1

    .line 5296
    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertToString(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    move v5, v0

    goto :goto_2

    :cond_3
    move v4, v5

    :cond_4
    if-eqz v4, :cond_5

    .line 5302
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    add-int/lit8 p0, p0, -0x2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v0

    invoke-virtual {v2, p0, v0}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;

    :cond_5
    const-string p0, "]"

    .line 5304
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5305
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 5307
    :cond_6
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string/jumbo v4, "{"

    .line 5308
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5309
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v4

    const/4 v5, -0x1

    .line 5312
    :try_start_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    const-string v7, "getTag"

    new-array v8, v1, [Ljava/lang/Class;

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v6

    new-array v7, v1, [Ljava/lang/Object;

    invoke-virtual {v6, p0, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6
    :try_end_1
    .catch Ljava/lang/IllegalAccessException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/NoSuchMethodException; {:try_start_1 .. :try_end_1} :catch_2

    goto :goto_3

    :catch_1
    move-exception v6

    .line 5314
    invoke-virtual {v6}, Ljava/lang/ReflectiveOperationException;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :catch_2
    move v6, v5

    :goto_3
    const-string v7, "="

    const/4 v8, 0x0

    if-eq v6, v5, :cond_7

    .line 5322
    :try_start_2
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "_tagString"

    new-array v5, v0, [Ljava/lang/Class;

    sget-object v9, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v9, v5, v1

    invoke-virtual {v3, v4, v5}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 5323
    invoke-virtual {v3, v0}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    new-array v4, v0, [Ljava/lang/Object;

    .line 5324
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v1

    invoke-virtual {v3, p0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;
    :try_end_2
    .catch Ljava/lang/NoSuchMethodException; {:try_start_2 .. :try_end_2} :catch_3
    .catch Ljava/lang/IllegalAccessException; {:try_start_2 .. :try_end_2} :catch_3
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_2 .. :try_end_2} :catch_3

    goto :goto_4

    :catch_3
    move-exception v3

    .line 5326
    invoke-virtual {v3}, Ljava/lang/ReflectiveOperationException;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    move-object v3, v8

    :goto_4
    if-eqz v3, :cond_b

    .line 5329
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5330
    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5332
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "get"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    sget-object v6, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v5, v6}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5333
    invoke-virtual {v3, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 5336
    :try_start_3
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    new-array v4, v1, [Ljava/lang/Class;

    invoke-virtual {v3, v0, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v1, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8
    :try_end_3
    .catch Ljava/lang/NoSuchMethodException; {:try_start_3 .. :try_end_3} :catch_4
    .catch Ljava/lang/IllegalAccessException; {:try_start_3 .. :try_end_3} :catch_4
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_3 .. :try_end_3} :catch_4

    goto :goto_5

    :catch_4
    move-exception p0

    .line 5339
    invoke-virtual {p0}, Ljava/lang/ReflectiveOperationException;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    :goto_5
    if-eqz v8, :cond_b

    .line 5342
    invoke-static {v8}, Lcom/android/internal/telephony/RILUtils;->convertToString(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_9

    .line 5347
    :cond_7
    array-length v5, v4

    move v6, v1

    :goto_6
    if-ge v1, v5, :cond_a

    aget-object v9, v4, v1

    .line 5349
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v10

    invoke-static {v10}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v10

    if-eqz v10, :cond_8

    goto :goto_8

    .line 5350
    :cond_8
    invoke-virtual {v9}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5353
    :try_start_4
    invoke-virtual {v9, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v9
    :try_end_4
    .catch Ljava/lang/IllegalAccessException; {:try_start_4 .. :try_end_4} :catch_5

    goto :goto_7

    :catch_5
    move-exception v9

    .line 5355
    invoke-virtual {v9}, Ljava/lang/IllegalAccessException;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    move-object v9, v8

    :goto_7
    if-nez v9, :cond_9

    goto :goto_8

    .line 5358
    :cond_9
    invoke-static {v9}, Lcom/android/internal/telephony/RILUtils;->convertToString(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v6, v0

    :goto_8
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    :cond_a
    if-eqz v6, :cond_b

    .line 5363
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    add-int/lit8 p0, p0, -0x2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v0

    invoke-virtual {v2, p0, v0}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;

    :cond_b
    :goto_9
    const-string/jumbo p0, "}"

    .line 5366
    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5367
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 5283
    :cond_c
    :goto_a
    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static deactivateDataReasonToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_3

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p0, v0, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    .line 4683
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "HANDOVER"

    return-object p0

    :cond_1
    const-string p0, "SHUTDOWN"

    return-object p0

    :cond_2
    const-string p0, "NORMAL"

    return-object p0

    :cond_3
    const-string p0, "UNKNOWN"

    return-object p0
.end method

.method public static getCaps(Lcom/android/internal/telephony/HalVersion;Z)Ljava/util/Set;
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/HalVersion;",
            "Z)",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 5235
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 5237
    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/HalVersion;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "Radio Hal Version is UNKNOWN!"

    .line 5239
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    .line 5242
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Radio Hal Version = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/HalVersion;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    .line 5243
    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p0

    if-eqz p0, :cond_2

    const-string p0, "CAPABILITY_USES_ALLOWED_NETWORK_TYPES_BITMASK"

    .line 5244
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5245
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    if-nez p1, :cond_1

    const-string p0, "CAPABILITY_SECONDARY_LINK_BANDWIDTH_VISIBLE"

    .line 5248
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5249
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    const-string p0, "CAPABILITY_NR_DUAL_CONNECTIVITY_CONFIGURATION_AVAILABLE"

    .line 5250
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5251
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    const-string p0, "CAPABILITY_THERMAL_MITIGATION_DATA_THROTTLING"

    .line 5252
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5253
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    const-string p0, "CAPABILITY_SLICING_CONFIG_SUPPORTED"

    .line 5254
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5255
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    const-string p0, "CAPABILITY_PHYSICAL_CHANNEL_CONFIG_1_6_SUPPORTED"

    .line 5256
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5257
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const-string p0, "CAPABILITY_SIM_PHONEBOOK_IN_MODEM"

    .line 5259
    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 5260
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->logd(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-object v0
.end method

.method private static isPrimitiveOrWrapper(Ljava/lang/Class;)Z
    .locals 1

    .line 5267
    invoke-virtual {p0}, Ljava/lang/Class;->isPrimitive()Z

    move-result v0

    if-nez v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/RILUtils;->WRAPPER_CLASSES:Ljava/util/Set;

    invoke-interface {v0, p0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private static synthetic lambda$convertHalDataCallResult$0(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;
    .locals 6

    .line 3489
    iget-object v0, p0, Landroid/hardware/radio/V1_5/LinkAddress;->address:Ljava/lang/String;

    iget v1, p0, Landroid/hardware/radio/V1_5/LinkAddress;->properties:I

    iget-wide v2, p0, Landroid/hardware/radio/V1_5/LinkAddress;->deprecationTime:J

    iget-wide v4, p0, Landroid/hardware/radio/V1_5/LinkAddress;->expirationTime:J

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;IJJ)Landroid/net/LinkAddress;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$convertHalDataCallResult$1(Landroid/hardware/radio/V1_5/LinkAddress;)Landroid/net/LinkAddress;
    .locals 6

    .line 3507
    iget-object v0, p0, Landroid/hardware/radio/V1_5/LinkAddress;->address:Ljava/lang/String;

    iget v1, p0, Landroid/hardware/radio/V1_5/LinkAddress;->properties:I

    iget-wide v2, p0, Landroid/hardware/radio/V1_5/LinkAddress;->deprecationTime:J

    iget-wide v4, p0, Landroid/hardware/radio/V1_5/LinkAddress;->expirationTime:J

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/RILUtils;->convertToLinkAddress(Ljava/lang/String;IJJ)Landroid/net/LinkAddress;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$convertHalSlicingConfig$2(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;
    .locals 2

    .line 3760
    :try_start_0
    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->convertHalTrafficDescriptor(Landroid/hardware/radio/V1_6/TrafficDescriptor;)Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 3762
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "convertHalSlicingConfig: Failed to convert traffic descriptor. e="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RILUtils;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$convertHalSlicingConfig$3(Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;)Landroid/telephony/data/RouteSelectionDescriptor;
    .locals 7

    .line 3769
    new-instance v6, Landroid/telephony/data/RouteSelectionDescriptor;

    iget-byte v1, p0, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;->precedence:B

    iget-object v0, p0, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;->sessionType:Landroid/hardware/radio/V1_6/OptionalPdpProtocolType;

    .line 3770
    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/OptionalPdpProtocolType;->value()I

    move-result v2

    iget-object v0, p0, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;->sscMode:Landroid/hardware/radio/V1_6/OptionalSscMode;

    invoke-virtual {v0}, Landroid/hardware/radio/V1_6/OptionalSscMode;->value()B

    move-result v3

    iget-object v0, p0, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;->sliceInfo:Ljava/util/ArrayList;

    .line 3771
    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v4, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda0;

    invoke-direct {v4}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v0, v4}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 3772
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v4

    invoke-interface {v0, v4}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    move-object v4, v0

    check-cast v4, Ljava/util/List;

    iget-object v5, p0, Landroid/hardware/radio/V1_6/RouteSelectionDescriptor;->dnn:Ljava/util/ArrayList;

    move-object v0, v6

    invoke-direct/range {v0 .. v5}, Landroid/telephony/data/RouteSelectionDescriptor;-><init>(IIILjava/util/List;Ljava/util/List;)V

    return-object v6
.end method

.method private static synthetic lambda$convertHalSlicingConfig$4(Landroid/hardware/radio/V1_6/UrspRule;)Landroid/telephony/data/UrspRule;
    .locals 4

    .line 3756
    new-instance v0, Landroid/telephony/data/UrspRule;

    iget-byte v1, p0, Landroid/hardware/radio/V1_6/UrspRule;->precedence:B

    iget-object v2, p0, Landroid/hardware/radio/V1_6/UrspRule;->trafficDescriptors:Ljava/util/ArrayList;

    .line 3757
    invoke-virtual {v2}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda6;

    invoke-direct {v3}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda6;-><init>()V

    .line 3758
    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda7;

    invoke-direct {v3}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda7;-><init>()V

    .line 3767
    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v2

    .line 3768
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/List;

    iget-object p0, p0, Landroid/hardware/radio/V1_6/UrspRule;->routeSelectionDescriptor:Ljava/util/ArrayList;

    .line 3769
    invoke-virtual {p0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v3, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda8;

    invoke-direct {v3}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda8;-><init>()V

    invoke-interface {p0, v3}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 3773
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {p0, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    invoke-direct {v0, v1, v2, p0}, Landroid/telephony/data/UrspRule;-><init>(ILjava/util/List;Ljava/util/List;)V

    return-object v0
.end method

.method private static logd(Ljava/lang/String;)V
    .locals 1

    const-string v0, "RILUtils"

    .line 5371
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 1

    const-string v0, "RILUtils"

    .line 5375
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static primitiveArrayToArrayList([B)Ljava/util/ArrayList;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B)",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation

    .line 4612
    new-instance v0, Ljava/util/ArrayList;

    array-length v1, p0

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 4613
    array-length v1, p0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-byte v3, p0, v2

    .line 4614
    invoke-static {v3}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static primitiveArrayToArrayList([I)Ljava/util/ArrayList;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([I)",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 4621
    new-instance v0, Ljava/util/ArrayList;

    array-length v1, p0

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 4622
    array-length v1, p0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget v3, p0, v2

    .line 4623
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public static primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 4630
    new-instance v0, Ljava/util/ArrayList;

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method public static requestToString(I)Ljava/lang/String;
    .locals 8

    packed-switch p0, :pswitch_data_0

    packed-switch p0, :pswitch_data_1

    const-string v0, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v1, "0"

    .line 5058
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 5059
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, ">"

    const-string v2, "<unknown request "

    if-eqz v0, :cond_0

    :try_start_0
    const-string v0, "com.mediatek.internal.telephony.MtkRIL"

    .line 5062
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v3, "requestToStringEx"

    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/Class;

    .line 5063
    const-class v6, Ljava/lang/Integer;

    const/4 v7, 0x0

    aput-object v6, v5, v7

    invoke-virtual {v0, v3, v5}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v3, 0x0

    new-array v4, v4, [Ljava/lang/Object;

    .line 5065
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v7

    invoke-virtual {v0, v3, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 5067
    :catch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 5070
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :pswitch_0
    const-string p0, "GET_USAGE_SETTING"

    return-object p0

    :pswitch_1
    const-string p0, "SET_USAGE_SETTING"

    return-object p0

    :pswitch_2
    const-string p0, "IS_VONR_ENABLED"

    return-object p0

    :pswitch_3
    const-string p0, "ENABLE_VONR"

    return-object p0

    :pswitch_4
    const-string p0, "GET_SLICING_CONFIG"

    return-object p0

    :pswitch_5
    const-string p0, "GET_ALLOWED_NETWORK_TYPES_BITMAP"

    return-object p0

    :pswitch_6
    const-string p0, "SET_ALLOWED_NETWORK_TYPES_BITMAP"

    return-object p0

    :pswitch_7
    const-string p0, "SET_DATA_THROTTLING"

    return-object p0

    :pswitch_8
    const-string p0, "GET_HAL_DEVICE_CAPABILITIES"

    return-object p0

    :pswitch_9
    const-string p0, "GET_SYSTEM_SELECTION_CHANNELS"

    return-object p0

    :pswitch_a
    const-string p0, "CANCEL_HANDOVER"

    return-object p0

    :pswitch_b
    const-string p0, "START_HANDOVER"

    return-object p0

    :pswitch_c
    const-string p0, "RELEASE_PDU_SESSION_ID"

    return-object p0

    :pswitch_d
    const-string p0, "ALLOCATE_PDU_SESSION_ID"

    return-object p0

    :pswitch_e
    const-string p0, "IS_NR_DUAL_CONNECTIVITY_ENABLED"

    return-object p0

    :pswitch_f
    const-string p0, "ENABLE_NR_DUAL_CONNECTIVITY"

    return-object p0

    :pswitch_10
    const-string p0, "ENTER_SIM_DEPERSONALIZATION"

    return-object p0

    :pswitch_11
    const-string p0, "GET_BARRING_INFO"

    return-object p0

    :pswitch_12
    const-string p0, "SET_SYSTEM_SELECTION_CHANNELS"

    return-object p0

    :pswitch_13
    const-string p0, "GET_UICC_APPLICATIONS_ENABLEMENT"

    return-object p0

    :pswitch_14
    const-string p0, "ENABLE_UICC_APPLICATIONS"

    return-object p0

    :pswitch_15
    const-string p0, "SWITCH_DUAL_SIM_CONFIG"

    return-object p0

    :pswitch_16
    const-string p0, "GET_PHONE_CAPABILITY"

    return-object p0

    :pswitch_17
    const-string p0, "EMERGENCY_DIAL"

    return-object p0

    :pswitch_18
    const-string p0, "SET_PREFERRED_DATA_MODEM"

    return-object p0

    :pswitch_19
    const-string p0, "SET_LINK_CAPACITY_REPORTING_CRITERIA"

    return-object p0

    :pswitch_1a
    const-string p0, "SET_SIGNAL_STRENGTH_REPORTING_CRITERIA"

    return-object p0

    :pswitch_1b
    const-string p0, "SET_LOGICAL_TO_PHYSICAL_SLOT_MAPPING"

    return-object p0

    :pswitch_1c
    const-string p0, "GET_SLOT_STATUS"

    return-object p0

    :pswitch_1d
    const-string p0, "UPDATE_SIM_PHONEBOOK_RECORD"

    return-object p0

    :pswitch_1e
    const-string p0, "GET_SIM_PHONEBOOK_RECORDS"

    return-object p0

    :pswitch_1f
    const-string p0, "GET_SIM_PHONEBOOK_CAPACITY"

    return-object p0

    :pswitch_20
    const-string p0, "CDMA_SEND_SMS_EXPECT_MORE"

    return-object p0

    :pswitch_21
    const-string p0, "GET_MODEM_STATUS"

    return-object p0

    :pswitch_22
    const-string p0, "ENABLE_MODEM"

    return-object p0

    :pswitch_23
    const-string p0, "STOP_KEEPALIVE"

    return-object p0

    :pswitch_24
    const-string p0, "START_KEEPALIVE"

    return-object p0

    :pswitch_25
    const-string p0, "STOP_NETWORK_SCAN"

    return-object p0

    :pswitch_26
    const-string p0, "START_NETWORK_SCAN"

    return-object p0

    :pswitch_27
    const-string p0, "SET_CARRIER_INFO_IMSI_ENCRYPTION"

    return-object p0

    :pswitch_28
    const-string p0, "SET_SIM_CARD_POWER"

    return-object p0

    :pswitch_29
    const-string p0, "SET_UNSOLICITED_RESPONSE_FILTER"

    return-object p0

    :pswitch_2a
    const-string p0, "SEND_DEVICE_STATE"

    return-object p0

    :pswitch_2b
    const-string p0, "GET_ALLOWED_CARRIERS"

    return-object p0

    :pswitch_2c
    const-string p0, "SET_ALLOWED_CARRIERS"

    return-object p0

    :pswitch_2d
    const-string p0, "GET_ACTIVITY_INFO"

    return-object p0

    :pswitch_2e
    const-string p0, "PULL_LCEDATA"

    return-object p0

    :pswitch_2f
    const-string p0, "STOP_LCE"

    return-object p0

    :pswitch_30
    const-string p0, "START_LCE"

    return-object p0

    :pswitch_31
    const-string p0, "SET_RADIO_CAPABILITY"

    return-object p0

    :pswitch_32
    const-string p0, "GET_RADIO_CAPABILITY"

    return-object p0

    :pswitch_33
    const-string p0, "SHUTDOWN"

    return-object p0

    :pswitch_34
    const-string p0, "SET_DATA_PROFILE"

    return-object p0

    :pswitch_35
    const-string p0, "SET_DC_RT_INFO_RATE"

    return-object p0

    :pswitch_36
    const-string p0, "GET_DC_RT_INFO"

    return-object p0

    :pswitch_37
    const-string p0, "SIM_AUTHENTICATION"

    return-object p0

    :pswitch_38
    const-string p0, "GET_HARDWARE_CONFIG"

    return-object p0

    :pswitch_39
    const-string p0, "ALLOW_DATA"

    return-object p0

    :pswitch_3a
    const-string p0, "SET_UICC_SUBSCRIPTION"

    return-object p0

    :pswitch_3b
    const-string p0, "NV_RESET_CONFIG"

    return-object p0

    :pswitch_3c
    const-string p0, "NV_WRITE_CDMA_PRL"

    return-object p0

    :pswitch_3d
    const-string p0, "NV_WRITE_ITEM"

    return-object p0

    :pswitch_3e
    const-string p0, "NV_READ_ITEM"

    return-object p0

    :pswitch_3f
    const-string p0, "SIM_TRANSMIT_APDU_CHANNEL"

    return-object p0

    :pswitch_40
    const-string p0, "SIM_CLOSE_CHANNEL"

    return-object p0

    :pswitch_41
    const-string p0, "SIM_OPEN_CHANNEL"

    return-object p0

    :pswitch_42
    const-string p0, "SIM_TRANSMIT_APDU_BASIC"

    return-object p0

    :pswitch_43
    const-string p0, "IMS_SEND_SMS"

    return-object p0

    :pswitch_44
    const-string p0, "IMS_REGISTRATION_STATE"

    return-object p0

    :pswitch_45
    const-string p0, "SET_INITIAL_ATTACH_APN"

    return-object p0

    :pswitch_46
    const-string p0, "SET_CELL_INFO_LIST_RATE"

    return-object p0

    :pswitch_47
    const-string p0, "GET_CELL_INFO_LIST"

    return-object p0

    :pswitch_48
    const-string p0, "VOICE_RADIO_TECH"

    return-object p0

    :pswitch_49
    const-string p0, "STK_SEND_ENVELOPE_WITH_STATUS"

    return-object p0

    :pswitch_4a
    const-string p0, "ACKNOWLEDGE_INCOMING_GSM_SMS_WITH_PDU"

    return-object p0

    :pswitch_4b
    const-string p0, "ISIM_AUTHENTICATION"

    return-object p0

    :pswitch_4c
    const-string p0, "CDMA_GET_SUBSCRIPTION_SOURCE"

    return-object p0

    :pswitch_4d
    const-string p0, "REPORT_STK_SERVICE_IS_RUNNING"

    return-object p0

    :pswitch_4e
    const-string p0, "REPORT_SMS_MEMORY_STATUS"

    return-object p0

    :pswitch_4f
    const-string p0, "SET_SMSC_ADDRESS"

    return-object p0

    :pswitch_50
    const-string p0, "GET_SMSC_ADDRESS"

    return-object p0

    :pswitch_51
    const-string p0, "EXIT_EMERGENCY_CALLBACK_MODE"

    return-object p0

    :pswitch_52
    const-string p0, "DEVICE_IDENTITY"

    return-object p0

    :pswitch_53
    const-string p0, "CDMA_DELETE_SMS_ON_RUIM"

    return-object p0

    :pswitch_54
    const-string p0, "CDMA_WRITE_SMS_TO_RUIM"

    return-object p0

    :pswitch_55
    const-string p0, "CDMA_SUBSCRIPTION"

    return-object p0

    :pswitch_56
    const-string p0, "CDMA_BROADCAST_ACTIVATION"

    return-object p0

    :pswitch_57
    const-string p0, "CDMA_SET_BROADCAST_CONFIG"

    return-object p0

    :pswitch_58
    const-string p0, "CDMA_GET_BROADCAST_CONFIG"

    return-object p0

    :pswitch_59
    const-string p0, "GSM_BROADCAST_ACTIVATION"

    return-object p0

    :pswitch_5a
    const-string p0, "GSM_SET_BROADCAST_CONFIG"

    return-object p0

    :pswitch_5b
    const-string p0, "GSM_GET_BROADCAST_CONFIG"

    return-object p0

    :pswitch_5c
    const-string p0, "CDMA_SMS_ACKNOWLEDGE"

    return-object p0

    :pswitch_5d
    const-string p0, "CDMA_SEND_SMS"

    return-object p0

    :pswitch_5e
    const-string p0, "CDMA_VALIDATE_AND_WRITE_AKEY"

    return-object p0

    :pswitch_5f
    const-string p0, "CDMA_BURST_DTMF"

    return-object p0

    :pswitch_60
    const-string p0, "CDMA_FLASH"

    return-object p0

    :pswitch_61
    const-string p0, "CDMA_QUERY_PREFERRED_VOICE_PRIVACY_MODE"

    return-object p0

    :pswitch_62
    const-string p0, "CDMA_SET_PREFERRED_VOICE_PRIVACY_MODE"

    return-object p0

    :pswitch_63
    const-string p0, "QUERY_TTY_MODE"

    return-object p0

    :pswitch_64
    const-string p0, "SET_TTY_MODE"

    return-object p0

    :pswitch_65
    const-string p0, "CDMA_QUERY_ROAMING_PREFERENCE"

    return-object p0

    :pswitch_66
    const-string p0, "CDMA_SET_ROAMING_PREFERENCE"

    return-object p0

    :pswitch_67
    const-string p0, "CDMA_SET_SUBSCRIPTION_SOURCE"

    return-object p0

    :pswitch_68
    const-string p0, "SET_LOCATION_UPDATES"

    return-object p0

    :pswitch_69
    const-string p0, "GET_NEIGHBORING_CELL_IDS"

    return-object p0

    :pswitch_6a
    const-string p0, "GET_PREFERRED_NETWORK_TYPE"

    return-object p0

    :pswitch_6b
    const-string p0, "SET_PREFERRED_NETWORK_TYPE"

    return-object p0

    :pswitch_6c
    const-string p0, "EXPLICIT_CALL_TRANSFER"

    return-object p0

    :pswitch_6d
    const-string p0, "STK_HANDLE_CALL_SETUP_REQUESTED_FROM_SIM"

    return-object p0

    :pswitch_6e
    const-string p0, "STK_SEND_TERMINAL_RESPONSE"

    return-object p0

    :pswitch_6f
    const-string p0, "STK_SEND_ENVELOPE_COMMAND"

    return-object p0

    :pswitch_70
    const-string p0, "STK_SET_PROFILE"

    return-object p0

    :pswitch_71
    const-string p0, "STK_GET_PROFILE"

    return-object p0

    :pswitch_72
    const-string p0, "QUERY_AVAILABLE_BAND_MODE"

    return-object p0

    :pswitch_73
    const-string p0, "SET_BAND_MODE"

    return-object p0

    :pswitch_74
    const-string p0, "DELETE_SMS_ON_SIM"

    return-object p0

    :pswitch_75
    const-string p0, "WRITE_SMS_TO_SIM"

    return-object p0

    :pswitch_76
    const-string p0, "SET_SUPP_SVC_NOTIFICATION"

    return-object p0

    :pswitch_77
    const-string p0, "SCREEN_STATE"

    return-object p0

    :pswitch_78
    const-string p0, "OEM_HOOK_STRINGS"

    return-object p0

    :pswitch_79
    const-string p0, "OEM_HOOK_RAW"

    return-object p0

    :pswitch_7a
    const-string p0, "RESET_RADIO"

    return-object p0

    :pswitch_7b
    const-string p0, "DATA_CALL_LIST"

    return-object p0

    :pswitch_7c
    const-string p0, "LAST_DATA_CALL_FAIL_CAUSE"

    return-object p0

    :pswitch_7d
    const-string p0, "QUERY_CLIP"

    return-object p0

    :pswitch_7e
    const-string p0, "GET_MUTE"

    return-object p0

    :pswitch_7f
    const-string p0, "SET_MUTE"

    return-object p0

    :pswitch_80
    const-string p0, "SEPARATE_CONNECTION"

    return-object p0

    :pswitch_81
    const-string p0, "BASEBAND_VERSION"

    return-object p0

    :pswitch_82
    const-string p0, "DTMF_STOP"

    return-object p0

    :pswitch_83
    const-string p0, "DTMF_START"

    return-object p0

    :pswitch_84
    const-string p0, "QUERY_AVAILABLE_NETWORKS "

    return-object p0

    :pswitch_85
    const-string p0, "SET_NETWORK_SELECTION_MANUAL"

    return-object p0

    :pswitch_86
    const-string p0, "SET_NETWORK_SELECTION_AUTOMATIC"

    return-object p0

    :pswitch_87
    const-string p0, "QUERY_NETWORK_SELECTION_MODE"

    return-object p0

    :pswitch_88
    const-string p0, "CHANGE_BARRING_PASSWORD"

    return-object p0

    :pswitch_89
    const-string p0, "SET_FACILITY_LOCK"

    return-object p0

    :pswitch_8a
    const-string p0, "QUERY_FACILITY_LOCK"

    return-object p0

    :pswitch_8b
    const-string p0, "DEACTIVATE_DATA_CALL"

    return-object p0

    :pswitch_8c
    const-string p0, "ANSWER"

    return-object p0

    :pswitch_8d
    const-string p0, "GET_IMEISV"

    return-object p0

    :pswitch_8e
    const-string p0, "GET_IMEI"

    return-object p0

    :pswitch_8f
    const-string p0, "SMS_ACKNOWLEDGE"

    return-object p0

    :pswitch_90
    const-string p0, "SET_CALL_WAITING"

    return-object p0

    :pswitch_91
    const-string p0, "QUERY_CALL_WAITING"

    return-object p0

    :pswitch_92
    const-string p0, "SET_CALL_FORWARD"

    return-object p0

    :pswitch_93
    const-string p0, "QUERY_CALL_FORWARD_STATUS"

    return-object p0

    :pswitch_94
    const-string p0, "SET_CLIR"

    return-object p0

    :pswitch_95
    const-string p0, "GET_CLIR"

    return-object p0

    :pswitch_96
    const-string p0, "CANCEL_USSD"

    return-object p0

    :pswitch_97
    const-string p0, "SEND_USSD"

    return-object p0

    :pswitch_98
    const-string p0, "SIM_IO"

    return-object p0

    :pswitch_99
    const-string p0, "SETUP_DATA_CALL"

    return-object p0

    :pswitch_9a
    const-string p0, "SEND_SMS_EXPECT_MORE"

    return-object p0

    :pswitch_9b
    const-string p0, "SEND_SMS"

    return-object p0

    :pswitch_9c
    const-string p0, "DTMF"

    return-object p0

    :pswitch_9d
    const-string p0, "RADIO_POWER"

    return-object p0

    :pswitch_9e
    const-string p0, "OPERATOR"

    return-object p0

    :pswitch_9f
    const-string p0, "DATA_REGISTRATION_STATE"

    return-object p0

    :pswitch_a0
    const-string p0, "VOICE_REGISTRATION_STATE"

    return-object p0

    :pswitch_a1
    const-string p0, "SIGNAL_STRENGTH"

    return-object p0

    :pswitch_a2
    const-string p0, "LAST_CALL_FAIL_CAUSE"

    return-object p0

    :pswitch_a3
    const-string p0, "UDUB"

    return-object p0

    :pswitch_a4
    const-string p0, "CONFERENCE"

    return-object p0

    :pswitch_a5
    const-string p0, "REQUEST_SWITCH_WAITING_OR_HOLDING_AND_ACTIVE"

    return-object p0

    :pswitch_a6
    const-string p0, "HANGUP_FOREGROUND_RESUME_BACKGROUND"

    return-object p0

    :pswitch_a7
    const-string p0, "HANGUP_WAITING_OR_BACKGROUND"

    return-object p0

    :pswitch_a8
    const-string p0, "HANGUP"

    return-object p0

    :pswitch_a9
    const-string p0, "GET_IMSI"

    return-object p0

    :pswitch_aa
    const-string p0, "DIAL"

    return-object p0

    :pswitch_ab
    const-string p0, "GET_CURRENT_CALLS"

    return-object p0

    :pswitch_ac
    const-string p0, "ENTER_NETWORK_DEPERSONALIZATION"

    return-object p0

    :pswitch_ad
    const-string p0, "CHANGE_SIM_PIN2"

    return-object p0

    :pswitch_ae
    const-string p0, "CHANGE_SIM_PIN"

    return-object p0

    :pswitch_af
    const-string p0, "ENTER_SIM_PUK2"

    return-object p0

    :pswitch_b0
    const-string p0, "ENTER_SIM_PIN2"

    return-object p0

    :pswitch_b1
    const-string p0, "ENTER_SIM_PUK"

    return-object p0

    :pswitch_b2
    const-string p0, "ENTER_SIM_PIN"

    return-object p0

    :pswitch_b3
    const-string p0, "GET_SIM_STATUS"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_b3
        :pswitch_b2
        :pswitch_b1
        :pswitch_b0
        :pswitch_af
        :pswitch_ae
        :pswitch_ad
        :pswitch_ac
        :pswitch_ab
        :pswitch_aa
        :pswitch_a9
        :pswitch_a8
        :pswitch_a7
        :pswitch_a6
        :pswitch_a5
        :pswitch_a4
        :pswitch_a3
        :pswitch_a2
        :pswitch_a1
        :pswitch_a0
        :pswitch_9f
        :pswitch_9e
        :pswitch_9d
        :pswitch_9c
        :pswitch_9b
        :pswitch_9a
        :pswitch_99
        :pswitch_98
        :pswitch_97
        :pswitch_96
        :pswitch_95
        :pswitch_94
        :pswitch_93
        :pswitch_92
        :pswitch_91
        :pswitch_90
        :pswitch_8f
        :pswitch_8e
        :pswitch_8d
        :pswitch_8c
        :pswitch_8b
        :pswitch_8a
        :pswitch_89
        :pswitch_88
        :pswitch_87
        :pswitch_86
        :pswitch_85
        :pswitch_84
        :pswitch_83
        :pswitch_82
        :pswitch_81
        :pswitch_80
        :pswitch_7f
        :pswitch_7e
        :pswitch_7d
        :pswitch_7c
        :pswitch_7b
        :pswitch_7a
        :pswitch_79
        :pswitch_78
        :pswitch_77
        :pswitch_76
        :pswitch_75
        :pswitch_74
        :pswitch_73
        :pswitch_72
        :pswitch_71
        :pswitch_70
        :pswitch_6f
        :pswitch_6e
        :pswitch_6d
        :pswitch_6c
        :pswitch_6b
        :pswitch_6a
        :pswitch_69
        :pswitch_68
        :pswitch_67
        :pswitch_66
        :pswitch_65
        :pswitch_64
        :pswitch_63
        :pswitch_62
        :pswitch_61
        :pswitch_60
        :pswitch_5f
        :pswitch_5e
        :pswitch_5d
        :pswitch_5c
        :pswitch_5b
        :pswitch_5a
        :pswitch_59
        :pswitch_58
        :pswitch_57
        :pswitch_56
        :pswitch_55
        :pswitch_54
        :pswitch_53
        :pswitch_52
        :pswitch_51
        :pswitch_50
        :pswitch_4f
        :pswitch_4e
        :pswitch_4d
        :pswitch_4c
        :pswitch_4b
        :pswitch_4a
        :pswitch_49
        :pswitch_48
        :pswitch_47
        :pswitch_46
        :pswitch_45
        :pswitch_44
        :pswitch_43
        :pswitch_42
        :pswitch_41
        :pswitch_40
        :pswitch_3f
        :pswitch_3e
        :pswitch_3d
        :pswitch_3c
        :pswitch_3b
        :pswitch_3a
        :pswitch_39
        :pswitch_38
        :pswitch_37
        :pswitch_36
        :pswitch_35
        :pswitch_34
        :pswitch_33
        :pswitch_32
        :pswitch_31
        :pswitch_30
        :pswitch_2f
        :pswitch_2e
        :pswitch_2d
        :pswitch_2c
        :pswitch_2b
        :pswitch_2a
        :pswitch_29
        :pswitch_28
        :pswitch_27
        :pswitch_26
        :pswitch_25
        :pswitch_24
        :pswitch_23
        :pswitch_22
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0xc8
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static responseToString(I)Ljava/lang/String;
    .locals 7

    packed-switch p0, :pswitch_data_0

    packed-switch p0, :pswitch_data_1

    packed-switch p0, :pswitch_data_2

    const-string v0, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v1, "0"

    .line 5208
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 5209
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "<unknown response>"

    if-eqz v0, :cond_0

    :try_start_0
    const-string v0, "com.mediatek.internal.telephony.MtkRIL"

    .line 5212
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v2, "responseToStringEx"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    .line 5213
    const-class v5, Ljava/lang/Integer;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v0, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v2, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    .line 5215
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v3, v6

    invoke-virtual {v0, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v1, p0

    :catch_0
    :cond_0
    return-object v1

    :pswitch_0
    const-string p0, "UNSOL_BARRING_INFO_CHANGED"

    return-object p0

    :pswitch_1
    const-string p0, "UNSOL_REGISTRATION_FAILED"

    return-object p0

    :pswitch_2
    const-string p0, "UNSOL_UICC_APPLICATIONS_ENABLEMENT_CHANGED"

    return-object p0

    :pswitch_3
    const-string p0, "UNSOL_EMERGENCY_NUMBER_LIST"

    return-object p0

    :pswitch_4
    const-string p0, "UNSOL_PHYSICAL_CHANNEL_CONFIG"

    return-object p0

    :pswitch_5
    const-string p0, "UNSOL_ICC_SLOT_STATUS"

    return-object p0

    :pswitch_6
    const-string p0, "UNSOL_RESPONSE_SIM_PHONEBOOK_RECORDS_RECEIVED"

    return-object p0

    :pswitch_7
    const-string p0, "UNSOL_RESPONSE_SIM_PHONEBOOK_CHANGED"

    return-object p0

    :pswitch_8
    const-string p0, "UNSOL_UNTHROTTLE_APN"

    return-object p0

    :pswitch_9
    const-string p0, "UNSOL_KEEPALIVE_STATUS"

    return-object p0

    :pswitch_a
    const-string p0, "UNSOL_NETWORK_SCAN_RESULT"

    return-object p0

    :pswitch_b
    const-string p0, "UNSOL_CARRIER_INFO_IMSI_ENCRYPTION"

    return-object p0

    :pswitch_c
    const-string p0, "UNSOL_MODEM_RESTART"

    return-object p0

    :pswitch_d
    const-string p0, "UNSOL_PCO_DATA"

    return-object p0

    :pswitch_e
    const-string p0, "UNSOL_LCE_INFO_RECV"

    return-object p0

    :pswitch_f
    const-string p0, "UNSOL_STK_CC_ALPHA_NOTIFY"

    return-object p0

    :pswitch_10
    const-string p0, "UNSOL_ON_SS"

    return-object p0

    :pswitch_11
    const-string p0, "UNSOL_RADIO_CAPABILITY"

    return-object p0

    :pswitch_12
    const-string p0, "UNSOL_DC_RT_INFO_CHANGED"

    return-object p0

    :pswitch_13
    const-string p0, "UNSOL_HARDWARE_CONFIG_CHANGED"

    return-object p0

    :pswitch_14
    const-string p0, "UNSOL_SRVCC_STATE_NOTIFY"

    return-object p0

    :pswitch_15
    const-string p0, "UNSOL_UICC_SUBSCRIPTION_STATUS_CHANGED"

    return-object p0

    :pswitch_16
    const-string p0, "UNSOL_RESPONSE_IMS_NETWORK_STATE_CHANGED"

    return-object p0

    :pswitch_17
    const-string p0, "UNSOL_CELL_INFO_LIST"

    return-object p0

    :pswitch_18
    const-string p0, "UNSOL_VOICE_RADIO_TECH_CHANGED"

    return-object p0

    :pswitch_19
    const-string p0, "UNSOL_RIL_CONNECTED"

    return-object p0

    :pswitch_1a
    const-string p0, "UNSOL_EXIT_EMERGENCY_CALLBACK_MODE"

    return-object p0

    :pswitch_1b
    const-string p0, "UNSOL_CDMA_PRL_CHANGED"

    return-object p0

    :pswitch_1c
    const-string p0, "UNSOL_CDMA_SUBSCRIPTION_SOURCE_CHANGED"

    return-object p0

    :pswitch_1d
    const-string p0, "UNSOL_RESEND_INCALL_MUTE"

    return-object p0

    :pswitch_1e
    const-string p0, "UNSOL_RINGBACK_TONE"

    return-object p0

    :pswitch_1f
    const-string p0, "UNSOL_OEM_HOOK_RAW"

    return-object p0

    :pswitch_20
    const-string p0, "UNSOL_CDMA_INFO_REC"

    return-object p0

    :pswitch_21
    const-string p0, "UNSOL_CDMA_OTA_PROVISION_STATUS"

    return-object p0

    :pswitch_22
    const-string p0, "UNSOL_CDMA_CALL_WAITING"

    return-object p0

    :pswitch_23
    const-string p0, "UNSOL_ENTER_EMERGENCY_CALLBACK_MODE"

    return-object p0

    :pswitch_24
    const-string p0, "UNSOL_RESTRICTED_STATE_CHANGED"

    return-object p0

    :pswitch_25
    const-string p0, "UNSOL_CDMA_RUIM_SMS_STORAGE_FULL"

    return-object p0

    :pswitch_26
    const-string p0, "UNSOL_RESPONSE_NEW_BROADCAST_SMS"

    return-object p0

    :pswitch_27
    const-string p0, "UNSOL_RESPONSE_CDMA_NEW_SMS"

    return-object p0

    :pswitch_28
    const-string p0, "UNSOL_RESPONSE_SIM_STATUS_CHANGED"

    return-object p0

    :pswitch_29
    const-string p0, "UNSOL_CALL_RING"

    return-object p0

    :pswitch_2a
    const-string p0, "UNSOL_SIM_REFRESH"

    return-object p0

    :pswitch_2b
    const-string p0, "UNSOL_SIM_SMS_STORAGE_FULL"

    return-object p0

    :pswitch_2c
    const-string p0, "UNSOL_STK_CALL_SETUP"

    return-object p0

    :pswitch_2d
    const-string p0, "UNSOL_STK_EVENT_NOTIFY"

    return-object p0

    :pswitch_2e
    const-string p0, "UNSOL_STK_PROACTIVE_COMMAND"

    return-object p0

    :pswitch_2f
    const-string p0, "UNSOL_STK_SESSION_END"

    return-object p0

    :pswitch_30
    const-string p0, "UNSOL_SUPP_SVC_NOTIFICATION"

    return-object p0

    :pswitch_31
    const-string p0, "UNSOL_DATA_CALL_LIST_CHANGED"

    return-object p0

    :pswitch_32
    const-string p0, "UNSOL_SIGNAL_STRENGTH"

    return-object p0

    :pswitch_33
    const-string p0, "UNSOL_NITZ_TIME_RECEIVED"

    return-object p0

    :pswitch_34
    const-string p0, "UNSOL_ON_USSD_REQUEST"

    return-object p0

    :pswitch_35
    const-string p0, "UNSOL_ON_USSD"

    return-object p0

    :pswitch_36
    const-string p0, "UNSOL_RESPONSE_NEW_SMS_ON_SIM"

    return-object p0

    :pswitch_37
    const-string p0, "UNSOL_RESPONSE_NEW_SMS_STATUS_REPORT"

    return-object p0

    :pswitch_38
    const-string p0, "UNSOL_RESPONSE_NEW_SMS"

    return-object p0

    :pswitch_39
    const-string p0, "UNSOL_RESPONSE_NETWORK_STATE_CHANGED"

    return-object p0

    :pswitch_3a
    const-string p0, "UNSOL_RESPONSE_CALL_STATE_CHANGED"

    return-object p0

    :pswitch_3b
    const-string p0, "UNSOL_RESPONSE_RADIO_STATE_CHANGED"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x3e8
        :pswitch_3b
        :pswitch_3a
        :pswitch_39
        :pswitch_38
        :pswitch_37
        :pswitch_36
        :pswitch_35
        :pswitch_34
        :pswitch_33
        :pswitch_32
        :pswitch_31
        :pswitch_30
        :pswitch_2f
        :pswitch_2e
        :pswitch_2d
        :pswitch_2c
        :pswitch_2b
        :pswitch_2a
        :pswitch_29
        :pswitch_28
        :pswitch_27
        :pswitch_26
        :pswitch_25
        :pswitch_24
        :pswitch_23
        :pswitch_22
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x41c
        :pswitch_8
        :pswitch_7
        :pswitch_6
    .end packed-switch

    :pswitch_data_2
    .packed-switch 0x44c
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static setupDataReasonToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    .line 4662
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "HANDOVER"

    return-object p0

    :cond_1
    const-string p0, "NORMAL"

    return-object p0

    :cond_2
    const-string p0, "UNKNOWN"

    return-object p0
.end method
