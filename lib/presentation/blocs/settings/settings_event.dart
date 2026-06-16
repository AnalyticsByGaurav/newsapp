import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class ToggleDarkModeEvent extends SettingsEvent {
  const ToggleDarkModeEvent();
}

class ToggleNotificationsEvent extends SettingsEvent {
  const ToggleNotificationsEvent();
}

class ChangeFontSizeEvent extends SettingsEvent {
  final double fontSize;
  const ChangeFontSizeEvent(this.fontSize);
  @override
  List<Object?> get props => [fontSize];
}

class ClearCacheEvent extends SettingsEvent {
  const ClearCacheEvent();
}
