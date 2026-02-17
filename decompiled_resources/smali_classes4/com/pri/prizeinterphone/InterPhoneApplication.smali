.class public Lcom/pri/prizeinterphone/InterPhoneApplication;
.super Landroid/app/Application;
.source "InterPhoneApplication.java"


# static fields
.field private static context:Landroid/content/Context;

.field private static instance:Lcom/pri/prizeinterphone/InterPhoneApplication;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    return-void
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .line 22
    sget-object v0, Lcom/pri/prizeinterphone/InterPhoneApplication;->context:Landroid/content/Context;

    return-object v0
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/InterPhoneApplication;
    .locals 1

    .line 11
    sget-object v0, Lcom/pri/prizeinterphone/InterPhoneApplication;->instance:Lcom/pri/prizeinterphone/InterPhoneApplication;

    return-object v0
.end method


# virtual methods
.method public onCreate()V
    .locals 0

    .line 16
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 17
    sput-object p0, Lcom/pri/prizeinterphone/InterPhoneApplication;->instance:Lcom/pri/prizeinterphone/InterPhoneApplication;

    .line 18
    invoke-virtual {p0}, Landroid/app/Application;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    sput-object p0, Lcom/pri/prizeinterphone/InterPhoneApplication;->context:Landroid/content/Context;

    return-void
.end method
