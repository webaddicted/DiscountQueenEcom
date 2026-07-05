import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/features/address/domain/address_model.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';

class CheckoutController extends BaseController {
  final selectedAddress = Rx<AddressModel?>(null);
  final selectedPaymentMethod = 'cod'.obs;
  final addresses = <AddressModel>[].obs;

  @override
  void onControllerInit() {
    _loadDummyAddresses();
  }

  void _loadDummyAddresses() {
    addresses.value = [
      AddressModel(
        id: 'addr1',
        name: 'Priya Sharma',
        phone: '+91 9876543210',
        addressLine1: '123, Green Valley Apartments',
        addressLine2: 'Sector 15, Near City Mall',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400001',
        landmark: 'Opposite Metro Station',
        type: 'home',
        isDefault: true,
      ),
      AddressModel(
        id: 'addr2',
        name: 'Priya Sharma',
        phone: '+91 9876543210',
        addressLine1: '456, Tech Park Building',
        addressLine2: 'Andheri East',
        city: 'Mumbai',
        state: 'Maharashtra',
        pincode: '400069',
        landmark: 'Near Airport',
        type: 'office',
        isDefault: false,
      ),
    ];
    selectedAddress.value = addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  void selectAddress(AddressModel address) => selectedAddress.value = address;
  void selectPaymentMethod(String method) =>
      selectedPaymentMethod.value = method;

  Future<void> placeOrder() async {
    final cartController = Get.find<CartController>();
    final address = selectedAddress.value;
    if (address == null) return;

    await executeWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      final subtotal = cartController.subtotal;
      final deliveryFee = cartController.deliveryFee;
      final discount = cartController.cart.value.couponDiscount;
      final total = subtotal + deliveryFee - discount;

      final order = OrderModel(
        id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
        orderNumber: 'SHU${DateTime.now().millisecondsSinceEpoch % 100000}',
        items: List.from(cartController.cart.value.items),
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        status: 'confirmed',
        paymentMethod: selectedPaymentMethod.value == 'cod'
            ? 'Cash on Delivery'
            : selectedPaymentMethod.value == 'online'
                ? 'Online Payment'
                : 'UPI',
        paymentStatus: 'pending',
        deliveryAddress: address,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        estimatedDelivery: DateTime.now()
            .add(const Duration(days: 5))
            .toIso8601String(),
      );

      cartController.clearCart();
      offNamed(RoutersConst.orderSuccess, arguments: order);
    });
  }
}
