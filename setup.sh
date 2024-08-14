#!/bin/bash
# Script for CI to generate Pull Request when Phrase updates

# exit on error
set -e
# show debug log
set -x

cd base
flutter clean
flutter pub get
cd ..

cd bluetooth
flutter clean
flutter pub get
dart run build_runner build
cd ..

cd usb
flutter clean
flutter pub get
cd ..
