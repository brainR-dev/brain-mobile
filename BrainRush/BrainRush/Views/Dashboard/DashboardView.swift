//
//  DashboardView.swift
//  BrainRush
//
//  Dashboard view
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var dashboardService = DashboardService.shared
    @StateObject private var authService = AuthService.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if dashboardService.isLoading && dashboardService.dashboardData == nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if let data = dashboardService.dashboardData {
                        // Quick Stats
                        QuickStatsView(stats: data.quickStats)
                            .padding(.horizontal)
                        
                        // Continue Learning
                        if let continueLearning = data.continueLearning {
                            ContinueLearningCard(continueLearning: continueLearning)
                                .padding(.horizontal)
                        }
                        
                        // Recommended Courses
                        if !data.recommendedCourses.isEmpty {
                            RecommendedCoursesSection(courses: data.recommendedCourses)
                                .padding(.horizontal)
                        }
                        
                        // Recent Activity
                        if !data.recentActivity.isEmpty {
                            RecentActivitySection(activities: data.recentActivity)
                                .padding(.horizontal)
                        }
                        
                        // Upcoming Deadlines
                        if !data.upcomingDeadlines.isEmpty {
                            UpcomingDeadlinesSection(deadlines: data.upcomingDeadlines)
                                .padding(.horizontal)
                        }
                    } else if let error = dashboardService.errorMessage {
                        ErrorView(message: error) {
                            Task {
                                await dashboardService.loadDashboard()
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("BrainRush")
            .refreshable {
                await dashboardService.loadDashboard()
            }
            .task {
                if dashboardService.dashboardData == nil {
                    await dashboardService.loadDashboard()
                }
            }
        }
    }
}

// MARK: - Quick Stats View

struct QuickStatsView: View {
    let stats: QuickStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.headline)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Level",
                    value: "\(stats.currentLevel)",
                    icon: "star.fill",
                    color: .yellow
                )
                
                StatCard(
                    title: "XP",
                    value: "\(stats.currentXP)",
                    icon: "bolt.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Streak",
                    value: "\(stats.studyStreak) 🔥",
                    icon: "flame.fill",
                    color: .orange
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "In Progress",
                    value: "\(stats.coursesInProgress)",
                    icon: "book.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Completed",
                    value: "\(stats.coursesCompleted)",
                    icon: "checkmark.circle.fill",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Continue Learning Card

struct ContinueLearningCard: View {
    let continueLearning: ContinueLearning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Learning")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(continueLearning.courseTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(continueLearning.lessonTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ProgressView(value: continueLearning.progress)
                    .tint(.blue)
                
                Text("\(Int(continueLearning.progress * 100))% complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Recommended Courses Section

struct RecommendedCoursesSection: View {
    let courses: [Course]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended for You")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(courses) { course in
                        CourseCard(course: course)
                    }
                }
            }
        }
    }
}

struct CourseCard: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 200, height: 120)
                .overlay(
                    Image(systemName: "book.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                )
            
            Text(course.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            if let rating = course.rating {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                }
            }
        }
        .frame(width: 200)
    }
}

// MARK: - Recent Activity Section

struct RecentActivitySection: View {
    let activities: [ActivityItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(activities.prefix(5)) { activity in
                    ActivityRow(activity: activity)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForType(activity.type))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                if let description = activity.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
    
    private func iconForType(_ type: String) -> String {
        switch type {
        case "lesson_completed": return "checkmark.circle.fill"
        case "achievement_unlocked": return "trophy.fill"
        case "level_up": return "arrow.up.circle.fill"
        default: return "circle.fill"
        }
    }
}

// MARK: - Upcoming Deadlines Section

struct UpcomingDeadlinesSection: View {
    let deadlines: [Deadline]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Deadlines")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(deadlines.prefix(3)) { deadline in
                    DeadlineRow(deadline: deadline)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct DeadlineRow: View {
    let deadline: Deadline
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(deadline.title)
                    .font(.subheadline)
                if let courseTitle = deadline.courseTitle {
                    Text(courseTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(formatDate(deadline.dueDate))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        // Simple date formatting - can be enhanced
        return dateString
    }
}

// MARK: - Error View

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}
