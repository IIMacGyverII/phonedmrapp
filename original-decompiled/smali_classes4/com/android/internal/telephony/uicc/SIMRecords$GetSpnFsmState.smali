.class public final enum Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
.super Ljava/lang/Enum;
.source "SIMRecords.java"


# annotations
.annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    implicitMember = "values()[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;"
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/SIMRecords;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x401c
    name = "GetSpnFsmState"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

.field public static final enum IDLE:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

.field public static final enum INIT:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum READ_SPN_3GPP:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum READ_SPN_CPHS:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum READ_SPN_SHORT_CPHS:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 11

    .line 1775
    new-instance v0, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const-string v1, "IDLE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->IDLE:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    .line 1776
    new-instance v1, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const-string v3, "INIT"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->INIT:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    .line 1778
    new-instance v3, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const-string v5, "READ_SPN_3GPP"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->READ_SPN_3GPP:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    .line 1780
    new-instance v5, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const-string v7, "READ_SPN_CPHS"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->READ_SPN_CPHS:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    .line 1782
    new-instance v7, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const-string v9, "READ_SPN_SHORT_CPHS"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->READ_SPN_SHORT_CPHS:Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    const/4 v9, 0x5

    new-array v9, v9, [Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    aput-object v0, v9, v2

    aput-object v1, v9, v4

    aput-object v3, v9, v6

    aput-object v5, v9, v8

    aput-object v7, v9, v10

    .line 1771
    sput-object v9, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->$VALUES:[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1773
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .locals 1

    .line 1771
    const-class v0, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;
    .locals 1

    .line 1771
    sget-object v0, Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->$VALUES:[Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/uicc/SIMRecords$GetSpnFsmState;

    return-object v0
.end method
