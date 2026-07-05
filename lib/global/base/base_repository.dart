import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:portfolio/global/apiutils/api_base_helper.dart';
import 'package:portfolio/global/apiutils/api_response.dart';
import 'package:portfolio/global/utils/app_utils.dart';

abstract class BaseRepository {
  ApiBaseHelper get api => apiHelper;

  @protected
  Future<Result<T>> get<T>({
    required String url,
    required T Function(dynamic data) parser,
    Map<String, dynamic>? params,
    String? dataKey,
  }) async {
    return _handleResponse(api.get(url, params: params), parser, dataKey);
  }

  @protected
  Future<Result<List<T>>> getList<T>({
    required String url,
    required T Function(dynamic item) itemParser,
    Map<String, dynamic>? params,
    String? listKey,
  }) async {
    return _handleListResponse(api.get(url, params: params), itemParser, listKey);
  }

  @protected
  Future<Result<T>> post<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    String? dataKey,
  }) async {
    return _handleResponse(api.post(url, data: data), parser, dataKey);
  }

  @protected
  Future<Result<T>> put<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    String? dataKey,
  }) async {
    return _handleResponse(api.put(url, data: data), parser, dataKey);
  }

  @protected
  Future<Result<T>> delete<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    String? dataKey,
  }) async {
    return _handleResponse(api.delete(url, data: data), parser, dataKey);
  }

  @protected
  Future<Result<Response>> raw(Future<Response> apiCall) async {
    try {
      final response = await apiCall;
      if (response.statusCode == ApiResponseCode.success) {
        return Result.success(response);
      }
      return Result.failure(_getErrorMessage(response));
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  @protected
  Future<Result<T>> execute<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @protected
  Result<T> executeSync<T>(T Function() action) {
    try {
      return Result.success(action());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<T>> _handleResponse<T>(
      Future<Response> apiCall, T Function(dynamic data) parser, String? dataKey) async {
    try {
      final response = await apiCall;
      if (response.statusCode == ApiResponseCode.success) {
        final data = dataKey != null ? response.data[dataKey] : response.data;
        return Result.success(parser(data));
      }
      return Result.failure(_getErrorMessage(response));
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  Future<Result<List<T>>> _handleListResponse<T>(
      Future<Response> apiCall, T Function(dynamic item) itemParser, String? listKey) async {
    try {
      final response = await apiCall;
      if (response.statusCode == ApiResponseCode.success) {
        final data = listKey != null ? response.data[listKey] : response.data;
        if (data is List) return Result.success(data.map((e) => itemParser(e)).toList());
        return Result.failure('Expected list data');
      }
      return Result.failure(_getErrorMessage(response));
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  String _getErrorMessage(Response response) {
    if (response.statusCode == ApiResponseCode.noInternet) return 'No internet connection';
    return response.statusMessage ?? 'Request failed';
  }

  String _handleException(Object e) {
    if (e is DioException) {
      final apiError = _extractApiError(e.response);
      if (apiError != null) return apiError;
      switch (e.type) {
        case DioExceptionType.connectionTimeout: return 'Connection timeout. Please try again.';
        case DioExceptionType.sendTimeout: return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout: return 'Server took too long to respond.';
        case DioExceptionType.connectionError: return 'No internet connection.';
        case DioExceptionType.cancel: return 'Request was cancelled.';
        case DioExceptionType.badCertificate: return 'Security certificate error.';
        case DioExceptionType.badResponse:
          return 'Error ${e.response?.statusCode ?? ''}: ${e.response?.statusMessage ?? 'Request failed'}';
        case DioExceptionType.unknown:
          if (e.message?.contains('SocketException') == true) return 'No internet connection.';
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  String? _extractApiError(Response? response) {
    if (response?.data == null) return null;
    final data = response!.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String? ??
          data['errorMessage'] as String?;
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }

  @protected
  void log(String message) {
    if (kDebugMode) printLog(runtimeType.toString(), message);
  }
}

mixin Cacheable on BaseRepository {
  final Map<String, _CacheEntry> _cache = {};

  Future<Result<T>> cached<T>({
    required String key,
    required Future<Result<T>> Function() fetcher,
    Duration duration = const Duration(minutes: 5),
  }) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) return Result.success(entry.data as T);
    final result = await fetcher();
    if (result.isSuccess) _cache[key] = _CacheEntry(result.dataOrThrow, DateTime.now().add(duration));
    return result;
  }

  void invalidate(String key) => _cache.remove(key);
  void invalidateAll() => _cache.clear();
  bool isCached(String key) {
    final entry = _cache[key];
    return entry != null && !entry.isExpired;
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;
  _CacheEntry(this.data, this.expiry);
  bool get isExpired => DateTime.now().isAfter(expiry);
}
