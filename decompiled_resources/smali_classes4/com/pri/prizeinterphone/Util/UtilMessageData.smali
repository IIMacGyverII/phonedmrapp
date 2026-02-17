.class public Lcom/pri/prizeinterphone/Util/UtilMessageData;
.super Ljava/lang/Object;
.source "UtilMessageData.java"


# static fields
.field public static final RECIEVE:I = 0x1

.field public static final SEND:I = 0x0

.field public static final TABLE_LIST_ID:Ljava/lang/String; = "message_list_id"

.field public static final TABLE_LIST_VALUE:Ljava/lang/String; = "message_list_value"

.field public static final TABLE_RECIEVE:Ljava/lang/String; = "message_recieve"

.field public static final TABLE_TIME:Ljava/lang/String; = "message_time"

.field public static final TABLE_VALUE:Ljava/lang/String; = "message_value"


# instance fields
.field private mDB:Landroid/database/sqlite/SQLiteDatabase;

.field private mDBName:Ljava/lang/String;

.field private mHelper:Landroid/database/sqlite/SQLiteOpenHelper;


# direct methods
.method public constructor <init>(Ljava/lang/String;ILandroid/content/Context;)V
    .locals 1

    .line 43
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 44
    new-instance p3, Lcom/pri/prizeinterphone/data/DBMessageHelper;

    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p3, p1, p2, v0}, Lcom/pri/prizeinterphone/data/DBMessageHelper;-><init>(Ljava/lang/String;ILandroid/content/Context;)V

    iput-object p3, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    .line 45
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "message_db_"

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, "_"

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDBName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public close()V
    .locals 0

    .line 92
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    if-eqz p0, :cond_0

    .line 93
    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->close()V

    :cond_0
    return-void
.end method

.method public deleteAllData()V
    .locals 2

    .line 64
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 65
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {v0, p0, v1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public deleteData(Lcom/pri/prizeinterphone/data/MessageData;)V
    .locals 3

    .line 59
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 60
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/data/MessageData;->getTime()Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "message_time = ?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public deleteListData(Lcom/pri/prizeinterphone/data/MessageListData;)V
    .locals 2

    .line 111
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p0, 0x1

    new-array p0, p0, [Ljava/lang/String;

    .line 112
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/data/MessageListData;->getId()Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x0

    aput-object p1, p0, v1

    const-string p1, "message_list_database"

    const-string v1, "message_list_id = ?"

    invoke-virtual {v0, p1, v1, p0}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public insertData(Lcom/pri/prizeinterphone/data/MessageData;)V
    .locals 3

    .line 50
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 51
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 52
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    const-string v2, "message_time"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 53
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    const-string v2, "message_value"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 54
    iget p1, p1, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v1, "message_recieve"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 55
    iget-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {p1, p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    return-void
.end method

.method public insertList(Lcom/pri/prizeinterphone/data/MessageListData;)V
    .locals 3

    .line 103
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 104
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 105
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/MessageListData;->id:Ljava/lang/String;

    const-string v2, "message_list_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 106
    iget-object p1, p1, Lcom/pri/prizeinterphone/data/MessageListData;->value:Ljava/lang/String;

    const-string v1, "message_list_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 107
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const-string p1, "message_list_database"

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    return-void
.end method

.method public onUpgrade(II)V
    .locals 1

    .line 98
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 99
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {p0, v0, p1, p2}, Landroid/database/sqlite/SQLiteOpenHelper;->onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V

    return-void
.end method

.method public queryData()Ljava/util/ArrayList;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 69
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 70
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 71
    iget-object v1, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDBName:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 79
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "message_time"

    .line 80
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "message_value"

    .line 81
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    const-string v3, "message_recieve"

    .line 82
    invoke-interface {p0, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    invoke-interface {p0, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    .line 84
    new-instance v4, Lcom/pri/prizeinterphone/data/MessageData;

    invoke-direct {v4, v1, v2, v3}, Lcom/pri/prizeinterphone/data/MessageData;-><init>(Ljava/lang/String;Ljava/lang/String;I)V

    .line 85
    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public queryListData(Ljava/lang/String;)Lcom/pri/prizeinterphone/data/MessageListData;
    .locals 9

    .line 145
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p0, 0x1

    new-array v5, p0, [Ljava/lang/String;

    const/4 p0, 0x0

    aput-object p1, v5, p0

    const-string v2, "message_list_database"

    const/4 v3, 0x0

    const-string v4, "message_list_id=?"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    .line 147
    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 154
    invoke-interface {p0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "peisaisai"

    const-string v0, "cursor has data!"

    .line 155
    invoke-static {p1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const-string p1, "message_list_id"

    .line 156
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result p1

    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    const-string v0, "message_list_value"

    .line 157
    invoke-interface {p0, v0}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0

    invoke-interface {p0, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 158
    new-instance v0, Lcom/pri/prizeinterphone/data/MessageListData;

    invoke-direct {v0, p1, p0}, Lcom/pri/prizeinterphone/data/MessageListData;-><init>(Ljava/lang/String;Ljava/lang/String;)V

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
            "Lcom/pri/prizeinterphone/data/MessageListData;",
            ">;"
        }
    .end annotation

    .line 116
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 117
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 118
    iget-object v1, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const-string v2, "message_list_database"

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 126
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "message_list_id"

    .line 127
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "message_list_value"

    .line 128
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 129
    new-instance v3, Lcom/pri/prizeinterphone/data/MessageListData;

    invoke-direct {v3, v1, v2}, Lcom/pri/prizeinterphone/data/MessageListData;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 130
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public updateListData(Lcom/pri/prizeinterphone/data/MessageListData;Lcom/pri/prizeinterphone/data/MessageListData;)V
    .locals 3

    .line 137
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 138
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 139
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/MessageListData;->id:Ljava/lang/String;

    const-string v2, "message_list_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 140
    iget-object p1, p1, Lcom/pri/prizeinterphone/data/MessageListData;->value:Ljava/lang/String;

    const-string v1, "message_list_value"

    invoke-virtual {v0, v1, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 141
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilMessageData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    const/4 p1, 0x1

    new-array p1, p1, [Ljava/lang/String;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/data/MessageListData;->getId()Ljava/lang/String;

    move-result-object p2

    const/4 v1, 0x0

    aput-object p2, p1, v1

    const-string p2, "message_list_database"

    const-string v1, "message_list_id = ?"

    invoke-virtual {p0, p2, v0, v1, p1}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method
