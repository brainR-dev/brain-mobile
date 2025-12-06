# 📊 PostHog Analytics Setup Guide

## Overview

The BrainRush app is fully integrated with PostHog for comprehensive analytics and error tracking. All user actions, errors, and events are automatically tracked.

## Configuration

### 1. Add PostHog API Key to Info.plist

```xml
<key>POSTHOG_API_KEY</key>
<string>your-posthog-api-key-here</string>

<key>POSTHOG_HOST</key>
<string>https://us.i.posthog.com</string>
```

### 2. Install PostHog SDK

#### Via Swift Package Manager

1. In Xcode: File → Add Package Dependencies
2. Add PostHog Swift SDK:
   ```
   https://github.com/PostHog/posthog-swift
   ```
   Version: `3.0.0` or latest

#### Via CocoaPods

```ruby
pod 'PostHog', '~> 3.0'
```

### 3. Enable PostHog in AnalyticsService

The `AnalyticsService` will automatically initialize PostHog when:
- API key is configured in Info.plist
- PostHog SDK is available

## Tracking Implementation

### ✅ What's Being Tracked

#### Authentication Events
- `user_signed_up` - User registration
- `user_signed_in` - User login
- `user_signed_out` - User logout

#### Learning Events
- `course_enrolled` - Course enrollment
- `lesson_started` - Lesson viewing started
- `lesson_completed` - Lesson completion
- `quiz_started` - Quiz attempt started
- `quiz_completed` - Quiz submission with score

#### Gamification Events
- `level_up` - User levels up
- `achievement_unlocked` - Achievement earned
- `challenge_started` - Challenge engagement
- `challenge_completed` - Challenge completion

#### Economy Events
- `tokens_earned` - Token rewards
- `tokens_spent` - Token purchases
- `swag_purchased` - Item purchases

#### Social Events
- `forum_thread_created` - Forum participation
- `study_group_joined` - Group participation
- `message_sent` - Direct messaging

#### AI Events
- `ai_tutor_message` - AI interactions
- `study_plan_generated` - AI planning

#### Navigation Events
- Screen views (all screens)
- Deep link opens
- Search performed

#### Error Tracking
- All API errors
- Network errors
- Decoding errors
- App crashes (via PostHog)

#### Performance Metrics
- API request times
- Page load times

### Screen Tracking

All screens automatically track views:
- `dashboard`
- `courses`
- `achievements`
- `challenges`
- `leaderboard`
- `wallet`
- `swag_store`
- `forums`
- `study_groups`
- `messages`
- `ai_tutor`
- `study_planner`
- `certificates`
- `brain_profile`
- `profile_settings`
- And more...

## Event Properties

Events include rich context:
- User ID
- Course/Lesson IDs
- Timestamps
- Error details
- Performance metrics
- User properties (level, XP, etc.)

## User Identification

Users are automatically identified when they:
- Sign up
- Sign in

User properties are updated:
- On level up
- On achievement unlock
- On course enrollment

## Error Tracking

All errors are automatically tracked with:
- Error message
- Error type
- Stack trace
- Context (endpoint, action, etc.)
- User ID
- Timestamp

## Custom Events

Add custom tracking anywhere:

```swift
// Track custom event
AnalyticsService.shared.track("custom_event", properties: [
    "property1": "value1",
    "property2": 123
])

// Track screen
AnalyticsService.shared.trackScreen("my_screen", properties: [
    "context": "additional_info"
])

// Track error
AnalyticsService.shared.trackError(error, context: [
    "action": "what_user_was_doing"
])
```

## Feature Flags

Use PostHog feature flags:

```swift
let isFeatureEnabled = AnalyticsService.shared.getFeatureFlag("new_feature")

if isFeatureEnabled {
    // Show new feature
}
```

## Session Replay

Session replay is enabled by default:
- Records user sessions
- Helps debug issues
- Understand user behavior
- Privacy-compliant

## Privacy

- User data is anonymized when possible
- Compliant with GDPR/CCPA
- Users can opt out (if implemented)
- No sensitive data tracked

## Dashboard Setup

### Recommended PostHog Dashboards

1. **User Engagement**
   - Daily active users
   - Session duration
   - Screen views

2. **Learning Analytics**
   - Course enrollments
   - Lesson completions
   - Quiz scores

3. **Gamification Metrics**
   - Level ups
   - Achievement unlocks
   - Challenge completions

4. **Error Monitoring**
   - Error frequency
   - Error types
   - Affected users

5. **Performance**
   - API response times
   - App load times

## Testing

### Verify Tracking

1. Check PostHog dashboard
2. View events in real-time
3. Verify user identification
4. Check error tracking
5. Review session replays

### Test Events

All events work even without PostHog SDK:
- Events logged to console in debug mode
- Mock tracking when SDK unavailable
- No crashes if PostHog not configured

## Production Checklist

- [ ] PostHog API key configured
- [ ] PostHog SDK installed
- [ ] Test events tracked successfully
- [ ] Error tracking verified
- [ ] User identification working
- [ ] Dashboard configured
- [ ] Alerts set up (if needed)

## Support

See PostHog documentation:
- [PostHog iOS SDK](https://posthog.com/docs/integrate/client/ios)
- [Event Tracking](https://posthog.com/docs/integrate/client/ios#identify)
- [Feature Flags](https://posthog.com/docs/feature-flags)

**All analytics are automatically tracked!** 📊
