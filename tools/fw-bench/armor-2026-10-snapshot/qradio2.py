import sqlite3
c = sqlite3.connect(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\radio_fw1718_check.db")
print("--- history since 14:25 ---")
q = ("SELECT datetime(ts/1000,'unixepoch','localtime'), channel, kind, substr(text,1,200) "
     "FROM history WHERE ts >= strftime('%s','2026-10-23 14:25:00','localtime')*1000 ORDER BY ts")
# ts is epoch ms. Convert 14:25 local by letting sqlite do it if the db clock is local-stored as epoch.
# The datetime() above used unixepoch localtime, so ts is unix ms. Build the cutoff in Python.
import datetime
cut = datetime.datetime(2026, 10, 23, 14, 25).timestamp() * 1000
print("cutoff", int(cut))
for r in c.execute("SELECT datetime(ts/1000,'unixepoch','localtime'), channel, kind, substr(text,1,200) FROM history WHERE ts>=? ORDER BY ts", (int(cut),)):
    print(" | ".join(str(x) for x in r))
print("--- channel 36 and active ---")
for r in c.execute("SELECT number, name, rxFreq, txFreq, power, active FROM channels WHERE number=36 OR active=1"):
    print(r)
print("--- zone 4 ---")
for r in c.execute("SELECT _id, name, substr(numbers,1,80) FROM zones"):
    print(r)
