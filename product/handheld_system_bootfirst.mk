#
# Copyright (C) 2018 The Android Open Source Project
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Boot-first variant of AOSP handheld_system.mk for SM-P205 LOS22 bring-up.
# TeleService blocks startup while radio HAL/VINTF is unfinished, so keep the
# generic handheld system set without the persistent phone app/provider.
$(call inherit-product, $(SRC_TARGET_DIR)/product/media_system.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/dancing-script/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/carrois-gothic-sc/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/coming-soon/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/cutive-mono/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/source-sans-pro/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-flex-fonts/fonts.mk)
$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)
$(call inherit-product-if-exists, frameworks/webview/chromium/chromium.mk)

PRODUCT_PACKAGES += \
    android.software.window_magnification.prebuilt.xml \
    BasicDreams \
    BlockedNumberProvider \
    BluetoothMidiService \
    BookmarkProvider \
    BuiltInPrintService \
    CalendarProvider \
    cameraserver \
    CameraExtensionsProxy \
    CaptivePortalLogin \
    CertInstaller \
    CredentialManager \
    DeviceAsWebcam \
    DeviceDiagnostics \
    DocumentsUI \
    DownloadProviderUi \
    EasterEgg \
    ExternalStorageProvider \
    FusedLocation \
    InputDevices \
    KeyChain \
    librs_jni \
    ManagedProvisioning \
    MmsService \
    MtpService \
    MusicFX \
    PacProcessor \
    preinstalled-packages-platform-handheld-system.xml \
    PrintRecommendationService \
    PrintSpooler \
    ProxyHandler \
    screenrecord \
    SecureElement \
    SharedStorageBackup \
    SimAppDialog \
    Telecom \
    UserDictionaryProvider \
    VpnDialogs \
    vr

PRODUCT_PACKAGES += $(RELEASE_PACKAGE_VIRTUAL_CAMERA)
$(call soong_config_set,vdm,virtual_camera_service_enabled,$(if $(RELEASE_PACKAGE_VIRTUAL_CAMERA),true,false))

PRODUCT_SYSTEM_SERVER_APPS += \
    FusedLocation \
    InputDevices \
    KeyChain \
    Telecom

PRODUCT_PACKAGES += framework-audio_effects.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.carrier?=unknown \
    ro.config.notification_sound?=OnTheHunt.ogg \
    ro.config.alarm_alert?=Alarm_Classic.ogg

PRODUCT_PACKAGES_ENG += \
    Traceur
