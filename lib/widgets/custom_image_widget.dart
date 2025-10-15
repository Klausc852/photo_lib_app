import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Custom Image Widget with lazy loading, caching, and error handling
/// Supports both network and asset images
class CustomImageWidget extends StatelessWidget {
  /// Image source URL (for network images) or path (for asset images)
  final String imageUrl;

  /// Whether the image is from assets or network
  final bool isAsset;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// BoxFit for the image
  final BoxFit fit;

  /// Border radius
  final double borderRadius;

  /// Custom placeholder widget
  final Widget? placeholder;

  /// Custom error widget
  final Widget? errorWidget;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.isAsset = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // For asset images
    if (isAsset) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        ),
      );
    }

    // For network images with caching
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        // Placeholder with shimmer effect
        placeholder: (context, url) {
          return placeholder ?? _buildShimmerPlaceholder();
        },

        // Error widget
        errorWidget: (context, url, error) {
          return errorWidget ?? _buildErrorWidget();
        },

        // Fade in animation
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  /// Build shimmer placeholder
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular image widget (for avatars, profiles, etc.)
class CircularImageWidget extends StatelessWidget {
  final String imageUrl;
  final bool isAsset;
  final double radius;
  final BoxFit fit;

  const CircularImageWidget({
    super.key,
    required this.imageUrl,
    this.isAsset = false,
    this.radius = 40,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImageWidget(
      imageUrl: imageUrl,
      isAsset: isAsset,
      width: radius * 2,
      height: radius * 2,
      fit: fit,
      borderRadius: radius,
    );
  }
}
