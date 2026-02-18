.class public Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;
.super Ljava/lang/Object;
.source "SubscriptionController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SubscriptionController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "WatchedSlotIndexToSubIds"
.end annotation


# instance fields
.field private mSlotIndexToSubIds:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>()V
    .locals 1

    .line 193
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 191
    new-instance v0, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    return-void
.end method


# virtual methods
.method public addToSubIdList(ILjava/lang/Integer;)V
    .locals 2

    .line 257
    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/ArrayList;

    if-nez v0, :cond_0

    .line 259
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 260
    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 261
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 263
    :cond_0
    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 265
    :goto_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 266
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    return-void
.end method

.method public clear()V
    .locals 0

    .line 197
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->clear()V

    .line 198
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 199
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    return-void
.end method

.method public clearSubIdList(I)V
    .locals 0

    .line 270
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/ArrayList;

    if-eqz p0, :cond_0

    .line 272
    invoke-virtual {p0}, Ljava/util/ArrayList;->clear()V

    .line 273
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 274
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    :cond_0
    return-void
.end method

.method public entrySet()Ljava/util/Set;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/util/Map$Entry<",
            "Ljava/lang/Integer;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;>;>;"
        }
    .end annotation

    .line 203
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p0

    return-object p0
.end method

.method public getCopy(I)Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 208
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/ArrayList;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 213
    :cond_0
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object p1
.end method

.method public getMap()Ljava/util/Map;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation

    .line 234
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    return-object p0
.end method

.method public put(ILjava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/ArrayList<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 217
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 218
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 219
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    return-void
.end method

.method public remove(I)V
    .locals 0

    .line 223
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 224
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 225
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    return-void
.end method

.method public removeFromSubIdList(II)I
    .locals 2

    .line 238
    iget-object v0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/ArrayList;

    if-nez v0, :cond_0

    const/4 p0, -0x1

    return p0

    .line 242
    :cond_0
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 243
    new-instance v1, Ljava/lang/Integer;

    invoke-direct {v1, p2}, Ljava/lang/Integer;-><init>(I)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 244
    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_1

    .line 245
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 247
    :cond_1
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->-$$Nest$sminvalidateDefaultSubIdCaches()V

    .line 248
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->invalidateSlotIndexCaches()V

    const/4 p0, 0x1

    return p0

    :cond_2
    const/4 p0, -0x2

    return p0
.end method

.method public size()I
    .locals 0

    .line 229
    iget-object p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedSlotIndexToSubIds;->mSlotIndexToSubIds:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->size()I

    move-result p0

    return p0
.end method
