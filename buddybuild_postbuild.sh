#!/bin/sh

set -e

bundle install 
echo "Running tests for scheme $BUDDYBUILD_SCHEME"

xcodebuild -scheme $BUDDYBUILD_SCHEME -project Paparazzi.xcodeproj test | bundle exec xcpretty -t
