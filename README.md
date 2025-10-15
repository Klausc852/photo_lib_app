# Flutter Base App Template

A comprehensive Flutter app template built with Dart 3 and Flutter 3 SDK, following best practices and providing a solid foundation for scalable mobile applications.

## Features

### 🎨 Theme Management
- **Light Theme**: Clean white background with dark text
- **Dark Theme**: Easy on eyes with black background and light text
- **Custom Theme**: Unique blue and green accent colors
- Easy theme switching using Provider pattern
- Persistent theme selection using SharedPreferences
- Smooth theme transitions

### 📱 UI/UX Features
- **Responsive Design**: Adapts to different screen sizes using flutter_screenutil
- **Scalable Fonts**: Font sizes scale based on screen width (375px design base)
- **Safe Area Handling**: Proper handling of notches and system bars
- **Material Design 3**: Modern UI components with Material 3
- **Custom Widgets**: Reusable button, image, and loading components
- **Google Fonts**: Clean Roboto font throughout the app

### 🖼️ Image Handling
- **Custom Image Widget**: Unified component for network and asset images
- **Lazy Loading**: Images load as they appear on screen
- **Caching**: Automatic image caching with cached_network_image
- **Placeholder**: Shimmer effect while loading
- **Error Handling**: Graceful fallback for failed image loads

### 🌐 API Integration
- **Dio HTTP Client**: Robust HTTP client with interceptors
- **Repository Pattern**: Clean separation of data layer
- **Error Handling**: Comprehensive error handling with retries
- **Retry Logic**: Automatic retry on network failures (up to 3 attempts)
- **Connectivity Check**: Internet connection verification
- **Response Caching**: Hive-based caching for API responses

### 💾 Cache Management
- **Hive Database**: Fast NoSQL database for complex data
- **SharedPreferences**: Simple key-value storage
- **API Cache**: 24-hour default cache duration
- **Manual Cache Control**: Clear cache from settings
- **Image Cache**: Automatic image caching

### 🎬 Splash Screen
- **Animated Entry**: Fade and scale animations
- **Auto Navigation**: Automatic navigation after 3 seconds
- **Skip Option**: Tap to skip to main screen
- **Loading Indicator**: Visual feedback during initialization

### 📦 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core app functionality
│   ├── models/                        # Data models
│   │   └── photo_model.dart
│   ├── providers/                     # State management
│   │   └── theme_provider.dart
│   ├── repositories/                  # Data repositories
│   │   └── photo_repository.dart
│   ├── services/                      # Services
│   │   ├── api_service.dart          # HTTP client
│   │   └── cache_service.dart        # Cache management
│   └── themes/                        # Theme configurations
│       ├── app_colors.dart
│       └── app_theme.dart
├── screens/                           # App screens
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── main_screen/
│   │   └── main_screen.dart
│   └── settings/
│       └── settings_screen.dart
└── widgets/                           # Reusable widgets
    ├── custom_button.dart
    ├── custom_image_widget.dart
    └── loading_indicator.dart
```

## Dependencies

### Core
- `flutter_screenutil`: Responsive UI design
- `provider`: State management
- `google_fonts`: Custom fonts

### Networking & Cache
- `dio`: HTTP client
- `hive`: NoSQL database
- `hive_flutter`: Hive Flutter integration
- `shared_preferences`: Simple key-value storage
- `cached_network_image`: Image caching
- `connectivity_plus`: Network connectivity

### UI & Animations
- `lottie`: Animation files (optional)
- `shimmer`: Loading placeholder effects

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. **Clone or copy this project structure**

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run build_runner (for Hive):**
```bash
flutter pub run build_runner build
```

4. **Run the app:**
```bash
flutter run
```

## Usage

### Theme Management

Access the theme provider anywhere in the app:

```dart
// Get current theme
final themeProvider = Provider.of<ThemeProvider>(context);

// Change theme
themeProvider.setThemeMode(AppThemeMode.dark);

// Toggle theme
themeProvider.toggleTheme();
```

### API Calls

Use the repository pattern for API calls:

```dart
final photoRepository = PhotoRepository();
final response = await photoRepository.fetchPhotos(limit: 30);

if (response.success) {
  final photos = response.data!;
  // Use photos
}
```

### Image Widget

Use the custom image widget for both network and asset images:

```dart
// Network image with caching
CustomImageWidget(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: 12,
)

// Asset image
CustomImageWidget(
  imageUrl: 'assets/images/logo.png',
  isAsset: true,
  width: 100,
  height: 100,
)
```

### Cache Management

Manage cache programmatically:

```dart
// Cache API response
await CacheService.cacheApiResponse('key', data, duration: 24);

// Get cached data
final cachedData = await CacheService.getCachedApiResponse('key');

// Clear cache
await CacheService.clearAllCache();
```

## Customization

### Colors

Edit `lib/core/themes/app_colors.dart` to customize colors:

```dart
static const Color primaryLight = Color(0xFF2196F3); // Your color
```

### Fonts

Change fonts in `lib/core/themes/app_theme.dart`:

```dart
textTheme: _buildTextTheme(textColor),
// Uses Google Fonts - customize in _buildTextTheme method
```

### API Endpoint

Change the base URL in `lib/core/services/api_service.dart`:

```dart
final String baseUrl = 'https://your-api.com';
```

### Design Size

Adjust the design size for screen scaling in `lib/main.dart`:

```dart
designSize: const Size(375, 812), // Your design dimensions
```

## Best Practices Implemented

✅ **Clean Architecture**: Separation of concerns with layers  
✅ **Repository Pattern**: Clean data layer abstraction  
✅ **Provider Pattern**: Efficient state management  
✅ **Error Handling**: Comprehensive error handling throughout  
✅ **Caching Strategy**: Multi-level caching for performance  
✅ **Responsive Design**: Adapts to all screen sizes  
✅ **Safe Area**: Proper handling of device notches/bars  
✅ **Loading States**: Visual feedback for all async operations  
✅ **Code Comments**: Well-documented code  
✅ **Widget Reusability**: Custom reusable components  

## API Reference

This template uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) for demo purposes. Replace with your own API:

- Photos endpoint: `https://jsonplaceholder.typicode.com/photos`

## Assets

Add your assets to the respective folders:

- `assets/images/` - General images
- `assets/animations/` - Lottie animation files
- `assets/logo/` - App logo and branding

## Testing

Run tests with:

```bash
flutter test
```

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Performance Optimization

- Images are cached automatically
- API responses are cached for 24 hours
- Lazy loading for grid views
- Optimized widget rebuilds with Provider
- Efficient state management

## Troubleshooting

### Common Issues

1. **Dependencies not installed**
   ```bash
   flutter pub get
   ```

2. **Build errors**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Font issues**
   - Fonts are loaded automatically via google_fonts package
   - Internet connection required for first load

## Contributing

This is a template project. Feel free to:
- Customize for your needs
- Add new features
- Improve existing code
- Share improvements

## License

This template is provided as-is for use in any project.

## Support

For Flutter-related issues, visit:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Community](https://flutter.dev/community)

## Changelog

### Version 1.0.0
- Initial template release
- Complete theme management
- API integration with caching
- Custom widgets library
- Settings screen
- Splash screen with animations

---

**Built with ❤️ using Flutter & Dart**
