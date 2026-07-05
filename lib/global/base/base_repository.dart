import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:portfolio/global/apiutils/api_base_helper.dart';
import 'package:portfolio/global/apiutils/api_response.dart';
import 'package:portfolio/global/utils/app_utils.dart';

import 'package:portfolio/model/api_body.dart';

abstract class BaseRepository {
  ApiBaseHelper get api => apiHelper;

  @protected
  Future<Result<T>> get<T>({
    required String url,
    required T Function(dynamic data) parser,
    Map<String, dynamic>? params,
  }) async {
    return _handleResponse(api.get(url, params: params), parser);
  }

  @protected
  Future<Result<List<T>>> getList<T>({
    required String url,
    required T Function(dynamic item) itemParser,
    Map<String, dynamic>? params,
  }) async {
    return _handleListResponse(api.get(url, params: params), itemParser);
  }

  @protected
  Future<Result<List<T>>> postList<T>({
    required String url,
    required T Function(dynamic item) itemParser,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _handleListResponse(
      api.post(url, data: _encodeBody(data), params: params),
      itemParser,
    );
  }

  @protected
  Future<Result<T>> post<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _handleResponse(api.post(url, data: _encodeBody(data), params: params), parser);
  }

  @protected
  Future<Result<T>> put<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _handleResponse(api.put(url, data: _encodeBody(data), params: params), parser);
  }

  @protected
  Future<Result<T>> delete<T>({
    required String url,
    required T Function(dynamic data) parser,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _handleResponse(api.delete(url, data: _encodeBody(data), params: params), parser);
  }

  /// Action endpoints that return envelope with empty `data: {}` on success.
  @protected
  Future<Result<void>> postAction({
    required String url,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    final result = await _handleResponse<dynamic>(
      api.post(url, data: _encodeBody(data), params: params),
      (d) => d,
    );
    return result.fold(
      (_) => Result.success(null),
      Result.failure,
    );
  }

  @protected
  Future<Result<void>> deleteAction({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    final result = await _handleResponse<dynamic>(
      api.delete(url, params: params),
      (d) => d,
    );
    return result.fold(
      (_) => Result.success(null),
      Result.failure,
    );
  }

  @protected
  Future<Result<Response>> raw(Future<Response> apiCall) async {
    try {
      final response = await apiCall;
      if (_isSuccessStatus(response.statusCode)) {
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
      Future<Response> apiCall, T Function(dynamic data) parser) async {
    try {
      final response = await apiCall;
      if (!_isSuccessStatus(response.statusCode)) {
        return Result.failure(_extractEnvelopeMessage(response.data) ?? _getErrorMessage(response));
      }
      return _parseEnvelope(response.data, parser);
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  Future<Result<List<T>>> _handleListResponse<T>(
      Future<Response> apiCall, T Function(dynamic item) itemParser) async {
    try {
      final response = await apiCall;
      if (!_isSuccessStatus(response.statusCode)) {
        return Result.failure(_extractEnvelopeMessage(response.data) ?? _getErrorMessage(response));
      }
      final envelope = _validateEnvelope(response.data);
      if (envelope.isFailure) return Result.failure(envelope.message);
      final items = _extractList(envelope.data);
      if (items != null) {
        return Result.success(items.map((e) => itemParser(e as dynamic)).toList());
      }
      return Result.failure(envelope.message.isNotEmpty ? envelope.message : 'Expected list data');
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  Result<T> _parseEnvelope<T>(dynamic raw, T Function(dynamic data) parser) {
    final envelope = _validateEnvelope(raw);
    if (envelope.isFailure) return Result.failure(envelope.message);
    try {
      return Result.success(parser(envelope.data));
    } catch (e) {
      return Result.failure('Failed to parse response data');
    }
  }

  ({bool isFailure, String message, dynamic data}) _validateEnvelope(dynamic raw) {
    if (raw is! Map) {
      return (isFailure: true, message: 'Invalid response format', data: null);
    }
    final map = Map<String, dynamic>.from(raw);
    final message = (map['message'] as String?)?.trim() ?? '';
    final success = map['success'] == true;
    final hasDataKey = map.containsKey('data');
    final data = hasDataKey ? map['data'] : null;

    if (!success) {
      return (
        isFailure: true,
        message: message.isNotEmpty ? message : 'Request failed',
        data: null,
      );
    }
    if (!hasDataKey || data == null) {
      return (
        isFailure: true,
        message: message.isNotEmpty ? message : 'No data available',
        data: null,
      );
    }
    if (data is! Map) {
      return (
        isFailure: true,
        message: 'Invalid response format',
        data: null,
      );
    }
    return (isFailure: false, message: message, data: Map<String, dynamic>.from(data));
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is Map) {
      final items = data['items'];
      if (items is List) return items;
    }
    return null;
  }

  String? _extractEnvelopeMessage(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final message = (raw['message'] as String?)?.trim();
      if (message != null && message.isNotEmpty) return message;
    }
    return _extractApiErrorFromData(raw);
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
        case DioExceptionType.transformTimeout:
          return 'Response processing timeout. Please try again.';
        case DioExceptionType.unknown:
          if (e.message?.contains('SocketException') == true) return 'No internet connection.';
          return 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  String? _extractApiError(Response? response) {
    return _extractEnvelopeMessage(response?.data) ?? _extractApiErrorFromData(response?.data);
  }

  String? _extractApiErrorFromData(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String? ??
          data['errorMessage'] as String? ??
          (data['detail'] is String ? data['detail'] as String : null);
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }

  bool _isSuccessStatus(int? code) =>
      code == ApiResponseCode.success || code == ApiResponseCode.created;

  dynamic _encodeBody(dynamic data) {
    if (data is ApiBody) return data.toJson();
    return data;
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
