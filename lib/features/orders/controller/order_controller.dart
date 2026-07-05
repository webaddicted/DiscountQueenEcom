import 'package:get/get.dart';
import 'package:portfolio/features/orders/data/order_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';

class OrderController extends BaseController {
  final _orderRepo = Get.find<OrderRepository>();

  final orders = <OrderModel>[].obs;
  final selectedOrder = Rx<OrderModel?>(null);
  final selectedStatus = 'all'.obs;

  @override
  void onControllerInit() {}

  Future<void> loadOrders() async {
    await executeWithLoading(() async {
      orders.value = await _orderRepo.getOrders();
    });
  }

  Future<void> loadOrderDetail(String id) async {
    await executeWithLoading(() async {
      selectedOrder.value = await _orderRepo.getOrderDetail(id);
    });
  }

  Future<void> cancelOrder(String id) async {
    await executeWithLoading(() async {
      final updated = await _orderRepo.cancelOrder(id);
      final idx = orders.indexWhere((o) => o.id == id);
      if (idx >= 0) orders[idx] = updated;
      if (selectedOrder.value?.id == id) selectedOrder.value = updated;
    });
  }

  List<OrderModel> getFilteredOrders(String? status) {
    if (status == null || status.isEmpty || status == 'all') {
      return orders;
    }
    return orders.where((o) => o.status == status).toList();
  }
}
