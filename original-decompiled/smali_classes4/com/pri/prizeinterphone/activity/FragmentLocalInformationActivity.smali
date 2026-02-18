.class public Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentLocalInformationActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field private mTvDmrFirmwareVersion:Landroid/widget/TextView;

.field private mTvMacGyverModVersion:Landroid/widget/TextView;

.field private mTvSoftwareVersion:Landroid/widget/TextView;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 16
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private initValue()V
    .locals 0

    return-void
.end method

.method private initView()V
    .locals 2

    const v0, 0x7f09018b

    .line 34
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->mTvSoftwareVersion:Landroid/widget/TextView;

    const v0, 0x7f090187

    .line 36
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->mTvDmrFirmwareVersion:Landroid/widget/TextView;

    .line 37
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->getVersionName()Ljava/lang/String;

    move-result-object v0

    .line 38
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->mTvSoftwareVersion:Landroid/widget/TextView;

    if-nez v0, :cond_0

    const-string v0, "V1.0"

    :cond_0
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 39
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->mTvDmrFirmwareVersion:Landroid/widget/TextView;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->getDmrVersion()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method


# virtual methods
.method public getDmrVersion()Ljava/lang/String;
    .locals 2

    .line 68
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_device_dmr_version"

    const-string v1, "DMR003.UV4T.V022"

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getVersionName()Ljava/lang/String;
    .locals 2

    .line 56
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 59
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object p0

    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p0

    .line 60
    iget-object p0, p0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 62
    invoke-virtual {p0}, Landroid/content/pm/PackageManager$NameNotFoundException;->printStackTrace()V

    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public onBackPressed()V
    .locals 0

    .line 30
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 48
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f090054

    if-eq p1, v0, :cond_0

    goto :goto_0

    .line 50
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->onBackPressed()V

    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 22
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c0044

    .line 23
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 24
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->initView()V

    .line 25
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalInformationActivity;->initValue()V

    return-void
.end method
