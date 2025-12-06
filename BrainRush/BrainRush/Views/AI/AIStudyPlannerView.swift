//
//  AIStudyPlannerView.swift
//  BrainRush
//
//  AI Study Planner view
//

import SwiftUI

struct AIStudyPlannerView: View {
    @StateObject private var plannerService = AIStudyPlannerService.shared
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Calendar View
                    CalendarView(selectedDate: $selectedDate)
                    
                    // Schedule for Selected Date
                    if let schedule = plannerService.schedule {
                        ScheduleDayView(
                            date: selectedDate,
                            sessions: schedule.sessions.filter { isSessionOnDate($0, date: selectedDate) }
                        )
                    }
                    
                    // Predictions
                    if let predictions = plannerService.schedule?.predictions {
                        PredictionsCard(predictions: predictions)
                    }
                }
                .padding()
            }
            .navigationTitle("Study Planner")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Generate") {
                        Task {
                            await plannerService.generateSchedule()
                        }
                    }
                }
            }
            .task {
                await plannerService.loadSchedule()
            }
        }
    }
    
    private func isSessionOnDate(_ session: StudySession, date: Date) -> Bool {
        // Check if session is on the selected date
        return true
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            Text("December 2024")
                .font(.headline)
            
            // Calendar grid would go here
            Text("Calendar View")
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

struct ScheduleDayView: View {
    let date: Date
    let sessions: [StudySession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule for \(formatDate(date))")
                .font(.headline)
            
            if sessions.isEmpty {
                Text("No sessions scheduled")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(sessions) { session in
                    StudySessionCard(session: session)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct StudySessionCard: View {
    let session: StudySession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.headline)
                Text(formatTime(session.startTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(session.duration) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if session.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatTime(_ timeString: String) -> String {
        return timeString
    }
}

struct PredictionsCard: View {
    let predictions: StudyPredictions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Predictions & Insights")
                .font(.headline)
            
            if let completionDate = predictions.completionDate {
                HStack {
                    Image(systemName: "calendar")
                    Text("Estimated Completion: \(completionDate)")
                        .font(.subheadline)
                }
            }
            
            if !predictions.riskFactors.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Risk Factors:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(predictions.riskFactors, id: \.self) { factor in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(factor)
                                .font(.caption)
                        }
                    }
                }
            }
            
            HStack {
                Text("Confidence: \(Int(predictions.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                ProgressView(value: predictions.confidence)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

@MainActor
class AIStudyPlannerService: ObservableObject {
    static let shared = AIStudyPlannerService()
    
    @Published var schedule: StudySchedule?
    @Published var isLoading = false
    
    func loadSchedule() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let schedule: StudySchedule = try await APIClient.shared.request(
                endpoint: "/mobile/ai/study-planner",
                method: "GET",
                accessToken: token
            )
            self.schedule = schedule
        } catch {
            // Handle error
        }
    }
    
    func generateSchedule() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let schedule: StudySchedule = try await APIClient.shared.request(
                endpoint: "/mobile/ai/study-planner",
                method: "POST",
                accessToken: token,
                body: [:]
            )
            self.schedule = schedule
        } catch {
            // Handle error
        }
    }
}

#Preview {
    AIStudyPlannerView()
}
