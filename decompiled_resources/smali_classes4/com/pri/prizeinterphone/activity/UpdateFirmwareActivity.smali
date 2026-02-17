.class public Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "UpdateFirmwareActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# static fields
.field private static final MSG_CONNECTED_SVC_FAILED:I = 0x51

.field private static final MSG_CONNECTED_SVC_SUCCEED:I = 0x50

.field private static final TAG:Ljava/lang/String; = "UpdateFirmwareAct"


# instance fields
.field private isEnd:Z

.field private isRunning:Z

.field private mClientMessenger:Landroid/os/Messenger;

.field private mHandler:Landroid/os/Handler;

.field private mIsSvcBind:Z

.field private mLeftBt:Landroid/widget/Button;

.field private mMessenger:Landroid/os/Messenger;

.field private mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

.field private mRightBt:Landroid/widget/Button;

.field private final mServiceConnection:Landroid/content/ServiceConnection;

.field private mTvContent:Landroid/widget/TextView;


# direct methods
.method public static synthetic $r8$lambda$CJeG9LhKaiLp7j0hAcYAzi7Re3Y(Landroid/app/Instrumentation;)V
    .locals 0

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->lambda$onClick$0(Landroid/app/Instrumentation;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsSvcBind(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmLeftBt(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/Button;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMessenger(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/os/Messenger;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmNumberProgressBar(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Lcom/pri/prizeinterphone/widget/NumberProgressBar;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRightBt(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/Button;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTvContent(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)Landroid/widget/TextView;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mTvContent:Landroid/widget/TextView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputisRunning(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isRunning:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsSvcBind(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmMessenger(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Landroid/os/Messenger;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleMsgFromSvc(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->handleMsgFromSvc(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstartUpdateFirmware(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->startUpdateFirmware()V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 38
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    const/4 v0, 0x0

    .line 40
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    const/4 v0, 0x0

    .line 42
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    .line 48
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isRunning:Z

    .line 49
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isEnd:Z

    .line 84
    new-instance v0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mServiceConnection:Landroid/content/ServiceConnection;

    .line 204
    new-instance v0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mHandler:Landroid/os/Handler;

    .line 278
    new-instance v0, Landroid/os/Messenger;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mHandler:Landroid/os/Handler;

    invoke-direct {v0, v1}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mClientMessenger:Landroid/os/Messenger;

    return-void
.end method

.method private bindInterPhoneService()V
    .locals 3

    .line 78
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    if-nez v0, :cond_1

    .line 79
    :cond_0
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mServiceConnection:Landroid/content/ServiceConnection;

    const/4 v2, 0x1

    invoke-virtual {p0, v0, v1, v2}, Landroid/app/Activity;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    :cond_1
    return-void
.end method

.method private handleMsgFromSvc(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;)V
    .locals 6

    if-eqz p1, :cond_5

    .line 235
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->getStep()I

    move-result v0

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/16 v4, 0x8

    if-eq v0, v1, :cond_4

    const/4 v1, 0x4

    if-eq v0, v1, :cond_3

    if-eq v0, v4, :cond_2

    const/16 p1, 0x20

    if-eq v0, p1, :cond_1

    const/16 p1, 0x40

    if-eq v0, p1, :cond_0

    goto/16 :goto_0

    .line 265
    :cond_0
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isEnd:Z

    .line 266
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-virtual {p1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 267
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mTvContent:Landroid/widget/TextView;

    const v0, 0x7f110123

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 268
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    invoke-virtual {p1, v3}, Landroid/widget/Button;->setVisibility(I)V

    .line 269
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    invoke-virtual {p1, v4}, Landroid/widget/Button;->setVisibility(I)V

    .line 270
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    const p1, 0x7f110127

    invoke-virtual {p0, p1}, Landroid/widget/Button;->setText(I)V

    goto/16 :goto_0

    .line 256
    :cond_1
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isEnd:Z

    .line 257
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mTvContent:Landroid/widget/TextView;

    const v0, 0x7f110122

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 258
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    const/16 v0, 0x64

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    .line 259
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    invoke-virtual {p1, v3}, Landroid/widget/Button;->setVisibility(I)V

    .line 260
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    invoke-virtual {p1, v4}, Landroid/widget/Button;->setVisibility(I)V

    .line 261
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-virtual {p1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 262
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    const p1, 0x7f110126

    invoke-virtual {p0, p1}, Landroid/widget/Button;->setText(I)V

    goto :goto_0

    .line 248
    :cond_2
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->getCurrentSent()I

    move-result v0

    int-to-double v0, v0

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->getTotal()I

    move-result p1

    int-to-double v2, p1

    div-double/2addr v0, v2

    const-wide/high16 v2, 0x4059000000000000L    # 100.0

    mul-double/2addr v0, v2

    .line 249
    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v2

    const-wide/16 v4, 0x64

    cmp-long p1, v2, v4

    if-eqz p1, :cond_5

    .line 250
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p1, v0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    goto :goto_0

    .line 245
    :cond_3
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    goto :goto_0

    .line 237
    :cond_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mTvContent:Landroid/widget/TextView;

    const v0, 0x7f110121

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 238
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    invoke-virtual {p1, v4}, Landroid/widget/Button;->setVisibility(I)V

    .line 239
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    const v0, 0x7f110129

    invoke-virtual {p1, v0}, Landroid/widget/Button;->setText(I)V

    .line 240
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    .line 241
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    invoke-virtual {p1, v3}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    .line 242
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    invoke-virtual {p0, v2}, Landroid/widget/Button;->setEnabled(Z)V

    :cond_5
    :goto_0
    return-void
.end method

.method private initView()V
    .locals 2

    const v0, 0x7f090161

    .line 67
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mLeftBt:Landroid/widget/Button;

    .line 68
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09021e

    .line 69
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    .line 70
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 71
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setEnabled(Z)V

    const v0, 0x7f0902a2

    .line 73
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mNumberProgressBar:Lcom/pri/prizeinterphone/widget/NumberProgressBar;

    const v0, 0x7f09029c

    .line 74
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mTvContent:Landroid/widget/TextView;

    return-void
.end method

.method private static synthetic lambda$onClick$0(Landroid/app/Instrumentation;)V
    .locals 1

    const/4 v0, 0x3

    .line 163
    invoke-virtual {p0, v0}, Landroid/app/Instrumentation;->sendKeyDownUpSync(I)V

    return-void
.end method

.method private setWindowLayoutParams()V
    .locals 3

    .line 133
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 134
    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 135
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p0

    .line 136
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    const/16 v2, 0x50

    .line 137
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v2, 0x3c

    .line 138
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v0, v0

    const v2, 0x3f666666    # 0.9f

    mul-float/2addr v0, v2

    float-to-int v0, v0

    .line 139
    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 140
    invoke-virtual {p0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v0, 0x106000d

    .line 141
    invoke-virtual {p0, v0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    const/16 v0, 0x80

    .line 142
    invoke-virtual {p0, v0}, Landroid/view/Window;->addFlags(I)V

    return-void
.end method

.method private startUpdateFirmware()V
    .locals 2

    .line 179
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    if-eqz v0, :cond_0

    .line 180
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 181
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mClientMessenger:Landroid/os/Messenger;

    iput-object v1, v0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    const/16 v1, 0x81

    .line 182
    iput v1, v0, Landroid/os/Message;->what:I

    .line 184
    :try_start_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    invoke-virtual {p0, v0}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 186
    invoke-virtual {p0}, Landroid/os/RemoteException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method

.method private unbindInterPhoneService()V
    .locals 1

    .line 103
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    if-eqz v0, :cond_1

    .line 104
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mServiceConnection:Landroid/content/ServiceConnection;

    invoke-virtual {p0, v0}, Landroid/app/Activity;->unbindService(Landroid/content/ServiceConnection;)V

    const/4 v0, 0x0

    .line 105
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    const/4 v0, 0x0

    .line 106
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mIsSvcBind:Z

    :cond_1
    return-void
.end method

.method private updateActivityDestroy()V
    .locals 2

    .line 192
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    if-eqz v0, :cond_0

    .line 193
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 194
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mClientMessenger:Landroid/os/Messenger;

    iput-object v1, v0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    const/16 v1, 0x83

    .line 195
    iput v1, v0, Landroid/os/Message;->what:I

    .line 197
    :try_start_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mMessenger:Landroid/os/Messenger;

    invoke-virtual {p0, v0}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 199
    invoke-virtual {p0}, Landroid/os/RemoteException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method


# virtual methods
.method public onBackPressed()V
    .locals 0

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 147
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f090161

    const/4 v1, 0x0

    if-eq p1, v0, :cond_2

    const v0, 0x7f09021e

    if-eq p1, v0, :cond_0

    goto :goto_0

    .line 160
    :cond_0
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isRunning:Z

    if-eqz p1, :cond_1

    .line 161
    new-instance p0, Landroid/app/Instrumentation;

    invoke-direct {p0}, Landroid/app/Instrumentation;-><init>()V

    .line 162
    new-instance p1, Ljava/lang/Thread;

    new-instance v0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity$$ExternalSyntheticLambda0;-><init>(Landroid/app/Instrumentation;)V

    invoke-direct {p1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 164
    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    goto :goto_0

    .line 166
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mRightBt:Landroid/widget/Button;

    invoke-virtual {p1, v1}, Landroid/widget/Button;->setEnabled(Z)V

    .line 167
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->startUpdateFirmware()V

    goto :goto_0

    .line 149
    :cond_2
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->isEnd:Z

    if-eqz p1, :cond_3

    .line 150
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->restartApp()V

    goto :goto_0

    .line 152
    :cond_3
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, p1}, Landroid/app/Activity;->stopService(Landroid/content/Intent;)Z

    .line 153
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->releaseYModem()V

    .line 154
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPwdFoot()V

    .line 155
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->releaseSerialPort()V

    .line 156
    invoke-static {v1}, Ljava/lang/System;->exit(I)V

    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 56
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const-string p1, "UpdateFirmwareAct"

    const-string v0, "onCreate"

    .line 57
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const p1, 0x7f0c001e

    .line 58
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    const-string p1, ""

    .line 59
    invoke-virtual {p0, p1}, Landroid/app/Activity;->setTitle(Ljava/lang/CharSequence;)V

    .line 60
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mHandler:Landroid/os/Handler;

    const/16 v0, 0x51

    const-wide/16 v1, 0x5dc

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    .line 61
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->setWindowLayoutParams()V

    .line 62
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->initView()V

    const/4 p1, 0x0

    .line 63
    invoke-virtual {p0, p1}, Landroid/app/Activity;->setFinishOnTouchOutside(Z)V

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    const-string v0, "UpdateFirmwareAct"

    const-string v1, "onDestroy"

    .line 125
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 126
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 127
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->updateActivityDestroy()V

    .line 128
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->unbindInterPhoneService()V

    .line 129
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method protected onPause()V
    .locals 2

    const-string v0, "UpdateFirmwareAct"

    const-string v1, "onPause"

    .line 119
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 120
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    return-void
.end method

.method protected onResume()V
    .locals 2

    const-string v0, "UpdateFirmwareAct"

    const-string v1, "onResume"

    .line 112
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 113
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;->bindInterPhoneService()V

    .line 114
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    return-void
.end method
