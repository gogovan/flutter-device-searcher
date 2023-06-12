#!/bin/bash
# Script for CI to generate Pull Request when Phrase updates

# exit on error
set -e
# show debug log
set -x

flutter clean
flutter pub get
