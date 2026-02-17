.class public final synthetic Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda29;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda29;->f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda29;->f$0:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->$r8$lambda$zMuDJu502zGij7RvXw5L6AY3yKk(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method
