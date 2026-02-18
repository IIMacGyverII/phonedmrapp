.class public final synthetic Lcom/pri/prizeinterphone/manager/DmrManager$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:B


# direct methods
.method public synthetic constructor <init>(B)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-byte p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager$$ExternalSyntheticLambda0;->f$0:B

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-byte p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager$$ExternalSyntheticLambda0;->f$0:B

    check-cast p1, Lcom/pri/prizeinterphone/manager/InterruptResultListener;

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->$r8$lambda$_RvfhDvk8D8j-ny2jgBpT_ZwMOM(BLcom/pri/prizeinterphone/manager/InterruptResultListener;)V

    return-void
.end method
