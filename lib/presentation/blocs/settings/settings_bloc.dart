import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/usecases/get_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings _getSettings;
  final Box _settingsBox;

  SettingsBloc({required GetSettings getSettings, required Box settingsBox})
      : _getSettings = getSettings,
        _settingsBox = settingsBox,
        super(SettingsState(
          isDarkMode: false,
          notificationsEnabled: true,
          fontSize: AppConstants.fontSizeMedium,
        )) {
    on<LoadSettingsEvent>(_onLoad);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ChangeFontSizeEvent>(_onChangeFontSize);
    on<ClearCacheEvent>(_onClearCache);
    _loadLocalPrefs();
  }

  void _loadLocalPrefs() {
    final isDarkMode = _settingsBox.get(AppConstants.prefsDarkMode, defaultValue: false) as bool;
    final notifications = _settingsBox.get(AppConstants.prefsNotifications, defaultValue: true) as bool;
    final fontSize = (_settingsBox.get(AppConstants.prefsFontSize, defaultValue: AppConstants.fontSizeMedium) as num).toDouble();
    emit(state.copyWith(
      isDarkMode: isDarkMode,
      notificationsEnabled: notifications,
      fontSize: fontSize,
    ));
  }

  Future<void> _onLoad(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _getSettings();
      emit(state.copyWith(siteSettings: settings, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.isDarkMode;
    await _settingsBox.put(AppConstants.prefsDarkMode, newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.notificationsEnabled;
    await _settingsBox.put(AppConstants.prefsNotifications, newValue);
    emit(state.copyWith(notificationsEnabled: newValue));
  }

  Future<void> _onChangeFontSize(
    ChangeFontSizeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsBox.put(AppConstants.prefsFontSize, event.fontSize);
    emit(state.copyWith(fontSize: event.fontSize));
  }

  Future<void> _onClearCache(
    ClearCacheEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // Cache clearing handled by the local data source via DI
  }
}
