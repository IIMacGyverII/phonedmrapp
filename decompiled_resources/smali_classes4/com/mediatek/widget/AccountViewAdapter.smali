.class public Lcom/mediatek/widget/AccountViewAdapter;
.super Landroid/widget/BaseAdapter;
.source "AccountViewAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/widget/AccountViewAdapter$AccountElements;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field private mData:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/widget/AccountViewAdapter$AccountElements;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List<",
            "Lcom/mediatek/widget/AccountViewAdapter$AccountElements;",
            ">;)V"
        }
    .end annotation

    .line 42
    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    .line 43
    iput-object p1, p0, Lcom/mediatek/widget/AccountViewAdapter;->mContext:Landroid/content/Context;

    .line 44
    iput-object p2, p0, Lcom/mediatek/widget/AccountViewAdapter;->mData:Ljava/util/List;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 49
    iget-object p0, p0, Lcom/mediatek/widget/AccountViewAdapter;->mData:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 0

    .line 54
    iget-object p0, p0, Lcom/mediatek/widget/AccountViewAdapter;->mData:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public getItemId(I)J
    .locals 0

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 0

    if-nez p2, :cond_0

    .line 76
    new-instance p2, Lcom/mediatek/widget/AccountItemView;

    iget-object p3, p0, Lcom/mediatek/widget/AccountViewAdapter;->mContext:Landroid/content/Context;

    invoke-direct {p2, p3}, Lcom/mediatek/widget/AccountItemView;-><init>(Landroid/content/Context;)V

    goto :goto_0

    .line 78
    :cond_0
    check-cast p2, Lcom/mediatek/widget/AccountItemView;

    .line 80
    :goto_0
    invoke-virtual {p0, p1}, Lcom/mediatek/widget/AccountViewAdapter;->getItem(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/mediatek/widget/AccountViewAdapter$AccountElements;

    .line 81
    invoke-virtual {p2, p0}, Lcom/mediatek/widget/AccountItemView;->setViewItem(Lcom/mediatek/widget/AccountViewAdapter$AccountElements;)V

    return-object p2
.end method

.method public updateData(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/mediatek/widget/AccountViewAdapter$AccountElements;",
            ">;)V"
        }
    .end annotation

    .line 68
    iput-object p1, p0, Lcom/mediatek/widget/AccountViewAdapter;->mData:Ljava/util/List;

    .line 69
    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    return-void
.end method
