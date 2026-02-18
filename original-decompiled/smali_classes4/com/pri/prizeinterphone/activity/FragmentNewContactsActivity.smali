.class public Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentNewContactsActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# static fields
.field private static final GROUP_NAME_INDEX:I = 0x2

.field private static final GROUP_NUMBER_INDEX:I = 0x3

.field private static final LIN_RES_ID:[I

.field private static final PEOPLE_NAME_INDEX:I = 0x0

.field private static final PEOPLE_NUMBER_INDEX:I = 0x1

.field private static final TAG:Ljava/lang/String; = "FragmentNewContactsActivity"


# instance fields
.field private cropPhotoSize:I

.field private isHasPicture:Z

.field private isModifyData:Z

.field private isModifyImg:Z

.field private mCameraDialog:Landroid/app/Dialog;

.field private mCropPictureUri:Landroid/net/Uri;

.field private mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

.field private mCurrentSelect:I

.field private mCurrentType:I

.field private mDialog:Landroid/app/Dialog;

.field private mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

.field private mEditGroupName:Landroid/widget/EditText;

.field private mEditGroupNumber:Landroid/widget/EditText;

.field private mEditPeopleName:Landroid/widget/EditText;

.field private mEditPeopleNumber:Landroid/widget/EditText;

.field private mImgPhoto:Landroid/widget/ImageView;

.field private mRelGroupName:Landroid/view/View;

.field private mRelGroupNumber:Landroid/view/View;

.field private mRelPeopleName:Landroid/view/View;

.field private mRelPeopleNumber:Landroid/view/View;

.field private mTakePictureUri:Landroid/net/Uri;

.field private mToast:Landroid/widget/Toast;

.field private mTvTitle:Landroid/widget/TextView;


# direct methods
.method static bridge synthetic -$$Nest$fgetmTakePictureUri(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)Landroid/net/Uri;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mcropPhoto(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->cropPhoto()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLocalImg(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;Landroid/graphics/Bitmap;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->updateLocalImg(Landroid/graphics/Bitmap;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x4

    new-array v0, v0, [I

    .line 58
    fill-array-data v0, :array_0

    sput-object v0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->LIN_RES_ID:[I

    return-void

    nop

    :array_0
    .array-data 4
        0x7f090151
        0x7f090153
        0x7f09013e
        0x7f090140
    .end array-data
.end method

.method public constructor <init>()V
    .locals 1

    .line 52
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    const/4 v0, 0x0

    .line 75
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    .line 76
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyImg:Z

    const/16 v0, 0x2d0

    .line 482
    iput v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->cropPhotoSize:I

    return-void
.end method

.method private appendCropExtras(Landroid/content/Intent;)V
    .locals 2

    const-string v0, "crop"

    const-string/jumbo v1, "true"

    .line 630
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v0, "scale"

    const/4 v1, 0x1

    .line 631
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string v0, "scaleUpIfNeeded"

    .line 632
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string v0, "aspectX"

    .line 633
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v0, "aspectY"

    .line 634
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 635
    iget v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->cropPhotoSize:I

    const-string v1, "outputX"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 636
    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->cropPhotoSize:I

    const-string v0, "outputY"

    invoke-virtual {p1, v0, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    return-void
.end method

.method private appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V
    .locals 1

    const-string p0, "output"

    .line 640
    invoke-virtual {p1, p0, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    const/4 v0, 0x3

    .line 641
    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 643
    invoke-static {p0, p2}, Landroid/content/ClipData;->newRawUri(Ljava/lang/CharSequence;Landroid/net/Uri;)Landroid/content/ClipData;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/content/Intent;->setClipData(Landroid/content/ClipData;)V

    return-void
.end method

.method private choosePhoto()V
    .locals 3

    .line 495
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    const-string v1, "TakeEditUserPhoto2.jpg"

    .line 498
    invoke-direct {p0, p0, v1, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    .line 499
    new-instance v0, Landroid/content/Intent;

    const/4 v1, 0x0

    const-string v2, "android.intent.action.GET_CONTENT"

    invoke-direct {v0, v2, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const-string v1, "image/*"

    .line 500
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 501
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    const/16 v1, 0x3e9

    .line 502
    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private copyAndCropPhoto(Landroid/net/Uri;)V
    .locals 1

    .line 528
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 531
    :cond_0
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$5;

    invoke-direct {v0, p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$5;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;Landroid/net/Uri;)V

    const/4 p0, 0x0

    new-array p0, p0, [Ljava/lang/Void;

    .line 549
    invoke-virtual {v0, p0}, Landroid/os/AsyncTask;->execute([Ljava/lang/Object;)Landroid/os/AsyncTask;

    return-void
.end method

.method private createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;
    .locals 1

    .line 647
    invoke-virtual {p1}, Landroid/content/Context;->getCacheDir()Ljava/io/File;

    move-result-object p0

    .line 648
    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    .line 649
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0, p2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    if-eqz p3, :cond_0

    .line 651
    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    :cond_0
    const-string p0, "com.pri.prizeinterphone.files"

    .line 653
    invoke-static {p1, p0, v0}, Landroidx/core/content/FileProvider;->getUriForFile(Landroid/content/Context;Ljava/lang/String;Ljava/io/File;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private cropPhoto()V
    .locals 3

    .line 506
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    const-string v1, "CropEditUserPhoto.jpg"

    .line 509
    invoke-direct {p0, p0, v1, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCropPictureUri:Landroid/net/Uri;

    .line 510
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.android.camera.action.CROP"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 511
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    const-string v2, "image/*"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;

    .line 512
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCropPictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    .line 513
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->appendCropExtras(Landroid/content/Intent;)V

    .line 514
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->resolveActivity(Landroid/content/pm/PackageManager;)Landroid/content/ComponentName;

    const/16 v1, 0x3eb

    .line 516
    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private deltePicture()V
    .locals 0

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 394
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 395
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 396
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private drawableToBitamp(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Bitmap;
    .locals 4

    .line 368
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result p0

    .line 369
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v0

    .line 370
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getOpacity()I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    goto :goto_0

    :cond_0
    sget-object v1, Landroid/graphics/Bitmap$Config;->RGB_565:Landroid/graphics/Bitmap$Config;

    .line 371
    :goto_0
    invoke-static {p0, v0, v1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 372
    new-instance v2, Landroid/graphics/Canvas;

    invoke-direct {v2, v1}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    const/4 v3, 0x0

    .line 373
    invoke-virtual {p1, v3, v3, p0, v0}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 374
    invoke-virtual {p1, v2}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    return-object v1
.end method

.method private initData()V
    .locals 7

    .line 140
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "isedit"

    const/4 v2, 0x0

    .line 141
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v1

    iput-boolean v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    const-string v1, "contact_type"

    .line 142
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v1

    const-string v3, "_id"

    const/4 v4, -0x1

    .line 143
    invoke-virtual {v0, v3, v4}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    .line 144
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "initData: isModifyData "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v5, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v5, "--type="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "--mEditContactDataId="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "FragmentNewContactsActivity"

    invoke-static {v5, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    new-instance v3, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-direct {v3}, Lcom/pri/prizeinterphone/serial/data/ContactData;-><init>()V

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 148
    iput v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    const/16 v3, 0x8

    if-nez v1, :cond_0

    .line 150
    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleName:Landroid/view/View;

    invoke-virtual {v6, v2}, Landroid/view/View;->setVisibility(I)V

    .line 151
    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleNumber:Landroid/view/View;

    invoke-virtual {v6, v2}, Landroid/view/View;->setVisibility(I)V

    .line 152
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupName:Landroid/view/View;

    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    .line 153
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupNumber:Landroid/view/View;

    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 155
    :cond_0
    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleName:Landroid/view/View;

    invoke-virtual {v6, v3}, Landroid/view/View;->setVisibility(I)V

    .line 156
    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleNumber:Landroid/view/View;

    invoke-virtual {v6, v3}, Landroid/view/View;->setVisibility(I)V

    .line 157
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupName:Landroid/view/View;

    invoke-virtual {v3, v2}, Landroid/view/View;->setVisibility(I)V

    .line 158
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupNumber:Landroid/view/View;

    invoke-virtual {v3, v2}, Landroid/view/View;->setVisibility(I)V

    .line 161
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mEditContactDataId = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v5, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eq v0, v4, :cond_1

    .line 163
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v2

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getContact(I)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 165
    :cond_1
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    const v2, 0x7f080092

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    if-eqz v0, :cond_4

    if-nez v1, :cond_2

    .line 167
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 168
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleNumber:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 170
    :cond_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 171
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupNumber:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 173
    :goto_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v0, v0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_3

    .line 174
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object p0

    invoke-virtual {v1, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_2

    .line 176
    :cond_3
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0, v2}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_2

    .line 179
    :cond_4
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0, v2}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :goto_2
    return-void
.end method

.method private initView()V
    .locals 2

    const v0, 0x7f09013d

    .line 88
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTvTitle:Landroid/widget/TextView;

    const v0, 0x7f09013b

    .line 89
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    const v0, 0x7f090152

    .line 90
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    .line 91
    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    const v0, 0x7f090154

    .line 100
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleNumber:Landroid/widget/EditText;

    .line 101
    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    const v0, 0x7f09013f

    .line 110
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    .line 111
    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$3;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    const v0, 0x7f090141

    .line 120
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupNumber:Landroid/widget/EditText;

    .line 121
    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$4;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$4;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    const v0, 0x7f090151

    .line 131
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleName:Landroid/view/View;

    const v0, 0x7f090153

    .line 132
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelPeopleNumber:Landroid/view/View;

    const v0, 0x7f09013e

    .line 133
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupName:Landroid/view/View;

    const v0, 0x7f090140

    .line 134
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mRelGroupNumber:Landroid/view/View;

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 684
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    move v1, v2

    :cond_0
    if-eqz v1, :cond_1

    const v0, 0x7f11011c

    .line 686
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    :cond_1
    return v1
.end method

.method private onPhotoCropped(Landroid/net/Uri;Z)V
    .locals 1

    .line 564
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 567
    :cond_0
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;

    invoke-direct {v0, p0, p2, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$6;-><init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;ZLandroid/net/Uri;)V

    sget-object p0, Landroid/os/AsyncTask;->THREAD_POOL_EXECUTOR:Ljava/util/concurrent/Executor;

    const/4 p1, 0x0

    .line 626
    invoke-virtual {v0, p0, p1}, Landroid/os/AsyncTask;->executeOnExecutor(Ljava/util/concurrent/Executor;[Ljava/lang/Object;)Landroid/os/AsyncTask;

    return-void
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 381
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 382
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 384
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 385
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 386
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 387
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 388
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 389
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 390
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private setWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 469
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 470
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 471
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 472
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 473
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 474
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 475
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 476
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 477
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showCameraDialog()V
    .locals 3

    .line 438
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c004f

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 439
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    if-nez v1, :cond_0

    .line 440
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    .line 441
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 442
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->setWindowLayoutParams(Landroid/app/Dialog;)V

    .line 444
    :cond_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f090104

    .line 445
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 446
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090103

    .line 447
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 448
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private showErrorTipDialog()V
    .locals 3

    .line 354
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c001f

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    const v1, 0x7f09007a

    .line 355
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 356
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 357
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    if-nez v1, :cond_0

    .line 358
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    .line 360
    :cond_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 361
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 362
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 668
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 669
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 671
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mToast:Landroid/widget/Toast;

    .line 672
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private showToast(Ljava/lang/String;)V
    .locals 1

    .line 676
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 677
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 679
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mToast:Landroid/widget/Toast;

    .line 680
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

    .line 556
    :goto_0
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v3

    const/4 v4, -0x1

    if-eq v3, v4, :cond_0

    add-int/2addr v2, v3

    .line 558
    invoke-virtual {p1, v0, v1, v3}, Ljava/io/OutputStream;->write([BII)V

    goto :goto_0

    :cond_0
    return v2
.end method

.method private takePhoto()V
    .locals 2

    .line 484
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    const-string v1, "TakeEditUserPhoto2.jpg"

    .line 487
    invoke-direct {p0, p0, v1, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->createTempImageUri(Landroid/content/Context;Ljava/lang/String;Z)Landroid/net/Uri;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    .line 488
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.media.action.IMAGE_CAPTURE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 489
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->appendOutputExtra(Landroid/content/Intent;Landroid/net/Uri;)V

    const/4 v1, 0x3

    .line 490
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const/16 v1, 0x3ea

    .line 491
    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private updateLocalImg(Landroid/graphics/Bitmap;)V
    .locals 1

    if-eqz p1, :cond_0

    .line 658
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iput-object p1, v0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    const/4 v0, 0x1

    .line 659
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyImg:Z

    .line 660
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object p1

    .line 661
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :cond_0
    return-void
.end method


# virtual methods
.method public getContext()Landroid/content/Context;
    .locals 0

    return-object p0
.end method

.method public getId()Ljava/lang/String;
    .locals 1

    .line 262
    iget v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    if-nez v0, :cond_0

    .line 263
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleNumber:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 265
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupNumber:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getName()Ljava/lang/String;
    .locals 1

    .line 255
    iget v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    if-nez v0, :cond_0

    .line 256
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 258
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    .param p3    # Landroid/content/Intent;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 402
    invoke-super {p0, p1, p2, p3}, Landroidx/fragment/app/FragmentActivity;->onActivityResult(IILandroid/content/Intent;)V

    const/16 v0, 0x3ea

    if-eq p1, v0, :cond_0

    const/16 v0, 0x3e9

    if-eq p1, v0, :cond_0

    const/16 v0, 0x3eb

    if-ne p1, v0, :cond_4

    :cond_0
    const/4 v0, -0x1

    if-ne p2, v0, :cond_4

    const-string p2, "FragmentNewContactsActivity"

    const-string v0, "onActivityResult ok"

    .line 404
    invoke-static {p2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p3, :cond_1

    .line 405
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 406
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p3

    goto :goto_0

    :cond_1
    iget-object p3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    .line 407
    :goto_0
    invoke-virtual {p3}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object v0

    const-string v1, "content"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 408
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Invalid pictureUri scheme: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 412
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onPrizeActivityResult requestCode = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    packed-switch p1, :pswitch_data_0

    goto :goto_1

    :pswitch_0
    const/4 p1, 0x1

    .line 425
    invoke-direct {p0, p3, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->onPhotoCropped(Landroid/net/Uri;Z)V

    goto :goto_1

    .line 416
    :pswitch_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mTakePictureUri:Landroid/net/Uri;

    invoke-virtual {p1, p3}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 417
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->cropPhoto()V

    const-string p0, "onPrizeActivityResult cropPhoto"

    .line 418
    invoke-static {p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    :cond_3
    const-string p1, "onPrizeActivityResult copyAndCropPhoto"

    .line 420
    invoke-static {p2, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 421
    invoke-direct {p0, p3}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->copyAndCropPhoto(Landroid/net/Uri;)V

    :cond_4
    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x3e9
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onBackPressed()V
    .locals 0

    .line 216
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 222
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    const v1, 0x7f090139

    if-ne v1, v0, :cond_0

    .line 223
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->onBackPressed()V

    goto :goto_0

    .line 225
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 228
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    sparse-switch p1, :sswitch_data_0

    goto :goto_0

    .line 230
    :sswitch_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->saveData()V

    goto :goto_0

    .line 233
    :sswitch_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showCameraDialog()V

    goto :goto_0

    .line 236
    :sswitch_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_2

    .line 237
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 239
    :cond_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->takePhoto()V

    goto :goto_0

    .line 242
    :sswitch_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_3

    .line 243
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 245
    :cond_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->choosePhoto()V

    goto :goto_0

    .line 248
    :sswitch_4
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->dismissDialog()V

    :goto_0
    return-void

    :sswitch_data_0
    .sparse-switch
        0x7f09007a -> :sswitch_4
        0x7f090103 -> :sswitch_3
        0x7f090104 -> :sswitch_2
        0x7f09013a -> :sswitch_1
        0x7f09013c -> :sswitch_0
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 454
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 455
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 456
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 457
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCameraDialog:Landroid/app/Dialog;

    .line 458
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showCameraDialog()V

    .line 460
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 461
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 462
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mDialog:Landroid/app/Dialog;

    .line 463
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showErrorTipDialog()V

    .line 465
    :cond_1
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 81
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c004c

    .line 82
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 83
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->initView()V

    .line 84
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->initData()V

    return-void
.end method

.method protected onDestroy()V
    .locals 0

    .line 211
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    return-void
.end method

.method protected onPause()V
    .locals 0

    .line 203
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 197
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    return-void
.end method

.method public saveData()V
    .locals 9

    .line 270
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mEditPeopleName.getText().toString() = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FragmentNewContactsActivity"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 271
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mEditPeopleNumber.getText().toString() = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleNumber:Landroid/widget/EditText;

    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 272
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mEditGroupName.getText().toString() = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 273
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mEditGroupNumber.getText().toString() = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupNumber:Landroid/widget/EditText;

    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 275
    iget v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    const v2, 0xfffcdf

    const v3, 0x7f11007f

    const v4, 0x7f11007e

    const-string v5, "[0-9]+"

    const/4 v6, 0x1

    const v7, 0x7f110103

    if-nez v0, :cond_6

    .line 276
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 277
    invoke-direct {p0, v7}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    return-void

    .line 280
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    invoke-virtual {v8}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setName(Ljava/lang/String;)V

    .line 281
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v0, :cond_1

    .line 282
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleName:Landroid/widget/EditText;

    invoke-virtual {v8}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setName(Ljava/lang/String;)V

    .line 284
    :cond_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 285
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f110101

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(Ljava/lang/String;)V

    return-void

    .line 288
    :cond_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditPeopleNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 289
    invoke-virtual {v0, v5}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_3

    .line 290
    invoke-direct {p0, v4}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    return-void

    .line 292
    :cond_3
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    if-lt v4, v6, :cond_5

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    if-le v4, v2, :cond_4

    goto :goto_0

    .line 296
    :cond_4
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setNumber(Ljava/lang/String;)V

    .line 297
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-virtual {v3}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->drawableToBitamp(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Bitmap;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setBitmap(Landroid/graphics/Bitmap;)V

    .line 298
    iget-boolean v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v2, :cond_d

    .line 299
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setNumber(Ljava/lang/String;)V

    goto/16 :goto_2

    .line 293
    :cond_5
    :goto_0
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    return-void

    :cond_6
    if-ne v0, v6, :cond_d

    .line 302
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_7

    .line 303
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100fb

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(Ljava/lang/String;)V

    return-void

    .line 306
    :cond_7
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    invoke-virtual {v8}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setName(Ljava/lang/String;)V

    .line 307
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v0, :cond_8

    .line 308
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupName:Landroid/widget/EditText;

    invoke-virtual {v8}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setName(Ljava/lang/String;)V

    .line 310
    :cond_8
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->getId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    .line 311
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100fc

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(Ljava/lang/String;)V

    return-void

    .line 314
    :cond_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditGroupNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 315
    invoke-virtual {v0, v5}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_a

    .line 316
    invoke-direct {p0, v4}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    return-void

    .line 320
    :cond_a
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    if-lt v4, v6, :cond_c

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    if-le v4, v2, :cond_b

    goto :goto_1

    .line 324
    :cond_b
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setNumber(Ljava/lang/String;)V

    .line 325
    iget-boolean v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v2, :cond_d

    .line 326
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setNumber(Ljava/lang/String;)V

    goto :goto_2

    .line 321
    :cond_c
    :goto_1
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showToast(I)V

    return-void

    .line 329
    :cond_d
    :goto_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setType(I)V

    .line 330
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v0, :cond_e

    .line 331
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentType:I

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setType(I)V

    .line 332
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mImgPhoto:Landroid/widget/ImageView;

    invoke-virtual {v2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->drawableToBitamp(Landroid/graphics/drawable/Drawable;)Landroid/graphics/Bitmap;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setBitmap(Landroid/graphics/Bitmap;)V

    .line 336
    :cond_e
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->isModifyData:Z

    if-eqz v0, :cond_f

    .line 337
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "saveData: update contact "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 338
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mEditContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z

    .line 339
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->onBackPressed()V

    goto :goto_3

    .line 341
    :cond_f
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "saveData: mc ="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 342
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v0

    if-eqz v0, :cond_10

    .line 344
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->showErrorTipDialog()V

    goto :goto_3

    .line 346
    :cond_10
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->saveContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z

    .line 347
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->onBackPressed()V

    :goto_3
    return-void
.end method

.method public updateSeletedItm(I)V
    .locals 4

    .line 185
    iput p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->mCurrentSelect:I

    const/4 v0, 0x0

    move v1, v0

    .line 186
    :goto_0
    sget-object v2, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->LIN_RES_ID:[I

    array-length v3, v2

    if-ge v1, v3, :cond_1

    if-ne v1, p1, :cond_0

    .line 188
    aget v2, v2, v1

    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/view/View;->setSelected(Z)V

    goto :goto_1

    .line 190
    :cond_0
    aget v2, v2, v1

    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/view/View;->setSelected(Z)V

    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method
