.class public final enum Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
.super Ljava/lang/Enum;
.source "DataConnection.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnection;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "SetupResult"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_DATA_SERVICE_SPECIFIC_ERROR:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_DUPLICATE_CID:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_INVALID_ARG:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_NO_DEFAULT_CONNECTION:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_RADIO_NOT_AVAILABLE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum ERROR_STALE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

.field public static final enum SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;


# instance fields
.field public mFailCause:I


# direct methods
.method static constructor <clinit>()V
    .locals 15

    .line 570
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v1, "SUCCESS"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 571
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v3, "ERROR_RADIO_NOT_AVAILABLE"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_RADIO_NOT_AVAILABLE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 572
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v5, "ERROR_INVALID_ARG"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_INVALID_ARG:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 573
    new-instance v5, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v7, "ERROR_STALE"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_STALE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 574
    new-instance v7, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v9, "ERROR_DATA_SERVICE_SPECIFIC_ERROR"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DATA_SERVICE_SPECIFIC_ERROR:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 575
    new-instance v9, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v11, "ERROR_DUPLICATE_CID"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DUPLICATE_CID:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 576
    new-instance v11, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const-string v13, "ERROR_NO_DEFAULT_CONNECTION"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_NO_DEFAULT_CONNECTION:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const/4 v13, 0x7

    new-array v13, v13, [Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    aput-object v0, v13, v2

    aput-object v1, v13, v4

    aput-object v3, v13, v6

    aput-object v5, v13, v8

    aput-object v7, v13, v10

    aput-object v9, v13, v12

    aput-object v11, v13, v14

    .line 569
    sput-object v13, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 580
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    const/4 p1, 0x0

    .line 581
    invoke-static {p1}, Landroid/telephony/DataFailCause;->getFailCause(I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
    .locals 1

    .line 569
    const-class v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
    .locals 1

    .line 569
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    return-object v0
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 2

    .line 586
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/Enum;->name()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "  SetupResult.mFailCause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    invoke-static {p0}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
