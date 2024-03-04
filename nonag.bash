#!/bin/bash
# Author: Draeician (3/2024)
# Purpose:  Stop the nag screen after login on a proxmox system
# Execution: curl -sSL  https://raw.githubusercontent.com/digitalw00t/proxmox/main/nonag.bash

FILE_PATH="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
BACKUP_PATH="${FILE_PATH}.original"

# Make a backup if it doesn't exist
[ ! -f "$BACKUP_PATH" ] && cp "$FILE_PATH" "$BACKUP_PATH"

# Comment out the specific line if it's not already commented out
grep -q 'if (res === null || res === undefined || !res || res' "$FILE_PATH" && sed -i '/if (res === null || res === undefined || !res || res/,+1 {/^[^\/]/s/^/\/\/ /}' "$FILE_PATH"

# Insert 'if (false) {' after the commented lines, if it doesn't already exist
if ! grep -q 'if (false) {' "$FILE_PATH"; then
  sed -i '/if (res === null || res === undefined || !res || res/a if (false) {' "$FILE_PATH"
fi

# Restart the pveproxy service
systemctl restart pveproxy.service
