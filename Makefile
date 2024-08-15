TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = chronod

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := RemoveWidgetBackground

RemoveWidgetBackground_FILES += RemoveWidgetBackground.x
RemoveWidgetBackground_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
