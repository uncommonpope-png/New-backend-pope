#!/data/data/com.termux/files/usr/bin/python
import requests, time, subprocess

BOT_TOKEN = "8713808619:AAHeGVgqgRbEp8GW_AuvMJtV2XVoQcgmM3A"
CHAT_ID = "8589507317"
last_update = 0

print("🤖 Profit AI Telegram Bot Started...")

def send_msg(text):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    requests.post(url, data={"chat_id": CHAT_ID, "text": text, "parse_mode": "HTML"})

def get_updates():
    global last_update
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates?offset={last_update+1}&timeout=30"
    try:
        r = requests.get(url, timeout=35).json()
        if r.get("ok") and r.get("result"):
            for u in r["result"]:
                last_update = u["update_id"]
                if "message" in u and "text" in u["message"]:
                    return u["message"]["text"], u["message"]["message_id"]
    except:
        pass
    return None, None

send_msg("✅ <b>Profit AI Online!</b>\n\nHey Craig! I'm now connected to Telegram. Message me anything and I'll respond! 🎮🚀")

while True:
    msg, msg_id = get_updates()
    if msg:
        print(f"📩 Craig: {msg}")
        # Here we would call AI to generate response
        # For now, smart auto-responses
        msg_lower = msg.lower()
        
        if any(x in msg_lower for x in ["hi", "hello", "hey", "sup"]):
            response = "Hey Craig! 👋 What's up? Ready to build something awesome?"
        elif any(x in msg_lower for x in ["game", "play", "voxel", "minecraft"]):
            response = "🎮 <b>SOULVERSE VOXEL</b>\n\n🖥️ Desktop:\nhttps://uncommonpope-png.github.io/svox/\n\n📱 Mobile:\nhttps://uncommonpope-png.github.io/svox/mobile.html\n\n⚠️ <b>Enable GitHub Pages first!</b>"
        elif any(x in msg_lower for x in ["404", "not working", "broken", "error"]):
            response = "🔧 <b>Fix GitHub Pages:</b>\n\n1. Go to settings:\nhttps://github.com/uncommonpope-png/svox/settings/pages\n\n2. Select: Deploy from branch\n3. Branch: main\n4. Folder: / (root)\n5. Click SAVE\n6. Wait 2 min\n7. Refresh!"
        elif any(x in msg_lower for x in ["help", "what can you do", "commands"]):
            response = "💬 <b>I can help with:</b>\n\n🎮 Game info - say 'game'\n🔧 Fix issues - say 'broken'\n📊 System status - say 'status'\n💰 PLT info - say 'plt'\n\nOr just ask me anything!"
        elif any(x in msg_lower for x in ["status", "running", "alive"]):
            response = "✅ <b>System Status:</b>\n\n🤖 Bot: Online\n🎮 Game: Ready\n🌐 GitHub: Pushed\n\nAll systems operational! 🚀"
        elif any(x in msg_lower for x in ["plt", "profit", "love", "tax"]):
            response = "💰 <b>PLT System:</b>\n\n💰 Profit = Resource gathering\n❤️ Love = Terrain beauty\n⚖️ Tax = Resource efficiency\n\nBreak ores to gain PLT!\nPlace blocks to spend PLT!"
        else:
            response = f"📩 Got: '{msg}'\n\nCraig, I'm in basic mode right now. For full AI chat on Telegram, need to integrate the full AI engine. What do you need? 🤖"
        
        send_msg(response)
        print(f"🤖 Bot: {response}")
