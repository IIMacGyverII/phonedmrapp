import sqlite3

conn = sqlite3.connect('database_channel_area_default_uhf.db')
cursor = conn.cursor()

# List tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = [row[0] for row in cursor.fetchall()]
print(f"Tables: {tables}")

# Try to find channel 17 data
for table in tables:
    try:
        cursor.execute(f"SELECT * FROM {table} WHERE channel_number=17 LIMIT 1")
        rows = cursor.fetchall()
        if rows:
            print(f"\nFound in table '{table}':")
            cursor.execute(f"PRAGMA table_info({table})")
            columns = [col[1] for col in cursor.fetchall()]
            print(f"Columns: {columns}")
            
            cursor.execute(f"SELECT * FROM {table} WHERE channel_number=17")
            row = cursor.fetchone()
            if row:
                data = dict(zip(columns, row))
                if 'channel_contactType' in data:
                    print(f"contactType: {data['channel_contactType']}")
                if 'channel_txContact' in data:
                    print(f"txContact: {data['channel_txContact']}")
    except:
        pass

conn.close()
