.class public final synthetic Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Landroid/telephony/data/DataProfile;

.field public final synthetic f$1:J

.field public final synthetic f$2:I


# direct methods
.method public synthetic constructor <init>(Landroid/telephony/data/DataProfile;JI)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$0:Landroid/telephony/data/DataProfile;

    iput-wide p2, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$1:J

    iput p4, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$2:I

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$0:Landroid/telephony/data/DataProfile;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$1:J

    iget p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;->f$2:I

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    invoke-static {v0, v1, v2, p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->$r8$lambda$KZfGK4Zigmfu6HLLSkTl-VHbguc(Landroid/telephony/data/DataProfile;JILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method
