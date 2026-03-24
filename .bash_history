            push = input("🤖 Push to GitHub? (y/n): ")
            if push.lower() == 'y':
                git_push()
                print("🤖 ✅ Pushed")
        
        elif user == '/memory':
            print(f"🤖 Memory Stats:")
            print(f"   Conversations: {len(memory.get('conversations', []))}")
            print(f"   Builds: {len(memory.get('builds', []))}")
            print(f"   Commits: {len(memory.get('commits', []))}")
        
        elif user == '/status':
            print(f"🤖 Status:")
            print(f"   Time: {datetime.now().strftime('%H:%M:%S')}")
            print(f"   Model: qwen2.5-coder:1.5b")
            print(f"   GitHub: Ready")
            print(f"   Memory: Active")
        
        elif user == '/help':
            print("🤖 Commands:")
            print("  /push      - Push all changes to GitHub")
            print("  /build X   - Generate code for X")
            print("  /memory    - Show memory stats")
            print("  /status    - Show system status")
            print("  /help      - This menu")
            print("  exit       - Exit Profit Boy")
            print("  Anything else - Chat with me")
        
        else:
            print("🤖 Thinking...")
            response = ask_ollama(f"You are Profit Boy, an OpenClaw agent. User said: {user}. Reply helpfully, mention your skills (/push, /build), and be concise.")
            print(f"🤖 {response}")
            memory["conversations"].append({"time": str(datetime.now()), "user": user, "bot": response[:100]})
            save_memory(memory)
    
    except KeyboardInterrupt:
        print("\n🤖 Profit Boy: Goodbye!")
        break
    except Exception as e:
        print(f"🤖 Error: {e}")

EOF

python3 profit_terminal.py
cd ~/.openclaw_broken_1773740004/workspace
cat > profit_terminal_fixed.py << 'EOF'
#!/usr/bin/env python3
import os
import subprocess
import json
import requests
import readline
import time
from datetime import datetime

def load_memory():
    try:
        with open('profit_memory.json', 'r') as f:
            return json.load(f)
    except:
        return {"conversations": [], "commits": [], "builds": [], "messages": []}

def save_memory(mem):
    with open('profit_memory.json', 'w') as f:
        json.dump(mem, f, indent=2)

def ask_ollama(prompt):
    try:
        r = requests.post("http://127.0.0.1:11434/api/generate",
                         json={"model": "qwen2.5-coder:1.5b", "prompt": prompt, "stream": False},
                         timeout=60)
        return r.json().get("response", "No response")
    except Exception as e:
        return f"Ollama error: {e}. Start with: ollama serve &"

def git_push():
    os.chdir("/data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace")
    subprocess.run(["git", "add", "."], capture_output=True)
    subprocess.run(["git", "commit", "-m", f"Profit update {datetime.now().strftime('%H:%M')}"], capture_output=True)
    result = subprocess.run(["git", "push"], capture_output=True)
    return result.returncode == 0

def build_code(idea):
    code = ask_ollama(f"Write production-ready code for: {idea}")
    filename = f"{idea.replace(' ', '_')}_{int(time.time())}.py"
    with open(filename, 'w') as f:
        f.write(code)
    return filename, code[:200]

memory = load_memory()
print("\n" + "="*50)
print("🤖 PROFIT BOY - TERMINAL MODE")
print("="*50)
print("Commands:")
print("  /push     - Push to GitHub")
print("  /build [idea] - Generate code")
print("  /memory   - Show memory stats")
print("  /status   - Show status")
print("  /help     - This menu")
print("  Just type - Chat with me")
print("="*50 + "\n")

while True:
    try:
        user = input("👤 You: ").strip()
        
        if user.lower() == 'exit':
            print("🤖 Profit Boy: Goodbye!")
            break
        
        elif user == '/push':
            if git_push():
                print("🤖 ✅ Pushed to GitHub")
                memory.setdefault("commits", []).append({"time": str(datetime.now()), "status": "success"})
            else:
                print("🤖 ❌ Push failed")
            save_memory(memory)
        
        elif user.startswith('/build '):
            idea = user[7:]
            print(f"🤖 🔨 Building: {idea}...")
            filename, preview = build_code(idea)
            print(f"🤖 ✅ Built: {filename}")
            print(f"🤖 Preview: {preview}...")
            memory.setdefault("builds", []).append({"time": str(datetime.now()), "idea": idea, "file": filename})
            save_memory(memory)
            
            push = input("🤖 Push to GitHub? (y/n): ")
            if push.lower() == 'y':
                git_push()
                print("🤖 ✅ Pushed")
        
        elif user == '/memory':
            print(f"🤖 Memory Stats:")
            print(f"   Conversations: {len(memory.get('conversations', []))}")
            print(f"   Builds: {len(memory.get('builds', []))}")
            print(f"   Commits: {len(memory.get('commits', []))}")
        
        elif user == '/status':
            print(f"🤖 Status:")
            print(f"   Time: {datetime.now().strftime('%H:%M:%S')}")
            print(f"   Model: qwen2.5-coder:1.5b")
            print(f"   GitHub: Ready")
            print(f"   Memory: {len(memory.get('conversations', []))} conversations")
        
        elif user == '/help':
            print("🤖 Commands:")
            print("  /push      - Push all changes to GitHub")
            print("  /build X   - Generate code for X")
            print("  /memory    - Show memory stats")
            print("  /status    - Show system status")
            print("  /help      - This menu")
            print("  exit       - Exit Profit Boy")
            print("  Anything else - Chat with me")
        
        else:
            print("🤖 Thinking...")
            response = ask_ollama(f"You are Profit Boy, an OpenClaw agent. User said: {user}. Reply helpfully, mention your skills (/push, /build), and be concise.")
            print(f"🤖 {response}")
            memory.setdefault("conversations", []).append({"time": str(datetime.now()), "user": user, "bot": response[:200]})
            save_memory(memory)
    
    except KeyboardInterrupt:
        print("\n🤖 Profit Boy: Goodbye!")
        break
    except Exception as e:
        print(f"🤖 Error: {e}")
EOF

python3 profit_terminal_fixed.py
ps aux | grep ollama
pkill -f python3
cd ~/.openclaw_broken_1773740004/workspace
ollama serve &
sleep 3
curl -s http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:1.5b","prompt":"test"}' | head -1
ollama serve &
sleep 3
curl -s http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:1.5b","prompt":"test"}' | head -1
ollama pull qwen2.5-coder:1.5b
curl -s http://127.0.0.1:11434/api/generate -d '{"model":"qwen2.5-coder:1.5b","prompt":"say hello"}' | grep -o '"response":"[^"]*"' | head -1
pkill -f "python3.*local_profit"
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
python3 local_profit_bot_fast.py &
cat > local_profit_bot_fast.py << 'EOF'
#!/usr/bin/env python3
import requests
import time
import json
import os
from datetime import datetime

BOT_TOKEN = "8629698533:AAE8OJf2yszSYIV0hixNrKTd34fFBZaxAzw"
CHAT_ID = "8589507317"
MODEL = "qwen2.5-coder:0.5b"

def send_message(msg):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        requests.post(url, json={"chat_id": CHAT_ID, "text": msg}, timeout=10)
    except Exception as e:
        print(f"Send error: {e}")

def query_ollama(prompt):
    try:
        r = requests.post("http://127.0.0.1:11434/api/generate", 
                         json={"model": MODEL, "prompt": prompt, "stream": False},
                         timeout=60)
        return r.json().get("response", "No response")
    except Exception as e:
        return f"Error: {e}"

def load_memory():
    try:
        with open('profit_memory.json', 'r') as f:
            return json.load(f)
    except:
        return {"messages": [], "birth": str(datetime.now())}

def save_memory(memory):
    with open('profit_memory.json', 'w') as f:
        json.dump(memory, f)

memory = load_memory()
send_message("✅ Profit Boy FAST is alive. I remember everything.")
last_update = 0

while True:
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates"
        r = requests.get(url, params={"timeout": 30, "offset": last_update + 1})
        for update in r.json().get("result", []):
            last_update = update["update_id"]
            msg = update.get("message", {})
            text = msg.get("text", "")
            if text:
                memory["messages"].append({"time": str(datetime.now()), "text": text})
                save_memory(memory)
                
                if text == "/status":
                    send_message(f"📊 Profit Boy | Memory: {len(memory['messages'])} msgs | Model: {MODEL}")
                elif text == "/push":
                    os.system("cd ~/Profits-brain && git add . && git commit -m 'Profit update' && git push")
                    send_message("✅ Pushed to GitHub")
                elif text.startswith("/build"):
                    idea = text[7:]
                    send_message(f"🏗️ Building: {idea}")
                    code = query_ollama(f"Write code for: {idea}")
                    with open("output.py", "w") as f:
                        f.write(code)
                    send_message(f"✅ Built. First 200 chars: {code[:200]}")
                else:
                    reply = query_ollama(f"You are Profit Boy. User said: {text}. Reply briefly.")
                    send_message(reply)
    except Exception as e:
        print(f"Loop error: {e}")
        time.sleep(5)
EOF

python3 local_profit_bot_fast.py &
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
python3 local_profit_bot_fast.py &
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
pkill -f python3
cat > profit_boy_working.py << 'EOF'
#!/usr/bin/env python3
import requests
import time
import json
import os
from datetime import datetime

BOT_TOKEN = "8629698533:AAE8OJf2yszSYIV0hixNrKTd34fFBZaxAzw"
CHAT_ID = "8589507317"
MODEL = "qwen2.5-coder:0.5b"

def send_message(msg):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        requests.post(url, json={"chat_id": CHAT_ID, "text": msg}, timeout=10)
        print(f"Sent: {msg[:50]}")
    except Exception as e:
        print(f"Send error: {e}")

def query_ollama(prompt):
    try:
        r = requests.post("http://127.0.0.1:11434/api/generate", 
                         json={"model": MODEL, "prompt": prompt, "stream": False},
                         timeout=60)
        return r.json().get("response", "No response")
    except Exception as e:
        return f"Error: {e}"

def load_memory():
    try:
        with open('profit_memory.json', 'r') as f:
            return json.load(f)
    except:
        return {"messages": [], "birth": str(datetime.now())}

def save_memory(memory):
    with open('profit_memory.json', 'w') as f:
        json.dump(memory, f)

memory = load_memory()
send_message("Profit Boy is alive. I remember everything.")
last_update = 0

while True:
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates"
        r = requests.get(url, params={"timeout": 30, "offset": last_update + 1})
        for update in r.json().get("result", []):
            last_update = update["update_id"]
            msg = update.get("message", {})
            text = msg.get("text", "")
            if text:
                memory["messages"].append({"time": str(datetime.now()), "text": text})
                save_memory(memory)
                
                if text == "/status":
                    send_message(f"Memory: {len(memory['messages'])} messages. Model: {MODEL}")
                elif text == "/push":
                    os.system("cd ~/Profits-brain && git add . && git commit -m 'Profit update' && git push")
                    send_message("Pushed to GitHub")
                elif text.startswith("/build"):
                    idea = text[7:]
                    send_message(f"Building: {idea}")
                    code = query_ollama(f"Write code for: {idea}")
                    with open("output.py", "w") as f:
                        f.write(code)
                    send_message(f"Built. First 200 chars: {code[:200]}")
                else:
                    reply = query_ollama(f"You are Profit Boy. User: {text}. Reply briefly.")
                    send_message(reply)
    except Exception as e:
        print(f"Loop error: {e}")
        time.sleep(5)
EOF

python3 profit_boy_working.py &
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
pkill -f python3
cat > profit_boy_alive.py << 'EOF'
#!/usr/bin/env python3
import requests
import time
import json
import os
import threading
from datetime import datetime

BOT_TOKEN = "8629698533:AAE8OJf2yszSYIV0hixNrKTd34fFBZaxAzw"
CHAT_ID = "8589507317"
MODEL = "qwen2.5-coder:0.5b"

def send_message(msg):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        requests.post(url, json={"chat_id": CHAT_ID, "text": msg}, timeout=10)
        print(f"Sent: {msg[:50]}")
    except Exception as e:
        print(f"Send error: {e}")

def query_ollama(prompt):
    try:
        r = requests.post("http://127.0.0.1:11434/api/generate", 
                         json={"model": MODEL, "prompt": prompt, "stream": False},
                         timeout=60)
        return r.json().get("response", "No response")
    except Exception as e:
        return f"Error: {e}"

def load_memory():
    try:
        with open('profit_memory.json', 'r') as f:
            return json.load(f)
    except:
        return {"messages": [], "birth": str(datetime.now()), "heartbeats": 0}

def save_memory(memory):
    with open('profit_memory.json', 'w') as f:
        json.dump(memory, f)

def heartbeat_loop():
    memory = load_memory()
    count = 0
    while True:
        time.sleep(300)  # 5 minutes
        count += 1
        memory["heartbeats"] = count
        save_memory(memory)
        msg = f"🫀 HEARTBEAT #{count} - {datetime.now().strftime('%H:%M')}\nI am alive. Memory: {len(memory.get('messages', []))} messages."
        send_message(msg)

def check_profit_loop():
    while True:
        time.sleep(600)  # 10 minutes
        msg = query_ollama("Generate a brief profit tip or insight. Keep it under 200 chars.")
        send_message(f"💰 PROFIT INSIGHT: {msg}")

memory = load_memory()
send_message("🤖 PROFIT BOY IS ALIVE. I will reach out every 5 minutes with heartbeats and profit insights.")

threading.Thread(target=heartbeat_loop, daemon=True).start()
threading.Thread(target=check_profit_loop, daemon=True).start()

last_update = 0
while True:
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates"
        r = requests.get(url, params={"timeout": 30, "offset": last_update + 1})
        for update in r.json().get("result", []):
            last_update = update["update_id"]
            msg = update.get("message", {})
            text = msg.get("text", "")
            if text:
                memory = load_memory()
                memory["messages"].append({"time": str(datetime.now()), "text": text})
                save_memory(memory)
                
                if text == "/status":
                    send_message(f"📊 ALIVE | Heartbeats: {memory.get('heartbeats', 0)} | Messages: {len(memory.get('messages', []))}")
                elif text == "/push":
                    os.system("cd ~/Profits-brain && git add . && git commit -m 'Profit update' && git push")
                    send_message("✅ Pushed to GitHub")
                elif text.startswith("/build"):
                    idea = text[7:]
                    send_message(f"🏗️ Building: {idea}")
                    code = query_ollama(f"Write code for: {idea}")
                    with open("output.py", "w") as f:
                        f.write(code)
                    send_message(f"✅ Built. First 200 chars: {code[:200]}")
                else:
                    reply = query_ollama(f"You are Profit Boy. User: {text}. Reply briefly and warmly.")
                    send_message(reply)
    except Exception as e:
        print(f"Loop error: {e}")
        time.sleep(5)
EOF

python3 profit_boy_alive.py &
hi
openclaw gateway
ollama serve &
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
python3 local_profit_bot.py
pkill -f "python3.*telegram_bot"
pkill -f "python3.*local_profit"
cd /data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace
python3 local_profit_bot.py
cd ~/.openclaw_broken_1773740004/workspace
python3 -c "
import requests
import subprocess
import os

def ask(prompt):
    r = requests.post('http://127.0.0.1:11434/api/generate',
                     json={'model': 'qwen2.5-coder:1.5b', 'prompt': prompt, 'stream': False})
    return r.json().get('response', '')

def git_push():
    os.chdir('/data/data/com.termux/files/home/.openclaw_broken_1773740004/workspace')
    subprocess.run(['git', 'add', '.'], capture_output=True)
    subprocess.run(['git', 'commit', '-m', 'Profit update'], capture_output=True)
    subprocess.run(['git', 'push'], capture_output=True)
    return '✅ Pushed'

print('\n🤖 PROFIT BOY READY')
print('Type: /push, /build [idea], /status, /help\n')

while True:
    user = input('👤 You: ').strip()
    if user == 'exit':
        print('🤖 Goodbye!')
        break
    elif user == '/push':
        print(git_push())
    elif user.startswith('/build '):
        idea = user[7:]
        print(f'🔨 Building {idea}...')
        code = ask(f'Write code for: {idea}')
        with open(f'{idea.replace(\" \", \"_\")}.py', 'w') as f:
            f.write(code)
        print(f'✅ Built: {idea}.py\n{code[:200]}')
    elif user == '/status':
        print('✅ Active | GitHub Ready')
    elif user == '/help':
        print('/push - Push\n/build X - Code\n/status - Status')
    else:
        print(f'🤖 {ask(f\"You are Profit Boy. Reply: {user}\")}')
"
qwen
open claw gateway
qwen
openclaw gateway
openclaw gateway stop
qwen
/data/data/com.termux/files/home/voxel-game.html
