import sqlite3
from pathlib import Path
here = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
for name in ["radio_sd_before.db", "radio_before.db", "radio_restore.db", "radio_r1_before.db"]:
    con = sqlite3.connect(str(here / name))
    con.row_factory = sqlite3.Row
    try:
        con.execute("PRAGMA wal_checkpoint(FULL)")
    except sqlite3.DatabaseError as e:
        print(name, "ckpt", e)
    rows = con.execute(
        "SELECT _id, number, name, type, rxFreq, txFreq, power, sq, active, rxOnly "
        "FROM channels WHERE _id=36 OR name='R1 BENCH' OR active=1"
    ).fetchall()
    n467 = con.execute("SELECT COUNT(*) FROM channels WHERE rxFreq=467625000").fetchone()[0]
    print("==", name, "n467", n467)
    for r in rows:
        print(dict(r))
    con.close()
