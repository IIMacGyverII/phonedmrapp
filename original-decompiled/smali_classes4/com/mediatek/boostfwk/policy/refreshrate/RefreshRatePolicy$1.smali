.class Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;
.super Ljava/lang/Object;
.source "RefreshRatePolicy.java"

# interfaces
.implements Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->registerActivityListener()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)V
    .locals 0

    .line 157
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onChange(Landroid/content/Context;)V
    .locals 6

    const-string v0, "MSYNC3-VariableRefreshRate"

    const-string v1, "Activity Changed"

    .line 160
    invoke-static {v0, v1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 161
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    const/4 v2, 0x0

    invoke-static {v1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmActiveRefreshScenario(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Lcom/mediatek/boostfwk/scenario/refreshrate/RefreshRateScenario;)V

    .line 162
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    const/4 v2, 0x0

    invoke-static {v1, v2}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmActivityHasVideoView(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Z)V

    .line 163
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmMSyncSupportedByProcess(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Z

    move-result v1

    if-eqz v1, :cond_2

    if-eqz p1, :cond_2

    instance-of v1, p1, Landroid/app/Activity;

    if-nez v1, :cond_0

    goto/16 :goto_1

    .line 166
    :cond_0
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->updateCurrentActivityName(Landroid/content/Context;)V

    .line 168
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmIsDataInited(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Z

    move-result v1

    if-eqz v1, :cond_1

    return-void

    .line 169
    :cond_1
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->initHardwareSupportRefreshRate(Landroid/content/Context;)V

    .line 170
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v1

    invoke-virtual {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->initMSync3SupportRefreshRate()Z

    .line 171
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->initPackageInfo(Landroid/content/Context;)V

    .line 173
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v3

    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getFlingSupportedRefreshRate()Ljava/util/ArrayList;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmFlingSupportedRefreshRate(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V

    .line 174
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v3

    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getFlingRefreshRateChangeGap()Ljava/util/ArrayList;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmFlingRefreshRateChangeGap(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V

    .line 175
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v3

    .line 176
    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getFlingRefreshRateChangeTimeOffset()Ljava/util/ArrayList;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmFlingRefreshRateChangeTimeOffset(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V

    .line 177
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v3

    .line 178
    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getFlingSupportedRefreshRateCount()I

    move-result v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmFlingSupportRefreshRateCount(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;I)V

    .line 179
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmRefreshRateInfo(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;

    move-result-object v3

    invoke-virtual {v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRateInfo;->getFlingRefreshRateVSyncTime()Ljava/util/ArrayList;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmFlingRefreshRateVsyncTime(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ljava/util/ArrayList;)V

    const-string v1, "com.mediatek.msync.RefreshRatePolicyExt"

    const-string v3, "/system/framework/msync-lib.jar"

    .line 185
    :try_start_0
    iget-object v4, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    new-instance v5, Ldalvik/system/PathClassLoader;

    invoke-virtual {p1}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object p1

    invoke-direct {v5, v3, p1}, Ldalvik/system/PathClassLoader;-><init>(Ljava/lang/String;Ljava/lang/ClassLoader;)V

    invoke-static {v4, v5}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmClassLoader(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Ldalvik/system/PathClassLoader;)V

    .line 186
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    invoke-static {p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fgetmClassLoader(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;)Ldalvik/system/PathClassLoader;

    move-result-object p1

    invoke-static {v1, v2, p1}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p1

    .line 187
    iget-object v1, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {p1, v3}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object p1

    new-array v2, v2, [Ljava/lang/Object;

    invoke-virtual {p1, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;

    invoke-static {v1, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmRefreshRatePolicyExt(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Lcom/mediatek/boostfwk/policy/refreshrate/IRefreshRateEx;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string p1, "msync-lib.jar not exits"

    .line 189
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLoge(Ljava/lang/String;Ljava/lang/String;)V

    .line 192
    :goto_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy$1;->this$0:Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;

    const/4 p1, 0x1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;->-$$Nest$fputmIsDataInited(Lcom/mediatek/boostfwk/policy/refreshrate/RefreshRatePolicy;Z)V

    :cond_2
    :goto_1
    return-void
.end method
