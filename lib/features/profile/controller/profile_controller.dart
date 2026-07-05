import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class ProfileController extends BaseController {
  final user = Rx<UserModel?>(null);

  @override
  void onControllerInit() {
    loadProfile();
  }

  void loadProfile() {
    user.value = _currentUser();
  }

  void updateProfile(UserModel updated) {
    user.value = updated;
  }

  UserModel _currentUser() {
    if (SPManager.isLoggedIn()) {
      return UserModel(
        id: SPManager.getUserId(),
        name: SPManager.getUserName().isNotEmpty
            ? SPManager.getUserName()
            : 'Shopper',
        email: SPManager.getUserEmail(),
        phone: '+919876543210',
        photoUrl: SPManager.getUserPhotoUrl(),
        gender: '',
        dateOfBirth: '',
        createdAt: '',
      );
    }
    return UserModel(
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
}
