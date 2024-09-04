#!/bin/sh

if [ -z "$SIMULATOR" ]; then
  exit 0
fi

cd $(dirname $0)/..

TWEAK_NAMES="RemoveWidgetBackground"

for TWEAK_NAME in $TWEAK_NAMES; do
  sudo rm -f /opt/simject/$TWEAK_NAME.dylib
  sudo cp -v $THEOS_OBJ_DIR/$TWEAK_NAME.dylib /opt/simject/$TWEAK_NAME.dylib
  sudo codesign -f -s - /opt/simject/$TWEAK_NAME.dylib
  sudo cp -v $PWD/$TWEAK_NAME.plist /opt/simject
done

BUNDLE_NAMES="RWBGPrefs"

for BUNDLE_NAME in $BUNDLE_NAMES; do
  sudo rm -rf /opt/simject/PreferenceBundles/$BUNDLE_NAME.bundle
  sudo cp -rv $THEOS_OBJ_DIR/$BUNDLE_NAME.bundle /opt/simject/PreferenceBundles/$BUNDLE_NAME.bundle
  sudo codesign -f -s - /opt/simject/PreferenceBundles/$BUNDLE_NAME.bundle
done

sudo cp -rv $PWD/RWBGPrefs/layout/Library/PreferenceLoader/Preferences/RWBGPrefs /opt/simject/PreferenceLoader/Preferences/

resim
