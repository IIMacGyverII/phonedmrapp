.class public Lcom/android/internal/telephony/phonenumbers/NumberParseException;
.super Ljava/lang/Exception;
.source "NumberParseException.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;
    }
.end annotation


# instance fields
.field private errorType:Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;

.field private message:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;Ljava/lang/String;)V
    .locals 0

    .line 60
    invoke-direct {p0, p2}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    .line 61
    iput-object p2, p0, Lcom/android/internal/telephony/phonenumbers/NumberParseException;->message:Ljava/lang/String;

    .line 62
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/NumberParseException;->errorType:Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;

    return-void
.end method


# virtual methods
.method public getErrorType()Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;
    .locals 0

    .line 69
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/NumberParseException;->errorType:Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 74
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Error type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/NumberParseException;->errorType:Lcom/android/internal/telephony/phonenumbers/NumberParseException$ErrorType;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ". "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/NumberParseException;->message:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
