class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://imgaurav.in/newsportal/api/v1';
  static const String apiKey = 'nm_live_6231eb48446c770c6a21fbd7042dc5c1'; // ← Step 1 ka key yahan paste karo

  static const String latest = '/news';         // server: /news
  static const String categories = '/categories';
  static const String article = '/article';
  static const String search = '/search';
  static const String related = '/related';
  static const String webStories = '/stories';  // server: /stories
  static const String shorts = '/shorts';
  static const String settings = '/settings';
  static const String comments = '/comments';
  static const String captcha = '/captcha';

  static const String uploadsUrl = 'https://imgaurav.in/newsportal/uploads/';

  static const int connectTimeout = 15;
  static const int receiveTimeout = 30;
  static const int defaultPerPage = 15;
}
