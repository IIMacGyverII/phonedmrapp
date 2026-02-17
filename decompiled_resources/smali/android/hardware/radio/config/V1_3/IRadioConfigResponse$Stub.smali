.class public abstract Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;
.super Landroid/os/HwBinder;
.source "IRadioConfigResponse.java"

# interfaces
.implements Landroid/hardware/radio/config/V1_3/IRadioConfigResponse;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/hardware/radio/config/V1_3/IRadioConfigResponse;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Stub"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 568
    invoke-direct {p0}, Landroid/os/HwBinder;-><init>()V

    return-void
.end method


# virtual methods
.method public asBinder()Landroid/os/IHwBinder;
    .locals 0

    return-object p0
.end method

.method public debug(Landroid/os/NativeHandle;Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/os/NativeHandle;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    return-void
.end method

.method public final getDebugInfo()Landroid/internal/hidl/base/V1_0/DebugInfo;
    .locals 2

    .line 627
    new-instance p0, Landroid/internal/hidl/base/V1_0/DebugInfo;

    invoke-direct {p0}, Landroid/internal/hidl/base/V1_0/DebugInfo;-><init>()V

    .line 628
    invoke-static {}, Landroid/os/HidlSupport;->getPidIfSharable()I

    move-result v0

    iput v0, p0, Landroid/internal/hidl/base/V1_0/DebugInfo;->pid:I

    const-wide/16 v0, 0x0

    .line 629
    iput-wide v0, p0, Landroid/internal/hidl/base/V1_0/DebugInfo;->ptr:J

    const/4 v0, 0x0

    .line 630
    iput v0, p0, Landroid/internal/hidl/base/V1_0/DebugInfo;->arch:I

    return-object p0
.end method

.method public final getHashChain()Ljava/util/ArrayList;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "[B>;"
        }
    .end annotation

    .line 599
    new-instance p0, Ljava/util/ArrayList;

    const/4 v0, 0x5

    new-array v0, v0, [[B

    const/16 v1, 0x20

    new-array v2, v1, [B

    fill-array-data v2, :array_0

    const/4 v3, 0x0

    aput-object v2, v0, v3

    new-array v2, v1, [B

    fill-array-data v2, :array_1

    const/4 v3, 0x1

    aput-object v2, v0, v3

    new-array v2, v1, [B

    fill-array-data v2, :array_2

    const/4 v3, 0x2

    aput-object v2, v0, v3

    new-array v2, v1, [B

    fill-array-data v2, :array_3

    const/4 v3, 0x3

    aput-object v2, v0, v3

    new-array v1, v1, [B

    fill-array-data v1, :array_4

    const/4 v2, 0x4

    aput-object v1, v0, v2

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object p0

    nop

    :array_0
    .array-data 1
        -0x37t
        -0x53t
        0x18t
        0x72t
        -0x6et
        0x68t
        0x59t
        0x3dt
        0x14t
        0x68t
        0x1dt
        -0x78t
        -0x1t
        -0x53t
        0x1ct
        -0x69t
        -0x19t
        0x7t
        0x44t
        0x4at
        0x45t
        -0x1ft
        -0x4ct
        -0x13t
        -0x80t
        0x4dt
        -0x55t
        -0x6ct
        -0x62t
        -0x25t
        -0x28t
        0x4ft
    .end array-data

    :array_1
    .array-data 1
        -0x28t
        -0x19t
        0x71t
        0x7et
        -0x7ft
        -0x79t
        -0x23t
        0x74t
        0x53t
        -0x2ct
        0x14t
        0x2ft
        -0x71t
        0x33t
        0x1et
        0x7ct
        0x32t
        0x5et
        0x7at
        0x6ft
        -0x62t
        -0x73t
        0x44t
        -0x54t
        0xdt
        0x52t
        -0x4dt
        -0x42t
        0x50t
        0x2bt
        -0x2t
        -0x7dt
    .end array-data

    :array_2
    .array-data 1
        -0x4ct
        0x2et
        -0x4dt
        -0x45t
        -0x2bt
        -0x19t
        -0x4bt
        0x19t
        -0x1et
        -0x7dt
        0x62t
        0x34t
        0xct
        0x22t
        0x5t
        -0x56t
        0x75t
        0x35t
        0x6dt
        -0x1at
        -0x4dt
        0xft
        0x4ft
        -0x30t
        -0x62t
        -0x3et
        -0x16t
        0x78t
        0x4ft
        0x25t
        0xat
        -0x50t
    .end array-data

    :array_3
    .array-data 1
        -0x5et
        -0x17t
        -0x49t
        -0x56t
        0x9t
        -0x9t
        -0x6ct
        0x26t
        -0x9t
        0x65t
        -0x7dt
        -0x7ft
        0x74t
        -0x20t
        0x4bt
        0x6ft
        -0x66t
        0x3et
        0x6ct
        -0x75t
        0x76t
        -0x47t
        0x23t
        -0x4t
        0x17t
        0x5t
        0x63t
        0x22t
        0x7t
        -0x46t
        -0x2ct
        0x4bt
    .end array-data

    :array_4
    .array-data 1
        -0x14t
        0x7ft
        -0x29t
        -0x62t
        -0x30t
        0x2dt
        -0x6t
        -0x7bt
        -0x44t
        0x49t
        -0x6ct
        0x26t
        -0x53t
        -0x52t
        0x3et
        -0x42t
        0x23t
        -0x11t
        0x5t
        0x24t
        -0xdt
        -0x33t
        0x69t
        0x57t
        0x13t
        -0x6dt
        0x24t
        -0x48t
        0x3bt
        0x18t
        -0x36t
        0x4ct
    .end array-data
.end method

.method public final interfaceChain()Ljava/util/ArrayList;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 576
    new-instance p0, Ljava/util/ArrayList;

    const-string v0, "android.hardware.radio.config@1.3::IRadioConfigResponse"

    const-string v1, "android.hardware.radio.config@1.2::IRadioConfigResponse"

    const-string v2, "android.hardware.radio.config@1.1::IRadioConfigResponse"

    const-string v3, "android.hardware.radio.config@1.0::IRadioConfigResponse"

    const-string v4, "android.hidl.base@1.0::IBase"

    filled-new-array {v0, v1, v2, v3, v4}, [Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object p0
.end method

.method public final interfaceDescriptor()Ljava/lang/String;
    .locals 0

    const-string p0, "android.hardware.radio.config@1.3::IRadioConfigResponse"

    return-object p0
.end method

.method public final linkToDeath(Landroid/os/IHwBinder$DeathRecipient;J)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public final notifySyspropsChanged()V
    .locals 0

    .line 637
    invoke-static {}, Landroid/os/HwBinder;->enableInstrumentation()V

    return-void
.end method

.method public onTransact(ILandroid/os/HwParcel;Landroid/os/HwParcel;I)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const-string p4, "android.hardware.radio.config@1.0::IRadioConfigResponse"

    const-string v0, "android.hardware.radio.config@1.1::IRadioConfigResponse"

    packed-switch p1, :pswitch_data_0

    const/4 p4, 0x0

    const-string v0, "android.hidl.base@1.0::IBase"

    sparse-switch p1, :sswitch_data_0

    goto/16 :goto_1

    .line 859
    :sswitch_0
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 861
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->notifySyspropsChanged()V

    goto/16 :goto_1

    .line 848
    :sswitch_1
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 850
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->getDebugInfo()Landroid/internal/hidl/base/V1_0/DebugInfo;

    move-result-object p0

    .line 851
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 852
    invoke-virtual {p0, p3}, Landroid/internal/hidl/base/V1_0/DebugInfo;->writeToParcel(Landroid/os/HwParcel;)V

    .line 853
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    .line 838
    :sswitch_2
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 840
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->ping()V

    .line 841
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 842
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    .line 825
    :sswitch_3
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 827
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->setHALInstrumentation()V

    goto/16 :goto_1

    .line 791
    :sswitch_4
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 793
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->getHashChain()Ljava/util/ArrayList;

    move-result-object p0

    .line 794
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 796
    new-instance p1, Landroid/os/HwBlob;

    const/16 p2, 0x10

    invoke-direct {p1, p2}, Landroid/os/HwBlob;-><init>(I)V

    .line 798
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p2

    const-wide/16 v0, 0x8

    .line 799
    invoke-virtual {p1, v0, v1, p2}, Landroid/os/HwBlob;->putInt32(JI)V

    const-wide/16 v0, 0xc

    .line 800
    invoke-virtual {p1, v0, v1, p4}, Landroid/os/HwBlob;->putBool(JZ)V

    .line 801
    new-instance v0, Landroid/os/HwBlob;

    mul-int/lit8 v1, p2, 0x20

    invoke-direct {v0, v1}, Landroid/os/HwBlob;-><init>(I)V

    :goto_0
    if-ge p4, p2, :cond_1

    mul-int/lit8 v1, p4, 0x20

    int-to-long v1, v1

    .line 805
    invoke-virtual {p0, p4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [B

    if-eqz v3, :cond_0

    .line 807
    array-length v4, v3

    const/16 v5, 0x20

    if-ne v4, v5, :cond_0

    .line 811
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/HwBlob;->putInt8Array(J[B)V

    add-int/lit8 p4, p4, 0x1

    goto :goto_0

    .line 808
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Array element is not of the expected length"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    const-wide/16 v1, 0x0

    .line 815
    invoke-virtual {p1, v1, v2, v0}, Landroid/os/HwBlob;->putBlob(JLandroid/os/HwBlob;)V

    .line 817
    invoke-virtual {p3, p1}, Landroid/os/HwParcel;->writeBuffer(Landroid/os/HwBlob;)V

    .line 819
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    .line 780
    :sswitch_5
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 782
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->interfaceDescriptor()Ljava/lang/String;

    move-result-object p0

    .line 783
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 784
    invoke-virtual {p3, p0}, Landroid/os/HwParcel;->writeString(Ljava/lang/String;)V

    .line 785
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    .line 768
    :sswitch_6
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 770
    invoke-virtual {p2}, Landroid/os/HwParcel;->readNativeHandle()Landroid/os/NativeHandle;

    move-result-object p1

    .line 771
    invoke-virtual {p2}, Landroid/os/HwParcel;->readStringVector()Ljava/util/ArrayList;

    move-result-object p2

    .line 772
    invoke-virtual {p0, p1, p2}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->debug(Landroid/os/NativeHandle;Ljava/util/ArrayList;)V

    .line 773
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 774
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    .line 757
    :sswitch_7
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 759
    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->interfaceChain()Ljava/util/ArrayList;

    move-result-object p0

    .line 760
    invoke-virtual {p3, p4}, Landroid/os/HwParcel;->writeStatus(I)V

    .line 761
    invoke-virtual {p3, p0}, Landroid/os/HwParcel;->writeStringVector(Ljava/util/ArrayList;)V

    .line 762
    invoke-virtual {p3}, Landroid/os/HwParcel;->send()V

    goto/16 :goto_1

    :pswitch_0
    const-string p1, "android.hardware.radio.config@1.3::IRadioConfigResponse"

    .line 746
    invoke-virtual {p2, p1}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 748
    new-instance p1, Landroid/hardware/radio/V1_6/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_6/RadioResponseInfo;-><init>()V

    .line 749
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_6/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 750
    invoke-virtual {p2}, Landroid/os/HwParcel;->readBool()Z

    move-result p2

    .line 751
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse;->getHalDeviceCapabilitiesResponse(Landroid/hardware/radio/V1_6/RadioResponseInfo;Z)V

    goto/16 :goto_1

    :pswitch_1
    const-string p1, "android.hardware.radio.config@1.2::IRadioConfigResponse"

    .line 735
    invoke-virtual {p2, p1}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 737
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 738
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 739
    invoke-static {p2}, Landroid/hardware/radio/config/V1_2/SimSlotStatus;->readVectorFromParcel(Landroid/os/HwParcel;)Ljava/util/ArrayList;

    move-result-object p2

    .line 740
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/V1_2/IRadioConfigResponse;->getSimSlotsStatusResponse_1_2(Landroid/hardware/radio/V1_0/RadioResponseInfo;Ljava/util/ArrayList;)V

    goto :goto_1

    .line 723
    :pswitch_2
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 725
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 726
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 727
    new-instance p3, Landroid/hardware/radio/config/V1_1/ModemsConfig;

    invoke-direct {p3}, Landroid/hardware/radio/config/V1_1/ModemsConfig;-><init>()V

    .line 728
    invoke-virtual {p3, p2}, Landroid/hardware/radio/config/V1_1/ModemsConfig;->readFromParcel(Landroid/os/HwParcel;)V

    .line 729
    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/config/V1_1/IRadioConfigResponse;->getModemsConfigResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;Landroid/hardware/radio/config/V1_1/ModemsConfig;)V

    goto :goto_1

    .line 713
    :pswitch_3
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 715
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 716
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 717
    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_1/IRadioConfigResponse;->setModemsConfigResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;)V

    goto :goto_1

    .line 703
    :pswitch_4
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 705
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 706
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 707
    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_1/IRadioConfigResponse;->setPreferredDataModemResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;)V

    goto :goto_1

    .line 691
    :pswitch_5
    invoke-virtual {p2, v0}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 693
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 694
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 695
    new-instance p3, Landroid/hardware/radio/config/V1_1/PhoneCapability;

    invoke-direct {p3}, Landroid/hardware/radio/config/V1_1/PhoneCapability;-><init>()V

    .line 696
    invoke-virtual {p3, p2}, Landroid/hardware/radio/config/V1_1/PhoneCapability;->readFromParcel(Landroid/os/HwParcel;)V

    .line 697
    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/config/V1_1/IRadioConfigResponse;->getPhoneCapabilityResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;Landroid/hardware/radio/config/V1_1/PhoneCapability;)V

    goto :goto_1

    .line 681
    :pswitch_6
    invoke-virtual {p2, p4}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 683
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 684
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 685
    invoke-interface {p0, p1}, Landroid/hardware/radio/config/V1_0/IRadioConfigResponse;->setSimSlotsMappingResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;)V

    goto :goto_1

    .line 670
    :pswitch_7
    invoke-virtual {p2, p4}, Landroid/os/HwParcel;->enforceInterface(Ljava/lang/String;)V

    .line 672
    new-instance p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;

    invoke-direct {p1}, Landroid/hardware/radio/V1_0/RadioResponseInfo;-><init>()V

    .line 673
    invoke-virtual {p1, p2}, Landroid/hardware/radio/V1_0/RadioResponseInfo;->readFromParcel(Landroid/os/HwParcel;)V

    .line 674
    invoke-static {p2}, Landroid/hardware/radio/config/V1_0/SimSlotStatus;->readVectorFromParcel(Landroid/os/HwParcel;)Ljava/util/ArrayList;

    move-result-object p2

    .line 675
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/config/V1_0/IRadioConfigResponse;->getSimSlotsStatusResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;Ljava/util/ArrayList;)V

    :goto_1
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch

    :sswitch_data_0
    .sparse-switch
        0xf43484e -> :sswitch_7
        0xf444247 -> :sswitch_6
        0xf445343 -> :sswitch_5
        0xf485348 -> :sswitch_4
        0xf494e54 -> :sswitch_3
        0xf504e47 -> :sswitch_2
        0xf524546 -> :sswitch_1
        0xf535953 -> :sswitch_0
    .end sparse-switch
.end method

.method public final ping()V
    .locals 0

    return-void
.end method

.method public queryLocalInterface(Ljava/lang/String;)Landroid/os/IHwInterface;
    .locals 1

    const-string v0, "android.hardware.radio.config@1.3::IRadioConfigResponse"

    .line 649
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public registerAsService(Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 656
    invoke-virtual {p0, p1}, Landroid/os/HwBinder;->registerService(Ljava/lang/String;)V

    return-void
.end method

.method public final setHALInstrumentation()V
    .locals 0

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 661
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/hardware/radio/config/V1_3/IRadioConfigResponse$Stub;->interfaceDescriptor()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "@Stub"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public final unlinkToDeath(Landroid/os/IHwBinder$DeathRecipient;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method
