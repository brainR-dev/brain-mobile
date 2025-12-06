//
//  CourseViewModel.swift
//  BrainRush
//
//  Course view model for MVVM pattern
//

import Foundation
import Combine

@MainActor
class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var filteredCourses: [Course] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedCategory: String?
    
    private let courseService = CourseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        courseService.$courses
            .assign(to: &$courses)
        
        courseService.$isLoading
            .assign(to: &$isLoading)
        
        // Filter courses when search or category changes
        Publishers.CombineLatest($courses, $searchText, $selectedCategory)
            .map { courses, searchText, category in
                var filtered = courses
                
                if !searchText.isEmpty {
                    filtered = filtered.filter { course in
                        course.title.localizedCaseInsensitiveContains(searchText) ||
                        course.description?.localizedCaseInsensitiveContains(searchText) == true
                    }
                }
                
                if let category = category {
                    filtered = filtered.filter { $0.category == category || $0.domain == category }
                }
                
                return filtered
            }
            .assign(to: &$filteredCourses)
    }
    
    func loadCourses() async {
        await courseService.loadCourses()
    }
    
    func enrollInCourse(courseId: String) async throws {
        try await courseService.enrollInCourse(courseId: courseId)
        await loadCourses()
    }
}
