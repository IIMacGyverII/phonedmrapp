.class public Lcom/android/internal/telephony/IndentingPrintWriter;
.super Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
.source "IndentingPrintWriter.java"


# annotations
.annotation runtime Ljava/lang/Deprecated;
.end annotation


# direct methods
.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;)V
    .locals 1

    const/4 v0, -0x1

    .line 32
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;I)V
    .locals 0

    .line 36
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    .line 40
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method


# virtual methods
.method public bridge synthetic decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 0

    .line 27
    invoke-virtual {p0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    move-result-object p0

    return-object p0
.end method

.method public decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 61
    invoke-super {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public bridge synthetic increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 0

    .line 27
    invoke-virtual {p0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    move-result-object p0

    return-object p0
.end method

.method public increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 55
    invoke-super {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public printHexPair(Ljava/lang/String;I)Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 76
    invoke-super {p0, p1, p2}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->printHexInt(Ljava/lang/String;I)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public printPair(Ljava/lang/String;Ljava/lang/Object;)Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 66
    invoke-super {p0, p1, p2}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->print(Ljava/lang/String;Ljava/lang/Object;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public printPair(Ljava/lang/String;[Ljava/lang/Object;)Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 71
    invoke-super {p0, p1, p2}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->print(Ljava/lang/String;Ljava/lang/Object;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public bridge synthetic setIndent(I)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 0

    .line 27
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->setIndent(I)Lcom/android/internal/telephony/IndentingPrintWriter;

    move-result-object p0

    return-object p0
.end method

.method public bridge synthetic setIndent(Ljava/lang/String;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 0

    .line 27
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->setIndent(Ljava/lang/String;)Lcom/android/internal/telephony/IndentingPrintWriter;

    move-result-object p0

    return-object p0
.end method

.method public setIndent(I)Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 49
    invoke-super {p0, p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->setIndent(I)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method

.method public setIndent(Ljava/lang/String;)Lcom/android/internal/telephony/IndentingPrintWriter;
    .locals 0

    .line 44
    invoke-super {p0, p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->setIndent(Ljava/lang/String;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-object p0
.end method
