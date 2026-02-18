.class public Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;
.super Ljava/lang/Object;
.source "LaunchConfig.java"


# static fields
.field public static final ACTIVITY_CONSIDERED_IDLE:J = 0x3e8L

.field public static final ACTIVITY_CONSIDERED_RESUME:J = 0x7d0L

.field public static final COUNT_DEFAULT:I = 0x1

.field public static SPECIAL_MAP:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 53
    new-instance v0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig$1;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig$1;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/launch/LaunchConfig;->SPECIAL_MAP:Ljava/util/Map;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
