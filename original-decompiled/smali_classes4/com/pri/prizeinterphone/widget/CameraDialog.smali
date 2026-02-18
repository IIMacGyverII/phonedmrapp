.class public Lcom/pri/prizeinterphone/widget/CameraDialog;
.super Landroid/app/AlertDialog;
.source "CameraDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;
    }
.end annotation


# instance fields
.field private mCameraDialogDelete:Landroid/widget/Button;

.field private mCameraDialogSelete:Landroid/widget/Button;

.field private mCameraDialogTake:Landroid/widget/Button;

.field private mContext:Landroid/content/Context;

.field private onClickCameraDialogListener:Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    .param p1    # Landroid/content/Context;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 26
    invoke-direct {p0, p1}, Landroid/app/AlertDialog;-><init>(Landroid/content/Context;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;I)V
    .locals 0
    .param p1    # Landroid/content/Context;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 30
    invoke-direct {p0, p1, p2}, Landroid/app/AlertDialog;-><init>(Landroid/content/Context;I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;ZLandroid/content/DialogInterface$OnCancelListener;)V
    .locals 0
    .param p1    # Landroid/content/Context;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p3    # Landroid/content/DialogInterface$OnCancelListener;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 34
    invoke-direct {p0, p1, p2, p3}, Landroid/app/AlertDialog;-><init>(Landroid/content/Context;ZLandroid/content/DialogInterface$OnCancelListener;)V

    .line 35
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->mContext:Landroid/content/Context;

    return-void
.end method

.method private initView(Landroid/view/View;)V
    .locals 1

    const v0, 0x7f09016d

    .line 65
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->mCameraDialogDelete:Landroid/widget/Button;

    .line 66
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f0901a2

    .line 67
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->mCameraDialogTake:Landroid/widget/Button;

    .line 68
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090190

    .line 69
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->mCameraDialogSelete:Landroid/widget/Button;

    .line 70
    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 72
    invoke-virtual {p0}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;

    move-result-object p0

    .line 73
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object p0

    const/16 p1, 0x1e0

    .line 74
    iput p1, p0, Landroid/view/WindowManager$LayoutParams;->height:I

    const/16 p1, 0x190

    .line 75
    iput p1, p0, Landroid/view/WindowManager$LayoutParams;->width:I

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 40
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f09016d

    if-eq p1, v0, :cond_2

    const v0, 0x7f090190

    if-eq p1, v0, :cond_1

    const v0, 0x7f0901a2

    if-eq p1, v0, :cond_0

    goto :goto_0

    .line 45
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->onClickCameraDialogListener:Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;

    invoke-interface {p1}, Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;->onTakePhoto()V

    goto :goto_0

    .line 48
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->onClickCameraDialogListener:Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;

    invoke-interface {p1}, Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;->onSelectPhoto()V

    goto :goto_0

    .line 42
    :cond_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->onClickCameraDialogListener:Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;

    invoke-interface {p1}, Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;->onDeletePhoto()V

    .line 51
    :goto_0
    invoke-virtual {p0}, Landroid/app/AlertDialog;->cancel()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 56
    invoke-super {p0, p1}, Landroid/app/AlertDialog;->onCreate(Landroid/os/Bundle;)V

    .line 57
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->mContext:Landroid/content/Context;

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c0038

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    .line 58
    invoke-virtual {p0, p1}, Landroid/app/AlertDialog;->setContentView(Landroid/view/View;)V

    .line 59
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/widget/CameraDialog;->initView(Landroid/view/View;)V

    return-void
.end method

.method public setOnClickCameraDialogListener(Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;)V
    .locals 0

    .line 80
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/CameraDialog;->onClickCameraDialogListener:Lcom/pri/prizeinterphone/widget/CameraDialog$onClickCameraDialogListener;

    return-void
.end method
