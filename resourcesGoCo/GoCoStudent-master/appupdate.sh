#!/usr/bin/env bash

# Enable error checking
set -e

# App Defaults
APKNAME="GoCoStudent"
APKBUILDPATH="platforms/android/build/outputs/apk/"
APKBUILDNAMEARM="android-armv7-release-unsigned.apk"
APKBUILDNAMEx86="android-x86-release-unsigned.apk"
KEYSTOREPATH="gocostudent.keystore"
KEYSTOREALIAS="gocostudent"

# Colors
cecho() {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac
  [ -z "$text" ] && local text="$color$2${code}0m"
  echo "$text"
}

devices=( "iPhone-4s" "iPhone-5" "iPhone-6" "iPhone-6-Plus" "iPad-Air" )

cecho cyan "Welcome to AdamVig App Update."

# Increment app version numbers
read -p "Open files to increment version number? (y/n) " yn
if [ $yn == "y" ]; then
  atom config.xml www/js/constants.js package.json
fi

# Emulate iOS devices
read -p "Emulate all possible iOS devices? (y/n) " yn
if [ $yn == "y" ]; then
  for i in "${devices[@]}"; do

    # Emulate device
    cordova emulate ios --target="$i" >& /dev/null
    cecho blue "$i emulator started."

    # Bring iOS simulator window to front
    osascript \
      -e 'tell application "iOS Simulator"' \
      -e 'activate' \
      -e 'end tell'

    read -p "Press any key to continue... " -n1 -s
    echo

    # Temporarily disable error checking and kill iOS Simulator
    set +e
    killall "iOS Simulator" 2> /dev/null
    set -e
  done
fi

# Package Android app
read -p "Package Android app for distribution? (y/n) " yn
if [ $yn == "y" ]; then

  # Build app for Android
  cecho blue "Building app for Android."
  cordova build --release android 1> /dev/null && wait

  # Sign APK
  cecho blue "Signing APK."

  # NOTE: Can't redirect to /dev/null due to password input
  jarsigner -sigalg SHA1withRSA -digestalg SHA1 \
    -tsa http://timestamp.digicert.com \
    -keystore "$KEYSTOREPATH" "$APKBUILDPATH$APKBUILDNAMEARM" "$KEYSTOREALIAS"

  jarsigner -sigalg SHA1withRSA -digestalg SHA1 \
    -tsa http://timestamp.digicert.com \
    -keystore "$KEYSTOREPATH" "$APKBUILDPATH$APKBUILDNAMEx86" "$KEYSTOREALIAS"

  # Remove existing APK and zipalign new APK in its place
  cecho blue "Zipaligning and renaming APK."

  zipalign -v 4 "$APKBUILDPATH$APKBUILDNAMEARM" "${APKNAME}_armv7.apk" 1> /dev/null
  zipalign -v 4 "$APKBUILDPATH$APKBUILDNAMEx86" "${APKNAME}_x86.apk" 1> /dev/null

  cecho yellow  "Done. Android app is ready for distribution."
fi

# Package iOS app
read -p "Package iOS app for distribution? (y/n) " yn
if [ $yn == "y" ]; then

  # Build app for iOS
  cecho blue "Building app for iOS."
  cordova build --release ios >& /dev/null && wait

  # Open Xcode project
  cecho blue "Opening Xcode project."
  open platforms/ios/*.xcodeproj

  cecho yellow "Done. iOS app is ready for distribution."
fi
