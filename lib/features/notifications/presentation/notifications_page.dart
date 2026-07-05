import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/notifications/controller/notification_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';
import 'package:portfolio/global/widgets/shimmer_widget.dart';

class NotificationsPage extends BaseStatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final controller = Get.put(NotificationController());
    if (SPManager.isLoggedIn()) {
      controller.loadNotifications();
    }

    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.notificationsTitle,
        showBack: true,
      ),
      body: Obx(() {
        if (controller.isLoadingRx.value) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 80),
          );
        }
        if (controller.notifications.isEmpty) {
          return const EmptyWidget(
            message: 'No notifications yet',
            subtitle: 'Your notifications will appear here',
            icon: Icons.notifications_none_outlined,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final n = controller.notifications[index];
              return ListTile(
                tileColor: n.isRead
                    ? null
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(n.title, style: AppTextStyle.titleMedium),
                subtitle: Text(n.body, style: AppTextStyle.bodyMedium),
                trailing: n.isRead
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.done_all, size: 20),
                        onPressed: () => controller.markAsRead(n.id),
                      ),
                onTap: () {
                  if (!n.isRead) controller.markAsRead(n.id);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
