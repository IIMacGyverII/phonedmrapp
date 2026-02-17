.class public Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;
.super Landroidx/recyclerview/widget/RecyclerView$Adapter;
.source "RecordListActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/RecordListActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "AudioListAdapter"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/recyclerview/widget/RecyclerView$Adapter<",
        "Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;


# direct methods
.method public static synthetic $r8$lambda$8BOUsnha_KVbkzvuPWnB3425uTI(Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;ILandroid/widget/CompoundButton;Z)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->lambda$onBindViewHolder$0(ILandroid/widget/CompoundButton;Z)V

    return-void
.end method

.method public static synthetic $r8$lambda$Mhm7ksEzuVBnttCOOVnqnNsAiQ4(Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;ILandroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->lambda$onBindViewHolder$1(ILandroid/view/View;)V

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;)V
    .locals 0

    .line 124
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-direct {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;-><init>()V

    .line 125
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllRecordList()Ljava/util/ArrayList;

    move-result-object p0

    invoke-static {p1, p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fputrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V

    .line 126
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {p1, p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fputdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V

    return-void
.end method

.method private addToDeleteList(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V
    .locals 0

    .line 183
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private synthetic lambda$onBindViewHolder$0(ILandroid/widget/CompoundButton;Z)V
    .locals 0

    if-eqz p3, :cond_0

    .line 152
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->addToDeleteList(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    goto :goto_0

    .line 154
    :cond_0
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->unSelectFromDelete(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    :goto_0
    return-void
.end method

.method private synthetic lambda$onBindViewHolder$1(ILandroid/view/View;)V
    .locals 3

    .line 160
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->stopPlayAudio()V

    .line 161
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getFilePath()Ljava/lang/String;

    move-result-object p2

    .line 162
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "click filePath="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_RecordListActivity"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 163
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "click position="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 164
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p2

    if-nez p2, :cond_0

    new-instance p2, Ljava/io/File;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getFilePath()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p2, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2}, Ljava/io/File;->exists()Z

    move-result p2

    if-eqz p2, :cond_0

    .line 165
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Z

    move-result p2

    if-nez p2, :cond_1

    .line 166
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p2

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getFilePath()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->startPlayAudio(Ljava/lang/String;)V

    goto :goto_0

    .line 169
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p2

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {p2, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteRecordFile(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    .line 170
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p2

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllRecordList()Ljava/util/ArrayList;

    move-result-object p2

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fputrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V

    .line 171
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V

    .line 172
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    const p1, 0x7f110184

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/RecordListActivity;I)V

    :cond_1
    :goto_0
    return-void
.end method

.method private unSelectFromDelete(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V
    .locals 0

    .line 187
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method


# virtual methods
.method public deleteSelectFiles()V
    .locals 3

    .line 191
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_2

    .line 192
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->stopPlayAudio()V

    const/4 v0, 0x0

    .line 193
    :goto_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 194
    new-instance v1, Ljava/io/File;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getFilePath()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 195
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 196
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 198
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteRecordFile(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 200
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllRecordList()Ljava/util/ArrayList;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fputrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;Ljava/util/List;)V

    .line 201
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V

    .line 202
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    const v0, 0x7f110185

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/RecordListActivity;I)V

    :cond_2
    return-void
.end method

.method public getItemCount()I
    .locals 0

    .line 179
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public bridge synthetic onBindViewHolder(Landroidx/recyclerview/widget/RecyclerView$ViewHolder;I)V
    .locals 0

    .line 123
    check-cast p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->onBindViewHolder(Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;I)V

    return-void
.end method

.method public onBindViewHolder(Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;I)V
    .locals 4

    .line 141
    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileName:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 142
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-virtual {v0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f11009b

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 143
    iget-object v1, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileChannel:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getChannelName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 144
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getDirection()I

    move-result v0

    if-nez v0, :cond_0

    .line 145
    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileType:Landroid/widget/TextView;

    const v1, 0x7f110116

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_0

    .line 147
    :cond_0
    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileType:Landroid/widget/TextView;

    const v1, 0x7f110115

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 149
    :goto_0
    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileTimestamp:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getTimestamp()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->timetodate(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 150
    iget-object v0, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileSelect:Landroid/widget/CheckBox;

    new-instance v1, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;I)V

    invoke-virtual {v0, v1}, Landroid/widget/CheckBox;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 157
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    .line 158
    iget-object v1, p1, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileSelect:Landroid/widget/CheckBox;

    invoke-virtual {v1, v0}, Landroid/widget/CheckBox;->setChecked(Z)V

    .line 159
    iget-object p1, p1, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;->itemView:Landroid/view/View;

    new-instance v0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter$$ExternalSyntheticLambda1;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;I)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method public bridge synthetic onCreateViewHolder(Landroid/view/ViewGroup;I)Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
    .locals 0

    .line 123
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->onCreateViewHolder(Landroid/view/ViewGroup;I)Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;

    move-result-object p0

    return-object p0
.end method

.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;
    .locals 2

    .line 131
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-static {p2}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p2

    const v0, 0x7f0c00a6

    const/4 v1, 0x0

    .line 132
    invoke-virtual {p2, v0, p1, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    .line 134
    new-instance p2, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-direct {p2, p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;Landroid/view/View;)V

    return-object p2
.end method

.method public selectAll()V
    .locals 2

    .line 207
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 208
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordItemList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 209
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V

    return-void
.end method

.method public unSelectAll()V
    .locals 1

    .line 213
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 214
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V

    return-void
.end method
