.class public Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;
.super Ljava/lang/Object;
.source "SoundEffectPresenter.java"

# interfaces
.implements Lcom/pri/prizeinterphone/audio/ISoundEffectInterface;


# static fields
.field public static final TAG:Ljava/lang/String; = "SoundEffectPresenter"

.field private static presenter:Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;


# instance fields
.field private currentState:I

.field private mCurrentId:I

.field public mMediaPlayer:Landroid/media/MediaPlayer;

.field private mOnCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;


# direct methods
.method private constructor <init>()V
    .locals 1

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x3

    .line 24
    iput v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    const/4 v0, 0x0

    .line 26
    iput v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mCurrentId:I

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;
    .locals 1

    .line 34
    sget-object v0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->presenter:Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;

    if-nez v0, :cond_0

    .line 35
    new-instance v0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->presenter:Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;

    .line 37
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->presenter:Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;

    return-object v0
.end method


# virtual methods
.method public registComplteLisenter(Landroid/media/MediaPlayer$OnCompletionListener;)V
    .locals 0

    .line 44
    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mOnCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;

    return-void
.end method

.method public startPlaySound(Landroid/content/Context;I)V
    .locals 4

    .line 49
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "playOrPause: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "SoundEffectPresenter"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 51
    iget v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    const/4 v2, 0x3

    const/4 v3, 0x1

    if-ne v0, v2, :cond_1

    const-string v0, "playOrPause: play new music"

    .line 52
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    invoke-static {p1, p2}, Landroid/media/MediaPlayer;->create(Landroid/content/Context;I)Landroid/media/MediaPlayer;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    .line 54
    invoke-virtual {p1, v2}, Landroid/media/MediaPlayer;->setAudioStreamType(I)V

    .line 55
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/media/MediaPlayer;->setLooping(Z)V

    .line 56
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V

    .line 57
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mOnCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;

    if-eqz p1, :cond_0

    .line 58
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->setOnCompletionListener(Landroid/media/MediaPlayer$OnCompletionListener;)V

    .line 60
    :cond_0
    iput p2, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mCurrentId:I

    .line 61
    iput v3, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    goto :goto_0

    :cond_1
    const/4 v2, 0x2

    if-ne v0, v3, :cond_3

    .line 63
    iget v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mCurrentId:I

    if-eq v0, p2, :cond_2

    const-string v0, "playOrPause: stop music"

    .line 64
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 65
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->stopPlaySound()V

    .line 66
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->startPlaySound(Landroid/content/Context;I)V

    goto :goto_0

    :cond_2
    const-string p1, "playOrPause: pause music"

    .line 68
    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 69
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->pause()V

    .line 70
    iput v2, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    goto :goto_0

    :cond_3
    if-ne v0, v2, :cond_5

    .line 73
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_5

    .line 74
    iget v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mCurrentId:I

    if-eq v0, p2, :cond_4

    .line 75
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->stopPlaySound()V

    .line 76
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->startPlaySound(Landroid/content/Context;I)V

    goto :goto_0

    :cond_4
    const-string p1, "playOrPause: restart music"

    .line 78
    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 79
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {p1}, Landroid/media/MediaPlayer;->start()V

    .line 80
    iput v3, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    :cond_5
    :goto_0
    return-void
.end method

.method public stopPlaySound()V
    .locals 1

    .line 89
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_0

    .line 90
    invoke-virtual {v0}, Landroid/media/MediaPlayer;->stop()V

    const/4 v0, 0x3

    .line 91
    iput v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->currentState:I

    .line 92
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->release()V

    const/4 v0, 0x0

    .line 93
    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/SoundEffectPresenter;->mMediaPlayer:Landroid/media/MediaPlayer;

    :cond_0
    return-void
.end method
