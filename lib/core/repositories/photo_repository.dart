import '../models/photo_model.dart';
import '../services/api_service.dart';

/// Repository for managing photo data
/// Implements repository pattern for clean separation of concerns
class PhotoRepository {
  final ApiService _apiService = ApiService();

  /// Fetch photos from API
  /// [limit] - Number of photos to fetch (default: fetch all)
  Future<ApiResponse<List<PhotoModel>>> fetchPhotos({int? limit}) async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        'photos',
        queryParameters: limit != null ? {'_limit': limit} : null,
        useCache: false,
        cacheDuration: 24, // Cache for 24 hours
      );

      if (!response.success) {
        return ApiResponse<List<PhotoModel>>(
          success: false,
          error: response.error,
          fromCache: response.fromCache,
        );
      }

      // Convert JSON to PhotoModel list
      final photos = (response.data as List<dynamic>)
          .map((json) => PhotoModel.fromJson(json as Map<dynamic, dynamic>))
          .toList();

      return ApiResponse<List<PhotoModel>>(
        success: true,
        data: photos,
        fromCache: response.fromCache,
      );
    } catch (e) {
      return ApiResponse<List<PhotoModel>>(
        success: false,
        error: 'Failed to parse photos: $e',
      );
    }
  }

  /// Fetch a single photo by ID
  Future<ApiResponse<PhotoModel>> fetchPhotoById(int id) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/photos/$id',
        useCache: true,
        cacheDuration: 24,
      );

      if (!response.success) {
        return ApiResponse<PhotoModel>(
          success: false,
          error: response.error,
          fromCache: response.fromCache,
        );
      }

      final photo = PhotoModel.fromJson(response.data as Map<String, dynamic>);

      return ApiResponse<PhotoModel>(
        success: true,
        data: photo,
        fromCache: response.fromCache,
      );
    } catch (e) {
      return ApiResponse<PhotoModel>(
        success: false,
        error: 'Failed to parse photo: $e',
      );
    }
  }
}
