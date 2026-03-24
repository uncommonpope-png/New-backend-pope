#!/data/data/com.termux/files/usr/bin/python
import requests, time, json

BOT_TOKEN = "8713808619:AAHeGVgqgRbEp8GW_AuvMJtV2XVoQcgmM3A"
CHAT_ID = "8589507317"
OLLAMA_URL = "http://localhost:11434/api/generate"
last_update = 0

print("🤖 Profit AI + Telegram Integration Started...")

def send_msg(text):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    requests.post(url, data={"chat_id": CHAT_ID, "text": text, "parse_mode": "HTML", "disable_web_page_preview": False})

def get_updates():
    global last_update
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates?offset={last_update+1}&timeout=30"
    try:
        r = requests.get(url, timeout=35).json()
        if r.get("ok") and r.get("result"):
            for u in r["result"]:
                last_update = u["update_id"]
                if "message" in u and "text" in u["message"]:
                    return u["message"]["text"], u["message"]["from"]["first_name"]
    except Exception as e:
        print(f"Error: {e}")
    return None, None

def ai_respond(msg):
    # Call Ollama/Qwen for AI response
    prompt = f"You are Profit, Craig's AI assistant. Be helpful, direct, and knowledgeable about the Soulverse voxel game, PLT system, and Craig's projects. Keep responses concise for Telegram.\n\nCraig: {msg}\n\nProfit:"
    
    try:
        payload = {
            "model": "qwen2.5:0.5b",
            "prompt": prompt,
            "stream": False
        }
        r = requests.post(OLLAMA_URL, json=payload, timeout=60)
        if r.status_code == 200:
            return r.json().get("response", "Thinking...")
        else:
            return f"AI error (status {r.status_code})"
    except Exception as e:
        return f"Connection error: {str(e)[:100]}"

# Startup message
send_msg("✅ <b>Profit AI FULLY ONLINE!</b>\n\n🎉 Craig, I'm now the REAL AI on Telegram!\n\n💬 Ask me anything:\n- Game info\n- PLT system\n- Code help\n- System status\n- Or just chat!\n\n🚀 Let's go!")

print("✅ Bot ready. Waiting for messages...")

while True:
    msg, name = get_updates()
    if msg:
        print(f"📩 {name}: {msg}")
        
        # Get AI response
        response = ai_respond(msg)
        
        # Send response
        send_msg(response)
        print(f"🤖 AI: {response[:100]}...")
    
    time.sleep(0.5)
