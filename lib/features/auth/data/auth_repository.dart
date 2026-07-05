import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/auth/domain/auth_request_model.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class AuthRepository extends BaseRepository {
  static const _demoUserIds = <String, String>{
    'aisha@example.com': '10000001-0001-4001-8001-000000000001',
    'admin@discountqueen.com': '10000001-0001-4001-8001-000000000002',
    'admin@kdebug.com': '10000001-0001-4001-8001-000000000002',
  };

  String resolveUserId(String email) {
    final key = email.trim().toLowerCase();
    return _demoUserIds[key] ?? _devUuidFromEmail(key);
  }

  String _devUuidFromEmail(String email) {
    final h = email.hashCode.abs();
    final h2 = email.codeUnits.fold<int>(0, (p, c) => p + c).abs();
    final part1 = (h & 0xffffffff).toRadixString(16).padLeft(8, '0');
    final part2 = (h2 & 0xffff).toRadixString(16).padLeft(4, '0');
    final part3 = (0x4000 | ((h ^ h2) & 0x0fff)).toRadixString(16).padLeft(4, '0');
    final part4 = (0x8000 | ((h + h2) & 0x0fff)).toRadixString(16).padLeft(4, '0');
    final part5 = ((h * h2) & 0xffffffffffff).toRadixString(16).padLeft(12, '0');
    return '$part1-$part2-$part3-$part4-$part5';
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final userId = resolveUserId(normalizedEmail);
    await postAction(
      url: ApiConstant.login,
      data: LoginRequest(email: email, password: password),
    ).unwrap();

    await SPManager.setUserId(userId);
    final profile = await _fetchProfileOrFallback(
      userId: userId,
      email: email.trim(),
      name: _nameFromEmail(normalizedEmail),
      isAdmin: _isAdminEmail(normalizedEmail),
    );
    await SPManager.saveLoginDetails(
      userId: profile.id,
      name: profile.name,
      email: email,
      photoUrl: profile.photoUrl,
      isAdmin: profile.isAdmin,
    );
    return profile;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final userId = resolveUserId(normalizedEmail);
    await SPManager.setUserId(userId);

    final result = await post<UserModel>(
      url: ApiConstant.register,
      data: RegisterRequest(
        name: name,
        email: email.trim(),
        password: password,
        phone: phone,
        userId: userId,
      ),
      parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );

    final profile = result.fold(
      (user) => user,
      (_) => UserModel(
        id: userId,
        name: name,
        email: email.trim(),
        phone: phone ?? '',
      ),
    );

    await SPManager.saveLoginDetails(
      userId: profile.id,
      name: profile.name,
      email: email.trim(),
      photoUrl: profile.photoUrl,
      isAdmin: profile.isAdmin,
    );
    return profile;
  }

  Future<void> logout() async {
    if (SPManager.isLoggedIn()) {
      await postAction(url: ApiConstant.logout);
    }
    await SPManager.clearLoginDetails();
  }

  Future<UserModel> _fetchProfileOrFallback({
    required String userId,
    required String email,
    required String name,
    required bool isAdmin,
  }) async {
    final result = await get<UserModel>(
      url: ApiConstant.userProfile,
      parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );
    return result.fold(
      (profile) => profile,
      (_) => UserModel(
        id: userId,
        name: name,
        email: email,
        isAdmin: isAdmin,
      ),
    );
  }

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'User';
    return local[0].toUpperCase() + local.substring(1);
  }

  bool _isAdminEmail(String email) =>
      email == 'admin@discountqueen.com' || email == 'admin@kdebug.com';

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
}
