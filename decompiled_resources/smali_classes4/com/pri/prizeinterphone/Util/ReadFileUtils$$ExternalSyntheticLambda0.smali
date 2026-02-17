.class public final synthetic Lcom/pri/prizeinterphone/Util/ReadFileUtils$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Ljava/util/StringJoiner;


# direct methods
.method public synthetic constructor <init>(Ljava/util/StringJoiner;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/ReadFileUtils$$ExternalSyntheticLambda0;->f$0:Ljava/util/StringJoiner;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ReadFileUtils$$ExternalSyntheticLambda0;->f$0:Ljava/util/StringJoiner;

    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/util/StringJoiner;->add(Ljava/lang/CharSequence;)Ljava/util/StringJoiner;

    return-void
.end method
