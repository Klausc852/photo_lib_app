#!/bin/bash

# Flutter Base App - Quick Setup Script
# This script will set up your Flutter project automatically

echo "🚀 Flutter Base App - Quick Setup"
echo "=================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter from: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
echo ""

# Check Flutter version
echo "📋 Flutter version:"
flutter --version
echo ""

# Run flutter doctor
echo "🔍 Running flutter doctor..."
flutter doctor
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo ""

# Run build_runner
echo "🔨 Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo "✅ Build runner completed successfully"
else
    echo "⚠️  Build runner had warnings (this is okay if no Hive models yet)"
fi
echo ""

# Clean build
echo "🧹 Cleaning build files..."
flutter clean
echo "✅ Clean completed"
echo ""

# Get dependencies again after clean
echo "📦 Re-installing dependencies..."
flutter pub get
echo "✅ Dependencies re-installed"
echo ""

echo "=================================="
echo "✨ Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Connect a device or start an emulator"
echo "2. Run: flutter run"
echo "3. Enjoy developing! 🎉"
echo ""
echo "Useful commands:"
echo "  flutter run           - Run the app"
echo "  flutter test          - Run tests"
echo "  flutter analyze       - Analyze code"
echo "  flutter build apk     - Build Android APK"
echo ""
