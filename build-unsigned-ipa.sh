#!/bin/bash
# Build unsigned IPA locally on Mac for dsh-Go iOS
# Usage: ./build-unsigned-ipa.sh

set -e

echo "🔧 Building unsigned IPA for dsh-Go iOS..."

# Check if we're in the right directory
if [ ! -d "app" ]; then
    echo "❌ 'app' directory not found. Run this from dsh-Go root."
    exit 1
fi

cd app

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🏗️  Building iOS (no codesign)..."
flutter build ios --release --no-codesign

echo "📱 Packaging unsigned IPA..."
APP_PATH=$(find build/ios -name "Runner.app" -type d | head -1)
if [ -z "$APP_PATH" ]; then
    echo "❌ Runner.app not found in build/ios"
    exit 1
fi

echo "Found: $APP_PATH"

rm -rf Payload unsigned.ipa
mkdir -p Payload
cp -R "$APP_PATH" Payload/
zip -r unsigned.ipa Payload/
rm -rf Payload

echo "✅ Done! unsigned.ipa created at: $(pwd)/unsigned.ipa"
echo ""
echo "Next steps:"
echo "1. Copy unsigned.ipa to your iPhone (via AirDrop, Files, etc.)"
echo "2. Open eSign (or your signing tool) and upload unsigned.ipa"
echo "3. Select your certificate/provisioning profile"
echo "4. Sign and install the resulting IPA"