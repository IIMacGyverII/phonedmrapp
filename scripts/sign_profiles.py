"""Sign the SignalDeck profile list.

Usage: python scripts/sign_profiles.py [profiles/profiles.json]

Writes <file>.sig (base64 DER ECDSA P-256 / SHA-256), checked by ProfileRegistry against the public key built into the app.
The private key lives outside the repository: ~/.signaldeck/profile_signing_key.pem (back it up; never commit it).
Bump "serial" for every list you publish: phones ignore a list whose serial is lower than the one they already have.
"""
import base64, json, os, sys
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec

path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "..", "profiles", "profiles.json")
key_path = os.path.join(os.path.expanduser("~"), ".signaldeck", "profile_signing_key.pem")
data = open(path, "rb").read()
doc = json.loads(data)                                   # refuse to sign something that is not valid JSON
assert doc.get("format") == 1 and isinstance(doc.get("serial"), int), "needs format 1 and an integer serial"
key = serialization.load_pem_private_key(open(key_path, "rb").read(), None)
sig = key.sign(data, ec.ECDSA(hashes.SHA256()))
open(path + ".sig", "w").write(base64.b64encode(sig).decode())
print("signed", path, "serial", doc["serial"], "-", len(doc.get("profiles", [])), "profiles,", len(doc.get("advisories", [])), "advisories")
