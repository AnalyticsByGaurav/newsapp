# Security Report — Namasteram News API

## Overview

This document covers security measures implemented in the Namasteram News PHP API and Flutter app.

---

## 1. API Key Authentication

### Implementation
- API keys are stored as SHA-256 hashes in the database
- Never stored in plaintext
- Keys are transmitted via `X-API-Key` header (not URL parameters)

### Validation
```php
$inputKey = $_SERVER['HTTP_X_API_KEY'] ?? '';
$hash = hash('sha256', $inputKey);
// Compare against stored hash using constant-time comparison
if (!hash_equals($storedHash, $hash)) {
    http_response_code(401);
    exit(json_encode(['success' => false, 'message' => 'Unauthorized']));
}
```

---

## 2. Rate Limiting

### Per API Key
- 60 requests per minute
- Tracked via `api_requests` table in MySQL
- Sliding window algorithm

### Per IP Address
- 100 requests per minute
- Stored in Redis/APCu (fallback: MySQL)
- Returns HTTP 429 with `Retry-After: 60` header

---

## 3. Input Validation

### All inputs are validated before processing:
```php
// Search query
$q = trim(strip_tags($_GET['q'] ?? ''));
if (strlen($q) < 2 || strlen($q) > 100) {
    throw new ValidationException('Invalid query length');
}

// Pagination
$page = max(1, (int)($_GET['page'] ?? 1));
$perPage = min(50, max(1, (int)($_GET['per_page'] ?? 15)));
```

---

## 4. SQL Injection Prevention

All database queries use PDO prepared statements:

```php
$stmt = $pdo->prepare('SELECT * FROM articles WHERE slug = ? AND status = "published"');
$stmt->execute([$slug]);
```

**No raw SQL string concatenation is used anywhere.**

---

## 5. XSS Prevention

### Output Escaping
All user-generated content is escaped before output:
```php
function clean($str): string {
    return htmlspecialchars($str, ENT_QUOTES | ENT_HTML5, 'UTF-8');
}
```

### Content Security Policy
API responses include:
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
```

---

## 6. CAPTCHA (Stateless HMAC)

The captcha system is fully stateless — no session or database storage required.

### How it works:
1. Server generates a math question: `a + b = ?`
2. Answer is HMAC-signed with a secret key + timestamp:
   ```php
   $answer = $a + $b;
   $token = hash_hmac('sha256', "$answer:" . floor(time()/600), SECRET_KEY);
   ```
3. Client submits answer + token with comment
4. Server verifies: recomputes expected HMAC, checks time window (10 min)

### Security Properties:
- Cannot be forged without the secret key
- Expires after 10 minutes (2 time windows checked)
- One-use (replay attacks fail due to rate limiting)

---

## 7. Comment Spam Protection

### Honeypot Field
A hidden field `website` is included in forms. Bots fill it; humans don't:
```html
<input type="text" name="website" style="display:none" tabindex="-1">
```

```php
if (!empty($_POST['website'])) {
    // Silently reject — bot detected
    return ['success' => true, 'message' => 'Thank you'];
}
```

### Disposable Email Detection
Common disposable email domains are checked:
```php
$disposableDomains = ['mailnull.com', 'guerrillamail.com', 'temp-mail.org', ...];
$domain = strtolower(explode('@', $email)[1] ?? '');
if (in_array($domain, $disposableDomains)) {
    throw new ValidationException('Disposable emails not allowed');
}
```

### Content Filtering
- Minimum content length: 10 characters
- Maximum content length: 2000 characters
- URL spam detection (max 2 links per comment)
- Duplicate content detection (same content from same IP within 1 hour)

---

## 8. HTTPS Enforcement (Production)

For production deployment, enforce HTTPS via `.htaccess`:
```apache
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

---

## 9. CORS Configuration

API allows only configured origins:
```php
$allowedOrigins = ['http://localhost', 'https://www.namasteram.com'];
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowedOrigins)) {
    header("Access-Control-Allow-Origin: $origin");
}
```

---

## 10. Flutter App Security

### Certificate Pinning (Recommended for Production)
```dart
// In dio_client.dart - add certificate pinning
(_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => false;
    return client;
};
```

### API Key Storage
- API key in `api_constants.dart` is compiled into the app binary
- For higher security, retrieve key from secure endpoint at startup
- Use Flutter Secure Storage for runtime key caching

### Network Security Config (Android)
`android/app/src/main/res/xml/network_security_config.xml`:
```xml
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">namasteram.com</domain>
    </domain-config>
</network-security-config>
```
