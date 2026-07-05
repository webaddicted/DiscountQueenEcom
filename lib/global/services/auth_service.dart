import 'package:get/get.dart';
import 'package:portfolio/global/apiutils/api_response.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/utils/app_utils.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool get isLoggedIn => SPManager.isLoggedIn();
  String get userId => SPManager.getUserId();
  String get userName => SPManager.getUserName();
  String get userEmail => SPManager.getUserEmail();
  String get userPhotoUrl => SPManager.getUserPhotoUrl();

  Map<String, dynamic> get userData => SPManager.getLoginDetails();

  Future<Result<bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual login API call
      await SPManager.saveLoginDetails(
        userId: 'user_123',
        name: 'User',
        email: email,
      );
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<bool>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement actual register API call
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<bool>> forgotPassword({required String email}) async {
    try {
      // TODO: Implement actual forgot password API call
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await SPManager.clearLoginDetails();
      Get.offAllNamed(RoutersConst.login);
    } catch (e) {
      printError('AuthService', 'logout error: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      // TODO: Implement actual delete account API call
      await SPManager.clearLoginDetails();
      await SPManager.clearPref();
      Get.offAllNamed(RoutersConst.login);
    } catch (e) {
      printError('AuthService', 'deleteAccount error: $e');
    }
  }

  Future<void> refreshSession() async {
    // TODO: Implement token refresh logic
  }

  bool isSessionValid() {
    return SPManager.getAccessToken().isNotEmpty;
  }
}
