import 'package:flutter/foundation.dart';
import 'package:portfolio/global/utils/app_utils.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    if (kDebugMode) printLog('AnalyticsService', 'initialized');
  }

  // Screen tracking
  void logScreenView(String screenName, {String? screenClass}) {
    _log('screen_view', {'screen_name': screenName, 'screen_class': screenClass ?? screenName});
  }

  // Auth events
  void logLogin({String? method}) => _log('login', {'method': method ?? 'email'});
  void logSignUp({String? method}) => _log('sign_up', {'method': method ?? 'email'});
  void logLogout() => _log('logout');

  // Content events
  void logSearch(String query) => _log('search', {'query': query});
  void logShare(String contentType, String itemId) =>
      _log('share', {'content_type': contentType, 'item_id': itemId});
  void logSelectContent(String contentType, String itemId) =>
      _log('select_content', {'content_type': contentType, 'item_id': itemId});

  // Portfolio-specific events
  void logProjectViewed(String projectId, String projectName) =>
      _log('project_viewed', {'project_id': projectId, 'project_name': projectName});
  void logContactSubmitted() => _log('contact_submitted');
  void logResumeDownloaded() => _log('resume_downloaded');
  void logProfileViewed() => _log('profile_viewed');
  void logBlogRead(String blogId, String blogTitle) =>
      _log('blog_read', {'blog_id': blogId, 'blog_title': blogTitle});
  void logSkillsViewed() => _log('skills_viewed');
  void logExperienceViewed() => _log('experience_viewed');

  // App lifecycle
  void logAppOpen() => _log('app_open');
  void logTutorialBegin() => _log('tutorial_begin');
  void logTutorialComplete() => _log('tutorial_complete');

  // User properties
  void setUserId(String userId) {
    if (kDebugMode) printLog('AnalyticsService', 'setUserId: $userId');
  }

  void setUserProperty(String name, String value) {
    if (kDebugMode) printLog('AnalyticsService', 'setUserProperty: $name=$value');
  }

  void resetAnalyticsData() {
    if (kDebugMode) printLog('AnalyticsService', 'resetAnalyticsData');
  }

  void _log(String eventName, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      printLog('AnalyticsService', 'Event: $eventName ${params ?? ''}');
    }
  }
}
