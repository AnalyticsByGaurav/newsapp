import 'package:flutter/material.dart';

class NmErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const NmErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.error.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('फिर से प्रयास करें'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NmNoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NmNoInternetWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return NmErrorWidget(
      message: 'इंटरनेट कनेक्शन उपलब्ध नहीं है।\nकृपया अपना नेटवर्क जांचें।',
      onRetry: onRetry,
      icon: Icons.wifi_off_rounded,
    );
  }
}

class NmEmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const NmEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
