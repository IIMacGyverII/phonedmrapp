.class public abstract Lcom/mediatek/powerhalmgr/IPowerHalMgr$Stub;
.super Landroid/os/Binder;
.source "IPowerHalMgr.java"

# interfaces
.implements Lcom/mediatek/powerhalmgr/IPowerHalMgr;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/powerhalmgr/IPowerHalMgr;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Stub"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/powerhalmgr/IPowerHalMgr$Stub$Proxy;
    }
.end annotation


# static fields
.field static final TRANSACTION_UpdateManagementPkt:I = 0xc

.field static final TRANSACTION_configBoosterInfo:I = 0x1f

.field static final TRANSACTION_flushPriorityRules:I = 0x1e

.field static final TRANSACTION_getCpuCap:I = 0x8

.field static final TRANSACTION_getCpuRTInfo:I = 0xb

.field static final TRANSACTION_getGpuCap:I = 0x9

.field static final TRANSACTION_getGpuRTInfo:I = 0xa

.field static final TRANSACTION_isDupPacketPredictionStarted:I = 0x11

.field static final TRANSACTION_mtkCusPowerHint:I = 0x7

.field static final TRANSACTION_mtkPowerHint:I = 0x19

.field static final TRANSACTION_perfCusLockHint:I = 0x1a

.field static final TRANSACTION_perfLockAcquire:I = 0x16

.field static final TRANSACTION_perfLockRelease:I = 0x17

.field static final TRANSACTION_querySysInfo:I = 0x18

.field static final TRANSACTION_registerDuplicatePacketPredictionEvent:I = 0x12

.field static final TRANSACTION_scnConfig:I = 0x2

.field static final TRANSACTION_scnDisable:I = 0x5

.field static final TRANSACTION_scnEnable:I = 0x4

.field static final TRANSACTION_scnReg:I = 0x1

.field static final TRANSACTION_scnUltraCfg:I = 0x6

.field static final TRANSACTION_scnUnreg:I = 0x3

.field static final TRANSACTION_setForegroundSports:I = 0xd

.field static final TRANSACTION_setPredictInfo:I = 0x15

.field static final TRANSACTION_setPriorityByLinkinfo:I = 0x1d

.field static final TRANSACTION_setPriorityByUid:I = 0x1c

.field static final TRANSACTION_setSysInfo:I = 0xe

.field static final TRANSACTION_setSysInfoSync:I = 0x1b

.field static final TRANSACTION_startDuplicatePacketPrediction:I = 0xf

.field static final TRANSACTION_stopDuplicatePacketPrediction:I = 0x10

.field static final TRANSACTION_unregisterDuplicatePacketPredictionEvent:I = 0x13

.field static final TRANSACTION_updateMultiDuplicatePacketLink:I = 0x14


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 134
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    const-string v0, "com.mediatek.powerhalmgr.IPowerHalMgr"

    .line 135
    invoke-virtual {p0, p0, v0}, Landroid/os/Binder;->attachInterface(Landroid/os/IInterface;Ljava/lang/String;)V

    return-void
.end method

.method public static asInterface(Landroid/os/IBinder;)Lcom/mediatek/powerhalmgr/IPowerHalMgr;
    .locals 2

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    const-string v0, "com.mediatek.powerhalmgr.IPowerHalMgr"

    .line 146
    invoke-interface {p0, v0}, Landroid/os/IBinder;->queryLocalInterface(Ljava/lang/String;)Landroid/os/IInterface;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 147
    instance-of v1, v0, Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    if-eqz v1, :cond_1

    .line 148
    check-cast v0, Lcom/mediatek/powerhalmgr/IPowerHalMgr;

    return-object v0

    .line 150
    :cond_1
    new-instance v0, Lcom/mediatek/powerhalmgr/IPowerHalMgr$Stub$Proxy;

    invoke-direct {v0, p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr$Stub$Proxy;-><init>(Landroid/os/IBinder;)V

    return-object v0
.end method


# virtual methods
.method public asBinder()Landroid/os/IBinder;
    .locals 0

    return-object p0
.end method

.method public onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const/4 v0, 0x1

    const-string v1, "com.mediatek.powerhalmgr.IPowerHalMgr"

    if-lt p1, v0, :cond_0

    const v2, 0xffffff

    if-gt p1, v2, :cond_0

    .line 160
    invoke-virtual {p2, v1}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    :cond_0
    const v2, 0x5f4e5446

    if-eq p1, v2, :cond_1

    packed-switch p1, :pswitch_data_0

    .line 471
    invoke-super {p0, p1, p2, p3, p4}, Landroid/os/Binder;->onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p0

    return p0

    .line 462
    :pswitch_0
    sget-object p1, Lcom/mediatek/powerhalmgr/BoosterInfo;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {p2, p1}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/mediatek/powerhalmgr/BoosterInfo;

    .line 463
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 464
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->configBoosterInfo(Lcom/mediatek/powerhalmgr/BoosterInfo;)Z

    move-result p0

    .line 465
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 466
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 452
    :pswitch_1
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 453
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 454
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->flushPriorityRules(I)Z

    move-result p0

    .line 455
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 456
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 440
    :pswitch_2
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 442
    sget-object p4, Lcom/mediatek/powerhalmgr/DupLinkInfo;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {p2, p4}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object p4

    check-cast p4, Lcom/mediatek/powerhalmgr/DupLinkInfo;

    .line 443
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 444
    invoke-interface {p0, p1, p4}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPriorityByLinkinfo(ILcom/mediatek/powerhalmgr/DupLinkInfo;)Z

    move-result p0

    .line 445
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 446
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 428
    :pswitch_3
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 430
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p4

    .line 431
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 432
    invoke-interface {p0, p1, p4}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPriorityByUid(II)Z

    move-result p0

    .line 433
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 434
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 416
    :pswitch_4
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 418
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p4

    .line 419
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 420
    invoke-interface {p0, p1, p4}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setSysInfoSync(ILjava/lang/String;)I

    move-result p0

    .line 421
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 422
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeInt(I)V

    goto/16 :goto_0

    .line 404
    :pswitch_5
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 406
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p4

    .line 407
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 408
    invoke-interface {p0, p1, p4}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfCusLockHint(II)I

    move-result p0

    .line 409
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 410
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeInt(I)V

    goto/16 :goto_0

    .line 394
    :pswitch_6
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 396
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p3

    .line 397
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 398
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->mtkPowerHint(II)V

    goto/16 :goto_0

    .line 382
    :pswitch_7
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 384
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p4

    .line 385
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 386
    invoke-interface {p0, p1, p4}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->querySysInfo(II)I

    move-result p0

    .line 387
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 388
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeInt(I)V

    goto/16 :goto_0

    .line 374
    :pswitch_8
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 375
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 376
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfLockRelease(I)V

    goto/16 :goto_0

    .line 360
    :pswitch_9
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 362
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p4

    .line 364
    invoke-virtual {p2}, Landroid/os/Parcel;->createIntArray()[I

    move-result-object v1

    .line 365
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 366
    invoke-interface {p0, p1, p4, v1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->perfLockAcquire(II[I)I

    move-result p0

    .line 367
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 368
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeInt(I)V

    goto/16 :goto_0

    .line 350
    :pswitch_a
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    .line 352
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p3

    .line 353
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 354
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setPredictInfo(Ljava/lang/String;I)V

    goto/16 :goto_0

    .line 340
    :pswitch_b
    sget-object p1, Lcom/mediatek/powerhalmgr/DupLinkInfo;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {p2, p1}, Landroid/os/Parcel;->createTypedArray(Landroid/os/Parcelable$Creator;)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/mediatek/powerhalmgr/DupLinkInfo;

    .line 341
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 342
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->updateMultiDuplicatePacketLink([Lcom/mediatek/powerhalmgr/DupLinkInfo;)Z

    move-result p0

    .line 343
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 344
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 330
    :pswitch_c
    invoke-virtual {p2}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;

    move-result-object p1

    invoke-static {p1}, Landroid/os/IRemoteCallback$Stub;->asInterface(Landroid/os/IBinder;)Landroid/os/IRemoteCallback;

    move-result-object p1

    .line 331
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 332
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->unregisterDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z

    move-result p0

    .line 333
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 334
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 320
    :pswitch_d
    invoke-virtual {p2}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;

    move-result-object p1

    invoke-static {p1}, Landroid/os/IRemoteCallback$Stub;->asInterface(Landroid/os/IBinder;)Landroid/os/IRemoteCallback;

    move-result-object p1

    .line 321
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 322
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->registerDuplicatePacketPredictionEvent(Landroid/os/IRemoteCallback;)Z

    move-result p0

    .line 323
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 324
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 312
    :pswitch_e
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->isDupPacketPredictionStarted()Z

    move-result p0

    .line 313
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 314
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 305
    :pswitch_f
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->stopDuplicatePacketPrediction()Z

    move-result p0

    .line 306
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 307
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 298
    :pswitch_10
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->startDuplicatePacketPrediction()Z

    move-result p0

    .line 299
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 300
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    goto/16 :goto_0

    .line 289
    :pswitch_11
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 291
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p3

    .line 292
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 293
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setSysInfo(ILjava/lang/String;)V

    goto/16 :goto_0

    .line 283
    :pswitch_12
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->setForegroundSports()V

    goto/16 :goto_0

    .line 274
    :pswitch_13
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 276
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p3

    .line 277
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 278
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->UpdateManagementPkt(ILjava/lang/String;)V

    goto/16 :goto_0

    .line 268
    :pswitch_14
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->getCpuRTInfo()V

    goto/16 :goto_0

    .line 263
    :pswitch_15
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->getGpuRTInfo()V

    goto/16 :goto_0

    .line 258
    :pswitch_16
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->getGpuCap()V

    goto/16 :goto_0

    .line 253
    :pswitch_17
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->getCpuCap()V

    goto/16 :goto_0

    .line 244
    :pswitch_18
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 246
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p3

    .line 247
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 248
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->mtkCusPowerHint(II)V

    goto/16 :goto_0

    .line 226
    :pswitch_19
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v2

    .line 228
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v3

    .line 230
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v4

    .line 232
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v5

    .line 234
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v6

    .line 236
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v7

    .line 237
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    move-object v1, p0

    .line 238
    invoke-interface/range {v1 .. v7}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnUltraCfg(IIIIII)V

    goto :goto_0

    .line 218
    :pswitch_1a
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 219
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 220
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnDisable(I)V

    goto :goto_0

    .line 208
    :pswitch_1b
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 210
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p3

    .line 211
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 212
    invoke-interface {p0, p1, p3}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnEnable(II)V

    goto :goto_0

    .line 200
    :pswitch_1c
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p1

    .line 201
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 202
    invoke-interface {p0, p1}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnUnreg(I)V

    goto :goto_0

    .line 182
    :pswitch_1d
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v2

    .line 184
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v3

    .line 186
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v4

    .line 188
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v5

    .line 190
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v6

    .line 192
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result v7

    .line 193
    invoke-virtual {p2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    move-object v1, p0

    .line 194
    invoke-interface/range {v1 .. v7}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnConfig(IIIIII)V

    goto :goto_0

    .line 174
    :pswitch_1e
    invoke-interface {p0}, Lcom/mediatek/powerhalmgr/IPowerHalMgr;->scnReg()I

    move-result p0

    .line 175
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 176
    invoke-virtual {p3, p0}, Landroid/os/Parcel;->writeInt(I)V

    :goto_0
    return v0

    .line 166
    :cond_1
    invoke-virtual {p3, v1}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    return v0

    :pswitch_data_0
    .packed-switch 0x1
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
