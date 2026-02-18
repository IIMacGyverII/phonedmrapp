.class Lcom/pri/prizeinterphone/config/ConfigXmlPullParser$SingletonHolder;
.super Ljava/lang/Object;
.source "ConfigXmlPullParser.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "SingletonHolder"
.end annotation


# static fields
.field private static final INSTANCE:Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;


# direct methods
.method static bridge synthetic -$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;
    .locals 1

    sget-object v0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser$SingletonHolder;->INSTANCE:Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 41
    new-instance v0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;-><init>(Landroid/content/Context;Lcom/pri/prizeinterphone/config/ConfigXmlPullParser-IA;)V

    sput-object v0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser$SingletonHolder;->INSTANCE:Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
