#!/bin/sh

if [ -z "$THEOS_DEVICE_SIMULATOR" ]; then
  exit 0
fi

cd $(dirname $0)/..

DEVICE_ID="9F68A084-F996-42EC-92E4-EA83A54AC8C5"
XCODE_PATH=$(xcode-select -p)

xcrun simctl boot $DEVICE_ID
open $XCODE_PATH/Applications/Simulator.app
