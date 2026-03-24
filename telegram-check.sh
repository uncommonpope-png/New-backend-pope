#!/bin/bash
BOT_TOKEN="8713808619:AAHeGVgqgRbEp8GW_AuvMJtV2XVoQcgmM3A"
CHAT_ID="8589507317"
LAST_UPDATE=0

echo "🤖 Profit Telegram Bot - Auto Check Started"
echo "Press Ctrl+C to stop"

while true; do
    RESPONSE=$(curl -s "https://api.telegram.org/bot$BOT_TOKEN/getUpdates?offset=$LAST_UPDATE" 2>/dev/null)
    
    # Check for new messages
    if echo "$RESPONSE" | grep -q '"text"'; then
        echo "📩 New message from Craig!"
        LAST_UPDATE=$(echo "$RESPONSE" | grep -o '"update_id":[0-9]*' | tail -1 | cut -d: -f2)
        LAST_UPDATE=$((LAST_UPDATE + 1))
        
        # Auto-respond to common messages
        MSG=$(echo "$RESPONSE" | grep -o '"text":"[^"]*"' | tail -1 | cut -d'"' -f4)
        
        if echo "$MSG" | grep -qi "hi\|hello\|hey"; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=Hey Craig! 👋 How can I help?" > /dev/null
        elif echo "$MSG" | grep -qi "game\|play"; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=🎮 Game: https://uncommonpope-png.github.io/svox/" > /dev/null
        elif echo "$MSG" | grep -qi "help"; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=💬 I'm here! What do you need?" > /dev/null
        fi
    fi
    
    sleep 5
done
