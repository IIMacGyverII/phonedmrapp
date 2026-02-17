.class public final enum Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;
.super Ljava/lang/Enum;
.source "NumberProgressBar.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/widget/NumberProgressBar;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "ProgressTextVisibility"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

.field public static final enum Invisible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

.field public static final enum Visible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    .line 156
    new-instance v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    const-string v1, "Visible"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->Visible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    new-instance v1, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    const-string v3, "Invisible"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->Invisible:Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    const/4 v3, 0x2

    new-array v3, v3, [Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    aput-object v0, v3, v2

    aput-object v1, v3, v4

    .line 155
    sput-object v3, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->$VALUES:[Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 155
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;
    .locals 1

    .line 155
    const-class v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    return-object p0
.end method

.method public static values()[Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;
    .locals 1

    .line 155
    sget-object v0, Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->$VALUES:[Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    invoke-virtual {v0}, [Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/pri/prizeinterphone/widget/NumberProgressBar$ProgressTextVisibility;

    return-object v0
.end method
