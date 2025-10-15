import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/models/photo_model.dart';
import '../../core/repositories/photo_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/photo_grid_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/photo_detail_dialog.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<PhotoModel> _allPhotos = []; // All photos from API
  List<PhotoModel> _filteredPhotos = []; // Filtered photos based on search
  List<PhotoModel> _displayedPhotos = []; // Currently displayed photos
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  bool _isFromCache = false;
  int _currentPage = 1;
  bool _toTop = false;
  static const int _photosPerPage = 20;
  bool _hasMorePhotos = true;

  // Filter and sort state
  String _searchQuery = '';
  bool _sortByTimeDescending =
      true; // true = newest first, false = oldest first

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load photos from API (fetch all photos once)
  Future<void> _loadPhotos({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
      if (refresh) {
        _allPhotos.clear();
        _displayedPhotos.clear();
        _currentPage = 1;
        _toTop = false;
        _hasMorePhotos = true;
      }
    });

    try {
      // Only fetch from API if we don't have photos or refreshing
      if (_allPhotos.isEmpty || refresh) {
        final response = await _photoRepository.fetchPhotos();

        if (mounted) {
          if (response.success && response.data != null) {
            _allPhotos = response.data!;
            _isFromCache = response.fromCache;
            _applyFiltersAndSort();
          } else {
            setState(() {
              _error = response.error ?? 'Failed to load photos';
              _isLoading = false;
            });
            return;
          }
        }
      } else {
        // Just update the displayed photos from cached data
        _applyFiltersAndSort();
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

  /// Apply filters and sorting, then load current page
  void _applyFiltersAndSort() {
    // Apply search filter
    if (_searchQuery.isEmpty) {
      _filteredPhotos = List.from(_allPhotos);
    } else {
      _filteredPhotos = _allPhotos.where((photo) {
        final query = _searchQuery.toLowerCase();
        return photo.description.toLowerCase().contains(query) ||
            photo.location.toLowerCase().contains(query) ||
            photo.createdBy.toLowerCase().contains(query);
      }).toList();
    }
    if (_filteredPhotos.length <= 0) {
    } else {
      // Apply sorting
      _filteredPhotos.sort((a, b) {
        if (_sortByTimeDescending) {
          return b.createdAt.compareTo(a.createdAt); // Newest first
        } else {
          return a.createdAt.compareTo(b.createdAt); // Oldest first
        }
      });
    }

    // Reset pagination and load first page
    _currentPage = 1;
    _loadCurrentPage();
  }

  /// Filter photos by search query
  void _filterPhotos(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  /// Toggle sort order
  void _toggleSortOrder() {
    setState(() {
      _sortByTimeDescending = !_sortByTimeDescending;
    });
    _applyFiltersAndSort();
  }

  /// Load current page from filtered photos
  void _loadCurrentPage() {
    final startIndex = (_currentPage - 1) * _photosPerPage;
    final endIndex = startIndex + _photosPerPage;

    setState(() {
      if (startIndex < _filteredPhotos.length) {
        final pagePhotos =
            _filteredPhotos.skip(startIndex).take(_photosPerPage).toList();

        if (_currentPage == 1) {
          _displayedPhotos = pagePhotos;
        } else {
          _displayedPhotos.addAll(pagePhotos);
        }

        _hasMorePhotos = endIndex < _filteredPhotos.length;
      } else {
        _hasMorePhotos = false;
      }
      _isLoading = false;
    });
  }

  /// Load more photos (next page from cached data)
  Future<void> _loadMorePhotos() async {
    if (_isLoadingMore || !_hasMorePhotos) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    _toTop = true;

    // Add a small delay to simulate loading for better UX
    await Future.delayed(const Duration(milliseconds: 300));

    final startIndex = (_currentPage - 1) * _photosPerPage;
    final endIndex = startIndex + _photosPerPage;

    if (mounted) {
      setState(() {
        if (startIndex < _filteredPhotos.length) {
          final pagePhotos =
              _filteredPhotos.skip(startIndex).take(_photosPerPage).toList();
          _displayedPhotos.addAll(pagePhotos);
          _hasMorePhotos = endIndex < _filteredPhotos.length;
        } else {
          _hasMorePhotos = false;
        }
        _isLoadingMore = false;
      });
    }
  }

  /// Scroll to top of the list
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _toTop = false;
    });
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
          onRefresh: () => _loadPhotos(refresh: true),
          child: Column(
            children: [
              // Search bar
              _buildSearchBar(),
              // Main content
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _toTop ? _scrollToTop : () => _loadPhotos(refresh: true),
        tooltip: _toTop ? 'Scroll to Top' : 'Refresh',
        child: Icon(_toTop ? Icons.keyboard_arrow_up : Icons.refresh),
      ),
    );
  }

  /// Build body based on state
  Widget _buildBody() {
    // Loading state
    if (_isLoading && _displayedPhotos.isEmpty) {
      return const LoadingIndicator(
        message: 'Loading photos...',
      );
    }

    // Error state
    if (_error != null && _displayedPhotos.isEmpty) {
      return _buildErrorWidget();
    }

    // Success state with data
    if (_displayedPhotos.isNotEmpty && _filteredPhotos.isNotEmpty) {
      return Column(
        children: [
          // Cache indicator
          if (_isFromCache) _buildCacheIndicator(),

          // Total photos indicator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Text(
              'Total photos: ${_filteredPhotos.length} (Showing: ${_displayedPhotos.length})',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          // Photo grid
          Expanded(
            child: PhotoGridWidget(
              photos: _displayedPhotos,
              scrollController: _scrollController,
              hasMorePhotos: _hasMorePhotos,
              isLoadingMore: _isLoadingMore,
              onLoadMore: _loadMorePhotos,
              onPhotoTap: _showPhotoDetail,
            ),
          ),
        ],
      );
    }

    // No results from search filter
    if (_searchQuery.isNotEmpty &&
        _filteredPhotos.isEmpty &&
        _allPhotos.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No photos found',
        subtitle: 'No photos match your search for "$_searchQuery"',
        icon: Icons.search_off,
        onRetry: () {
          _searchController.clear();
          _filterPhotos('');
        },
        retryButtonText: 'Clear Search',
      );
    }

    // Empty state (no photos at all)
    return const EmptyStateWidget();
  }

  /// Build cache indicator
  Widget _buildCacheIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.amber,
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
              onPressed: () => _loadPhotos(refresh: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show photo detail dialog
  void _showPhotoDetail(PhotoModel photo) {
    PhotoDetailDialog.show(context, photo);
  }

  /// Build search bar widget
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by description, location, or creator...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPhotos('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: _filterPhotos,
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: IconButton(
              icon:
                  Icon(_sortByTimeDescending ? Icons.schedule : Icons.history),
              tooltip: _sortByTimeDescending ? 'Newest First' : 'Oldest First',
              onPressed: _toggleSortOrder,
            ),
          ),
        ],
      ),
    );
  }
}
