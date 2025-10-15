# Flutter Base App - Quick Reference Guide

## 🚀 Quick Start Commands

```bash
# First time setup (manual - no setup.sh script)
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
| Photo Grid Widget | `lib/widgets/photo_grid_widget.dart` |
| Photo Card Widget | `lib/widgets/photo_card_widget.dart` |
| Empty State Widget | `lib/widgets/empty_state_widget.dart` |
| Photo Detail Dialog | `lib/widgets/photo_detail_dialog.dart` |
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

## 📸 Using Photo Widgets

### Photo Grid
```dart
PhotoGridWidget(
  photos: photoList,
  scrollController: scrollController,
  hasMorePhotos: hasMore,
  isLoadingMore: isLoading,
  onLoadMore: () => loadMorePhotos(),
  onPhotoTap: (photo) => showPhotoDetail(photo),
)
```

### Photo Card
```dart
PhotoCardWidget(
  photo: photoModel,
  onTap: () => handlePhotoTap(),
)
```

### Photo Detail Dialog
```dart
PhotoDetailDialog.show(context, photoModel);
```

### Empty State Widget
```dart
EmptyStateWidget(
  title: 'No photos found',
  subtitle: 'Try searching for something else',
  icon: Icons.photo_library_outlined,
  onRetry: () => retry(),
  retryButtonText: 'Retry',
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

### Button with Icon
```dart
CustomButton(
  text: 'Save',
  onPressed: () {},
  icon: Icons.save,
  isLoading: false,
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

## 📱 Device Orientation

The app automatically handles orientation based on device type:

### Mobile Devices (Phones)
- **Locked to portrait orientation** - prevents rotation to landscape
- Provides consistent UI experience on smaller screens
- Grid always shows 2 columns

### Tablet Devices  
- **Supports all orientations** - can rotate freely
- Portrait: 2 columns in photo grid
- Landscape: 4 columns in photo grid
- Takes advantage of larger screen real estate

### Implementation
Orientation is controlled in `lib/main.dart` using `SystemChrome.setPreferredOrientations()` based on device detection.

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

## 🔍 Search and Filtering

The app includes smart search functionality:

### Search Features
- **Real-time filtering** as you type
- **Multi-field search** - searches description, location, and creator
- **No results state** - shows helpful message when search returns no matches
- **Clear search** - easy button to clear and return to all photos

### Search States
```dart
// When search returns no results
EmptyStateWidget(
  title: 'No photos found',
  subtitle: 'No photos match your search for "sunset"',
  icon: Icons.search_off,
  onRetry: () => clearSearch(),
  retryButtonText: 'Clear Search',
)
```

### Implementation
- Search controller: `TextEditingController _searchController`
- Filter method: `_filterPhotos(String query)`
- State management tracks: `_searchQuery`, `_filteredPhotos`, `_allPhotos`

## 🧩 Widget Architecture

The app follows a modular widget architecture for better maintainability:

### Extracted Widgets
- **PhotoGridWidget**: Handles photo grid display with pagination
- **PhotoCardWidget**: Individual photo card with tap handling  
- **EmptyStateWidget**: Flexible empty state with customizable content
- **PhotoDetailDialog**: Modal dialog for photo details
- **LoadingIndicator**: Consistent loading states throughout app

### Benefits
- **Reusability**: Widgets can be used in multiple screens
- **Testability**: Each widget can be tested independently  
- **Maintainability**: Changes to specific widgets are isolated
- **Cleaner Code**: Main screen focuses on business logic

### Usage Pattern
```dart
// In main screen, complex UI is simplified to:
PhotoGridWidget(
  photos: _displayedPhotos,
  scrollController: _scrollController,
  hasMorePhotos: _hasMorePhotos,
  isLoadingMore: _isLoadingMore,
  onLoadMore: _loadMorePhotos,
  onPhotoTap: _showPhotoDetail,
)
```

## ♿ Accessibility & Text Scaling

The app includes modern accessibility features:

### Text Scaling Support
- **Modern API**: Uses `textScaler` instead of deprecated `textScaleFactor`
- **Clamped Scaling**: Text scaling limited between 0.8x and 1.5x for optimal readability
- **Linear Scaling**: Maintains consistent scaling behavior

### Implementation
```dart
// In main.dart MaterialApp builder:
data: MediaQuery.of(context).copyWith(
  textScaler: TextScaler.linear(
    MediaQuery.of(context)
        .textScaler
        .scale(1.0)
        .clamp(0.8, 1.5),
  ),
),
```

This ensures the app remains usable for users with different accessibility needs while preventing UI breaking at extreme scale factors.

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
**Fix**: Check `android/app/build.gradle.kts` for correct SDK versions, ensure MainActivity.kt is properly configured

### Issue: MainActivity unresolved references
**Fix**: 
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

### Issue: Pods install failed (iOS)
**Fix**:
```bash
cd ios
pod install
cd ..
```

### Issue: Image not showing
**Fix**: Make sure path in `pubspec.yaml` matches actual file location

### Issue: Network images not loading on Android
**Fix**: Ensure internet permissions are added to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## 📱 Android Configuration

### Required Permissions
The app includes essential Android permissions:
- **INTERNET**: For fetching photos from API
- **ACCESS_NETWORK_STATE**: For checking connectivity

### MainActivity Setup
- Uses Flutter embedding v2
- Kotlin-based implementation
- Located at: `android/app/src/main/kotlin/app/example/photo_lib_app/MainActivity.kt`

### Build Configuration  
- **Gradle**: Uses Kotlin DSL (`build.gradle.kts`)
- **Minimum SDK**: Defined by Flutter
- **Target SDK**: Latest supported by Flutter
- **Namespace**: `app.example.photo_lib_app`

## 📚 Learn More

- **Flutter Docs**: https://docs.flutter.dev/
- **Dart Docs**: https://dart.dev/guides
- **Pub.dev**: https://pub.dev/
- **Flutter Cookbook**: https://docs.flutter.dev/cookbook
- **API Reference**: https://api.flutter.dev/

---

**Need more help?** Check the detailed [README.md](README.md) and [SETUP.md](SETUP.md)
