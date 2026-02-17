.class public Lcom/android/internal/telephony/data/KeepaliveStatus;
.super Ljava/lang/Object;
.source "KeepaliveStatus.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/android/internal/telephony/data/KeepaliveStatus;",
            ">;"
        }
    .end annotation
.end field

.field public static final ERROR_NONE:I = 0x0

.field public static final ERROR_NO_RESOURCES:I = 0x2

.field public static final ERROR_UNKNOWN:I = 0x3

.field public static final ERROR_UNSUPPORTED:I = 0x1

.field public static final INVALID_HANDLE:I = 0x7fffffff

.field public static final STATUS_ACTIVE:I = 0x0

.field public static final STATUS_INACTIVE:I = 0x1

.field public static final STATUS_PENDING:I = 0x2


# instance fields
.field public final errorCode:I

.field public final sessionHandle:I

.field public final statusCode:I
    .annotation build Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 100
    new-instance v0, Lcom/android/internal/telephony/data/KeepaliveStatus$1;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/KeepaliveStatus$1;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/data/KeepaliveStatus;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>(I)V
    .locals 1

    .line 62
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const v0, 0x7fffffff

    .line 63
    iput v0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    const/4 v0, 0x1

    .line 64
    iput v0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    .line 65
    iput p1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    return-void
.end method

.method public constructor <init>(II)V
    .locals 0
    .param p2    # I
        .annotation build Lcom/android/internal/telephony/data/KeepaliveStatus$KeepaliveStatusCode;
        .end annotation
    .end param

    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 69
    iput p1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    .line 70
    iput p2, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    const/4 p1, 0x0

    .line 71
    iput p1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    return-void
.end method

.method private constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 94
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 95
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    .line 96
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    .line 97
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    return-void
.end method

.method synthetic constructor <init>(Landroid/os/Parcel;Lcom/android/internal/telephony/data/KeepaliveStatus-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(Landroid/os/Parcel;)V

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 77
    iget v1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    .line 78
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget v1, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget p0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 v1, 0x2

    aput-object p0, v0, v1

    const-string/jumbo p0, "{errorCode=%d, sessionHandle=%d, statusCode=%d}"

    .line 77
    invoke-static {p0, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 89
    iget p2, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 90
    iget p2, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 91
    iget p0, p0, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
