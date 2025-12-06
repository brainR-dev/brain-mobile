//
//  MockDataFactory.swift
//  BrainRushTests
//
//  Factory for creating mock data in tests
//

import Foundation
@testable import BrainRush

struct MockDataFactory {
    
    // MARK: - Courses
    
    static func makeCourse(
        id: String = "course_1",
        title: String = "Test Course",
        description: String? = "Test description",
        instructor: String? = "Test Instructor",
        duration: Int? = 120,
        rating: Double? = 4.5,
        category: String? = "Programming"
    ) -> Course {
        Course(
            id: id,
            title: title,
            description: description,
            thumbnail: nil,
            instructor: instructor,
            duration: duration,
            rating: rating,
            reviewCount: nil,
            enrollmentCount: nil,
            difficulty: nil,
            category: category,
            domain: nil,
            brainWaveLevel: nil,
            sections: nil,
            progress: nil
        )
    }
    
    static func makeCourses(count: Int) -> [Course] {
        (1...count).map { index in
            makeCourse(
                id: "course_\(index)",
                title: "Course \(index)",
                category: index % 2 == 0 ? "Programming" : "Design"
            )
        }
    }
    
    // MARK: - User Profile
    
    static func makeUserProfile(
        id: String = "user_1",
        email: String = "test@example.com",
        hasCompletedBrainProfile: Bool = false
    ) -> UserProfile {
        UserProfile(
            id: id,
            email: email,
            username: "testuser",
            avatar: nil,
            createdAt: Date().ISO8601Format(),
            hasCompletedBrainProfile: hasCompletedBrainProfile
        )
    }
    
    // MARK: - XP & Gamification
    
    static func makeUserXP(
        currentXP: Int = 750,
        level: Int = 12,
        xpToNextLevel: Int = 250,
        lifetimeXP: Int = 5000
    ) -> UserXP {
        UserXP(
            currentXP: currentXP,
            level: level,
            xpToNextLevel: xpToNextLevel,
            lifetimeXP: lifetimeXP
        )
    }
    
    static func makeAchievement(
        id: String = "ach_1",
        name: String = "First Steps",
        category: String = "getting_started",
        rarity: String = "Rare",
        isUnlocked: Bool? = true
    ) -> Achievement {
        Achievement(
            id: id,
            name: name,
            description: "Test achievement",
            category: category,
            rarity: rarity,
            icon: "trophy.fill",
            points: 10,
            isUnlocked: isUnlocked,
            progress: isUnlocked == true ? 1.0 : 0.0,
            unlockedAt: isUnlocked == true ? Date().ISO8601Format() : nil
        )
    }
    
    static func makeAchievements(count: Int, unlockedCount: Int = 0) -> [Achievement] {
        (1...count).map { index in
            makeAchievement(
                id: "ach_\(index)",
                name: "Achievement \(index)",
                isUnlocked: index <= unlockedCount
            )
        }
    }
    
    static func makeChallenge(
        id: String = "challenge_1",
        type: String = "daily",
        progress: Double = 0.5,
        isCompleted: Bool = false
    ) -> Challenge {
        Challenge(
            id: id,
            name: "Test Challenge",
            description: "Test challenge description",
            type: type,
            startDate: Date().ISO8601Format(),
            endDate: Date().addingTimeInterval(86400).ISO8601Format(),
            progress: progress,
            target: 100,
            current: 50,
            rewards: ChallengeRewards(xp: 100, tokens: 50, items: nil),
            isCompleted: isCompleted
        )
    }
    
    // MARK: - Quiz
    
    static func makeQuiz(
        id: String = "quiz_1",
        title: String = "Test Quiz",
        questionCount: Int = 5
    ) -> Quiz {
        Quiz(
            id: id,
            courseId: "course_1",
            lessonId: nil,
            title: title,
            description: "Test quiz description",
            questions: makeQuizQuestions(count: questionCount),
            timeLimit: 30,
            passingScore: 0.7,
            isTimed: true
        )
    }
    
    static func makeQuizQuestion(
        id: String = "q_1",
        type: String = "multiple_choice",
        correct: Bool = true
    ) -> QuizQuestion {
        QuizQuestion(
            id: id,
            type: type,
            question: "Test question?",
            options: ["Option A", "Option B", "Option C", "Option D"],
            correctAnswer: correct ? "Option A" : nil,
            correctAnswers: nil,
            explanation: "Test explanation",
            points: 10
        )
    }
    
    static func makeQuizQuestions(count: Int) -> [QuizQuestion] {
        (1...count).map { index in
            makeQuizQuestion(id: "q_\(index)")
        }
    }
    
    // MARK: - Lesson
    
    static func makeLesson(
        id: String = "lesson_1",
        courseId: String = "course_1",
        title: String = "Test Lesson",
        type: String = "video",
        isCompleted: Bool = false
    ) -> Lesson {
        Lesson(
            id: id,
            courseId: courseId,
            sectionId: nil,
            title: title,
            description: "Test lesson description",
            type: type,
            duration: 15,
            videoUrl: type == "video" ? "https://example.com/video.mp4" : nil,
            content: type == "text" ? "Test content" : nil,
            order: 1,
            isCompleted: isCompleted,
            progress: isCompleted ? 1.0 : 0.5
        )
    }
    
    static func makeLessons(count: Int, courseId: String = "course_1") -> [Lesson] {
        (1...count).map { index in
            makeLesson(
                id: "lesson_\(index)",
                courseId: courseId,
                title: "Lesson \(index)",
                type: index % 2 == 0 ? "video" : "text"
            )
        }
    }
    
    // MARK: - Economy
    
    static func makeTokenBalance(
        balance: Int = 1000,
        totalEarned: Int = 5000,
        totalSpent: Int = 4000
    ) -> TokenBalance {
        TokenBalance(
            balance: balance,
            totalEarned: totalEarned,
            totalSpent: totalSpent
        )
    }
    
    static func makeSwagItem(
        id: String = "item_1",
        name: String = "Cool Hat",
        category: String = "hats",
        rarity: String = "Rare",
        price: Int = 500,
        isOwned: Bool = false
    ) -> SwagItem {
        SwagItem(
            id: id,
            name: name,
            description: "Test item description",
            category: category,
            rarity: rarity,
            price: price,
            image: nil,
            isOwned: isOwned
        )
    }
    
    // MARK: - Social
    
    static func makeForum(
        id: String = "forum_1",
        name: String = "General Discussion",
        threadCount: Int? = 10
    ) -> Forum {
        Forum(
            id: id,
            name: name,
            description: "Test forum",
            courseId: nil,
            domain: nil,
            threadCount: threadCount
        )
    }
    
    static func makeForumThread(
        id: String = "thread_1",
        forumId: String = "forum_1",
        title: String = "Test Thread",
        replyCount: Int = 5
    ) -> ForumThread {
        ForumThread(
            id: id,
            forumId: forumId,
            title: title,
            content: "Test thread content",
            author: makeUserBasic(),
            replyCount: replyCount,
            viewCount: 100,
            upvotes: 10,
            isPinned: false,
            createdAt: Date().ISO8601Format(),
            updatedAt: Date().ISO8601Format()
        )
    }
    
    static func makeUserBasic(
        id: String = "user_1",
        username: String = "testuser",
        level: Int = 5
    ) -> UserBasic {
        UserBasic(
            id: id,
            username: username,
            avatar: nil,
            level: level
        )
    }
    
    // MARK: - Dashboard
    
    static func makeDashboardData() -> DashboardData {
        DashboardData(
            continueLearning: ContinueLearning(
                courseId: "course_1",
                courseTitle: "Test Course",
                lessonId: "lesson_1",
                lessonTitle: "Test Lesson",
                progress: 0.6
            ),
            recommendedCourses: makeCourses(count: 3),
            recentActivity: [
                ActivityItem(
                    id: "activity_1",
                    type: "lesson_completed",
                    title: "Completed lesson",
                    description: "You completed a lesson",
                    timestamp: Date().ISO8601Format(),
                    metadata: nil
                )
            ],
            quickStats: QuickStats(
                coursesInProgress: 3,
                coursesCompleted: 5,
                currentXP: 750,
                currentLevel: 12,
                studyStreak: 7
            ),
            upcomingDeadlines: []
        )
    }
    
    // MARK: - Certificates
    
    static func makeCertificate(
        id: String = "cert_1",
        title: String = "Completion Certificate",
        type: String = "course"
    ) -> Certificate {
        Certificate(
            id: id,
            type: type,
            title: title,
            courseId: type == "course" ? "course_1" : nil,
            programId: nil,
            issuedAt: Date().ISO8601Format(),
            verificationUrl: "https://example.com/verify/\(id)",
            pdfUrl: "https://example.com/certificates/\(id).pdf"
        )
    }
    
    // MARK: - Brain Profile
    
    static func makeBrainProfile() -> BrainProfile {
        BrainProfile(
            userId: "user_1",
            scores: BrainDomainScores(
                analytical: 0.8,
                creative: 0.6,
                practical: 0.7,
                theoretical: 0.9,
                intuitive: 0.5,
                structured: 0.85
            ),
            insights: BrainProfileInsights(
                learningStyle: "Analytical",
                strengths: ["Problem Solving", "Analysis"],
                growthAreas: ["Creativity", "Intuition"],
                recommendations: ["Try creative courses", "Explore intuitive learning"]
            ),
            recommendations: nil,
            completedAt: Date().ISO8601Format()
        )
    }
}
