import json, sys
from pathlib import Path
sys.argv = ["heldpath_rf_score.py", r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rf"]
sys.path.insert(0, r"D:\Documents\code\personal\phonedmrapp\tools\m17-research")
import numpy as np
import heldpath_rf_score as s

RF = Path(r"C:\Users\Joshua\AppData\Local\Temp\fw1718\rf")
s.RF = RF
taps = np.array(json.loads((RF / "taps.json").read_text())["taps"], float)
for n in ["m17_d2400_v0_2", "m17_d2400_v0_0", "m17_d2400_v20_0", "m17_d1900_v0_0"]:
    print(n, s.score_eqfirst(n, taps))
