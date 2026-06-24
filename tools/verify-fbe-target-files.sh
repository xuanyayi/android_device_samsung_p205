#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <expanded-target-files-dir|target-files.zip>" >&2
    exit 2
fi

TARGET="$1"
EXPECTED='fileencryption=aes-256-xts:aes-256-cts:v1'

check_stream() {
    local label="$1"
    local data="$2"

    if ! grep -q '/data' <<<"$data"; then
        echo "FAIL: $label has no /data fstab entry" >&2
        return 1
    fi

    if ! grep -q "$EXPECTED" <<<"$data"; then
        echo "FAIL: $label /data entry is missing $EXPECTED" >&2
        grep '/data' <<<"$data" >&2 || true
        return 1
    fi

    echo "PASS: $label"
    grep '/data' <<<"$data"
}

if [ -d "$TARGET" ]; then
    check_stream "BOOT/RAMDISK/fstab.exynos7904" "$(cat "$TARGET/BOOT/RAMDISK/fstab.exynos7904")"
    check_stream "VENDOR/etc/fstab.exynos7904" "$(cat "$TARGET/VENDOR/etc/fstab.exynos7904")"
    check_stream "RECOVERY/RAMDISK/system/etc/recovery.fstab" "$(cat "$TARGET/RECOVERY/RAMDISK/system/etc/recovery.fstab")"
else
    check_stream "BOOT/RAMDISK/fstab.exynos7904" "$(unzip -p "$TARGET" BOOT/RAMDISK/fstab.exynos7904)"
    check_stream "VENDOR/etc/fstab.exynos7904" "$(unzip -p "$TARGET" VENDOR/etc/fstab.exynos7904)"
    check_stream "RECOVERY/RAMDISK/system/etc/recovery.fstab" "$(unzip -p "$TARGET" RECOVERY/RAMDISK/system/etc/recovery.fstab)"
fi
