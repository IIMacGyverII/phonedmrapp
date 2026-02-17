.class public final enum Lcom/android/internal/telephony/Call$State;
.super Ljava/lang/Enum;
.source "Call.java"


# annotations
.annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    implicitMember = "values()[Lcom/android/internal/telephony/Call$State;"
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/Call;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "State"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/Call$State;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/Call$State;

.field public static final enum ACTIVE:Lcom/android/internal/telephony/Call$State;

.field public static final enum ALERTING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum DIALING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum DISCONNECTED:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum DISCONNECTING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum HOLDING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum IDLE:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum INCOMING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum WAITING:Lcom/android/internal/telephony/Call$State;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 16

    .line 42
    new-instance v0, Lcom/android/internal/telephony/Call$State;

    const-string v1, "IDLE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    .line 43
    new-instance v1, Lcom/android/internal/telephony/Call$State;

    const-string v3, "ACTIVE"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/Call$State;->ACTIVE:Lcom/android/internal/telephony/Call$State;

    .line 44
    new-instance v3, Lcom/android/internal/telephony/Call$State;

    const-string v5, "HOLDING"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/Call$State;->HOLDING:Lcom/android/internal/telephony/Call$State;

    .line 45
    new-instance v5, Lcom/android/internal/telephony/Call$State;

    const-string v7, "DIALING"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/Call$State;->DIALING:Lcom/android/internal/telephony/Call$State;

    .line 46
    new-instance v7, Lcom/android/internal/telephony/Call$State;

    const-string v9, "ALERTING"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/Call$State;->ALERTING:Lcom/android/internal/telephony/Call$State;

    .line 47
    new-instance v9, Lcom/android/internal/telephony/Call$State;

    const-string v11, "INCOMING"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/Call$State;->INCOMING:Lcom/android/internal/telephony/Call$State;

    .line 48
    new-instance v11, Lcom/android/internal/telephony/Call$State;

    const-string v13, "WAITING"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/Call$State;->WAITING:Lcom/android/internal/telephony/Call$State;

    .line 49
    new-instance v13, Lcom/android/internal/telephony/Call$State;

    const-string v15, "DISCONNECTED"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v13, Lcom/android/internal/telephony/Call$State;->DISCONNECTED:Lcom/android/internal/telephony/Call$State;

    .line 50
    new-instance v15, Lcom/android/internal/telephony/Call$State;

    const-string v14, "DISCONNECTING"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12}, Lcom/android/internal/telephony/Call$State;-><init>(Ljava/lang/String;I)V

    sput-object v15, Lcom/android/internal/telephony/Call$State;->DISCONNECTING:Lcom/android/internal/telephony/Call$State;

    const/16 v14, 0x9

    new-array v14, v14, [Lcom/android/internal/telephony/Call$State;

    aput-object v0, v14, v2

    aput-object v1, v14, v4

    aput-object v3, v14, v6

    aput-object v5, v14, v8

    aput-object v7, v14, v10

    const/4 v0, 0x5

    aput-object v9, v14, v0

    const/4 v0, 0x6

    aput-object v11, v14, v0

    const/4 v0, 0x7

    aput-object v13, v14, v0

    aput-object v15, v14, v12

    .line 40
    sput-object v14, Lcom/android/internal/telephony/Call$State;->$VALUES:[Lcom/android/internal/telephony/Call$State;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 41
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/Call$State;
    .locals 1

    .line 40
    const-class v0, Lcom/android/internal/telephony/Call$State;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/Call$State;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/Call$State;
    .locals 1

    .line 40
    sget-object v0, Lcom/android/internal/telephony/Call$State;->$VALUES:[Lcom/android/internal/telephony/Call$State;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/Call$State;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/Call$State;

    return-object v0
.end method


# virtual methods
.method public isAlive()Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 54
    sget-object v0, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    if-eq p0, v0, :cond_0

    sget-object v0, Lcom/android/internal/telephony/Call$State;->DISCONNECTED:Lcom/android/internal/telephony/Call$State;

    if-eq p0, v0, :cond_0

    sget-object v0, Lcom/android/internal/telephony/Call$State;->DISCONNECTING:Lcom/android/internal/telephony/Call$State;

    if-eq p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isDialing()Z
    .locals 1

    .line 63
    sget-object v0, Lcom/android/internal/telephony/Call$State;->DIALING:Lcom/android/internal/telephony/Call$State;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/Call$State;->ALERTING:Lcom/android/internal/telephony/Call$State;

    if-ne p0, v0, :cond_0

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

.method public isRinging()Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 59
    sget-object v0, Lcom/android/internal/telephony/Call$State;->INCOMING:Lcom/android/internal/telephony/Call$State;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/Call$State;->WAITING:Lcom/android/internal/telephony/Call$State;

    if-ne p0, v0, :cond_0

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
