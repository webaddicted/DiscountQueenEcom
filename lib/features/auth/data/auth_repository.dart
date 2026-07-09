import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/global/services/supabase_service.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/auth/domain/auth_request_model.dart';
import 'package:portfolio/features/auth/domain/auth_response_model.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class AuthRepository extends BaseRepository {
  Future<LoginResult> loginWithResult({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final envelope = await postEnvelope<UserModel>(
      url: ApiConstant.login,
      data: LoginRequest(email: trimmedEmail, password: password),
      dataParser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );

    final response = LoginResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );

    if (response.isSuccess && response.data != null) {
      await _persistSession(response.data!, trimmedEmail);
    }

    return LoginResult.fromResponse(response);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await loginWithResult(email: email, password: password);
    if (result.status == LoginStatus.success && result.user != null) {
      return result.user!;
    }
    throw Exception(result.message.isNotEmpty ? result.message : 'Login failed');
  }

  Future<RegisterResponse> registerWithResult({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final envelope = await postEnvelope<RegisterPendingModel>(
      url: ApiConstant.register,
      data: RegisterRequest(
        name: name.trim(),
        email: email.trim(),
        password: password,
        phone: phone?.trim(),
      ),
      dataParser: (d) =>
          RegisterPendingModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );

    return RegisterResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }

  Future<RegisterPendingModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await registerWithResult(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(
      response.message.isNotEmpty ? response.message : 'Registration failed',
    );
  }

  Future<void> sendOtp({required String email}) async {
    final response = await postMessageEnvelope(
      url: ApiConstant.sendOtp,
      data: ResendOtpRequest(email: email.trim()),
    );
    if (response.isFailure) {
      throw Exception(
        response.message.isNotEmpty ? response.message : 'Failed to send OTP',
      );
    }
  }

  Future<MessageResponse> verifyOtpWithResult({
    required String email,
    required String otp,
  }) async {
    final envelope = await postMessageEnvelope(
      url: ApiConstant.verifyOtp,
      data: VerifyOtpRequest(email: email.trim(), otp: otp.trim()),
    );

    return MessageResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await verifyOtpWithResult(email: email, otp: otp);
    if (response.isFailure) {
      throw Exception(
        response.message.isNotEmpty ? response.message : 'OTP verification failed',
      );
    }
  }

  Future<void> logout() async {
    if (SPManager.isLoggedIn()) {
      await postAction(url: ApiConstant.logout);
    }
    await SupabaseService.signOut();
    await SPManager.clearLoginDetails();
  }

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? gender,
    String? dateOfBirth,
  }) async {
    return post<UserModel>(
      url: ApiConstant.updateProfile,
      parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
      data: ProfileUpdateRequest(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        gender: gender,
        dateOfBirth: dateOfBirth,
      ),
    ).unwrap();
  }

  Future<void> deleteAccount() async {
    await postAction(url: ApiConstant.deleteAccount).unwrap();
    await SPManager.clearLoginDetails();
  }

  Future<void> _persistSession(UserModel profile, String email) async {
    if (profile.accessToken.isNotEmpty) {
      await SPManager.setAccessToken(profile.accessToken);
    }
    if (profile.refreshToken.isNotEmpty) {
      await SPManager.setRefreshToken(profile.refreshToken);
      await SupabaseService.restoreSession(
        accessToken: profile.accessToken,
        refreshToken: profile.refreshToken,
      );
    }

    await SPManager.setUserId(profile.id);
    await SPManager.saveLoginDetails(
      userId: profile.id,
      name: profile.name,
      email: email,
      photoUrl: profile.photoUrl,
      isAdmin: profile.isAdmin,
    );
  }
}
