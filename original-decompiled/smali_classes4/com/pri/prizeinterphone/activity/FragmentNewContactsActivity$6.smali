.class Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;
.super Landroid/os/AsyncTask;
.source "FragmentNewContactsActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->onPhotoCropped(Landroid/net/Uri;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/os/AsyncTask<",
        "Ljava/lang/Void;",
        "Ljava/lang/Void;",
        "Landroid/graphics/Bitmap;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

.field final synthetic val$cropped:Z

.field final synthetic val$data:Landroid/net/Uri;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;ZLandroid/net/Uri;)V
    .locals 0

    .line 567
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    iput-boolean p2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->val$cropped:Z

    iput-object p3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->val$data:Landroid/net/Uri;

    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    return-void
.end method


# virtual methods
.method protected varargs doInBackground([Ljava/lang/Void;)Landroid/graphics/Bitmap;
    .locals 8

    const-string p1, "Cannot close image stream"

    .line 570
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->val$cropped:Z

    const-string v1, "Cannot find image file"

    const-string v2, "FragmentNewContactsActivity"

    const/4 v3, 0x0

    if-eqz v0, :cond_4

    .line 573
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->val$data:Landroid/net/Uri;

    .line 574
    invoke-virtual {v0, p0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object p0
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p0, :cond_0

    .line 575
    :try_start_1
    invoke-static {p0}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object v3
    :try_end_1
    .catch Ljava/io/FileNotFoundException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_0

    :catch_0
    move-exception v0

    goto :goto_2

    :cond_0
    :goto_0
    if-eqz p0, :cond_1

    .line 582
    :try_start_2
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_1

    :catch_1
    move-exception p0

    .line 584
    invoke-static {v2, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_1
    return-object v3

    :catchall_0
    move-exception v0

    goto :goto_4

    :catch_2
    move-exception v0

    move-object p0, v3

    .line 577
    :goto_2
    :try_start_3
    invoke-static {v2, v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz p0, :cond_2

    .line 582
    :try_start_4
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_3

    goto :goto_3

    :catch_3
    move-exception p0

    .line 584
    invoke-static {v2, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_2
    :goto_3
    return-object v3

    :catchall_1
    move-exception v0

    move-object v3, p0

    :goto_4
    if-eqz v3, :cond_3

    .line 582
    :try_start_5
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    goto :goto_5

    :catch_4
    move-exception p0

    .line 584
    invoke-static {v2, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 587
    :cond_3
    :goto_5
    throw v0

    .line 592
    :cond_4
    :try_start_6
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->val$data:Landroid/net/Uri;

    .line 593
    invoke-virtual {p1, p0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object p0

    if-eqz p0, :cond_5

    .line 594
    invoke-static {p0}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;

    move-result-object p0
    :try_end_6
    .catch Ljava/io/FileNotFoundException; {:try_start_6 .. :try_end_6} :catch_5

    goto :goto_6

    :cond_5
    move-object p0, v3

    :goto_6
    if-eqz p0, :cond_6

    .line 601
    sget-object p1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/16 v0, 0x280

    const/16 v1, 0x1e0

    invoke-static {v0, v1, p1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object p1

    .line 603
    new-instance v2, Landroid/graphics/Canvas;

    invoke-direct {v2, p1}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 604
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    .line 605
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v4

    .line 604
    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    .line 606
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    sub-int/2addr v4, v3

    div-int/lit8 v4, v4, 0x2

    .line 607
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v5

    sub-int/2addr v5, v3

    div-int/lit8 v5, v5, 0x2

    .line 608
    new-instance v6, Landroid/graphics/Rect;

    add-int v7, v4, v3

    add-int/2addr v3, v5

    invoke-direct {v6, v4, v5, v7, v3}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 610
    new-instance v3, Landroid/graphics/Rect;

    const/4 v4, 0x0

    invoke-direct {v3, v4, v4, v0, v1}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 611
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0}, Landroid/graphics/Paint;-><init>()V

    .line 612
    invoke-virtual {v2, p0, v6, v3, v0}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Rect;Landroid/graphics/Paint;)V

    return-object p1

    :cond_6
    return-object v3

    :catch_5
    move-exception p0

    .line 597
    invoke-static {v2, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v3
.end method

.method protected bridge synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 567
    check-cast p1, [Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->doInBackground([Ljava/lang/Void;)Landroid/graphics/Bitmap;

    move-result-object p0

    return-object p0
.end method

.method protected onPostExecute(Landroid/graphics/Bitmap;)V
    .locals 2

    .line 622
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-static {v0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->-$$Nest$mupdateLocalImg(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;Landroid/graphics/Bitmap;)V

    .line 623
    new-instance p1, Ljava/io/File;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object v0

    const-string v1, "TakeEditUserPhoto2.jpg"

    invoke-direct {p1, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/io/File;->delete()Z

    .line 624
    new-instance p1, Ljava/io/File;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object p0

    const-string v0, "CropEditUserPhoto.jpg"

    invoke-direct {p1, p0, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/io/File;->delete()Z

    return-void
.end method

.method protected bridge synthetic onPostExecute(Ljava/lang/Object;)V
    .locals 0

    .line 567
    check-cast p1, Landroid/graphics/Bitmap;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;->onPostExecute(Landroid/graphics/Bitmap;)V

    return-void
.end method
