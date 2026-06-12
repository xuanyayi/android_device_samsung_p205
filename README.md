# Samsung Galaxy Tab A 8.0 with S Pen LTE (SM-P205)

Device tree for building LineageOS 20 for the Samsung Galaxy Tab A 8.0 with
S Pen LTE (`SM-P205`, codename `wisdom`).

## Sync

```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
mkdir -p .repo/local_manifests
curl -L https://raw.githubusercontent.com/xuanyayi/android_manifest_samsung_wisdom/lineage-20/wisdom.xml \
  -o .repo/local_manifests/wisdom.xml
repo sync -c --force-sync --no-clone-bundle --no-tags -j"$(nproc --all)"
```

## Apply Patches

```bash
./patches/samsung/wisdom/apply-patches.sh "$PWD"
```

## Build

```bash
source build/envsetup.sh
lunch lineage_wisdom-userdebug
mka bacon -j"$(nproc --all)"
```

## Recovery

This device tree uses a validated prebuilt Lineage Recovery image. The
`recoveryimage` target copies `device/samsung/wisdom/prebuilt/recovery.img` to
`out/target/product/wisdom/recovery.img` instead of rebuilding recovery during a
normal ROM build.

The source and rebuild recipe for this recovery image live in:

```text
https://github.com/xuanyayi/p205-lineage-recovery
```

When synced through `android_manifest_samsung_wisdom`, the recovery source is
checked out at:

```text
recovery/samsung/p205_lineage_recovery
```

To verify the recovery output:

```bash
mka recoveryimage -j"$(nproc --all)"
cmp device/samsung/wisdom/prebuilt/recovery.img out/target/product/wisdom/recovery.img
```

To rebuild the recovery image itself, follow the README in
`recovery/samsung/p205_lineage_recovery`, then replace
`device/samsung/wisdom/prebuilt/recovery.img` only after validating the new
image size, boot behavior, and SHA-256.
