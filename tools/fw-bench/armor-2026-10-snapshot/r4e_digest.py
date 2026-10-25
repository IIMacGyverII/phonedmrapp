import json

s = json.load(open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4e0_silence.json", encoding="utf-8"))
sl = s["steady"]["slices_100ms"]
print("n slices", len(sl))
for x in sl:
    print(f"t={x['t']:.1f} p99={x['p99']:.1f} rms={x['rms']:.1f}")
print("LINES")
for x in s["steady"]["lines"]:
    print(x)
print("SYNC after")
for x in s["stream"]["attempts"]["after_click"]["syncs"][:8]:
    print(x)
print("SYNC steady first")
for x in s["stream"]["attempts"]["steady"]["syncs"][:4]:
    print(x)

b = json.load(open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\r4e0_boot.json", encoding="utf-8"))

def brief(o, p=""):
    if isinstance(o, dict):
        for k, v in o.items():
            if isinstance(v, dict):
                print(p + k, "dict", list(v)[:16])
                if p.count(".") < 2:
                    brief(v, p + k + ".")
            elif isinstance(v, list):
                print(p + k, "list", len(v))
            else:
                print(p + k, "=", repr(v)[:180])

brief(b)
