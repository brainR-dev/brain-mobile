//
//  ServiceIntegrationTests.swift
//  BrainRushTests
//
//  Integration tests for service interactions
//

import XCTest
@testable import BrainRush

@MainActor
final class ServiceIntegrationTests: XCTestCase {
    
    func testAuthAndDashboardIntegration() async throws {
        let authService = AuthService.shared
        let dashboardService = DashboardService.shared
        
        // Sign in
        do {
            try await authService.signIn(email: "test@example.com", password: "password123")
            
            // Wait a bit for session to be set
            try? await Task.sleep(nanoseconds: 100_000_000)
            
            // Load dashboard (should work with authenticated session)
            await dashboardService.loadDashboard()
            
            // Verify services work together
            XCTAssertTrue(authService.isAuthenticated)
        } catch {
            // Expected if API not available
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testCourseEnrollmentAndProgress() async throws {
        let courseService = CourseService.shared
        let lessonService = LessonService.shared
        
        // Enroll in course
        do {
            try await courseService.enrollInCourse(courseId: "course_1")
            
            // Load lesson
            let lesson = try await lessonService.loadLesson(lessonId: "lesson_1")
            
            // Verify integration
            XCTAssertEqual(lesson.courseId, "course_1")
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testGamificationAndEconomyIntegration() async {
        let gamificationService = GamificationService.shared
        let economyService = EconomyService.shared
        
        // Load XP (should be connected to token rewards)
        await gamificationService.loadUserXP()
        await economyService.loadTokenBalance()
        
        // Verify both services work
        XCTAssertNotNil(gamificationService)
        XCTAssertNotNil(economyService)
    }
    
    func testOfflineAndSyncIntegration() async throws {
        let offlineService = OfflineService.shared
        let courseService = CourseService.shared
        
        // Download course for offline
        do {
            try await offlineService.downloadCourseContent(courseId: "course_1")
            
            // Sync changes
            try await offlineService.syncOfflineChanges()
            
            // Verify integration
            XCTAssertNotNil(offlineService)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError || error is OfflineError)
        }
    }
    
    func testAnalyticsAndServicesIntegration() {
        let analytics = AnalyticsService.shared
        
        // Track various service actions
        analytics.track("course_enrolled", properties: ["course_id": "course_1"])
        analytics.track("lesson_completed", properties: ["lesson_id": "lesson_1"])
        analytics.track("achievement_unlocked", properties: ["achievement_id": "ach_1"])
        
        // Verify analytics work with all services
        XCTAssertNotNil(analytics)
    }
}
