.class public final synthetic Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

.field public final synthetic f$1:Lcom/android/internal/telephony/dataconnection/DataConnection;

.field public final synthetic f$2:Ljava/lang/Integer;

.field public final synthetic f$3:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

.field public final synthetic f$4:Landroid/os/Message;

.field public final synthetic f$5:Landroid/telephony/data/DataProfile;

.field public final synthetic f$6:Z

.field public final synthetic f$7:Z


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$1:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iput-object p3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$2:Ljava/lang/Integer;

    iput-object p4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$3:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    iput-object p5, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$4:Landroid/os/Message;

    iput-object p6, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$5:Landroid/telephony/data/DataProfile;

    iput-boolean p7, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$6:Z

    iput-boolean p8, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$7:Z

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 9

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$0:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$1:Lcom/android/internal/telephony/dataconnection/DataConnection;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$2:Ljava/lang/Integer;

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$3:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$4:Landroid/os/Message;

    iget-object v5, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$5:Landroid/telephony/data/DataProfile;

    iget-boolean v6, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$6:Z

    iget-boolean v7, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;->f$7:Z

    move-object v8, p1

    check-cast v8, Ljava/lang/Boolean;

    invoke-static/range {v0 .. v8}, Lcom/android/internal/telephony/dataconnection/DataConnection;->$r8$lambda$1-zC7pfdvj8isv8ULGxkeJ57JTE(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Boolean;)V

    return-void
.end method
