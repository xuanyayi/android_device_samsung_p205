LOCAL_PATH := $(call my-dir)

ifneq ($(filter p205, $(TARGET_DEVICE)),)

include $(call all-makefiles-under,$(LOCAL_PATH))

endif
