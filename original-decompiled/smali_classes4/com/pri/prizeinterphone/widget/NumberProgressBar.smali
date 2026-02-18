.class public Lcom/pri/prizeinterphone/widget/NumberProgressBar;
.super Landroid/view/View;
.source "NumberProgressBar.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;,
        Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;
    }
.end annotation


# static fields
.field private static final INSTANCE_MAX:Ljava/lang/String; = "max"

.field private static final INSTANCE_PREFIX:Ljava/lang/String; = "prefix"

.field private static final INSTANCE_PROGRESS:Ljava/lang/String; = "progress"

.field private static final INSTANCE_REACHED_BAR_COLOR:Ljava/lang/String; = "reached_bar_color"

.field private static final INSTANCE_REACHED_BAR_HEIGHT:Ljava/lang/String; = "reached_bar_height"

.field private static final INSTANCE_STATE:Ljava/lang/String; = "saved_instance"

.field private static final INSTANCE_SUFFIX:Ljava/lang/String; = "suffix"

.field private static final INSTANCE_TEXT_COLOR:Ljava/lang/String; = "text_color"

.field private static final INSTANCE_TEXT_SIZE:Ljava/lang/String; = "text_size"

.field private static final INSTANCE_TEXT_VISIBILITY:Ljava/lang/String; = "text_visibility"

.field private static final INSTANCE_UNREACHED_BAR_COLOR:Ljava/lang/String; = "unreached_bar_color"

.field private static final INSTANCE_UNREACHED_BAR_HEIGHT:Ljava/lang/String; = "unreached_bar_height"

.field private static final PROGRESS_TEXT_VISIBLE:I


# instance fields
.field private final default_progress_text_offset:F

.field private final default_reached_bar_height:F

.field private final default_reached_color:I

.field private final default_text_color:I

.field private final default_text_size:F

.field private final default_unreached_bar_height:F

.field private final default_unreached_color:I

.field private mCurrentDrawText:Ljava/lang/String;

.field private mCurrentProgress:I

.field private mDrawReachedBar:Z

.field private mDrawTextEnd:F

.field private mDrawTextStart:F

.field private mDrawTextWidth:F

.field private mDrawUnreachedBar:Z

.field private mIfDrawText:Z

.field private mListener:Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;

.field private mMaxProgress:I

.field private mOffset:F

.field private mPrefix:Ljava/lang/String;

.field private mReachedBarColor:I

.field private mReachedBarHeight:F

.field private mReachedBarPaint:Landroid/graphics/Paint;

.field private mReachedRectF:Landroid/graphics/RectF;

.field private mSuffix:Ljava/lang/String;

.field private mTextColor:I

.field private mTextPaint:Landroid/graphics/Paint;

.field private mTextSize:F

.field private mUnreachedBarColor:I

.field private mUnreachedBarHeight:F

.field private mUnreachedBarPaint:Landroid/graphics/Paint;

.field private mUnreachedRectF:Landroid/graphics/RectF;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 160
    invoke-direct {p0, p1, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    const/4 v0, 0x0

    .line 164
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 11

    .line 168
    invoke-direct {p0, p1, p2, p3}, Landroid/view/View;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    const/16 v0, 0x64

    .line 19
    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mMaxProgress:I

    const/4 v1, 0x0

    .line 24
    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentProgress:I

    const-string v2, "%"

    .line 59
    iput-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mSuffix:Ljava/lang/String;

    const-string v2, ""

    .line 64
    iput-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mPrefix:Ljava/lang/String;

    const/16 v2, 0x42

    const/16 v3, 0x91

    const/16 v4, 0xf1

    .line 67
    invoke-static {v2, v3, v4}, Landroid/graphics/Color;->rgb(III)I

    move-result v5

    iput v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_text_color:I

    .line 68
    invoke-static {v2, v3, v4}, Landroid/graphics/Color;->rgb(III)I

    move-result v2

    iput v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_reached_color:I

    const/16 v3, 0xcc

    .line 69
    invoke-static {v3, v3, v3}, Landroid/graphics/Color;->rgb(III)I

    move-result v3

    iput v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_unreached_color:I

    .line 130
    new-instance v4, Landroid/graphics/RectF;

    const/4 v6, 0x0

    invoke-direct {v4, v6, v6, v6, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    iput-object v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    .line 134
    new-instance v4, Landroid/graphics/RectF;

    invoke-direct {v4, v6, v6, v6, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    iput-object v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    const/4 v4, 0x1

    .line 144
    iput-boolean v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawUnreachedBar:Z

    .line 146
    iput-boolean v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawReachedBar:Z

    .line 148
    iput-boolean v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    const/high16 v6, 0x3fc00000    # 1.5f

    .line 170
    invoke-virtual {p0, v6}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->dp2px(F)F

    move-result v6

    iput v6, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_reached_bar_height:F

    const/high16 v7, 0x3f800000    # 1.0f

    .line 171
    invoke-virtual {p0, v7}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->dp2px(F)F

    move-result v7

    iput v7, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_unreached_bar_height:F

    const/high16 v8, 0x41200000    # 10.0f

    .line 172
    invoke-virtual {p0, v8}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->sp2px(F)F

    move-result v8

    iput v8, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_text_size:F

    const/high16 v9, 0x40400000    # 3.0f

    .line 173
    invoke-virtual {p0, v9}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->dp2px(F)F

    move-result v9

    iput v9, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->default_progress_text_offset:F

    .line 176
    invoke-virtual {p1}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object p1

    sget-object v10, Lcom/pri/prizeinterphone/R$styleable;->NumberProgressBar:[I

    invoke-virtual {p1, p2, v10, p3, v1}, Landroid/content/res/Resources$Theme;->obtainStyledAttributes(Landroid/util/AttributeSet;[III)Landroid/content/res/TypedArray;

    move-result-object p1

    const/4 p2, 0x3

    .line 179
    invoke-virtual {p1, p2, v2}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarColor:I

    const/16 p2, 0x9

    .line 180
    invoke-virtual {p1, p2, v3}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarColor:I

    const/4 p2, 0x4

    .line 181
    invoke-virtual {p1, p2, v5}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextColor:I

    const/4 p2, 0x6

    .line 182
    invoke-virtual {p1, p2, v8}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    const/4 p2, 0x2

    .line 184
    invoke-virtual {p1, p2, v6}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    const/16 p2, 0x8

    .line 185
    invoke-virtual {p1, p2, v7}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    const/4 p2, 0x5

    .line 186
    invoke-virtual {p1, p2, v9}, Landroid/content/res/TypedArray;->getDimension(IF)F

    move-result p2

    iput p2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mOffset:F

    const/4 p2, 0x7

    .line 188
    invoke-virtual {p1, p2, v1}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result p2

    if-eqz p2, :cond_0

    .line 190
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    .line 193
    :cond_0
    invoke-virtual {p1, v1, v1}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result p2

    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    .line 194
    invoke-virtual {p1, v4, v0}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result p2

    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setMax(I)V

    .line 196
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->recycle()V

    .line 197
    invoke-direct {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->initializePainters()V

    return-void
.end method

.method private calculateDrawRectF()V
    .locals 7

    const/4 v0, 0x1

    new-array v1, v0, [Ljava/lang/Object;

    .line 283
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v2

    mul-int/lit8 v2, v2, 0x64

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result v3

    div-int/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "%d"

    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentDrawText:Ljava/lang/String;

    .line 284
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mPrefix:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentDrawText:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mSuffix:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentDrawText:Ljava/lang/String;

    .line 285
    iget-object v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {v2, v1}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;)F

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextWidth:F

    .line 287
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v1

    const/high16 v2, 0x40000000    # 2.0f

    if-nez v1, :cond_0

    .line 288
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawReachedBar:Z

    .line 289
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v1

    int-to-float v1, v1

    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    goto :goto_0

    .line 291
    :cond_0
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawReachedBar:Z

    .line 292
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v4

    int-to-float v4, v4

    iput v4, v1, Landroid/graphics/RectF;->left:F

    .line 293
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v4

    int-to-float v4, v4

    div-float/2addr v4, v2

    iget v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    div-float/2addr v5, v2

    sub-float/2addr v4, v5

    iput v4, v1, Landroid/graphics/RectF;->top:F

    .line 294
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v5

    sub-int/2addr v4, v5

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v5

    sub-int/2addr v4, v5

    int-to-float v4, v4

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result v5

    int-to-float v5, v5

    const/high16 v6, 0x3f800000    # 1.0f

    mul-float/2addr v5, v6

    div-float/2addr v4, v5

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v4, v5

    iget v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mOffset:F

    sub-float/2addr v4, v5

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v5

    int-to-float v5, v5

    add-float/2addr v4, v5

    iput v4, v1, Landroid/graphics/RectF;->right:F

    .line 295
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v4

    int-to-float v4, v4

    div-float/2addr v4, v2

    iget v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    div-float/2addr v5, v2

    add-float/2addr v4, v5

    iput v4, v1, Landroid/graphics/RectF;->bottom:F

    .line 296
    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->right:F

    iget v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mOffset:F

    add-float/2addr v1, v4

    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    .line 299
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget-object v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {v4}, Landroid/graphics/Paint;->descent()F

    move-result v4

    iget-object v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {v5}, Landroid/graphics/Paint;->ascent()F

    move-result v5

    add-float/2addr v4, v5

    div-float/2addr v4, v2

    sub-float/2addr v1, v4

    float-to-int v1, v1

    int-to-float v1, v1

    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextEnd:F

    .line 301
    iget v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    iget v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextWidth:F

    add-float/2addr v1, v4

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v5

    sub-int/2addr v4, v5

    int-to-float v4, v4

    cmpl-float v1, v1, v4

    if-ltz v1, :cond_1

    .line 302
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v4

    sub-int/2addr v1, v4

    int-to-float v1, v1

    iget v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextWidth:F

    sub-float/2addr v1, v4

    iput v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    .line 303
    iget-object v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    iget v5, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mOffset:F

    sub-float/2addr v1, v5

    iput v1, v4, Landroid/graphics/RectF;->right:F

    .line 306
    :cond_1
    iget v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    iget v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextWidth:F

    add-float/2addr v1, v4

    iget v4, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mOffset:F

    add-float/2addr v1, v4

    .line 307
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v5

    sub-int/2addr v4, v5

    int-to-float v4, v4

    cmpl-float v4, v1, v4

    if-ltz v4, :cond_2

    .line 308
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawUnreachedBar:Z

    goto :goto_1

    .line 310
    :cond_2
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawUnreachedBar:Z

    .line 311
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    iput v1, v0, Landroid/graphics/RectF;->left:F

    .line 312
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v3

    sub-int/2addr v1, v3

    int-to-float v1, v1

    iput v1, v0, Landroid/graphics/RectF;->right:F

    .line 313
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    neg-float v3, v3

    div-float/2addr v3, v2

    add-float/2addr v1, v3

    iput v1, v0, Landroid/graphics/RectF;->top:F

    .line 314
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    div-float/2addr p0, v2

    add-float/2addr v1, p0

    iput v1, v0, Landroid/graphics/RectF;->bottom:F

    :goto_1
    return-void
.end method

.method private calculateDrawRectFWithoutProgressText()V
    .locals 5

    .line 270
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v1

    int-to-float v1, v1

    iput v1, v0, Landroid/graphics/RectF;->left:F

    .line 271
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v1, v2

    iget v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    div-float/2addr v3, v2

    sub-float/2addr v1, v3

    iput v1, v0, Landroid/graphics/RectF;->top:F

    .line 272
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v3

    sub-int/2addr v1, v3

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v3

    sub-int/2addr v1, v3

    int-to-float v1, v1

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result v3

    int-to-float v3, v3

    const/high16 v4, 0x3f800000    # 1.0f

    mul-float/2addr v3, v4

    div-float/2addr v1, v3

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v1, v3

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v1, v3

    iput v1, v0, Landroid/graphics/RectF;->right:F

    .line 273
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    div-float/2addr v3, v2

    add-float/2addr v1, v3

    iput v1, v0, Landroid/graphics/RectF;->bottom:F

    .line 275
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->right:F

    iput v1, v0, Landroid/graphics/RectF;->left:F

    .line 276
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v3

    sub-int/2addr v1, v3

    int-to-float v1, v1

    iput v1, v0, Landroid/graphics/RectF;->right:F

    .line 277
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget v3, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    neg-float v3, v3

    div-float/2addr v3, v2

    add-float/2addr v1, v3

    iput v1, v0, Landroid/graphics/RectF;->top:F

    .line 278
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    div-float/2addr v1, v2

    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    div-float/2addr p0, v2

    add-float/2addr v1, p0

    iput v1, v0, Landroid/graphics/RectF;->bottom:F

    return-void
.end method

.method private initializePainters()V
    .locals 3

    .line 257
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarPaint:Landroid/graphics/Paint;

    .line 258
    iget v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarColor:I

    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 260
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarPaint:Landroid/graphics/Paint;

    .line 261
    iget v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarColor:I

    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 263
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    .line 264
    iget v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextColor:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 265
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    invoke-virtual {v0, p0}, Landroid/graphics/Paint;->setTextSize(F)V

    return-void
.end method

.method private measure(IZ)I
    .locals 3

    .line 217
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v0

    .line 218
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result p1

    if-eqz p2, :cond_0

    .line 219
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v2

    :goto_0
    add-int/2addr v1, v2

    const/high16 v2, 0x40000000    # 2.0f

    if-ne v0, v2, :cond_1

    goto :goto_2

    :cond_1
    if-eqz p2, :cond_2

    .line 223
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getSuggestedMinimumWidth()I

    move-result p0

    goto :goto_1

    :cond_2
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getSuggestedMinimumHeight()I

    move-result p0

    :goto_1
    add-int/2addr p0, v1

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_4

    if-eqz p2, :cond_3

    .line 227
    invoke-static {p0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    goto :goto_2

    .line 229
    :cond_3
    invoke-static {p0, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    goto :goto_2

    :cond_4
    move p1, p0

    :goto_2
    return p1
.end method


# virtual methods
.method public dp2px(F)F
    .locals 0

    .line 481
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr p1, p0

    return p1
.end method

.method public getMax()I
    .locals 0

    .line 349
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mMaxProgress:I

    return p0
.end method

.method public getPrefix()Ljava/lang/String;
    .locals 0

    .line 420
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mPrefix:Ljava/lang/String;

    return-object p0
.end method

.method public getProgress()I
    .locals 0

    .line 345
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentProgress:I

    return p0
.end method

.method public getProgressTextSize()F
    .locals 0

    .line 333
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    return p0
.end method

.method public getProgressTextVisibility()Z
    .locals 0

    .line 496
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    return p0
.end method

.method public getReachedBarColor()I
    .locals 0

    .line 341
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarColor:I

    return p0
.end method

.method public getReachedBarHeight()F
    .locals 0

    .line 353
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    return p0
.end method

.method public getSuffix()Ljava/lang/String;
    .locals 0

    .line 408
    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mSuffix:Ljava/lang/String;

    return-object p0
.end method

.method protected getSuggestedMinimumHeight()I
    .locals 2

    .line 207
    iget v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    float-to-int v0, v0

    iget v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    float-to-int v1, v1

    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    float-to-int p0, p0

    invoke-static {v1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-static {v0, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    return p0
.end method

.method protected getSuggestedMinimumWidth()I
    .locals 0

    .line 202
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    float-to-int p0, p0

    return p0
.end method

.method public getTextColor()I
    .locals 0

    .line 324
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextColor:I

    return p0
.end method

.method public getUnreachedBarColor()I
    .locals 0

    .line 337
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarColor:I

    return p0
.end method

.method public getUnreachedBarHeight()F
    .locals 0

    .line 357
    iget p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    return p0
.end method

.method public incrementProgressBy(I)V
    .locals 1

    if-lez p1, :cond_0

    .line 425
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v0

    add-int/2addr v0, p1

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    .line 428
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mListener:Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;

    if-eqz p1, :cond_1

    .line 429
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result p0

    invoke-interface {p1, v0, p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;->onProgressChange(II)V

    :cond_1
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 3

    .line 238
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    if-eqz v0, :cond_0

    .line 239
    invoke-direct {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->calculateDrawRectF()V

    goto :goto_0

    .line 241
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->calculateDrawRectFWithoutProgressText()V

    .line 244
    :goto_0
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawReachedBar:Z

    if-eqz v0, :cond_1

    .line 245
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedRectF:Landroid/graphics/RectF;

    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 248
    :cond_1
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawUnreachedBar:Z

    if-eqz v0, :cond_2

    .line 249
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedRectF:Landroid/graphics/RectF;

    iget-object v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 252
    :cond_2
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    if-eqz v0, :cond_3

    .line 253
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentDrawText:Ljava/lang/String;

    iget v1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextStart:F

    iget v2, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mDrawTextEnd:F

    iget-object p0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1, v2, p0}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    :cond_3
    return-void
.end method

.method protected onMeasure(II)V
    .locals 1

    const/4 v0, 0x1

    .line 212
    invoke-direct {p0, p1, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->measure(IZ)I

    move-result p1

    const/4 v0, 0x0

    invoke-direct {p0, p2, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->measure(IZ)I

    move-result p2

    invoke-virtual {p0, p1, p2}, Landroid/view/View;->setMeasuredDimension(II)V

    return-void
.end method

.method protected onRestoreInstanceState(Landroid/os/Parcelable;)V
    .locals 1

    .line 460
    instance-of v0, p1, Landroid/os/Bundle;

    if-eqz v0, :cond_1

    .line 461
    check-cast p1, Landroid/os/Bundle;

    const-string/jumbo v0, "text_color"

    .line 462
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextColor:I

    const-string/jumbo v0, "text_size"

    .line 463
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getFloat(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    const-string v0, "reached_bar_height"

    .line 464
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getFloat(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    const-string/jumbo v0, "unreached_bar_height"

    .line 465
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getFloat(Ljava/lang/String;)F

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    const-string v0, "reached_bar_color"

    .line 466
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarColor:I

    const-string/jumbo v0, "unreached_bar_color"

    .line 467
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarColor:I

    .line 468
    invoke-direct {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->initializePainters()V

    const-string v0, "max"

    .line 469
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setMax(I)V

    const-string v0, "progress"

    .line 470
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgress(I)V

    const-string v0, "prefix"

    .line 471
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setPrefix(Ljava/lang/String;)V

    const-string/jumbo v0, "suffix"

    .line 472
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setSuffix(Ljava/lang/String;)V

    const-string/jumbo v0, "text_visibility"

    .line 473
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->Visible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    goto :goto_0

    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->Invisible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    :goto_0
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->setProgressTextVisibility(Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;)V

    const-string v0, "saved_instance"

    .line 474
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object p1

    invoke-super {p0, p1}, Landroid/view/View;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    return-void

    .line 477
    :cond_1
    invoke-super {p0, p1}, Landroid/view/View;->onRestoreInstanceState(Landroid/os/Parcelable;)V

    return-void
.end method

.method protected onSaveInstanceState()Landroid/os/Parcelable;
    .locals 3

    .line 442
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 443
    invoke-super {p0}, Landroid/view/View;->onSaveInstanceState()Landroid/os/Parcelable;

    move-result-object v1

    const-string v2, "saved_instance"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 444
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getTextColor()I

    move-result v1

    const-string/jumbo v2, "text_color"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 445
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgressTextSize()F

    move-result v1

    const-string/jumbo v2, "text_size"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    .line 446
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getReachedBarHeight()F

    move-result v1

    const-string v2, "reached_bar_height"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    .line 447
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getUnreachedBarHeight()F

    move-result v1

    const-string/jumbo v2, "unreached_bar_height"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    .line 448
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getReachedBarColor()I

    move-result v1

    const-string v2, "reached_bar_color"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 449
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getUnreachedBarColor()I

    move-result v1

    const-string/jumbo v2, "unreached_bar_color"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 450
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result v1

    const-string v2, "max"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 451
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgress()I

    move-result v1

    const-string v2, "progress"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 452
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getSuffix()Ljava/lang/String;

    move-result-object v1

    const-string/jumbo v2, "suffix"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 453
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getPrefix()Ljava/lang/String;

    move-result-object v1

    const-string v2, "prefix"

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 454
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getProgressTextVisibility()Z

    move-result p0

    const-string/jumbo v1, "text_visibility"

    invoke-virtual {v0, v1, p0}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    return-object v0
.end method

.method public setMax(I)V
    .locals 0

    if-lez p1, :cond_0

    .line 394
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mMaxProgress:I

    .line 395
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    :cond_0
    return-void
.end method

.method public setOnProgressBarListener(Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;)V
    .locals 0

    .line 500
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mListener:Lcom/pri/prizeinterphone/widget/NumberProgressBar$OnProgressBarListener;

    return-void
.end method

.method public setPrefix(Ljava/lang/String;)V
    .locals 0

    if-nez p1, :cond_0

    const-string p1, ""

    .line 413
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mPrefix:Ljava/lang/String;

    goto :goto_0

    .line 415
    :cond_0
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mPrefix:Ljava/lang/String;

    :goto_0
    return-void
.end method

.method public setProgress(I)V
    .locals 1

    .line 434
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->getMax()I

    move-result v0

    if-gt p1, v0, :cond_0

    if-ltz p1, :cond_0

    .line 435
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mCurrentProgress:I

    .line 436
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    :cond_0
    return-void
.end method

.method public setProgressTextColor(I)V
    .locals 1

    .line 367
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextColor:I

    .line 368
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setColor(I)V

    .line 369
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setProgressTextSize(F)V
    .locals 1

    .line 361
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextSize:F

    .line 362
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mTextPaint:Landroid/graphics/Paint;

    invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 363
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setProgressTextVisibility(Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;)V
    .locals 1

    .line 491
    sget-object v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->Visible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    if-ne p1, v0, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mIfDrawText:Z

    .line 492
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setReachedBarColor(I)V
    .locals 1

    .line 379
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarColor:I

    .line 380
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarPaint:Landroid/graphics/Paint;

    invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setColor(I)V

    .line 381
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setReachedBarHeight(F)V
    .locals 0

    .line 385
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mReachedBarHeight:F

    return-void
.end method

.method public setSuffix(Ljava/lang/String;)V
    .locals 0

    if-nez p1, :cond_0

    const-string p1, ""

    .line 401
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mSuffix:Ljava/lang/String;

    goto :goto_0

    .line 403
    :cond_0
    iput-object p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mSuffix:Ljava/lang/String;

    :goto_0
    return-void
.end method

.method public setUnreachedBarColor(I)V
    .locals 1

    .line 373
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarColor:I

    .line 374
    iget-object v0, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarPaint:Landroid/graphics/Paint;

    invoke-virtual {v0, p1}, Landroid/graphics/Paint;->setColor(I)V

    .line 375
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    return-void
.end method

.method public setUnreachedBarHeight(F)V
    .locals 0

    .line 389
    iput p1, p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar;->mUnreachedBarHeight:F

    return-void
.end method

.method public sp2px(F)F
    .locals 0

    .line 486
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->scaledDensity:F

    mul-float/2addr p1, p0

    return p1
.end method
