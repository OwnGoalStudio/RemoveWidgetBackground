TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES := Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME := RWBGPrefs

RWBGPrefs_FILES += RWBGRootListController.m
RWBGPrefs_CFLAGS += -fobjc-arc

RWBGPrefs_FRAMEWORKS += UIKit
RWBGPrefs_PRIVATE_FRAMEWORKS += CoreServices
RWBGPrefs_PRIVATE_FRAMEWORKS += Preferences
RWBGPrefs_EXTRA_FRAMEWORKS += AltList
RWBGPrefs_INSTALL_PATH += /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk