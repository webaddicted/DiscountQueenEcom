import 'package:get/get.dart';
import 'package:portfolio/features/profile/data/user_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class ProfileController extends BaseController {
  final _userRepo = Get.find<UserRepository>();

  final user = Rx<UserModel?>(null);

  @override
  void onControllerInit() {}

  Future<void> loadProfile() async {
    if (!SPManager.isLoggedIn()) {
      user.value = _guestUser();
      return;
    }
    await executeSilently(() async {
      user.value = await _userRepo.getProfile();
      await SPManager.saveLoginDetails(
        userId: user.value!.id,
        name: user.value!.name,
        email: SPManager.getUserEmail().isNotEmpty
            ? SPManager.getUserEmail()
            : user.value!.email,
        photoUrl: user.value!.photoUrl,
        isAdmin: user.value!.isAdmin,
      );
    });
  }

  Future<void> updateProfile(UserModel updated) async {
    await executeWithLoading(() async {
      final saved = await _userRepo.updateProfile(
        name: updated.name,
        phone: updated.phone,
        photoUrl: updated.photoUrl,
        gender: updated.gender,
        dateOfBirth: updated.dateOfBirth,
      );
      user.value = saved;
      await SPManager.setUserName(saved.name);
      await SPManager.setUserPhotoUrl(saved.photoUrl);
    });
  }

  UserModel _guestUser() => UserModel(
        id: 'guest',
        name: 'Guest',
        email: '',
        phone: '',
        photoUrl: '',
        gender: '',
        dateOfBirth: '',
        createdAt: '',
      );
}
