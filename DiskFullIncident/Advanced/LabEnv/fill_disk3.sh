#! /bin/bash -
# Advanced Disk Lab - Setup Script.
# Run once to prepare the environment.

set -euo pipefail

echo "=========================================="
echo "Setting up advanced disk lab..."
echo "=========================================="

# ── Directories ────────────────────────────────
mkdir -p /var/log/myapp
mkdir -p /backup
mkdir -p /var/crash
mkdir -p /var/lib/docker/overlay2
mkdir -p /opt/myapp


# ── Copy runaway.sh ────────────────────────────
# (assumes runaway.sh is in same directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/runaway.sh" ]]; then
    cp "${SCRIPT_DIR}/runaway.sh" /opt/myapp/runaway.sh
    chmod +x /opt/myapp/runaway.sh
fi


# ── Fake myapp binary ──────────────────────────
echo "Creating myapp binary..."
cat > /opt/myapp/myapp << 'APP'
#!/bin/bash
# Fake myapp - simulates a real application
while true; do
    sleep 1
done
APP
chmod +x /opt/myapp/myapp

# ── Systemd service ────────────────────────────
echo "Installing myapp systemd service..."
cat > /etc/systemd/system/myapp.service << 'SERVICE'
[Unit]
Description=My Application Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/myapp/myapp
Restart=always
RestartSec=3
StandardOutput=append:/var/log/myapp/app.log
StandardError=append:/var/log/myapp/app.log

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable myapp.service
systemctl start myapp.service



# ── Application logs ───────────────────────────
echo "Creating application logs..."
dd if=/dev/zero of=/var/log/myapp/app.log bs=1M count=400 2>/dev/null
for i in {1..10}; do
    log_file="/var/log/myapp/app.log.$i"
    dd if=/dev/zero of="${log_file}" bs=1M count=20 2>/dev/null
    touch -d "$((i * 10)) days ago" "${log_file}"
done

# ── Old database backups ───────────────────────
echo "Creating old database backups..."
db_bkp=/backup/db-backup-2023-10-01.sql.gz
dd if=/dev/zero of="${db_bkp}" bs=1M count=300 2>/dev/null
touch -t 202310011430 "${db_bkp}"

db_bkp=/backup/db-backup-2024-01-01.sql.gz
dd if=/dev/zero of="${db_bkp}" bs=1M count=200 2>/dev/null
touch -t 202401011430 "${db_bkp}"

db_bkp=/backup/db-backup-2024-01-15.sql.gz
dd if=/dev/zero of="${db_bkp}" bs=1M count=100 2>/dev/null
touch -t 202401151430 "${db_bkp}"

# ── Docker layer cache ─────────────────────────
echo "Creating Docker layer cache..."
dd if=/dev/zero of=/var/lib/docker/overlay2/a7f3c8e9d2b1f4a6c8e7d9b2f1a4c6e8-init bs=1M count=100 2>/dev/null
touch -d "60 days ago" /var/lib/docker/overlay2/a7f3c8e9d2b1f4a6c8e7d9b2f1a4c6e8-init

dd if=/dev/zero of=/var/lib/docker/overlay2/e4d9c2f7a1b8e6d3c9f2a7b4e1d8c5f9 bs=1M count=100 2>/dev/null
touch -d "45 days ago" /var/lib/docker/overlay2/e4d9c2f7a1b8e6d3c9f2a7b4e1d8c5f9

dd if=/dev/zero of=/var/lib/docker/overlay2/f8b3d1c6e9a2f4d7c8e1b5a9d3f6c2e7.tmp bs=1M count=100 2>/dev/null
touch -d "30 days ago" /var/lib/docker/overlay2/f8b3d1c6e9a2f4d7c8e1b5a9d3f6c2e7.tmp

# ── APT cache ──────────────────────────────────
echo "Creating APT cache..."
mkdir -p /var/cache/apt/archives
dd if=/dev/zero of=/var/cache/apt/archives/linux-image-5.4.0-169-generic_5.4.0-169.187_amd64.deb bs=1M count=100 2>/dev/null
touch -d "90 days ago" /var/cache/apt/archives/linux-image-5.4.0-169-generic_5.4.0-169.187_amd64.deb

dd if=/dev/zero of=/var/cache/apt/archives/linux-modules-5.4.0-169-generic_5.4.0-169.187_amd64.deb bs=1M count=100 2>/dev/null
touch -d "90 days ago" /var/cache/apt/archives/linux-modules-5.4.0-169-generic_5.4.0-169.187_amd64.deb

# ── Core dump ──────────────────────────────────
echo "Creating core dump..."
dd if=/dev/zero of=/var/crash/core.02102026 bs=1M count=200 2>/dev/null
touch -d "15 days ago" /var/crash/core.02102026

echo ""
echo "=========================================="
echo "Setup complete! "
echo "=========================================="
