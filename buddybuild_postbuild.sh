#!/bin/sh

bundle install 
xcodebuild -scheme $BUDDYBUILD_SCHEME -project Paparazzi.xcodeproj test | bundle exec xcpretty -t
