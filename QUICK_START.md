# ⚡ Quick Start Guide

## Get Started in 5 Minutes

### 1. Open Project
```bash
open BrainRush/BrainRush.xcodeproj
```

### 2. Add Supabase SDK
- File → Add Package Dependencies
- URL: `https://github.com/supabase/supabase-swift`
- Version: Latest

### 3. Configure Info.plist
Add your Supabase credentials:
```xml
<key>SUPABASE_URL</key>
<string>https://your-project.supabase.co</string>

<key>SUPABASE_ANON_KEY</key>
<string>your-key-here</string>
```

### 4. Build & Run
- ⌘R to build and run
- App launches with mock data

### 5. Next Steps
- Connect to real API (see API_INTEGRATION.md)
- Run tests (⌘U)
- Customize UI/UX

## Project Structure

```
BrainRush/
├── Core/           # Infrastructure
├── Models/         # Data models
├── Services/       # Business logic
├── ViewModels/     # MVVM view models
└── Views/          # SwiftUI views
```

## Key Files

- `BrainRushApp.swift` - App entry point
- `RootView.swift` - Main navigation
- `APIClient.swift` - API networking
- `AuthService.swift` - Authentication

## Features Ready

✅ Authentication  
✅ Dashboard  
✅ Courses & Lessons  
✅ Quizzes  
✅ Gamification  
✅ Social Features  
✅ AI Features  
✅ And 15+ more!

## Need Help?

- See `SETUP_GUIDE.md` for detailed setup
- See `API_INTEGRATION.md` for API connection
- See `TESTING_GUIDE.md` for testing
- See `README.md` for full documentation

**Ready to build!** 🚀
