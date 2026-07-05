import 'package:get/get.dart';
import 'package:portfolio/features/notifications/data/notification_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/notifications/domain/notification_model.dart';

class NotificationController extends BaseController {
  final _repo = Get.find<NotificationRepository>();

  final notifications = <NotificationModel>[].obs;

  @override
  void onControllerInit() {}

  Future<void> loadNotifications() async {
    await executeWithLoading(() async {
      notifications.value = await _repo.getNotifications();
    });
  }

  Future<void> markAsRead(String id) async {
    await executeSilently(() async {
      await _repo.markAsRead(id);
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx >= 0) {
        notifications[idx] = NotificationModel(
          id: notifications[idx].id,
          title: notifications[idx].title,
          body: notifications[idx].body,
          notificationType: notifications[idx].notificationType,
          isRead: true,
          createdAt: notifications[idx].createdAt,
        );
      }
    });
  }
}
