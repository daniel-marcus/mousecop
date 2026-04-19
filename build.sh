#!/bin/bash
set -e

APP=Mousecop.app
BUNDLE=$APP/Contents

swift build -c release

rm -rf $APP
mkdir -p $BUNDLE/MacOS
mkdir -p $BUNDLE/Resources

cp .build/release/mousecop $BUNDLE/MacOS/
cp AppIcon.icns $BUNDLE/Resources/
cp Info.plist $BUNDLE/

# Ad-hoc sign (sufficient for personal use; Input Monitoring permission
# will be tied to this bundle ID.)
codesign --sign - --force --deep $APP

echo "Built $APP"
