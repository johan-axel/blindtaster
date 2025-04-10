#!/bin/bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$PWD/flutter/bin"
flutter precache
flutter pub get
flutter build web
