//
//  DeepLinkRouter.swift
//  BrainRush
//
//  Deep link routing service
//

import Foundation

enum DeepLinkRoute {
    case course(String)
    case lesson(courseId: String, lessonId: String)
    case program(String)
    case profile(String)
    case achievement(String)
    case challenge(String)
    case certificate(String)
    case forum(forumId: String, threadId: String?)
    case studyGroup(String)
    case dashboard
    case leaderboard
}

class DeepLinkRouter {
    static let shared = DeepLinkRouter()
    
    private init() {}
    
    func handleURL(_ url: URL) -> DeepLinkRoute? {
        // Track deep link
        let urlString = url.absoluteString
        var routeString = "unknown"
        
        // Try universal link first
        if let route = handleUniversalLink(url) {
            routeString = String(describing: route)
            AnalyticsService.shared.trackDeepLink(url: urlString, route: routeString)
            return route
        }
        
        // Then try custom URL scheme
        if let route = handleCustomURL(url) {
            routeString = String(describing: route)
            AnalyticsService.shared.trackDeepLink(url: urlString, route: routeString)
            return route
        }
        
        AnalyticsService.shared.trackDeepLink(url: urlString, route: routeString)
        return nil
    }
    
    private func handleUniversalLink(_ url: URL) -> DeepLinkRoute? {
        guard url.host == "brainrash.com" else { return nil }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        switch pathComponents.first {
        case "courses":
            if pathComponents.count > 1 {
                let courseId = pathComponents[1]
                if pathComponents.count > 3 && pathComponents[2] == "lessons" {
                    return .lesson(courseId: courseId, lessonId: pathComponents[3])
                }
                return .course(courseId)
            }
        case "programs":
            if pathComponents.count > 1 {
                return .program(pathComponents[1])
            }
        case "profile":
            if pathComponents.count > 1 {
                return .profile(pathComponents[1])
            }
        case "achievements":
            if pathComponents.count > 1 {
                return .achievement(pathComponents[1])
            }
        case "challenges":
            if pathComponents.count > 1 {
                return .challenge(pathComponents[1])
            }
        case "certificates":
            if pathComponents.count > 1 {
                return .certificate(pathComponents[1])
            }
        case "forums":
            if pathComponents.count > 2 {
                let forumId = pathComponents[1]
                let threadId = pathComponents.count > 3 ? pathComponents[3] : nil
                return .forum(forumId: forumId, threadId: threadId)
            }
        case "study-groups":
            if pathComponents.count > 1 {
                return .studyGroup(pathComponents[1])
            }
        case "dashboard":
            return .dashboard
        case "leaderboard":
            return .leaderboard
        default:
            break
        }
        
        return nil
    }
    
    func handleCustomURL(_ url: URL) -> DeepLinkRoute? {
        guard url.scheme == "brainrush" else { return nil }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        switch pathComponents.first {
        case "course":
            if pathComponents.count > 1 {
                return .course(pathComponents[1])
            }
        case "lesson":
            if pathComponents.count > 2 {
                return .lesson(courseId: pathComponents[1], lessonId: pathComponents[2])
            }
        case "program":
            if pathComponents.count > 1 {
                return .program(pathComponents[1])
            }
        case "profile":
            if pathComponents.count > 1 {
                return .profile(pathComponents[1])
            }
        case "achievement":
            if pathComponents.count > 1 {
                return .achievement(pathComponents[1])
            }
        case "challenge":
            if pathComponents.count > 1 {
                return .challenge(pathComponents[1])
            }
        case "certificate":
            if pathComponents.count > 1 {
                return .certificate(pathComponents[1])
            }
        case "forum":
            if pathComponents.count > 2 {
                return .forum(forumId: pathComponents[1], threadId: pathComponents[2])
            }
        case "study-group":
            if pathComponents.count > 1 {
                return .studyGroup(pathComponents[1])
            }
        case "dashboard":
            return .dashboard
        case "leaderboard":
            return .leaderboard
        default:
            break
        }
        
        return nil
    }
}
