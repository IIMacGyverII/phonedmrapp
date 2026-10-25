from pathlib import Path

results = Path(r"D:\Documents\code\personal\phonedmrapp\radio_firmware\results.md")
section = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rg_section.md")
text = results.read_bytes().decode("utf-8")
if "\r" in text:
    raise SystemExit("results cr")
if "# R-G firmware" in text:
    raise SystemExit("already appended")
body = section.read_bytes().decode("utf-8")
if "\r" in body:
    raise SystemExit("section cr")
if not text.endswith("\n"):
    text += "\n"
text = text + "\n" + body
if not text.endswith("\n"):
    text += "\n"
results.write_bytes(text.encode("utf-8"))
print("appended", results.stat().st_size)
