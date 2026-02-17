.class public Lcom/mediatek/widget/AccountItemView;
.super Landroid/widget/LinearLayout;
.source "AccountItemView.java"


# instance fields
.field private mAccountIcon:Landroid/widget/ImageView;

.field private mAccountName:Landroid/widget/TextView;

.field private mAccountNumber:Landroid/widget/TextView;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 46
    invoke-direct {p0, p1, v0}, Lcom/mediatek/widget/AccountItemView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    .line 54
    invoke-direct {p0, p1, p2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    const-string p2, "layout_inflater"

    .line 56
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/LayoutInflater;

    const p2, 0x80d0021

    const/4 v0, 0x0

    .line 57
    invoke-virtual {p1, p2, v0}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    .line 58
    invoke-virtual {p0, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 59
    invoke-direct {p0, p1}, Lcom/mediatek/widget/AccountItemView;->initViewItem(Landroid/view/View;)V

    return-void
.end method

.method private initViewItem(Landroid/view/View;)V
    .locals 1

    const v0, 0x1020006

    .line 63
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountIcon:Landroid/widget/ImageView;

    const v0, 0x1020016

    .line 64
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountName:Landroid/widget/TextView;

    const v0, 0x1020010

    .line 65
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/mediatek/widget/AccountItemView;->mAccountNumber:Landroid/widget/TextView;

    return-void
.end method

.method private setText(Landroid/widget/TextView;Ljava/lang/String;)V
    .locals 0

    .line 113
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/16 p0, 0x8

    .line 114
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_0

    .line 116
    :cond_0
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p0, 0x0

    .line 117
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setVisibility(I)V

    :goto_0
    return-void
.end method


# virtual methods
.method public setAccountIcon(I)V
    .locals 0

    .line 88
    iget-object p0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountIcon:Landroid/widget/ImageView;

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageResource(I)V

    return-void
.end method

.method public setAccountIcon(Landroid/graphics/drawable/Drawable;)V
    .locals 0

    .line 95
    iget-object p0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountIcon:Landroid/widget/ImageView;

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    return-void
.end method

.method public setAccountName(Ljava/lang/String;)V
    .locals 1

    .line 102
    iget-object v0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountName:Landroid/widget/TextView;

    invoke-direct {p0, v0, p1}, Lcom/mediatek/widget/AccountItemView;->setText(Landroid/widget/TextView;Ljava/lang/String;)V

    return-void
.end method

.method public setAccountNumber(Ljava/lang/String;)V
    .locals 1

    .line 109
    iget-object v0, p0, Lcom/mediatek/widget/AccountItemView;->mAccountNumber:Landroid/widget/TextView;

    invoke-direct {p0, v0, p1}, Lcom/mediatek/widget/AccountItemView;->setText(Landroid/widget/TextView;Ljava/lang/String;)V

    return-void
.end method

.method public setViewItem(Lcom/mediatek/widget/AccountViewAdapter$AccountElements;)V
    .locals 1

    .line 74
    invoke-virtual {p1}, Lcom/mediatek/widget/AccountViewAdapter$AccountElements;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 76
    invoke-virtual {p0, v0}, Lcom/mediatek/widget/AccountItemView;->setAccountIcon(Landroid/graphics/drawable/Drawable;)V

    goto :goto_0

    .line 78
    :cond_0
    invoke-virtual {p1}, Lcom/mediatek/widget/AccountViewAdapter$AccountElements;->getIcon()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/mediatek/widget/AccountItemView;->setAccountIcon(I)V

    .line 80
    :goto_0
    invoke-virtual {p1}, Lcom/mediatek/widget/AccountViewAdapter$AccountElements;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/mediatek/widget/AccountItemView;->setAccountName(Ljava/lang/String;)V

    .line 81
    invoke-virtual {p1}, Lcom/mediatek/widget/AccountViewAdapter$AccountElements;->getNumber()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/mediatek/widget/AccountItemView;->setAccountNumber(Ljava/lang/String;)V

    return-void
.end method
