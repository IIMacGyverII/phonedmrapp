import sqlite3
c = sqlite3.connect(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\radio_fw1718_check.db")
print("TABLES", [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='table'")])
print("--- ISS / pass history ---")
q = ("SELECT datetime(ts/1000,'unixepoch','localtime'), channel, kind, substr(text,1,180) "
     "FROM history WHERE text LIKE '%ISS%' OR text LIKE '%resume%' OR text LIKE '%Tracking%' "
     "OR text LIKE '%pass over%' ORDER BY ts DESC LIMIT 30")
for r in c.execute(q):
    print(" | ".join(str(x) for x in r))
print("--- channels columns ---")
print([r[1] for r in c.execute("PRAGMA table_info(channels)")])
print("--- zones columns ---")
print([r[1] for r in c.execute("PRAGMA table_info(zones)")])
