import json
d=json.load(open("/data/data/com.termux/files/home/.openclaw/openclaw.json"))
d["providers"]["anthropic"]["apiKey"]="YOUR_NEW_KEY"
open("/data/data/com.termux/files/home/.openclaw/openclaw.json","w").write(json.dumps(d))
