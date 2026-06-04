DEVICE_PATH := device/samsung/wisdom

TARGET_OTA_ASSERT_DEVICE := p205,wisdom,wisdomx

# Kernel
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_CONFIG := wisdom_defconfig
BOARD_CUSTOM_BOOTIMG_MK := hardware/samsung/mkbootimg.mk
TARGET_CUSTOM_DTBTOOL := dtbhtoolExynos
BOARD_BOOT_HEADER_VERSION := 1

# Keep the known-booting 4.4.177 p205 kernel until the 4.4.302 source kernel
# is boot-stable on this tablet.

# Use the booting SM-P205 TWRP DTBO as a base until the source kernel is
# stable, but keep its speaker route aligned with the runtime
# `tfa98xx-aif-9-34` widget rather than the broken `8-34` route in the stock
# blob.
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/recovery_dtbo
BOARD_PREBUILT_RECOVERY_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/recovery_dtbo

BOARD_ROOT_EXTRA_SYMLINKS := \
    /mnt/vendor/efs:/efs \
    /mnt/vendor/efs:/factory

# Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_USES_FULL_RECOVERY_IMAGE := true
BOOTLOADER_MESSAGE_OFFSET := 2048
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.exynos7904
TARGET_RECOVERY_PIXEL_FORMAT := "ABGR_8888"

# Sepolicy
BOARD_SEPOLICY_TEE_FLAVOR := mobicore

# SPL
VENDOR_SECURITY_PATCH := 2023-02-01

# Inherit common board flags
include device/samsung/universal7904-common/BoardConfigCommon.mk

# p205-specific partition sizes. Keep these after common BoardConfig so the
# shared wisdom defaults do not override the real SM-P205 layout.
TARGET_COPY_OUT_PRODUCT := product
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4227858432
BOARD_VENDORIMAGE_PARTITION_SIZE := 570425344
BOARD_PRODUCTIMAGE_PARTITION_SIZE := 436207616
BOARD_CACHEIMAGE_PARTITION_SIZE := 367001600
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25354567680
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 39845888
TARGET_USERIMAGES_USE_F2FS := false

# AVB is disabled for initial bring-up; flash disabled vbmeta separately.
BOARD_AVB_ENABLE := false
BOARD_BUILD_DISABLED_VBMETAIMAGE := true

# VINTF
DEVICE_MANIFEST_FILE += \
    $(DEVICE_PATH)/configs/android.hardware.keymaster@3.0-service.xml \
    $(DEVICE_PATH)/configs/camera-provider.xml \
    $(DEVICE_PATH)/configs/radio_manifest.xml
