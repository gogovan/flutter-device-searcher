#!/bin/bash
# Script for CI to generate Pull Request when Phrase updates

# exit on error
set -e
# show debug log
set -x

cd base
dart format lib
dart format test
flutter analyze --fatal-infos --fatal-warnings
cd ..

cd bluetooth
dart format lib
dart format test
flutter analyze --fatal-infos --fatal-warnings
cd ..

cd usb
dart format lib
dart format test
flutter analyze --fatal-infos --fatal-warnings
cd ..

exit 0
