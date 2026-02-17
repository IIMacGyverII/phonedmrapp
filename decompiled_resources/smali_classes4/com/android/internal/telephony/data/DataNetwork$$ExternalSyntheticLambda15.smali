.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda15;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda15;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda15;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    check-cast p1, Landroid/telephony/data/DataCallResponse;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->$r8$lambda$Ubr8k8tZ5l0hV5IbEsIVYy85Pfc(Lcom/android/internal/telephony/data/DataNetwork;Landroid/telephony/data/DataCallResponse;)Z

    move-result p0

    return p0
.end method
