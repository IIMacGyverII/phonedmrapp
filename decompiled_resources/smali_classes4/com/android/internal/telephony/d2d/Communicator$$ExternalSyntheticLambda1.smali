.class public final synthetic Lcom/android/internal/telephony/d2d/Communicator$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Ljava/util/Optional;


# direct methods
.method public synthetic constructor <init>(Ljava/util/Optional;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/d2d/Communicator$$ExternalSyntheticLambda1;->f$0:Ljava/util/Optional;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/d2d/Communicator$$ExternalSyntheticLambda1;->f$0:Ljava/util/Optional;

    check-cast p1, Lcom/android/internal/telephony/d2d/TransportProtocol;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/d2d/Communicator;->$r8$lambda$IPKm6P0RsLFXM_Ibt_4qq_tY3cg(Ljava/util/Optional;Lcom/android/internal/telephony/d2d/TransportProtocol;)Z

    move-result p0

    return p0
.end method
