import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../blocs/settings/settings_event.dart';
import '../../blocs/settings/settings_state.dart';
import '../../../core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('सेटिंग्स')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              // Appearance section
              _SectionHeader(title: 'प्रदर्शन'),
              SwitchListTile(
                title: const Text('डार्क मोड'),
                subtitle: const Text('रात में पढ़ने के लिए'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: state.isDarkMode,
                onChanged: (_) => context.read<SettingsBloc>().add(const ToggleDarkModeEvent()),
              ),
              ListTile(
                leading: const Icon(Icons.text_fields_outlined),
                title: const Text('फ़ॉन्ट आकार'),
                subtitle: Text(_fontSizeLabel(state.fontSize)),
                trailing: SizedBox(
                  width: 160,
                  child: Slider(
                    value: state.fontSize,
                    min: AppConstants.fontSizeSmall,
                    max: AppConstants.fontSizeLarge,
                    divisions: 2,
                    onChanged: (v) => context.read<SettingsBloc>().add(ChangeFontSizeEvent(v)),
                  ),
                ),
              ),
              const Divider(),
              // Notifications section
              _SectionHeader(title: 'सूचनाएं'),
              SwitchListTile(
                title: const Text('पुश नोटिफिकेशन'),
                subtitle: const Text('ब्रेकिंग न्यूज़ की सूचनाएं'),
                secondary: const Icon(Icons.notifications_outlined),
                value: state.notificationsEnabled,
                onChanged: (_) => context.read<SettingsBloc>().add(const ToggleNotificationsEvent()),
              ),
              const Divider(),
              // About section
              _SectionHeader(title: 'जानकारी'),
              if (state.siteSettings != null) ...[
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('साइट नाम'),
                  subtitle: Text(state.siteSettings!.siteName),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('संपर्क ईमेल'),
                  subtitle: Text(state.siteSettings!.contactEmail),
                ),
              ],
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('ऐप संस्करण'),
                subtitle: const Text('1.0.0'),
              ),
              const Divider(),
              // Cache section
              _SectionHeader(title: 'कैश'),
              ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('कैश साफ़ करें'),
                subtitle: const Text('अस्थायी डेटा हटाएं'),
                onTap: () => _showClearCacheDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  String _fontSizeLabel(double size) {
    if (size <= AppConstants.fontSizeSmall) return 'छोटा';
    if (size >= AppConstants.fontSizeLarge) return 'बड़ा';
    return 'मध्यम';
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('कैश साफ़ करें?'),
        content: const Text('सभी अस्थायी डेटा हटा दिया जाएगा।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('रद्द करें'),
          ),
          FilledButton(
            onPressed: () {
              context.read<SettingsBloc>().add(const ClearCacheEvent());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('कैश साफ़ हो गया!')),
              );
            },
            child: const Text('साफ़ करें'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
