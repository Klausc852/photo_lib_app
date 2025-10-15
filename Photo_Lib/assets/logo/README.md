# Assets Folder

Place your logo images in this folder.

## Recommended Files:
- `app_logo.png` - Main app logo (512x512 or larger)
- `app_icon.png` - App icon for various uses

## Usage in Code:

```dart
Image.asset('assets/logo/app_logo.png')
```

Or use the CustomImageWidget:

```dart
CustomImageWidget(
  imageUrl: 'assets/logo/app_logo.png',
  isAsset: true,
  width: 120,
  height: 120,
)
```
