import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/address/domain/address_model.dart';
import 'package:portfolio/features/cart/domain/cart_model.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';

class OrderController extends BaseController {
  final orders = <OrderModel>[].obs;
  final selectedOrder = Rx<OrderModel?>(null);
  final selectedStatus = 'all'.obs;

  @override
  void onControllerInit() {
    loadOrders();
  }

  void loadOrders() {
    orders.value = _getDummyOrders();
  }

  void loadOrderDetail(String id) {
    OrderModel? found;
    for (final o in orders) {
      if (o.id == id) {
        found = o;
        break;
      }
    }
    if (found == null) {
      for (final o in _getDummyOrders()) {
        if (o.id == id) {
          found = o;
          break;
        }
      }
    }
    selectedOrder.value = found;
  }

  Future<void> cancelOrder(String id) async {
    final idx = orders.indexWhere((o) => o.id == id);
    if (idx >= 0 && orders[idx].canCancel) {
      orders[idx] = OrderModel(
        id: orders[idx].id,
        orderNumber: orders[idx].orderNumber,
        items: orders[idx].items,
        subtotal: orders[idx].subtotal,
        deliveryFee: orders[idx].deliveryFee,
        discount: orders[idx].discount,
        total: orders[idx].total,
        status: 'cancelled',
        paymentMethod: orders[idx].paymentMethod,
        paymentStatus: orders[idx].paymentStatus,
        deliveryAddress: orders[idx].deliveryAddress,
        createdAt: orders[idx].createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        estimatedDelivery: orders[idx].estimatedDelivery,
        trackingSteps: orders[idx].trackingSteps,
        userId: orders[idx].userId,
        paymentRef: orders[idx].paymentRef,
      );
      if (selectedOrder.value?.id == id) {
        selectedOrder.value = orders[idx];
      }
    }
  }

  List<OrderModel> _getDummyOrders() {
    final addr = AddressModel(
      id: '1',
      name: 'John Doe',
      phone: '+919876543210',
      addressLine1: '123, Green Valley Apartments',
      addressLine2: 'Block B, 4th Floor',
      city: 'Mumbai',
      state: 'Maharashtra',
      pincode: '400001',
      landmark: 'Near City Mall',
      type: 'home',
      isDefault: true,
    );

    return [
      OrderModel(
        id: '1',
        orderNumber: 'ORD-2024-001',
        items: [
          CartItemModel(
            id: 'ci1',
            productId: 'p1',
            productName: 'Baby Cotton Onesie',
            productImage: 'https://picsum.photos/200?random=1',
            price: 499,
            mrp: 699,
            quantity: 2,
          ),
          CartItemModel(
            id: 'ci2',
            productId: 'p2',
            productName: 'Soft Baby Blanket',
            productImage: 'https://picsum.photos/200?random=2',
            price: 899,
            mrp: 999,
            quantity: 1,
          ),
        ],
        subtotal: 1897,
        deliveryFee: 49,
        discount: 100,
        total: 1846,
        status: 'delivered',
        paymentMethod: 'UPI',
        paymentStatus: 'paid',
        deliveryAddress: addr,
        createdAt: '2024-03-01T10:00:00Z',
        updatedAt: '2024-03-05T14:30:00Z',
        estimatedDelivery: '2024-03-05',
        trackingSteps: [
          OrderTrackingStep(
            title: 'Order Placed',
            description: 'Your order has been placed',
            dateTime: 'Mar 1, 2024 10:00 AM',
            isCompleted: true,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Shipped',
            description: 'Order dispatched from warehouse',
            dateTime: 'Mar 2, 2024 2:00 PM',
            isCompleted: true,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Out for Delivery',
            description: 'Package is on the way',
            dateTime: 'Mar 5, 2024 9:00 AM',
            isCompleted: true,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Delivered',
            description: 'Delivered successfully',
            dateTime: 'Mar 5, 2024 2:30 PM',
            isCompleted: true,
            isCurrent: true,
          ),
        ],
      ),
      OrderModel(
        id: '2',
        orderNumber: 'ORD-2024-002',
        items: [
          CartItemModel(
            id: 'ci3',
            productId: 'p3',
            productName: 'Baby Feeding Bottle Set',
            productImage: 'https://picsum.photos/200?random=3',
            price: 599,
            mrp: 799,
            quantity: 1,
          ),
        ],
        subtotal: 599,
        deliveryFee: 49,
        discount: 0,
        total: 648,
        status: 'shipped',
        paymentMethod: 'Cash on Delivery',
        paymentStatus: 'pending',
        deliveryAddress: addr,
        createdAt: '2024-03-08T11:30:00Z',
        updatedAt: '2024-03-09T08:00:00Z',
        estimatedDelivery: '2024-03-12',
        trackingSteps: [
          OrderTrackingStep(
            title: 'Order Placed',
            description: 'Your order has been placed',
            dateTime: 'Mar 8, 2024 11:30 AM',
            isCompleted: true,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Shipped',
            description: 'Order dispatched from warehouse',
            dateTime: 'Mar 9, 2024 8:00 AM',
            isCompleted: true,
            isCurrent: true,
          ),
          OrderTrackingStep(
            title: 'Out for Delivery',
            description: 'Package will be delivered soon',
            dateTime: '',
            isCompleted: false,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Delivered',
            description: '',
            dateTime: '',
            isCompleted: false,
            isCurrent: false,
          ),
        ],
      ),
      OrderModel(
        id: '3',
        orderNumber: 'ORD-2024-003',
        items: [
          CartItemModel(
            id: 'ci4',
            productId: 'p4',
            productName: 'Baby Diaper Pack',
            productImage: 'https://picsum.photos/200?random=4',
            price: 449,
            mrp: 549,
            quantity: 3,
          ),
        ],
        subtotal: 1347,
        deliveryFee: 0,
        discount: 150,
        total: 1197,
        status: 'pending',
        paymentMethod: 'UPI',
        paymentStatus: 'paid',
        deliveryAddress: addr,
        createdAt: '2024-03-10T09:15:00Z',
        updatedAt: '2024-03-10T09:15:00Z',
        estimatedDelivery: '2024-03-14',
        trackingSteps: [
          OrderTrackingStep(
            title: 'Order Placed',
            description: 'Your order has been placed',
            dateTime: 'Mar 10, 2024 9:15 AM',
            isCompleted: true,
            isCurrent: true,
          ),
          OrderTrackingStep(
            title: 'Shipped',
            description: '',
            dateTime: '',
            isCompleted: false,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Out for Delivery',
            description: '',
            dateTime: '',
            isCompleted: false,
            isCurrent: false,
          ),
          OrderTrackingStep(
            title: 'Delivered',
            description: '',
            dateTime: '',
            isCompleted: false,
            isCurrent: false,
          ),
        ],
      ),
    ];
  }

  List<OrderModel> getFilteredOrders(String? status) {
    if (status == null || status.isEmpty || status == 'all') {
      return orders;
    }
    return orders.where((o) => o.status == status).toList();
  }
}
