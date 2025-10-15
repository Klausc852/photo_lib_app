import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/models/photo_model.dart';
import 'photo_card_widget.dart';

/// Photo Grid Widget - Displays a grid of photos with pagination
class PhotoGridWidget extends StatelessWidget {
  final List<PhotoModel> photos;
  final ScrollController scrollController;
  final bool hasMorePhotos;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Function(PhotoModel) onPhotoTap;

  const PhotoGridWidget({
    super.key,
    required this.photos,
    required this.scrollController,
    required this.hasMorePhotos,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Photo grid
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PhotoCardWidget(
                photo: photos[index],
                onTap: () => onPhotoTap(photos[index]),
              ),
              childCount: photos.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.w,
              childAspectRatio: 1,
            ),
          ),
        ),

        // Load more button or loading indicator
        if (hasMorePhotos || isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: isLoadingMore
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: ElevatedButton(
                        onPressed: onLoadMore,
                        child: const Text('Load More'),
                      ),
                    ),
            ),
          ),
      ],
    );
  }

  /// Get cross axis count based on device type and orientation
  int _getCrossAxisCount(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    if (isTablet) {
      // Tablet: 2 items in portrait, 4 items in landscape
      return isPortrait ? 2 : 4;
    } else {
      // Mobile: Always 2 items (vertical layout regardless of orientation)
      return 2;
    }
  }
}
