.class Lcom/pri/prizeinterphone/config/tag/XmlTagManager$SingletonHolder;
.super Ljava/lang/Object;
.source "XmlTagManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/config/tag/XmlTagManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "SingletonHolder"
.end annotation


# static fields
.field private static final INSTANCE:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;


# direct methods
.method static bridge synthetic -$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/config/tag/XmlTagManager;
    .locals 1

    sget-object v0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager$SingletonHolder;->INSTANCE:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 172
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;-><init>(Lcom/pri/prizeinterphone/config/tag/XmlTagManager-IA;)V

    sput-object v0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager$SingletonHolder;->INSTANCE:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 171
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
