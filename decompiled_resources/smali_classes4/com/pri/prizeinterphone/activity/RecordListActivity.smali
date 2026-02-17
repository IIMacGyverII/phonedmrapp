.class public Lcom/pri/prizeinterphone/activity/RecordListActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "RecordListActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;,
        Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;
    }
.end annotation


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_RecordListActivity"


# instance fields
.field private deleteList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
            ">;"
        }
    .end annotation
.end field

.field private deleteSelect:Landroid/widget/ImageButton;

.field private mToast:Landroid/widget/Toast;

.field private pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

.field private recordAdapter:Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

.field private recordItemList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
            ">;"
        }
    .end annotation
.end field

.field private recordList:Landroidx/recyclerview/widget/RecyclerView;

.field private selectAll:Landroid/widget/CheckBox;


# direct methods
.method static bridge synthetic -$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->deleteList:Ljava/util/List;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetrecordAdapter(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordAdapter:Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordItemList:Ljava/util/List;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetselectAll(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Landroid/widget/CheckBox;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->selectAll:Landroid/widget/CheckBox;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->deleteList:Ljava/util/List;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordItemList:Ljava/util/List;

    return-void
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/RecordListActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->showToast(I)V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 32
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private isTalkSend()Z
    .locals 2

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 243
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    move v1, v0

    :cond_0
    return v1
.end method

.method private showToast(I)V
    .locals 1

    .line 235
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 236
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 238
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->mToast:Landroid/widget/Toast;

    .line 239
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method public static timetodate(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 219
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v0

    .line 220
    invoke-static {p0}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/util/Calendar;->setTimeInMillis(J)V

    .line 221
    new-instance p0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyy-MM-dd HH:mm:ss"

    invoke-direct {p0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 222
    invoke-virtual {v0}, Ljava/util/Calendar;->getTime()Ljava/util/Date;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 44
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c001d

    .line 45
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    const p1, 0x7f090287

    .line 47
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    const v0, 0x7f110114

    .line 48
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    const p1, 0x7f090217

    .line 50
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroidx/recyclerview/widget/RecyclerView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordList:Landroidx/recyclerview/widget/RecyclerView;

    .line 51
    new-instance p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordAdapter:Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    .line 52
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordList:Landroidx/recyclerview/widget/RecyclerView;

    new-instance v0, Landroidx/recyclerview/widget/LinearLayoutManager;

    invoke-direct {v0, p0}, Landroidx/recyclerview/widget/LinearLayoutManager;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, v0}, Landroidx/recyclerview/widget/RecyclerView;->setLayoutManager(Landroidx/recyclerview/widget/RecyclerView$LayoutManager;)V

    .line 53
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordList:Landroidx/recyclerview/widget/RecyclerView;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->recordAdapter:Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    invoke-virtual {p1, v0}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V

    const p1, 0x7f090096

    .line 55
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageButton;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->deleteSelect:Landroid/widget/ImageButton;

    const p1, 0x7f09023a

    .line 56
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/CheckBox;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->selectAll:Landroid/widget/CheckBox;

    .line 57
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->deleteSelect:Landroid/widget/ImageButton;

    new-instance v0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/ImageButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 69
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->selectAll:Landroid/widget/CheckBox;

    new-instance v0, Lcom/pri/prizeinterphone/activity/RecordListActivity$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    return-void
.end method

.method protected onStop()V
    .locals 0

    .line 84
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    .line 85
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->stopPlayAudio()V

    return-void
.end method

.method public startPlayAudio(Ljava/lang/String;)V
    .locals 1

    .line 97
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    if-nez v0, :cond_0

    .line 98
    new-instance v0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    .line 100
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->startPlay(Ljava/lang/String;)V

    return-void
.end method

.method public stopPlayAudio()V
    .locals 1

    .line 89
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    if-eqz v0, :cond_0

    .line 90
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->stopPlay()V

    .line 91
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->release()V

    const/4 v0, 0x0

    .line 92
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity;->pcmAudioPlayer:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    :cond_0
    return-void
.end method
