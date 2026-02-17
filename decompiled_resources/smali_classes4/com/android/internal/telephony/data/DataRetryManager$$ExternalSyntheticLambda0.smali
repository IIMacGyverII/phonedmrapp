.class public final synthetic Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;

.field public final synthetic f$1:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/data/DataNetwork;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/DataRetryManager;->$r8$lambda$AsR2WE65TN2gfQqbLq9H_uu9V7c(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method
