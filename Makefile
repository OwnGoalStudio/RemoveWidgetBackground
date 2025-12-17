export PACKAGE_VERSION := 2.0
export GO_EASY_ON_ME := 1

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
TARGET := simulator:clang:latest:14.0
ARCHS := arm64 x86_64
else
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES := chronod SpringBoard
ARCHS := arm64 arm64e
endif

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += RWBGPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME := RemoveWidgetBackground

RemoveWidgetBackground_FILES += RemoveWidgetBackground.x
RemoveWidgetBackground_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

export THEOS_OBJ_DIR
after-all::
	@devkit/sim-install.sh
