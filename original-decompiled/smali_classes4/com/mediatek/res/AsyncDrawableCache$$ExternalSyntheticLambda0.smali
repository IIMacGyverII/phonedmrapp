.class public final synthetic Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Landroid/content/SharedPreferences;

.field public final synthetic f$1:Landroid/content/Context;


# direct methods
.method public synthetic constructor <init>(Landroid/content/SharedPreferences;Landroid/content/Context;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;->f$0:Landroid/content/SharedPreferences;

    iput-object p2, p0, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;->f$1:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;->f$0:Landroid/content/SharedPreferences;

    iget-object p0, p0, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;->f$1:Landroid/content/Context;

    invoke-static {v0, p0}, Lcom/mediatek/res/AsyncDrawableCache;->$r8$lambda$ac_r_7YgOMlJFsFlbAW5-E7gx9I(Landroid/content/SharedPreferences;Landroid/content/Context;)V

    return-void
.end method
