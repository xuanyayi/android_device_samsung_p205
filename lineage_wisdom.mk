# Copyright (C) 2018 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# The SM-P205 product partition is only 416 MiB. Avoid full_base_telephony.mk
# because it pulls large generic /product apps that do not fit the real device
# layout. Keep the system/vendor pieces required for a phone/tablet bring-up,
# and only include the small product base plus WebView.
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/media_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/wisdom/device.mk)

# Keep a camera frontend installed even though this target uses the mini tablet
# package set to fit the real SM-P205 product partition.
PRODUCT_PACKAGES += \
    Aperture \
    FlipFlap \
    FlipFlapOverlay \
    Gallery2 \
    PhotoTable

# Restore the standard Android language set; this target does not inherit
# full_base.mk because the product partition is small.
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# This unofficial build does not provide OTA updates; keep the updater service
# out of RAM on the 3GB device.
TARGET_DISABLE_LINEAGE_UPDATER := true

## Inherit common Lineage tablet stuff without the full optional app suite.
$(call inherit-product, vendor/lineage/config/common_mini_tablet.mk)

# Keep Settings search available while staying on the mini package set.
PRODUCT_PACKAGES += \
    SettingsIntelligence

# Device identifier. wisdom is the canonical local device path and product
# device name; p205 remains only as the hardware/model alias for SM-P205.
PRODUCT_DEVICE := wisdom
PRODUCT_NAME := lineage_wisdom
PRODUCT_MODEL := SM-P205
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

TARGET_DISABLE_EPPE := true
PRODUCT_CHARACTERISTICS := tablet
