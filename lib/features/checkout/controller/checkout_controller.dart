import 'package:get/get.dart';
import 'package:portfolio/features/address/controller/address_controller.dart';
import 'package:portfolio/features/cart/controller/cart_controller.dart';
import 'package:portfolio/features/orders/data/order_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/address/domain/address_model.dart';

class CheckoutController extends BaseController {
  final _orderRepo = Get.find<OrderRepository>();

  final selectedAddress = Rx<AddressModel?>(null);
  final selectedPaymentMethod = 'cod'.obs;
  final addresses = <AddressModel>[].obs;

  @override
  void onControllerInit() {
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    if (!SPManager.isLoggedIn()) return;
    final addressCtrl = Get.isRegistered<AddressController>()
        ? Get.find<AddressController>()
        : Get.put(AddressController());
    if (addressCtrl.addresses.isEmpty) {
      await addressCtrl.loadAddresses();
    }
    addresses.value = addressCtrl.addresses.toList();
    if (addresses.isNotEmpty) {
      selectedAddress.value = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
    }
  }

  void selectAddress(AddressModel address) => selectedAddress.value = address;
  void selectPaymentMethod(String method) =>
      selectedPaymentMethod.value = method;

  Future<void> placeOrder() async {
    final cartController = Get.find<CartController>();
    final address = selectedAddress.value;
    if (address == null) return;

    await executeWithLoading(() async {
      final order = await _orderRepo.placeOrder(
        addressId: address.id,
        paymentMethod: selectedPaymentMethod.value,
        couponCode: cartController.cart.value.couponCode.isNotEmpty
            ? cartController.cart.value.couponCode
            : null,
      );
      await cartController.refreshCart();
      offNamed(RoutersConst.orderSuccess, arguments: order);
    });
  }
}
