//
//  LessonView.swift
//  BrainRush
//
//  Lesson content view
//

import SwiftUI
import AVKit

struct LessonView: View {
    let lessonId: String
    let courseId: String
    
    @StateObject private var lessonService = LessonService.shared
    @State private var lesson: Lesson?
    @State private var isLoading = false
    @State private var videoPlayer: AVPlayer?
    @State private var showNotes = false
    @State private var notes: String = ""
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let lesson = lesson {
                VStack(alignment: .leading, spacing: 24) {
                    // Video Player (if video lesson)
                    if let videoUrl = lesson.videoUrl, !videoUrl.isEmpty {
                        VideoPlayer(player: videoPlayer)
                            .frame(height: 250)
                            .cornerRadius(12)
                            .onAppear {
                                if let url = URL(string: videoUrl) {
                                    videoPlayer = AVPlayer(url: url)
                                }
                            }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text(lesson.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        if let description = lesson.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Text content
                        if let content = lesson.content, !content.isEmpty {
                            Text(content)
                                .font(.body)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showNotes.toggle() }) {
                    Image(systemName: "note.text")
                }
            }
        }
        .sheet(isPresented: $showNotes) {
            NotesView(notes: $notes, lessonId: lessonId)
        }
        .task {
            AnalyticsService.shared.trackScreen("lesson", properties: [
                "lesson_id": lessonId,
                "course_id": courseId
            ])
            await loadLesson()
        }
    }
    
    private func loadLesson() async {
        isLoading = true
        do {
            lesson = try await lessonService.loadLesson(lessonId: lessonId)
            
            // Track lesson started
            if let lesson = lesson {
                AnalyticsService.shared.trackLessonStarted(
                    courseId: courseId,
                    lessonId: lessonId,
                    lessonTitle: lesson.title
                )
            }
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_lesson",
                "lesson_id": lessonId,
                "course_id": courseId
            ])
        }
        isLoading = false
    }
}

struct NotesView: View {
    @Binding var notes: String
    let lessonId: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .padding()
                .navigationTitle("Notes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            // Save notes
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    LessonView(lessonId: "1", courseId: "1")
}
