import json
KEY = input()
d=json.load(open("/data/data/com.termux/files/home/.openclaw/openclaw.json"))
d["wizard"]["anthropicApiKey"]=KEY
open("/data/data/com.termux/files/home/.openclaw/openclaw.json","w").write(json.dumps(d))
print("Done")
