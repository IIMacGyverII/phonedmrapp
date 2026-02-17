.class public Lcom/pri/prizeinterphone/serial/data/UtilMessageData;
.super Ljava/lang/Object;
.source "UtilMessageData.java"


# static fields
.field public static final RECIEVE:I = 0x1

.field public static final SEND:I = 0x0

.field public static final TABLE_CONTENT:Ljava/lang/String; = "message_content"

.field public static final TABLE_CONVTYPE:Ljava/lang/String; = "message_convType"

.field public static final TABLE_CONV_TARGET:Ljava/lang/String; = "message_conv_target"

.field public static final TABLE_DIRECTION:Ljava/lang/String; = "message_direction"

.field public static final TABLE_FROM:Ljava/lang/String; = "message_from"

.field public static final TABLE_ID:Ljava/lang/String; = "message_id"

.field public static final TABLE_LIST_ID:Ljava/lang/String; = "message_list_id"

.field public static final TABLE_LIST_VALUE:Ljava/lang/String; = "message_list_value"

.field public static final TABLE_STATUS:Ljava/lang/String; = "message_status"

.field public static final TABLE_TIMESTAMP:Ljava/lang/String; = "message_timestamp"

.field public static final TABLE_TO:Ljava/lang/String; = "message_to"

.field public static final TAG:Ljava/lang/String; = "TAG_UtilMessageData"


# instance fields
.field private mDB:Landroid/database/sqlite/SQLiteDatabase;

.field private mDBNameDefault:Ljava/lang/String;

.field private mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

.field public messageTables:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->messageTables:Ljava/util/Map;

    .line 39
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    const-string p1, "message_db"

    .line 40
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDBNameDefault:Ljava/lang/String;

    .line 41
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    return-void
.end method


# virtual methods
.method public addSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Ljava/lang/Long;
    .locals 4

    .line 45
    iget v0, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    invoke-virtual {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v0

    .line 46
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->prepareDBTables(Ljava/lang/String;)V

    .line 47
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    .line 48
    iget-wide v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const-string v3, "message_id"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 49
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_convType"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 50
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_conv_target"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 51
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_from"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 52
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_to"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 53
    iget-object v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    const-string v3, "message_content"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 54
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_status"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 55
    iget-wide v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const-string v3, "message_timestamp"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 56
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v2, "message_direction"

    invoke-virtual {v1, v2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 57
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p1, 0x0

    invoke-virtual {p0, v0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide p0

    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    return-object p0
.end method

.method public close()V
    .locals 0

    .line 253
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    if-eqz p0, :cond_0

    .line 254
    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->close()V

    :cond_0
    return-void
.end method

.method public deleteAllSms(II)V
    .locals 1

    .line 84
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {v0, p0, p1, p1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public deleteListData(Lcom/pri/prizeinterphone/serial/data/MessageListData;)V
    .locals 2

    .line 272
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p0, 0x1

    new-array p0, p0, [Ljava/lang/String;

    .line 273
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageListData;->getId()Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x0

    aput-object p1, p0, v1

    const-string p1, "message_list_database"

    const-string v1, "message_list_id = ?"

    invoke-virtual {v0, p1, v1, p0}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public deleteSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 4

    .line 79
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConv_target()I

    move-result v2

    invoke-virtual {p0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object p0

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "message_timestamp = ?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public getAllSms(I)Ljava/util/ArrayList;
    .locals 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 218
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 219
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDBNameDefault:Ljava/lang/String;

    const/4 p0, 0x1

    new-array v5, p0, [Ljava/lang/String;

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    aput-object p0, v5, p1

    const/4 v3, 0x0

    const-string v4, "message_conv_target=?"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 227
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "message_id"

    .line 228
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result p1

    int-to-long v2, p1

    const-string p1, "message_convType"

    .line 229
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    const-string p1, "message_conv_target"

    .line 230
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v5

    const-string p1, "message_from"

    .line 231
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    const-string p1, "message_to"

    .line 232
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    const-string p1, "message_content"

    .line 233
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v8

    const-string p1, "message_timestamp"

    .line 234
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v9

    invoke-static {v9, v10}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const-string v1, "message_status"

    .line 235
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    const-string v1, "message_direction"

    .line 236
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v12

    .line 238
    new-instance v13, Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 244
    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v10

    move-object v1, v13

    invoke-direct/range {v1 .. v12}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>(JIIIILjava/lang/String;IJI)V

    .line 246
    invoke-virtual {v0, v13}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public getAllSms(II)Ljava/util/ArrayList;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(II)",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 179
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 180
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->isTableExist(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 183
    :cond_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 p0, 0x2

    new-array v6, p0, [Ljava/lang/String;

    const/4 p0, 0x0

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v6, p0

    const/4 p0, 0x1

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, v6, p0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const-string v5, "message_to=? OR message_from=?"

    const-string v9, "message_timestamp"

    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 191
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p1, "message_id"

    .line 192
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result p1

    int-to-long v2, p1

    const-string p1, "message_convType"

    .line 193
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    const-string p1, "message_conv_target"

    .line 194
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v5

    const-string p1, "message_from"

    .line 195
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    const-string p1, "message_to"

    .line 196
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    const-string p1, "message_content"

    .line 197
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v8

    const-string p1, "message_timestamp"

    .line 198
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide p1

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const-string p2, "message_status"

    .line 199
    invoke-interface {p0, p2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p2

    invoke-interface {p0, p2}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    const-string p2, "message_direction"

    .line 200
    invoke-interface {p0, p2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p2

    invoke-interface {p0, p2}, Landroid/database/Cursor;->getInt(I)I

    move-result v12

    .line 202
    new-instance p2, Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 208
    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v10

    move-object v1, p2

    invoke-direct/range {v1 .. v12}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>(JIIIILjava/lang/String;IJI)V

    .line 210
    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method public getAllSms(Ljava/lang/String;)Ljava/util/ArrayList;
    .locals 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 91
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 92
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDBNameDefault:Ljava/lang/String;

    const/4 p0, 0x1

    new-array v5, p0, [Ljava/lang/String;

    const/4 p0, 0x0

    aput-object p1, v5, p0

    const/4 v3, 0x0

    const-string v4, "message_conv_target=?"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 100
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "message_id"

    .line 101
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result p1

    int-to-long v2, p1

    const-string p1, "message_convType"

    .line 102
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    const-string p1, "message_conv_target"

    .line 103
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v5

    const-string p1, "message_from"

    .line 104
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    const-string p1, "message_to"

    .line 105
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    const-string p1, "message_content"

    .line 106
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v8

    const-string p1, "message_timestamp"

    .line 107
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v9

    invoke-static {v9, v10}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const-string v1, "message_status"

    .line 108
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    const-string v1, "message_direction"

    .line 109
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v12

    .line 111
    new-instance v13, Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 117
    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v10

    move-object v1, v13

    invoke-direct/range {v1 .. v12}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>(JIIIILjava/lang/String;IJI)V

    .line 119
    invoke-virtual {v0, v13}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public getDbName(II)Ljava/lang/String;
    .locals 1

    .line 75
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "message_db_"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "_"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getLastSms(II)Lcom/pri/prizeinterphone/serial/data/MessageData;
    .locals 12

    .line 140
    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->isTableExist(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 143
    :cond_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const-string v9, "message_timestamp desc"

    const-string v10, "1"

    invoke-virtual/range {v2 .. v10}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 151
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p1, "message_id"

    .line 152
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result p1

    int-to-long v1, p1

    const-string p1, "message_convType"

    .line 153
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    const-string p1, "message_conv_target"

    .line 154
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    const-string p1, "message_from"

    .line 155
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v5

    const-string p1, "message_to"

    .line 156
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getInt(I)I

    move-result v6

    const-string p1, "message_content"

    .line 157
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    const-string p1, "message_timestamp"

    .line 158
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide p1

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const-string p2, "message_status"

    .line 159
    invoke-interface {p0, p2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p2

    invoke-interface {p0, p2}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    const-string p2, "message_direction"

    .line 160
    invoke-interface {p0, p2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p2

    invoke-interface {p0, p2}, Landroid/database/Cursor;->getInt(I)I

    move-result v11

    .line 162
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 168
    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v9

    move-object v0, p0

    invoke-direct/range {v0 .. v11}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>(JIIIILjava/lang/String;IJI)V

    return-object p0

    :cond_1
    return-object v1
.end method

.method public insertList(Lcom/pri/prizeinterphone/serial/data/MessageListData;)V
    .locals 3

    .line 264
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 265
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 266
    iget-object v1, p1, Lcom/pri/prizeinterphone/serial/data/MessageListData;->id:Ljava/lang/String;

    const-string v2, "message_list_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 267
    iget-object p1, p1, Lcom/pri/prizeinterphone/serial/data/MessageListData;->value:Ljava/lang/String;

    const-string v1, "message_list_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 268
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const-string p1, "message_list_database"

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    return-void
.end method

.method public isTableExist(Ljava/lang/String;)Z
    .locals 3

    .line 128
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "select name from sqlite_master where type=\'table\' and name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/database/sqlite/SQLiteDatabase;->rawQuery(Ljava/lang/String;[Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    const/4 v0, 0x0

    move v1, v0

    .line 129
    :cond_0
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 130
    invoke-interface {p0, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 131
    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    .line 135
    :cond_1
    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    return v1
.end method

.method public onUpgrade(II)V
    .locals 1

    .line 259
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 260
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-virtual {p0, v0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;->onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V

    return-void
.end method

.method public prepareDBTables(Ljava/lang/String;)V
    .locals 1

    .line 71
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0, p0, p1}, Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;->createTableIfNotExist(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;)V

    return-void
.end method

.method public queryListData(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/MessageListData;
    .locals 8

    .line 308
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p0, 0x1

    new-array v4, p0, [Ljava/lang/String;

    const/4 p0, 0x0

    aput-object p1, v4, p0

    const-string v1, "message_list_database"

    const/4 v2, 0x0

    const-string v3, "message_list_id=?"

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    invoke-virtual/range {v0 .. v7}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 315
    invoke-interface {p0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "message_list_id"

    .line 316
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    const-string v0, "message_list_value"

    .line 317
    invoke-interface {p0, v0}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0

    invoke-interface {p0, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 318
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/MessageListData;

    invoke-direct {v0, p1, p0}, Lcom/pri/prizeinterphone/serial/data/MessageListData;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return-object v0
.end method

.method public queryListData()Ljava/util/ArrayList;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageListData;",
            ">;"
        }
    .end annotation

    .line 278
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 279
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const-string v2, "message_list_database"

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 287
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "message_list_id"

    .line 288
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "message_list_value"

    .line 289
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 290
    new-instance v3, Lcom/pri/prizeinterphone/serial/data/MessageListData;

    invoke-direct {v3, v1, v2}, Lcom/pri/prizeinterphone/serial/data/MessageListData;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 291
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public resetData()V
    .locals 6

    .line 326
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBMessageHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const-string v1, "select name from sqlite_master where type=\'table\'"

    const/4 v2, 0x0

    .line 328
    invoke-virtual {v0, v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->rawQuery(Ljava/lang/String;[Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    .line 329
    :goto_0
    invoke-interface {v0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v1, 0x0

    .line 330
    invoke-interface {v0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v3, "message_db"

    .line 331
    invoke-virtual {v1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 332
    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v3, v1, v2, v2}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    .line 334
    :cond_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "delete from "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    goto :goto_0

    .line 336
    :cond_1
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    return-void
.end method

.method public updateListData(Lcom/pri/prizeinterphone/serial/data/MessageListData;Lcom/pri/prizeinterphone/serial/data/MessageListData;)V
    .locals 3

    .line 299
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 300
    iget-object v1, p1, Lcom/pri/prizeinterphone/serial/data/MessageListData;->id:Ljava/lang/String;

    const-string v2, "message_list_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 301
    iget-object p1, p1, Lcom/pri/prizeinterphone/serial/data/MessageListData;->value:Ljava/lang/String;

    const-string v1, "message_list_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 302
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p1, 0x1

    new-array p1, p1, [Ljava/lang/String;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/MessageListData;->getId()Ljava/lang/String;

    move-result-object p2

    const/4 v1, 0x0

    aput-object p2, p1, v1

    const-string p2, "message_list_database"

    const-string v1, "message_list_id = ?"

    invoke-virtual {p0, p2, v0, v1, p1}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public updateSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)I
    .locals 6

    .line 61
    iget v0, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    iget v1, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    invoke-virtual {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getDbName(II)Ljava/lang/String;

    move-result-object v0

    .line 62
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->prepareDBTables(Ljava/lang/String;)V

    .line 64
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    .line 65
    iget v2, p1, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const-string v3, "message_status"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 66
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v3, 0x0

    aput-object p1, v2, v3

    const-string p1, "message_timestamp = ?"

    invoke-virtual {p0, v0, v1, p1, v2}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0

    return p0
.end method
