#!/bin/sh

if [ -z "$THEOS_DEVICE_SIMULATOR" ]; then
  exit 0
fi

cd $(dirname $0)/..

DEVICE_ID="5B06938E-E08D-4E4E-A99C-F375CB47565B"
XCODE_PATH=$(xcode-select -p)

xcrun simctl boot $DEVICE_ID
open $XCODE_PATH/Applications/Simulator.app
