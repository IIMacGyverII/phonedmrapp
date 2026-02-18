.class public Lcom/pri/prizeinterphone/Util/UtilContactsData;
.super Ljava/lang/Object;
.source "UtilContactsData.java"


# static fields
.field public static final ID_MAX:I = 0xfffcdf

.field public static final ID_MIN:I = 0x2

.field public static final INSERT:I = 0x457

.field public static final TABLE_ICON:Ljava/lang/String; = "person_icon"

.field public static final TABLE_ID:Ljava/lang/String; = "person_id"

.field public static final TABLE_NAME:Ljava/lang/String; = "person_name"

.field public static final UPDATE:I = 0x458


# instance fields
.field private mDB:Landroid/database/sqlite/SQLiteDatabase;

.field private mDBName:Ljava/lang/String;

.field private mHelper:Landroid/database/sqlite/SQLiteOpenHelper;


# direct methods
.method public constructor <init>(Ljava/lang/String;Landroid/content/Context;)V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string p2, "people_database.db"

    .line 39
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_0

    .line 40
    new-instance p1, Lcom/pri/prizeinterphone/data/DBPeopleHelper;

    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-direct {p1, p2}, Lcom/pri/prizeinterphone/data/DBPeopleHelper;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    const-string p1, "people_database"

    .line 41
    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    goto :goto_0

    :cond_0
    const-string p2, "group_database.db"

    .line 42
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 43
    new-instance p1, Lcom/pri/prizeinterphone/data/DBGroupHelper;

    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-direct {p1, p2}, Lcom/pri/prizeinterphone/data/DBGroupHelper;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    const-string p1, "group_databas"

    .line 44
    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public close()V
    .locals 0

    .line 187
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    if-eqz p0, :cond_0

    .line 188
    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->close()V

    :cond_0
    return-void
.end method

.method public deleteData(Lcom/pri/prizeinterphone/data/ContactData;)V
    .locals 3

    .line 70
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 71
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/data/ContactData;->getId()Ljava/lang/String;

    move-result-object p1

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "person_id = ?"

    invoke-virtual {v0, p0, p1, v1}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method

.method public insertData(Lcom/pri/prizeinterphone/data/ContactData;)V
    .locals 5

    .line 49
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 50
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 51
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->id:Ljava/lang/String;

    const-string v2, "person_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 52
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->name:Ljava/lang/String;

    const-string v2, "person_name"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 53
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    const-string v2, "person_icon"

    if-eqz v1, :cond_0

    .line 54
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 55
    iget-object p1, p1, Lcom/pri/prizeinterphone/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v4, 0x64

    invoke-virtual {p1, v3, v4, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 56
    new-instance p1, Ljava/lang/String;

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    const/4 v3, 0x0

    invoke-static {v1, v3}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p1, v1}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    .line 57
    invoke-virtual {v0, v2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, ""

    .line 59
    invoke-virtual {v0, v2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 61
    :goto_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {p1, p0, v1, v0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    return-void
.end method

.method public queryData(Ljava/lang/String;)Lcom/pri/prizeinterphone/data/ContactData;
    .locals 9

    .line 76
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 78
    iget-object v2, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const/4 p0, 0x1

    new-array v5, p0, [Ljava/lang/String;

    const/4 v0, 0x0

    aput-object p1, v5, v0

    const/4 v3, 0x0

    const-string v4, "person_id=?"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p1

    .line 85
    invoke-interface {p1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    const-string v1, "peisaisai"

    const-string v3, "cursor has data!"

    .line 86
    invoke-static {v1, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "person_id"

    .line 87
    invoke-interface {p1, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p1, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v3, "person_name"

    .line 88
    invoke-interface {p1, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    invoke-interface {p1, v3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    const-string v4, "person_icon"

    .line 89
    invoke-interface {p1, v4}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v4

    invoke-interface {p1, v4}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 91
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_0

    .line 92
    invoke-virtual {p1}, Ljava/lang/String;->getBytes()[B

    move-result-object p1

    invoke-static {p1, p0}, Landroid/util/Base64;->decode([BI)[B

    move-result-object p0

    .line 93
    array-length p1, p0

    invoke-static {p0, v0, p1}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 96
    :cond_0
    new-instance p0, Lcom/pri/prizeinterphone/data/ContactData;

    invoke-direct {p0, v1, v3, v2}, Lcom/pri/prizeinterphone/data/ContactData;-><init>(Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    move-object v2, p0

    :cond_1
    return-object v2
.end method

.method public queryData()Ljava/util/ArrayList;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/data/ContactData;",
            ">;"
        }
    .end annotation

    .line 103
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 104
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 105
    iget-object v1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v2, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 113
    :goto_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "person_id"

    .line 114
    invoke-interface {p0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {p0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const-string v2, "person_name"

    .line 115
    invoke-interface {p0, v2}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {p0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    const-string v3, "person_icon"

    .line 116
    invoke-interface {p0, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    invoke-interface {p0, v3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    .line 118
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_0

    .line 119
    invoke-virtual {v3}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    const/4 v4, 0x1

    invoke-static {v3, v4}, Landroid/util/Base64;->decode([BI)[B

    move-result-object v3

    const/4 v4, 0x0

    .line 120
    array-length v5, v3

    invoke-static {v3, v4, v5}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v4

    .line 123
    :cond_0
    new-instance v3, Lcom/pri/prizeinterphone/data/ContactData;

    invoke-direct {v3, v1, v2, v4}, Lcom/pri/prizeinterphone/data/ContactData;-><init>(Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    .line 124
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method public queryData(Lcom/pri/prizeinterphone/data/ContactData;Lcom/pri/prizeinterphone/data/ContactData;)Z
    .locals 21

    move-object/from16 v0, p0

    .line 131
    iget-object v1, v0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v2

    iput-object v2, v0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 132
    iget-object v3, v0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const-string v1, "person_id"

    const-string v10, "person_name"

    filled-new-array {v1, v10}, [Ljava/lang/String;

    move-result-object v4

    const/4 v11, 0x1

    new-array v6, v11, [Ljava/lang/String;

    .line 135
    invoke-virtual/range {p1 .. p1}, Lcom/pri/prizeinterphone/data/ContactData;->getId()Ljava/lang/String;

    move-result-object v5

    const/4 v12, 0x0

    aput-object v5, v6, v12

    const-string v5, "person_id=?"

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    .line 132
    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v2

    .line 139
    invoke-interface {v2}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v3

    const-string v4, "cursor has data!"

    const-string v5, "peisaisai"

    if-eqz v3, :cond_1

    .line 140
    invoke-static {v5, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 141
    invoke-interface {v2, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    invoke-interface {v2, v3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v3

    .line 142
    invoke-interface {v2, v10}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v6

    invoke-interface {v2, v6}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    if-eqz p2, :cond_0

    .line 143
    invoke-virtual/range {p2 .. p2}, Lcom/pri/prizeinterphone/data/ContactData;->getId()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-virtual/range {p2 .. p2}, Lcom/pri/prizeinterphone/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_0

    :cond_0
    return v11

    .line 149
    :cond_1
    :goto_0
    iget-object v13, v0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object v14, v0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    filled-new-array {v1, v10}, [Ljava/lang/String;

    move-result-object v15

    new-array v0, v11, [Ljava/lang/String;

    .line 152
    invoke-virtual/range {p1 .. p1}, Lcom/pri/prizeinterphone/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v2

    aput-object v2, v0, v12

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v20, 0x0

    const-string v16, "person_name=?"

    move-object/from16 v17, v0

    .line 149
    invoke-virtual/range {v13 .. v20}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    .line 156
    invoke-interface {v0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v2

    if-eqz v2, :cond_3

    .line 157
    invoke-static {v5, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 158
    invoke-interface {v0, v1}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v1

    invoke-interface {v0, v1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 159
    invoke-interface {v0, v10}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v2

    invoke-interface {v0, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v0

    if-eqz p2, :cond_2

    .line 160
    invoke-virtual/range {p2 .. p2}, Lcom/pri/prizeinterphone/data/ContactData;->getId()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-virtual/range {p2 .. p2}, Lcom/pri/prizeinterphone/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    goto :goto_1

    :cond_2
    return v11

    :cond_3
    :goto_1
    return v12
.end method

.method public updateData(Lcom/pri/prizeinterphone/data/ContactData;Lcom/pri/prizeinterphone/data/ContactData;)V
    .locals 6

    .line 170
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    .line 171
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 172
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->id:Ljava/lang/String;

    const-string v2, "person_id"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 173
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->name:Ljava/lang/String;

    const-string v2, "person_name"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 174
    iget-object v1, p1, Lcom/pri/prizeinterphone/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    const/4 v2, 0x0

    const-string v3, "person_icon"

    if-eqz v1, :cond_0

    .line 175
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 176
    iget-object p1, p1, Lcom/pri/prizeinterphone/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    sget-object v4, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v5, 0x64

    invoke-virtual {p1, v4, v5, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 177
    new-instance p1, Ljava/lang/String;

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1

    invoke-static {v1, v2}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p1, v1}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    .line 178
    invoke-virtual {v0, v3, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, ""

    .line 180
    invoke-virtual {v0, v3, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 182
    :goto_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDB:Landroid/database/sqlite/SQLiteDatabase;

    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/UtilContactsData;->mDBName:Ljava/lang/String;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/data/ContactData;->getId()Ljava/lang/String;

    move-result-object p2

    aput-object p2, v1, v2

    const-string p2, "person_id = ?"

    invoke-virtual {p1, p0, v0, p2, v1}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    return-void
.end method
