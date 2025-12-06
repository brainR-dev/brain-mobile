//
//  ProgramsView.swift
//  BrainRush
//
//  Degree programs view
//

import SwiftUI

struct ProgramsView: View {
    @StateObject private var programService = ProgramService.shared
    @State private var searchText = ""
    @State private var selectedDomain: String?
    
    var filteredPrograms: [Program] {
        var programs = programService.programs
        
        if !searchText.isEmpty {
            programs = programs.filter { program in
                program.name.localizedCaseInsensitiveContains(searchText) ||
                program.description?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        if let domain = selectedDomain {
            programs = programs.filter { $0.domain == domain }
        }
        
        return programs
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search programs...", text: $searchText)
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
                
                if programService.isLoading && programService.programs.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredPrograms.isEmpty {
                    EmptyStateView(
                        icon: "graduationcap",
                        title: "No Programs Found",
                        message: "Try adjusting your search or filters"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredPrograms) { program in
                                NavigationLink(destination: ProgramDetailView(programId: program.id)) {
                                    ProgramRowView(program: program)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Degree Programs")
            .refreshable {
                await programService.loadPrograms()
            }
            .task {
                if programService.programs.isEmpty {
                    await programService.loadPrograms()
                }
            }
        }
    }
}

struct ProgramRowView: View {
    let program: Program
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(program.name)
                        .font(.headline)
                    
                    if let description = program.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    HStack {
                        if let degreeType = program.degreeType {
                            BadgeView(degreeType, color: .blue)
                        }
                        
                        if let domain = program.domain {
                            BadgeView(domain, color: .green)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            
            if let enrollmentCount = program.enrollmentCount {
                Text("\(enrollmentCount) students enrolled")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ProgramDetailView: View {
    let programId: String
    @StateObject private var programService = ProgramService.shared
    @State private var program: Program?
    @State private var isLoading = false
    @State private var isEnrolled = false
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let program = program {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(program.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        if let degreeType = program.degreeType {
                            BadgeView(degreeType, color: .blue)
                        }
                        
                        if let description = program.description {
                            Text(description)
                                .font(.body)
                        }
                    }
                    .padding()
                    
                    // Stats
                    HStack(spacing: 24) {
                        if let enrollmentCount = program.enrollmentCount {
                            StatBadge(icon: "person.3.fill", value: "\(enrollmentCount)", color: .green)
                        }
                        
                        if let duration = program.duration {
                            StatBadge(icon: "clock.fill", value: "\(duration) months", color: .blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Courses in Program
                    if let programCourses = program.courses, !programCourses.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Program Courses")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(programCourses) { programCourse in
                                NavigationLink(destination: CourseDetailView(courseId: programCourse.courseId)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(programCourse.title)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            if programCourse.isRequired {
                                                BadgeView("Required", color: .red)
                                            } else {
                                                BadgeView("Optional", color: .blue)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Enroll Button
                    Button(action: enrollInProgram) {
                        Text(isEnrolled ? "Enrolled" : "Enroll in Program")
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
                program = try await programService.loadProgramDetails(programId: programId)
            } catch {
                // Handle error
            }
            isLoading = false
        }
    }
    
    private func enrollInProgram() {
        guard let program = program else { return }
        Task {
            do {
                try await programService.enrollInProgram(programId: program.id)
                isEnrolled = true
            } catch {
                // Handle error
            }
        }
    }
}

#Preview {
    ProgramsView()
}
