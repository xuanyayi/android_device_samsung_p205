#!/usr/bin/env bash
set -euo pipefail

device_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
top="${ANDROID_BUILD_TOP:-$(cd "$device_dir/../../.." && pwd)}"
product_out="${OUT_DIR:-$top/out}/target/product/wisdom"
target_files_dir="${1:-}"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

pass() {
    echo "PASS: $*"
}

require_file() {
    [[ -f "$1" ]] || fail "missing $1"
}

require_grep() {
    local pattern="$1"
    local file="$2"
    grep -qE "$pattern" "$file" || fail "missing pattern '$pattern' in $file"
}

require_apk_bool_true() {
    local apk="$1"
    local name="$2"
    require_file "$apk"
    local dump
    dump="$("$top/out/host/linux-x86/bin/aapt2" dump resources "$apk" 2>/dev/null)" \
        || fail "could not dump resources from $apk"
    grep -A1 "bool/$name" <<<"$dump" | grep -q '() true' \
        || fail "$name is not true in $apk"
}

if [[ -z "$target_files_dir" ]]; then
    target_files_dir="$(find "$product_out/obj/PACKAGING/target_files_intermediates" \
        -maxdepth 1 -type d -name 'lineage_wisdom-target_files-*' \
        -printf '%T@ %p\n' 2>/dev/null | sort -nr | awk 'NR == 1 {print $2}')"
fi

[[ -n "$target_files_dir" && -d "$target_files_dir" ]] \
    || fail "target_files directory not found; pass it as argv[1]"

overlay_xml="$device_dir/overlay/frameworks/base/core/res/res/values/config.xml"
kernel_config="$product_out/obj/KERNEL_OBJ/.config"
if [[ ! -f "$kernel_config" ]]; then
    kernel_config="$product_out/kernel.config"
fi

require_file "$overlay_xml"
require_grep '<bool name="config_useDevInputEventForAudioJack">true</bool>' "$overlay_xml"
pass "3.5mm jack input-event framework overlay is enabled"

framework_rro="$(find "$target_files_dir/VENDOR/overlay" \
    -maxdepth 1 -type f -name 'framework-res*auto_generated_rro_vendor.apk' \
    -print -quit)"
[[ -n "$framework_rro" ]] || fail "framework-res vendor RRO not found in $target_files_dir/VENDOR/overlay"

require_apk_bool_true \
    "$framework_rro" \
    config_useDevInputEventForAudioJack
pass "target_files vendor framework overlay carries input-event jack support"

require_file "$target_files_dir/VENDOR/etc/audio_policy_configuration.xml"
require_file "$target_files_dir/VENDOR/etc/usb_audio_policy_configuration.xml"
require_file "$target_files_dir/VENDOR/etc/permissions/android.hardware.usb.host.xml"
require_grep 'usb_audio_policy_configuration.xml' \
    "$target_files_dir/VENDOR/etc/audio_policy_configuration.xml"
require_grep 'AUDIO_DEVICE_OUT_USB_HEADSET' \
    "$target_files_dir/VENDOR/etc/usb_audio_policy_configuration.xml"
require_grep 'AUDIO_DEVICE_IN_USB_HEADSET' \
    "$target_files_dir/VENDOR/etc/usb_audio_policy_configuration.xml"
pass "target_files carries USB host permission and USB headset audio policy"

if [[ -f "$kernel_config" ]]; then
    require_grep '^CONFIG_USB_DWC3_DUAL_ROLE=y$' "$kernel_config"
    require_grep '^CONFIG_SND_USB_AUDIO=y$' "$kernel_config"
    pass "kernel config enables USB dual-role host and USB audio"
else
    echo "WARN: kernel config not found; verify live /proc/config.gz for CONFIG_SND_USB_AUDIO=y"
fi

echo "Audio accessory support checks passed for $target_files_dir"
