import 'package:dio/dio.dart';
import 'package:portfolio/global/apiutils/api_base_helper.dart';
import 'package:portfolio/global/constant/api_const.dart';

class Result<T> {
  final T? _data;
  final String? _error;
  final bool _isSuccess;

  const Result._(this._data, this._error, this._isSuccess);

  factory Result.success(T data) => Result._(data, null, true);
  factory Result.failure(String error) => Result._(null, error, false);

  bool get isSuccess => _isSuccess;
  bool get isFailure => !_isSuccess;

  T get dataOrThrow => _isSuccess ? _data as T : throw Exception(_error);
  T getOrDefault(T defaultValue) => _isSuccess && _data != null ? _data as T : defaultValue;

  R fold<R>(R Function(T data) onSuccess, R Function(String error) onFailure) =>
      _isSuccess ? onSuccess(_data as T) : onFailure(_error ?? 'Unknown error');

  Result<R> map<R>(R Function(T data) transform) =>
      _isSuccess ? Result.success(transform(_data as T)) : Result.failure(_error ?? 'Unknown error');

  void onSuccess(void Function(T data) action) { if (_isSuccess && _data != null) action(_data as T); }
  void onFailure(void Function(String error) action) { if (!_isSuccess) action(_error ?? 'Unknown error'); }
}

enum ApiStatus { idle, loading, success, error, noInternet }

class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;

  const ApiResponse._(this.status, this.data, this.message);

  factory ApiResponse.idle() => const ApiResponse._(ApiStatus.idle, null, null);
  factory ApiResponse.loading() => const ApiResponse._(ApiStatus.loading, null, null);
  factory ApiResponse.success(T data) => ApiResponse._(ApiStatus.success, data, null);
  factory ApiResponse.error([String? message]) => ApiResponse._(ApiStatus.error, null, message);
  factory ApiResponse.noInternet() => const ApiResponse._(ApiStatus.noInternet, null, null);

  factory ApiResponse.fromResponse(Response? response, T? data) {
    if (response?.statusCode == ApiResponseCode.success) return ApiResponse.success(data as T);
    if (response?.statusCode == ApiResponseCode.noInternet) return ApiResponse.noInternet();
    return ApiResponse.error(response?.statusMessage ?? ApiConstant.somethingWentWrong);
  }

  factory ApiResponse.fromResult(Result<T> result) {
    return result.fold(
      (data) => ApiResponse.success(data),
      (error) => error.toLowerCase().contains('internet') ? ApiResponse.noInternet() : ApiResponse.error(error),
    );
  }

  bool get isIdle => status == ApiStatus.idle;
  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
  bool get hasData => data != null;
}

extension ResultToApiResponse<T> on Result<T> {
  ApiResponse<T> toApiResponse() => ApiResponse.fromResult(this);
}
