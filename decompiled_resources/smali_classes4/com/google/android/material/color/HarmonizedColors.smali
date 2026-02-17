.class public Lcom/google/android/material/color/HarmonizedColors;
.super Ljava/lang/Object;
.source "HarmonizedColors.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "HarmonizedColors"


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static addHarmonizedColorAttributesToReplacementMap(Ljava/util/Map;Landroid/content/res/TypedArray;Landroid/content/res/TypedArray;I)V
    .locals 4
    .param p0    # Ljava/util/Map;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p1    # Landroid/content/res/TypedArray;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p2    # Landroid/content/res/TypedArray;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p3    # I
        .annotation build Landroidx/annotation/ColorInt;
        .end annotation
    .end param
    .annotation build Landroidx/annotation/RequiresApi;
        api = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;",
            "Landroid/content/res/TypedArray;",
            "Landroid/content/res/TypedArray;",
            "I)V"
        }
    .end annotation

    if-eqz p2, :cond_0

    goto :goto_0

    :cond_0
    move-object p2, p1

    :goto_0
    const/4 v0, 0x0

    move v1, v0

    .line 152
    :goto_1
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->getIndexCount()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 153
    invoke-virtual {p2, v1, v0}, Landroid/content/res/TypedArray;->getResourceId(II)I

    move-result v2

    if-eqz v2, :cond_1

    .line 155
    invoke-virtual {p1, v1}, Landroid/content/res/TypedArray;->hasValue(I)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 156
    invoke-virtual {p1, v1}, Landroid/content/res/TypedArray;->getType(I)I

    move-result v3

    invoke-static {v3}, Lcom/google/android/material/color/HarmonizedColors;->isColorResource(I)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 157
    invoke-virtual {p1, v1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v3

    .line 159
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-static {v3, p3}, Lcom/google/android/material/color/MaterialColors;->harmonize(II)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 158
    invoke-interface {p0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    :cond_2
    return-void
.end method

.method private static addResourcesLoaderToContext(Landroid/content/Context;Lcom/google/android/material/color/HarmonizedColorsOptions;)Z
    .locals 3
    .annotation build Landroidx/annotation/RequiresApi;
        api = 0x1e
    .end annotation

    .line 88
    invoke-static {p1}, Lcom/google/android/material/color/HarmonizedColors;->createHarmonizedColorReplacementMap(Lcom/google/android/material/color/HarmonizedColorsOptions;)Ljava/util/Map;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/material/color/ColorResourcesLoaderCreator;->create(Landroid/content/Context;Ljava/util/Map;)Landroid/content/res/loader/ResourcesLoader;

    move-result-object p1

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    .line 90
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const/4 v1, 0x1

    new-array v2, v1, [Landroid/content/res/loader/ResourcesLoader;

    aput-object p1, v2, v0

    invoke-virtual {p0, v2}, Landroid/content/res/Resources;->addLoaders([Landroid/content/res/loader/ResourcesLoader;)V

    return v1

    :cond_0
    return v0
.end method

.method public static applyIfAvailable(Lcom/google/android/material/color/HarmonizedColorsOptions;)V
    .locals 2
    .param p0    # Lcom/google/android/material/color/HarmonizedColorsOptions;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 46
    invoke-static {}, Lcom/google/android/material/color/HarmonizedColors;->isHarmonizedColorAvailable()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 49
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 50
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getThemeOverlayResourceId()I

    move-result v1

    .line 52
    invoke-static {v0, p0}, Lcom/google/android/material/color/HarmonizedColors;->addResourcesLoaderToContext(Landroid/content/Context;Lcom/google/android/material/color/HarmonizedColorsOptions;)Z

    move-result p0

    if-eqz p0, :cond_1

    if-eqz v1, :cond_1

    .line 53
    invoke-static {v0, v1}, Lcom/google/android/material/color/ThemeUtils;->applyThemeOverlay(Landroid/content/Context;I)V

    :cond_1
    return-void
.end method

.method private static createHarmonizedColorReplacementMap(Lcom/google/android/material/color/HarmonizedColorsOptions;)Ljava/util/Map;
    .locals 8
    .annotation build Landroidx/annotation/RequiresApi;
        api = 0x15
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/google/android/material/color/HarmonizedColorsOptions;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 99
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 100
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 102
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getColorAttributeToHarmonizeWith()I

    move-result v2

    sget-object v3, Lcom/google/android/material/color/HarmonizedColors;->TAG:Ljava/lang/String;

    invoke-static {v0, v2, v3}, Lcom/google/android/material/color/MaterialColors;->getColor(Landroid/content/Context;ILjava/lang/String;)I

    move-result v2

    .line 105
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getColorResourcesIds()[I

    move-result-object v3

    array-length v4, v3

    const/4 v5, 0x0

    :goto_0
    if-ge v5, v4, :cond_0

    aget v6, v3, v5

    .line 108
    invoke-static {v0, v6}, Landroidx/core/content/ContextCompat;->getColor(Landroid/content/Context;I)I

    move-result v7

    .line 107
    invoke-static {v7, v2}, Lcom/google/android/material/color/MaterialColors;->harmonize(II)I

    move-result v7

    .line 109
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v1, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 112
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getColorAttributes()Lcom/google/android/material/color/HarmonizedColorAttributes;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 114
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorAttributes;->getAttributes()[I

    move-result-object v3

    .line 115
    array-length v4, v3

    if-lez v4, :cond_2

    .line 119
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorAttributes;->getThemeOverlay()I

    move-result p0

    .line 120
    invoke-virtual {v0, v3}, Landroid/content/Context;->obtainStyledAttributes([I)Landroid/content/res/TypedArray;

    move-result-object v4

    if-eqz p0, :cond_1

    .line 123
    new-instance v5, Landroid/view/ContextThemeWrapper;

    invoke-direct {v5, v0, p0}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;I)V

    invoke-virtual {v5, v3}, Landroid/view/ContextThemeWrapper;->obtainStyledAttributes([I)Landroid/content/res/TypedArray;

    move-result-object p0

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    .line 125
    :goto_1
    invoke-static {v1, v4, p0, v2}, Lcom/google/android/material/color/HarmonizedColors;->addHarmonizedColorAttributesToReplacementMap(Ljava/util/Map;Landroid/content/res/TypedArray;Landroid/content/res/TypedArray;I)V

    .line 131
    invoke-virtual {v4}, Landroid/content/res/TypedArray;->recycle()V

    if-eqz p0, :cond_2

    .line 133
    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    :cond_2
    return-object v1
.end method

.method private static isColorResource(I)Z
    .locals 1

    const/16 v0, 0x1c

    if-gt v0, p0, :cond_0

    const/16 v0, 0x1f

    if-gt p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static isHarmonizedColorAvailable()Z
    .locals 1
    .annotation build Landroidx/annotation/ChecksSdkIntAtLeast;
        api = 0x1e
    .end annotation

    const/4 v0, 0x1

    return v0
.end method

.method public static wrapContextIfAvailable(Lcom/google/android/material/color/HarmonizedColorsOptions;)Landroid/content/Context;
    .locals 3
    .param p0    # Lcom/google/android/material/color/HarmonizedColorsOptions;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 65
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 66
    invoke-static {}, Lcom/google/android/material/color/HarmonizedColors;->isHarmonizedColorAvailable()Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 69
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/material/color/HarmonizedColorsOptions;->getThemeOverlayResourceId()I

    move-result v1

    if-nez v1, :cond_1

    .line 72
    new-instance v1, Landroid/content/ContextWrapper;

    invoke-direct {v1, v0}, Landroid/content/ContextWrapper;-><init>(Landroid/content/Context;)V

    goto :goto_0

    .line 73
    :cond_1
    new-instance v2, Landroid/view/ContextThemeWrapper;

    invoke-direct {v2, v0, v1}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;I)V

    move-object v1, v2

    .line 75
    :goto_0
    invoke-static {v1, p0}, Lcom/google/android/material/color/HarmonizedColors;->addResourcesLoaderToContext(Landroid/content/Context;Lcom/google/android/material/color/HarmonizedColorsOptions;)Z

    move-result p0

    if-eqz p0, :cond_2

    move-object v0, v1

    :cond_2
    return-object v0
.end method
