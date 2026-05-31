# Samsung SM-P205 Device Facts

This file records hardware facts used by the `lineage_wisdom` bring-up. Do not
blindly encode every public spec into Android resources; only use values that
affect framework, partition, or HAL behavior.

## Identity

- Marketing name: Samsung Galaxy Tab A 8.0 with S Pen (2019), LTE
- Model: SM-P205
- Lineage target in this tree: `lineage_wisdom`
- Upstream community codename: `wisdom`
- Product/device assert aliases: `p205,wisdom,wisdomx`

## Platform

- SoC: Samsung Exynos 7904 / `universal7904`
- CPU: 2x Cortex-A73 + 6x Cortex-A53, arm64
- GPU: Mali-G71 MP2
- Display: 8.0 inch, 1200 x 1920
- Memory/storage public SKU: 3 GB RAM / 32 GB storage
- Battery: 4200 mAh class
- Factory Android generation: Android 9, so `PRODUCT_SHIPPING_API_LEVEL := 28`
- Official firmware generation used for blobs: Android 11
- Current bring-up baseline assumption: SM-P205 Android 11 stock firmware,
  defaulting to `P205DXU6CVG2` until a dump from the exact target tablet is
  provided and recorded here.
- Kernel/dtbo currently staged in this tree:
  - `device/samsung/p205/prebuilt/Image`
  - `device/samsung/p205/prebuilt/recovery_dtbo`
  - `device/samsung/p205/prebuilt/vbmeta.img`
  `BoardConfig.mk` deliberately forces the prebuilt kernel and prebuilt dtbo
  for rescue builds while userspace boot blockers are being removed. These
  files must be replaced together from the same selected stock baseline; do not
  mix a recovery dtbo with blobs or firmware from another build.
- Long-term source-kernel bring-up should keep `wisdom_defconfig`, add/validate
  p205 DTS entries and matching `BOARD_DTB_CFG`/`BOARD_DTBO_CFG`, then unset
  `TARGET_FORCE_PREBUILT_KERNEL`.
- Bluetooth bring-up is enabled through the Samsung SLSI H4 vendor library and
  `/dev/scsc_h4_0`. The 2026-05-25 pstore logs previously showed
  `com.android.bluetooth` aborting when the HCI service could not start, so
  validate the HCI HAL, feature XML, and profile properties together after each
  build.
- Wi-Fi uses Lineage's legacy HIDL service. The Android 13 1.6 default Wi-Fi
  service crashed in `getLinkLayerStats_1_6()` with the SLSI legacy HAL.
- `wlbtd` and `tfadsp.bin` are expected from the selected SM-P205 Android 11
  stock baseline and are present in the current local blob tree. The TFA
  speaker amplifier firmware is installed to both `/vendor/firmware` and the
  boot/recovery ramdisks under `/lib/firmware` because the kernel requests it
  before vendor is mounted.
- Do not ship `gsi_skip_mount.cfg` in p205 device builds. It skips `/product`
  and `/system_ext`, which made the 2026-05-25 build boot without product
  permissions/overlays and caused SystemUI to crash because
  `lineageglobalactions` was never published.

## Vendor Firmware Hashes

Current p205 camera firmware blobs:

```text
edaf335c151ad2d830db2d48fef302fd5bd3219e142bf58f7045a87097332949  fimc_is_lib.bin
53c169f830176d49e3585c0acec0f68016384d8fd027294f011bd8357bd30ee5  fimc_is_rta.bin
290bcafd2412a77fe451dbcb19099f7a79c249313ccc0d71a1b9ff6db71de85d  setfile_3l6.bin
f710e0c95a37176cfb3e1c9d463aedd8ad2833ab1085cf7a350ee107dff820ad  setfile_4ha.bin
61824aca51a708ed4a880e8a27767d3b85b80613ac12dd1b158319cc2d254433  setfile_5e9.bin
```

The source build fingerprint for these blobs is still unverified. Before
declaring the camera stack stable, re-extract these files from the selected
SM-P205 Android 11 stock firmware and update this section with the exact build
fingerprint and partition image hashes.

## Features

- LTE single-SIM tablet: expose one radio slot in VINTF and one default network entry.
- Wi-Fi 802.11 a/b/g/n/ac, Bluetooth 5.0, GPS/GLONASS/BDS/Galileo.
- Cameras: 8 MP rear, 5 MP front.
- Sensors publicly listed across sources: accelerometer, ambient light, hall,
  proximity. Do not advertise fingerprint, NFC or gyroscope unless verified on
  hardware.
- S Pen / Wacom input is device-defining; do not remove input support while pruning.
- NFC is not part of the SM-P205 public spec and there is no `nfc` partition/HAL in the current bring-up.

## Verified Partition Layout

Captured from TWRP on the target device:

```text
boot      mmcblk0p15   32768 KiB
recovery  mmcblk0p16   38912 KiB
dtb       mmcblk0p17    8192 KiB
dtbo      mmcblk0p18    8192 KiB
radio     mmcblk0p19   46080 KiB
vbmeta    mmcblk0p22     512 KiB
system    mmcblk0p25 4128768 KiB
vendor    mmcblk0p26  557056 KiB
product   mmcblk0p27  425984 KiB
cache     mmcblk0p28  358400 KiB
userdata  mmcblk0p32 24760320 KiB
```

There is no dedicated `odm` or `system_ext` partition on this device.
