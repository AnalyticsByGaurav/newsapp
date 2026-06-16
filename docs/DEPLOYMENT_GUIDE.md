# Deployment Guide — Namasteram News Flutter App

## Prerequisites

- XAMPP (Apache + MySQL + PHP 8.1+)
- Flutter SDK 3.19+
- Android Studio / VS Code
- Java JDK 17+

---

## 1. PHP Server Setup (XAMPP)

### Install XAMPP
1. Download XAMPP from https://www.apachefriends.org/
2. Install to `C:\xampp\`
3. Start Apache and MySQL from XAMPP Control Panel

### Copy Project Files
```bash
# Place newsportal in htdocs
C:\xampp\htdocs\newsportal\
```

### Enable URL Rewriting
Edit `C:\xampp\apache\conf\httpd.conf`:
```apache
AllowOverride All
```

Restart Apache after change.

---

## 2. Database Setup

### Create Database
```sql
CREATE DATABASE bestwnqo_newsportal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Run Migration
```bash
mysql -u root -p bestwnqo_newsportal < C:\xampp\htdocs\newsportal\migrate_api.sql
```

Or via phpMyAdmin:
1. Open http://localhost/phpmyadmin
2. Select `bestwnqo_newsportal`
3. Click "Import" → choose `migrate_api.sql`

---

## 3. Generate API Key

### Via Admin Panel
1. Open http://localhost/newsportal/admin
2. Login with admin credentials
3. Navigate to **API Management**
4. Click **Generate New Key**
5. Copy the generated key

### Manual via MySQL
```sql
INSERT INTO api_keys (name, api_key, is_active, rate_limit, created_at)
VALUES ('Flutter App', SHA2(CONCAT(RAND(), NOW()), 256), 1, 60, NOW());

SELECT api_key FROM api_keys ORDER BY id DESC LIMIT 1;
```

---

## 4. Configure Flutter App

Open `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  // For Android Emulator (use 10.0.2.2 for localhost)
  static const String baseUrl = 'http://10.0.2.2/newsportal/api/v1';
  
  // For Physical Device (use your machine's IP)
  // static const String baseUrl = 'http://192.168.1.100/newsportal/api/v1';
  
  // For Production
  // static const String baseUrl = 'https://www.namasteram.com/api/v1';
  
  static const String apiKey = 'YOUR_GENERATED_API_KEY';
}
```

---

## 5. Build Flutter App

### Install Dependencies
```bash
cd C:\xampp\htdocs\newsportal\flutter_app
flutter pub get
```

### Build Debug APK
```bash
flutter run --debug
```

### Build Release APK
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Bundle location: `build/app/outputs/bundle/release/app-release.aab`

---

## 6. Firebase Setup (Push Notifications)

### Create Firebase Project
1. Go to https://console.firebase.google.com
2. Create new project: "Namasteram News"
3. Add Android app with package ID: `com.namasteram.news`

### Download Config File
1. Download `google-services.json`
2. Place in: `android/app/google-services.json`

### Update android/build.gradle
```groovy
classpath 'com.google.gms:google-services:4.4.1'
```

### Update android/app/build.gradle
```groovy
apply plugin: 'com.google.gms.google-services'
```

### Enable Firebase in main.dart
Uncomment in `lib/main.dart`:
```dart
await Firebase.initializeApp();
await FirebaseMessaging.instance.requestPermission();
```

---

## 7. Signing the Release APK

### Create Keystore
```bash
keytool -genkey -v -keystore namasteram.jks -keyalg RSA -keysize 2048 -validity 10000 -alias namasteram
```

### Configure Signing in android/app/build.gradle
```groovy
signingConfigs {
    release {
        storeFile file("namasteram.jks")
        storePassword "your_store_password"
        keyAlias "namasteram"
        keyPassword "your_key_password"
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
    }
}
```

---

## 8. Network Configuration (Physical Device)

Find your machine's IP:
```bash
ipconfig  # Windows
ifconfig  # macOS/Linux
```

Update `api_constants.dart`:
```dart
static const String baseUrl = 'http://192.168.1.X/newsportal/api/v1';
```

Also allow network traffic in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<application android:usesCleartextTraffic="true" ...>
```
