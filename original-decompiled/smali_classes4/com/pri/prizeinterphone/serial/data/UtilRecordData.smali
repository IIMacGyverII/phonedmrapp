.class public Lcom/pri/prizeinterphone/serial/data/UtilRecordData;
.super Ljava/lang/Object;
.source "UtilRecordData.java"


# static fields
.field public static final RECIEVE:I = 0x1

.field public static final SEND:I = 0x0

.field public static final TABLE_CHANNELNAME:Ljava/lang/String; = "record_channelName"

.field public static final TABLE_DIRECTION:Ljava/lang/String; = "record_direction"

.field public static final TABLE_FILEPATH:Ljava/lang/String; = "record_filePath"

.field public static final TABLE_NAME:Ljava/lang/String; = "record_name"

.field public static final TABLE_TIMESTAMP:Ljava/lang/String; = "record_timestamp"

.field public static final TAG:Ljava/lang/String; = "TAG_UtilMessageData"


# instance fields
.field private mDB:Landroid/database/sqlite/SQLiteDatabase;

.field private mDBNameDefault:Ljava/lang/String;

.field private mHelper:Lcom/pri/prizeinterphone/serial/data/DBAudioRecordHelper;

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

    .line 37
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 33
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->messageTables:Ljava/util/Map;

    .line 38
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/DBAudioRecordHelper;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/serial/data/DBAudioRecordHelper;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mHelper:Lcom/pri/prizeinterphone/serial/data/DBAudioRecordHelper;

    const-string p1, "record_database"

    .line 39
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDBNameDefault:Ljava/lang/String;

    .line 40
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    return-void
.end method


# virtual methods
.method public addRecordData(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)J
    .locals 2

    .line 76
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 77
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v1, "record_name"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 78
    iget-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDBNameDefault:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {p1, p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide p0

    return-wide p0
.end method

.method public getAllRecordFiles()Ljava/util/ArrayList;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
            ">;"
        }
    .end annotation

    .line 47
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 48
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDBNameDefault:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const-string v8, "record_timestamp desc"

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 56
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "_id"

    .line 57
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v1

    const-string v2, "record_name"

    .line 58
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v6

    const-string v2, "record_channelName"

    .line 59
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    const-string v2, "record_filePath"

    .line 60
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v11

    const-string v2, "record_timestamp"

    .line 61
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const-string v3, "record_direction"

    .line 62
    invoke-interface {p0, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    invoke-interface {p0, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v10

    .line 64
    new-instance v12, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    int-to-long v4, v1

    invoke-virtual {v2}, Ljava/lang/Long;->longValue()J

    move-result-wide v8

    move-object v3, v12

    invoke-direct/range {v3 .. v11}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;-><init>(JLjava/lang/String;Ljava/lang/String;JILjava/lang/String;)V

    .line 65
    invoke-virtual {v0, v12}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public removeRecordFile(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)I
    .locals 5

    .line 72
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDBNameDefault:Ljava/lang/String;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getTimestamp()J

    move-result-wide v3

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "record_timestamp=?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public updateRecordData(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)I
    .locals 6

    .line 82
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 83
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getId()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 84
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "record_name"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 85
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getChannelName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "record_channelName"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 86
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getDirection()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "record_direction"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 87
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getTimestamp()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "record_timestamp"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 88
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getFilePath()Ljava/lang/String;

    move-result-object v1

    const-string v2, "record_filePath"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 89
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->mDBNameDefault:Ljava/lang/String;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->getId()J

    move-result-wide v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ""

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v3, 0x0

    aput-object p1, v2, v3

    const-string p1, "_id = ?"

    invoke-virtual {v1, p0, v0, p1, v2}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0

    return p0
.end method
