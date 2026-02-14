#! /bin/bash -
# Advanced Disk Lab - Runaway Process Script.
# Simulates 3 runaway processes filling disk simultaneously.
# WARNING: fills disk FAST - this is intentional.

# Do NOT use set -e here (loops must survive write errors):
set -uo pipefail

echo "Starting runaway processes... "
echo "Press Ctrl+C to stop all processes. "

# ── Runaway 1: Log writer ──────────────────────
# Simulates app logging out of control:
log_writer() {
    while true; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Unhandled exception in thread-$RANDOM: java.lang.OutOfMemoryError: Java heap space at com.myapp.service.RequestHandler.process(RequestHandler.java:$RANDOM)" \
            >> /var/log/myapp/app.log 2>/dev/null || true
    done
}

# ── Runaway 2: Core dump writer ────────────────
# Simulates app crashing repeatedly:
core_writer() {
    local i=0
    while true; do
        dd if=/dev/zero of="/var/crash/core.$((RANDOM * RANDOM))" \
            bs=1M count=50 2>/dev/null || true
        i=$((i + 1))
    done
}

# ── Runaway 3: Temp file accumulator ───────────
# Simulates app leaking temp files:
tmp_writer() {
    while true; do
        dd if=/dev/zero of="/tmp/.session-$(date +%s%N)" \
            bs=1M count=20 2>/dev/null || true
    done
}

# ── Runaway 4: Chatty terminal ─────────────────
# Broadcasts kernel-like panic messages to all terminals:
chatty() {
    while true; do
        wall "$(date '+%b %d %H:%M:%S') kernel: [$(cut -d' ' -f1 /proc/uptime)] EXT4-fs error (device sda2): ext4_find_entry:1455: inode #2: comm myapp: reading directory lblock 0"
        sleep 0.5
        wall "$(date '+%b %d %H:%M:%S') kernel: SCSI error: return code = 0x08000002"
        sleep 0.5
        wall "$(date '+%b %d %H:%M:%S') kernel: [$(cut -d' ' -f1 /proc/uptime)] EXT4-fs warning: ext4_dx_add_entry: Directory index full!"
        sleep 0.5
        wall "$(date '+%b %d %H:%M:%S') myapp[${LOG_PID}]: FATAL: No space left on device - aborting write"
        sleep 0.5
    done
}

# ── Start all 4 in background ──────────────────
log_writer &
LOG_PID=$!

core_writer &
CORE_PID=$!

tmp_writer &
TMP_PID=$!

chatty &
CHATTY_PID=$!

#echo "Runaway PIDs:"
#echo "  Log writer:  ${LOG_PID}  → /var/log/myapp/app.log"
#echo "  Core writer: ${CORE_PID} → /var/crash/core.*"
#echo "  Tmp writer:  ${TMP_PID}  → /tmp/.session-*"
#CHATTY_PID

# ── Cleanup on Ctrl+C ──────────────────────────
trap 'echo "Stopping... "; kill ${LOG_PID} ${CORE_PID} ${TMP_PID} ${CHATTY_PID} 2>/dev/null; exit 0' SIGINT SIGTERM

# ── Keep script alive ──────────────────────────
wait
