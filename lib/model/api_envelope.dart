/// Standard API envelope: `{ message, success, data }`.
class ApiEnvelope<T> {
  final String message;
  final bool success;
  final T? data;

  const ApiEnvelope({
    this.message = '',
    this.success = false,
    this.data,
  });

  bool get isSuccess => success;
  bool get isFailure => !success;
  bool get hasData => data != null;

  T get dataOrThrow {
    if (!success || data == null) {
      throw Exception(message.isNotEmpty ? message : 'No data available');
    }
    return data as T;
  }

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic raw)? dataParser,
  ) {
    final message = json['message']?.toString().trim() ?? '';
    final isSuccess = json['success'] == true;
    final rawData = json['data'];

    if (!isSuccess) {
      return ApiEnvelope<T>(
        message: message.isNotEmpty ? message : 'Request failed',
        success: false,
      );
    }

    if (rawData == null) {
      return ApiEnvelope<T>(
        message: message.isNotEmpty ? message : 'No data available',
        success: false,
      );
    }

    if (dataParser != null) {
      try {
        final parsed = dataParser(rawData);
        return ApiEnvelope<T>(
          message: message,
          success: true,
          data: parsed,
        );
      } catch (_) {
        return ApiEnvelope<T>(
          message: 'Failed to parse response data',
          success: false,
        );
      }
    }

    if (rawData is Map || rawData is List) {
      return ApiEnvelope<T>(
        message: message,
        success: true,
        data: rawData as T?,
      );
    }

    return ApiEnvelope<T>(
      message: message,
      success: true,
      data: rawData as T?,
    );
  }

  static ApiEnvelope<T> parse<T>(
    dynamic raw,
    T Function(dynamic data)? dataParser,
  ) {
    if (raw is! Map) {
      return ApiEnvelope<T>(
        message: 'Invalid response format',
        success: false,
      );
    }
    return ApiEnvelope<T>.fromJson(
      Map<String, dynamic>.from(raw),
      dataParser,
    );
  }

  factory ApiEnvelope.failure(String message) =>
      ApiEnvelope<T>(message: message, success: false);

  factory ApiEnvelope.success(T data, {String message = ''}) =>
      ApiEnvelope<T>(message: message, success: true, data: data);

  Map<String, dynamic> toJson({Object? Function(T value)? dataEncoder}) => {
        'message': message,
        'success': success,
        'data': data != null && dataEncoder != null
            ? dataEncoder(data as T)
            : data,
      };
}
