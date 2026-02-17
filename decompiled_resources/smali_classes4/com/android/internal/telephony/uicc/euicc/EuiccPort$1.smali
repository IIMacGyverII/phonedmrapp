.class Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;
.super Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;
.source "EuiccPort.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->sendApdu(Lcom/android/internal/telephony/uicc/euicc/apdu/RequestProvider;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

.field final synthetic val$callback:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

.field final synthetic val$exceptionHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;

.field final synthetic val$intermediateResultHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;

.field final synthetic val$responseHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/euicc/EuiccPort;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;)V
    .locals 0

    .line 1193
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->this$0:Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    iput-object p2, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$callback:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    iput-object p3, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$responseHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;

    iput-object p4, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$intermediateResultHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;

    iput-object p5, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$exceptionHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/euicc/apdu/ApduSenderResultCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onException(Ljava/lang/Throwable;)V
    .locals 0

    .line 1216
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$exceptionHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;->handleException(Ljava/lang/Throwable;)V

    return-void
.end method

.method public bridge synthetic onResult(Ljava/lang/Object;)V
    .locals 0

    .line 1193
    check-cast p1, [B

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->onResult([B)V

    return-void
.end method

.method public onResult([B)V
    .locals 4

    .line 1197
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$callback:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$responseHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;

    invoke-interface {v1, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;->handleResult([B)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;->onResult(Ljava/lang/Object;)V
    :try_end_0
    .catch Lcom/android/internal/telephony/uicc/euicc/EuiccCardException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Lcom/android/internal/telephony/uicc/asn1/InvalidAsn1DataException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lcom/android/internal/telephony/uicc/asn1/TagNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1201
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$callback:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    new-instance v1, Lcom/android/internal/telephony/uicc/euicc/EuiccCardException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Cannot parse response: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1202
    invoke-static {p1}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v1, p1, v0}, Lcom/android/internal/telephony/uicc/euicc/EuiccCardException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 1201
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;->onException(Ljava/lang/Throwable;)V

    goto :goto_0

    :catch_1
    move-exception p1

    .line 1199
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$callback:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;->onException(Ljava/lang/Throwable;)V

    :goto_0
    return-void
.end method

.method public shouldContinueOnIntermediateResult(Lcom/android/internal/telephony/uicc/IccIoResult;)Z
    .locals 0

    .line 1208
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$1;->val$intermediateResultHandler:Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    .line 1211
    :cond_0
    invoke-interface {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduIntermediateResultHandler;->shouldContinue(Lcom/android/internal/telephony/uicc/IccIoResult;)Z

    move-result p0

    return p0
.end method
