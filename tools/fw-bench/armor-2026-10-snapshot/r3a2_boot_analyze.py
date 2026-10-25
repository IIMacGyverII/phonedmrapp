import json, sys
sys.path.insert(0, r"C:\Users\Joshua\AppData\Local\Temp\fw1718")
import factory_boot

iq = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\caps\r3a2_boot.iq"
info = factory_boot.analyze(1.0, iq)
db = info.pop("db_100ms")
hot = [(round(i * 0.1, 1), db[i]) for i in range(len(db)) if db[i] >= 3]
info["hot_3db"] = hot
info["n_bins"] = len(db)
out = r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r3a2_boot.json"
json.dump(info, open(out, "w", encoding="utf-8"), indent=2)
print("n_s %.2f floor %.4f peak_db %.2f at %.1f s  above_10 %.2f  above_6 %.2f  clip %.6f" % (
    info["n_s"], info["floor_power"], info["peak_db"], info["peak_t"],
    info["above_10db_s"], info["above_6db_s"], info["clip_frac"]))
print("runs", len(info["runs"]))
for run in info["runs"]:
    print("  %.2f-%.2f dur %.2f peak %.1f rms %.0f" % (
        run["t0"], run["t1"], run["dur"], run["peak_db"], run["dev_rms"]))
print("hot", hot[:30], "count", len(hot))
print("spectrum", info["spectrum"])
