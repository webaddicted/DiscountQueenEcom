import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/notifications/domain/notification_model.dart';

class NotificationRepository extends BaseRepository {
  Future<List<NotificationModel>> getNotifications() => getList<NotificationModel>(
        url: ApiConstant.notifications,
        itemParser: (e) => NotificationModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<void> markAsRead(String notificationId) async {
    await postAction(
      url: ApiConstant.notificationsRead,
      params: {'notification_id': notificationId},
    ).unwrap();
  }
}
