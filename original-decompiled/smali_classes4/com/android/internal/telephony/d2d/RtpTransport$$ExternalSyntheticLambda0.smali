.class public final synthetic Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Function;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/d2d/RtpTransport;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/d2d/RtpTransport;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/d2d/RtpTransport;

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/d2d/RtpTransport;

    check-cast p1, Landroid/telephony/ims/RtpHeaderExtension;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->$r8$lambda$qq-ZNu_Bmu1UtX9Upvh3dQtiDTk(Lcom/android/internal/telephony/d2d/RtpTransport;Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;

    move-result-object p0

    return-object p0
.end method
