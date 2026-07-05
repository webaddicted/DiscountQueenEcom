class NotificationBroadcastModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool sent;

  NotificationBroadcastModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.sent = false,
  });
}
