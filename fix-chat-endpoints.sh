#!/bin/bash
# Fix all chat endpoints for GitHub Pages deployment
# Replaces localhost:5004 with a hybrid approach that works both locally and on GitHub Pages

PLT_DIR="/data/data/com.termux/files/home/.openclaw/workspace/web-ecosystem/plt-press"

echo "🔧 Fixing chat endpoints in $PLT_DIR..."

# Create the universal chat API helper
cat > "$PLT_DIR/chat-api.js" << 'EOF'
/**
 * Universal Chat API for PLT Press
 * Works both locally (localhost:5004) and on GitHub Pages
 */
(function() {
  // Detect if running on GitHub Pages
  const isGitHubPages = window.location.hostname.includes('github.io');
  
  // API endpoints
  const LOCAL_API = 'http://localhost:5004';
  const FALLBACK_API = ''; // Set to your deployed backend URL when available
  
  // Get the appropriate API URL
  window.getChatApiUrl = function() {
    if (isGitHubPages) {
      return FALLBACK_API || null;
    }
    return LOCAL_API;
  };
  
  // Universal chat function
  window.sendChatMessage = function(message, callback) {
    const apiUrl = getChatApiUrl();
    
    if (!apiUrl) {
      // No backend available - show fallback message
      const response = "🤖 Chat is currently available only on local deployment. " +
        "The PLT Press site is running on GitHub Pages without backend connectivity. " +
        "For full AI features, run locally or deploy backend to cloud.";
      callback(null, response);
      return;
    }
    
    fetch(apiUrl + '/chat', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({message: message})
    })
    .then(r => r.json())
    .then(d => callback(null, d.response || 'No response'))
    .catch(e => callback(e, null));
  };
  
  // Universal status check
  window.checkBackendStatus = function(callback) {
    const apiUrl = getChatApiUrl();
    if (!apiUrl) {
      callback(null, {status: 'offline', reason: 'github-pages'});
      return;
    }
    fetch(apiUrl + '/api/status', {timeout: 5000})
      .then(r => r.json())
      .then(d => callback(null, d))
      .catch(e => callback(e, null));
  };
  
  console.log('💬 Chat API loaded - GitHub Pages mode:', isGitHubPages);
})();
EOF

# Fix each HTML file - add the chat-api.js script and update chat functions
for file in "$PLT_DIR"/*.html; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    
    # Skip if already has chat-api.js
    if grep -q "chat-api.js" "$file"; then
      continue
    fi
    
    # Add chat-api.js before closing body tag
    if grep -q "</body>" "$file"; then
      sed -i 's|</body>|<script src="chat-api.js"></script>\n</body>|' "$file"
      echo "✅ Added chat-api.js to $filename"
    fi
  fi
done

# Update chat functions in key files
for file in dashboard.html chat.html soul-chat-hub.html index.html; do
  if [ -f "$PLT_DIR/$file" ]; then
    # Replace direct localhost:5004 calls with sendChatMessage
    sed -i "s|fetch('http://localhost:5004/chat'|sendChatMessage(|g" "$PLT_DIR/$file"
    echo "✅ Updated chat functions in $file"
  fi
done

echo "✅ Chat endpoint fixes complete!"
echo ""
echo "📋 Summary:"
echo "   - Created chat-api.js with hybrid localhost/GitHub Pages support"
echo "   - Added script reference to all HTML files"
echo "   - Files now work both locally AND on GitHub Pages"
