import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';

class ApiResponseCode {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
  static const int noInternet = 999;
}

class ApiBaseHelper {
  late Dio _dio;

  ApiBaseHelper(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstant.timeout,
      receiveTimeout: ApiConstant.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SPManager.getAccessToken();
        if (token.isNotEmpty) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle token refresh or logout
        }
        handler.next(error);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    try {
      if (!await _isInternetAvailable()) return _noInternetResponse(url);
      return await _dio.get(url, queryParameters: _sanitizeParams(params));
    } catch (e) {
      return _handleException(e, url);
    }
  }

  Future<Response> post(String url, {dynamic data, Map<String, dynamic>? params}) async {
    try {
      if (!await _isInternetAvailable()) return _noInternetResponse(url);
      return await _dio.post(url, data: data is Map ? _sanitizeParams(data as Map<String, dynamic>) : data, queryParameters: params);
    } catch (e) {
      return _handleException(e, url);
    }
  }

  Future<Response> put(String url, {dynamic data, Map<String, dynamic>? params}) async {
    try {
      if (!await _isInternetAvailable()) return _noInternetResponse(url);
      return await _dio.put(url, data: data is Map ? _sanitizeParams(data as Map<String, dynamic>) : data, queryParameters: params);
    } catch (e) {
      return _handleException(e, url);
    }
  }

  Future<Response> delete(String url, {dynamic data, Map<String, dynamic>? params}) async {
    try {
      if (!await _isInternetAvailable()) return _noInternetResponse(url);
      return await _dio.delete(url, data: data, queryParameters: params);
    } catch (e) {
      return _handleException(e, url);
    }
  }

  Future<Response> patch(String url, {dynamic data, Map<String, dynamic>? params}) async {
    try {
      if (!await _isInternetAvailable()) return _noInternetResponse(url);
      return await _dio.patch(url, data: data, queryParameters: params);
    } catch (e) {
      return _handleException(e, url);
    }
  }

  Response _noInternetResponse(String url) {
    return Response(
      requestOptions: RequestOptions(path: url),
      statusCode: ApiResponseCode.noInternet,
      statusMessage: ApiConstant.noInternetConnection,
    );
  }

  Response _handleException(Object e, String url) {
    String message = ApiConstant.somethingWentWrong;
    int statusCode = 533;

    if (e is DioException) {
      statusCode = e.response?.statusCode ?? 533;
      message = _getCleanErrorMessage(e);
    }

    return Response(
      requestOptions: RequestOptions(path: url),
      statusCode: statusCode,
      statusMessage: message,
    );
  }

  String _getCleanErrorMessage(DioException e) {
    final apiError = _extractApiError(e.response);
    if (apiError != null) return apiError;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        return 'Error ${e.response?.statusCode ?? ''}: ${e.response?.statusMessage ?? 'Request failed'}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error.';
      case DioExceptionType.unknown:
        if (e.message?.contains('SocketException') == true) return 'No internet connection.';
        return ApiConstant.somethingWentWrong;
    }
  }

  String? _extractApiError(Response? response) {
    if (response?.data == null) return null;
    final data = response!.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String? ??
          data['errorMessage'] as String? ??
          (data['error'] is Map ? data['error']['message'] as String? : null) ??
          (data['errors'] is List && (data['errors'] as List).isNotEmpty
              ? (data['errors'] as List).first.toString()
              : null);
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }

  Map<String, dynamic>? _sanitizeParams(Map<String, dynamic>? params) {
    params?.removeWhere((key, value) =>
        value == null || (value is String && value.isEmpty) || (value is List && value.isEmpty));
    return params;
  }

  Future<bool> _isInternetAvailable() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

final apiHelper = ApiBaseHelper(ApiConstant.baseUrl);
