//
//  NavigationCoordinator.swift
//  BrainRush
//
//  Navigation coordinator for deep linking and routing
//

import SwiftUI

enum NavigationDestination: Hashable {
    case course(String)
    case lesson(courseId: String, lessonId: String)
    case program(String)
    case quiz(String)
    case achievement(String)
    case challenge(String)
    case certificate(String)
    case forum(String)
    case studyGroup(String)
    case profile(String)
    case aiTutor
    case studyPlanner
}

class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    
    @Published var path = NavigationPath()
    
    private init() {}
    
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }
    
    func navigateToCourse(_ courseId: String) {
        navigate(to: .course(courseId))
    }
    
    func navigateToLesson(courseId: String, lessonId: String) {
        navigate(to: .lesson(courseId: courseId, lessonId: lessonId))
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
