.class Lcom/mediatek/storage/StorageDefaultPathDialog$1;
.super Landroid/content/BroadcastReceiver;
.source "StorageDefaultPathDialog.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/storage/StorageDefaultPathDialog;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/storage/StorageDefaultPathDialog;


# direct methods
.method constructor <init>(Lcom/mediatek/storage/StorageDefaultPathDialog;)V
    .locals 0

    .line 83
    iput-object p1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog$1;->this$0:Lcom/mediatek/storage/StorageDefaultPathDialog;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    .line 86
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string p2, "android.intent.action.MEDIA_BAD_REMOVAL"

    .line 87
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 88
    iget-object p0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog$1;->this$0:Lcom/mediatek/storage/StorageDefaultPathDialog;

    invoke-virtual {p0}, Lcom/android/internal/app/AlertActivity;->finish()V

    :cond_0
    return-void
.end method
