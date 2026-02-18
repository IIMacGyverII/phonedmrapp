.class public final Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
.super Ljava/lang/Object;
.source "YModemTXMsg.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "YModemTXMsgBuilder"
.end annotation


# instance fields
.field private currentSent:I

.field private step:I

.field private total:I


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static anYModemTXMsg()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
    .locals 1

    .line 72
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;-><init>()V

    return-object v0
.end method


# virtual methods
.method public build()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;
    .locals 2

    .line 91
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;-><init>(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg-IA;)V

    .line 92
    iget v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->total:I

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->-$$Nest$fputtotal(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V

    .line 93
    iget v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->currentSent:I

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->-$$Nest$fputcurrentSent(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V

    .line 94
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->step:I

    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->-$$Nest$fputstep(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V

    return-object v0
.end method

.method public withCurrentSent(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
    .locals 0

    .line 81
    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->currentSent:I

    return-object p0
.end method

.method public withStep(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
    .locals 0

    .line 76
    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->step:I

    return-object p0
.end method

.method public withTotal(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
    .locals 0

    .line 86
    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->total:I

    return-object p0
.end method
