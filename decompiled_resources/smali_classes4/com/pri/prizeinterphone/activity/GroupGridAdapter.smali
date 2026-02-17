.class public Lcom/pri/prizeinterphone/activity/GroupGridAdapter;
.super Landroid/widget/BaseAdapter;
.source "GroupGridAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "GroupGridAdapter"


# instance fields
.field private activity:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

.field public grouplist:[I

.field private inflater:Landroid/view/LayoutInflater;


# direct methods
.method static bridge synthetic -$$Nest$fgetactivity(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->activity:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    return-object p0
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;[I)V
    .locals 2

    .line 23
    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 20
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    const-string v0, "GroupGridAdapter"

    const-string v1, "GroupGridAdapter()"

    .line 24
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 25
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->activity:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    .line 26
    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->inflater:Landroid/view/LayoutInflater;

    .line 27
    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    .line 28
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 3

    .line 33
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    if-nez v0, :cond_0

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 34
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    const/4 v1, 0x0

    .line 35
    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 36
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    const/4 v2, 0x1

    aput v2, v0, v1

    :cond_0
    const-string v0, "GroupGridAdapter"

    const-string v1, "getCount()"

    .line 38
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 39
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    array-length p0, p0

    return p0
.end method

.method public getGroupList()[I
    .locals 0

    .line 107
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    return-object p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 2

    const-string v0, "GroupGridAdapter"

    const-string v1, "getItem()"

    .line 45
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 46
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    aget p0, p0, p1

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method public getItemId(I)J
    .locals 1

    const-string p0, "GroupGridAdapter"

    const-string v0, "getItemId()"

    .line 51
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 4

    const-string v0, "GroupGridAdapter"

    const-string v1, "getView()"

    .line 58
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-nez p2, :cond_0

    .line 61
    new-instance p2, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;

    const/4 v0, 0x0

    invoke-direct {p2, p0, v0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder-IA;)V

    .line 62
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->inflater:Landroid/view/LayoutInflater;

    const v1, 0x7f0c0051

    const/4 v2, 0x0

    invoke-virtual {v0, v1, p3, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p3

    const v0, 0x7f09011a

    .line 63
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->-$$Nest$fputeditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;Landroid/widget/EditText;)V

    .line 64
    invoke-virtual {p3, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 66
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;

    move-object v3, p3

    move-object p3, p2

    move-object p2, v3

    .line 69
    :goto_0
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->-$$Nest$fgeteditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;)Landroid/widget/EditText;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    aget v2, v2, p1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 70
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->-$$Nest$fgeteditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;)Landroid/widget/EditText;

    move-result-object v0

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    .line 71
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->-$$Nest$fgeteditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;)Landroid/widget/EditText;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$1;-><init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 80
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->-$$Nest$fgeteditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;)Landroid/widget/EditText;

    move-result-object p2

    new-instance v0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;

    invoke-direct {v0, p0, p1}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;-><init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;I)V

    invoke-virtual {p2, v0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    return-object p3
.end method

.method public updateData(II)V
    .locals 0

    .line 103
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->grouplist:[I

    aput p2, p0, p1

    return-void
.end method
