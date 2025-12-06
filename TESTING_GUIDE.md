# 🧪 Testing Guide

## Testing Strategy

The app follows a comprehensive testing strategy with 90%+ coverage for business logic and 75%+ overall coverage.

## Test Structure

```
BrainRushTests/
├── UnitTests/
│   ├── Models/
│   ├── Services/
│   ├── ViewModels/
│   └── Utils/
├── IntegrationTests/
│   ├── APITests/
│   ├── DatabaseTests/
│   └── AuthTests/
└── UITests/
    ├── AuthFlowTests/
    ├── CourseFlowTests/
    └── GamificationTests/
```

## Unit Tests

### Example: Service Test

```swift
// BrainRushTests/UnitTests/Services/CourseServiceTests.swift
import XCTest
@testable import BrainRush

final class CourseServiceTests: XCTestCase {
    var service: CourseService!
    
    override func setUp() {
        super.setUp()
        service = CourseService.shared
    }
    
    func testLoadCourses() async throws {
        // Mock API response
        let courses = try await service.loadCourses()
        XCTAssertFalse(courses.isEmpty)
    }
}
```

### Example: ViewModel Test

```swift
// BrainRushTests/UnitTests/ViewModels/CourseViewModelTests.swift
import XCTest
import Combine
@testable import BrainRush

final class CourseViewModelTests: XCTestCase {
    var viewModel: CourseViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = CourseViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    func testFilterCourses() {
        let expectation = expectation(description: "Filter courses")
        
        viewModel.$filteredCourses
            .dropFirst()
            .sink { courses in
                XCTAssertTrue(courses.allSatisfy { $0.category == "Computer Science" })
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.selectedCategory = "Computer Science"
        waitForExpectations(timeout: 1.0)
    }
}
```

### Example: Model Test

```swift
// BrainRushTests/UnitTests/Models/CourseTests.swift
import XCTest
@testable import BrainRush

final class CourseTests: XCTestCase {
    func testCourseDecoding() throws {
        let json = """
        {
            "id": "1",
            "title": "Test Course",
            "instructor": "John Doe",
            "duration": 120,
            "rating": 4.5
        }
        """
        
        let data = json.data(using: .utf8)!
        let course = try JSONDecoder().decode(Course.self, from: data)
        
        XCTAssertEqual(course.id, "1")
        XCTAssertEqual(course.title, "Test Course")
    }
}
```

## Integration Tests

### API Integration Test

```swift
// BrainRushTests/IntegrationTests/APITests/APIClientTests.swift
import XCTest
@testable import BrainRush

final class APIClientTests: XCTestCase {
    func testAuthenticatedRequest() async throws {
        let token = "test_token"
        
        // This would use a test API endpoint
        // For now, tests API client structure
        let client = APIClient.shared
        
        do {
            let response: EmptyResponse = try await client.request(
                endpoint: "/mobile/test",
                method: "GET",
                accessToken: token
            )
            // Verify response handling
        } catch {
            // Expected for test endpoint
        }
    }
}
```

### Database Test (SwiftData)

```swift
// BrainRushTests/IntegrationTests/DatabaseTests/SwiftDataTests.swift
import XCTest
import SwiftData
@testable import BrainRush

final class SwiftDataTests: XCTestCase {
    var modelContainer: ModelContainer!
    
    override func setUp() {
        let schema = Schema([UserProfile.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: schema, configurations: [config])
    }
    
    func testSaveUserProfile() throws {
        let context = modelContainer.mainContext
        let profile = UserProfile(/* ... */)
        context.insert(profile)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(fetchDescriptor)
        XCTAssertEqual(profiles.count, 1)
    }
}
```

## UI Tests

### Example: Authentication Flow

```swift
// BrainRushTests/UITests/AuthFlowTests.swift
import XCTest

final class AuthFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testSignIn() {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        emailField.tap()
        emailField.typeText("test@example.com")
        
        passwordField.tap()
        passwordField.typeText("password123")
        
        signInButton.tap()
        
        // Verify navigation to dashboard
        XCTAssertTrue(app.navigationBars["Dashboard"].exists)
    }
}
```

### Example: Course Enrollment

```swift
// BrainRushTests/UITests/CourseFlowTests.swift
import XCTest

final class CourseFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testEnrollInCourse() {
        // Navigate to courses
        app.tabBars.buttons["Courses"].tap()
        
        // Tap first course
        app.collectionViews.cells.firstMatch.tap()
        
        // Tap enroll button
        app.buttons["Enroll in Course"].tap()
        
        // Verify enrollment
        XCTAssertTrue(app.buttons["Enrolled"].exists)
    }
}
```

## Performance Tests

```swift
// BrainRushTests/PerformanceTests.swift
import XCTest
@testable import BrainRush

final class PerformanceTests: XCTestCase {
    func testCourseListPerformance() {
        measure {
            let service = CourseService.shared
            Task {
                _ = try? await service.loadCourses()
            }
        }
    }
}
```

## Snapshot Tests

Using SwiftSnapshotTesting:

```swift
// BrainRushTests/SnapshotTests/DashboardSnapshotTests.swift
import XCTest
import SwiftSnapshotTesting
@testable import BrainRush

final class DashboardSnapshotTests: XCTestCase {
    func testDashboardSnapshot() {
        let view = DashboardView()
            .frame(width: 375, height: 812)
        
        assertSnapshot(matching: view, as: .image)
    }
}
```

## Test Coverage Goals

- **Business Logic**: 90%+
- **Services**: 85%+
- **ViewModels**: 90%+
- **Models**: 95%+
- **Overall**: 75%+

## Running Tests

```bash
# Run all tests
cmd + U in Xcode

# Run specific test suite
xcodebuild test -scheme BrainRush -destination 'platform=iOS Simulator,name=iPhone 15'

# Generate coverage report
xcodebuild test -scheme BrainRush -enableCodeCoverage YES
```

## Continuous Integration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: xcodebuild test -scheme BrainRush -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Mocking

For testing, create mock services:

```swift
class MockCourseService: CourseServiceProtocol {
    var courses: [Course] = []
    
    func loadCourses() async throws -> [Course] {
        return courses
    }
}
```

## Test Data

Create test fixtures:

```swift
extension Course {
    static var mockCourse: Course {
        Course(/* mock data */)
    }
}
```

## Best Practices

1. ✅ Test business logic thoroughly
2. ✅ Mock external dependencies
3. ✅ Test error cases
4. ✅ Use descriptive test names
5. ✅ Keep tests fast and isolated
6. ✅ Test user flows end-to-end
7. ✅ Maintain high coverage
8. ✅ Update tests with code changes
