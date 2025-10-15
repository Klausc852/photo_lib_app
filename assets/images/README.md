# Images Folder

Place your general image assets in this folder.

## Supported Formats:
- PNG
- JPG/JPEG
- WebP
- GIF

## Usage in Code:

```dart
Image.asset('assets/images/your_image.png')
```

Or use the CustomImageWidget:

```dart
CustomImageWidget(
  imageUrl: 'assets/images/your_image.png',
  isAsset: true,
  width: 200,
  height: 200,
  borderRadius: 12,
)
```
