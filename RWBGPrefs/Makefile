ifeq ($(THEOS_DEVICE_SIMULATOR),1)
TARGET := simulator:clang:latest:14.0
ARCHS := arm64
else
TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES := Preferences
ARCHS := arm64 arm64e
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME := RWBGPrefs

RWBGPrefs_FILES += RWBGRootListController.m
RWBGPrefs_CFLAGS += -fobjc-arc

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
RWBGPrefs_LDFLAGS += -FFrameworks/_Simulator
RWBGPrefs_LDFLAGS += -rpath /opt/simject
else
RWBGPrefs_LDFLAGS += -FFrameworks
endif

RWBGPrefs_FRAMEWORKS += UIKit
RWBGPrefs_EXTRA_FRAMEWORKS += AltList
RWBGPrefs_PRIVATE_FRAMEWORKS += CoreServices
RWBGPrefs_PRIVATE_FRAMEWORKS += Preferences
RWBGPrefs_INSTALL_PATH += /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk