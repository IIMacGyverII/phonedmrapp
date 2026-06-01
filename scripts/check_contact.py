import sqlite3

# Check contact database
conn = sqlite3.connect('contact_db.db')
cursor = conn.cursor()

# List tables
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = cursor.fetchall()
print("Tables in contact database:")
for t in tables:
    print(f"  - {t[0]}")

# Try to find contact with ID 1
for table in tables:
    table_name = table[0]
    if 'contact' in table_name.lower():
        print(f"\nChecking table: {table_name}")
        try:
            cursor.execute(f"SELECT * FROM {table_name} WHERE _id = 1 LIMIT 1")
            cols = [desc[0] for desc in cursor.description]
            row = cursor.fetchone()
            if row:
                print(f"Found contact in {table_name}:")
                for i in range(len(cols)):
                    print(f"  {cols[i]}: {row[i]}")
        except Exception as e:
            print(f"  Error: {e}")

conn.close()
