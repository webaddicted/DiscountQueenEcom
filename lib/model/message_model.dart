class MessageModel {
  final String message;
  final bool success;

  const MessageModel({
    required this.message,
    this.success = true,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json['message']?.toString() ?? '',
        success: json['success'] == true,
      );
}
