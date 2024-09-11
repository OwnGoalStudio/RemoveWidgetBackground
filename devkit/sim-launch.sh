#!/bin/sh

if [ -z "$THEOS_DEVICE_SIMULATOR" ]; then
  exit 0
fi

cd $(dirname $0)/..

DEVICE_ID="C2975FF8-AFC5-4533-8C58-9DC0477499AF"
XCODE_PATH=$(xcode-select -p)

xcrun simctl boot $DEVICE_ID
open $XCODE_PATH/Applications/Simulator.app
