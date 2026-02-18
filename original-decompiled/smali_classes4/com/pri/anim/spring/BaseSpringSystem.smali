.class public Lcom/pri/anim/spring/BaseSpringSystem;
.super Ljava/lang/Object;
.source "BaseSpringSystem.java"


# instance fields
.field private final mActiveSprings:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/pri/anim/spring/Spring;",
            ">;"
        }
    .end annotation
.end field

.field private mIdle:Z

.field private final mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/CopyOnWriteArraySet<",
            "Lcom/pri/anim/spring/SpringSystemListener;",
            ">;"
        }
    .end annotation
.end field

.field private final mSpringLooper:Lcom/pri/anim/spring/SpringLooper;

.field private final mSpringRegistry:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/pri/anim/spring/Spring;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Lcom/pri/anim/spring/SpringLooper;)V
    .locals 1

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 21
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    .line 22
    new-instance v0, Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-direct {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;-><init>()V

    iput-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    .line 24
    new-instance v0, Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-direct {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;-><init>()V

    iput-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    const/4 v0, 0x1

    .line 25
    iput-boolean v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mIdle:Z

    if-eqz p1, :cond_0

    .line 36
    iput-object p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringLooper:Lcom/pri/anim/spring/SpringLooper;

    .line 37
    invoke-virtual {p1, p0}, Lcom/pri/anim/spring/SpringLooper;->setSpringSystem(Lcom/pri/anim/spring/BaseSpringSystem;)V

    return-void

    .line 34
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo p1, "springLooper is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method activateSpring(Ljava/lang/String;)V
    .locals 2

    .line 153
    iget-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/anim/spring/Spring;

    if-eqz v0, :cond_1

    .line 157
    iget-object p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    invoke-interface {p1, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 158
    invoke-virtual {p0}, Lcom/pri/anim/spring/BaseSpringSystem;->getIsIdle()Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x0

    .line 159
    iput-boolean p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mIdle:Z

    .line 160
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringLooper:Lcom/pri/anim/spring/SpringLooper;

    invoke-virtual {p0}, Lcom/pri/anim/spring/SpringLooper;->start()V

    :cond_0
    return-void

    .line 155
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "springId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " does not reference a registered com.pri.anim.com.pri.anim.spring.com.pri.anim.spring"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public addListener(Lcom/pri/anim/spring/SpringSystemListener;)V
    .locals 0

    if-eqz p1, :cond_0

    .line 170
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p0, p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->add(Ljava/lang/Object;)Z

    return-void

    .line 168
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "newListener is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method advance(D)V
    .locals 4

    .line 117
    iget-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/anim/spring/Spring;

    .line 119
    invoke-virtual {v1}, Lcom/pri/anim/spring/Spring;->systemShouldAdvance()Z

    move-result v2

    if-eqz v2, :cond_0

    const-wide v2, 0x408f400000000000L    # 1000.0

    div-double v2, p1, v2

    .line 120
    invoke-virtual {v1, v2, v3}, Lcom/pri/anim/spring/Spring;->advance(D)V

    goto :goto_0

    .line 122
    :cond_0
    iget-object v2, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    invoke-interface {v2, v1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    return-void
.end method

.method public createSpring()Lcom/pri/anim/spring/Spring;
    .locals 1

    .line 53
    new-instance v0, Lcom/pri/anim/spring/Spring;

    invoke-direct {v0, p0}, Lcom/pri/anim/spring/Spring;-><init>(Lcom/pri/anim/spring/BaseSpringSystem;)V

    .line 54
    invoke-virtual {p0, v0}, Lcom/pri/anim/spring/BaseSpringSystem;->registerSpring(Lcom/pri/anim/spring/Spring;)V

    return-object v0
.end method

.method deregisterSpring(Lcom/pri/anim/spring/Spring;)V
    .locals 1

    if-eqz p1, :cond_0

    .line 108
    iget-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 109
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    return-void

    .line 106
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public getAllSprings()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/pri/anim/spring/Spring;",
            ">;"
        }
    .end annotation

    .line 75
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    .line 77
    instance-of v0, p0, Ljava/util/List;

    if-eqz v0, :cond_0

    .line 78
    check-cast p0, Ljava/util/List;

    goto :goto_0

    .line 80
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    move-object p0, v0

    .line 82
    :goto_0
    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getIsIdle()Z
    .locals 0

    .line 45
    iget-boolean p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mIdle:Z

    return p0
.end method

.method public getSpringById(Ljava/lang/String;)Lcom/pri/anim/spring/Spring;
    .locals 0

    if-eqz p1, :cond_0

    .line 67
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/anim/spring/Spring;

    return-object p0

    .line 65
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "id is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public loop(D)V
    .locals 2

    .line 131
    iget-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/anim/spring/SpringSystemListener;

    .line 132
    invoke-interface {v1, p0}, Lcom/pri/anim/spring/SpringSystemListener;->onBeforeIntegrate(Lcom/pri/anim/spring/BaseSpringSystem;)V

    goto :goto_0

    .line 134
    :cond_0
    invoke-virtual {p0, p1, p2}, Lcom/pri/anim/spring/BaseSpringSystem;->advance(D)V

    .line 135
    iget-object p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mActiveSprings:Ljava/util/Set;

    invoke-interface {p1}, Ljava/util/Set;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    .line 136
    iput-boolean p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mIdle:Z

    .line 138
    :cond_1
    iget-object p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/anim/spring/SpringSystemListener;

    .line 139
    invoke-interface {p2, p0}, Lcom/pri/anim/spring/SpringSystemListener;->onAfterIntegrate(Lcom/pri/anim/spring/BaseSpringSystem;)V

    goto :goto_1

    .line 141
    :cond_2
    iget-boolean p1, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mIdle:Z

    if-eqz p1, :cond_3

    .line 142
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringLooper:Lcom/pri/anim/spring/SpringLooper;

    invoke-virtual {p0}, Lcom/pri/anim/spring/SpringLooper;->stop()V

    :cond_3
    return-void
.end method

.method registerSpring(Lcom/pri/anim/spring/Spring;)V
    .locals 2

    if-eqz p1, :cond_1

    .line 93
    iget-object v0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 95
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mSpringRegistry:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void

    .line 94
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is already registered"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 91
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public removeAllListeners()V
    .locals 0

    .line 181
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p0}, Ljava/util/concurrent/CopyOnWriteArraySet;->clear()V

    return-void
.end method

.method public removeListener(Lcom/pri/anim/spring/SpringSystemListener;)V
    .locals 0

    if-eqz p1, :cond_0

    .line 177
    iget-object p0, p0, Lcom/pri/anim/spring/BaseSpringSystem;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p0, p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->remove(Ljava/lang/Object;)Z

    return-void

    .line 175
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "listenerToRemove is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
