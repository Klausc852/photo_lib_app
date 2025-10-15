# Flutter Base App - Quick Reference Guide

## 🚀 Quick Start Commands

```bash
# First time setup
./setup.sh

# Or manually:
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 📁 File Locations

| Purpose | Location |
|---------|----------|
| App Entry Point | `lib/main.dart` |
| Splash Screen | `lib/screens/splash/splash_screen.dart` |
| Main Screen | `lib/screens/main_screen/main_screen.dart` |
| Settings Screen | `lib/screens/settings/settings_screen.dart` |
| Theme Configuration | `lib/core/themes/app_theme.dart` |
| Colors | `lib/core/themes/app_colors.dart` |
| API Service | `lib/core/services/api_service.dart` |
| Cache Service | `lib/core/services/cache_service.dart` |
| Custom Widgets | `lib/widgets/` |
| Assets | `assets/images/`, `assets/logo/`, `assets/animations/` |

## 🎨 Customizing Themes

### Change Colors
Edit `lib/core/themes/app_colors.dart`:
```dart
static const Color primaryLight = Color(0xFF2196F3); // Your color here
```

### Change Theme Programmatically
```dart
// In any widget with context
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
themeProvider.setThemeMode(AppThemeMode.dark);
```

### Toggle Theme
```dart
themeProvider.toggleTheme(); // Cycles through Light -> Dark -> Custom
```

## 🌐 API Integration

### Making API Calls
```dart
final photoRepository = PhotoRepository();
final response = await photoRepository.fetchPhotos(limit: 30);

if (response.success) {
  final photos = response.data!;
  // Use your data
}
```

### Changing API Endpoint
Edit `lib/core/services/api_service.dart`:
```dart
final String baseUrl = 'https://your-api.com';
```

### Creating New Repository
1. Create model in `lib/core/models/`
2. Create repository in `lib/core/repositories/`
3. Use ApiService methods: `get()`, `post()`, `put()`, `delete()`

## 🖼️ Using Custom Image Widget

### Network Image
```dart
CustomImageWidget(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: 12,
  fit: BoxFit.cover,
)
```

### Asset Image
```dart
CustomImageWidget(
  imageUrl: 'assets/images/my_image.png',
  isAsset: true,
  width: 200,
  height: 200,
)
```

### Circular Image (Avatar)
```dart
CircularImageWidget(
  imageUrl: 'https://example.com/avatar.jpg',
  radius: 50,
)
```

## 🔘 Using Custom Buttons

### Elevated Button
```dart
CustomButton(
  text: 'Click Me',
  onPressed: () {
    // Handle press
  },
  icon: Icons.check,
  isLoading: false,
)
```

### Outlined Button
```dart
CustomButton(
  text: 'Click Me',
  onPressed: () {},
  isOutlined: true,
)
```

### Icon Button
```dart
CustomIconButton(
  icon: Icons.settings,
  onPressed: () {},
  tooltip: 'Settings',
)
```

## ⏳ Loading Indicators

### Standard Loading
```dart
LoadingIndicator(
  message: 'Loading...',
)
```

### Overlay Loading
```dart
OverlayLoadingIndicator(
  isLoading: _isLoading,
  message: 'Please wait...',
  child: YourContentWidget(),
)
```

### Small Inline Loading
```dart
SmallLoadingIndicator()
```

## 💾 Cache Management

### Cache API Response
```dart
await CacheService.cacheApiResponse(
  'cache_key',
  data,
  duration: 24, // hours
);
```

### Get Cached Data
```dart
final cachedData = await CacheService.getCachedApiResponse('cache_key');
```

### Clear Cache
```dart
// Clear all cache
await CacheService.clearAllCache();

// Clear API cache only
await CacheService.clearApiCache();

// Clear specific entry
await CacheService.clearCacheEntry('cache_key');
```

### SharedPreferences
```dart
// Save
await CacheService.saveString('key', 'value');
await CacheService.saveBool('key', true);
await CacheService.saveInt('key', 123);

// Get
final value = await CacheService.getString('key');
```

## 📱 Responsive Sizing

Using flutter_screenutil for responsive design:

```dart
// Width
width: 200.w

// Height
height: 100.h

// Font size
fontSize: 16.sp

// Radius
borderRadius: BorderRadius.circular(12.r)

// Padding/Margin
padding: EdgeInsets.all(16.w)
padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
```

## 🎯 Navigation

### Push to new screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NewScreen(),
  ),
);
```

### Replace current screen
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => NewScreen(),
  ),
);
```

### Pop back
```dart
Navigator.pop(context);
```

### Pop with result
```dart
Navigator.pop(context, result);
```

## 🎨 Accessing Theme Colors

```dart
// Primary color
Theme.of(context).primaryColor

// Background color
Theme.of(context).scaffoldBackgroundColor

// Text color
Theme.of(context).textTheme.bodyLarge?.color

// Error color
Theme.of(context).colorScheme.error
```

## 📝 Text Styles

```dart
// Display (largest)
Text('Hello', style: Theme.of(context).textTheme.displayLarge)

// Headline
Text('Hello', style: Theme.of(context).textTheme.headlineMedium)

// Title
Text('Hello', style: Theme.of(context).textTheme.titleMedium)

// Body
Text('Hello', style: Theme.of(context).textTheme.bodyMedium)

// Label
Text('Hello', style: Theme.of(context).textTheme.labelMedium)
```

## 🐛 Debugging

### Print to console
```dart
print('Debug message');
debugPrint('Debug message'); // Safer for large outputs
```

### Check variable
```dart
debugPrint('Value: $variable');
```

### Flutter DevTools
```bash
# Activate DevTools
flutter pub global activate devtools

# Run DevTools
flutter pub global run devtools

# Or while app is running, press 'p' in terminal
```

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run specific test
```bash
flutter test test/widget_test.dart
```

### Test coverage
```bash
flutter test --coverage
```

## 🚀 Building

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Useful Flutter Commands

```bash
# Check installation
flutter doctor

# List devices
flutter devices

# Run on specific device
flutter run -d device_id

# Clean build
flutter clean

# Get packages
flutter pub get

# Upgrade packages
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
flutter format .

# Show outdated packages
flutter pub outdated
```

## 🎭 State Management

### Using Provider

#### Create Provider
Already set up in `lib/core/providers/theme_provider.dart` as example.

#### Access Provider
```dart
// With rebuild on change
final provider = Provider.of<ThemeProvider>(context);

// Without rebuild
final provider = Provider.of<ThemeProvider>(context, listen: false);

// Using Consumer
Consumer<ThemeProvider>(
  builder: (context, provider, child) {
    return Text(provider.themeModeName);
  },
)
```

## 📦 Adding New Packages

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  package_name: ^version
```

2. Get packages:
```bash
flutter pub get
```

3. Import in Dart file:
```dart
import 'package:package_name/package_name.dart';
```

## 🎨 Custom Theme Example

Want to add a 4th theme? Edit `lib/core/providers/theme_provider.dart`:

```dart
enum AppThemeMode {
  light,
  dark,
  custom,
  yourNewTheme, // Add here
}
```

Then add theme configuration in `lib/core/themes/app_theme.dart`.

## 💡 Pro Tips

1. **Hot Reload**: Press `r` while app is running (faster)
2. **Hot Restart**: Press `R` while app is running (full restart)
3. **Save Images**: Use PNG for transparency, WebP for smaller size
4. **Use Const**: Use `const` for widgets that don't change
5. **Extract Widgets**: Break large widgets into smaller ones
6. **Named Parameters**: Use named parameters for clarity
7. **Null Safety**: Always handle null cases
8. **Async/Await**: Use for asynchronous operations
9. **Cache Wisely**: Cache API responses but allow manual refresh
10. **Test on Real Devices**: Test on both iOS and Android

## 🆘 Common Issues

### Issue: Hot reload not working
**Fix**: Press `R` for hot restart or restart the app

### Issue: Package conflicts
**Fix**: 
```bash
flutter clean
flutter pub get
```

### Issue: Gradle build failed (Android)
**Fix**: Check `android/app/build.gradle` for correct SDK versions

### Issue: Pods install failed (iOS)
**Fix**:
```bash
cd ios
pod install
cd ..
```

### Issue: Image not showing
**Fix**: Make sure path in `pubspec.yaml` matches actual file location

## 📚 Learn More

- **Flutter Docs**: https://docs.flutter.dev/
- **Dart Docs**: https://dart.dev/guides
- **Pub.dev**: https://pub.dev/
- **Flutter Cookbook**: https://docs.flutter.dev/cookbook
- **API Reference**: https://api.flutter.dev/

---

**Need more help?** Check the detailed [README.md](README.md) and [SETUP.md](SETUP.md)
