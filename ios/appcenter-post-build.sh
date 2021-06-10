#!/usr/bin/env bash

# fail if any command fails
set -e
# debug log
set -x

# re export flutter PATH
cd ..
export PATH=`pwd`/flutter/bin:$PATH

# build integration test
flutter build ios integration_test/increment_test.dart --debug

# change dir to ios subfolder
cd ios

# delete the derived data folder if it exists
rm -fr DerivedData

# build for testing
xcodebuild build-for-testing -sdk iphonesimulator -workspace Runner.xcworkspace -scheme Runner -config Debug -derivedDataPath DerivedData ARCHS="x86_64" VALID_ARCHS="x86_64" 

# test
xcodebuild test-without-building -xctestrun DerivedData/Build/Products/Runner_iphonesimulator14.5-x86_64.xctestrun -destination 'platform=iOS Simulator,name=iPhone 12 Pro Max'
