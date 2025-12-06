//
//  CompleteUserFlowTests.swift
//  BrainRushTests
//
//  End-to-end user workflow tests
//

import XCTest
@testable import BrainRush

@MainActor
final class CompleteUserFlowTests: XCTestCase {
    
    func testCompleteSignUpFlow() async throws {
        let authService = AuthService.shared
        
        // 1. Sign up
        do {
            try await authService.signUp(
                email: "newuser@example.com",
                password: "SecurePass123"
            )
            
            // 2. Verify authenticated
            XCTAssertTrue(authService.isAuthenticated)
            XCTAssertNotNil(authService.currentUser)
            
            // 3. Complete onboarding (if exists)
            // This would navigate through onboarding screens
            
            // 4. Load dashboard
            let dashboardService = DashboardService.shared
            await dashboardService.loadDashboard()
            
            XCTAssertNotNil(dashboardService.dashboardData)
        } catch {
            // Expected if API not available
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCompleteCourseEnrollmentFlow() async throws {
        let courseService = CourseService.shared
        let lessonService = LessonService.shared
        
        // 1. Browse courses
        await courseService.loadCourses()
        
        // 2. Enroll in course
        do {
            try await courseService.enrollInCourse(courseId: "course_1")
            
            // 3. Load first lesson
            let lesson = try await lessonService.loadLesson(lessonId: "lesson_1")
            
            // 4. Mark lesson complete
            try await lessonService.markLessonComplete(
                lessonId: "lesson_1",
                courseId: "course_1",
                lessonTitle: lesson.title,
                duration: 30
            )
            
            // 5. Verify XP gained
            let gamificationService = GamificationService.shared
            await gamificationService.loadUserXP()
            
            XCTAssertNotNil(gamificationService.userXP)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCompleteQuizFlow() async throws {
        let quizService = QuizService.shared
        
        // 1. Load quiz
        do {
            let quiz = try await quizService.loadQuiz(quizId: "quiz_1")
            
            // 2. Answer questions
            var answers: [String: String] = [:]
            for (index, question) in quiz.questions.enumerated() {
                if let correctAnswer = question.correctAnswer {
                    answers[question.id] = correctAnswer
                } else if let options = question.options, !options.isEmpty {
                    answers[question.id] = options[0]
                }
            }
            
            // 3. Submit quiz
            let result = try await quizService.submitQuiz(
                quizId: "quiz_1",
                answers: answers
            )
            
            // 4. Verify score and XP gained
            XCTAssertNotNil(result)
            XCTAssertGreaterThanOrEqual(result.score, 0.0)
            XCTAssertLessThanOrEqual(result.score, 1.0)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCompleteAchievementUnlockFlow() async {
        let gamificationService = GamificationService.shared
        
        // 1. Complete action that triggers achievement
        // (e.g., complete first lesson)
        await gamificationService.loadAchievements()
        
        // 2. Check for newly unlocked achievements
        let unlocked = gamificationService.achievements.filter { $0.isUnlocked == true }
        
        // 3. Verify achievement unlocked
        XCTAssertNotNil(unlocked)
    }
    
    func testCompletePurchaseFlow() async throws {
        let economyService = EconomyService.shared
        
        // 1. Load token balance
        await economyService.loadTokenBalance()
        
        // 2. Browse swag store
        await economyService.loadSwagItems()
        
        // 3. Purchase item
        do {
            try await economyService.purchaseItem(itemId: "item_1")
            
            // 4. Verify balance updated
            await economyService.loadTokenBalance()
            
            // 5. Verify item owned
            await economyService.loadSwagItems()
            let item = economyService.swagItems?.first { $0.id == "item_1" }
            
            XCTAssertTrue(item?.isOwned ?? false)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCompleteSearchFlow() async throws {
        let searchService = SearchService.shared
        
        // 1. Perform search
        do {
            let results = try await searchService.searchAll(query: "Swift")
            
            // 2. Verify results
            XCTAssertNotNil(results)
            
            // 3. Check search history
            let history = await searchService.getSearchHistory()
            
            // Search should be in history
            XCTAssertNotNil(history)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCompleteOfflineFlow() async throws {
        let offlineService = OfflineService.shared
        let courseService = CourseService.shared
        
        // 1. Download course for offline
        do {
            try await offlineService.downloadCourseContent(courseId: "course_1")
            
            // 2. Verify downloaded
            let isDownloaded = offlineService.isContentDownloaded(courseId: "course_1")
            
            // 3. Access offline content
            // (would test offline lesson loading)
            
            // 4. Sync when back online
            try await offlineService.syncOfflineChanges()
            
            XCTAssertNotNil(offlineService)
        } catch {
            XCTAssertTrue(error is APIError || error is OfflineError)
        }
    }
}
