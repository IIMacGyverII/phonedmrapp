.class Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;
.super Ljava/lang/Object;
.source "GroupGridAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/GroupGridAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ViewHolder"
.end annotation


# instance fields
.field private editText:Landroid/widget/EditText;

.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;


# direct methods
.method static bridge synthetic -$$Nest$fgeteditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->editText:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputeditText(Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;Landroid/widget/EditText;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->editText:Landroid/widget/EditText;

    return-void
.end method

.method private constructor <init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)V
    .locals 0

    .line 110
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;->this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)V

    return-void
.end method
