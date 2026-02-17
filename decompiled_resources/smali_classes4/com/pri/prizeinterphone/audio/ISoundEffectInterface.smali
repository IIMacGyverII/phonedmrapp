.class public interface abstract Lcom/pri/prizeinterphone/audio/ISoundEffectInterface;
.super Ljava/lang/Object;
.source "ISoundEffectInterface.java"


# static fields
.field public static final PLAYER_STATE_PAUSE:I = 0x2

.field public static final PLAYER_STATE_PLAY:I = 0x1

.field public static final PLAYER_STATE_STOP:I = 0x3


# virtual methods
.method public abstract registComplteLisenter(Landroid/media/MediaPlayer$OnCompletionListener;)V
.end method

.method public abstract startPlaySound(Landroid/content/Context;I)V
.end method

.method public abstract stopPlaySound()V
.end method
