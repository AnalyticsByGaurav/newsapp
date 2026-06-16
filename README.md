# Namasteram News — Flutter App

A production-ready Hindi news app built with Flutter, connecting to the Namasteram News PHP REST API.

## Features

- Latest news with infinite scroll
- Category-based filtering
- Full article reading with HTML content
- Web Stories viewer
- Short Videos (TikTok-style)
- Search with debouncing
- Bookmarks (offline)
- Push notifications (Firebase)
- Dark mode + font size settings
- Hindi (Devanagari) UI throughout
- Offline caching with Hive

## Quick Start

### 1. Configure API Connection

Edit `lib/core/constants/api_constants.dart`:

```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2/newsportal/api/v1';

// Physical Device (replace with your IP)
// static const String baseUrl = 'http://192.168.1.100/newsportal/api/v1';

// Your API Key from admin panel
static const String apiKey = 'YOUR_KEY_HERE';
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
# Debug mode
flutter run

# Release APK
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

## Architecture

```
lib/
├── core/
│   ├── constants/      # API and app constants
│   ├── di/             # GetIt dependency injection
│   ├── errors/         # Exception types
│   ├── network/        # Dio HTTP client + interceptors
│   ├── theme/          # Material 3 light/dark themes
│   └── utils/          # HTML parser, date formatter, cache manager
├── domain/
│   ├── entities/       # Pure Dart models
│   ├── repositories/   # Abstract interfaces
│   └── usecases/       # Business logic
├── data/
│   ├── models/         # JSON serialization
│   ├── datasources/    # Remote (Dio) + Local (Hive)
│   └── repositories/   # Implementation with offline fallback
└── presentation/
    ├── blocs/          # BLoC state management
    ├── pages/          # Screen widgets
    ├── router/         # GoRouter navigation
    └── widgets/        # Reusable UI components
```

## Tech Stack

| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| dio | HTTP client |
| hive_flutter | Local storage + caching |
| cached_network_image | Image caching with WebP support |
| go_router | Navigation |
| firebase_messaging | Push notifications |
| share_plus | Social sharing |
| video_player | Short video playback |
| visibility_detector | Auto-play on scroll |
| connectivity_plus | Network status |
| get_it | Dependency injection |

## Push Notifications

1. Create Firebase project at https://console.firebase.google.com
2. Add Android app with `com.namasteram.news`
3. Download `google-services.json` → place in `android/app/`
4. Uncomment Firebase initialization in `lib/main.dart`

## Documentation

- `docs/API_DOCUMENTATION.md` — API reference
- `docs/DEPLOYMENT_GUIDE.md` — Server setup and build instructions
- `docs/SECURITY_REPORT.md` — Security measures
