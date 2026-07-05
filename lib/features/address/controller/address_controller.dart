import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/profile/data/user_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/address/domain/address_model.dart';

class AddressController extends BaseController {
  final _userRepo = Get.find<UserRepository>();

  final addresses = <AddressModel>[].obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final landmarkController = TextEditingController();

  final selectedType = 'home'.obs;
  final isDefault = false.obs;

  @override
  void onControllerInit() {}

  @override
  void onControllerClose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    landmarkController.dispose();
  }

  Future<void> loadAddresses() async {
    await executeWithLoading(() async {
      addresses.value = await _userRepo.getAddresses();
    });
  }

  Future<void> addAddress(AddressModel address) async {
    await executeWithLoading(() async {
      final saved = await _userRepo.addAddress(address);
      addresses.add(saved);
      _clearForm();
    });
  }

  Future<void> updateAddress(AddressModel address) async {
    await executeWithLoading(() async {
      final saved = await _userRepo.updateAddress(address);
      final idx = addresses.indexWhere((a) => a.id == address.id);
      if (idx >= 0) addresses[idx] = saved;
      _clearForm();
    });
  }

  Future<void> deleteAddress(String id) async {
    await executeWithLoading(() async {
      await _userRepo.deleteAddress(id);
      addresses.removeWhere((a) => a.id == id);
    });
  }

  Future<void> setDefault(String id) async {
    final addr = addresses.firstWhereOrNull((a) => a.id == id);
    if (addr == null) return;
    await updateAddress(addr.copyWith(isDefault: true));
    await loadAddresses();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    landmarkController.clear();
    selectedType.value = 'home';
    isDefault.value = false;
    applyDebugDefaultsIfNeeded();
  }

  void loadAddressForEdit(AddressModel address) {
    nameController.text = address.name;
    phoneController.text = address.phone;
    addressLine1Controller.text = address.addressLine1;
    addressLine2Controller.text = address.addressLine2;
    cityController.text = address.city;
    stateController.text = address.state;
    pincodeController.text = address.pincode;
    landmarkController.text = address.landmark;
    selectedType.value = address.type;
    isDefault.value = address.isDefault;
  }

  void applyDebugDefaultsIfNeeded() {
    if (!kDebugMode) return;
    if (nameController.text.trim().isEmpty) {
      nameController.text = 'Debug User';
    }
    if (phoneController.text.trim().isEmpty) {
      phoneController.text = '9876543210';
    }
    if (addressLine1Controller.text.trim().isEmpty) {
      addressLine1Controller.text = '221B Baker Street';
    }
    if (addressLine2Controller.text.trim().isEmpty) {
      addressLine2Controller.text = 'Near Central Park';
    }
    if (cityController.text.trim().isEmpty) {
      cityController.text = 'Mumbai';
    }
    if (stateController.text.trim().isEmpty) {
      stateController.text = 'Maharashtra';
    }
    if (pincodeController.text.trim().isEmpty) {
      pincodeController.text = '400001';
    }
    if (landmarkController.text.trim().isEmpty) {
      landmarkController.text = 'Opposite Metro Gate 2';
    }
    selectedType.value = selectedType.value.isEmpty ? 'home' : selectedType.value;
    isDefault.value = true;
  }
}
