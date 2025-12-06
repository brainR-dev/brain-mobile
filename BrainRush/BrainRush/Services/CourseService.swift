//
//  CourseService.swift
//  BrainRush
//
//  Course service
//

import Foundation

@MainActor
class CourseService: ObservableObject {
    static let shared = CourseService()
    
    @Published var courses: [Course] = []
    @Published var enrolledCourses: [Course] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    func loadCourses() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else {
            errorMessage = "Not authenticated"
            return
        }
        
        do {
            let data: [Course] = try await APIClient.shared.request(
                endpoint: "/courses",
                method: "GET",
                accessToken: token
            )
            self.courses = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func loadCourseDetails(courseId: String) async throws -> Course {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let course: Course = try await APIClient.shared.request(
            endpoint: "/mobile/courses/\(courseId)/full",
            method: "GET",
            accessToken: token
        )
        return course
    }
    
    func enrollInCourse(courseId: String) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        do {
            let _: EmptyResponse = try await APIClient.shared.request(
                endpoint: "/courses/\(courseId)/enroll",
                method: "POST",
                accessToken: token
            )
            
            // Track enrollment
            if let course = courses.first(where: { $0.id == courseId }) {
                AnalyticsService.shared.trackCourseEnrolled(
                    courseId: courseId,
                    courseTitle: course.title
                )
            }
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "enroll_course",
                "course_id": courseId
            ])
            throw error
        }
    }
    
    func loadEnrolledCourses() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else {
            errorMessage = "Not authenticated"
            return
        }
        
        do {
            let data: [Course] = try await APIClient.shared.request(
                endpoint: "/mobile/courses/enrollment",
                method: "GET",
                accessToken: token
            )
            self.enrolledCourses = data
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
