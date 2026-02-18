.class public abstract Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;
.super Ljava/lang/Object;
.source "OverScrollBounceEffectDecoratorBase.java"

# interfaces
.implements Lcom/pri/support/common/IOverScrollDecor;
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;,
        Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;
    }
.end annotation


# static fields
.field private static final MAX_OVER_SCROLL_OFFSET_FACTOR:F = 0.5f

.field private static final TAG:Ljava/lang/String; = "OSBounceEffectDeBase"


# instance fields
.field private final mBounceBackState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

.field private mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

.field private mEnableOverScrollEffect:Z

.field private final mIdleState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

.field private final mOverScrollingState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

.field private final mStartAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

.field private mStateListener:Lcom/pri/support/common/IOverScrollStateListener;

.field private mUpdateListener:Lcom/pri/support/common/IOverScrollUpdateListener;

.field private final mViewAdapter:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;


# direct methods
.method protected constructor <init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;FFF)V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p4, 0x1

    .line 16
    iput-boolean p4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mEnableOverScrollEffect:Z

    .line 20
    new-instance p4, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    invoke-direct {p4}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;-><init>()V

    iput-object p4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mStartAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    .line 23
    new-instance p4, Lcom/pri/support/common/ListenerStubs$OverScrollStateListenerStub;

    invoke-direct {p4}, Lcom/pri/support/common/ListenerStubs$OverScrollStateListenerStub;-><init>()V

    iput-object p4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mStateListener:Lcom/pri/support/common/IOverScrollStateListener;

    .line 24
    new-instance p4, Lcom/pri/support/common/ListenerStubs$OverScrollUpdateListenerStub;

    invoke-direct {p4}, Lcom/pri/support/common/ListenerStubs$OverScrollUpdateListenerStub;-><init>()V

    iput-object p4, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mUpdateListener:Lcom/pri/support/common/IOverScrollUpdateListener;

    .line 31
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mViewAdapter:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;

    .line 33
    new-instance p1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    invoke-direct {p1, p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;-><init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)V

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mBounceBackState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    .line 34
    new-instance p1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

    invoke-direct {p1, p0, p2, p3}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;-><init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;FF)V

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mOverScrollingState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

    .line 35
    new-instance p1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    invoke-direct {p1, p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;-><init>(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)V

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mIdleState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    .line 36
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    .line 37
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->attach()V

    return-void
.end method

.method static synthetic access$000(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mViewAdapter:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;

    return-object p0
.end method

.method static synthetic access$100(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mStartAttr:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollStartAttributes;

    return-object p0
.end method

.method static synthetic access$200(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mOverScrollingState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$OverScrollingState;

    return-object p0
.end method

.method static synthetic access$300(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollStateListener;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mStateListener:Lcom/pri/support/common/IOverScrollStateListener;

    return-object p0
.end method

.method static synthetic access$400(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mBounceBackState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    return-object p0
.end method

.method static synthetic access$500(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/IOverScrollUpdateListener;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mUpdateListener:Lcom/pri/support/common/IOverScrollUpdateListener;

    return-object p0
.end method

.method static synthetic access$600(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;)Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;
    .locals 0

    .line 14
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mIdleState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    return-object p0
.end method

.method public static stateToString(I)Ljava/lang/String;
    .locals 1

    if-eqz p0, :cond_4

    const/4 v0, 0x1

    if-eq p0, v0, :cond_3

    const/4 v0, 0x2

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v0, 0x4

    if-eq p0, v0, :cond_0

    const-string/jumbo p0, "unknown"

    goto :goto_0

    :cond_0
    const-string p0, "bounceBack"

    goto :goto_0

    :cond_1
    const-string p0, "dragStartEnd"

    goto :goto_0

    :cond_2
    const-string p0, "dragStartSlide"

    goto :goto_0

    :cond_3
    const-string p0, "drag"

    goto :goto_0

    :cond_4
    const-string p0, "idle"

    :goto_0
    return-object p0
.end method


# virtual methods
.method protected attach()V
    .locals 1

    .line 143
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 144
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object p0

    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Landroid/view/View;->setOverScrollMode(I)V

    return-void
.end method

.method protected abstract createAnimationAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$AnimationAttributes;
.end method

.method protected abstract createMotionAttributes()Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$MotionAttributes;
.end method

.method protected deAttach()V
    .locals 1

    .line 148
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object p0

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    return-void
.end method

.method protected abstract getTranslateValue(Landroid/view/View;)F
.end method

.method public getView()Landroid/view/View;
    .locals 0

    .line 129
    iget-object p0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mViewAdapter:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;

    invoke-interface {p0}, Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;->getView()Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 2

    .line 93
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    .line 94
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    const/4 v1, 0x1

    if-eq p1, v1, :cond_1

    const/4 v1, 0x2

    if-eq p1, v1, :cond_0

    const/4 v1, 0x3

    if-eq p1, v1, :cond_1

    const/4 p0, 0x0

    goto :goto_0

    .line 99
    :cond_0
    invoke-interface {v0, p2}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->handleMoveTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    goto :goto_0

    .line 104
    :cond_1
    invoke-interface {v0, p2}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->handleUpOrCancelTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p1

    .line 107
    iget-object p2, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mIdleState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    if-ne p2, v0, :cond_2

    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getView()Landroid/view/View;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->getTranslateValue(Landroid/view/View;)F

    move-result p2

    invoke-virtual {v0, p2}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;->isNonOriginalOffset(F)Z

    move-result p2

    if-eqz p2, :cond_2

    .line 110
    iget-object p2, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mBounceBackState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$BounceBackState;

    invoke-virtual {p0, p2}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    :cond_2
    move p0, p1

    :goto_0
    return p0
.end method

.method public setEnableOverScrollEffect(Z)V
    .locals 0

    if-eqz p1, :cond_0

    .line 83
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->attach()V

    goto :goto_0

    .line 85
    :cond_0
    invoke-virtual {p0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->deAttach()V

    .line 86
    iget-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mIdleState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IdleState;

    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    :goto_0
    return-void
.end method

.method protected transitToState(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V
    .locals 1

    .line 133
    iget-object v0, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    if-eq p1, v0, :cond_0

    .line 135
    iput-object p1, p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;->mCurrentState:Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;

    .line 138
    invoke-interface {p1, v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;->handleEntryTransition(Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$IDecoratorState;)V

    :cond_0
    return-void
.end method

.method protected abstract translateView(Landroid/view/View;F)V
.end method

.method protected abstract translateViewAndEvent(Landroid/view/View;FLandroid/view/MotionEvent;)V
.end method
