import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'cache_service.dart';

/// API Service for handling all HTTP requests
/// Implements repository pattern with caching, error handling, and retries
class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _initializeDio();
  }

  late Dio _dio;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  /// Initialize Dio with configuration
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print(
              '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
          print('Error message: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Check internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Generic GET request with caching and retry logic
  /// [endpoint] - API endpoint
  /// [useCache] - Whether to use cached data
  /// [cacheDuration] - Cache duration in hours
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool useCache = true,
    int cacheDuration = CacheService.defaultCacheDuration,
  }) async {
    // Check cache first if enabled
    if (useCache) {
      final cachedData = await CacheService.getCachedApiResponse(endpoint);
      if (cachedData != null) {
        print('📦 Using cached data for: $endpoint');
        return ApiResponse<T>(
          success: true,
          data: cachedData as T,
          fromCache: true,
        );
      }
    }

    // Check internet connection
    if (!await hasInternetConnection()) {
      return ApiResponse<T>(
        success: false,
        error: 'No internet connection',
      );
    }

    // Make API request with retry logic
    return _executeWithRetry(() async {
      try {
        final response = await _dio.get(
          endpoint,
          queryParameters: queryParameters,
        );

        // Cache successful response
        if (useCache && response.statusCode == 200) {
          await CacheService.cacheApiResponse(
            endpoint,
            response.data,
            duration: cacheDuration,
          );
        }

        return ApiResponse<T>(
          success: true,
          data: response.data as T,
          statusCode: response.statusCode,
        );
      } on DioException catch (e) {
        return _handleDioError<T>(e);
      } catch (e) {
        return ApiResponse<T>(
          success: false,
          error: 'Unexpected error: $e',
        );
      }
    });
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await hasInternetConnection()) {
      return ApiResponse<T>(
        success: false,
        error: 'No internet connection',
      );
    }

    return _executeWithRetry(() async {
      try {
        final response = await _dio.post(
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );

        return ApiResponse<T>(
          success: true,
          data: response.data as T,
          statusCode: response.statusCode,
        );
      } on DioException catch (e) {
        return _handleDioError<T>(e);
      } catch (e) {
        return ApiResponse<T>(
          success: false,
          error: 'Unexpected error: $e',
        );
      }
    });
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await hasInternetConnection()) {
      return ApiResponse<T>(
        success: false,
        error: 'No internet connection',
      );
    }

    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>(
        success: true,
        data: response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await hasInternetConnection()) {
      return ApiResponse<T>(
        success: false,
        error: 'No internet connection',
      );
    }

    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>(
        success: true,
        data: response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        error: 'Unexpected error: $e',
      );
    }
  }

  /// Execute request with retry logic
  Future<ApiResponse<T>> _executeWithRetry<T>(
    Future<ApiResponse<T>> Function() request,
  ) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      attempts++;
      final response = await request();

      if (response.success || attempts >= maxRetries) {
        return response;
      }

      // Wait before retrying
      if (attempts < maxRetries) {
        print('⏳ Retrying... Attempt $attempts/$maxRetries');
        await Future.delayed(retryDelay);
      }
    }

    return ApiResponse<T>(
      success: false,
      error: 'Max retries exceeded',
    );
  }

  /// Handle Dio errors
  ApiResponse<T> _handleDioError<T>(DioException error) {
    String errorMessage;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Server error: ${error.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      default:
        errorMessage = 'Network error. Please check your connection.';
    }

    return ApiResponse<T>(
      success: false,
      error: errorMessage,
      statusCode: error.response?.statusCode,
    );
  }
}

/// API Response wrapper class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;
  final bool fromCache;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
    this.fromCache = false,
  });
}
