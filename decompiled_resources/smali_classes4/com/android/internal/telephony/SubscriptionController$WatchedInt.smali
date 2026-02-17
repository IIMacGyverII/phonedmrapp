.class public Lcom/android/internal/telephony/SubscriptionController$WatchedInt;
.super Ljava/lang/Object;
.source "SubscriptionController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SubscriptionController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "WatchedInt"
.end annotation


# instance fields
.field private mValue:I


# direct methods
.method public constructor <init>(I)V
    .locals 0

    .line 282
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 283
    iput p1, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->mValue:I

    return-void
.end method


# virtual methods
.method public get()I
    .locals 0

    .line 287
    iget p0, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->mValue:I

    return p0
.end method

.method public set(I)V
    .locals 0

    .line 291
    iput p1, p0, Lcom/android/internal/telephony/SubscriptionController$WatchedInt;->mValue:I

    return-void
.end method
