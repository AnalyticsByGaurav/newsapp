import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  CacheEntry({required this.data, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toMap() => {
        'data': data,
        'expiresAt': expiresAt.toIso8601String(),
      };

  factory CacheEntry.fromMap(Map<dynamic, dynamic> map) => CacheEntry(
        data: map['data'],
        expiresAt: DateTime.parse(map['expiresAt'] as String),
      );
}

class CacheManager {
  final Box _metaBox;

  CacheManager(this._metaBox);

  Future<void> set(String key, dynamic value, {int ttlSeconds = AppConstants.newsCacheTtl}) async {
    final entry = {
      'data': value,
      'expiresAt': DateTime.now().add(Duration(seconds: ttlSeconds)).toIso8601String(),
    };
    await _metaBox.put(key, entry);
  }

  T? get<T>(String key) {
    final raw = _metaBox.get(key);
    if (raw == null) return null;

    try {
      final map = raw as Map;
      final expiresAt = DateTime.parse(map['expiresAt'] as String);
      if (DateTime.now().isAfter(expiresAt)) {
        _metaBox.delete(key);
        return null;
      }
      return map['data'] as T?;
    } catch (_) {
      _metaBox.delete(key);
      return null;
    }
  }

  Future<void> delete(String key) async {
    await _metaBox.delete(key);
  }

  Future<void> clear() async {
    await _metaBox.clear();
  }

  bool has(String key) {
    final raw = _metaBox.get(key);
    if (raw == null) return false;
    try {
      final map = raw as Map;
      final expiresAt = DateTime.parse(map['expiresAt'] as String);
      return !DateTime.now().isAfter(expiresAt);
    } catch (_) {
      return false;
    }
  }
}
