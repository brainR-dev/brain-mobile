//
//  CoursesView.swift
//  BrainRush
//
//  Courses catalog view
//

import SwiftUI

struct CoursesView: View {
    @StateObject private var courseService = CourseService.shared
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showFilters = false
    
    var filteredCourses: [Course] {
        var courses = courseService.courses
        
        if !searchText.isEmpty {
            courses = courses.filter { course in
                course.title.localizedCaseInsensitiveContains(searchText) ||
                course.description?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        if let category = selectedCategory {
            courses = courses.filter { $0.category == category || $0.domain == category }
        }
        
        return courses
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search courses...", text: $searchText)
                        .textFieldStyle(.plain)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if courseService.isLoading && courseService.courses.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredCourses.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No courses found")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredCourses) { course in
                                NavigationLink(destination: CourseDetailView(courseId: course.id)) {
                                    CourseRowView(course: course)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                CourseFiltersView(selectedCategory: $selectedCategory)
            }
            .refreshable {
                await courseService.loadCourses()
            }
            .task {
                if courseService.courses.isEmpty {
                    await courseService.loadCourses()
                }
            }
        }
    }
}

struct CourseRowView: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 100, height: 70)
                .overlay(
                    Image(systemName: "book.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let instructor = course.instructor {
                    Text("by \(instructor)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    if let rating = course.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                        }
                    }
                    
                    if let duration = course.duration {
                        Text("• \(duration) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CourseFiltersView: View {
    @Binding var selectedCategory: String?
    @Environment(\.dismiss) private var dismiss
    
    let categories = ["All", "Business", "Computer Science", "Healthcare", "Education", "Psychology", "Engineering"]
    
    var body: some View {
        NavigationView {
            List {
                Section("Category") {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category == "All" ? nil : category
                            dismiss()
                        }) {
                            HStack {
                                Text(category)
                                Spacer()
                                if selectedCategory == category || (category == "All" && selectedCategory == nil) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CourseDetailView: View {
    let courseId: String
    @StateObject private var courseService = CourseService.shared
    @State private var course: Course?
    @State private var isLoading = false
    @State private var isEnrolled = false
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let course = course {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(course.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        if let instructor = course.instructor {
                            Text("by \(instructor)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let description = course.description {
                            Text(description)
                                .font(.body)
                        }
                    }
                    .padding()
                    
                    // Stats
                    HStack(spacing: 24) {
                        if let rating = course.rating {
                            StatBadge(icon: "star.fill", value: String(format: "%.1f", rating), color: .yellow)
                        }
                        if let duration = course.duration {
                            StatBadge(icon: "clock.fill", value: "\(duration) min", color: .blue)
                        }
                        if let enrollmentCount = course.enrollmentCount {
                            StatBadge(icon: "person.3.fill", value: "\(enrollmentCount)", color: .green)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sections
                    if let sections = course.sections, !sections.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Course Content")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(sections) { section in
                                CourseSectionView(section: section)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Enroll Button
                    Button(action: enrollInCourse) {
                        Text(isEnrolled ? "Enrolled" : "Enroll in Course")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isEnrolled)
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            isLoading = true
            do {
                course = try await courseService.loadCourseDetails(courseId: courseId)
            } catch {
                // Handle error
            }
            isLoading = false
        }
    }
    
    private func enrollInCourse() {
        guard let course = course else { return }
        Task {
            do {
                try await courseService.enrollInCourse(courseId: course.id)
                isEnrolled = true
            } catch {
                // Handle error
            }
        }
    }
}

struct CourseSectionView: View {
    let section: CourseSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.headline)
            
            if let lessons = section.lessons {
                ForEach(lessons) { lesson in
                    HStack {
                        Image(systemName: iconForLessonType(lesson.type))
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text(lesson.title)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        if let duration = lesson.duration {
                            Text("\(duration)m")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func iconForLessonType(_ type: String) -> String {
        switch type {
        case "video": return "play.circle.fill"
        case "text": return "doc.text.fill"
        case "quiz": return "questionmark.circle.fill"
        default: return "circle.fill"
        }
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(value)
                .font(.caption)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    CoursesView()
}
