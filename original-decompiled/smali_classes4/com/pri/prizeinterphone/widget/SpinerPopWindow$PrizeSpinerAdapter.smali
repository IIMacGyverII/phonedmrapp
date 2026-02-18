.class Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;
.super Landroid/widget/BaseAdapter;
.source "SpinerPopWindow.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/widget/SpinerPopWindow;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "PrizeSpinerAdapter"
.end annotation


# instance fields
.field private mInflater:Landroid/view/LayoutInflater;

.field final synthetic this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;Landroid/content/Context;)V
    .locals 0

    .line 79
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    const-string p1, "layout_inflater"

    .line 80
    invoke-virtual {p2, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/LayoutInflater;

    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->mInflater:Landroid/view/LayoutInflater;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 85
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmDataList(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    return p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 0

    .line 90
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmDataList(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public getItemId(I)J
    .locals 0

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 1

    if-nez p2, :cond_0

    .line 103
    iget-object p2, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->mInflater:Landroid/view/LayoutInflater;

    const p3, 0x7f0c0053

    const/4 v0, 0x0

    invoke-virtual {p2, p3, v0}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    .line 104
    new-instance p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;

    invoke-direct {p3}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;-><init>()V

    const v0, 0x7f09012f

    .line 105
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mTvValue:Landroid/widget/TextView;

    const v0, 0x7f09012d

    .line 106
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mImgSeleted:Landroid/widget/ImageView;

    const v0, 0x7f09012e

    .line 107
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mLine:Landroid/view/View;

    .line 108
    invoke-virtual {p2, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 110
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;

    .line 113
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {v0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmDataList(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    .line 114
    iget-object v0, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mTvValue:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 115
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {v0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmCurrentSeleted(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {v0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmCurrentSeleted(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 116
    iget-object p1, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mImgSeleted:Landroid/widget/ImageView;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setSelected(Z)V

    goto :goto_1

    .line 118
    :cond_1
    iget-object p1, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mImgSeleted:Landroid/widget/ImageView;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setSelected(Z)V

    .line 121
    :goto_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->isNotShowSelect()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 122
    iget-object p1, p3, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;->mImgSeleted:Landroid/widget/ImageView;

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;->this$0:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-static {p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->-$$Nest$fgetmContext(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Landroid/content/Context;

    move-result-object p0

    const p3, 0x7f0800b9

    invoke-virtual {p0, p3}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :cond_2
    return-object p2
.end method
