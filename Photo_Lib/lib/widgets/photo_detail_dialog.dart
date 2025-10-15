import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/photo_model.dart';
import 'custom_image_widget.dart';

/// Photo Detail Dialog Widget - Shows detailed view of a photo
class PhotoDetailDialog extends StatelessWidget {
  final PhotoModel photo;

  const PhotoDetailDialog({
    super.key,
    required this.photo,
  });

  /// Show photo detail dialog
  static void show(BuildContext context, PhotoModel photo) {
    showDialog(
      context: context,
      builder: (context) => PhotoDetailDialog(photo: photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Full size image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CustomImageWidget(
              imageUrl: photo.url,
              width: double.infinity,
              height: 300.h,
              fit: BoxFit.cover,
            ),
          ),

          // Photo details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Location: ${photo.location}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Creator: ${photo.createdBy}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
