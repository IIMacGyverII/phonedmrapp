.class public Lcom/pri/prizeinterphone/serial/data/UtilConversationData;
.super Ljava/lang/Object;
.source "UtilConversationData.java"


# static fields
.field public static final ID_MAX:I = 0xfffcdf

.field public static final ID_MIN:I = 0x2

.field public static final INSERT:I = 0x457

.field public static final TABLE_CONVTARGET:Ljava/lang/String; = "conver_target"

.field public static final TABLE_CONVTYPE:Ljava/lang/String; = "conver_type"

.field public static final TABLE_ID:Ljava/lang/String; = "conver_id"

.field public static final TABLE_NAME:Ljava/lang/String; = "conver_name"

.field public static final TABLE_TIMESTAMP:Ljava/lang/String; = "conver_timestamp"

.field public static final TABLE_UNREADCOUNT:Ljava/lang/String; = "conver_unreadcount"

.field public static final TAG:Ljava/lang/String; = "TAG_UtilConversationData"

.field public static final UPDATE:I = 0x458


# instance fields
.field private mDB:Landroid/database/sqlite/SQLiteDatabase;

.field private mDBName:Ljava/lang/String;

.field private mHelper:Landroid/database/sqlite/SQLiteOpenHelper;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 33
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/DBConversationHelper;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/serial/data/DBConversationHelper;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    const-string p1, "conversation_database"

    .line 34
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public addConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)J
    .locals 3

    .line 38
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 39
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 40
    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "conver_type"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 41
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v1, "conver_target"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 42
    iget-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {p1, p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide p0

    return-wide p0
.end method

.method public close()V
    .locals 0

    .line 177
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    if-eqz p0, :cond_0

    .line 178
    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->close()V

    :cond_0
    return-void
.end method

.method public deleteConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 3

    .line 93
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 94
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getId()I

    move-result p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "conver_id = ?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public deleteConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 5

    .line 60
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 61
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "deleteConverstion: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_UtilConversationData"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 62
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget v3, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ""

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x0

    aput-object v2, v1, v4

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x1

    aput-object p1, v1, v2

    const-string p1, "conver_type=? AND conver_target=?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public getAllConversations()Ljava/util/ArrayList;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation

    .line 146
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 147
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 148
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const-string v8, "conver_timestamp desc"

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 156
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "conver_id"

    .line 157
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    const-string v1, "conver_type"

    .line 158
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    const-string v1, "conver_target"

    .line 159
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v5

    const-string v1, "conver_name"

    .line 160
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    const-string v1, "conver_timestamp"

    .line 161
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    const-string v1, "conver_unreadcount"

    .line 162
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    .line 164
    new-instance v1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-object v2, v1

    invoke-direct/range {v2 .. v8}, Lcom/pri/prizeinterphone/serial/data/ConversationData;-><init>(IIILjava/lang/String;Ljava/lang/Long;I)V

    .line 165
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public getConversation(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;
    .locals 10

    .line 68
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 71
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 p0, 0x2

    new-array v5, p0, [Ljava/lang/String;

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 v0, 0x0

    aput-object p0, v5, v0

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x1

    aput-object p0, v5, p1

    const/4 v3, 0x0

    const-string v4, "conver_type=? AND conver_target=?"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const-string v9, "1"

    invoke-virtual/range {v1 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    const/4 p1, 0x0

    .line 79
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p2

    if-eqz p2, :cond_0

    const-string p1, "conver_id"

    .line 80
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v1

    const-string p1, "conver_type"

    .line 81
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v2

    const-string p1, "conver_target"

    .line 82
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    const-string p1, "conver_name"

    .line 83
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string p1, "conver_timestamp"

    .line 84
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide p1

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v5

    const-string p1, "conver_unreadcount"

    .line 85
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    .line 87
    new-instance p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-object v0, p1

    invoke-direct/range {v0 .. v6}, Lcom/pri/prizeinterphone/serial/data/ConversationData;-><init>(IIILjava/lang/String;Ljava/lang/Long;I)V

    goto :goto_0

    :cond_0
    return-object p1
.end method

.method public resetData()V
    .locals 2

    .line 172
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 173
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public updateConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 6

    .line 46
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 47
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 48
    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "conver_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 49
    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "conver_type"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 50
    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "conver_target"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 51
    iget-object v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    const-string v2, "conver_name"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 52
    iget-object v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    const-string v2, "conver_timestamp"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 53
    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "conver_unreadcount"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 54
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->mDBName:Ljava/lang/String;

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget v4, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ""

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/4 v5, 0x0

    aput-object v3, v2, v5

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v3, 0x1

    aput-object p1, v2, v3

    const-string p1, "conver_type=? AND conver_target=?"

    invoke-virtual {v1, p0, v0, p1, v2}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method
