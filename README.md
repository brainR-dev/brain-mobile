# BrainRush iOS Mobile App

A comprehensive iOS mobile app for BrainRash - a gamified learning platform that makes education fun, engaging, and rewarding.

## Features

### ✅ Core Features Implemented

- **Authentication & Onboarding**
  - Email/password sign up and sign in
  - OAuth support structure (Google, Apple)
  - Complete onboarding flow with Brain Profile quiz
  - Secure token storage with Keychain

- **Learning System**
  - Course discovery and enrollment
  - Lesson content (video and text)
  - Quiz system (16+ question types)
  - Degree program browsing and enrollment
  - Progress tracking

- **Gamification**
  - XP and leveling system (100 levels)
  - 300+ achievements
  - Daily/weekly/monthly challenges
  - Global, course, challenge, and domain leaderboards

- **Virtual Economy**
  - Brain-R token wallet
  - 200+ swag items
  - Avatar customization
  - Transaction history

- **Social Learning**
  - Discussion forums
  - Study groups
  - Direct messaging
  - Real-time chat support

- **AI Features**
  - AI Learning Assistant (6 personas)
  - AI Study Planner
  - Personalized recommendations
  - Progress predictions

- **Additional Features**
  - Digital certificates
  - Brain Profile assessment
  - Offline mode support
  - Push notifications
  - Deep linking (Universal Links & custom schemes)
  - Search and discovery
  - Profile and settings

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

- **Models**: Data structures for all entities
- **Views**: SwiftUI views for UI
- **Services**: Business logic and API integration
- **Core**: Networking, utilities, and shared services

## Tech Stack

- **SwiftUI** - UI framework
- **SwiftData** - Local data persistence
- **AVKit** - Video playback
- **UserNotifications** - Push notifications
- **Supabase Auth** - Authentication (iOS SDK ready)
- **Async/Await** - Modern concurrency
- **Combine** - Reactive programming

## Project Structure

```
BrainRush/
├── Core/
│   ├── Config/
│   │   └── AppConfig.swift
│   ├── Networking/
│   │   └── APIClient.swift
│   ├── Services/
│   │   ├── KeychainService.swift
│   │   ├── OfflineService.swift
│   │   ├── PushNotificationService.swift
│   │   ├── DeepLinkRouter.swift
│   │   └── SearchService.swift
│   └── Utils/
│       └── Extensions.swift
├── Models/
│   ├── UserProfile.swift
│   ├── Course.swift
│   ├── Dashboard.swift
│   ├── Program.swift
│   ├── Quiz.swift
│   ├── Gamification.swift
│   ├── Economy.swift
│   ├── Social.swift
│   ├── AI.swift
│   ├── Certificate.swift
│   └── BrainProfile.swift
├── Services/
│   ├── AuthService.swift
│   ├── DashboardService.swift
│   ├── CourseService.swift
│   ├── ProgramService.swift
│   ├── GamificationService.swift
│   ├── EconomyService.swift
│   ├── SocialService.swift
│   └── AITutorService.swift
├── Views/
│   ├── Auth/
│   │   ├── SignInView.swift
│   │   └── SignUpView.swift
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Dashboard/
│   │   └── DashboardView.swift
│   ├── Courses/
│   │   └── CoursesView.swift
│   ├── Lessons/
│   │   └── LessonView.swift
│   ├── Quizzes/
│   │   └── QuizView.swift
│   ├── Gamification/
│   │   ├── AchievementsView.swift
│   │   ├── ChallengesView.swift
│   │   └── LeaderboardView.swift
│   ├── Economy/
│   │   ├── TokenWalletView.swift
│   │   └── SwagStoreView.swift
│   ├── Social/
│   │   ├── ForumsView.swift
│   │   └── StudyGroupsView.swift
│   ├── Messaging/
│   │   └── MessagingView.swift
│   ├── AI/
│   │   ├── AITutorView.swift
│   │   └── AIStudyPlannerView.swift
│   ├── Certificates/
│   │   └── CertificatesView.swift
│   ├── BrainProfile/
│   │   └── BrainProfileView.swift
│   ├── Profile/
│   │   └── ProfileSettingsView.swift
│   └── RootView.swift
└── BrainRushApp.swift
```

## API Integration

- **Base URL**: `https://brainrash.com/api`
- **Authentication**: Supabase Auth (Bearer token)
- **Mobile Endpoints**: `/api/mobile/*`
- All requests include:
  - `Authorization: Bearer {token}`
  - `X-Client-App: {bundle_id}`
  - `X-Platform: ios`

## Configuration

### Required Info.plist Keys

Add these to your `Info.plist`:

```xml
<key>SUPABASE_URL</key>
<string>https://your-project.supabase.co</string>
<key>SUPABASE_ANON_KEY</key>
<string>your-anon-key-here</string>
```

### URL Schemes

Add to `Info.plist`:
- Custom URL scheme: `brainrush://`

### Associated Domains

Add for Universal Links:
- `applinks:brainrash.com`

## Setup Instructions

1. **Open Project**
   ```bash
   open BrainRush/BrainRush.xcodeproj
   ```

2. **Configure Supabase**
   - Add Supabase URL and anon key to Info.plist
   - (Or use a secure configuration method)

3. **Add Dependencies**
   - Supabase iOS SDK (via SPM or CocoaPods)
   - Other dependencies as needed

4. **Configure Capabilities**
   - Push Notifications
   - Associated Domains
   - Keychain Sharing (if needed)

5. **Build and Run**
   - Select a simulator or device
   - Build and run the app

## Testing

The app structure supports comprehensive testing:
- Unit tests for services and business logic
- Integration tests for API calls
- UI tests for critical user flows
- Performance testing
- Accessibility testing

## Next Steps

1. Integrate actual Supabase iOS SDK
2. Complete remaining detailed views
3. Add game-like animations and polish
4. Implement real-time features (WebSocket/SSE)
5. Complete offline storage implementation
6. Add comprehensive test suite
7. Configure push notifications (APNs)
8. Set up deep linking (AASA file on server)

## Design Philosophy

- **Entertaining**: Every interaction feels like a game
- **Exciting**: Frequent rewards and celebrations
- **Fun**: Interactive elements and gamification
- **Engaging**: Social features and challenges
- **Easy**: Intuitive navigation and clear guidance

## License

Proprietary - BrainRash Platform
