#!/usr/bin/env bash

# fail if any command fails
set -e
# debug log
set -x

# re export flutter PATH
cd ..
export PATH=`pwd`/flutter/bin:$PATH

# build integration test
flutter build ios integration_test/increment_test.dart --release

# change dir to ios subfolder
cd ios

# delete the derived data folder if it exists
rm -fr DerivedData

# build for testing
xcodebuild build-for-testing -sdk "iphoneos" -workspace Runner.xcworkspace -scheme Runner -config Release -derivedDataPath DerivedData

# test
xcodebuild test-without-building -xctestrun DerivedData/Build/Products/Runner_iphoneos14.4-arm64.xctestrun -destination 'platform=iOS,name=iPhone 12 Pro Max'
