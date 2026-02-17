.class public Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "InterPhoneChannelActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Landroid/view/View$OnTouchListener;
.implements Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;


# static fields
.field private static final LIN_RES_ID:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final TAG:Ljava/lang/String; = "InterPhoneChannelActivity"


# instance fields
.field private btnCancel:Landroid/widget/ImageButton;

.field private btnSave:Landroid/widget/ImageButton;

.field private channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

.field private currentAreaId:Ljava/lang/String;

.field private gridAdapter:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

.field private groupGridview:Landroid/widget/GridView;

.field private groupNumbers:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private isEdit:Z

.field private mCurrentChannelBand:Ljava/lang/String;

.field private mCurrentChannelCallName:Ljava/lang/String;

.field private mCurrentChannelColor:Ljava/lang/String;

.field private mCurrentChannelContactType:Ljava/lang/String;

.field private mCurrentChannelEncryption:Ljava/lang/String;

.field private mCurrentChannelEncryptionkey:Ljava/lang/String;

.field private mCurrentChannelFrqBand:Ljava/lang/String;

.field private mCurrentChannelId:Ljava/lang/String;

.field private mCurrentChannelInputMode:Ljava/lang/String;

.field private mCurrentChannelInterruptTransmission:Ljava/lang/String;

.field private mCurrentChannelPower:Ljava/lang/String;

.field private mCurrentChannelRelayDisconnet:Ljava/lang/String;

.field private mCurrentChannelRxSub:Ljava/lang/String;

.field private mCurrentChannelRxtype:Ljava/lang/String;

.field private mCurrentChannelSlot:Ljava/lang/String;

.field private mCurrentChannelSq:Ljava/lang/String;

.field private mCurrentChannelTxSub:Ljava/lang/String;

.field private mCurrentChannelTxtype:Ljava/lang/String;

.field private mCurrentChannelType:Ljava/lang/String;

.field private mCurrentFrequency:I

.field private mCurrentTouchX:F

.field private mCurrentTouchY:F

.field private mCurrentViewId:I

.field private mDataChannelBand:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelCallName:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelColor:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelContactType:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelEncryption:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelFrqBand:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelId:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelInputMode:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelInterruptTransmission:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelPower:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelRelayDisconnet:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelRxSubBDcs:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelRxSubCtc:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelRxSubFDcs:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelRxtype:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelSlot:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelSq:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelTxSubBDcs:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelTxSubCtc:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelTxSubFDcs:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelTxtype:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDataChannelType:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public mDismissRunnable:Ljava/lang/Runnable;

.field public mDismissRunnableAndroidFinish:Ljava/lang/Runnable;

.field private mEditChannelName:Landroid/widget/EditText;

.field private mEditFrequncyRecieve:Landroid/widget/EditText;

.field private mEditFrequncySend:Landroid/widget/EditText;

.field public mHandler:Landroid/os/Handler;

.field private mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

.field private mProgressDialog:Landroid/app/ProgressDialog;

.field private mToast:Landroid/widget/Toast;

.field private mTvChannelBand:Landroid/widget/TextView;

.field private mTvChannelCallNumber:Landroid/widget/EditText;

.field private mTvChannelColor:Landroid/widget/TextView;

.field private mTvChannelContactType:Landroid/widget/TextView;

.field private mTvChannelEncryption:Landroid/widget/TextView;

.field private mTvChannelEncryptionKey:Landroid/widget/EditText;

.field private mTvChannelFrqBand:Landroid/widget/TextView;

.field private mTvChannelInputMode:Landroid/widget/TextView;

.field private mTvChannelInterruptTransmission:Landroid/widget/TextView;

.field private mTvChannelPower:Landroid/widget/TextView;

.field private mTvChannelRelayDisconnet:Landroid/widget/TextView;

.field private mTvChannelRxSub:Landroid/widget/TextView;

.field private mTvChannelRxtype:Landroid/widget/TextView;

.field private mTvChannelSlot:Landroid/widget/TextView;

.field private mTvChannelSq:Landroid/widget/TextView;

.field private mTvChannelTxSub:Landroid/widget/TextView;

.field private mTvChannelTxtype:Landroid/widget/TextView;

.field private mTvChannelType:Landroid/widget/TextView;

.field private messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

.field private rootView:Landroid/view/View;

.field private tvTitle:Landroid/widget/TextView;


# direct methods
.method static bridge synthetic -$$Nest$fgetchannelData(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEditChannelName(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEditFrequncyRecieve(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEditFrequncySend(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTvChannelCallNumber(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTvChannelEncryptionKey(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetrootView(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->rootView:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmCurrentFrequency(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentFrequency:I

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 48
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->LIN_RES_ID:Ljava/util/LinkedHashMap;

    const v1, 0x7f090121

    .line 50
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090120

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090138

    .line 51
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090137

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090115

    .line 52
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090113

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090117

    .line 53
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090116

    .line 54
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090107

    .line 55
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090106

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090123

    .line 56
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090122

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09010c

    .line 57
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09010b

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09011e

    .line 58
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09011f

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09012b

    .line 59
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09012c

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09010e

    .line 60
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09010d

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090109

    .line 61
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090108

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090112

    .line 62
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09010f

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090125

    .line 63
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090124

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09011c

    .line 64
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f09011b

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090111

    .line 65
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090110

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f09011a

    .line 66
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090119

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090131

    .line 67
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090130

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090136

    .line 68
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090135

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090134

    .line 69
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090133

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090129

    .line 70
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090128

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const v1, 0x7f090127

    .line 71
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const v2, 0x7f090126

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 45
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    const/4 v0, 0x0

    .line 158
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 161
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0x20

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->groupNumbers:Ljava/util/List;

    .line 169
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    .line 669
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mHandler:Landroid/os/Handler;

    .line 684
    new-instance v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$6;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$6;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDismissRunnable:Ljava/lang/Runnable;

    .line 691
    new-instance v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$7;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$7;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDismissRunnableAndroidFinish:Ljava/lang/Runnable;

    return-void
.end method

.method private hideKeyboard(Landroid/os/IBinder;)V
    .locals 1

    if-eqz p1, :cond_0

    const-string v0, "input_method"

    .line 1231
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/view/inputmethod/InputMethodManager;

    const/4 v0, 0x2

    .line 1232
    invoke-virtual {p0, p1, v0}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z

    :cond_0
    return-void
.end method

.method private initData()V
    .locals 12

    .line 272
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030019

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    .line 273
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelId:Ljava/util/ArrayList;

    const v0, 0x7f1100d0

    .line 274
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelId:Ljava/lang/String;

    .line 275
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030024

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    .line 276
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelType:Ljava/util/ArrayList;

    const v0, 0x7f1100f8

    .line 277
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelType:Ljava/lang/String;

    .line 278
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x7f030018

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v1

    .line 279
    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelFrqBand:Ljava/util/ArrayList;

    const v1, 0x7f1100cb

    .line 280
    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    .line 281
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f03001c

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v2

    .line 282
    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelPower:Ljava/util/ArrayList;

    const v2, 0x7f1100e0

    .line 283
    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelPower:Ljava/lang/String;

    .line 284
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f030015

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 285
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelColor:Ljava/util/ArrayList;

    const v3, 0x7f1100ae

    .line 286
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelColor:Ljava/lang/String;

    .line 288
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f03001a

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 289
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelInputMode:Ljava/util/ArrayList;

    const v3, 0x7f1100d6

    .line 290
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInputMode:Ljava/lang/String;

    .line 292
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f03001e

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 293
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelSlot:Ljava/util/ArrayList;

    const v3, 0x7f1100b9

    .line 294
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSlot:Ljava/lang/String;

    .line 296
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f030016

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 297
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelContactType:Ljava/util/ArrayList;

    const v3, 0x7f1100b1

    .line 298
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    .line 299
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f030014

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 300
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelCallName:Ljava/util/ArrayList;

    const v3, 0x7f1100a9

    .line 301
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelCallName:Ljava/lang/String;

    .line 302
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f030017

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 303
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelEncryption:Ljava/util/ArrayList;

    const v3, 0x7f1100bc

    .line 304
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelEncryption:Ljava/lang/String;

    .line 306
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f03001d

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 307
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRelayDisconnet:Ljava/util/ArrayList;

    const v3, 0x7f1100e4

    .line 308
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRelayDisconnet:Ljava/lang/String;

    .line 310
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f03001b

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 311
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelInterruptTransmission:Ljava/util/ArrayList;

    const v3, 0x7f1100d1

    .line 312
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInterruptTransmission:Ljava/lang/String;

    .line 314
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f030013

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v3

    .line 315
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelBand:Ljava/util/ArrayList;

    const v3, 0x7f1100a6

    .line 316
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v4

    iput-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelBand:Ljava/lang/String;

    .line 318
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v5, 0x7f03001f

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v4

    .line 319
    invoke-direct {p0, v4}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v4

    iput-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelSq:Ljava/util/ArrayList;

    const v4, 0x7f1100ef

    .line 320
    invoke-virtual {p0, v4}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v4

    iput-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSq:Ljava/lang/String;

    .line 322
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v5, 0x7f030023

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v4

    .line 323
    invoke-direct {p0, v4}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v4

    iput-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxtype:Ljava/util/ArrayList;

    const v4, 0x7f1100f5

    .line 324
    invoke-virtual {p0, v4}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v6

    iput-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    .line 326
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v6

    invoke-virtual {v6, v5}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v5

    .line 327
    invoke-direct {p0, v5}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxtype:Ljava/util/ArrayList;

    .line 328
    invoke-virtual {p0, v4}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    .line 330
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    const v6, 0x7f030021

    invoke-virtual {v5, v6}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v5

    .line 331
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    const v8, 0x7f030022

    invoke-virtual {v7, v8}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v7

    .line 332
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const v10, 0x7f030020

    invoke-virtual {v9, v10}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v9

    .line 333
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v11

    invoke-virtual {v11, v6}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v6

    .line 334
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v11

    invoke-virtual {v11, v8}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v8

    .line 335
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v11

    invoke-virtual {v11, v10}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v10

    .line 337
    invoke-direct {p0, v5}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubCtc:Ljava/util/ArrayList;

    .line 338
    invoke-direct {p0, v7}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubFDcs:Ljava/util/ArrayList;

    .line 339
    invoke-direct {p0, v9}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubBDcs:Ljava/util/ArrayList;

    .line 340
    invoke-direct {p0, v6}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubCtc:Ljava/util/ArrayList;

    .line 341
    invoke-direct {p0, v8}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubFDcs:Ljava/util/ArrayList;

    .line 342
    invoke-direct {p0, v10}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->strToArray([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubBDcs:Ljava/util/ArrayList;

    .line 346
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v5

    const-string v6, "edit"

    const/4 v7, 0x0

    .line 347
    invoke-virtual {v5, v6, v7}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v6

    iput-boolean v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isEdit:Z

    const-string v6, "currentAreaId"

    .line 348
    invoke-virtual {v5, v6}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    iput-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    .line 349
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "isEdit="

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v8, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isEdit:Z

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const-string v8, "InterPhoneChannelActivity"

    invoke-static {v8, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 350
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "currentAreaId="

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v9, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v8, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 351
    iget-boolean v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isEdit:Z

    const/4 v9, 0x1

    if-eqz v6, :cond_21

    const-string v6, "channelId"

    .line 352
    invoke-virtual {v5, v6, v7}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v5

    .line 353
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "channelIndex="

    invoke-virtual {v6, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v8, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 354
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v6

    invoke-virtual {v6}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object v6

    iget-object v10, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    invoke-virtual {v6, v10}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v6

    invoke-virtual {v6, v5}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getChannel(I)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v5

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 355
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "channelData="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v8, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 356
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    if-eqz v5, :cond_22

    .line 357
    iget v5, v5, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v5, :cond_0

    .line 358
    new-instance v5, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v6, v6, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    invoke-direct {v5, p0, v6}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;[I)V

    iput-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->gridAdapter:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    .line 359
    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->groupGridview:Landroid/widget/GridView;

    invoke-virtual {v6, v5}, Landroid/widget/GridView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 362
    :cond_0
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    const v6, 0x7f1100f7

    if-eqz v5, :cond_2

    .line 363
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getType()I

    move-result v5

    if-nez v5, :cond_1

    .line 364
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v8

    const v10, 0x7f1100f9

    invoke-virtual {v8, v10}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v8, v8, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_0

    .line 366
    :cond_1
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v8

    invoke-virtual {v8, v6}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v8, v8, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    goto :goto_0

    .line 369
    :cond_2
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v5

    .line 371
    :goto_0
    iget-object v8, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {v8, v5}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 372
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v10, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v10}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v10

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, ""

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 373
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v11, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v11}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxFreq()I

    move-result v11

    invoke-virtual {v8, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 374
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v5

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v5

    const v8, 0x7f1100cc

    if-eqz v5, :cond_4

    .line 375
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v5

    const v11, 0x1c9c3800

    if-gt v5, v11, :cond_3

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 376
    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v5

    const v11, 0x17d78400

    if-lt v5, v11, :cond_3

    .line 377
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v5, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_1

    .line 378
    :cond_3
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v1

    const v5, 0xa5f0780

    if-gt v1, v5, :cond_7

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 379
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v1

    const v5, 0x81b3200

    if-lt v1, v5, :cond_7

    .line 380
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(I)V

    goto :goto_1

    .line 382
    :cond_4
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v5

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportOnlyUFrequencyBand()Z

    move-result v5

    if-eqz v5, :cond_5

    .line 383
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v5, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_1

    .line 384
    :cond_5
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v5

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportOnlyVFrequencyBand()Z

    move-result v5

    if-eqz v5, :cond_6

    .line 385
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(I)V

    goto :goto_1

    .line 387
    :cond_6
    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v5, v1}, Landroid/widget/TextView;->setText(I)V

    .line 389
    :cond_7
    :goto_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    .line 391
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getPower()I

    move-result v1

    if-ne v1, v9, :cond_8

    .line 392
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(I)V

    goto :goto_2

    .line 394
    :cond_8
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    const v2, 0x7f1100e2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(I)V

    .line 396
    :goto_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelPower:Ljava/lang/String;

    .line 398
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRelay()I

    move-result v1

    const/4 v2, 0x2

    if-ne v1, v2, :cond_9

    .line 399
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    const v5, 0x7f1100e5

    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setText(I)V

    goto :goto_3

    .line 401
    :cond_9
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    const v5, 0x7f1100e6

    invoke-virtual {v1, v5}, Landroid/widget/TextView;->setText(I)V

    .line 403
    :goto_3
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRelayDisconnet:Ljava/lang/String;

    .line 405
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInterrupt()I

    move-result v1

    const/4 v5, 0x3

    if-ne v1, v9, :cond_a

    .line 406
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    const v8, 0x7f1100d3

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(I)V

    goto :goto_4

    .line 407
    :cond_a
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInterrupt()I

    move-result v1

    if-ne v1, v2, :cond_b

    .line 408
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    const v8, 0x7f1100d2

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(I)V

    goto :goto_4

    .line 409
    :cond_b
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInterrupt()I

    move-result v1

    if-ne v1, v5, :cond_c

    .line 410
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    const v8, 0x7f1100d4

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setText(I)V

    .line 412
    :cond_c
    :goto_4
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    invoke-virtual {v1}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInterruptTransmission:Ljava/lang/String;

    const v1, 0x7f090137

    .line 415
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    const/16 v8, 0x8

    invoke-virtual {v1, v8}, Landroid/view/View;->setVisibility(I)V

    .line 416
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getType()I

    move-result v1

    if-nez v1, :cond_15

    .line 417
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 418
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideAnalogMenu()V

    .line 419
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelColor:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getCc()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 420
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getCc()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelColor:Ljava/lang/String;

    .line 421
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v0

    const v1, 0x7f09010a

    if-nez v0, :cond_d

    .line 422
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    const v3, 0x7f1100b3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(I)V

    .line 423
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 424
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f1100a8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_5

    .line 426
    :cond_d
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v0

    if-ne v0, v9, :cond_e

    .line 427
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    const v3, 0x7f1100b2

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(I)V

    .line 428
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 429
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f1100aa

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_5

    .line 433
    :cond_e
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    const v1, 0x7f1100b0

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    const v0, 0x7f090108

    .line 436
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v8}, Landroid/view/View;->setVisibility(I)V

    .line 438
    :goto_5
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    .line 440
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptSw()I

    move-result v0

    const v1, 0x7f090110

    const v3, 0x7f1100be

    if-ne v0, v2, :cond_f

    .line 441
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    const v2, 0x7f1100bd

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(I)V

    .line 442
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v8}, Landroid/view/View;->setVisibility(I)V

    goto :goto_6

    .line 444
    :cond_f
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(I)V

    .line 445
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v7}, Landroid/view/View;->setVisibility(I)V

    .line 447
    :goto_6
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptSw()I

    move-result v0

    if-ne v0, v9, :cond_10

    .line 448
    invoke-virtual {p0, v3}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelEncryption:Ljava/lang/String;

    .line 450
    :cond_10
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptKey()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 452
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getChannelMode()I

    move-result v0

    if-nez v0, :cond_11

    .line 453
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    const v1, 0x7f1100d7

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_7

    .line 454
    :cond_11
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getChannelMode()I

    move-result v0

    const/4 v1, 0x4

    if-ne v0, v1, :cond_12

    .line 455
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    const v1, 0x7f1100d8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 457
    :cond_12
    :goto_7
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInputMode:Ljava/lang/String;

    .line 459
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInBoundSlot()I

    move-result v0

    if-nez v0, :cond_13

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getOutBoundSlot()I

    move-result v0

    if-nez v0, :cond_13

    .line 460
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    const v1, 0x7f1100b7

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_8

    .line 461
    :cond_13
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInBoundSlot()I

    move-result v0

    if-ne v0, v9, :cond_14

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getOutBoundSlot()I

    move-result v0

    if-ne v0, v9, :cond_14

    .line 462
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    const v1, 0x7f1100b8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 464
    :cond_14
    :goto_8
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSlot:Ljava/lang/String;

    goto/16 :goto_e

    .line 467
    :cond_15
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v0, v6}, Landroid/widget/TextView;->setText(I)V

    .line 468
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideDigitalMenu()V

    .line 469
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getBand()I

    move-result v0

    if-nez v0, :cond_16

    .line 470
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    const v1, 0x7f1100a5

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    goto :goto_9

    .line 472
    :cond_16
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(I)V

    .line 474
    :goto_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelBand:Ljava/lang/String;

    .line 475
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSq:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getSq()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 476
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getSq()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSq:Ljava/lang/String;

    .line 478
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    const v1, 0x7f090126

    if-nez v0, :cond_17

    .line 479
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v8}, Landroid/view/View;->setVisibility(I)V

    goto :goto_a

    .line 481
    :cond_17
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v7}, Landroid/view/View;->setVisibility(I)V

    .line 483
    :goto_a
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    if-nez v0, :cond_18

    const v0, 0x7f090133

    .line 484
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v8}, Landroid/view/View;->setVisibility(I)V

    goto :goto_b

    :cond_18
    const v0, 0x7f090133

    .line 486
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v7}, Landroid/view/View;->setVisibility(I)V

    .line 489
    :goto_b
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    if-nez v0, :cond_19

    .line 490
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v0, v4}, Landroid/widget/TextView;->setText(I)V

    const-string v0, "0"

    .line 491
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_c

    .line 492
    :cond_19
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    if-ne v0, v9, :cond_1a

    .line 493
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    const v1, 0x7f1100f2

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 494
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubCtc:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_c

    .line 495
    :cond_1a
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    if-ne v0, v2, :cond_1b

    .line 496
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    const v1, 0x7f1100f4

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 497
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubFDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_c

    .line 498
    :cond_1b
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    if-ne v0, v5, :cond_1c

    .line 499
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    const v1, 0x7f1100f3

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 500
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubBDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    .line 502
    :cond_1c
    :goto_c
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 503
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    .line 505
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    if-nez v0, :cond_1d

    .line 506
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    const v1, 0x7f1100ec

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    const-string v0, "0"

    .line 507
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_d

    .line 508
    :cond_1d
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    if-ne v0, v9, :cond_1e

    .line 509
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    const v1, 0x7f1100e9

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 510
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubCtc:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_d

    .line 512
    :cond_1e
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    if-ne v0, v2, :cond_1f

    .line 513
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    const v1, 0x7f1100eb

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 514
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubFDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_d

    .line 515
    :cond_1f
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    if-ne v0, v5, :cond_20

    .line 516
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    const v1, 0x7f1100ea

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 517
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubBDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxSubCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    .line 520
    :cond_20
    :goto_d
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 521
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    goto :goto_e

    .line 526
    :cond_21
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 527
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideAnalogMenu()V

    const v0, 0x7f090118

    .line 528
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/GridView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->groupGridview:Landroid/widget/GridView;

    const/16 v0, 0x20

    new-array v0, v0, [I

    .line 530
    invoke-static {v0, v7}, Ljava/util/Arrays;->fill([II)V

    aput v9, v0, v7

    .line 532
    new-instance v1, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-direct {v1, p0, v0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;[I)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->gridAdapter:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    .line 533
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->groupGridview:Landroid/widget/GridView;

    invoke-virtual {p0, v1}, Landroid/widget/GridView;->setAdapter(Landroid/widget/ListAdapter;)V

    :cond_22
    :goto_e
    return-void
.end method

.method private initView()V
    .locals 3

    const v0, 0x7f090221

    .line 181
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->rootView:Landroid/view/View;

    const v0, 0x7f090105

    .line 182
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageButton;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->btnCancel:Landroid/widget/ImageButton;

    const v0, 0x7f09012a

    .line 183
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageButton;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->btnSave:Landroid/widget/ImageButton;

    .line 184
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->btnCancel:Landroid/widget/ImageButton;

    new-instance v1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ImageButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 185
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->btnSave:Landroid/widget/ImageButton;

    new-instance v1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ImageButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090132

    .line 186
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->tvTitle:Landroid/widget/TextView;

    const v0, 0x7f090121

    .line 187
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    .line 188
    new-instance v1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    const v0, 0x7f090117

    .line 197
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    .line 198
    new-instance v1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 207
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    const v0, 0x7f090116

    .line 209
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    .line 210
    new-instance v2, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$3;

    invoke-direct {v2, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$3;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 219
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    .line 224
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x7f090114

    .line 225
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    :cond_0
    const v0, 0x7f090115

    .line 227
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    const v0, 0x7f090138

    .line 228
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    const v0, 0x7f090123

    .line 229
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    const v0, 0x7f09010c

    .line 230
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelColor:Landroid/widget/TextView;

    const v0, 0x7f09011e

    .line 231
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    const v0, 0x7f09012b

    .line 232
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    const v0, 0x7f09010e

    .line 233
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    const v0, 0x7f090109

    .line 234
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    .line 235
    new-instance v2, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$4;

    invoke-direct {v2, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$4;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 243
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    const v0, 0x7f090112

    .line 244
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    const v0, 0x7f090111

    .line 245
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    .line 246
    new-instance v2, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$5;

    invoke-direct {v2, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$5;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 254
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setInputType(I)V

    .line 255
    new-instance v0, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    .line 256
    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->setPrizeOnItemClickListener(Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;)V

    const v0, 0x7f090125

    .line 259
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    const v0, 0x7f09011c

    .line 260
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    const v0, 0x7f090107

    .line 261
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    const v0, 0x7f090131

    .line 262
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSq:Landroid/widget/TextView;

    const v0, 0x7f090129

    .line 263
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    const v0, 0x7f090136

    .line 264
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    const v0, 0x7f090134

    .line 265
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    const v0, 0x7f090127

    .line 266
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    const v0, 0x7f090118

    .line 268
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/GridView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->groupGridview:Landroid/widget/GridView;

    return-void
.end method

.method private isShouldHideKeyboard(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 5

    const/4 p0, 0x0

    if-eqz p1, :cond_1

    .line 1212
    instance-of v0, p1, Landroid/widget/EditText;

    if-eqz v0, :cond_1

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1213
    fill-array-data v0, :array_0

    .line 1214
    invoke-virtual {p1, v0}, Landroid/view/View;->getLocationInWindow([I)V

    aget v1, v0, p0

    const/4 v2, 0x1

    aget v0, v0, v2

    .line 1217
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v3

    add-int/2addr v3, v0

    .line 1218
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p1

    add-int/2addr p1, v1

    .line 1219
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result v4

    int-to-float v1, v1

    cmpl-float v1, v4, v1

    if-lez v1, :cond_0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    int-to-float p1, p1

    cmpg-float p1, v1, p1

    if-gez p1, :cond_0

    .line 1220
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    int-to-float v0, v0

    cmpl-float p1, p1, v0

    if-lez p1, :cond_0

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    int-to-float p2, v3

    cmpg-float p1, p1, p2

    if-gez p1, :cond_0

    return p0

    :cond_0
    return v2

    :cond_1
    return p0

    :array_0
    .array-data 4
        0x0
        0x0
    .end array-data
.end method

.method private isTalkSend()Z
    .locals 3

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 1267
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    move v1, v2

    :cond_0
    if-eqz v1, :cond_1

    const v0, 0x7f11011c

    .line 1269
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    :cond_1
    return v1
.end method

.method private showKeyboard(Landroid/view/View;)V
    .locals 1

    if-eqz p1, :cond_0

    const-string v0, "input_method"

    .line 1238
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/view/inputmethod/InputMethodManager;

    .line 1239
    invoke-virtual {p1}, Landroid/view/View;->requestFocus()Z

    const/4 v0, 0x0

    .line 1240
    invoke-virtual {p0, p1, v0}, Landroid/view/inputmethod/InputMethodManager;->showSoftInput(Landroid/view/View;I)Z

    :cond_0
    return-void
.end method

.method private showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V
    .locals 5

    const/high16 v0, 0x42480000    # 50.0f

    .line 999
    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/Util/UtilDensity;->dip2px(Landroid/content/Context;F)I

    move-result v0

    .line 1000
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "itemHeight = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "InterPhoneChannelActivity"

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1001
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {v1, p1, p4}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->refreshData(Ljava/util/ArrayList;Ljava/lang/String;)V

    .line 1002
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    int-to-double v1, v0

    const-wide v3, 0x400a666666666666L    # 3.3

    mul-double/2addr v1, v3

    double-to-int p4, v1

    invoke-virtual {p1, p4}, Landroid/widget/PopupWindow;->setWidth(I)V

    .line 1003
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    mul-int/2addr p2, v0

    invoke-virtual {p1, p2}, Landroid/widget/PopupWindow;->setHeight(I)V

    .line 1004
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p0, p3}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/PopupWindow;->showAsDropDown(Landroid/view/View;)V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 1251
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 1252
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 1254
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mToast:Landroid/widget/Toast;

    .line 1255
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private showToast(Ljava/lang/String;)V
    .locals 1

    .line 1259
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 1260
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 1262
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mToast:Landroid/widget/Toast;

    .line 1263
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private strToArray([Ljava/lang/String;)Ljava/util/ArrayList;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 582
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    const/4 v0, 0x0

    .line 583
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_0

    .line 584
    aget-object v1, p1, v0

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-object p0
.end method


# virtual methods
.method public dismissProgressDialog()V
    .locals 0

    .line 680
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    if-eqz p0, :cond_0

    .line 681
    invoke-virtual {p0}, Landroid/app/ProgressDialog;->dismiss()V

    :cond_0
    return-void
.end method

.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 1

    .line 1197
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    if-nez v0, :cond_0

    .line 1198
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentTouchX:F

    .line 1199
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentTouchY:F

    .line 1208
    :cond_0
    invoke-super {p0, p1}, Landroid/app/Activity;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method public hideAnalogMenu()V
    .locals 4

    const v0, 0x7f09010b

    .line 561
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09011f

    .line 562
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09012c

    .line 563
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09010d

    .line 564
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090108

    .line 565
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09010f

    .line 566
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f1100be

    .line 567
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const v2, 0x7f090110

    const/16 v3, 0x8

    if-eqz v0, :cond_0

    .line 568
    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 570
    :cond_0
    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    :goto_0
    const v0, 0x7f090106

    .line 572
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090130

    .line 573
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090135

    .line 574
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090128

    .line 575
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090124

    .line 576
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09011b

    .line 577
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090119

    .line 578
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method

.method public hideDigitalMenu()V
    .locals 3

    const v0, 0x7f09010b

    .line 544
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09011f

    .line 545
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09012c

    .line 546
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09010d

    .line 547
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090108

    .line 548
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09010f

    .line 549
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090110

    .line 550
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090106

    .line 551
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090130

    .line 552
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090135

    .line 553
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090128

    .line 554
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090124

    .line 555
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f09011b

    .line 556
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    const v0, 0x7f090119

    .line 557
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method

.method public isParamsCorrect()Z
    .locals 7

    .line 595
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const v0, 0x7f1100db

    .line 596
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 600
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    const v0, 0x7f1100ca

    .line 601
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 604
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_2

    const v0, 0x7f1100c7

    .line 605
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 611
    :cond_2
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    const v2, 0x81b3200

    const v3, 0xa5f0780

    const v4, 0x17d78400

    const v5, 0x1c9c3800

    if-eqz v0, :cond_4

    const v0, 0x7f1100cb

    .line 612
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v6}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v6

    invoke-interface {v6}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    move v3, v5

    :cond_3
    if-eqz v0, :cond_7

    move v2, v4

    goto :goto_0

    .line 615
    :cond_4
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportOnlyUFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_6

    :cond_5
    move v2, v4

    move v3, v5

    goto :goto_0

    .line 618
    :cond_6
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportOnlyVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 625
    :cond_7
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    const/4 v4, 0x1

    if-lt v0, v2, :cond_10

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-gt v0, v3, :cond_10

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    .line 626
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-lt v0, v2, :cond_10

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-le v0, v3, :cond_8

    goto/16 :goto_2

    .line 631
    :cond_8
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    const v2, 0x7f1100f9

    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_f

    .line 633
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const v2, 0x7f1100b0

    if-eqz v0, :cond_9

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    .line 634
    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_9

    const v0, 0x7f1100ab

    .line 635
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 638
    :cond_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const v3, 0xfffcdf

    if-nez v0, :cond_d

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    .line 639
    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_d

    .line 640
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    const v2, 0x7f1100b3

    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 641
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 642
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-lt v0, v4, :cond_a

    if-le v0, v3, :cond_d

    :cond_a
    const v0, 0x7f1100dc

    .line 644
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 647
    :cond_b
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    const v2, 0x7f1100b2

    invoke-virtual {p0, v2}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_d

    .line 648
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 649
    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-lt v0, v4, :cond_c

    if-le v0, v3, :cond_d

    :cond_c
    const v0, 0x7f1100ce

    .line 651
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    .line 656
    :cond_d
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->gridAdapter:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->getGroupList()[I

    move-result-object v0

    .line 657
    array-length v2, v0

    move v5, v1

    :goto_1
    if-ge v5, v2, :cond_f

    aget v6, v0, v5

    if-le v6, v3, :cond_e

    const v0, 0x7f1100cd

    .line 659
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    return v1

    :cond_e
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    :cond_f
    return v4

    :cond_10
    :goto_2
    const v0, 0x7f1100c4

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Object;

    .line 627
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v5, v1

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v5, v4

    invoke-virtual {p0, v0, v5}, Landroid/app/Activity;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(Ljava/lang/String;)V

    return v1
.end method

.method public onBackPressed()V
    .locals 0

    .line 591
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 5

    .line 894
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    const/4 v1, 0x3

    const/4 v2, 0x4

    const/16 v3, 0x8

    const/4 v4, 0x2

    sparse-switch v0, :sswitch_data_0

    goto/16 :goto_0

    .line 913
    :sswitch_0
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 914
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelType:Ljava/util/ArrayList;

    const v0, 0x7f090138

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelType:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 967
    :sswitch_1
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 968
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxtype:Ljava/util/ArrayList;

    const v0, 0x7f090136

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    invoke-direct {p0, p1, v2, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 975
    :sswitch_2
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 976
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    const v0, 0x7f1100f2

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const v0, 0x7f090134

    if-eqz p1, :cond_0

    .line 977
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubCtc:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 978
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    const v1, 0x7f1100f4

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 979
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubFDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 980
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    const v1, 0x7f1100f3

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_5

    .line 981
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubBDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 963
    :sswitch_3
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 964
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelSq:Ljava/util/ArrayList;

    const v0, 0x7f090131

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSq:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 936
    :sswitch_4
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 937
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelSlot:Ljava/util/ArrayList;

    const v0, 0x7f09012b

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSlot:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 899
    :sswitch_5
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_2

    goto/16 :goto_0

    .line 902
    :cond_2
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->saveChannelData()V

    goto/16 :goto_0

    .line 971
    :sswitch_6
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 972
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxtype:Ljava/util/ArrayList;

    const v0, 0x7f090129

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    invoke-direct {p0, p1, v2, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 986
    :sswitch_7
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 987
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    const v0, 0x7f1100e9

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const v0, 0x7f090127

    if-eqz p1, :cond_3

    .line 988
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubCtc:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 989
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    const v1, 0x7f1100eb

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 990
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubFDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 991
    :cond_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    const v1, 0x7f1100ea

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_5

    .line 992
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubBDcs:Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    invoke-direct {p0, p1, v3, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 951
    :sswitch_8
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 952
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRelayDisconnet:Ljava/util/ArrayList;

    const v0, 0x7f090125

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRelayDisconnet:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 924
    :sswitch_9
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 925
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelPower:Ljava/util/ArrayList;

    const v0, 0x7f090123

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelPower:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 932
    :sswitch_a
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 933
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelInputMode:Ljava/util/ArrayList;

    const v0, 0x7f09011e

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInputMode:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto/16 :goto_0

    .line 955
    :sswitch_b
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 956
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelInterruptTransmission:Ljava/util/ArrayList;

    const v0, 0x7f09011c

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInterruptTransmission:Ljava/lang/String;

    invoke-direct {p0, p1, v1, v0, v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 917
    :sswitch_c
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 918
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelFrqBand:Ljava/util/ArrayList;

    const v0, 0x7f090115

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 921
    :sswitch_d
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    goto :goto_0

    .line 947
    :sswitch_e
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 948
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelEncryption:Ljava/util/ArrayList;

    const v0, 0x7f090112

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelEncryption:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 940
    :sswitch_f
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 941
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelContactType:Ljava/util/ArrayList;

    const v0, 0x7f09010e

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    invoke-direct {p0, p1, v1, v0, v2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 928
    :sswitch_10
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 929
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelColor:Ljava/util/ArrayList;

    const v0, 0x7f09010c

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelColor:Ljava/lang/String;

    invoke-direct {p0, p1, v2, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 944
    :sswitch_11
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    goto :goto_0

    .line 959
    :sswitch_12
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    .line 960
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelBand:Ljava/util/ArrayList;

    const v0, 0x7f090107

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelBand:Ljava/lang/String;

    invoke-direct {p0, p1, v4, v0, v1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showPopupWindow(Ljava/util/ArrayList;IILjava/lang/String;)V

    goto :goto_0

    .line 896
    :sswitch_13
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->onBackPressed()V

    :cond_5
    :goto_0
    return-void

    nop

    :sswitch_data_0
    .sparse-switch
        0x7f090105 -> :sswitch_13
        0x7f090107 -> :sswitch_12
        0x7f090109 -> :sswitch_11
        0x7f09010c -> :sswitch_10
        0x7f09010e -> :sswitch_f
        0x7f090112 -> :sswitch_e
        0x7f090113 -> :sswitch_d
        0x7f090115 -> :sswitch_c
        0x7f09011c -> :sswitch_b
        0x7f09011e -> :sswitch_a
        0x7f090123 -> :sswitch_9
        0x7f090125 -> :sswitch_8
        0x7f090127 -> :sswitch_7
        0x7f090129 -> :sswitch_6
        0x7f09012a -> :sswitch_5
        0x7f09012b -> :sswitch_4
        0x7f090131 -> :sswitch_3
        0x7f090134 -> :sswitch_2
        0x7f090136 -> :sswitch_1
        0x7f090138 -> :sswitch_0
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 539
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 540
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 173
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c0050

    .line 174
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    const-string p1, "InterPhoneChannelActivity"

    const-string v0, "onCreate: "

    .line 175
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 176
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->initView()V

    .line 177
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->initData()V

    return-void
.end method

.method protected onDestroy()V
    .locals 1

    .line 888
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 889
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    return-void
.end method

.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public saveChannelData()V
    .locals 10

    .line 700
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isParamsCorrect()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 704
    :cond_0
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isEdit:Z

    const v1, 0x7f1100f9

    const-string v2, ""

    if-nez v0, :cond_1

    .line 705
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 706
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setName(Ljava/lang/String;)V

    goto/16 :goto_1

    .line 709
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 710
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getType()I

    move-result v0

    if-nez v0, :cond_2

    .line 711
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v3, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    .line 713
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v3

    const v4, 0x7f1100f7

    invoke-virtual {v3, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v3, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_3
    move-object v0, v2

    .line 716
    :goto_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 717
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setName(Ljava/lang/String;)V

    .line 721
    :cond_4
    :goto_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxFreq(I)V

    .line 722
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {v3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxFreq(I)V

    const v0, 0x7f1100e0

    .line 723
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    invoke-virtual {v3}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v3

    invoke-interface {v3}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v0, :cond_5

    .line 724
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setPower(I)V

    goto :goto_2

    .line 726
    :cond_5
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setPower(I)V

    :goto_2
    const v0, 0x7f1100e5

    .line 729
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    invoke-virtual {v5}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v5

    invoke-interface {v5}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v5, 0x2

    if-eqz v0, :cond_6

    .line 730
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRelay(I)V

    .line 731
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->relayCommand()V

    goto :goto_3

    :cond_6
    const v0, 0x7f1100e6

    .line 732
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v6, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    invoke-virtual {v6}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v6

    invoke-interface {v6}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 733
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRelay(I)V

    .line 734
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->relayCommand()V

    .line 737
    :cond_7
    :goto_3
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "InterPhoneChannelActivity"

    const/4 v6, 0x3

    if-eqz v0, :cond_14

    .line 738
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setType(I)V

    const v0, 0x7f1100b3

    .line 739
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 740
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setContactType(I)V

    .line 741
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v7}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v0, v7}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxContact(I)V

    goto :goto_4

    :cond_8
    const v0, 0x7f1100b2

    .line 742
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    .line 743
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v7}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v0, v7}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxContact(I)V

    .line 744
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setContactType(I)V

    goto :goto_4

    :cond_9
    const v0, 0x7f1100b0

    .line 745
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a

    .line 746
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setContactType(I)V

    .line 747
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    const v7, 0xffffff

    invoke-virtual {v0, v7}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxContact(I)V

    .line 749
    :cond_a
    :goto_4
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->gridAdapter:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-virtual {v7}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->getGroupList()[I

    move-result-object v7

    invoke-virtual {v0, v7}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setGroups([I)V

    .line 751
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelColor:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v0, v7}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setCc(I)V

    const v0, 0x7f1100be

    .line 753
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_d

    .line 754
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setEncryptSw(I)V

    .line 755
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 756
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    const/16 v7, 0x8

    if-ge v2, v7, :cond_c

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v2

    if-le v2, v3, :cond_c

    .line 757
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    move v8, v4

    .line 758
    :goto_5
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v9

    rsub-int/lit8 v9, v9, 0x8

    if-ge v8, v9, :cond_b

    const-string v9, "0"

    .line 759
    invoke-virtual {v2, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v8, v8, 0x1

    goto :goto_5

    .line 761
    :cond_b
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 762
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 763
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v0, v4}, Landroid/widget/EditText;->setSelection(I)V

    .line 764
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " mTvChannelEncryptionKey.getText().toString() = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 766
    :cond_c
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryptionKey:Landroid/widget/EditText;

    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setEncryptKey(Ljava/lang/String;)V

    goto :goto_6

    .line 768
    :cond_d
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setEncryptSw(I)V

    .line 769
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setEncryptKey(Ljava/lang/String;)V

    :goto_6
    const v0, 0x7f1100d3

    .line 772
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_e

    .line 773
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setInterrupt(I)V

    goto :goto_7

    :cond_e
    const v0, 0x7f1100d2

    .line 775
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_f

    .line 776
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setInterrupt(I)V

    goto :goto_7

    :cond_f
    const v0, 0x7f1100d4

    .line 778
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_10

    .line 779
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v6}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setInterrupt(I)V

    .line 780
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v2, "pref_person_busy_no_send"

    invoke-static {v0, v2, v4}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    :cond_10
    :goto_7
    const v0, 0x7f1100d7

    .line 783
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_11

    .line 784
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setChannelMode(I)V

    goto :goto_8

    :cond_11
    const v0, 0x7f1100d8

    .line 785
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_12

    .line 786
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    const/4 v2, 0x4

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setChannelMode(I)V

    :cond_12
    :goto_8
    const v0, 0x7f1100b7

    .line 789
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_13

    .line 790
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setInBoundSlot(I)V

    .line 791
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setOutBoundSlot(I)V

    goto/16 :goto_b

    :cond_13
    const v0, 0x7f1100b8

    .line 792
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1d

    .line 793
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setInBoundSlot(I)V

    .line 794
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setOutBoundSlot(I)V

    goto/16 :goto_b

    .line 798
    :cond_14
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setType(I)V

    const v0, 0x7f1100a5

    .line 800
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_15

    .line 801
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setBand(I)V

    goto :goto_9

    .line 803
    :cond_15
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setBand(I)V

    .line 805
    :goto_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSq:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setSq(I)V

    const v0, 0x7f1100f5

    .line 808
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_16

    .line 809
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxType(I)V

    .line 810
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxSubCode(I)V

    goto/16 :goto_a

    :cond_16
    const v0, 0x7f1100f2

    .line 811
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17

    .line 812
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxType(I)V

    .line 813
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubCtc:Ljava/util/ArrayList;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxSubCode(I)V

    goto :goto_a

    :cond_17
    const v0, 0x7f1100f4

    .line 814
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_18

    .line 815
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxType(I)V

    .line 816
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubFDcs:Ljava/util/ArrayList;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxSubCode(I)V

    goto :goto_a

    :cond_18
    const v0, 0x7f1100f3

    .line 817
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_19

    .line 818
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v6}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxType(I)V

    .line 819
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubBDcs:Ljava/util/ArrayList;

    iget-object v7, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    invoke-virtual {v7}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v7

    invoke-interface {v7}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxSubCode(I)V

    :cond_19
    :goto_a
    const v0, 0x7f1100ec

    .line 822
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1a

    .line 823
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxType(I)V

    .line 824
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxSubCode(I)V

    goto/16 :goto_b

    :cond_1a
    const v0, 0x7f1100e9

    .line 825
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1b

    .line 826
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxType(I)V

    .line 827
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubCtc:Ljava/util/ArrayList;

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    invoke-virtual {v5}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v5

    invoke-interface {v5}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxSubCode(I)V

    goto :goto_b

    :cond_1b
    const v0, 0x7f1100eb

    .line 828
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1c

    .line 829
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v5}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxType(I)V

    .line 830
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubFDcs:Ljava/util/ArrayList;

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    invoke-virtual {v5}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v5

    invoke-interface {v5}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxSubCode(I)V

    goto :goto_b

    :cond_1c
    const v0, 0x7f1100ea

    .line 831
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v2}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1d

    .line 832
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v6}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxType(I)V

    .line 833
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubBDcs:Ljava/util/ArrayList;

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    invoke-virtual {v5}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v5

    invoke-interface {v5}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setRxSubCode(I)V

    .line 837
    :cond_1d
    :goto_b
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->isEdit:Z

    if-eqz v0, :cond_21

    .line 838
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    if-nez v0, :cond_1e

    .line 839
    new-instance v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$8;-><init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    .line 865
    :cond_1e
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    if-ne v0, v3, :cond_20

    .line 866
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v0

    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v2

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getSetChannelState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v2

    if-ne v0, v2, :cond_1f

    const-string v0, "saveChannelData is setting channel..."

    .line 867
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 868
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->rootView:Landroid/view/View;

    const v0, 0x7f11017c

    invoke-static {p0, v0, v4}, Lcom/google/android/material/snackbar/Snackbar;->make(Landroid/view/View;II)Lcom/google/android/material/snackbar/Snackbar;

    move-result-object p0

    invoke-virtual {p0}, Lcom/google/android/material/snackbar/Snackbar;->show()V

    goto :goto_c

    :cond_1f
    const v0, 0x7f110031

    .line 870
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showProgressDialog(Ljava/lang/String;)V

    .line 871
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x22

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 872
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x23

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 873
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfoWithData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 874
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDismissRunnable:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_c

    .line 877
    :cond_20
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 878
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    goto :goto_c

    .line 881
    :cond_21
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->currentAreaId:Ljava/lang/String;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->channelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->createChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 882
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    :goto_c
    return-void
.end method

.method public setOnItemClick(Ljava/lang/String;)V
    .locals 6

    .line 1013
    iget v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentViewId:I

    const v1, 0x7f090138

    if-ne v0, v1, :cond_1

    .line 1014
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelType:Ljava/lang/String;

    .line 1015
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelType:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f1100f9

    .line 1016
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 1017
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideAnalogMenu()V

    goto/16 :goto_6

    .line 1019
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideDigitalMenu()V

    goto/16 :goto_6

    :cond_1
    const v1, 0x7f090115

    const-string v2, "InterPhoneChannelActivity"

    if-eq v0, v1, :cond_1f

    const v1, 0x7f090117

    if-eq v0, v1, :cond_1f

    const v1, 0x7f090116

    if-ne v0, v1, :cond_2

    goto/16 :goto_5

    :cond_2
    const v1, 0x7f090123

    if-ne v0, v1, :cond_3

    .line 1036
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelPower:Ljava/lang/String;

    .line 1037
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelPower:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_3
    const v1, 0x7f09010c

    if-ne v0, v1, :cond_4

    .line 1039
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelColor:Ljava/lang/String;

    .line 1040
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelColor:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_4
    const v1, 0x7f09011e

    if-ne v0, v1, :cond_5

    .line 1042
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInputMode:Ljava/lang/String;

    .line 1043
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInputMode:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_5
    const v1, 0x7f09012b

    if-ne v0, v1, :cond_6

    .line 1045
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSlot:Ljava/lang/String;

    .line 1046
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSlot:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_6
    const v1, 0x7f09010e

    const/16 v3, 0x8

    const/4 v4, 0x0

    if-ne v0, v1, :cond_a

    .line 1048
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelContactType:Ljava/lang/String;

    .line 1049
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelContactType:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f1100b0

    .line 1050
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const v1, 0x7f090108

    if-eqz v0, :cond_7

    .line 1051
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    goto/16 :goto_6

    :cond_7
    const v0, 0x7f1100b3

    .line 1054
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const v2, 0x7f09010a

    if-eqz v0, :cond_8

    .line 1055
    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    const v0, 0x7f1100a8

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    goto :goto_0

    :cond_8
    const v0, 0x7f1100b2

    .line 1057
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_9

    .line 1058
    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    const v0, 0x7f1100aa

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(I)V

    .line 1061
    :cond_9
    :goto_0
    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v4}, Landroid/view/View;->setVisibility(I)V

    goto/16 :goto_6

    :cond_a
    const v1, 0x7f090109

    if-ne v0, v1, :cond_b

    .line 1065
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelCallName:Ljava/lang/String;

    .line 1066
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {v0, p1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_b
    const v1, 0x7f090112

    if-ne v0, v1, :cond_d

    .line 1068
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelEncryption:Ljava/lang/String;

    .line 1069
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelEncryption:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f1100bd

    .line 1070
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const v0, 0x7f090110

    if-eqz p1, :cond_c

    .line 1071
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    goto/16 :goto_6

    .line 1073
    :cond_c
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v4}, Landroid/view/View;->setVisibility(I)V

    goto/16 :goto_6

    :cond_d
    const v1, 0x7f090125

    if-ne v0, v1, :cond_e

    .line 1076
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRelayDisconnet:Ljava/lang/String;

    .line 1077
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRelayDisconnet:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_e
    const v1, 0x7f09011c

    if-ne v0, v1, :cond_f

    .line 1079
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInterruptTransmission:Ljava/lang/String;

    .line 1080
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelInterruptTransmission:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1081
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCurrentChannelInterruptTransmission = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelInterruptTransmission:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const v0, 0x7f1100d4

    .line 1082
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_22

    const p1, 0x7f11010b

    .line 1083
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->showToast(I)V

    goto/16 :goto_6

    :cond_f
    const v1, 0x7f090107

    if-ne v0, v1, :cond_10

    .line 1086
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelBand:Ljava/lang/String;

    .line 1087
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelBand:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_10
    const v1, 0x7f090131

    if-ne v0, v1, :cond_11

    .line 1089
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelSq:Ljava/lang/String;

    .line 1090
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelSq:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_11
    const v1, 0x7f090129

    const-string v2, "0"

    if-ne v0, v1, :cond_17

    .line 1092
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxtype:Ljava/lang/String;

    .line 1093
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxtype:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f1100ec

    .line 1094
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const v5, 0x7f090126

    if-eqz v1, :cond_12

    .line 1095
    invoke-virtual {p0, v5}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v3}, Landroid/view/View;->setVisibility(I)V

    goto :goto_1

    .line 1097
    :cond_12
    invoke-virtual {p0, v5}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 1099
    :goto_1
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_13

    .line 1100
    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_2

    :cond_13
    const v0, 0x7f1100e9

    .line 1101
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_14

    .line 1102
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubCtc:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_2

    :cond_14
    const v0, 0x7f1100eb

    .line 1103
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_15

    .line 1104
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubFDcs:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    goto :goto_2

    :cond_15
    const v0, 0x7f1100ea

    .line 1105
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_16

    .line 1106
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelRxSubBDcs:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    .line 1108
    :cond_16
    :goto_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto/16 :goto_6

    :cond_17
    const v1, 0x7f090136

    if-ne v0, v1, :cond_1d

    .line 1110
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxtype:Ljava/lang/String;

    .line 1111
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxtype:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f1100f5

    .line 1112
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const v5, 0x7f090133

    if-eqz v1, :cond_18

    .line 1113
    invoke-virtual {p0, v5}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v3}, Landroid/view/View;->setVisibility(I)V

    goto :goto_3

    .line 1115
    :cond_18
    invoke-virtual {p0, v5}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 1118
    :goto_3
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_19

    .line 1119
    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_4

    :cond_19
    const v0, 0x7f1100f2

    .line 1120
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1a

    .line 1121
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubCtc:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_4

    :cond_1a
    const v0, 0x7f1100f4

    .line 1122
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1b

    .line 1123
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubFDcs:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    goto :goto_4

    :cond_1b
    const v0, 0x7f1100f3

    .line 1124
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1c

    .line 1125
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mDataChannelTxSubBDcs:Ljava/util/ArrayList;

    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    .line 1127
    :cond_1c
    :goto_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_6

    :cond_1d
    const v1, 0x7f090134

    if-ne v0, v1, :cond_1e

    .line 1129
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelTxSub:Ljava/lang/String;

    .line 1130
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelTxSub:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_6

    :cond_1e
    const v1, 0x7f090127

    if-ne v0, v1, :cond_22

    .line 1132
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelRxSub:Ljava/lang/String;

    .line 1133
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelRxSub:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_6

    .line 1024
    :cond_1f
    :goto_5
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    .line 1025
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelFrqBand:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p1, 0x7f1100cb

    .line 1026
    invoke-virtual {p0, p1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_20

    .line 1027
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    const v0, 0x7f1100c2

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setHint(I)V

    .line 1028
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setHint(I)V

    goto :goto_6

    :cond_20
    const p1, 0x7f1100cc

    .line 1029
    invoke-virtual {p0, p1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentChannelFrqBand:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_21

    .line 1030
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    const v0, 0x7f1100c3

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setHint(I)V

    .line 1031
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setHint(I)V

    goto :goto_6

    :cond_21
    const-string p1, "channel frequency band error"

    .line 1033
    invoke-static {v2, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1135
    :cond_22
    :goto_6
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p0}, Landroid/widget/PopupWindow;->dismiss()V

    return-void
.end method

.method public showProgressDialog(Ljava/lang/String;)V
    .locals 1

    .line 671
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    if-nez v0, :cond_0

    .line 672
    new-instance v0, Landroid/app/ProgressDialog;

    invoke-direct {v0, p0}, Landroid/app/ProgressDialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    .line 675
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v0, p1}, Landroid/app/ProgressDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 676
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/app/ProgressDialog;->setCancelable(Z)V

    .line 677
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {p0}, Landroid/app/ProgressDialog;->show()V

    return-void
.end method

.method public updateSelectedItem(I)V
    .locals 7

    .line 1140
    iput p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentViewId:I

    .line 1142
    sget-object v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->LIN_RES_ID:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const v2, 0x7f090117

    const v3, 0x7f090116

    const v4, 0x7f090115

    const/4 v5, 0x1

    if-eqz v1, :cond_4

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    if-eq p1, v4, :cond_0

    if-eq p1, v3, :cond_0

    if-ne p1, v2, :cond_1

    .line 1150
    :cond_0
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result v6

    if-eq v6, v4, :cond_3

    .line 1151
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    if-eq v4, v3, :cond_3

    .line 1152
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    if-ne v3, v2, :cond_1

    goto :goto_2

    .line 1155
    :cond_1
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-virtual {p0, v2}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ne p1, v1, :cond_2

    goto :goto_1

    :cond_2
    const/4 v5, 0x0

    :goto_1
    invoke-virtual {v2, v5}, Landroid/view/View;->setSelected(Z)V

    goto :goto_0

    .line 1153
    :cond_3
    :goto_2
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-virtual {p0, v1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1, v5}, Landroid/view/View;->setSelected(Z)V

    goto :goto_0

    .line 1158
    :cond_4
    iget p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentViewId:I

    const v0, 0x7f090121

    if-eq p1, v0, :cond_5

    .line 1159
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->clearFocus()V

    .line 1160
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideKeyboard(Landroid/os/IBinder;)V

    goto :goto_3

    .line 1162
    :cond_5
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditChannelName:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->requestFocus()Z

    .line 1165
    :goto_3
    iget p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentViewId:I

    if-eq p1, v4, :cond_7

    if-eq p1, v3, :cond_7

    if-eq p1, v2, :cond_7

    .line 1168
    iget p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentFrequency:I

    if-nez p1, :cond_6

    .line 1169
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->clearFocus()V

    .line 1170
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideKeyboard(Landroid/os/IBinder;)V

    goto :goto_4

    :cond_6
    if-ne p1, v5, :cond_9

    .line 1172
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->clearFocus()V

    .line 1173
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideKeyboard(Landroid/os/IBinder;)V

    goto :goto_4

    .line 1176
    :cond_7
    iget p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentFrequency:I

    if-nez p1, :cond_8

    .line 1177
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncySend:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->requestFocus()Z

    goto :goto_4

    :cond_8
    if-ne p1, v5, :cond_9

    .line 1179
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mEditFrequncyRecieve:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->requestFocus()Z

    .line 1184
    :cond_9
    :goto_4
    iget p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mCurrentViewId:I

    const v0, 0x7f090109

    if-eq p1, v0, :cond_a

    .line 1185
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->clearFocus()V

    .line 1186
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->hideKeyboard(Landroid/os/IBinder;)V

    goto :goto_5

    .line 1188
    :cond_a
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->mTvChannelCallNumber:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->requestFocus()Z

    :goto_5
    return-void
.end method
