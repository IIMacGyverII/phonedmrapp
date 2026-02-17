.class Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache$1;
.super Ljava/util/LinkedHashMap;
.source "RegexCache.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;-><init>(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/util/LinkedHashMap<",
        "TK;TV;>;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;IFZ)V
    .locals 0

    .line 58
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache$1;->this$0:Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;

    invoke-direct {p0, p2, p3, p4}, Ljava/util/LinkedHashMap;-><init>(IFZ)V

    return-void
.end method


# virtual methods
.method protected removeEldestEntry(Ljava/util/Map$Entry;)Z
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map$Entry<",
            "TK;TV;>;)Z"
        }
    .end annotation

    .line 61
    invoke-virtual {p0}, Ljava/util/LinkedHashMap;->size()I

    move-result p1

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache$1;->this$0:Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;

    invoke-static {p0}, Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;->access$000(Lcom/android/internal/telephony/phonenumbers/internal/RegexCache$LRUCache;)I

    move-result p0

    if-le p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
