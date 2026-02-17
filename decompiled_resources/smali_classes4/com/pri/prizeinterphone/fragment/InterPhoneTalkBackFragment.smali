.class public Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;
.super Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.source "InterPhoneTalkBackFragment.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Landroid/view/View$OnTouchListener;
.implements Lcom/pri/prizeinterphone/manager/LaunchListener;
.implements Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;
.implements Lcom/pri/prizeinterphone/manager/InterruptResultListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;
    }
.end annotation


# static fields
.field public static PTTDOWNINTER:Ljava/lang/String; = "com.interphone.ptt.down"

.field public static PTTUPINTER:Ljava/lang/String; = "com.interphone.ptt.up"

.field private static final TAG:Ljava/lang/String; = "InterPhoneTalkBackFragment"


# instance fields
.field private audioFocusRequest:Landroid/media/AudioFocusRequest;

.field private audioManager:Landroid/media/AudioManager;

.field public channels:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation
.end field

.field private countDownTimer:Landroid/os/CountDownTimer;

.field private focusChangeListener:Landroid/media/AudioManager$OnAudioFocusChangeListener;

.field public isButtonRecord:Z

.field public isPTTRecord:Z

.field public isReceiveStart:Z

.field private mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

.field private mCurrentChannelIndex:I

.field private final mHandler:Landroid/os/Handler;

.field private mImgTalkbackAdd:Landroid/widget/ImageButton;

.field private mImgTalkbackNumOne:Landroid/widget/ImageButton;

.field private mImgTalkbackNumTwo:Landroid/widget/ImageButton;

.field private mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

.field private mImgTalkbackRecord:Landroid/widget/ImageButton;

.field private mImgTalkbackSub:Landroid/widget/ImageButton;

.field private mLocalView:Landroid/view/View;

.field private mMaxChannelId:I

.field private mPhoneStateListener:Landroid/telephony/PhoneStateListener;

.field private mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

.field private mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

.field private mToast:Landroid/widget/Toast;

.field private mTvTalkbackCallName:Landroid/widget/TextView;

.field private mTvTalkbackColorOrNoise:Landroid/widget/TextView;

.field private mTvTalkbackPower:Landroid/widget/TextView;

.field private mTvTalkbackReceive:Landroid/widget/TextView;

.field private mTvTalkbackSend:Landroid/widget/TextView;

.field private mUpdateUIRunnable:Ljava/lang/Runnable;

.field private messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

.field private onLoadCompleteListener:Landroid/media/SoundPool$OnLoadCompleteListener;

.field public receiver:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;

.field private soundId:I

.field private soundPool:Landroid/media/SoundPool;

.field private tmpCurrentChannelIndex:I


# direct methods
.method public static synthetic $r8$lambda$KxFRuJc4R1UVwJkM9tjSqW424R4(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$setTalkbackRecordBg$1(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$X1veGoYc9tbGPRo0_l2CgJ-3xA4(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$updateChannelId$0(Z)V

    return-void
.end method

.method public static synthetic $r8$lambda$cQLkEHYh8EpU0bgnnYdSs_q134w(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$cancelLimitRecordTime$3()V

    return-void
.end method

.method public static synthetic $r8$lambda$y9dSNsSmdb1fF6ZnmplsP4yJx-Y(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->lambda$showLimitRecordTime$2()V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmImgTalkbackProgress(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTalkBackStateMachine(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetsoundId(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->soundId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgettmpCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmCurrentChannelData(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmCurrentChannelIndex(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateUI(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->updateUI()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 106
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    const/4 v0, 0x0

    .line 61
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    .line 69
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;

    .line 73
    new-instance v1, Landroid/os/Handler;

    invoke-direct {v1}, Landroid/os/Handler;-><init>()V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mHandler:Landroid/os/Handler;

    .line 158
    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mUpdateUIRunnable:Ljava/lang/Runnable;

    .line 263
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    iput v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    .line 460
    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$3;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->onLoadCompleteListener:Landroid/media/SoundPool$OnLoadCompleteListener;

    .line 524
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isPTTRecord:Z

    .line 525
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isButtonRecord:Z

    .line 526
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isReceiveStart:Z

    .line 560
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$4;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPhoneStateListener:Landroid/telephony/PhoneStateListener;

    .line 618
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$5;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$5;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->focusChangeListener:Landroid/media/AudioManager$OnAudioFocusChangeListener;

    return-void
.end method

.method private abandonAudioFocus()V
    .locals 2

    .line 610
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioManager:Landroid/media/AudioManager;

    if-eqz v0, :cond_0

    .line 611
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioFocusRequest:Landroid/media/AudioFocusRequest;

    if-eqz p0, :cond_0

    .line 612
    invoke-virtual {v0, p0}, Landroid/media/AudioManager;->abandonAudioFocusRequest(Landroid/media/AudioFocusRequest;)I

    move-result p0

    .line 613
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "requestAudioFocus,result="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "InterPhoneTalkBackFragment"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method

.method private createSoundPool()V
    .locals 3

    .line 441
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->soundPool:Landroid/media/SoundPool;

    if-nez v0, :cond_0

    .line 444
    new-instance v0, Landroid/media/AudioAttributes$Builder;

    invoke-direct {v0}, Landroid/media/AudioAttributes$Builder;-><init>()V

    const/4 v1, 0x1

    .line 445
    invoke-virtual {v0, v1}, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v0

    const/4 v2, 0x2

    .line 446
    invoke-virtual {v0, v2}, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v0

    .line 447
    invoke-virtual {v0}, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;

    move-result-object v0

    .line 449
    new-instance v2, Landroid/media/SoundPool$Builder;

    invoke-direct {v2}, Landroid/media/SoundPool$Builder;-><init>()V

    .line 450
    invoke-virtual {v2, v1}, Landroid/media/SoundPool$Builder;->setMaxStreams(I)Landroid/media/SoundPool$Builder;

    move-result-object v1

    .line 451
    invoke-virtual {v1, v0}, Landroid/media/SoundPool$Builder;->setAudioAttributes(Landroid/media/AudioAttributes;)Landroid/media/SoundPool$Builder;

    move-result-object v0

    .line 452
    invoke-virtual {v0}, Landroid/media/SoundPool$Builder;->build()Landroid/media/SoundPool;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->soundPool:Landroid/media/SoundPool;

    .line 456
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->onLoadCompleteListener:Landroid/media/SoundPool$OnLoadCompleteListener;

    invoke-virtual {v0, p0}, Landroid/media/SoundPool;->setOnLoadCompleteListener(Landroid/media/SoundPool$OnLoadCompleteListener;)V

    :cond_0
    return-void
.end method

.method private synthetic lambda$cancelLimitRecordTime$3()V
    .locals 2

    .line 795
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->countDownTimer:Landroid/os/CountDownTimer;

    if-eqz v0, :cond_0

    .line 796
    invoke-virtual {v0}, Landroid/os/CountDownTimer;->cancel()V

    .line 798
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    if-eqz v0, :cond_1

    const/4 v1, 0x0

    .line 799
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;->setProgress(I)V

    .line 800
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    const/4 v0, 0x4

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    :cond_1
    return-void
.end method

.method private synthetic lambda$setTalkbackRecordBg$1(I)V
    .locals 1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    .line 693
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackRecord:Landroid/widget/ImageButton;

    const p1, 0x7f0800d0

    invoke-virtual {p0, p1}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    goto :goto_0

    .line 687
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackRecord:Landroid/widget/ImageButton;

    const p1, 0x7f0800d3

    invoke-virtual {p0, p1}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    goto :goto_0

    .line 690
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackRecord:Landroid/widget/ImageButton;

    const p1, 0x7f0800d2

    invoke-virtual {p0, p1}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    :goto_0
    return-void
.end method

.method private synthetic lambda$showLimitRecordTime$2()V
    .locals 8

    .line 769
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 771
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "pref_person_limit_send_time"

    const/16 v2, 0x1e

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    if-lez v0, :cond_0

    mul-int/lit16 v7, v0, 0x3e8

    .line 774
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;

    int-to-long v3, v7

    const-wide/16 v5, 0x3e8

    move-object v1, v0

    move-object v2, p0

    invoke-direct/range {v1 .. v7}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$6;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;JJI)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->countDownTimer:Landroid/os/CountDownTimer;

    .line 786
    invoke-virtual {v0}, Landroid/os/CountDownTimer;->start()Landroid/os/CountDownTimer;

    :cond_0
    return-void
.end method

.method private synthetic lambda$updateChannelId$0(Z)V
    .locals 3

    .line 271
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x1

    if-gt v0, v1, :cond_0

    return-void

    .line 275
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;

    iget v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 277
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    if-eqz p1, :cond_1

    add-int/2addr v0, v1

    .line 280
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    goto :goto_0

    :cond_1
    sub-int/2addr v0, v1

    .line 282
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    .line 285
    :goto_0
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    if-gez p1, :cond_2

    const/4 p1, 0x0

    .line 286
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    return-void

    .line 288
    :cond_2
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mMaxChannelId:I

    add-int/lit8 v2, v0, -0x1

    if-le p1, v2, :cond_3

    sub-int/2addr v0, v1

    .line 289
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    return-void

    .line 292
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    if-nez p1, :cond_4

    .line 293
    new-instance p1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    .line 322
    :cond_4
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/16 v0, 0x22

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 323
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/16 v0, 0x23

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 325
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;

    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->tmpCurrentChannelIndex:I

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 327
    :try_start_0
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->clone()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p1

    .line 328
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfoWithData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    const-string v0, "InterPhoneTalkBackFragment"

    const-string/jumbo v1, "updateChannelId,error"

    .line 330
    invoke-static {v0, v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1
    const p1, 0x7f1100ac

    .line 339
    invoke-virtual {p0, p1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->showProgressDialog(Ljava/lang/String;)V

    .line 349
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0xbb8

    invoke-virtual {p1, p0, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method private playSound()V
    .locals 4

    .line 468
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 471
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->createSoundPool()V

    .line 472
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->soundPool:Landroid/media/SoundPool;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const v2, 0x7f100001

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v3}, Landroid/media/SoundPool;->load(Landroid/content/Context;II)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->soundId:I

    return-void
.end method

.method private saveSendRecord()V
    .locals 5

    .line 423
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->getSaveRecord()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 424
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->setSaveRecord(Z)V

    .line 425
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->getRecordFileName()Ljava/lang/String;

    move-result-object v0

    .line 426
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->getRecordFilePath()Ljava/lang/String;

    move-result-object v2

    .line 427
    new-instance v3, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-direct {v3}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;-><init>()V

    .line 428
    invoke-virtual {v3, v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setName(Ljava/lang/String;)V

    .line 429
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ""

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setChannelName(Ljava/lang/String;)V

    .line 430
    invoke-virtual {v3, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setDirection(I)V

    .line 431
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->getTimestamp()J

    move-result-wide v0

    invoke-virtual {v3, v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setTimestamp(J)V

    .line 432
    invoke-virtual {v3, v2}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setFilePath(Ljava/lang/String;)V

    .line 433
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->addRecordDb(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    :cond_0
    return-void
.end method

.method private updateChannelNumber()V
    .locals 4

    .line 356
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v0

    const/16 v1, 0xa

    if-ge v0, v1, :cond_0

    .line 359
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumOne:Landroid/widget/ImageButton;

    const v2, 0x7f0800c6

    invoke-virtual {v1, v2}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    .line 361
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumTwo:Landroid/widget/ImageButton;

    sget-object v1, Lcom/pri/prizeinterphone/Util/Util;->FRAGMENT_TALKBACK_NUM_RES:[I

    aget v0, v1, v0

    invoke-virtual {p0, v0}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    goto :goto_0

    .line 363
    :cond_0
    div-int/lit8 v2, v0, 0xa

    .line 364
    rem-int/2addr v0, v1

    .line 366
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumOne:Landroid/widget/ImageButton;

    sget-object v3, Lcom/pri/prizeinterphone/Util/Util;->FRAGMENT_TALKBACK_NUM_RES:[I

    aget v2, v3, v2

    invoke-virtual {v1, v2}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    .line 368
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumTwo:Landroid/widget/ImageButton;

    aget v0, v3, v0

    invoke-virtual {p0, v0}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    :goto_0
    return-void
.end method

.method private updateUI()V
    .locals 10

    const-string v0, "InterPhoneTalkBackFragment"

    const-string/jumbo v1, "updateUI"

    .line 167
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 168
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->initData()V

    .line 169
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-nez v1, :cond_0

    const-string/jumbo p0, "updateUI, mCurrentChannelData is null"

    .line 170
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 173
    :cond_0
    iget v0, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    const v1, 0x7f1100dd

    const/4 v2, 0x1

    const v3, 0x7f1100ed

    if-ne v0, v2, :cond_1

    .line 174
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackPower:Landroid/widget/TextView;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const v1, 0x7f1100e0

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 176
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackPower:Landroid/widget/TextView;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const v1, 0x7f1100e2

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 179
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v0, :cond_2

    .line 180
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackColorOrNoise:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const v4, 0x7f1100ad

    invoke-virtual {p0, v4}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;->cc:I

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 182
    :cond_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackColorOrNoise:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const v4, 0x7f1100ee

    invoke-virtual {p0, v4}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 184
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 185
    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackSend:Landroid/widget/TextView;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const v6, 0x7f1100c8

    invoke-virtual {p0, v6}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v6, 0x0

    const/4 v7, 0x3

    invoke-virtual {v0, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "."

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v9

    invoke-virtual {v0, v7, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 187
    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackReceive:Landroid/widget/TextView;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const v9, 0x7f1100c5

    invoke-virtual {p0, v9}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v8

    invoke-virtual {v0, v7, v8}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 189
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    const-string v5, " "

    if-nez v4, :cond_5

    .line 190
    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    const v4, 0x7f1100af

    if-nez v0, :cond_3

    .line 191
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v4}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 192
    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const v3, 0x7f1100b3

    .line 193
    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v3, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 191
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    :cond_3
    if-ne v0, v2, :cond_4

    .line 196
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v4}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const v3, 0x7f1100b2

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v3, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 198
    :cond_4
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v4}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const v3, 0x7f1100b0

    invoke-virtual {p0, v3}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 200
    :goto_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    invoke-virtual {v0, v6}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_3

    .line 202
    :cond_5
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    const/4 v2, 0x4

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 211
    :goto_3
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    const v3, 0x17d78400

    if-lt v2, v3, :cond_6

    const v4, 0x1c9c3800

    if-gt v2, v4, :cond_6

    iget v6, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    if-lt v6, v3, :cond_6

    if-gt v6, v4, :cond_6

    const-string v1, "(UHF)"

    goto :goto_4

    :cond_6
    const v3, 0x81b3200

    if-lt v2, v3, :cond_7

    const v4, 0xa5f0780

    if-gt v2, v4, :cond_7

    .line 216
    iget v2, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    if-lt v2, v3, :cond_7

    if-gt v2, v4, :cond_7

    const-string v1, "(VHF)"

    .line 222
    :cond_7
    :goto_4
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_9

    .line 223
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 224
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 226
    :cond_8
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 229
    :cond_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v0, :cond_b

    .line 230
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const v2, 0x7f1100f9

    if-eqz v0, :cond_a

    .line 231
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    goto :goto_5

    .line 233
    :cond_a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    goto :goto_5

    .line 236
    :cond_b
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const v2, 0x7f1100f7

    if-eqz v0, :cond_c

    .line 237
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    goto :goto_5

    .line 239
    :cond_c
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    :goto_5
    return-void
.end method


# virtual methods
.method public cancelLimitRecordTime()V
    .locals 2

    .line 793
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 794
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method

.method public createRecordFile()V
    .locals 0

    .line 706
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->createRecordFile()V

    return-void
.end method

.method public doAddAction()V
    .locals 3

    .line 247
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->doAddAction()V

    .line 248
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public getAudioFocus()V
    .locals 3

    .line 587
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 591
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioManager:Landroid/media/AudioManager;

    if-nez v0, :cond_1

    .line 592
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "audio"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/media/AudioManager;

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioManager:Landroid/media/AudioManager;

    .line 594
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioFocusRequest:Landroid/media/AudioFocusRequest;

    if-nez v0, :cond_2

    .line 595
    new-instance v0, Landroid/media/AudioFocusRequest$Builder;

    const/4 v1, 0x3

    invoke-direct {v0, v1}, Landroid/media/AudioFocusRequest$Builder;-><init>(I)V

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->focusChangeListener:Landroid/media/AudioManager$OnAudioFocusChangeListener;

    .line 596
    invoke-virtual {v0, v1}, Landroid/media/AudioFocusRequest$Builder;->setOnAudioFocusChangeListener(Landroid/media/AudioManager$OnAudioFocusChangeListener;)Landroid/media/AudioFocusRequest$Builder;

    move-result-object v0

    .line 597
    invoke-virtual {v0}, Landroid/media/AudioFocusRequest$Builder;->build()Landroid/media/AudioFocusRequest;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioFocusRequest:Landroid/media/AudioFocusRequest;

    .line 599
    :cond_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioManager:Landroid/media/AudioManager;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioFocusRequest:Landroid/media/AudioFocusRequest;

    invoke-virtual {v0, p0}, Landroid/media/AudioManager;->requestAudioFocus(Landroid/media/AudioFocusRequest;)I

    move-result p0

    const-string v0, "InterPhoneTalkBackFragment"

    .line 600
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "requestAudioFocus,result="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 602
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_0
    return-void
.end method

.method public getBusyNoSend()Z
    .locals 0

    .line 815
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getBusyNoSend()Z

    move-result p0

    return p0
.end method

.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "InterPhoneTalkBackFragment"

    return-object p0
.end method

.method public initData()V
    .locals 2

    .line 145
    :try_start_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList()Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->channels:Ljava/util/List;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 151
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 152
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannelIndex()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelIndex:I

    .line 153
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mMaxChannelId:I

    .line 155
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->updateChannelNumber()V

    return-void

    :catch_0
    move-exception p0

    const-string v0, "InterPhoneTalkBackFragment"

    const-string v1, "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null"

    .line 147
    invoke-static {v0, v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method public initView(Landroid/view/View;)V
    .locals 2

    .line 111
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 113
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c004d

    const/4 v1, 0x0

    .line 114
    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    .line 115
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 116
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e2

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumOne:Landroid/widget/ImageButton;

    .line 117
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e3

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackNumTwo:Landroid/widget/ImageButton;

    .line 118
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e9

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackSub:Landroid/widget/ImageButton;

    .line 119
    invoke-virtual {p1, p0}, Landroid/widget/ImageButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 120
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900df

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackAdd:Landroid/widget/ImageButton;

    .line 121
    invoke-virtual {p1, p0}, Landroid/widget/ImageButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 122
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e7

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackRecord:Landroid/widget/ImageButton;

    .line 123
    invoke-virtual {p1, p0}, Landroid/widget/ImageButton;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 124
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackRecord:Landroid/widget/ImageButton;

    const v0, 0x7f0800d1

    invoke-virtual {p1, v0}, Landroid/widget/ImageButton;->setBackgroundResource(I)V

    .line 125
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e5

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mImgTalkbackProgress:Lcom/pri/prizeinterphone/widget/CircleProgressDrawable;

    .line 126
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e4

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackPower:Landroid/widget/TextView;

    .line 127
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e1

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackColorOrNoise:Landroid/widget/TextView;

    .line 128
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e8

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackSend:Landroid/widget/TextView;

    .line 129
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e6

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackReceive:Landroid/widget/TextView;

    .line 130
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900e0

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTvTalkbackCallName:Landroid/widget/TextView;

    const p1, 0x7f0800bb

    .line 131
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setAddButton(I)V

    .line 133
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    .line 134
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addInterruptListener(Lcom/pri/prizeinterphone/manager/InterruptResultListener;)V

    .line 135
    invoke-static {p0}, Lcom/pri/prizeinterphone/state/TalkBackStateMachine;->makePerson(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    return-void
.end method

.method public isInterruptTransport()Z
    .locals 1

    .line 679
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInterrupt()I

    move-result p0

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isSendStatus()Z
    .locals 0

    .line 811
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSendStatus()Z

    move-result p0

    return p0
.end method

.method public launchCommand()V
    .locals 0

    .line 759
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->launchCommand()V

    return-void
.end method

.method public launchEnd()V
    .locals 0

    .line 763
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->launchEnd()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 374
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f0900df

    const/16 v1, 0x7e5

    if-eq p1, v0, :cond_1

    const v0, 0x7f0900e9

    if-eq p1, v0, :cond_0

    goto :goto_0

    .line 376
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz p0, :cond_2

    .line 377
    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {p0, v1, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 381
    :cond_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz p0, :cond_2

    .line 382
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0, v1, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_2
    :goto_0
    return-void
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 253
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 254
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->updateUI()V

    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 80
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->onCreate(Landroid/os/Bundle;)V

    const-string p1, "InterPhoneTalkBackFragment"

    const-string v0, "onCreate"

    .line 81
    invoke-static {p1, v0}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 83
    new-instance p1, Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-direct {p1}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    .line 86
    new-instance p1, Landroid/content/IntentFilter;

    invoke-direct {p1}, Landroid/content/IntentFilter;-><init>()V

    const-string v0, "com.interphone.ptt.down"

    .line 87
    invoke-virtual {p1, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "com.interphone.ptt.up"

    .line 88
    invoke-virtual {p1, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 89
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->receiver:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;

    .line 90
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->receiver:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;

    invoke-virtual {v0, v1, p1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 92
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addLaunchListener(Lcom/pri/prizeinterphone/manager/LaunchListener;)V

    .line 94
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    const-string v0, "phone"

    invoke-virtual {p1, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/TelephonyManager;

    .line 95
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPhoneStateListener:Landroid/telephony/PhoneStateListener;

    const/16 v1, 0x20

    invoke-virtual {p1, v0, v1}, Landroid/telephony/TelephonyManager;->listen(Landroid/telephony/PhoneStateListener;I)V

    .line 97
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    const-string v0, "audio"

    invoke-virtual {p1, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/media/AudioManager;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->audioManager:Landroid/media/AudioManager;

    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 483
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onDestroy()V

    .line 484
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz v0, :cond_0

    const/16 v1, 0x7dc

    .line 485
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 486
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/StateMachine;->quit()V

    .line 488
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mHandler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 489
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->receiver:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$InterPhoneReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 490
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->removeInterruptListener(Lcom/pri/prizeinterphone/manager/InterruptResultListener;)V

    .line 491
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    return-void
.end method

.method public onReceiveInterrupt(I)V
    .locals 1

    .line 531
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 v0, 0x7de

    invoke-virtual {p0, v0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public onReceiveStart()V
    .locals 1

    .line 634
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz p0, :cond_0

    const/16 v0, 0x7e0

    .line 635
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    :cond_0
    return-void
.end method

.method public onReceiveStop()V
    .locals 1

    .line 641
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz p0, :cond_0

    const/16 v0, 0x7e1

    .line 643
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(I)V

    :cond_0
    return-void
.end method

.method public onResume()V
    .locals 2

    .line 627
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    const-string v0, "InterPhoneTalkBackFragment"

    const-string v1, "onResume"

    .line 628
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 629
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->updateUI()V

    return-void
.end method

.method public onSendStart()V
    .locals 0

    return-void
.end method

.method public onSendStop()V
    .locals 0

    return-void
.end method

.method public onSendTimeout()V
    .locals 1

    .line 663
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    if-eqz p0, :cond_0

    const/16 v0, 0x7e4

    .line 664
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_0
    return-void
.end method

.method public onStop()V
    .locals 0

    .line 478
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onStop()V

    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 4

    .line 392
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    const/4 v1, 0x1

    const v2, 0x7f0900e7

    if-ne v0, v2, :cond_3

    .line 393
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "motionEvent="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "InterPhoneTalkBackFragment"

    invoke-static {v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 394
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result p2

    const/16 v0, 0x4e8f

    if-eqz p2, :cond_1

    if-eq p2, v1, :cond_0

    const/4 p1, 0x3

    if-eq p2, p1, :cond_0

    goto :goto_0

    .line 410
    :cond_0
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isButtonRecord:Z

    if-eqz p1, :cond_3

    .line 412
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 413
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    const/16 p2, 0x7dc

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    const/4 p1, 0x0

    .line 414
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isButtonRecord:Z

    goto :goto_0

    .line 397
    :cond_1
    iget-boolean p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isPTTRecord:Z

    if-eqz p2, :cond_2

    goto :goto_0

    .line 400
    :cond_2
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    invoke-interface {p1, v1}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 401
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->isButtonRecord:Z

    .line 403
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->removeMessages(I)V

    .line 405
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mTalkBackStateMachine:Lcom/pri/prizeinterphone/state/TalkBackStateMachine;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v2, 0xc8

    invoke-virtual {p0, p1, v2, v3}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessageDelayed(Landroid/os/Message;J)V

    :cond_3
    :goto_0
    return v1
.end method

.method public sendInterrupt()V
    .locals 1

    .line 670
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    const/4 v0, 0x3

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendTransmissionInterruptCmdToMdl(I)V

    return-void
.end method

.method public setSendStatus(I)V
    .locals 0

    .line 807
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->setSendStatus(I)V

    return-void
.end method

.method public setStartReceivePrepare()V
    .locals 1

    .line 740
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->getAudioFocus()V

    const/4 v0, 0x2

    .line 741
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    return-void
.end method

.method public setStartRecordPrepare()V
    .locals 1

    const/4 v0, 0x1

    .line 722
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 723
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->getAudioFocus()V

    .line 724
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->playStartPromptTone()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 725
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->playSound()V

    :cond_0
    return-void
.end method

.method public setStopReceivePrepare()V
    .locals 3

    .line 745
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 746
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;-><init>()V

    .line 747
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getRecordFileName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setName(Ljava/lang/String;)V

    .line 748
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mCurrentChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getNumber()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setChannelName(Ljava/lang/String;)V

    const/4 v1, 0x1

    .line 749
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setDirection(I)V

    .line 750
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getTimestamp()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setTimestamp(J)V

    .line 751
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getRecordFilePath()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setFilePath(Ljava/lang/String;)V

    .line 752
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addRecordDb(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    .line 754
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->abandonAudioFocus()V

    const/4 v0, 0x0

    .line 755
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    return-void
.end method

.method public setStopRecordPrepare()V
    .locals 1

    const/4 v0, 0x0

    .line 730
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->setTalkbackRecordBg(I)V

    .line 731
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->playEndPromptTone()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 732
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->playSound()V

    .line 734
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->saveSendRecord()V

    .line 735
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->cancelLimitRecordTime()V

    .line 736
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->abandonAudioFocus()V

    return-void
.end method

.method public setTalkbackRecordBg(I)V
    .locals 2

    .line 683
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 684
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;I)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method

.method public showLimitRecordTime()V
    .locals 2

    .line 767
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 768
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda2;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method

.method public showToast(I)V
    .locals 2

    .line 507
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 508
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    .line 510
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 511
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mToast:Landroid/widget/Toast;

    .line 512
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    :cond_1
    return-void
.end method

.method public startPcmRead()V
    .locals 0

    .line 714
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->startPcmRead()V

    return-void
.end method

.method public startPcmRecord()I
    .locals 0

    .line 702
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->startPcmRecord()I

    move-result p0

    return p0
.end method

.method public stopPcmRead()V
    .locals 0

    .line 718
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->stopPcmRead()V

    return-void
.end method

.method public stopPcmRecord()V
    .locals 0

    .line 710
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mPrizePcmManager:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->stopPcmRecord()V

    return-void
.end method

.method public updateChannelId(Z)V
    .locals 2

    .line 265
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v0

    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getSetChannelState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v1

    if-ne v0, v1, :cond_0

    const-string p0, "InterPhoneTalkBackFragment"

    const-string/jumbo p1, "updateChannelId is setting channel..."

    .line 266
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 269
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 270
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$$ExternalSyntheticLambda3;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;Z)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_1
    return-void
.end method

.method public updateModuleInit()V
    .locals 0

    return-void
.end method

.method public updateTalkBackChannelList()V
    .locals 1

    .line 496
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->mUpdateUIRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public updateView()V
    .locals 0

    .line 259
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    return-void
.end method
