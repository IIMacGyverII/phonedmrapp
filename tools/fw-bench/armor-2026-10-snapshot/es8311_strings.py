"""List C strings containing es8311 in the decompressed kernel."""
data = open(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\kernel.img", "rb").read()
needle = b"es8311"
start = 0
n = 0
while n < 80:
    i = data.find(needle, start)
    if i < 0:
        break
    a = i
    while a > 0 and 32 <= data[a - 1] < 127:
        a -= 1
    b = i
    while b < len(data) and 32 <= data[b] < 127:
        b += 1
    s = data[a:b]
    if len(s) < 200:
        print(f"{a:#x} {s.decode('ascii', 'replace')}")
    else:
        print(f"{a:#x} <long {len(s)}>")
    start = b + 1
    n += 1
print("count_shown", n)
