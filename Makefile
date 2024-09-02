TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = chronod SpringBoard

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += RWBGPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME := RemoveWidgetBackground

RemoveWidgetBackground_FILES += RemoveWidgetBackground.x
RemoveWidgetBackground_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
