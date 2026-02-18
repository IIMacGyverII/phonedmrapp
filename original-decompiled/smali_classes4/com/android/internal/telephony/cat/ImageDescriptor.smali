.class public Lcom/android/internal/telephony/cat/ImageDescriptor;
.super Ljava/lang/Object;
.source "ImageDescriptor.java"


# static fields
.field public static final CODING_SCHEME_BASIC:I = 0x11

.field public static final CODING_SCHEME_COLOUR:I = 0x21


# instance fields
.field public mCodingScheme:I

.field public mHeight:I

.field public mHighOffset:I

.field public mImageId:I

.field public mLength:I

.field public mLowOffset:I

.field public mWidth:I


# direct methods
.method constructor <init>()V
    .locals 1

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 41
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mWidth:I

    .line 42
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHeight:I

    .line 43
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mCodingScheme:I

    .line 44
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mImageId:I

    .line 45
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHighOffset:I

    .line 46
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLowOffset:I

    .line 47
    iput v0, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLength:I

    return-void
.end method

.method public static parse([BI)Lcom/android/internal/telephony/cat/ImageDescriptor;
    .locals 5

    const-string v0, "ImageDescriptor"

    const-string v1, ", "

    .line 60
    new-instance v2, Lcom/android/internal/telephony/cat/ImageDescriptor;

    invoke-direct {v2}, Lcom/android/internal/telephony/cat/ImageDescriptor;-><init>()V

    add-int/lit8 v3, p1, 0x1

    .line 62
    :try_start_0
    aget-byte p1, p0, p1

    and-int/lit16 p1, p1, 0xff

    iput p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mWidth:I

    add-int/lit8 p1, v3, 0x1

    .line 63
    aget-byte v3, p0, v3

    and-int/lit16 v3, v3, 0xff

    iput v3, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHeight:I

    add-int/lit8 v3, p1, 0x1

    .line 64
    aget-byte p1, p0, p1

    and-int/lit16 p1, p1, 0xff

    iput p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mCodingScheme:I

    add-int/lit8 p1, v3, 0x1

    .line 67
    aget-byte v3, p0, v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x8

    add-int/lit8 v4, p1, 0x1

    .line 68
    aget-byte p1, p0, p1

    and-int/lit16 p1, p1, 0xff

    or-int/2addr p1, v3

    iput p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mImageId:I

    add-int/lit8 p1, v4, 0x1

    .line 70
    aget-byte v3, p0, v4

    and-int/lit16 v3, v3, 0xff

    iput v3, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHighOffset:I

    add-int/lit8 v3, p1, 0x1

    .line 71
    aget-byte p1, p0, p1

    and-int/lit16 p1, p1, 0xff

    iput p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLowOffset:I

    add-int/lit8 p1, v3, 0x1

    .line 73
    aget-byte v3, p0, v3

    and-int/lit16 v3, v3, 0xff

    shl-int/lit8 v3, v3, 0x8

    aget-byte p0, p0, p1

    and-int/lit16 p0, p0, 0xff

    or-int/2addr p0, v3

    iput p0, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLength:I

    .line 74
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "parse; Descriptor : "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mWidth:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHeight:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mCodingScheme:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", 0x"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mImageId:I

    .line 75
    invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mHighOffset:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLowOffset:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, v2, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLength:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 74
    invoke-static {v0, p0}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/IndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string p0, "parse; failed parsing image descriptor"

    .line 78
    invoke-static {v0, p0}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v2, 0x0

    :goto_0
    return-object v2
.end method
