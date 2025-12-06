# 🔌 API Integration Guide

## Overview

The BrainRush mobile app connects to the BrainRash API at `https://brainrash.com/api`. All API endpoints are accessed through the `APIClient` class.

## API Base Configuration

```swift
// BrainRush/BrainRush/Core/Config/AppConfig.swift
static let apiBaseURL = "https://brainrash.com/api"
```

## Authentication

### Supabase Auth Integration

The app uses Supabase Auth for authentication. Update `AuthService.swift` to integrate:

```swift
import Supabase

class AuthService: ObservableObject {
    let supabase: SupabaseClient
    
    init() {
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: AppConfig.supabaseURL)!,
            supabaseKey: AppConfig.supabaseAnonKey
        )
    }
    
    func signIn(email: String, password: String) async throws {
        let session = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        // Store session...
    }
}
```

### API Request Headers

All API requests include:

```swift
Authorization: Bearer {access_token}
X-Client-App: {bundle_id}
X-Platform: ios
Content-Type: application/json
```

## API Endpoints

### Mobile-Optimized Endpoints

All mobile endpoints are prefixed with `/api/mobile`:

#### Authentication
- `POST /api/mobile/auth/sign-in`
- `POST /api/mobile/auth/sign-up`
- `POST /api/mobile/auth/sign-out`
- `POST /api/mobile/auth/refresh`

#### Dashboard
- `GET /api/mobile/dashboard`
  - Returns: `DashboardData`

#### Courses
- `GET /api/mobile/courses` - List courses
- `GET /api/mobile/courses/:id` - Course details
- `POST /api/mobile/courses/:id/enroll` - Enroll in course

#### Lessons
- `GET /api/mobile/lessons/:id` - Lesson details
- `POST /api/mobile/lessons/:id/complete` - Mark complete
- `GET /api/mobile/lessons/:id/download` - Download for offline

#### Quizzes
- `GET /api/mobile/quizzes/:id` - Quiz details
- `POST /api/mobile/quizzes/:id/submit` - Submit quiz
- `GET /api/mobile/quizzes/:id/results` - Quiz results

#### Gamification
- `GET /api/mobile/xp` - User XP data
- `GET /api/mobile/achievements` - User achievements
- `GET /api/mobile/challenges` - Active challenges
- `GET /api/mobile/leaderboards` - Leaderboard data

#### Economy
- `GET /api/mobile/economy` - Token balance
- `GET /api/mobile/economy/transactions` - Transaction history
- `GET /api/mobile/swag` - Swag items
- `POST /api/mobile/swag/:id/purchase` - Purchase item

#### Social
- `GET /api/mobile/forums` - Forums list
- `GET /api/mobile/forums/:id/threads` - Forum threads
- `GET /api/mobile/study-groups` - Study groups
- `GET /api/mobile/messages` - Conversations

#### AI
- `POST /api/mobile/ai/tutor` - Send AI message
- `GET /api/mobile/ai/tutor/history` - Chat history
- `GET /api/mobile/ai/tutor/quota` - Usage quota
- `GET /api/mobile/ai/study-planner` - Study schedule

#### Certificates
- `GET /api/mobile/certificates` - User certificates
- `GET /api/mobile/certificates/:id` - Certificate details
- `GET /api/mobile/certificates/:id/download` - PDF download

#### Brain Profile
- `GET /api/mobile/brain-profile` - Current profile
- `POST /api/mobile/brain-profile/create` - Submit assessment

## Response Format

All API responses follow this format:

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message",
  "errors": []
}
```

Error responses:
```json
{
  "success": false,
  "error": "Error code",
  "message": "Human-readable error message",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

## Error Handling

The `APIClient` handles errors automatically:

```swift
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case unauthorized
    case serverError(Int, String?)
    case unknown
}
```

Usage in services:

```swift
do {
    let data: ResponseType = try await APIClient.shared.request(
        endpoint: "/mobile/endpoint",
        method: "GET",
        accessToken: token
    )
} catch APIError.unauthorized {
    // Handle auth error
} catch {
    // Handle other errors
}
```

## Offline Support

The app supports offline mode with local caching:

1. Content downloaded via `OfflineService`
2. Progress saved locally
3. Sync when connection restored via `OfflineService.syncOfflineChanges()`

## Push Notifications

Device tokens are registered via:

```
POST /api/mobile/push/register
{
  "device_token": "...",
  "device_type": "ios",
  "device_model": "...",
  "os_version": "..."
}
```

## Testing API Integration

### Development Environment

Use mock data initially (already implemented):

```swift
// Services return mock data when API is unavailable
// Switch to real API calls by uncommenting API code
```

### Testing Checklist

- [ ] Authentication flow
- [ ] Dashboard data loading
- [ ] Course enrollment
- [ ] Lesson progress tracking
- [ ] Quiz submission
- [ ] XP/achievement updates
- [ ] Offline sync
- [ ] Push notifications
- [ ] Deep linking
- [ ] Error handling

## Rate Limiting

API requests should respect rate limits:
- Mobile API Key required in headers
- Rate limits: 100 requests/minute per user
- Implement retry logic with exponential backoff

## Security

- All requests use HTTPS
- Tokens stored in Keychain
- API key in headers (from secure config)
- Input validation before sending requests

## Monitoring

Implement analytics for:
- API request success/failure rates
- Response times
- Error types and frequencies
- User engagement metrics
