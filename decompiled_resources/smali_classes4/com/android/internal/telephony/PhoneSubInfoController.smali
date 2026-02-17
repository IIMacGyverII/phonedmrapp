.class public Lcom/android/internal/telephony/PhoneSubInfoController;
.super Lcom/android/internal/telephony/IPhoneSubInfo$Stub;
.source "PhoneSubInfoController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;,
        Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field private static final TAG:Ljava/lang/String; = "PhoneSubInfoController"

.field private static final VDBG:Z = false


# instance fields
.field private mAppOps:Landroid/app/AppOpsManager;

.field private final mContext:Landroid/content/Context;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$4Fn0tkRyNaCeY8o4RVyNcEwhT_M(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck$22(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$6AmAJwCY_zo2CMzwtrNK_RFTkX4(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIsimDomain$15(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$AtnL4lswd7BxFBxHdpSXdQv47bA(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$resetCarrierKeysForImsiEncryption$5(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$C0XIWfHmI-AYshyzmnjTOqsSEbQ(ILcom/android/internal/telephony/Phone;)Landroid/telephony/ImsiEncryptionInfo;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getCarrierInfoForImsiEncryption$3(ILcom/android/internal/telephony/Phone;)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$KyLnFb-Htr-DEfmA4iz-SyobOrE(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getDeviceIdForPhone$0(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$M5bgoEn6XVkGvBfKeepd7HLTg3A(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIsimImpu$16(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$MPAoBQu9fd9P_AxSsUyjgKK17Xs(Lcom/android/internal/telephony/PhoneSubInfoController;IILjava/lang/String;Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIccSimChallengeResponse$19(IILjava/lang/String;Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$RXzDgoMCP2x2epNyEwDf2N5w56s(Lcom/android/internal/telephony/PhoneSubInfoController;Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithModifyCheck$25(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$TbuYNBUl1MV58PfsZXkWBFEM8Wg(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getVoiceMailAlphaTagForSubscriber$13(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$VTfTx-U7MEt2WMvXRNLnmcJOcAc(Lcom/android/internal/telephony/PhoneSubInfoController;Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getVoiceMailNumberForSubscriber$12(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$WhSbW5KLa7rJpw39q0uiESnW4wI(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck$23(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$WytkJSy_JvYQynwOoN86FpdJvJI(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getDeviceSvnUsingSubId$6(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$XzENYZNCETjxQY_svycFf9IBfgk(Landroid/telephony/ImsiEncryptionInfo;Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$setCarrierInfoForImsiEncryption$4(Landroid/telephony/ImsiEncryptionInfo;Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$d7Vc6i1h8gpOT6wKvxlA9e6qHmo(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithReadPhoneNumberCheck$26(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$dVu5LT3S7qbWTyn9nYtHqcPinOE(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getImeiForSubscriber$2(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$eXuQyCe82NtHGM8RdVJyHnR3OIY(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIsimImpi$14(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$jU13rye3Ob5wWScRoaOlWAy7ojU(Lcom/android/internal/telephony/PhoneSubInfoController;Ljava/lang/String;Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithPrivilegedCheck$24(Ljava/lang/String;Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$jVenYL4Evuz_j9-6RUaTEJ5kUe0(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIsimPcscf$18(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$kEsLBr4Vf_yUVQfaSgmxNMGxjA4(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIccSerialNumberForSubscriber$8(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$kobtDnxwkORL2o2TOzyf86Yw3k8(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getGroupIdLevel1ForSubscriber$20(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$obyG-OzI0W0OHkRIAr_rdp5EzYQ(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getLine1NumberForSubscriber$9(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$rKDpZQroY1vt2c_kMM7pgLTqjaA(Lcom/android/internal/telephony/PhoneSubInfoController;Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/PhoneSubInfoController;->enforceIccSimChallengeResponsePermission(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$rKHUtA3zPz276k7mMB2KbvIBSPE(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getNaiForSubscriber$1(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$vjTdESL-zxfDUWs6m-8EfsCZrLQ(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getMsisdnForSubscriber$11(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$wa_ax_93FFimSOIsKlEhUFwKclM(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getSubscriberIdForSubscriber$7(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$xfSMDyUZq_vF3O_50pw8KWK-b_I(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getIsimIst$17(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$yHpEJLxpqc4iqJ-DbN1Q7YRsE6A(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$callPhoneMethodForSubIdWithReadCheck$21(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$zKDetgHCqi6Au94YpCk40UGiR5Q(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->lambda$getLine1AlphaTagForSubscriber$10(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 55
    invoke-direct {p0}, Lcom/android/internal/telephony/IPhoneSubInfo$Stub;-><init>()V

    .line 57
    invoke-static {}, Landroid/telephony/TelephonyFrameworkInitializer;->getTelephonyServiceManager()Landroid/os/TelephonyServiceManager;

    move-result-object v0

    .line 58
    invoke-virtual {v0}, Landroid/os/TelephonyServiceManager;->getPhoneSubServiceRegisterer()Landroid/os/TelephonyServiceManager$ServiceRegisterer;

    move-result-object v0

    .line 59
    invoke-virtual {v0}, Landroid/os/TelephonyServiceManager$ServiceRegisterer;->get()Landroid/os/IBinder;

    move-result-object v1

    if-nez v1, :cond_0

    .line 60
    invoke-virtual {v0, p0}, Landroid/os/TelephonyServiceManager$ServiceRegisterer;->register(Landroid/os/IBinder;)V

    .line 62
    :cond_0
    const-class v0, Landroid/app/AppOpsManager;

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AppOpsManager;

    iput-object v0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mAppOps:Landroid/app/AppOpsManager;

    .line 63
    iput-object p1, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    return-void
.end method

.method private callPhoneMethodForPhoneIdWithReadDeviceIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 564
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p1, 0x0

    .line 567
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    const/4 v0, 0x0

    if-nez p1, :cond_1

    return-object v0

    .line 571
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    .line 572
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 571
    invoke-static {p0, v1, p2, p3, p4}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadDeviceIdentifiers(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_2

    return-object v0

    .line 576
    :cond_2
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide p2

    .line 578
    :try_start_0
    invoke-interface {p5, p1}, Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;->callMethod(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 580
    invoke-static {p2, p3}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-static {p2, p3}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 581
    throw p0
.end method

.method private callPhoneMethodForSubIdWithModifyCheck(ILjava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 543
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda18;

    invoke-direct {v6, p0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda18;-><init>(Lcom/android/internal/telephony/PhoneSubInfoController;)V

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v0, p0

    move v1, p1

    move-object v4, p3

    move-object v5, p4

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 534
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda0;

    invoke-direct {v6, p0, p2}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/PhoneSubInfoController;Ljava/lang/String;)V

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v0, p0

    move v1, p1

    move-object v4, p2

    move-object v5, p3

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 505
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda27;

    invoke-direct {v6}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda27;-><init>()V

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 515
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda20;

    invoke-direct {v6}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda20;-><init>()V

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodForSubIdWithReadPhoneNumberCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 553
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda23;

    invoke-direct {v6}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda23;-><init>()V

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 525
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda16;

    invoke-direct {v6}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda16;-><init>()V

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(I",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper<",
            "TT;>;",
            "Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;",
            ")TT;"
        }
    .end annotation

    .line 483
    iget-object v1, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    move-object v0, p6

    move v2, p1

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    invoke-interface/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;->checkPermission(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p2

    const/4 p3, 0x0

    if-nez p2, :cond_0

    return-object p3

    .line 488
    :cond_0
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 490
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p2

    if-eqz p2, :cond_1

    .line 492
    invoke-interface {p5, p2}, Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;->callMethod(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 498
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    .line 494
    :cond_1
    :try_start_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p4, " phone is null for Subscription:"

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->loge(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 498
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p3

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 499
    throw p0
.end method

.method private enforceCallingPackage(Ljava/lang/String;ILjava/lang/String;)V
    .locals 2

    .line 326
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    .line 327
    invoke-static {p2}, Landroid/os/UserHandle;->getUserHandleForUid(I)Landroid/os/UserHandle;

    move-result-object v0

    const/4 v1, 0x0

    .line 326
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->createContextAsUser(Landroid/os/UserHandle;I)Landroid/content/Context;

    move-result-object p0

    .line 327
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 330
    :try_start_0
    invoke-virtual {p0, p1, v1}, Landroid/content/pm/PackageManager;->getPackageUid(Ljava/lang/String;I)I

    move-result p0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    :cond_0
    const/4 p0, -0x1

    :goto_0
    if-ne p0, p2, :cond_1

    return-void

    .line 336
    :cond_1
    new-instance p0, Ljava/lang/SecurityException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, ": Package "

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " does not belong to "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private enforceCallingPackageUidMatched(Ljava/lang/String;)V
    .locals 3

    .line 275
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mAppOps:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v0

    invoke-virtual {p0, v0, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p0

    const p1, 0x534e4554

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    const-string v2, "188677422"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    .line 277
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v0, v1

    invoke-static {p1, v0}, Landroid/util/EventLog;->writeEvent(I[Ljava/lang/Object;)I

    .line 278
    throw p0
.end method

.method private enforceIccSimChallengeResponsePermission(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 284
    invoke-static {p1, p3, p4, p5}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfUseIccAuthWithDeviceIdentifier(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p1

    const/4 p3, 0x1

    if-eqz p1, :cond_0

    return p3

    .line 289
    :cond_0
    invoke-direct {p0, p2, p5}, Lcom/android/internal/telephony/PhoneSubInfoController;->enforcePrivilegedPermissionOrCarrierPrivilege(ILjava/lang/String;)V

    return p3
.end method

.method private enforceModifyPermission()V
    .locals 2

    .line 315
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    const-string v0, "android.permission.MODIFY_PHONE_STATE"

    const-string v1, "Requires MODIFY_PHONE_STATE"

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private enforcePrivilegedPermissionOrCarrierPrivilege(ILjava/lang/String;)V
    .locals 2

    .line 302
    iget-object v0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.READ_PRIVILEGED_PHONE_STATE"

    invoke-virtual {v0, v1}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 308
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/TelephonyPermissions;->enforceCallingOrSelfCarrierPrivilege(Landroid/content/Context;ILjava/lang/String;)V

    return-void
.end method

.method private getDefaultSubscription()I
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 343
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getDefaultSubscription()I

    move-result p0

    return p0
.end method

.method private getPhone(I)Lcom/android/internal/telephony/Phone;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 266
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result p0

    .line 267
    invoke-static {p0}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result p1

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 270
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$callPhoneMethodForSubIdWithModifyCheck$25(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 545
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->enforceModifyPermission()V

    const/4 p0, 0x1

    return p0
.end method

.method private synthetic lambda$callPhoneMethodForSubIdWithPrivilegedCheck$24(Ljava/lang/String;Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 536
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    const-string p2, "android.permission.READ_PRIVILEGED_PHONE_STATE"

    invoke-virtual {p0, p2, p1}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0
.end method

.method private static synthetic lambda$callPhoneMethodForSubIdWithReadCheck$21(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 508
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadPhoneState(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck$22(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 518
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadDeviceIdentifiers(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$callPhoneMethodForSubIdWithReadPhoneNumberCheck$26(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 556
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadPhoneNumber(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck$23(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 528
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadSubscriberIdentifiers(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$getCarrierInfoForImsiEncryption$3(ILcom/android/internal/telephony/Phone;)Landroid/telephony/ImsiEncryptionInfo;
    .locals 1

    const/4 v0, 0x1

    .line 98
    invoke-virtual {p1, p0, v0}, Lcom/android/internal/telephony/Phone;->getCarrierInfoForImsiEncryption(IZ)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getDeviceIdForPhone$0(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 80
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDeviceId()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getDeviceSvnUsingSubId$6(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 134
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDeviceSvn()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getGroupIdLevel1ForSubscriber$20(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 456
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getGroupIdLevel1()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getIccSerialNumberForSubscriber$8(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 194
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIccSerialNumber()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$getIccSimChallengeResponse$19(IILjava/lang/String;Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 3

    .line 425
    invoke-virtual {p4}, Lcom/android/internal/telephony/Phone;->getUiccPort()Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p4

    const/4 v0, 0x0

    if-nez p4, :cond_0

    const-string p1, "getIccSimChallengeResponse() uiccPort is null"

    .line 427
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 431
    :cond_0
    invoke-virtual {p4, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->getApplicationByType(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p4

    if-nez p4, :cond_1

    .line 433
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "getIccSimChallengeResponse() no app with specified type -- "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 436
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getIccSimChallengeResponse() found app "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getAid()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " specified type -- "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->loge(Ljava/lang/String;)V

    const/16 p1, 0x80

    if-eq p2, p1, :cond_2

    const/16 p1, 0x81

    if-eq p2, p1, :cond_2

    .line 442
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "getIccSimChallengeResponse() unsupported authType: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 445
    :cond_2
    invoke-virtual {p4}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Lcom/android/internal/telephony/uicc/IccRecords;->getIccSimChallengeResponse(ILjava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getImeiForSubscriber$2(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 91
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getImei()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getIsimDomain$15(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 367
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 369
    invoke-interface {p0}, Lcom/android/internal/telephony/uicc/IsimRecords;->getIsimDomain()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$getIsimImpi$14(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 352
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 354
    invoke-interface {p0}, Lcom/android/internal/telephony/uicc/IsimRecords;->getIsimImpi()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$getIsimImpu$16(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;
    .locals 0

    .line 382
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 384
    invoke-interface {p0}, Lcom/android/internal/telephony/uicc/IsimRecords;->getIsimImpu()[Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$getIsimIst$17(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 397
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 399
    invoke-interface {p0}, Lcom/android/internal/telephony/uicc/IsimRecords;->getIsimIst()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$getIsimPcscf$18(Lcom/android/internal/telephony/Phone;)[Ljava/lang/String;
    .locals 0

    .line 412
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getIsimRecords()Lcom/android/internal/telephony/uicc/IsimRecords;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 414
    invoke-interface {p0}, Lcom/android/internal/telephony/uicc/IsimRecords;->getIsimPcscf()[Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$getLine1AlphaTagForSubscriber$10(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 219
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getLine1AlphaTag()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getLine1NumberForSubscriber$9(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 208
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getLine1Number()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getMsisdnForSubscriber$11(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 231
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getMsisdn()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getNaiForSubscriber$1(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 85
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getNai()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getSubscriberIdForSubscriber$7(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 163
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getSubscriberId()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getVoiceMailAlphaTagForSubscriber$13(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 258
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getVoiceMailAlphaTag()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$getVoiceMailNumberForSubscriber$12(Lcom/android/internal/telephony/Phone;)Ljava/lang/String;
    .locals 0

    .line 244
    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getVoiceMailNumber()Ljava/lang/String;

    move-result-object p0

    .line 243
    invoke-static {p0}, Landroid/telephony/PhoneNumberUtils;->extractNetworkPortion(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$resetCarrierKeysForImsiEncryption$5(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    .line 122
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->resetCarrierKeysForImsiEncryption()V

    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$setCarrierInfoForImsiEncryption$4(Landroid/telephony/ImsiEncryptionInfo;Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    .line 106
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/Phone;->setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    const-string p0, "PhoneSubInfoController"

    .line 585
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const-string p0, "PhoneSubInfoController"

    .line 590
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public getCarrierInfoForImsiEncryption(IILjava/lang/String;)Landroid/telephony/ImsiEncryptionInfo;
    .locals 0

    .line 96
    new-instance p3, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda24;

    invoke-direct {p3, p2}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda24;-><init>(I)V

    const-string p2, "getCarrierInfoForImsiEncryption"

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/ImsiEncryptionInfo;

    return-object p0
.end method

.method public getDeviceId(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v0, 0x0

    .line 68
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDeviceIdWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDeviceIdForPhone(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 78
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->enforceCallingPackageUidMatched(Ljava/lang/String;)V

    .line 79
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda21;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda21;-><init>()V

    const-string v4, "getDeviceId"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForPhoneIdWithReadDeviceIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getDeviceIdWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 72
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDeviceIdForPhone(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDeviceSvn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 128
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDeviceSvnUsingSubId(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDeviceSvnUsingSubId(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 133
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda17;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda17;-><init>()V

    const-string v4, "getDeviceSvn"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getGroupIdLevel1ForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 455
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda22;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda22;-><init>()V

    const-string v4, "getGroupIdLevel1"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIccSerialNumber(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v0, 0x0

    .line 180
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getIccSerialNumberWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getIccSerialNumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 193
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda5;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda5;-><init>()V

    const-string v4, "getIccSerialNumber"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIccSerialNumberWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 187
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getIccSerialNumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getIccSimChallengeResponse(IIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 424
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;

    invoke-direct {v5, p0, p2, p3, p4}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/PhoneSubInfoController;IILjava/lang/String;)V

    .line 448
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda3;

    invoke-direct {v6, p0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/PhoneSubInfoController;)V

    const-string v4, "getIccSimChallengeResponse"

    move-object v0, p0

    move v1, p1

    move-object v2, p5

    move-object v3, p6

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodWithPermissionCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;Lcom/android/internal/telephony/PhoneSubInfoController$PermissionCheckHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getImeiForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 90
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda14;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda14;-><init>()V

    const-string v4, "getImei"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadDeviceIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIsimDomain(I)Ljava/lang/String;
    .locals 2

    .line 365
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda13;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda13;-><init>()V

    const-string v1, "getIsimDomain"

    invoke-direct {p0, p1, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIsimImpi(I)Ljava/lang/String;
    .locals 2

    .line 350
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda8;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda8;-><init>()V

    const-string v1, "getIsimImpi"

    invoke-direct {p0, p1, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIsimImpu(I)[Ljava/lang/String;
    .locals 2

    .line 380
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda7;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda7;-><init>()V

    const-string v1, "getIsimImpu"

    invoke-direct {p0, p1, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/lang/String;

    return-object p0
.end method

.method public getIsimIst(I)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 395
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda4;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda4;-><init>()V

    const-string v1, "getIsimIst"

    invoke-direct {p0, p1, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getIsimPcscf(I)[Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 410
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda25;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda25;-><init>()V

    const-string v1, "getIsimPcscf"

    invoke-direct {p0, p1, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithPrivilegedCheck(ILjava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/lang/String;

    return-object p0
.end method

.method public getLine1AlphaTag(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 212
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getLine1AlphaTagForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getLine1AlphaTagForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 218
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda6;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda6;-><init>()V

    const-string v4, "getLine1AlphaTag"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getLine1Number(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 198
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getLine1NumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getLine1NumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 206
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda1;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda1;-><init>()V

    const-string v4, "getLine1Number"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadPhoneNumberCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getMsisdn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 223
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getMsisdnForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getMsisdnForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 230
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda10;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda10;-><init>()V

    const-string v4, "getMsisdn"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadPhoneNumberCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getNaiForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 84
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda26;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda26;-><init>()V

    const-string v4, "getNai"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getSubscriberId(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v0, 0x0

    .line 139
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getSubscriberIdWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getSubscriberIdForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 7

    .line 151
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v0

    const-string v5, "getSubscriberIdForSubscriber"

    invoke-direct {p0, p2, v0, v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->enforceCallingPackage(Ljava/lang/String;ILjava/lang/String;)V

    .line 153
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 156
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v2

    invoke-virtual {v2, p1, p2, p3}, Lcom/android/internal/telephony/SubscriptionController;->isActiveSubId(ILjava/lang/String;Ljava/lang/String;)Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 159
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    if-eqz v2, :cond_0

    .line 162
    new-instance v6, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda15;

    invoke-direct {v6}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda15;-><init>()V

    move-object v1, p0

    move v2, p1

    move-object v3, p2

    move-object v4, p3

    invoke-direct/range {v1 .. v6}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadSubscriberIdentifiersCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0

    .line 165
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController;->mContext:Landroid/content/Context;

    invoke-static {p0, p1, p2, p3, v5}, Lcom/android/internal/telephony/TelephonyPermissions;->checkCallingOrSelfReadSubscriberIdentifiers(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_1

    const/4 p0, 0x0

    return-object p0

    .line 169
    :cond_1
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide p2

    .line 171
    :try_start_1
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->getImsiPrivileged(I)Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 173
    invoke-static {p2, p3}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-static {p2, p3}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 174
    throw p0

    :catchall_1
    move-exception p0

    .line 159
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 160
    throw p0
.end method

.method public getSubscriberIdWithFeature(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 143
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getSubscriberIdForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getVoiceMailAlphaTag(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 251
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getVoiceMailAlphaTagForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getVoiceMailAlphaTagForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 257
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda19;

    invoke-direct {v5}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda19;-><init>()V

    const-string v4, "getVoiceMailAlphaTag"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getVoiceMailNumber(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 235
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneSubInfoController;->getDefaultSubscription()I

    move-result v0

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/PhoneSubInfoController;->getVoiceMailNumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getVoiceMailNumberForSubscriber(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 241
    new-instance v5, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda12;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda12;-><init>(Lcom/android/internal/telephony/PhoneSubInfoController;)V

    const-string v4, "getVoiceMailNumber"

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithReadCheck(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public resetCarrierKeysForImsiEncryption(ILjava/lang/String;)V
    .locals 2

    .line 119
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda9;

    invoke-direct {v0}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda9;-><init>()V

    const-string v1, "resetCarrierKeysForImsiEncryption"

    invoke-direct {p0, p1, p2, v1, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithModifyCheck(ILjava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    return-void
.end method

.method public setCarrierInfoForImsiEncryption(ILjava/lang/String;Landroid/telephony/ImsiEncryptionInfo;)V
    .locals 1

    .line 103
    new-instance v0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda11;

    invoke-direct {v0, p3}, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda11;-><init>(Landroid/telephony/ImsiEncryptionInfo;)V

    const-string p3, "setCarrierInfoForImsiEncryption"

    invoke-direct {p0, p1, p2, p3, v0}, Lcom/android/internal/telephony/PhoneSubInfoController;->callPhoneMethodForSubIdWithModifyCheck(ILjava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;)Ljava/lang/Object;

    return-void
.end method
