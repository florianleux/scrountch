#!/bin/bash

# Scrountch APK Build Script
# This script builds the release APK for manual distribution

echo "🏠 Building Scrountch Family Inventory App..."
echo "================================================"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if google-services.json exists
if [ ! -f "android/app/google-services.json" ]; then
    echo "❌ google-services.json not found in android/app/"
    echo "Please download it from Firebase Console and place it in android/app/"
    echo "See firebase_setup_instructions.md for details"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📧 You can now distribute this APK via email to family members"
    echo "📊 APK size: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
    echo ""
    echo "🔥 Firebase Setup Reminder:"
    echo "   - Ensure Firebase project is configured"
    echo "   - Check security rules are applied"
    echo "   - Monitor quota usage in Firebase Console"
else
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi
