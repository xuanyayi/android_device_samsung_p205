#!/usr/bin/env python3
#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

import os

import common


def FullOTA_InstallEnd(info):
  dtbo_path = os.path.join(info.input_tmp, "IMAGES", "dtbo.img")
  if not os.path.exists(dtbo_path):
    return

  dtbo_img = common.File.FromLocalFile("dtbo.img", dtbo_path)
  common.CheckSize(dtbo_img.data, "dtbo.img", info.info_dict)
  common.ZipWriteStr(info.output_zip, "dtbo.img", dtbo_img.data)
  info.script.WriteRawImage("/dtbo", "dtbo.img")
