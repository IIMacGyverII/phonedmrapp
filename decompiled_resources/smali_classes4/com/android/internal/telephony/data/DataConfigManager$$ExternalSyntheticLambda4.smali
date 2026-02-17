.class public final synthetic Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;->f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;

    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    return-void
.end method
