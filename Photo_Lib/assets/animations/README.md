# Animations Folder

Place your Lottie animation files (.json) in this folder.

## Getting Animations:
- [LottieFiles](https://lottiefiles.com/) - Free and premium animations

## Usage in Code:

First, ensure you have the lottie package in pubspec.yaml (already included).

```dart
import 'package:lottie/lottie.dart';

// Use Lottie animation
Lottie.asset(
  'assets/animations/loading.json',
  width: 200,
  height: 200,
)
```

## Example Animations:
- `loading.json` - Loading animation
- `success.json` - Success animation
- `error.json` - Error animation
- `empty.json` - Empty state animation
