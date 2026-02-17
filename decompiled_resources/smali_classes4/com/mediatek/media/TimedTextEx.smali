.class public Lcom/mediatek/media/TimedTextEx;
.super Ljava/lang/Object;
.source "TimedTextEx.java"


# static fields
.field private static final CLASS_NAME:Ljava/lang/String; = "android.media.TimedText"

.field private static final FD_FIELD_NAME:Ljava/lang/String; = "mBitMapFd"

.field private static final HEIGHT_FIELD_NAME:Ljava/lang/String; = "mBitMapHeight"

.field private static final TAG:Ljava/lang/String; = "TimedTextEx"

.field private static final TEXT_FIELD_NAME:Ljava/lang/String; = "mTextByteChars"

.field private static final WIDTH_FIELD_NAME:Ljava/lang/String; = "mBitMapWidth"

.field private static fdField:Ljava/lang/reflect/Field;

.field private static heightField:Ljava/lang/reflect/Field;

.field private static textField:Ljava/lang/reflect/Field;

.field private static widthField:Ljava/lang/reflect/Field;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "@M_TimedTextEx"

    :try_start_0
    const-string v1, "android.media.TimedText"

    .line 50
    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "mTextByteChars"

    .line 52
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    sput-object v2, Lcom/mediatek/media/TimedTextEx;->textField:Ljava/lang/reflect/Field;

    const-string v2, "mBitMapWidth"

    .line 53
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    sput-object v2, Lcom/mediatek/media/TimedTextEx;->widthField:Ljava/lang/reflect/Field;

    const-string v2, "mBitMapHeight"

    .line 54
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    sput-object v2, Lcom/mediatek/media/TimedTextEx;->heightField:Ljava/lang/reflect/Field;

    const-string v2, "mBitMapFd"

    .line 55
    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    sput-object v1, Lcom/mediatek/media/TimedTextEx;->fdField:Ljava/lang/reflect/Field;

    .line 57
    sget-object v1, Lcom/mediatek/media/TimedTextEx;->textField:Ljava/lang/reflect/Field;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 58
    sget-object v1, Lcom/mediatek/media/TimedTextEx;->widthField:Ljava/lang/reflect/Field;

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 59
    sget-object v1, Lcom/mediatek/media/TimedTextEx;->heightField:Ljava/lang/reflect/Field;

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 60
    sget-object v1, Lcom/mediatek/media/TimedTextEx;->fdField:Ljava/lang/reflect/Field;

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/NoSuchFieldException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/ClassNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string v1, "ClassNotFoundException: android.media.TimedText"

    .line 65
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catch_1
    const-string v1, "NoSuchFieldException"

    .line 63
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getBitmapFd(Landroid/media/TimedText;)I
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;,
            Ljava/lang/IllegalAccessException;
        }
    .end annotation

    .line 122
    sget-object v0, Lcom/mediatek/media/TimedTextEx;->fdField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public static getBitmapHeight(Landroid/media/TimedText;)I
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;,
            Ljava/lang/IllegalAccessException;
        }
    .end annotation

    .line 108
    sget-object v0, Lcom/mediatek/media/TimedTextEx;->heightField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public static getBitmapWidth(Landroid/media/TimedText;)I
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;,
            Ljava/lang/IllegalAccessException;
        }
    .end annotation

    .line 94
    sget-object v0, Lcom/mediatek/media/TimedTextEx;->widthField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public static getTextByteChars(Landroid/media/TimedText;)[B
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;,
            Ljava/lang/IllegalAccessException;
        }
    .end annotation

    .line 80
    sget-object v0, Lcom/mediatek/media/TimedTextEx;->textField:Ljava/lang/reflect/Field;

    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [B

    return-object p0
.end method
