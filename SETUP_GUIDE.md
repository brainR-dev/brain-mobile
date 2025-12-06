# 🚀 BrainRush Mobile App - Setup Guide

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift 5.9+
- CocoaPods or Swift Package Manager

## Step 1: Clone & Open Project

```bash
cd /path/to/brain-mobile
open BrainRush/BrainRush.xcodeproj
```

## Step 2: Install Dependencies

### Option A: Swift Package Manager (Recommended)

1. In Xcode: File → Add Package Dependencies
2. Add Supabase Swift SDK:
   ```
   https://github.com/supabase/supabase-swift
   ```
   Version: `2.0.0` or latest

### Option B: CocoaPods

```bash
cd BrainRush
pod init
# Add to Podfile:
# pod 'Supabase', '~> 2.0'
pod install
open BrainRush.xcworkspace
```

## Step 3: Configure Info.plist

Add the following keys to your `Info.plist`:

```xml
<key>SUPABASE_URL</key>
<string>https://your-project.supabase.co</string>

<key>SUPABASE_ANON_KEY</key>
<string>your-anon-key-here</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>brainrush</string>
        </array>
    </dict>
</array>

<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:brainrash.com</string>
    <string>applinks:www.brainrash.com</string>
</array>
```

## Step 4: Configure Capabilities

### Enable Push Notifications

1. Select project target → Signing & Capabilities
2. Click "+ Capability"
3. Add "Push Notifications"

### Enable Associated Domains

1. Select project target → Signing & Capabilities
2. Click "+ Capability"
3. Add "Associated Domains"
4. Add: `applinks:brainrash.com`

### Background Modes

1. Select project target → Signing & Capabilities
2. Add "Background Modes"
3. Enable:
   - Remote notifications
   - Background fetch

## Step 5: Update AppConfig

Update `BrainRush/BrainRush/Core/Config/AppConfig.swift`:

```swift
struct AppConfig {
    static let apiBaseURL = "https://brainrash.com/api"
    static let bundleID = "com.brainrash.BrainRush" // Update with your bundle ID
    // Supabase config is read from Info.plist
}
```

## Step 6: Configure APNs (Push Notifications)

1. Create APNs Key in Apple Developer Portal
2. Upload key to your backend/push service
3. Ensure backend sends device tokens to Supabase or your push service

## Step 7: Server Configuration

### Universal Links (AASA File)

Host an `apple-app-site-association` file at:
```
https://brainrash.com/.well-known/apple-app-site-association
```

Content:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.brainrash.BrainRush",
        "paths": ["*"]
      }
    ]
  }
}
```

Replace `TEAM_ID` with your Apple Developer Team ID.

## Step 8: Build & Run

1. Select a simulator or connected device
2. Product → Run (⌘R)
3. App should launch successfully

## Step 9: Testing

### Test Authentication
- Sign up with test email
- Sign in with credentials
- Test OAuth flows (when implemented)

### Test Deep Linking
- Test Universal Links: `https://brainrash.com/courses/123`
- Test Custom URL: `brainrush://course?id=123`

### Test Push Notifications
- Grant notification permissions
- Verify device token registration
- Test notification handling

## Troubleshooting

### Build Errors

**"Cannot find module 'Supabase'"**
- Ensure Swift Package is added and resolved
- Clean build folder (⌘⇧K) and rebuild

**Code Signing Errors**
- Update Bundle Identifier in project settings
- Select proper Team in Signing & Capabilities

### Runtime Errors

**"Invalid Supabase URL"**
- Check Info.plist keys are set correctly
- Verify Supabase project URL format

**"Network request failed"**
- Check API base URL in AppConfig
- Verify backend is accessible
- Check network permissions in Info.plist

## Next Steps

1. ✅ Integrate Supabase Auth SDK
2. ✅ Connect to real API endpoints
3. ✅ Test all features end-to-end
4. ✅ Add comprehensive tests
5. ✅ Configure analytics
6. ✅ Prepare for App Store submission

## Additional Resources

- [Supabase iOS Documentation](https://supabase.com/docs/reference/swift)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Apple App Store Guidelines](https://developer.apple.com/app-store/review/guidelines/)
