import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/auth/data/auth_repository.dart';
import 'package:portfolio/features/auth/domain/auth_response_model.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/utils/permission_utils.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
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
  final otpController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final termsAccepted = false.obs;
  final otpEmail = ''.obs;
  final otpCountdown = 0.obs;
  final otpFromLogin = false.obs;
  final canSubmitLogin = false.obs;
  final canSubmitRegister = false.obs;
  final canSubmitOtp = false.obs;

  Worker? _termsWorker;

  @override
  void onControllerInit() {
    if (kDebugMode) {
      _prefillDebugDefaults();
    }
    _readOtpRouteArgs();
    _attachSubmitListeners();
    _refreshSubmitStates();
  }

  void _readOtpRouteArgs() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['email'] != null) {
        otpEmail.value = args['email'].toString();
        emailController.text = otpEmail.value;
      }
      if (args['fromLogin'] == true) {
        otpFromLogin.value = true;
      }
      if (otpEmail.value.isNotEmpty) {
        _startOtpCountdown();
      }
    }
  }

  void _attachSubmitListeners() {
    for (final controller in [
      emailController,
      passwordController,
      nameController,
      phoneController,
      confirmPasswordController,
      otpController,
    ]) {
      controller.addListener(_refreshSubmitStates);
    }
    _termsWorker = ever(termsAccepted, (_) => _refreshSubmitStates());
  }

  void _closeSnackbars() {
    if (Get.isSnackbarOpen == true) {
      Get.closeAllSnackbars();
    }
  }

  void _navigateThenSnack(
    void Function() navigate,
    String message, {
    bool success = true,
  }) {
    _closeSnackbars();
    navigate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (success) {
        showSuccess(message);
      } else {
        showError(message);
      }
    });
  }

  void _refreshSubmitStates() {
    canSubmitLogin.value = emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final allFilled = name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;

    final validationsPass = ValidationUtils.name(name) == null &&
        ValidationUtils.email(email) == null &&
        ValidationUtils.phone(phone) == null &&
        ValidationUtils.password(password, minLength: 6) == null &&
        ValidationUtils.confirmPassword(confirmPassword, password) == null;

    canSubmitRegister.value =
        allFilled && validationsPass && termsAccepted.value;

    canSubmitOtp.value =
        otpController.text.trim().length == AppConstant.otpLength;
  }

  @override
  void onControllerClose() {
    _termsWorker?.dispose();
    for (final controller in [
      emailController,
      passwordController,
      nameController,
      phoneController,
      confirmPasswordController,
      otpController,
    ]) {
      controller.removeListener(_refreshSubmitStates);
    }
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
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
    if (!canSubmitLogin.value) return;
    if (loginFormKey.currentState?.validate() != true) return;
    clearError();

    final hasPermission = await _requestNotificationPermission();
    if (!hasPermission) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    final result = await executeWithLoading(
      () => _authRepo.loginWithResult(email: email, password: password),
      showError: false,
    );

    if (result == null) return;

    switch (result.status) {
      case LoginStatus.success:
        _navigateThenSnack(
          () => offAllNamed(RoutersConst.home),
          StringConst.loginSuccess,
        );
      case LoginStatus.notVerified:
        otpEmail.value = email;
        otpFromLogin.value = true;
        _closeSnackbars();
        offNamed(
          RoutersConst.otp,
          arguments: {'email': email, 'fromLogin': true},
        );
      case LoginStatus.failed:
        showError(
          result.message.isNotEmpty
              ? result.message
              : StringConst.somethingWentWrong,
        );
    }
  }

  Future<void> register() async {
    if (!canSubmitRegister.value) return;
    if (registerFormKey.currentState?.validate() != true) return;
    if (!termsAccepted.value) {
      showError(StringConst.termsAgree);
      return;
    }
    clearError();

    final hasPermission = await _requestNotificationPermission();
    if (!hasPermission) return;

    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    final response = await executeWithLoading(
      () => _authRepo.registerWithResult(
        name: nameController.text.trim(),
        email: email,
        password: passwordController.text,
        phone: phone,
      ),
      showError: false,
    );

    if (response == null || response.isFailure || response.data == null) {
      showError(
        response?.message.isNotEmpty == true
            ? response!.message
            : StringConst.somethingWentWrong,
      );
      return;
    }

    final pending = response.data!;

    otpEmail.value = pending.email.isNotEmpty ? pending.email : email;
    otpFromLogin.value = false;
    _navigateThenSnack(
      () => offNamed(
        RoutersConst.otp,
        arguments: {'email': otpEmail.value, 'fromLogin': false},
      ),
      StringConst.otpSent,
    );
  }

  Future<void> verifyOtp() async {
    if (!canSubmitOtp.value) return;
    if (otpFormKey.currentState?.validate() != true) return;
    clearError();

    final email = otpEmail.value.isNotEmpty
        ? otpEmail.value
        : emailController.text.trim();

    final verifyResponse = await executeWithLoading(
      () => _authRepo.verifyOtpWithResult(
        email: email,
        otp: otpController.text.trim(),
      ),
      showError: false,
    );

    if (verifyResponse == null || verifyResponse.isFailure) {
      showError(
        verifyResponse?.message.isNotEmpty == true
            ? verifyResponse!.message
            : StringConst.somethingWentWrong,
      );
      return;
    }

    if (otpFromLogin.value) {
      final loginResult = await executeWithLoading(
        () => _authRepo.loginWithResult(
          email: email,
          password: passwordController.text,
        ),
        showError: false,
      );

      if (loginResult?.status == LoginStatus.success) {
        _navigateThenSnack(
          () => offAllNamed(RoutersConst.home),
          StringConst.loginSuccess,
        );
      } else {
        showError(
          loginResult?.message.isNotEmpty == true
              ? loginResult!.message
              : StringConst.somethingWentWrong,
        );
      }
      return;
    }

    _navigateThenSnack(
      () => offAllNamed(RoutersConst.login),
      StringConst.otpVerificationSuccessHindi,
    );
  }

  Future<void> resendOtp() async {
    if (otpCountdown.value > 0) return;
    clearError();

    final email = otpEmail.value.isNotEmpty
        ? otpEmail.value
        : emailController.text.trim();

    if (email.isEmpty) {
      showError(StringConst.enterEmail);
      return;
    }

    final success = await executeWithLoading(() async {
      await _authRepo.sendOtp(email: email);
      return true;
    });

    if (success == true) {
      showSuccess(StringConst.otpSent);
      _startOtpCountdown();
    }
  }

  void _startOtpCountdown() {
    otpCountdown.value = AppConstant.otpTimeout;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (otpCountdown.value <= 0) return false;
      otpCountdown.value--;
      return otpCountdown.value > 0;
    });
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
      showError(StringConst.enterEmail);
      return;
    }
    if (ValidationUtils.email(emailController.text.trim()) != null) {
      showError(StringConst.invalidEmail);
      return;
    }
    await executeWithLoading(() async {
      showSuccess('Reset link sent to ${emailController.text.trim()}');
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
  String? validateOtp(String? value) =>
      ValidationUtils.otp(value, length: AppConstant.otpLength);
}
