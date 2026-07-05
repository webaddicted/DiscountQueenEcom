import 'package:portfolio/global/constant/sp_const.dart';
import 'package:portfolio/global/sp/sp_helper.dart';

class SPManager {
  SPManager._();

  // Theme
  static Future<bool> setTheme(bool isDark) => SPHelper.setPreference(SPConst.isThemeDark, isDark);
  static bool getTheme() => SPHelper.getPreference<bool>(SPConst.isThemeDark, false)!;

  // Onboarding
  static Future<bool> setOnboardingShown(bool shown) => SPHelper.setPreference(SPConst.isOnBoardingShown, shown);
  static bool isOnboardingShown() => SPHelper.getPreference<bool>(SPConst.isOnBoardingShown, false)!;

  // Auth
  static Future<bool> setLoggedIn(bool value) => SPHelper.setPreference(SPConst.isLoggedIn, value);
  static bool isLoggedIn() => SPHelper.getPreference<bool>(SPConst.isLoggedIn, false)!;
  static Future<bool> setAccessToken(String token) => SPHelper.setPreference(SPConst.accessToken, token);
  static String getAccessToken() => SPHelper.getPreference<String>(SPConst.accessToken, '')!;
  static Future<bool> setRefreshToken(String token) => SPHelper.setPreference(SPConst.refreshToken, token);
  static String getRefreshToken() => SPHelper.getPreference<String>(SPConst.refreshToken, '')!;

  // User
  static Future<bool> setUserId(String id) => SPHelper.setPreference(SPConst.userId, id);
  static String getUserId() => SPHelper.getPreference<String>(SPConst.userId, '')!;
  static Future<bool> setUserName(String name) => SPHelper.setPreference(SPConst.userName, name);
  static String getUserName() => SPHelper.getPreference<String>(SPConst.userName, '')!;
  static Future<bool> setUserEmail(String email) => SPHelper.setPreference(SPConst.userEmail, email);
  static String getUserEmail() => SPHelper.getPreference<String>(SPConst.userEmail, '')!;
  static Future<bool> setUserPhotoUrl(String url) => SPHelper.setPreference(SPConst.userPhotoUrl, url);
  static String getUserPhotoUrl() => SPHelper.getPreference<String>(SPConst.userPhotoUrl, '')!;

  static Future<bool> setUserAdmin(bool value) =>
      SPHelper.setPreference(SPConst.isUserAdmin, value);

  static bool isUserAdmin() => SPHelper.getPreference<bool>(SPConst.isUserAdmin, false)!;

  // Batch login
  static Future<bool> saveLoginDetails({
    required String userId,
    required String name,
    required String email,
    String photoUrl = '',
    bool isAdmin = false,
  }) async {
    return await SPHelper.setBatch({
      SPConst.isLoggedIn: true,
      SPConst.userId: userId,
      SPConst.userName: name,
      SPConst.userEmail: email,
      SPConst.userPhotoUrl: photoUrl,
      SPConst.isUserAdmin: isAdmin,
    });
  }

  static Future<bool> clearLoginDetails() async {
    await SPHelper.removeKey(SPConst.isLoggedIn);
    await SPHelper.removeKey(SPConst.accessToken);
    await SPHelper.removeKey(SPConst.refreshToken);
    await SPHelper.removeKey(SPConst.userId);
    await SPHelper.removeKey(SPConst.userName);
    await SPHelper.removeKey(SPConst.userEmail);
    await SPHelper.removeKey(SPConst.userPhotoUrl);
    await SPHelper.removeKey(SPConst.isUserAdmin);
    return true;
  }

  static Map<String, dynamic> getLoginDetails() {
    return SPHelper.getBatch(
      [
        SPConst.isLoggedIn,
        SPConst.userId,
        SPConst.userName,
        SPConst.userEmail,
        SPConst.userPhotoUrl,
        SPConst.isUserAdmin,
      ],
      {
        SPConst.isLoggedIn: false,
        SPConst.userId: '',
        SPConst.userName: '',
        SPConst.userEmail: '',
        SPConst.userPhotoUrl: '',
        SPConst.isUserAdmin: false,
      },
    );
  }

  // App settings
  static Future<bool> setLanguage(String lang) => SPHelper.setPreference(SPConst.appLanguage, lang);
  static String getLanguage() => SPHelper.getPreference<String>(SPConst.appLanguage, 'en')!;
  static Future<bool> setNotificationsEnabled(bool enabled) => SPHelper.setPreference(SPConst.notificationsEnabled, enabled);
  static bool getNotificationsEnabled() => SPHelper.getPreference<bool>(SPConst.notificationsEnabled, true)!;

  // Batch app settings
  static Future<bool> setAppSettings({required bool isDarkTheme, required bool hasSeenOnboarding}) async {
    return await SPHelper.setBatch({SPConst.isThemeDark: isDarkTheme, SPConst.isOnBoardingShown: hasSeenOnboarding});
  }

  static Map<String, dynamic> getAppSettings() {
    return SPHelper.getBatch(
      [SPConst.isThemeDark, SPConst.isOnBoardingShown],
      {SPConst.isThemeDark: false, SPConst.isOnBoardingShown: false},
    );
  }

  // Data load time
  static Future<bool> setLastDataLoadTime(int timestamp) => SPHelper.setPreference(SPConst.lastDataLoadTime, timestamp);
  static int getLastDataLoadTime() => SPHelper.getPreference<int>(SPConst.lastDataLoadTime, 0)!;

  // Keys management
  static Future<Set<String>> getAllKeys() async => SPHelper.getAllKeys();
  static Future<bool> removeKeys(String keyName) async => await SPHelper.removeKey(keyName);
  static Future<bool> clearPref() async => await SPHelper.clearAll();
}
