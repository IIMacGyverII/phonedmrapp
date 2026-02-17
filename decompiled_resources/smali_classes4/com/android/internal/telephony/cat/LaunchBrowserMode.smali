.class public final enum Lcom/android/internal/telephony/cat/LaunchBrowserMode;
.super Ljava/lang/Enum;
.source "LaunchBrowserMode.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/LaunchBrowserMode;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/LaunchBrowserMode;

.field public static final enum LAUNCH_IF_NOT_ALREADY_LAUNCHED:Lcom/android/internal/telephony/cat/LaunchBrowserMode;

.field public static final enum LAUNCH_NEW_BROWSER:Lcom/android/internal/telephony/cat/LaunchBrowserMode;

.field public static final enum USE_EXISTING_BROWSER:Lcom/android/internal/telephony/cat/LaunchBrowserMode;


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .line 27
    new-instance v0, Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    const-string v1, "LAUNCH_IF_NOT_ALREADY_LAUNCHED"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/cat/LaunchBrowserMode;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/cat/LaunchBrowserMode;->LAUNCH_IF_NOT_ALREADY_LAUNCHED:Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    .line 32
    new-instance v1, Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    const-string v3, "USE_EXISTING_BROWSER"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/cat/LaunchBrowserMode;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/cat/LaunchBrowserMode;->USE_EXISTING_BROWSER:Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    .line 34
    new-instance v3, Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    const-string v5, "LAUNCH_NEW_BROWSER"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/cat/LaunchBrowserMode;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/cat/LaunchBrowserMode;->LAUNCH_NEW_BROWSER:Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    const/4 v5, 0x3

    new-array v5, v5, [Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    aput-object v0, v5, v2

    aput-object v1, v5, v4

    aput-object v3, v5, v6

    .line 25
    sput-object v5, Lcom/android/internal/telephony/cat/LaunchBrowserMode;->$VALUES:[Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 25
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/LaunchBrowserMode;
    .locals 1

    .line 25
    const-class v0, Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/LaunchBrowserMode;
    .locals 1

    .line 25
    sget-object v0, Lcom/android/internal/telephony/cat/LaunchBrowserMode;->$VALUES:[Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/LaunchBrowserMode;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/LaunchBrowserMode;

    return-object v0
.end method
