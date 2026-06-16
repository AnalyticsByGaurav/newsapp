class AppConstants {
  AppConstants._();

  static const String appName = 'Namasteram News';
  static const String appNameHi = 'नमस्तेराम न्यूज़';
  static const String appTagline = 'आपका विश्वसनीय समाचार स्रोत';

  // Hive box names
  static const String hiveBoxArticles = 'articles_box';
  static const String hiveBoxBookmarks = 'bookmarks_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveBoxCategories = 'categories_box';
  static const String hiveBoxNotifications = 'notifications_box';

  // Cache TTL in seconds
  static const int newsCacheTtl = 300; // 5 minutes
  static const int categoryCacheTtl = 3600; // 1 hour
  static const int articleCacheTtl = 600; // 10 minutes

  // Settings preference keys
  static const String prefsDarkMode = 'dark_mode';
  static const String prefsNotifications = 'notifications_enabled';
  static const String prefsFontSize = 'font_size';
  static const String prefsApiKey = 'api_key';
  static const String prefsPrimaryColor = 'primary_color';
  static const String prefsSiteName = 'site_name';

  // Notification channel
  static const String notificationChannelId = 'namasteram_news_channel';
  static const String notificationChannelName = 'Namasteram News';
  static const String notificationChannelDesc = 'Breaking news and updates';

  // Default primary color
  static const String defaultPrimaryColor = '#E53935';

  // Font sizes
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
}
