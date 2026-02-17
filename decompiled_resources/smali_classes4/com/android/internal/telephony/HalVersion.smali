.class public Lcom/android/internal/telephony/HalVersion;
.super Ljava/lang/Object;
.source "HalVersion.java"

# interfaces
.implements Ljava/lang/Comparable;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/lang/Comparable<",
        "Lcom/android/internal/telephony/HalVersion;",
        ">;"
    }
.end annotation


# static fields
.field public static final UNKNOWN:Lcom/android/internal/telephony/HalVersion;


# instance fields
.field public final major:I

.field public final minor:I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 29
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    const/4 v1, -0x1

    invoke-direct {v0, v1, v1}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/HalVersion;->UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    return-void
.end method

.method public constructor <init>(II)V
    .locals 0

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 36
    iput p1, p0, Lcom/android/internal/telephony/HalVersion;->major:I

    .line 37
    iput p2, p0, Lcom/android/internal/telephony/HalVersion;->minor:I

    return-void
.end method


# virtual methods
.method public compareTo(Lcom/android/internal/telephony/HalVersion;)I
    .locals 4

    const/4 v0, 0x1

    if-nez p1, :cond_0

    return v0

    .line 45
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/HalVersion;->major:I

    iget v2, p1, Lcom/android/internal/telephony/HalVersion;->major:I

    if-le v1, v2, :cond_1

    return v0

    :cond_1
    const/4 v3, -0x1

    if-ge v1, v2, :cond_2

    return v3

    .line 49
    :cond_2
    iget p0, p0, Lcom/android/internal/telephony/HalVersion;->minor:I

    iget p1, p1, Lcom/android/internal/telephony/HalVersion;->minor:I

    if-le p0, p1, :cond_3

    return v0

    :cond_3
    if-ge p0, p1, :cond_4

    return v3

    :cond_4
    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic compareTo(Ljava/lang/Object;)I
    .locals 0

    .line 26
    check-cast p1, Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->compareTo(Lcom/android/internal/telephony/HalVersion;)I

    move-result p0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 1

    .line 64
    instance-of v0, p1, Lcom/android/internal/telephony/HalVersion;

    if-eqz v0, :cond_1

    if-eq p1, p0, :cond_0

    check-cast p1, Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->compareTo(Lcom/android/internal/telephony/HalVersion;)I

    move-result p0

    if-nez p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public greater(Lcom/android/internal/telephony/HalVersion;)Z
    .locals 0

    .line 71
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->compareTo(Lcom/android/internal/telephony/HalVersion;)I

    move-result p0

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z
    .locals 1

    .line 85
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->greater(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

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

.method public hashCode()I
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 59
    iget v1, p0, Lcom/android/internal/telephony/HalVersion;->major:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget p0, p0, Lcom/android/internal/telephony/HalVersion;->minor:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 v1, 0x1

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public less(Lcom/android/internal/telephony/HalVersion;)Z
    .locals 0

    .line 78
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->compareTo(Lcom/android/internal/telephony/HalVersion;)I

    move-result p0

    if-gez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public lessOrEqual(Lcom/android/internal/telephony/HalVersion;)Z
    .locals 1

    .line 92
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HalVersion;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

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

.method public toString()Ljava/lang/String;
    .locals 2

    .line 97
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget v1, p0, Lcom/android/internal/telephony/HalVersion;->major:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/HalVersion;->minor:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
