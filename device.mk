DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

LINEAGE_SKIP_CUSTOM_LOCALES := true

PRODUCT_SHIPPING_API_LEVEL := 28
PRODUCT_USE_DYNAMIC_PARTITIONS := false

# Bring-up diagnostics. Keep USB adb enabled by default and keep enough log
# buffer to diagnose black-screen boots from recovery/pstore. For rescue builds
# that need insecure adb, use WITH_ADB_INSECURE=true instead of overriding
# ro.adb.secure in the product properties.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.usb.config=mtp,adb \
    persist.service.adb.enable=1 \
    persist.service.debuggable=1 \
    persist.logd.size=8M \
    ro.logd.size=8M

PRODUCT_VENDOR_PROPERTIES += \
    ro.recovery.usb.vid=04E8 \
    ro.recovery.usb.adb.pid=685D \
    ro.recovery.usb.fastboot.pid=685D

# Inherit common device configuration
$(call inherit-product, device/samsung/universal7904-common/universal7904-common.mk)

$(call inherit-product, vendor/samsung/wisdom/wisdom-vendor.mk)

# Samsung's RIL and carrier-feature blobs look up OMC data under /product/omc
# for CSC/network policy, including legacy CS fallback behavior. The OMC
# cscfeature XML files are Samsung-encoded, so they are installed as prebuilt
# modules instead of PRODUCT_COPY_FILES to avoid host xmllint validation.
include vendor/samsung/wisdom/omc-packages.mk

PRODUCT_PRODUCT_PROPERTIES += \
    ro.omc.build.version=P205OLM6CWA2 \
    ro.omc.build.id=61127026 \
    ro.omc.changetype=NONE \
    ro.simbased.changetype=NONE \
    ro.omc.disabler=FALSE

# P205 stock camera provider uses Samsung's prebuilt camera.device/provider
# legacy implementations. Do not install the AOSP stubs with the same stems.
PRODUCT_PACKAGES := $(filter-out \
    android.hardware.camera.provider@2.4-legacy \
    android.hardware.camera.provider@2.5-legacy \
    camera.device@1.0-impl \
    camera.device@3.2-impl \
    camera.device@3.3-impl \
    camera.device@3.4-impl \
    camera.device@3.5-impl, \
    $(PRODUCT_PACKAGES))

# Camera
PRODUCT_PACKAGES += \
    vendor.samsung.hardware.camera.provider@4.0.vendor

PRODUCT_COPY_FILES += \
    vendor/samsung/wisdom/proprietary/vendor/etc/permissions/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.multisim.simslotcount=1 \
    ro.vendor.radio.voice_capable=1 \
    ro.vendor.telephony.force_legacy_voice_capability=1

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-service \
    android.hardware.keymaster@3.0-impl \
    libkeymaster3device

# Rootdir
PRODUCT_PACKAGES += \
	fstab.exynos7904 \
	init.target.rc \
	init.baseband.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Navigation bar mode overlays. The 2-button overlay is inherited from the
# common Lineage tablet config and is harmless to keep for now.
PRODUCT_PACKAGES += \
    Dialer \
    NavigationBarMode3ButtonOverlay \
    NavigationBarModeGesturalOverlay \
    PhhImsFrameworkOverlay \
    framework_compatibility_matrix.p205_kernel_2.xml
