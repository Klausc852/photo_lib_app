# Flutter Base App - Setup Guide

## Quick Start

Follow these steps to get your Flutter app up and running:

### 1. Prerequisites

Ensure you have the following installed:
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **IDE**: VS Code or Android Studio
- **Device/Emulator**: Physical device or emulator for testing

Check your Flutter installation:
```bash
flutter doctor
```

### 2. Install Dependencies

Navigate to the project directory and run:
```bash
cd /Users/klaustang/Desktop/git/tools/flutterBase
flutter pub get
```

This will download all required packages specified in `pubspec.yaml`.

### 3. Generate Required Files

Run the build_runner to generate files for Hive:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Add Assets (Optional)

If you have custom images or logos:

1. Place your logo in `assets/logo/`
2. Place images in `assets/images/`
3. Place Lottie animations in `assets/animations/`

Update the splash screen code in `lib/screens/splash/splash_screen.dart` to use your logo:

```dart
// Replace the _buildLogo method with:
Widget _buildLogo(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Image.asset(
      'assets/logo/app_logo.png',
      width: 120.w,
      height: 120.w,
      fit: BoxFit.contain,
    ),
  );
}
```

### 5. Run the App

#### For Debug Mode:
```bash
flutter run
```

#### For Specific Device:
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

#### For iOS (macOS only):
```bash
flutter run -d ios
```

#### For Android:
```bash
flutter run -d android
```

### 6. Hot Reload & Hot Restart

While the app is running:
- **Hot Reload**: Press `r` in terminal (fast, maintains state)
- **Hot Restart**: Press `R` in terminal (restarts app)
- **Quit**: Press `q` in terminal

## Customization Guide

### Change App Name

1. **Android**: Edit `android/app/src/main/AndroidManifest.xml`
   ```xml
   <application android:label="Your App Name">
   ```

2. **iOS**: Edit `ios/Runner/Info.plist`
   ```xml
   <key>CFBundleName</key>
   <string>Your App Name</string>
   ```

### Change Package Name/Bundle ID

Use the `change_app_package_name` package or manually update:

1. Install the package:
   ```bash
   flutter pub global activate change_app_package_name
   ```

2. Change package name:
   ```bash
   flutter pub global run change_app_package_name:main com.yourcompany.appname
   ```

### Customize Colors

Edit `lib/core/themes/app_colors.dart`:

```dart
// Light Theme Colors
static const Color primaryLight = Color(0xFF2196F3); // Your primary color
static const Color secondaryLight = Color(0xFF4CAF50); // Your secondary color
```

### Customize Fonts

The app uses Google Fonts (Roboto by default). To change:

Edit `lib/core/themes/app_theme.dart`:

```dart
// Change font in _buildTextTheme method
displayLarge: GoogleFonts.poppins(  // Change to your preferred font
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: textColor,
),
```

### Change API Endpoint

Edit `lib/core/services/api_service.dart`:

```dart
final String baseUrl = 'https://your-api-endpoint.com';
```

Then update the repository methods accordingly.

### Adjust Screen Design Base

Edit `lib/main.dart`:

```dart
ScreenUtilInit(
  designSize: const Size(375, 812), // Change to your design dimensions
  // ...
)
```

## Project Structure

```
flutterBase/
├── android/              # Android native code
├── assets/              # App assets
│   ├── images/         # Image files
│   ├── animations/     # Lottie animations
│   └── logo/           # App logo
├── ios/                # iOS native code
├── lib/                # Dart source code
│   ├── core/          # Core functionality
│   │   ├── models/    # Data models
│   │   ├── providers/ # State management
│   │   ├── repositories/ # Data layer
│   │   ├── services/  # Services (API, Cache)
│   │   └── themes/    # Theme configurations
│   ├── screens/       # App screens
│   │   ├── splash/
│   │   ├── main_screen/
│   │   └── settings/
│   ├── widgets/       # Reusable widgets
│   └── main.dart      # App entry point
├── test/              # Unit tests
├── pubspec.yaml       # Dependencies
└── README.md          # Documentation
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (macOS only)
```bash
flutter build ios --release
```
Then open Xcode to archive and distribute.

## Testing

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/widget_test.dart
```

## Common Issues & Solutions

### Issue: Packages not found
**Solution:**
```bash
flutter pub get
flutter pub upgrade
```

### Issue: Build errors after package update
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Hot reload not working
**Solution:**
- Press `R` for hot restart
- Or stop and run again: `flutter run`

### Issue: Hive errors
**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Font not loading
**Solution:**
- Check internet connection (Google Fonts loads on first use)
- Fonts are cached after first download

## Development Tips

1. **Use Hot Reload**: Saves time during development (press `r`)
2. **Check Logs**: Use `print()` or `debugPrint()` for logging
3. **Flutter DevTools**: Run `flutter pub global activate devtools` then `flutter pub global run devtools`
4. **Format Code**: Press `Shift + Alt + F` (VS Code) or `Cmd + Alt + L` (Android Studio)
5. **Analyze Code**: Run `flutter analyze` to check for issues

## Next Steps

1. ✅ Install dependencies: `flutter pub get`
2. ✅ Run the app: `flutter run`
3. 🎨 Customize colors and themes
4. 🖼️ Add your logo and assets
5. 🌐 Configure your API endpoints
6. 📱 Test on real devices
7. 🚀 Build for production

## Useful Commands

```bash
# Get packages
flutter pub get

# Clean build
flutter clean

# Run app
flutter run

# Run with flavor
flutter run --flavor development

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Check Flutter setup
flutter doctor

# Update packages
flutter pub upgrade
```

## Support & Resources

- **Flutter Docs**: https://docs.flutter.dev/
- **Pub.dev**: https://pub.dev/ (Package repository)
- **Flutter Community**: https://flutter.dev/community
- **Stack Overflow**: Tag with `flutter` and `dart`

## Need Help?

Check the comprehensive [README.md](README.md) for detailed feature documentation.

---

Happy Coding! 🚀
