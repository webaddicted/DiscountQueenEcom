import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';

abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;
  final Rx<Exception?> _exception = Rx<Exception?>(null);

  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;

  /// Use inside [Obx] / [GetX] builders so loading state updates reliably.
  RxBool get isLoadingRx => _isLoading;
  RxBool get isErrorRx => _isError;
  RxString get errorMessageRx => _errorMessage;
  Exception? get exception => _exception.value;

  @protected
  void onControllerInit() {}
  @protected
  void onControllerReady() {}
  @protected
  void onControllerClose() {}

  @override
  void onInit() { super.onInit(); onControllerInit(); }
  @override
  void onReady() { super.onReady(); onControllerReady(); }
  @override
  void onClose() { onControllerClose(); super.onClose(); }

  void showLoading() {
    _isLoading.value = true;
    _isError.value = false;
    _errorMessage.value = '';
  }

  void hideLoading() => _isLoading.value = false;

  void setError(String message, [Exception? e]) {
    _isError.value = true;
    _errorMessage.value = message;
    _exception.value = e;
    _isLoading.value = false;
  }

  void clearError() {
    _isError.value = false;
    _errorMessage.value = '';
    _exception.value = null;
  }

  void resetStates() {
    _isLoading.value = false;
    _isError.value = false;
    _errorMessage.value = '';
    _exception.value = null;
  }

  String _exceptionMessage(Object e, {String? fallback}) {
    if (e is Exception) {
      final text = e.toString();
      if (text.startsWith('Exception: ')) return text.substring(11);
      return text;
    }
    return fallback ?? e.toString();
  }

  Future<T?> executeWithLoading<T>(Future<T> Function() action,
      {String? errorMessage, bool showError = true}) async {
    try {
      showLoading();
      final result = await action();
      hideLoading();
      return result;
    } catch (e) {
      if (showError) {
        setError(
          errorMessage ?? _exceptionMessage(e),
          e is Exception ? e : Exception(e.toString()),
        );
      } else {
        hideLoading();
      }
      return null;
    }
  }

  Future<T?> executeSilently<T>(Future<T> Function() action,
      {Function(Exception)? onError, bool showErrorMessage = false}) async {
    try {
      return await action();
    } catch (e) {
      final exception = e is Exception ? e : Exception(e.toString());
      onError?.call(exception);
      if (showErrorMessage) {
        showError(_exceptionMessage(e));
      }
      return null;
    }
  }

  Future<T?> executeWithRetry<T>(Future<T> Function() action,
      {int maxRetries = 3,
      Duration retryDelay = const Duration(seconds: 1),
      String? errorMessage}) async {
    int attempts = 0;
    Exception? lastException;
    while (attempts < maxRetries) {
      try {
        showLoading();
        final result = await action();
        hideLoading();
        return result;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempts++;
        if (attempts < maxRetries) await Future.delayed(retryDelay);
      }
    }
    setError(
      errorMessage ?? _exceptionMessage(lastException ?? 'Request failed'),
      lastException,
    );
    return null;
  }

  // Navigation
  Future<T?>? toNamed<T>(String route, {dynamic arguments}) =>
      Get.toNamed<T>(route, arguments: arguments);
  Future<T?>? to<T>(Widget page, {Transition? transition}) =>
      Get.to<T>(() => page, transition: transition);
  Future<T?>? offNamed<T>(String route, {dynamic arguments}) =>
      Get.offNamed<T>(route, arguments: arguments);
  Future<T?>? off<T>(Widget page, {Transition? transition}) =>
      Get.off<T>(() => page, transition: transition);
  Future<T?>? offAllNamed<T>(String route, {dynamic arguments}) =>
      Get.offAllNamed<T>(route, arguments: arguments);
  void goBack<T>([T? result]) => Get.back<T>(result: result);

  void showLoadingDialog({String? message}) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: Text(message, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ]),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  T? getArguments<T>() => Get.arguments as T?;
  Map<String, String?> get parameters => Get.parameters;
}
