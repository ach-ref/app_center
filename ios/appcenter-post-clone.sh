#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

echo $SERVICE_ACCOUNT
cd $APPCENTER_SOURCE_DIRECTORY
curl -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-345.0.0-darwin-x86_64.tar.gz
# unpack
tar -xf google-cloud-sdk.tar.gz
# auth
echo $SERVICE_ACCOUNT > /tmp/$CI_PIPELINE_ID.json
./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /tmp/$CI_PIPELINE_ID.json


cd $APPCENTER_SOURCE_DIRECTORY
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

flutter build ios --release --no-codesign
