.class Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;
.super Landroid/os/AsyncTask;
.source "InterPhoneLocalFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->copyAndCropPhoto(Landroid/net/Uri;)V
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
        "Ljava/lang/Void;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

.field final synthetic val$pictureUri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;Landroid/net/Uri;)V
    .locals 0

    .line 249
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    iput-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->val$pictureUri:Landroid/net/Uri;

    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    return-void
.end method


# virtual methods
.method protected bridge synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 249
    check-cast p1, [Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->doInBackground([Ljava/lang/Void;)Ljava/lang/Void;

    move-result-object p0

    return-object p0
.end method

.method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Void;
    .locals 1

    .line 252
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-virtual {p1}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    .line 253
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->val$pictureUri:Landroid/net/Uri;

    invoke-virtual {p1, v0}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 254
    :try_start_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->-$$Nest$fgetmTakePictureUri(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)Landroid/net/Uri;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;)Ljava/io/OutputStream;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 255
    :try_start_2
    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->streamsCopy(Ljava/io/InputStream;Ljava/io/OutputStream;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz p0, :cond_0

    .line 256
    :try_start_3
    invoke-virtual {p0}, Ljava/io/OutputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    :cond_0
    if-eqz v0, :cond_3

    :try_start_4
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0

    goto :goto_2

    :catchall_0
    move-exception p1

    if-eqz p0, :cond_1

    .line 253
    :try_start_5
    invoke-virtual {p0}, Ljava/io/OutputStream;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception p0

    :try_start_6
    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_1
    :goto_0
    throw p1
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    :catchall_2
    move-exception p0

    if-eqz v0, :cond_2

    :try_start_7
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_3

    goto :goto_1

    :catchall_3
    move-exception p1

    :try_start_8
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_2
    :goto_1
    throw p0
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_0

    :catch_0
    move-exception p0

    const-string p1, "InterPhoneLocalFragment"

    const-string v0, "Failed to copy photo"

    .line 257
    invoke-static {p1, v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_3
    :goto_2
    const/4 p0, 0x0

    return-object p0
.end method

.method protected bridge synthetic onPostExecute(Ljava/lang/Object;)V
    .locals 0

    .line 249
    check-cast p1, Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->onPostExecute(Ljava/lang/Void;)V

    return-void
.end method

.method protected onPostExecute(Ljava/lang/Void;)V
    .locals 0

    .line 264
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-virtual {p1}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result p1

    if-nez p1, :cond_0

    return-void

    .line 265
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->-$$Nest$mcropPhoto(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)V

    return-void
.end method
