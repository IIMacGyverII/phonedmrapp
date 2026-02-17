.class public final enum Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;
.super Ljava/lang/Enum;
.source "DcTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DcTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x401c
    name = "RetryFailures"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

.field public static final enum ALWAYS:Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

.field public static final enum ONLY_ON_CHANGE:Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    .line 1546
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    const-string v1, "ALWAYS"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;->ALWAYS:Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    .line 1550
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    const-string v3, "ONLY_ON_CHANGE"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;->ONLY_ON_CHANGE:Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    const/4 v3, 0x2

    new-array v3, v3, [Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    aput-object v0, v3, v2

    aput-object v1, v3, v4

    .line 1544
    sput-object v3, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1544
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;
    .locals 1

    .line 1544
    const-class v0, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;
    .locals 1

    .line 1544
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/dataconnection/DcTracker$RetryFailures;

    return-object v0
.end method
