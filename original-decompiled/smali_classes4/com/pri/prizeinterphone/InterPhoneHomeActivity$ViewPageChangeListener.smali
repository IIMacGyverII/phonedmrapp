.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;
.super Ljava/lang/Object;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Landroidx/viewpager/widget/ViewPager$OnPageChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/InterPhoneHomeActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ViewPageChangeListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;


# direct methods
.method private constructor <init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V
    .locals 0

    .line 421
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    return-void
.end method


# virtual methods
.method public onPageScrollStateChanged(I)V
    .locals 0

    return-void
.end method

.method public onPageScrolled(IFI)V
    .locals 0

    return-void
.end method

.method public onPageSelected(I)V
    .locals 1

    .line 424
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$msetCurrentViewPagerItem(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;I)V

    .line 425
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {v0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$mupdateTapView(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;I)V

    .line 426
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->-$$Nest$fgetmAdapter(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->updateFragmentView(I)V

    return-void
.end method
