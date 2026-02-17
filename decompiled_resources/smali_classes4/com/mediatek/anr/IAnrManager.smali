.class public interface abstract Lcom/mediatek/anr/IAnrManager;
.super Ljava/lang/Object;
.source "IAnrManager.java"

# interfaces
.implements Landroid/os/IInterface;


# static fields
.field public static final INFORM_MESSAGE_DUMP_TRANSACTION:I = 0x2

.field public static final descriptor:Ljava/lang/String; = "android.app.IAnrManager"


# virtual methods
.method public abstract informMessageDump(Ljava/lang/String;I)V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method
