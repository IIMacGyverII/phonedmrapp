import sqlite3
con = sqlite3.connect(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\radio_sd_before.db")
con.row_factory = sqlite3.Row
rows = con.execute(
    "SELECT _id, number, type, rxFreq, txFreq, power, active FROM channels WHERE rxFreq=467625000 OR name='R1 BENCH'"
).fetchall()
for r in rows:
    print(dict(r))
n = con.execute("SELECT COUNT(*) FROM channels WHERE name='R1 BENCH'").fetchone()[0]
print("bench", n)
con.close()
