import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/models/photo_model.dart';
import '../../core/repositories/photo_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/custom_image_widget.dart';
import '../settings/settings_screen.dart';

/// Main Screen - Primary screen with photo grid
/// Demonstrates API fetching, caching, and image loading
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PhotoRepository _photoRepository = PhotoRepository();
  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  String? _error;
  bool _isFromCache = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  /// Load photos from API
  Future<void> _loadPhotos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _photoRepository.fetchPhotos(limit: 30);

      if (mounted) {
        if (response.success && response.data != null) {
          setState(() {
            _photos = response.data!;
            _isFromCache = response.fromCache;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = response.error ?? 'Failed to load photos';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'An error occurred: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // AppBar
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.themeIcon),
                tooltip: '${themeProvider.themeModeName} Theme',
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),

          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // Body
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPhotos,
          child: _buildBody(),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPhotos,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// Build body based on state
  Widget _buildBody() {
    // Loading state
    if (_isLoading && _photos.isEmpty) {
      return const LoadingIndicator(
        message: 'Loading photos...',
      );
    }

    // Error state
    if (_error != null && _photos.isEmpty) {
      return _buildErrorWidget();
    }

    // Success state with data
    if (_photos.isNotEmpty) {
      return Column(
        children: [
          // Cache indicator
          if (_isFromCache) _buildCacheIndicator(),

          // Photo grid
          Expanded(
            child: _buildPhotoGrid(),
          ),
        ],
      );
    }

    // Empty state
    return _buildEmptyWidget();
  }

  /// Build photo grid
  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        return _buildPhotoCard(_photos[index]);
      },
    );
  }

  /// Build photo card
  Widget _buildPhotoCard(PhotoModel photo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showPhotoDetail(photo),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo image
            Expanded(
              child: CustomImageWidget(
                imageUrl: photo.thumbnailUrl,
                width: double.infinity,
                borderRadius: 12,
                fit: BoxFit.cover,
              ),
            ),

            // Photo info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Album ${photo.albumId} • ID ${photo.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build cache indicator
  Widget _buildCacheIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.amber.withOpacity(0.2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 16.sp, color: Colors.amber[800]),
          SizedBox(width: 8.w),
          Text(
            'Showing cached data',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.amber[800],
                ),
          ),
        ],
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _error ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _loadPhotos,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty widget
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No photos available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  /// Show photo detail dialog
  void _showPhotoDetail(PhotoModel photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Full size image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                    photo.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Album ID: ${photo.albumId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Photo ID: ${photo.id}',
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
      ),
    );
  }
}
