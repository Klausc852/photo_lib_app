import 'package:flutter/material.dart';

import '../core/models/photo_model.dart';
import 'custom_image_widget.dart';

/// Photo Card Widget - Displays a single photo card
class PhotoCardWidget extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback onTap;

  const PhotoCardWidget({
    super.key,
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo image
            Expanded(
              child: CustomImageWidget(
                imageUrl: photo.url,
                width: double.infinity,
                borderRadius: 12,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Location: ${photo.location}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
