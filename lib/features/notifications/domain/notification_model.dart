class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String notificationType;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    this.title = '',
    this.body = '',
    this.notificationType = 'system',
    this.isRead = false,
    this.createdAt = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        notificationType: json['notification_type'] ?? 'system',
        isRead: json['is_read'] == true,
        createdAt: json['created_at'] ?? '',
      );
}
