#! /bin/bash -

# Scenario: Linux container's disk filled over time.

set -euo pipefail

echo "=========================================="
echo "Setting up lab..."
echo "=========================================="

# Application logs:
mkdir -p /var/log/myapp
# Today:
dd if=/dev/zero of=/var/log/myapp/app.log bs=1M count=600 2>/dev/null
# Older:
for i in {1..200}
do
    log_file="/var/log/myapp/app.log.$i"
    dd if=/dev/zero of="${log_file}" bs=1M count=2 2>/dev/null
    touch -d "$((i * 10)) days ago" "${log_file}"
done

# Old database backup dumps:
mkdir -p /backup
db_bkp=/backup/db-backup-2024-01-01.sql.gz
dd if=/dev/zero of="${db_bkp}" bs=1M count=400 2>/dev/null
touch -t 202401011430 "${db_bkp}"
db_bkp=/backup/db-backup-2024-01-15.sql.gz
dd if=/dev/zero of="${db_bkp}" bs=1M count=400 2>/dev/null
touch -t 202401151430 "${db_bkp}"

# Failed Docker layer cache:
mkdir -p /var/lib/docker/overlay2
dd if=/dev/zero of=/var/lib/docker/overlay2/a7f3c8e9d2b1f4a6c8e7d9b2f1a4c6e8-init bs=1M count=300 2>/dev/null

# Core dump:
mkdir -p /var/crash
dd if=/dev/zero of=/var/crash/core.02102026 bs=1M count=200 2>/dev/null
