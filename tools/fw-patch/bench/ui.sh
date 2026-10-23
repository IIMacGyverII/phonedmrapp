#!/bin/bash
# Bench helper: dump SignalDeck/stock UI nodes or tap one by text/content-desc (uiautomator).
# ui.sh dump            -> prints text/desc nodes with centers
# ui.sh tap "label"     -> taps first node whose text or content-desc equals/contains label
export MSYS_NO_PATHCONV=1
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"; D="-s ${DEV:-192.168.1.125:5555}"
"$A" $D shell uiautomator dump /sdcard/ui_fw.xml >/dev/null 2>&1
"$A" $D pull /sdcard/ui_fw.xml "$TEMP/ui_fw.xml" >/dev/null 2>&1
"$A" $D shell rm /sdcard/ui_fw.xml
python - "$TEMP/ui_fw.xml" "$1" "$2" <<'PY'
import sys,re,subprocess,os
x=open(sys.argv[1],encoding='utf-8').read()
nodes=[]
for m in re.finditer(r'<node [^>]*>',x):
    n=m.group(0)
    t=re.search(r' text="([^"]*)"',n).group(1); d=re.search(r'content-desc="([^"]*)"',n).group(1)
    b=list(map(int,re.findall(r'\d+',re.search(r'bounds="([^"]*)"',n).group(1))))
    cx,cy=(b[0]+b[2])//2,(b[1]+b[3])//2
    if (t or d) and b[2]>b[0]: nodes.append((t,d,cx,cy))
if sys.argv[2]=='dump':
    for t,d,cx,cy in nodes: print(f'{cx:5},{cy:5}  {t[:60]!r}  {d[:40]!r}'.encode('ascii','replace').decode())
else:
    lab=sys.argv[3]
    hit=[n for n in nodes if n[0]==lab or n[1]==lab] or [n for n in nodes if lab.lower() in (n[0]+' '+n[1]).lower()]
    if not hit: print('NOT FOUND',lab); sys.exit(1)
    t,d,cx,cy=hit[0]; print('tap',cx,cy,repr(t or d).encode('ascii','replace').decode())
    subprocess.run([os.environ['LOCALAPPDATA']+'/Android/Sdk/platform-tools/adb.exe','-s',os.environ.get("DEV","192.168.1.125:5555"),'shell','input','tap',str(cx),str(cy)])
PY
