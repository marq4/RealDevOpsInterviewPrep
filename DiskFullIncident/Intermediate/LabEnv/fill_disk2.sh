#! /bin/bash -

# Scenario: Linux VM disk filled over time with realistic files.

set -euo pipefail

echo "=========================================="
echo "Setting up lab..."
echo "=========================================="

# Application logs (600MB total):
# - 1 current log (400MB)
# - 10 rotated logs at different ages (20MB each = 200MB)
mkdir -p /var/log/myapp
echo "Creating application logs..."
dd if=/dev/zero of=/var/log/myapp/app.log bs=1M count=400 2>/dev/null
for i in {1..10}
do
    log_file="/var/log/myapp/app.log.$i"
    dd if=/dev/zero of="${log_file}" bs=1M count=20 2>/dev/null
    touch -d "$((i * 10)) days ago" "${log_file}"
done

# Old database backup dumps (600MB total):
# - 3 old backups at different dates
mkdir -p /backup
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

# Failed Docker layer cache (300MB total):
# Realistic overlay2 layer names (hex IDs)
mkdir -p /var/lib/docker/overlay2
echo "Creating Docker layer cache..."
dd if=/dev/zero of=/var/lib/docker/overlay2/a7f3c8e9d2b1f4a6c8e7d9b2f1a4c6e8-init bs=1M count=100 2>/dev/null
touch -d "60 days ago" /var/lib/docker/overlay2/a7f3c8e9d2b1f4a6c8e7d9b2f1a4c6e8-init

dd if=/dev/zero of=/var/lib/docker/overlay2/e4d9c2f7a1b8e6d3c9f2a7b4e1d8c5f9 bs=1M count=100 2>/dev/null
touch -d "45 days ago" /var/lib/docker/overlay2/e4d9c2f7a1b8e6d3c9f2a7b4e1d8c5f9

dd if=/dev/zero of=/var/lib/docker/overlay2/f8b3d1c6e9a2f4d7c8e1b5a9d3f6c2e7.tmp bs=1M count=100 2>/dev/null
touch -d "30 days ago" /var/lib/docker/overlay2/f8b3d1c6e9a2f4d7c8e1b5a9d3f6c2e7.tmp

# Core dump (200MB):
# Use /dev/zero NOT /dev/random (random blocks waiting for entropy)
mkdir -p /var/crash
echo "Creating core dump..."
dd if=/dev/zero of=/var/crash/core.02102026 bs=1M count=200 2>/dev/null
touch -d "15 days ago" /var/crash/core.02102026

# APT package cache (200MB):
# Leftover .deb files from old installs
mkdir -p /var/cache/apt/archives
echo "Creating APT cache..."
dd if=/dev/zero of=/var/cache/apt/archives/linux-image-5.4.0-169-generic_5.4.0-169.187_amd64.deb bs=1M count=100 2>/dev/null
touch -d "90 days ago" /var/cache/apt/archives/linux-image-5.4.0-169-generic_5.4.0-169.187_amd64.deb

dd if=/dev/zero of=/var/cache/apt/archives/linux-modules-5.4.0-169-generic_5.4.0-169.187_amd64.deb bs=1M count=100 2>/dev/null
touch -d "90 days ago" /var/cache/apt/archives/linux-modules-5.4.0-169-generic_5.4.0-169.187_amd64.deb

# Total: ~1900MB (fills ~95% of remaining 2.0GB free space)
