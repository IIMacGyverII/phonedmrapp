.class public Lcom/pri/prizeinterphone/widget/SpinerPopWindow;
.super Landroid/widget/PopupWindow;
.source "SpinerPopWindow.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;,
        Lcom/pri/prizeinterphone/widget/SpinerPopWindow$ViewHolder;,
        Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;
    }
.end annotation


# instance fields
.field private mAdapter:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;

.field private mContext:Landroid/content/Context;

.field private mCurrentSeleted:Ljava/lang/String;

.field private mDataList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mListView:Landroid/widget/ListView;

.field private mPrizeOnItemClickListener:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;

.field public notShowSelect:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetmContext(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentSeleted(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mCurrentSeleted:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataList(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mDataList:Ljava/util/ArrayList;

    return-object p0
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 31
    invoke-direct {p0, p1}, Landroid/widget/PopupWindow;-><init>(Landroid/content/Context;)V

    const/4 v0, 0x0

    .line 70
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->notShowSelect:Z

    .line 32
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mContext:Landroid/content/Context;

    .line 33
    invoke-direct {p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->init()V

    return-void
.end method

.method private init()V
    .locals 3

    .line 37
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0052

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 38
    invoke-virtual {p0, v0}, Landroid/widget/PopupWindow;->setContentView(Landroid/view/View;)V

    const/4 v1, -0x2

    .line 39
    invoke-virtual {p0, v1}, Landroid/widget/PopupWindow;->setWidth(I)V

    .line 40
    invoke-virtual {p0, v1}, Landroid/widget/PopupWindow;->setHeight(I)V

    const/4 v1, 0x1

    .line 42
    invoke-virtual {p0, v1}, Landroid/widget/PopupWindow;->setFocusable(Z)V

    .line 43
    new-instance v1, Landroid/graphics/drawable/ColorDrawable;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    .line 44
    invoke-virtual {p0, v1}, Landroid/widget/PopupWindow;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const v1, 0x7f09011d

    .line 47
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mListView:Landroid/widget/ListView;

    .line 49
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mDataList:Ljava/util/ArrayList;

    .line 50
    new-instance v0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mContext:Landroid/content/Context;

    invoke-direct {v0, p0, v1}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;-><init>(Lcom/pri/prizeinterphone/widget/SpinerPopWindow;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mAdapter:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;

    .line 51
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 52
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mListView:Landroid/widget/ListView;

    invoke-virtual {v0, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    return-void
.end method


# virtual methods
.method public isNotShowSelect()Z
    .locals 0

    .line 72
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->notShowSelect:Z

    return p0
.end method

.method public onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    .line 67
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mPrizeOnItemClickListener:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mDataList:Ljava/util/ArrayList;

    invoke-virtual {p0, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-interface {p1, p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;->setOnItemClick(Ljava/lang/String;)V

    return-void
.end method

.method public refreshData(Ljava/util/ArrayList;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 60
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mDataList:Ljava/util/ArrayList;

    .line 61
    iput-object p2, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mCurrentSeleted:Ljava/lang/String;

    .line 62
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mAdapter:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeSpinerAdapter;

    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    return-void
.end method

.method public setNotShowSelect(Z)V
    .locals 0

    .line 75
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->notShowSelect:Z

    return-void
.end method

.method public setPrizeOnItemClickListener(Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;)V
    .locals 0

    .line 56
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->mPrizeOnItemClickListener:Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;

    return-void
.end method
