#!/usr/bin/env bash

# fail if any command fails
set -e
# debug log
set -x

# vars
DERIVED_DATA="DerivedData"
PRODUCT="DerivedData/Build/Products"
DEV_TARGET="14.4"

# re-export flutter PATH
cd ..
export PATH=`pwd`/flutter/bin:$PATH


######################### Unit & Widget testing

# run unit and widget tests
flutter test


######################### Prepare Integration tests

# build integration test
flutter build ios integration_test/increment_test.dart --release

# change dir to ios subfolder
cd ios

# build for testing
rm -fr $DERIVED_DATA
xcodebuild build-for-testing -sdk "iphoneos$DEV_TARGET" -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $DERIVED_DATA
# archive the build
cd $PRODUCT
zip -r ios_tests.zip Release-iphoneos Runner_iphoneos$DEV_TARGET-arm64.xctestrun


######################### google cloud testing

# download google cloud sdk
cd $APPCENTER_SOURCE_DIRECTORY
curl -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-345.0.0-darwin-x86_64.tar.gz
# unpack
tar -xf google-cloud-sdk.tar.gz
# auth
echo '$SERVICE_ACCOUNT' > /tmp/$CI_PIPELINE_ID.json
./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /tmp/$CI_PIPELINE_ID.json
# set the project
./google-cloud-sdk/bin/gcloud --quiet config set project $PROJECT_ID
# make sure the tool results api is enabled
./google-cloud-sdk/bin/gcloud services enable toolresults.googleapis.com
# upload and run the test
./google-cloud-sdk/bin/gcloud firebase test ios run --test ios/$PRODUCT/ios_tests.zip --device model=iphone11pro,version=14.1,locale=fr_FR,orientation=portrait


######################### cleaning

# delete flutter dir
rm -fr flutter
# delete derived data
rm -fr $DERIVED_DATA
# delete gcloud key file
rm /tmp/$CI_PIPELINE_ID.json
