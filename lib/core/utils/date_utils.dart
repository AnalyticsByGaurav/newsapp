class TimeAgoHelper {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'अभी';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} मिनट पहले';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} घंटे पहले';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} दिन पहले';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks सप्ताह पहले';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months महीने पहले';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years वर्ष पहले';
    }
  }

  static String formatDate(DateTime dateTime) {
    const months = [
      'जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल',
      'मई', 'जून', 'जुलाई', 'अगस्त',
      'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }
}
