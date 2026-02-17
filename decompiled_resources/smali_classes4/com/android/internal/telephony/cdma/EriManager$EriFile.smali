.class Lcom/android/internal/telephony/cdma/EriManager$EriFile;
.super Ljava/lang/Object;
.source "EriManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cdma/EriManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "EriFile"
.end annotation


# instance fields
.field mCallPromptId:[Ljava/lang/String;

.field mEriFileType:I

.field mNumberOfEriEntries:I

.field mRoamIndTable:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/cdma/EriInfo;",
            ">;"
        }
    .end annotation
.end field

.field mVersionNumber:I

.field final synthetic this$0:Lcom/android/internal/telephony/cdma/EriManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/cdma/EriManager;)V
    .locals 1

    .line 55
    iput-object p1, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->this$0:Lcom/android/internal/telephony/cdma/EriManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, -0x1

    .line 56
    iput p1, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->mVersionNumber:I

    const/4 v0, 0x0

    .line 57
    iput v0, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->mNumberOfEriEntries:I

    .line 58
    iput p1, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->mEriFileType:I

    const-string p1, ""

    .line 59
    filled-new-array {p1, p1, p1}, [Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->mCallPromptId:[Ljava/lang/String;

    .line 60
    new-instance p1, Ljava/util/HashMap;

    invoke-direct {p1}, Ljava/util/HashMap;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/cdma/EriManager$EriFile;->mRoamIndTable:Ljava/util/HashMap;

    return-void
.end method
