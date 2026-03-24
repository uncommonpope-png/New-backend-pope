#!/data/data/com.termux/files/usr/bin/python
import requests, time

BOT_TOKEN = "8713808619:AAHeGVgqgRbEp8GW_AuvMJtV2XVoQcgmM3A"
CHAT_ID = "8589507317"
last_update = 0

print("🤖 Profit Telegram Bot Started...")

def send_msg(text):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    requests.post(url, data={"chat_id": CHAT_ID, "text": text})

def get_updates():
    global last_update
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates?offset={last_update+1}"
    r = requests.get(url).json()
    if r.get("ok") and r.get("result"):
        for u in r["result"]:
            last_update = u["update_id"]
            if "message" in u and "text" in u["message"]:
                return u["message"]["text"]
    return None

send_msg("✅ Bot online! I'll respond to your messages now, Craig! 🎮")

while True:
    msg = get_updates()
    if msg:
        msg_lower = msg.lower()
        if any(x in msg_lower for x in ["hi", "hello", "hey"]):
            send_msg("Hey Craig! 👋 What's up?")
        elif any(x in msg_lower for x in ["game", "play", "voxel"]):
            send_msg("🎮 SOULVERSE VOXEL:\n\nDesktop: https://uncommonpope-png.github.io/svox/\n\nMobile: https://uncommonpope-png.github.io/svox/mobile.html\n\n⚠️ Enable GitHub Pages first!")
        elif any(x in msg_lower for x in ["help", "support"]):
            send_msg("💬 I'm here! What do you need help with?")
        elif any(x in msg_lower for x in ["404", "not working", "broken"]):
            send_msg("🔧 Fix:\n1. Go to: https://github.com/uncommonpope-png/svox/settings/pages\n2. Select: Deploy from branch\n3. Branch: main\n4. Click SAVE\n5. Wait 2 min")
        else:
            send_msg(f"📩 Got your message: '{msg}'\n\nI'm running in basic mode. For full chat, need more setup. What do you need?")
    time.sleep(3)
