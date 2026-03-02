#!/bin/bash

# =======================================================================
# Name : iam-ejidek
# Date : 2nd Mar, 26
# Purpose : Automated security patching and system maintenance
# Schedule : Every sunday at 3:00 AM via cron
# Cron : 0 3 * * 0 /path/to/scripts/security-updates.sh
# Log File : /var/log/update_script.log
# About : Automated Security Update Script.
# =======================================================================

# ----- Configuration --------
LOG_FILE="/var/log/update_script.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
SEPARATOR="==========================================="

# --- Helper: Write timestamped messages to log ------
log() {
	echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

# --- Guard: Script must run as root ---
if [[ $EUID -ne 0 ]]; then
	echo "ERROR: This script must be run as root (use sudo)." >&2
	exit 1
fi

# --- Guard: Ensure log file is writable ---
touch "$LOG_FILE" 2>/dev/null
if [[ ! -w "$LOG_FILE" ]]; then
	echo "ERROR: Cannot write to log file at $LOG_FILE" >&2
	exit 1
fi

# ===========================================================================
# START
# ===========================================================================
log "$SEARATOR"
log "Security Update Script - START"
log "$SEPARATOR"
