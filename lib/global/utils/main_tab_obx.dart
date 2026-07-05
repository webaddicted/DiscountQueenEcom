import 'package:get/get.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';

/// Binds [Obx] to main shell state when a tab controller is not registered yet.
void trackMainShellObx() {
  if (!Get.isRegistered<MainController>()) return;
  final main = Get.find<MainController>();
  main.currentIndex.value;
  main.tabRevision.value;
}
