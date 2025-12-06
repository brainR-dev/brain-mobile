//
//  AnalyticsService.swift
//  BrainRush
//
//  Analytics and event tracking service using PostHog
//

import Foundation
#if canImport(PostHog)
import PostHog
#endif

@MainActor
class AnalyticsService: ObservableObject {
    static let shared = AnalyticsService()
    
    private var isInitialized = false
    
    private init() {
        initializePostHog()
    }
    
    private func initializePostHog() {
        #if canImport(PostHog)
        guard !isInitialized else { return }
        
        // Initialize PostHog - keys should come from AppConfig or Info.plist
        if let posthogKey = AppConfig.posthogAPIKey, !posthogKey.isEmpty {
            let config = PostHogConfig(
                apiKey: posthogKey,
                host: AppConfig.posthogHost
            )
            config.sessionReplay = true // Enable session replay
            config.captureApplicationLifecycleEvents = true
            config.captureScreenViews = true
            
            PostHogSDK.shared.setup(config)
            isInitialized = true
            
            Logger.shared.info("PostHog initialized successfully")
        } else {
            Logger.shared.warning("PostHog API key not configured")
        }
        #else
        Logger.shared.warning("PostHog SDK not available - using mock analytics")
        #endif
    }
    
    // MARK: - Screen Tracking
    
    func trackScreen(_ screenName: String, properties: [String: Any]? = nil) {
        var eventProperties: [String: Any] = ["screen_name": screenName]
        
        if let properties = properties {
            eventProperties.merge(properties) { (_, new) in new }
        }
        
        #if canImport(PostHog)
        PostHogSDK.shared.screen(screenName, properties: eventProperties)
        #else
        Logger.shared.debug("📊 Screen: \(screenName)")
        #endif
        
        Logger.shared.debug("Screen tracked: \(screenName)")
    }
    
    // MARK: - Event Tracking
    
    func track(_ eventName: String, properties: [String: Any]? = nil) {
        #if canImport(PostHog)
        PostHogSDK.shared.capture(eventName, properties: properties ?? [:])
        #else
        Logger.shared.debug("📊 Event: \(eventName)")
        if let props = properties {
            Logger.shared.debug("Properties: \(props)")
        }
        #endif
        
        Logger.shared.debug("Event tracked: \(eventName)")
    }
    
    // MARK: - User Identification
    
    func identify(userId: String, properties: [String: Any]? = nil) {
        #if canImport(PostHog)
        PostHogSDK.shared.identify(distinctId: userId, properties: properties ?? [:])
        #else
        Logger.shared.debug("👤 Identify: \(userId)")
        #endif
        
        Logger.shared.debug("User identified: \(userId)")
    }
    
    func reset() {
        #if canImport(PostHog)
        PostHogSDK.shared.reset()
        #else
        Logger.shared.debug("🔄 Analytics reset")
        #endif
        
        Logger.shared.debug("Analytics reset")
    }
    
    // MARK: - User Properties
    
    func setUserProperties(_ properties: [String: Any]) {
        #if canImport(PostHog)
        PostHogSDK.shared.identify(distinctId: nil, properties: properties)
        #else
        Logger.shared.debug("👤 User properties: \(properties)")
        #endif
    }
    
    // MARK: - Error Tracking
    
    func trackError(_ error: Error, context: [String: Any]? = nil) {
        let errorDescription = error.localizedDescription
        var errorProperties: [String: Any] = [
            "error_message": errorDescription,
            "error_type": String(describing: type(of: error))
        ]
        
        if let nsError = error as NSError? {
            errorProperties["error_code"] = nsError.code
            errorProperties["error_domain"] = nsError.domain
            if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                errorProperties["underlying_error"] = underlyingError.localizedDescription
            }
        }
        
        if let context = context {
            errorProperties.merge(context) { (_, new) in new }
        }
        
        // Track as exception in PostHog
        #if canImport(PostHog)
        PostHogSDK.shared.capture("$exception", properties: errorProperties)
        #else
        Logger.shared.error("❌ Error: \(errorDescription)")
        #endif
        
        Logger.shared.error("Error tracked: \(errorDescription)")
    }
    
    // MARK: - Feature-Specific Tracking
    
    // Authentication
    func trackSignUp(method: String) {
        track("user_signed_up", properties: ["method": method])
    }
    
    func trackSignIn(method: String) {
        track("user_signed_in", properties: ["method": method])
    }
    
    func trackSignOut() {
        track("user_signed_out")
    }
    
    // Learning
    func trackCourseEnrolled(courseId: String, courseTitle: String) {
        track("course_enrolled", properties: [
            "course_id": courseId,
            "course_title": courseTitle
        ])
    }
    
    func trackLessonStarted(courseId: String, lessonId: String, lessonTitle: String) {
        track("lesson_started", properties: [
            "course_id": courseId,
            "lesson_id": lessonId,
            "lesson_title": lessonTitle
        ])
    }
    
    func trackLessonCompleted(courseId: String, lessonId: String, lessonTitle: String, duration: Int?) {
        var properties: [String: Any] = [
            "course_id": courseId,
            "lesson_id": lessonId,
            "lesson_title": lessonTitle
        ]
        if let duration = duration {
            properties["duration_seconds"] = duration
        }
        track("lesson_completed", properties: properties)
    }
    
    func trackQuizStarted(quizId: String, quizTitle: String) {
        track("quiz_started", properties: [
            "quiz_id": quizId,
            "quiz_title": quizTitle
        ])
    }
    
    func trackQuizCompleted(quizId: String, quizTitle: String, score: Double, passed: Bool) {
        track("quiz_completed", properties: [
            "quiz_id": quizId,
            "quiz_title": quizTitle,
            "score": score,
            "passed": passed
        ])
    }
    
    // Gamification
    func trackLevelUp(newLevel: Int, xp: Int) {
        track("level_up", properties: [
            "new_level": newLevel,
            "xp": xp
        ])
    }
    
    func trackAchievementUnlocked(achievementId: String, achievementName: String, rarity: String) {
        track("achievement_unlocked", properties: [
            "achievement_id": achievementId,
            "achievement_name": achievementName,
            "rarity": rarity
        ])
    }
    
    func trackChallengeStarted(challengeId: String, challengeType: String) {
        track("challenge_started", properties: [
            "challenge_id": challengeId,
            "challenge_type": challengeType
        ])
    }
    
    func trackChallengeCompleted(challengeId: String, challengeType: String, rewardXP: Int, rewardTokens: Int) {
        track("challenge_completed", properties: [
            "challenge_id": challengeId,
            "challenge_type": challengeType,
            "reward_xp": rewardXP,
            "reward_tokens": rewardTokens
        ])
    }
    
    // Economy
    func trackTokenEarned(amount: Int, reason: String, source: String) {
        track("tokens_earned", properties: [
            "amount": amount,
            "reason": reason,
            "source": source
        ])
    }
    
    func trackTokenSpent(amount: Int, itemId: String, itemName: String) {
        track("tokens_spent", properties: [
            "amount": amount,
            "item_id": itemId,
            "item_name": itemName
        ])
    }
    
    func trackSwagPurchased(itemId: String, itemName: String, price: Int, rarity: String) {
        track("swag_purchased", properties: [
            "item_id": itemId,
            "item_name": itemName,
            "price": price,
            "rarity": rarity
        ])
    }
    
    // Social
    func trackForumThreadCreated(forumId: String, threadId: String) {
        track("forum_thread_created", properties: [
            "forum_id": forumId,
            "thread_id": threadId
        ])
    }
    
    func trackStudyGroupJoined(groupId: String, groupName: String) {
        track("study_group_joined", properties: [
            "group_id": groupId,
            "group_name": groupName
        ])
    }
    
    func trackMessageSent(conversationId: String) {
        track("message_sent", properties: [
            "conversation_id": conversationId
        ])
    }
    
    // AI
    func trackAITutorMessage(personaId: String, messageLength: Int) {
        track("ai_tutor_message", properties: [
            "persona_id": personaId,
            "message_length": messageLength
        ])
    }
    
    func trackStudyPlanGenerated() {
        track("study_plan_generated")
    }
    
    // Search
    func trackSearch(query: String, resultsCount: Int, filters: [String: Any]?) {
        var properties: [String: Any] = [
            "query": query,
            "results_count": resultsCount
        ]
        if let filters = filters {
            properties["filters"] = filters
        }
        track("search_performed", properties: properties)
    }
    
    // Navigation
    func trackDeepLink(url: String, route: String) {
        track("deep_link_opened", properties: [
            "url": url,
            "route": route
        ])
    }
    
    // Push Notifications
    func trackPushNotificationReceived(notificationId: String, type: String) {
        track("push_notification_received", properties: [
            "notification_id": notificationId,
            "type": type
        ])
    }
    
    func trackPushNotificationTapped(notificationId: String, type: String) {
        track("push_notification_tapped", properties: [
            "notification_id": notificationId,
            "type": type
        ])
    }
    
    // Performance
    func trackPerformance(metricName: String, value: Double, unit: String = "ms") {
        track("performance_metric", properties: [
            "metric_name": metricName,
            "value": value,
            "unit": unit
        ])
    }
    
    // Feature Flags (if using PostHog feature flags)
    func getFeatureFlag(_ flagName: String) -> Bool {
        #if canImport(PostHog)
        return PostHogSDK.shared.isFeatureEnabled(flagName) ?? false
        #else
        return false
        #endif
    }
}
