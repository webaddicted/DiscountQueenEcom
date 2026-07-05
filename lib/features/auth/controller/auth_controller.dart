import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/auth/data/auth_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/utils/permission_utils.dart';
import 'package:portfolio/global/utils/validation_utils.dart';

class AuthController extends BaseController {
  final _authRepo = Get.find<AuthRepository>();

  bool get isLoggedIn => SPManager.isLoggedIn();

  bool get isAdmin => SPManager.isUserAdmin();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final termsAccepted = false.obs;

  @override
  void onControllerInit() {
    if (kDebugMode) {
      _prefillDebugDefaults();
    }
  }

  @override
  void onControllerClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void _prefillDebugDefaults() {
    if (nameController.text.trim().isEmpty) {
      nameController.text = 'Debug User';
    }
    if (emailController.text.trim().isEmpty) {
      emailController.text = 'aisha@example.com';
    }
    if (phoneController.text.trim().isEmpty) {
      phoneController.text = '9876543210';
    }
    if (passwordController.text.isEmpty) {
      passwordController.text = 'Pass@123';
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordController.text = 'Pass@123';
    }
    termsAccepted.value = true;
  }

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() != true) return;

    final hasPermission = await _requestNotificationPermission();
    if (!hasPermission) return;

    final success = await executeWithLoading(() async {
      await _authRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      return true;
    });

    if (success != null && success) {
      offAllNamed(RoutersConst.home);
    }
  }

  Future<void> register() async {
    if (registerFormKey.currentState?.validate() != true) return;
    if (!termsAccepted.value) {
      Get.snackbar(
        StringConst.termsTitle,
        StringConst.termsAgree,
      );
      return;
    }

    final hasPermission = await _requestNotificationPermission();
    if (!hasPermission) return;

    final success = await executeWithLoading(() async {
      await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      );
      return true;
    });

    if (success != null && success) {
      offAllNamed(RoutersConst.home);
    }
  }

  Future<bool> _requestNotificationPermission() async {
    if (kIsWeb) return true;
    return PermissionHelper.requestPermission(
      PermissionType.notification,
      showBottomSheet: true,
      showDialogOnDenied: true,
    );
  }

  Future<void> forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        StringConst.forgotPassword,
        StringConst.enterEmail,
      );
      return;
    }
    if (ValidationUtils.email(emailController.text.trim()) != null) {
      Get.snackbar(
        StringConst.forgotPassword,
        StringConst.invalidEmail,
      );
      return;
    }
    await executeWithLoading(() async {
      Get.snackbar(
        StringConst.resetPassword,
        'Reset link sent to ${emailController.text.trim()}',
      );
      return true;
    });
  }

  String? validateEmail(String? value) => ValidationUtils.email(value);
  String? validatePassword(String? value) =>
      ValidationUtils.password(value, minLength: 6);
  String? validateName(String? value) => ValidationUtils.name(value);
  String? validatePhone(String? value) => ValidationUtils.phone(value);
  String? validateConfirmPassword(String? value) =>
      ValidationUtils.confirmPassword(value, passwordController.text);
}
