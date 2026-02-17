.class public Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;
.super Ljava/lang/Object;
.source "MtkFileSystemProviderHelper.java"


# static fields
.field private static final BASE_URI:Landroid/net/Uri;

.field private static final DEBUG:Z = false

.field private static final DEFAULT_DOCUMENT_PROJECTION:[Ljava/lang/String;

.field private static final LOG_INOTIFY:Z = false

.field private static final MIMETYPE_JPEG:Ljava/lang/String; = "image/jpeg"

.field private static final MIMETYPE_JPG:Ljava/lang/String; = "image/jpg"

.field private static final MIMETYPE_OCTET_STREAM:Ljava/lang/String; = "application/octet-stream"

.field private static final TAG:Ljava/lang/String; = "FileSystemProvider"


# instance fields
.field private mContext:Landroid/content/Context;

.field private mDefaultProjection:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 10

    .line 44
    new-instance v0, Landroid/net/Uri$Builder;

    invoke-direct {v0}, Landroid/net/Uri$Builder;-><init>()V

    const-string v1, "content"

    .line 45
    invoke-virtual {v0, v1}, Landroid/net/Uri$Builder;->scheme(Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v0

    const-string v1, "com.android.externalstorage.documents"

    .line 46
    invoke-virtual {v0, v1}, Landroid/net/Uri$Builder;->authority(Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/Uri$Builder;->build()Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->BASE_URI:Landroid/net/Uri;

    const-string v1, "document_id"

    const-string v2, "mime_type"

    const-string v3, "_display_name"

    const-string v4, "last_modified"

    const-string v5, "flags"

    const-string v6, "_size"

    const-string v7, "_data"

    const-string v8, "is_drm"

    const-string v9, "drm_method"

    .line 54
    filled-new-array/range {v1 .. v9}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->DEFAULT_DOCUMENT_PROJECTION:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 72
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 73
    iput-object p1, p0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->mContext:Landroid/content/Context;

    return-void
.end method

.method private getTypeForDrmFile(Ljava/io/File;)Ljava/lang/String;
    .locals 1

    .line 168
    new-instance v0, Landroid/drm/DrmManagerClient;

    iget-object p0, p0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->mContext:Landroid/content/Context;

    invoke-direct {v0, p0}, Landroid/drm/DrmManagerClient;-><init>(Landroid/content/Context;)V

    .line 169
    invoke-virtual {p1}, Ljava/io/File;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    .line 173
    invoke-virtual {v0, p0, p1}, Landroid/drm/DrmManagerClient;->canHandle(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 174
    invoke-virtual {v0, p0}, Landroid/drm/DrmManagerClient;->getOriginalMimeType(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "application/octet-stream"

    return-object p0
.end method

.method public static isMtkDrmApp()Z
    .locals 2

    const-string v0, "ro.vendor.mtk_oma_drm_support"

    const/4 v1, 0x0

    .line 77
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method


# virtual methods
.method public getDefaultProjection()[Ljava/lang/String;
    .locals 0

    .line 180
    sget-object p0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->DEFAULT_DOCUMENT_PROJECTION:[Ljava/lang/String;

    return-object p0
.end method

.method public getTypeForNameMtk(Ljava/io/File;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    const/16 v0, 0x2e

    .line 144
    invoke-virtual {p2, v0}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v0

    if-ltz v0, :cond_1

    add-int/lit8 v0, v0, 0x1

    .line 146
    invoke-virtual {p2, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v0

    const-string v1, "dcf"

    .line 147
    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 148
    invoke-direct {p0, p1}, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->getTypeForDrmFile(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 150
    :cond_0
    invoke-static {}, Landroid/webkit/MimeTypeMap;->getSingleton()Landroid/webkit/MimeTypeMap;

    move-result-object p0

    invoke-virtual {p0, v0}, Landroid/webkit/MimeTypeMap;->getMimeTypeFromExtension(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_1

    return-object p0

    .line 157
    :cond_1
    invoke-static {p2}, Landroid/media/MediaFile;->getMimeTypeForFile(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_2

    return-object p0

    :cond_2
    const-string p0, "application/octet-stream"

    return-object p0
.end method

.method public supportDRM(Ljava/io/File;Landroid/database/MatrixCursor$RowBuilder;Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/FileNotFoundException;
        }
    .end annotation

    .line 84
    invoke-virtual {p1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p3

    .line 87
    invoke-static {}, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->isMtkDrmApp()Z

    move-result v0

    const-string v1, "mime_type"

    if-eqz v0, :cond_5

    invoke-virtual {p1}, Ljava/io/File;->isDirectory()Z

    move-result v0

    if-nez v0, :cond_5

    const/16 v0, 0x2e

    .line 88
    invoke-virtual {p3, v0}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v0

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-ltz v0, :cond_0

    add-int/2addr v0, v2

    .line 91
    invoke-virtual {p3, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p3

    goto :goto_0

    :cond_0
    move-object p3, v3

    :goto_0
    if-eqz p3, :cond_5

    const-string v0, "dcf"

    .line 94
    invoke-virtual {p3, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_5

    const-string p1, "external"

    .line 96
    invoke-static {p1}, Landroid/provider/MediaStore$Files;->getContentUri(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    const-string v7, "_data = ?"

    const-string p1, "is_drm"

    const-string p3, "drm_method"

    .line 99
    filled-new-array {p1, p3, v1}, [Ljava/lang/String;

    move-result-object v6

    if-eqz p5, :cond_1

    .line 111
    :try_start_0
    iget-object p0, p0, Lcom/mediatek/internal/content/MtkFileSystemProviderHelper;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    new-array v8, v2, [Ljava/lang/String;

    const/4 p0, 0x0

    .line 112
    invoke-virtual {p5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v8, p0

    const/4 v9, 0x0

    .line 111
    invoke-virtual/range {v4 .. v9}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v3

    if-eqz v3, :cond_2

    .line 114
    invoke-interface {v3}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p0

    if-eqz p0, :cond_2

    .line 116
    invoke-interface {v3, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p0

    invoke-interface {v3, p0}, Landroid/database/Cursor;->getInt(I)I

    move-result p0

    .line 118
    invoke-interface {v3, p3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0

    invoke-interface {v3, v0}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    .line 120
    invoke-interface {v3, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {v3, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p4

    .line 121
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {p2, p1, p0}, Landroid/database/MatrixCursor$RowBuilder;->add(Ljava/lang/String;Ljava/lang/Object;)Landroid/database/MatrixCursor$RowBuilder;

    .line 122
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {p2, p3, p0}, Landroid/database/MatrixCursor$RowBuilder;->add(Ljava/lang/String;Ljava/lang/Object;)Landroid/database/MatrixCursor$RowBuilder;

    goto :goto_1

    :cond_1
    const-string p0, "FileSystemProvider"

    const-string p1, "VisibleFile is null"

    .line 127
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_2
    :goto_1
    if-eqz v3, :cond_4

    goto :goto_2

    :catchall_0
    move-exception p0

    if-eqz v3, :cond_3

    .line 134
    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    .line 136
    :cond_3
    throw p0

    :catch_0
    if-eqz v3, :cond_4

    .line 134
    :goto_2
    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    :cond_4
    move-object p1, p5

    .line 139
    :cond_5
    invoke-virtual {p2, v1, p4}, Landroid/database/MatrixCursor$RowBuilder;->add(Ljava/lang/String;Ljava/lang/Object;)Landroid/database/MatrixCursor$RowBuilder;

    .line 140
    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    const-string p1, "_data"

    invoke-virtual {p2, p1, p0}, Landroid/database/MatrixCursor$RowBuilder;->add(Ljava/lang/String;Ljava/lang/Object;)Landroid/database/MatrixCursor$RowBuilder;

    return-void
.end method
