#!/usr/bin/env bash

# fail if any command fails
set -e
# debug log
set -x

# re-export flutter PATH
cd $APPCENTER_SOURCE_DIRECTORY
export PATH=`pwd`/flutter/bin:$PATH


######################### Unit & Widget testing

# run unit and widget tests
flutter test


######################### Prepare Integration tests

# generates files in android/ for building the app
flutter build apk --release

# change dir to android subfolder
cd android

# build for testing
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=`pwd`/../integration_test/increment_test.dart


######################### google cloud testing

# download google cloud sdk
cd $APPCENTER_SOURCE_DIRECTORY
curl -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-345.0.0-darwin-x86_64.tar.gz
# unpack
tar -xf google-cloud-sdk.tar.gz
# get service account
echo $SERVICE_ACCOUNT > /tmp/$CI_PIPELINE_ID_TMP.json
cat /tmp/$CI_PIPELINE_ID_TMP.json | sed -e 's/\\\"/\"/g' > /tmp/$CI_PIPELINE_ID.json
# auth
./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /tmp/$CI_PIPELINE_ID.json
# set the project
./google-cloud-sdk/bin/gcloud --quiet config set project $PROJECT_ID
# make sure the tool results api is enabled
./google-cloud-sdk/bin/gcloud services enable toolresults.googleapis.com
# upload and run the test
./google-cloud-sdk/bin/gcloud firebase test android run --type instrumentation --app build/app/outputs/apk/debug/app-debug.apk --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk --device=model=Pixel3,version=28


######################### cleaning

# delete flutter dir
rm -fr flutter
# delete gcloud key file
rm /tmp/$CI_PIPELINE_ID.json
rm /tmp/$CI_PIPELINE_ID_TMP.json
