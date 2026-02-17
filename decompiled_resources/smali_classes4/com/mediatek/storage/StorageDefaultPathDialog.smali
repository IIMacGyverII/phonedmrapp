.class public Lcom/mediatek/storage/StorageDefaultPathDialog;
.super Lcom/android/internal/app/AlertActivity;
.source "StorageDefaultPathDialog.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# static fields
.field private static final INSERT_OTG:Ljava/lang/String; = "insert_otg"

.field private static final SD_ACTION:Ljava/lang/String; = "android.intent.action.MEDIA_BAD_REMOVAL"

.field private static final TAG:Ljava/lang/String; = "StorageDefaultPathDialog"


# instance fields
.field private mInsertOtg:Ljava/lang/Boolean;

.field private mReceiver:Landroid/content/BroadcastReceiver;

.field private mSDCardStateFilter:Landroid/content/IntentFilter;

.field private final mSDStateReceiver:Landroid/content/BroadcastReceiver;

.field path:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 73
    invoke-direct {p0}, Lcom/android/internal/app/AlertActivity;-><init>()V

    const/4 v0, 0x0

    .line 78
    iput-object v0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->path:Ljava/lang/String;

    .line 81
    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    iput-object v0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mInsertOtg:Ljava/lang/Boolean;

    .line 83
    new-instance v0, Lcom/mediatek/storage/StorageDefaultPathDialog$1;

    invoke-direct {v0, p0}, Lcom/mediatek/storage/StorageDefaultPathDialog$1;-><init>(Lcom/mediatek/storage/StorageDefaultPathDialog;)V

    iput-object v0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mSDStateReceiver:Landroid/content/BroadcastReceiver;

    return-void
.end method

.method private createDialog()V
    .locals 2

    .line 104
    iget-object v0, p0, Lcom/android/internal/app/AlertActivity;->mAlertParams:Lcom/android/internal/app/AlertController$AlertParams;

    .line 105
    iget-object v1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mInsertOtg:Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    if-eqz v1, :cond_0

    const v1, 0x8050083

    invoke-virtual {p0, v1}, Lcom/android/internal/app/AlertActivity;->getString(I)Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const v1, 0x8050077

    .line 106
    invoke-virtual {p0, v1}, Lcom/android/internal/app/AlertActivity;->getString(I)Ljava/lang/String;

    move-result-object v1

    :goto_0
    iput-object v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mTitle:Ljava/lang/CharSequence;

    .line 107
    invoke-direct {p0}, Lcom/mediatek/storage/StorageDefaultPathDialog;->createView()Landroid/view/View;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mView:Landroid/view/View;

    const/4 v1, 0x1

    .line 108
    iput-boolean v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mViewSpacingSpecified:Z

    const/16 v1, 0xf

    .line 109
    iput v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mViewSpacingLeft:I

    .line 110
    iput v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mViewSpacingRight:I

    const/4 v1, 0x5

    .line 111
    iput v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mViewSpacingTop:I

    .line 112
    iput v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mViewSpacingBottom:I

    const v1, 0x1040013

    .line 113
    invoke-virtual {p0, v1}, Lcom/android/internal/app/AlertActivity;->getString(I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mPositiveButtonText:Ljava/lang/CharSequence;

    .line 114
    iput-object p0, v0, Lcom/android/internal/app/AlertController$AlertParams;->mPositiveButtonListener:Landroid/content/DialogInterface$OnClickListener;

    const v1, 0x1040009

    .line 115
    invoke-virtual {p0, v1}, Lcom/android/internal/app/AlertActivity;->getString(I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/app/AlertController$AlertParams;->mNegativeButtonText:Ljava/lang/CharSequence;

    .line 116
    iput-object p0, v0, Lcom/android/internal/app/AlertController$AlertParams;->mNegativeButtonListener:Landroid/content/DialogInterface$OnClickListener;

    .line 117
    invoke-virtual {p0}, Lcom/android/internal/app/AlertActivity;->setupAlert()V

    return-void
.end method

.method private createView()Landroid/view/View;
    .locals 2

    .line 121
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 122
    invoke-virtual {v0}, Landroid/widget/TextView;->getContext()Landroid/content/Context;

    move-result-object p0

    const v1, 0x1030044

    invoke-virtual {v0, p0, v1}, Landroid/widget/TextView;->setTextAppearance(Landroid/content/Context;I)V

    const p0, 0x8050078

    .line 123
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(I)V

    return-object v0
.end method

.method private onCancel()V
    .locals 0

    .line 161
    invoke-virtual {p0}, Lcom/android/internal/app/AlertActivity;->finish()V

    return-void
.end method

.method private onOK()V
    .locals 3

    .line 149
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "android.settings.INTERNAL_STORAGE_SETTINGS"

    .line 150
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v1, 0x54000000

    .line 151
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setFlags(I)Landroid/content/Intent;

    const-string v1, "StorageDefaultPathDialog"

    const-string v2, "onOK() start activity"

    .line 152
    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 153
    invoke-virtual {p0, v0}, Lcom/android/internal/app/AlertActivity;->startActivity(Landroid/content/Intent;)V

    .line 154
    invoke-virtual {p0}, Lcom/android/internal/app/AlertActivity;->finish()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    const/4 p1, -0x2

    if-eq p2, p1, :cond_1

    const/4 p1, -0x1

    if-eq p2, p1, :cond_0

    goto :goto_0

    .line 167
    :cond_0
    invoke-direct {p0}, Lcom/mediatek/storage/StorageDefaultPathDialog;->onOK()V

    goto :goto_0

    .line 170
    :cond_1
    invoke-direct {p0}, Lcom/mediatek/storage/StorageDefaultPathDialog;->onCancel()V

    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 94
    invoke-super {p0, p1}, Lcom/android/internal/app/AlertActivity;->onCreate(Landroid/os/Bundle;)V

    const-string p1, "StorageDefaultPathDialog"

    const-string v0, "StorageDefaultPathDialog onCreate()"

    .line 95
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 96
    new-instance p1, Landroid/content/IntentFilter;

    const-string v0, "android.intent.action.MEDIA_BAD_REMOVAL"

    invoke-direct {p1, v0}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    iput-object p1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mSDCardStateFilter:Landroid/content/IntentFilter;

    const-string v0, "file"

    .line 97
    invoke-virtual {p1, v0}, Landroid/content/IntentFilter;->addDataScheme(Ljava/lang/String;)V

    .line 98
    iget-object p1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mSDStateReceiver:Landroid/content/BroadcastReceiver;

    iput-object p1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mReceiver:Landroid/content/BroadcastReceiver;

    .line 99
    invoke-virtual {p0}, Lcom/android/internal/app/AlertActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    const-string v0, "insert_otg"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p1

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    iput-object p1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mInsertOtg:Ljava/lang/Boolean;

    .line 100
    invoke-direct {p0}, Lcom/mediatek/storage/StorageDefaultPathDialog;->createDialog()V

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    const-string v0, "StorageDefaultPathDialog"

    const-string v1, "onDestroy()"

    .line 135
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 136
    invoke-super {p0}, Lcom/android/internal/app/AlertActivity;->onDestroy()V

    return-void
.end method

.method protected onPause()V
    .locals 2

    .line 141
    invoke-super {p0}, Lcom/android/internal/app/AlertActivity;->onPause()V

    const-string v0, "StorageDefaultPathDialog"

    const-string v1, "onPause entry"

    .line 143
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 144
    iget-object v0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v0}, Lcom/android/internal/app/AlertActivity;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    return-void
.end method

.method protected onResume()V
    .locals 2

    .line 129
    invoke-super {p0}, Lcom/android/internal/app/AlertActivity;->onResume()V

    .line 131
    iget-object v0, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mReceiver:Landroid/content/BroadcastReceiver;

    iget-object v1, p0, Lcom/mediatek/storage/StorageDefaultPathDialog;->mSDCardStateFilter:Landroid/content/IntentFilter;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/app/AlertActivity;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    return-void
.end method
