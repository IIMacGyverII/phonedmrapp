.class public Lcom/pri/prizeinterphone/activity/RecordItem;
.super Ljava/lang/Object;
.source "RecordItem.java"


# instance fields
.field private id:I

.field private index:I

.field private isplay:Z

.field private name:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public constructor <init>(ILjava/lang/String;I)V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 13
    iput p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->index:I

    .line 14
    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->name:Ljava/lang/String;

    .line 15
    iput p3, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->id:I

    const/4 p1, 0x0

    .line 16
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->isplay:Z

    return-void
.end method


# virtual methods
.method public getId()I
    .locals 0

    .line 36
    iget p0, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->id:I

    return p0
.end method

.method public getIndex()I
    .locals 0

    .line 20
    iget p0, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->index:I

    return p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 28
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->name:Ljava/lang/String;

    return-object p0
.end method

.method public isIsplay()Z
    .locals 0

    .line 44
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->isplay:Z

    return p0
.end method

.method public setId(I)V
    .locals 0

    .line 40
    iput p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->id:I

    return-void
.end method

.method public setIndex(I)V
    .locals 0

    .line 24
    iput p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->index:I

    return-void
.end method

.method public setIsplay(Z)V
    .locals 0

    .line 48
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->isplay:Z

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 32
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordItem;->name:Ljava/lang/String;

    return-void
.end method
