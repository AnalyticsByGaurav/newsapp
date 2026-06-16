import 'package:equatable/equatable.dart';
import '../../../domain/entities/site_settings.dart';
import '../../../core/constants/app_constants.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final double fontSize;
  final SiteSettings? siteSettings;
  final bool isLoading;

  const SettingsState({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.fontSize = AppConstants.fontSizeMedium,
    this.siteSettings,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    double? fontSize,
    SiteSettings? siteSettings,
    bool? isLoading,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      fontSize: fontSize ?? this.fontSize,
      siteSettings: siteSettings ?? this.siteSettings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        notificationsEnabled,
        fontSize,
        siteSettings,
        isLoading,
      ];
}
