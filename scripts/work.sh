#! /bin/sh

currenttime=$(date +%H:%M)
if [[ "$currenttime" > "09:00" ]] || [[ "$currenttime" < "18:00" ]]; then
  osascript ~/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Set\ notifications.scpt Whatsapp 0
else
  osascript ~/Library/Mobile\ Documents/com~apple~ScriptEditor2/Documents/Set\ notifications.scpt Whatsapp 1
fi
