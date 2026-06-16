# Namasteram News API Documentation

**Base URL:** `http://your-server/newsportal/api/v1`  
**Authentication:** `X-API-Key: <your_api_key>` (header required on all requests)

---

## Authentication

All API requests must include the API key in the request header:

```
X-API-Key: your_generated_api_key_here
```

---

## Rate Limiting

- 60 requests per minute per API key
- 100 requests per minute per IP address
- Exceeding limits returns HTTP 429 with `Retry-After` header

---

## Error Codes

| Code | Description |
|------|-------------|
| 200  | Success |
| 400  | Bad request / validation error |
| 401  | Unauthorized (missing or invalid API key) |
| 403  | Forbidden |
| 404  | Resource not found |
| 429  | Too many requests (rate limited) |
| 500  | Internal server error |

**Error Response Format:**
```json
{
  "success": false,
  "message": "Error description here"
}
```

---

## Endpoints

### 1. GET /latest

Fetch latest news articles with pagination.

**Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| page | int | 1 | Page number |
| per_page | int | 15 | Articles per page (max 50) |
| category | string | null | Filter by category slug |

**Request:**
```
GET /api/v1/latest?page=1&per_page=15
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "समाचार शीर्षक",
      "slug": "samachar-shirshak",
      "excerpt": "संक्षिप्त विवरण",
      "author": "Author Name",
      "category": "राजनीति",
      "category_slug": "politics",
      "img": "http://server/uploads/image.jpg",
      "webp": "http://server/uploads/image.webp",
      "img_w": 1200,
      "img_h": 630,
      "alt": "Image description",
      "tags": ["tag1", "tag2"],
      "published_at": "2025-06-16T10:00:00Z",
      "views": 1234
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 15,
    "total": 150
  }
}
```

---

### 2. GET /categories

Fetch all categories.

**Request:**
```
GET /api/v1/categories
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "राजनीति",
      "slug": "politics",
      "count": 45
    }
  ]
}
```

---

### 3. GET /article/{slug}

Fetch a single article by slug.

**Request:**
```
GET /api/v1/article/samachar-shirshak
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "समाचार शीर्षक",
    "slug": "samachar-shirshak",
    "excerpt": "संक्षिप्त विवरण",
    "content": "<p>पूर्ण लेख सामग्री HTML में</p>",
    "img": "http://server/uploads/image.jpg",
    "webp": "http://server/uploads/image.webp",
    "img_w": 1200,
    "img_h": 630,
    "alt": "Image description",
    "author": "Author Name",
    "category": "राजनीति",
    "category_slug": "politics",
    "tags": ["tag1", "tag2"],
    "published_at": "2025-06-16T10:00:00Z",
    "views": 1234,
    "related": [
      {
        "id": 2,
        "title": "संबंधित लेख",
        "slug": "sambandht-lekh",
        "img": "...",
        "published_at": "2025-06-15T10:00:00Z"
      }
    ]
  }
}
```

---

### 4. GET /search

Search articles.

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| q | string | Yes | Search query (min 2 chars) |
| page | int | No | Page number (default 1) |

**Request:**
```
GET /api/v1/search?q=modi&page=1
X-API-Key: your_key
```

**Response:** Same format as `/latest`

---

### 5. GET /related/{slug}

Get related articles for a given article slug.

**Request:**
```
GET /api/v1/related/samachar-shirshak
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": [ /* array of article objects */ ]
}
```

---

### 6. GET /web-stories

Fetch web stories list.

**Parameters:** `page` (default 1)

**Request:**
```
GET /api/v1/web-stories?page=1
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "स्टोरी शीर्षक",
      "slug": "story-slug",
      "thumbnail": "http://server/uploads/thumb.jpg",
      "slides_count": 7
    }
  ],
  "meta": { "page": 1, "per_page": 15, "total": 30 }
}
```

---

### 7. GET /shorts

Fetch short videos.

**Parameters:** `page` (default 1)

**Request:**
```
GET /api/v1/shorts?page=1
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "वीडियो शीर्षक",
      "slug": "video-slug",
      "video_url": "http://server/uploads/video.mp4",
      "thumbnail": "http://server/uploads/thumb.jpg",
      "duration": 60
    }
  ],
  "meta": { "page": 1, "per_page": 15, "total": 50 }
}
```

---

### 8. GET /settings

Fetch site settings.

**Request:**
```
GET /api/v1/settings
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": {
    "site_name": "Namasteram News",
    "tagline": "आपका विश्वसनीय समाचार स्रोत",
    "logo": "http://server/uploads/logo.png",
    "favicon": "http://server/favicon.ico",
    "primary_color": "#E53935",
    "contact_email": "info@namasteram.com"
  }
}
```

---

### 9. POST /comments

Submit a comment on an article.

**Request:**
```
POST /api/v1/comments
X-API-Key: your_key
Content-Type: application/json

{
  "article_id": 1,
  "name": "Visitor Name",
  "email": "visitor@example.com",
  "content": "Great article!",
  "captcha": "42",
  "captcha_token": "hmac_token_from_captcha_endpoint"
}
```

**Response:**
```json
{
  "success": true,
  "message": "आपकी टिप्पणी सफलतापूर्वक पोस्ट की गई!"
}
```

---

### 10. GET /captcha

Fetch a math captcha challenge.

**Request:**
```
GET /api/v1/captcha
X-API-Key: your_key
```

**Response:**
```json
{
  "success": true,
  "data": {
    "question": "15 + 7 = ?",
    "token": "hmac_signed_token_here"
  }
}
```

The `token` is an HMAC-signed value that must be sent back with the comment submission. It encodes the correct answer and expires after 10 minutes.

---

## Response Conventions

- All responses are JSON
- Success responses: `{"success": true, "data": ...}`
- Error responses: `{"success": false, "message": "..."}`
- Timestamps are ISO 8601 format (UTC)
- Image URLs are absolute
