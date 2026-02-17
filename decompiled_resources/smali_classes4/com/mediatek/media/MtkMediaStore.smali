.class public final Lcom/mediatek/media/MtkMediaStore;
.super Ljava/lang/Object;
.source "MtkMediaStore.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/media/MtkMediaStore$ImageColumns;,
        Lcom/mediatek/media/MtkMediaStore$VideoColumns;,
        Lcom/mediatek/media/MtkMediaStore$FileColumns;,
        Lcom/mediatek/media/MtkMediaStore$MediaColumns;
    }
.end annotation


# static fields
.field private static final CONTENT_AUTHORITY_SLASH:Ljava/lang/String; = "content://media/"

.field public static final MTP_TRANSFER_FILE_PATH:Ljava/lang/String; = "mtp_transfer_file_path"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getMtpTransferFileUri()Landroid/net/Uri;
    .locals 1

    const-string v0, "content://media/none/mtp_transfer_file"

    .line 130
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    return-object v0
.end method
