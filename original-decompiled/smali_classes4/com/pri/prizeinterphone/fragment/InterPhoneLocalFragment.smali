.class public Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;
.super Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.source "InterPhoneLocalFragment.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation build Landroid/annotation/SuppressLint;
    value = {
        "StaticFieldLeak"
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "InterPhoneLocalFragment"


# instance fields
.field private cropPhotoSize:I

.field private mCameraDialog:Landroid/app/Dialog;

.field private mCropPictureUri:Landroid/net/Uri;

.field private mExitApptDialog:Landroid/app/Dialog;

.field private mFactoryResetDialog:Landroid/app/Dialog;

.field private mLocalCamera:Landroid/widget/Button;

.field private mLocalDeviceArea:Landroid/view/View;

.field private mLocalExitApp:Landroid/view/View;

.field private mLocalFactoryTest:Landroid/view/View;

.field private mLocalImg:Landroid/widget/ImageView;

.field private mLocalImgShow:Landroid/widget/ImageView;

.field private mLocalInformation:Landroid/view/View;

.field private mLocalSetting:Landroid/view/View;

.field private mLocalTestBitErrorRate:Landroid/view/View;

.field private mLocalUseAssistant:Landroid/view/View;

.field private mLocalView:Landroid/view/View;

.field private mTakePictureUri:Landroid/net/Uri;

.field private mToast:Landroid/widget/Toast;

.field private updateAreaText:Ljava/lang/Runnable;


# direct methods
.method static bridge synthetic -$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTakePictureUri(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)Landroid/net/Uri;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mcropPhoto(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhoto()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLocalImg(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;Landroid/graphics/Bitmap;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateLocalImg(Landroid/graphics/Bitmap;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 73
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    const/16 v0, 0x2d0

    .line 215
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhotoSize:I

    .line 516
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateAreaText:Ljava/lang/Runnable;

    return-void
.end method

.method private appendCropExtras(Landroid/content/Intent;)V
    .locals 2

    const-string v0, "crop"

    const-string/jumbo v1, "true"

    .line 345
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "scale"

    const/4 v1, 0x1

    .line 346
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string v0, "scaleUpIfNeeded"

    .line 347
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string v0, "aspectX"

    .line 348
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v0, "aspectY"

    .line 349
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 350
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhotoSize:I

    const-string v1, "outputX"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 351
    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhotoSize:I

    const-string v0, "outputY"

    invoke-virtual {p1, v0, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    return-void
.end method

.method private appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V
    .locals 1

    const-string p0, "output"

    .line 355
    invoke-virtual {p1, p0, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    const/4 v0, 0x3

    .line 356
    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 358
    invoke-static {p0, p2}, Landroid/content/ClipData;->newRawUri(Ljava/lang/CharSequence;Landroid/net/Uri;)Landroid/content/ClipData;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    return-void
.end method

.method private choosePhoto()V
    .locals 3

    .line 226
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "TakeEditUserPhoto2.jpg"

    const/4 v2, 0x0

    invoke-direct {p0, v0, v1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    .line 227
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.GET_CONTENT"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const-string v1, "image/*"

    .line 228
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 229
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    .line 230
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private copyAndCropPhoto(Landroid/net/Uri;)V
    .locals 1

    .line 249
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;

    invoke-direct {v0, p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;Landroid/net/Uri;)V

    const/4 p0, 0x0

    new-array p0, p0, [Ljava/lang/Void;

    .line 267
    invoke-virtual {v0, p0}, Landroid/os/AsyncTask;->execute([Ljava/lang/Object;)Landroid/os/AsyncTask;

    return-void
.end method

.method private createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;
    .locals 1

    .line 362
    invoke-virtual {p1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object p0

    .line 363
    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    .line 364
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0, p2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    if-eqz p3, :cond_0

    .line 366
    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    :cond_0
    const-string p0, "com.pri.prizeinterphone.files"

    .line 368
    invoke-static {p1, p0, v0}, Landroidx/core/content/FileProvider;->getUriForFile(Landroid/content/Context;Ljava/lang/String;Ljava/io/File;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private cropPhoto()V
    .locals 3

    .line 234
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "CropEditUserPhoto.jpg"

    const/4 v2, 0x0

    invoke-direct {p0, v0, v1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCropPictureUri:Landroid/net/Uri;

    .line 235
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.android.camera.action.CROP"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 236
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    const-string v2, "image/*"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    .line 237
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCropPictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    .line 238
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->appendCropExtras(Landroid/content/Intent;)V

    .line 239
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->resolveActivity(Landroid/content/pm/PackageManager;)Landroid/content/ComponentName;

    .line 241
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const/16 v1, 0x3eb

    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private getDefauteBitmap()Landroid/graphics/Bitmap;
    .locals 5

    .line 508
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const v0, 0x7f080092

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 509
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v0

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v1

    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v0, v1, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 510
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 511
    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v2

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v3

    const/4 v4, 0x0

    invoke-virtual {p0, v4, v4, v2, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 512
    invoke-virtual {p0, v1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    return-object v0
.end method

.method private initData()V
    .locals 3

    .line 112
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->getDefauteBitmap()Landroid/graphics/Bitmap;

    move-result-object v1

    const-string v2, "pref_person_icon"

    invoke-static {v0, v2, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getImgData(Landroid/content/Context;Ljava/lang/String;Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 113
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateLocalImg(Landroid/graphics/Bitmap;)V

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    .line 558
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "pref_person_send_status"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    move v2, v1

    :cond_0
    if-eqz v2, :cond_1

    const v0, 0x7f11011c

    .line 560
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showToast(I)V

    :cond_1
    return v2
.end method

.method private localFactoryReset()V
    .locals 4

    const v0, 0x7f11006e

    .line 497
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->showProgressDialog(Ljava/lang/String;)V

    .line 499
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->resetData(Z)V

    .line 500
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->getDefauteBitmap()Landroid/graphics/Bitmap;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateLocalImg(Landroid/graphics/Bitmap;)V

    .line 503
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    const-wide/16 v2, 0x3e8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 504
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateAreaText:Ljava/lang/Runnable;

    invoke-virtual {v0, p0, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method private localmExitApp()V
    .locals 4

    .line 539
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->releaseYModem()V

    .line 540
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPwdFoot()V

    .line 541
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->releaseSerialPort()V

    .line 542
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    new-instance v1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v2

    const-class v3, Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {v1, v2, v3}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->stopService(Landroid/content/Intent;)Z

    .line 543
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->finishAffinity()V

    .line 544
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    const/4 p0, 0x0

    .line 545
    invoke-static {p0}, Ljava/lang/System;->exit(I)V

    return-void
.end method

.method private onPhotoCropped(Landroid/net/Uri;Z)V
    .locals 1

    .line 282
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$2;

    invoke-direct {v0, p0, p2, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;ZLandroid/net/Uri;)V

    sget-object p0, Landroid/os/AsyncTask;->THREAD_POOL_EXECUTOR:Ljava/util/concurrent/Executor;

    const/4 p1, 0x0

    .line 341
    invoke-virtual {v0, p0, p1}, Landroid/os/AsyncTask;->executeOnExecutor(Ljava/util/concurrent/Executor;[Ljava/lang/Object;)Landroid/os/AsyncTask;

    return-void
.end method

.method private setWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 181
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 182
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 183
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 184
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 185
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 186
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 187
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 188
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 189
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showCameraDialog()V
    .locals 3

    .line 147
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c004f

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 148
    new-instance v1, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    .line 149
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 150
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->setWindowLayoutParams(Landroid/app/Dialog;)V

    .line 151
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f090104

    .line 152
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 153
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090103

    .line 154
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 155
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private showLocalExitAppDialog()V
    .locals 3

    .line 526
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0042

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 527
    new-instance v1, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    .line 528
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 529
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->setWindowLayoutParams(Landroid/app/Dialog;)V

    .line 530
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f0900d6

    .line 532
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 533
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f0900d7

    .line 534
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 535
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private showLocalFactoryResetDialog()V
    .locals 3

    .line 483
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0043

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 484
    new-instance v1, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    .line 485
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 486
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->setWindowLayoutParams(Landroid/app/Dialog;)V

    .line 487
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f0900d8

    .line 489
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 490
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f0900d9

    .line 491
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 492
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private showToast(I)V
    .locals 2

    .line 550
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 551
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    .line 553
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mToast:Landroid/widget/Toast;

    .line 554
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method public static streamsCopy(Ljava/io/InputStream;Ljava/io/OutputStream;)I
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v0, 0x2000

    new-array v0, v0, [B

    const/4 v1, 0x0

    move v2, v1

    .line 274
    :goto_0
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v3

    const/4 v4, -0x1

    if-eq v3, v4, :cond_0

    add-int/2addr v2, v3

    .line 276
    invoke-virtual {p1, v0, v1, v3}, Ljava/io/OutputStream;->write([BII)V

    goto :goto_0

    :cond_0
    return v2
.end method

.method private takePhoto()V
    .locals 3

    .line 218
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "TakeEditUserPhoto2.jpg"

    const/4 v2, 0x0

    invoke-direct {p0, v0, v1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    .line 219
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.media.action.IMAGE_CAPTURE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 220
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    const/4 v1, 0x3

    .line 221
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 222
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const/16 v1, 0x3ea

    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private updateLanguageArea()V
    .locals 2

    .line 208
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f09017a

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 209
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 210
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private updateLocalImg(Landroid/graphics/Bitmap;)V
    .locals 2

    if-eqz p1, :cond_0

    .line 373
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0, p1}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object v0

    .line 374
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalImg:Landroid/widget/ImageView;

    invoke-virtual {v1, v0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 375
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const-string v0, "pref_person_icon"

    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putImgData(Landroid/content/Context;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    :cond_0
    return-void
.end method


# virtual methods
.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "InterPhoneLocalFragment"

    return-object p0
.end method

.method public initView(Landroid/view/View;)V
    .locals 2

    .line 78
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 79
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c0049

    const/4 v1, 0x0

    .line 80
    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    .line 81
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 82
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900d4

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalCamera:Landroid/widget/Button;

    .line 83
    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 84
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900da

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalImg:Landroid/widget/ImageView;

    .line 85
    sget-object v0, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 86
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900db

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalImgShow:Landroid/widget/ImageView;

    .line 88
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f090191

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalSetting:Landroid/view/View;

    .line 89
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 90
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f090185

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalInformation:Landroid/view/View;

    .line 91
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 92
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f09016e

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalDeviceArea:Landroid/view/View;

    .line 93
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 94
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f090182

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalFactoryTest:Landroid/view/View;

    .line 95
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 96
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0901a6

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalUseAssistant:Landroid/view/View;

    .line 97
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 98
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f090180

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalExitApp:Landroid/view/View;

    .line 99
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 101
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0901a3

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalTestBitErrorRate:Landroid/view/View;

    .line 102
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 104
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const v0, 0x7f0700df

    .line 105
    invoke-virtual {p1, v0}, Landroid/content/res/Resources;->getDimension(I)F

    move-result p1

    float-to-int p1, p1

    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhotoSize:I

    .line 107
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->initData()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 382
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    sparse-switch p1, :sswitch_data_0

    goto/16 :goto_0

    .line 450
    :sswitch_0
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/pri/prizeinterphone/activity/FragmentLocalUseAssistantActivity;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 451
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    .line 460
    :sswitch_1
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 461
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    .line 408
    :sswitch_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 411
    :cond_0
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 412
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    .line 415
    :sswitch_3
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 416
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    .line 430
    :sswitch_4
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_1

    return-void

    .line 433
    :cond_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showLocalFactoryResetDialog()V

    goto/16 :goto_0

    .line 454
    :sswitch_5
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_2

    return-void

    .line 457
    :cond_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showLocalExitAppDialog()V

    goto/16 :goto_0

    .line 419
    :sswitch_6
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_3

    return-void

    .line 422
    :cond_3
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_4

    const-string p0, "InterPhoneLocalFragment"

    const-string p1, "monkey is running, not let go come into FragmentLocalDeviceAreaActivity"

    .line 423
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 426
    :cond_4
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 427
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto :goto_0

    .line 390
    :sswitch_7
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_5

    return-void

    .line 393
    :cond_5
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_6

    .line 394
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 396
    :cond_6
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->takePhoto()V

    goto :goto_0

    .line 399
    :sswitch_8
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_7

    return-void

    .line 402
    :cond_7
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_8

    .line 403
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 405
    :cond_8
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->choosePhoto()V

    goto :goto_0

    .line 441
    :sswitch_9
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_9

    return-void

    .line 444
    :cond_9
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_a

    .line 445
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 447
    :cond_a
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->localFactoryReset()V

    goto :goto_0

    .line 436
    :sswitch_a
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 437
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    goto :goto_0

    .line 469
    :sswitch_b
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_b

    return-void

    .line 472
    :cond_b
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_c

    .line 473
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 475
    :cond_c
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->localmExitApp()V

    goto :goto_0

    .line 464
    :sswitch_c
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 465
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    goto :goto_0

    .line 384
    :sswitch_d
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_d

    return-void

    .line 387
    :cond_d
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showCameraDialog()V

    :cond_e
    :goto_0
    return-void

    :sswitch_data_0
    .sparse-switch
        0x7f0900d4 -> :sswitch_d
        0x7f0900d6 -> :sswitch_c
        0x7f0900d7 -> :sswitch_b
        0x7f0900d8 -> :sswitch_a
        0x7f0900d9 -> :sswitch_9
        0x7f090103 -> :sswitch_8
        0x7f090104 -> :sswitch_7
        0x7f09016e -> :sswitch_6
        0x7f090180 -> :sswitch_5
        0x7f090182 -> :sswitch_4
        0x7f090185 -> :sswitch_3
        0x7f090191 -> :sswitch_2
        0x7f0901a3 -> :sswitch_1
        0x7f0901a6 -> :sswitch_0
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 161
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    const-string p1, "InterPhoneLocalFragment"

    const-string v0, "onConfigurationChanged"

    .line 162
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 163
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 164
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 165
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mCameraDialog:Landroid/app/Dialog;

    .line 166
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showCameraDialog()V

    .line 168
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 169
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 170
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    .line 171
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showLocalFactoryResetDialog()V

    .line 173
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_2

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 174
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mFactoryResetDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 175
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mExitApptDialog:Landroid/app/Dialog;

    .line 176
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->showLocalExitAppDialog()V

    :cond_2
    return-void
.end method

.method public onPrizeActivityResult(IILandroid/content/Intent;)V
    .locals 2

    if-eqz p3, :cond_0

    .line 117
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p2

    if-eqz p2, :cond_0

    .line 118
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p2

    goto :goto_0

    :cond_0
    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    :goto_0
    const-string p3, "InterPhoneLocalFragment"

    if-nez p2, :cond_1

    const-string p0, "Invalid pictureUri null"

    .line 120
    invoke-static {p3, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 123
    :cond_1
    invoke-virtual {p2}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object v0

    const-string v1, "content"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 124
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Invalid pictureUri scheme: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p3, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_2
    packed-switch p1, :pswitch_data_0

    goto :goto_1

    :pswitch_0
    const/4 p1, 0x1

    .line 138
    invoke-direct {p0, p2, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->onPhotoCropped(Landroid/net/Uri;Z)V

    goto :goto_1

    .line 131
    :pswitch_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mTakePictureUri:Landroid/net/Uri;

    invoke-virtual {p1, p2}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 132
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->cropPhoto()V

    goto :goto_1

    .line 134
    :cond_3
    invoke-direct {p0, p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->copyAndCropPhoto(Landroid/net/Uri;)V

    :goto_1
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x3e9
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onResume()V
    .locals 2

    .line 194
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    .line 195
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x7f110097

    .line 196
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    .line 198
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f090192

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f110073

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 199
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f09018c

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f11006f

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 200
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f09017b

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f110051

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 201
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->updateLanguageArea()V

    .line 202
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f090183

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f11006b

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 203
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f0901a7

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f110088

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 204
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->mLocalView:Landroid/view/View;

    const v1, 0x7f090181

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f110068

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
