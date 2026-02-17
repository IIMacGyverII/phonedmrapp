.class public final synthetic Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/dataconnection/TransportManager;

.field public final synthetic f$1:I

.field public final synthetic f$2:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/TransportManager;II)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/dataconnection/TransportManager;

    iput p2, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$1:I

    iput p3, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$2:I

    return-void
.end method


# virtual methods
.method public final onCompleted(ZZ)V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/dataconnection/TransportManager;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$1:I

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;->f$2:I

    invoke-static {v0, v1, p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/TransportManager;->$r8$lambda$LZWHj72eRdQFUv9LCRqk7lYws5s(Lcom/android/internal/telephony/dataconnection/TransportManager;IIZZ)V

    return-void
.end method
