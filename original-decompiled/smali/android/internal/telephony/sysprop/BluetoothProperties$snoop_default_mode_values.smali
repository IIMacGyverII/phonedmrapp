.class public final enum Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;
.super Ljava/lang/Enum;
.source "BluetoothProperties.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/internal/telephony/sysprop/BluetoothProperties;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "snoop_default_mode_values"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

.field public static final enum DISABLED:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

.field public static final enum EMPTY:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

.field public static final enum FILTERED:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

.field public static final enum FULL:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;


# instance fields
.field private final propValue:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 10

    .line 163
    new-instance v0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    const-string v1, "EMPTY"

    const/4 v2, 0x0

    const-string v3, "empty"

    invoke-direct {v0, v1, v2, v3}, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->EMPTY:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    .line 164
    new-instance v1, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    const-string v3, "DISABLED"

    const/4 v4, 0x1

    const-string v5, "disabled"

    invoke-direct {v1, v3, v4, v5}, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v1, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->DISABLED:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    .line 165
    new-instance v3, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    const-string v5, "FILTERED"

    const/4 v6, 0x2

    const-string v7, "filtered"

    invoke-direct {v3, v5, v6, v7}, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v3, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->FILTERED:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    .line 166
    new-instance v5, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    const-string v7, "FULL"

    const/4 v8, 0x3

    const-string v9, "full"

    invoke-direct {v5, v7, v8, v9}, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v5, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->FULL:Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    const/4 v7, 0x4

    new-array v7, v7, [Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    aput-object v0, v7, v2

    aput-object v1, v7, v4

    aput-object v3, v7, v6

    aput-object v5, v7, v8

    .line 162
    sput-object v7, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->$VALUES:[Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILjava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 168
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 169
    iput-object p3, p0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->propValue:Ljava/lang/String;

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;
    .locals 1

    .line 162
    const-class v0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    return-object p0
.end method

.method public static values()[Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;
    .locals 1

    .line 162
    sget-object v0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->$VALUES:[Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    invoke-virtual {v0}, [Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;

    return-object v0
.end method


# virtual methods
.method public getPropValue()Ljava/lang/String;
    .locals 0

    .line 172
    iget-object p0, p0, Landroid/internal/telephony/sysprop/BluetoothProperties$snoop_default_mode_values;->propValue:Ljava/lang/String;

    return-object p0
.end method
