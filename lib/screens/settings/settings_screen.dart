import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_lib_app/core/services/environment_service.dart';
import 'package:provider/provider.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/services/cache_service.dart';
import '../../widgets/custom_button.dart';

/// Settings Screen
/// Allows users to configure app settings including theme selection
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isClearing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // AppBar
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Body
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Theme Section
            _buildSectionTitle('Theme'),
            SizedBox(height: 12.h),
            _buildThemeSelector(),

            SizedBox(height: 32.h),

            // Cache Section
            _buildSectionTitle('Cache Management'),
            SizedBox(height: 12.h),
            _buildCacheManagement(),

            SizedBox(height: 32.h),

            // About Section
            _buildSectionTitle('About'),
            SizedBox(height: 12.h),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  /// Build section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// Build theme selector
  Widget _buildThemeSelector() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16.h),

                // Light Theme Option
                _buildThemeOption(
                  title: 'Light',
                  description: 'Bright and clean interface',
                  icon: Icons.light_mode,
                  isSelected: themeProvider.appThemeMode == AppThemeMode.light,
                  onTap: () => themeProvider.setThemeMode(AppThemeMode.light),
                ),

                SizedBox(height: 12.h),

                // Dark Theme Option
                _buildThemeOption(
                  title: 'Dark',
                  description: 'Easy on the eyes in low light',
                  icon: Icons.dark_mode,
                  isSelected: themeProvider.appThemeMode == AppThemeMode.dark,
                  onTap: () => themeProvider.setThemeMode(AppThemeMode.dark),
                ),

                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build theme option tile
  Widget _buildThemeOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24.sp,
              ),
            ),

            SizedBox(width: 12.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Checkmark
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  /// Build cache management section
  Widget _buildCacheManagement() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clear Cache',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            Text(
              'Remove cached images and API data to free up space.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: 'Clear All Cache',
              onPressed: _clearCache,
              isLoading: _isClearing,
              icon: Icons.delete_sweep,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  /// Build about section
  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            _buildInfoRow('Version', EnvironmentService.appVersion),
          ],
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  /// Clear cache
  Future<void> _clearCache() async {
    setState(() => _isClearing = true);

    try {
      await CacheService.clearAllCache();

      if (mounted) {
        setState(() => _isClearing = false);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cache cleared successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isClearing = false);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cache: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
