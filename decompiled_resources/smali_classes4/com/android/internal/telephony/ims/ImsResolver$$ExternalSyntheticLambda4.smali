.class public final synthetic Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/ims/ImsResolver;

.field public final synthetic f$1:Ljava/util/concurrent/LinkedBlockingQueue;

.field public final synthetic f$2:Z

.field public final synthetic f$3:I

.field public final synthetic f$4:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/LinkedBlockingQueue;ZII)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iput-object p2, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$1:Ljava/util/concurrent/LinkedBlockingQueue;

    iput-boolean p3, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$2:Z

    iput p4, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$3:I

    iput p5, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$4:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/ims/ImsResolver;

    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$1:Ljava/util/concurrent/LinkedBlockingQueue;

    iget-boolean v2, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$2:Z

    iget v3, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$3:I

    iget p0, p0, Lcom/android/internal/telephony/ims/ImsResolver$$ExternalSyntheticLambda4;->f$4:I

    invoke-static {v0, v1, v2, v3, p0}, Lcom/android/internal/telephony/ims/ImsResolver;->$r8$lambda$YUaSCBwEWx3N5GJkdupwxvfzxcU(Lcom/android/internal/telephony/ims/ImsResolver;Ljava/util/concurrent/LinkedBlockingQueue;ZII)V

    return-void
.end method
