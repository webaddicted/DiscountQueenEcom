class ApiEnvelope<T> {
  final String message;
  final bool success;
  final T? data;

  const ApiEnvelope({
    required this.message,
    required this.success,
    this.data,
  });

  bool get hasData => data != null;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic raw)? dataParser,
  ) {
    final rawData = json['data'];
    return ApiEnvelope<T>(
      message: json['message']?.toString() ?? '',
      success: json['success'] == true,
      data: rawData != null && dataParser != null ? dataParser(rawData) : rawData as T?,
    );
  }
}
