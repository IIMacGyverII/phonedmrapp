.class public Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
.super Ljava/io/PrintWriter;
.source "IndentingPrintWriter.java"


# instance fields
.field private mCurrentIndent:[C

.field private mCurrentLength:I

.field private mEmptyLine:Z

.field private mIndentBuilder:Ljava/lang/StringBuilder;

.field private mSingleChar:[C

.field private final mSingleIndent:Ljava/lang/String;

.field private final mWrapLength:I


# direct methods
.method public constructor <init>(Ljava/io/Writer;)V
    .locals 2

    const-string v0, "  "

    const/4 v1, -0x1

    .line 56
    invoke-direct {p0, p1, v0, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;)V
    .locals 2

    const/4 v0, 0x0

    const/4 v1, -0x1

    .line 60
    invoke-direct {p0, p1, p2, v0, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;I)V
    .locals 1

    const/4 v0, 0x0

    .line 70
    invoke-direct {p0, p1, p2, v0, p3}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    const/4 v0, -0x1

    .line 65
    invoke-direct {p0, p1, p2, p3, v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method public constructor <init>(Ljava/io/Writer;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 1

    .line 75
    invoke-direct {p0, p1}, Ljava/io/PrintWriter;-><init>(Ljava/io/Writer;)V

    .line 41
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    const/4 v0, 0x1

    .line 51
    iput-boolean v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    new-array v0, v0, [C

    .line 53
    iput-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mSingleChar:[C

    .line 76
    iput-object p2, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mSingleIndent:Ljava/lang/String;

    .line 77
    iput p4, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mWrapLength:I

    if-eqz p3, :cond_0

    .line 79
    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_0
    return-void
.end method

.method private maybeWriteIndent()V
    .locals 3

    .line 242
    iget-boolean v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    if-eqz v0, :cond_1

    const/4 v0, 0x0

    .line 243
    iput-boolean v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    .line 244
    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    if-eqz v1, :cond_1

    .line 245
    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    if-nez v1, :cond_0

    .line 246
    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->toCharArray()[C

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    .line 248
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    array-length v2, v1

    invoke-super {p0, v1, v0, v2}, Ljava/io/PrintWriter;->write([CII)V

    :cond_1
    return-void
.end method


# virtual methods
.method public decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 3

    .line 130
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mSingleIndent:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;

    const/4 v0, 0x0

    .line 131
    iput-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    return-object p0
.end method

.method public increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 2

    .line 120
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mSingleIndent:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v0, 0x0

    .line 121
    iput-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    return-object p0
.end method

.method public print(Ljava/lang/String;Ljava/lang/Object;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 2

    if-nez p2, :cond_0

    const-string p2, "null"

    goto/16 :goto_0

    .line 143
    :cond_0
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->isArray()Z

    move-result v0

    if-eqz v0, :cond_9

    .line 144
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [Z

    if-ne v0, v1, :cond_1

    .line 145
    check-cast p2, [Z

    invoke-static {p2}, Ljava/util/Arrays;->toString([Z)Ljava/lang/String;

    move-result-object p2

    goto/16 :goto_0

    .line 146
    :cond_1
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [B

    if-ne v0, v1, :cond_2

    .line 147
    check-cast p2, [B

    invoke-static {p2}, Ljava/util/Arrays;->toString([B)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 148
    :cond_2
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [C

    if-ne v0, v1, :cond_3

    .line 149
    check-cast p2, [C

    invoke-static {p2}, Ljava/util/Arrays;->toString([C)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 150
    :cond_3
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [D

    if-ne v0, v1, :cond_4

    .line 151
    check-cast p2, [D

    invoke-static {p2}, Ljava/util/Arrays;->toString([D)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 152
    :cond_4
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [F

    if-ne v0, v1, :cond_5

    .line 153
    check-cast p2, [F

    invoke-static {p2}, Ljava/util/Arrays;->toString([F)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 154
    :cond_5
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [I

    if-ne v0, v1, :cond_6

    .line 155
    check-cast p2, [I

    invoke-static {p2}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 156
    :cond_6
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [J

    if-ne v0, v1, :cond_7

    .line 157
    check-cast p2, [J

    invoke-static {p2}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 158
    :cond_7
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, [S

    if-ne v0, v1, :cond_8

    .line 159
    check-cast p2, [S

    invoke-static {p2}, Ljava/util/Arrays;->toString([S)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 161
    :cond_8
    check-cast p2, [Ljava/lang/Object;

    invoke-static {p2}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 164
    :cond_9
    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    .line 166
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    return-object p0
.end method

.method public printHexInt(Ljava/lang/String;I)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 1

    .line 175
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "=0x"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    return-object p0
.end method

.method public println()V
    .locals 1

    const/16 v0, 0xa

    .line 181
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->write(I)V

    return-void
.end method

.method public setIndent(I)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 108
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->setLength(I)V

    :goto_0
    if-ge v1, p1, :cond_0

    .line 110
    invoke-virtual {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object p0
.end method

.method public setIndent(Ljava/lang/String;)Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 92
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->setLength(I)V

    .line 93
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p1, 0x0

    .line 94
    iput-object p1, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentIndent:[C

    return-object p0
.end method

.method public write(I)V
    .locals 2

    .line 186
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mSingleChar:[C

    int-to-char p1, p1

    const/4 v1, 0x0

    aput-char p1, v0, v1

    const/4 p1, 0x1

    .line 187
    invoke-virtual {p0, v0, v1, p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->write([CII)V

    return-void
.end method

.method public write(Ljava/lang/String;II)V
    .locals 3

    .line 192
    new-array v0, p3, [C

    sub-int v1, p3, p2

    const/4 v2, 0x0

    .line 193
    invoke-virtual {p1, p2, v1, v0, v2}, Ljava/lang/String;->getChars(II[CI)V

    .line 194
    invoke-virtual {p0, v0, v2, p3}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->write([CII)V

    return-void
.end method

.method public write([CII)V
    .locals 7

    .line 199
    iget-object v0, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mIndentBuilder:Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v0

    add-int/2addr p3, p2

    move v1, p2

    :goto_0
    if-ge p2, p3, :cond_3

    add-int/lit8 v2, p2, 0x1

    .line 206
    aget-char p2, p1, p2

    .line 207
    iget v3, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    const/4 v4, 0x1

    add-int/2addr v3, v4

    iput v3, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    const/4 v3, 0x0

    const/16 v5, 0xa

    if-ne p2, v5, :cond_0

    .line 209
    invoke-direct {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->maybeWriteIndent()V

    sub-int p2, v2, v1

    .line 210
    invoke-super {p0, p1, v1, p2}, Ljava/io/PrintWriter;->write([CII)V

    .line 212
    iput-boolean v4, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    .line 213
    iput v3, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    move v1, v2

    .line 217
    :cond_0
    iget p2, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mWrapLength:I

    if-lez p2, :cond_2

    iget v6, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    sub-int/2addr p2, v0

    if-lt v6, p2, :cond_2

    .line 218
    iget-boolean p2, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    if-nez p2, :cond_1

    .line 220
    invoke-super {p0, v5}, Ljava/io/PrintWriter;->write(I)V

    .line 221
    iput-boolean v4, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    sub-int p2, v2, v1

    .line 222
    iput p2, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    goto :goto_1

    .line 225
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->maybeWriteIndent()V

    sub-int p2, v2, v1

    .line 226
    invoke-super {p0, p1, v1, p2}, Ljava/io/PrintWriter;->write([CII)V

    .line 227
    invoke-super {p0, v5}, Ljava/io/PrintWriter;->write(I)V

    .line 228
    iput-boolean v4, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mEmptyLine:Z

    .line 230
    iput v3, p0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->mCurrentLength:I

    move v1, v2

    :cond_2
    :goto_1
    move p2, v2

    goto :goto_0

    :cond_3
    if-eq v1, p2, :cond_4

    .line 236
    invoke-direct {p0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->maybeWriteIndent()V

    sub-int/2addr p2, v1

    .line 237
    invoke-super {p0, p1, v1, p2}, Ljava/io/PrintWriter;->write([CII)V

    :cond_4
    return-void
.end method
