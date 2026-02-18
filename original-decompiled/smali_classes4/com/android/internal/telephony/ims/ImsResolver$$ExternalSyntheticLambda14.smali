.class public final synthetic Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/ims/ImsResolver;

.field public final synthetic f$1:Ljava/util/concurrent/CompletableFuture;

.field public final synthetic f$2:I

.field public final synthetic f$3:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/CompletableFuture;II)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iput-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$1:Ljava/util/concurrent/CompletableFuture;

    iput p3, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$2:I

    iput p4, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$3:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$1:Ljava/util/concurrent/CompletableFuture;

    iget v2, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$2:I

    iget p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda14;->f$3:I

    invoke-static {v0, v1, v2, p0}, Lcom/android/internal/telephony/ims/ImsResolver;->$r8$lambda$xLd43Oh4UfXMY5LqEzxz20Rr348(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/CompletableFuture;II)V

    return-void
.end method
