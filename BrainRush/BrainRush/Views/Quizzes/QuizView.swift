//
//  QuizView.swift
//  BrainRush
//
//  Quiz taking view
//

import SwiftUI

struct QuizView: View {
    let quizId: String
    @StateObject private var quizService = QuizService.shared
    @State private var quiz: Quiz?
    @State private var currentQuestionIndex = 0
    @State private var answers: [String: String] = [:]
    @State private var showResults = false
    @State private var quizResult: QuizResult?
    @State private var timeRemaining: Int?
    
    var currentQuestion: QuizQuestion? {
        quiz?.questions[safe: currentQuestionIndex]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress and Timer
                VStack(spacing: 8) {
                    ProgressView(value: Double(currentQuestionIndex + 1), total: Double(quiz?.questions.count ?? 1))
                        .progressViewStyle(.linear)
                    
                    HStack {
                        Text("Question \(currentQuestionIndex + 1) of \(quiz?.questions.count ?? 0)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let timeRemaining = timeRemaining {
                            Text(formatTime(timeRemaining))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                
                // Question
                if let question = currentQuestion {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text(question.question)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            QuestionInputView(
                                question: question,
                                answer: Binding(
                                    get: { answers[question.id] ?? "" },
                                    set: { answers[question.id] = $0 }
                                )
                            )
                        }
                        .padding()
                    }
                }
                
                // Navigation
                HStack(spacing: 16) {
                    Button("Previous") {
                        if currentQuestionIndex > 0 {
                            currentQuestionIndex -= 1
                        }
                    }
                    .disabled(currentQuestionIndex == 0)
                    
                    Spacer()
                    
                    if currentQuestionIndex == (quiz?.questions.count ?? 0) - 1 {
                        Button("Submit") {
                            submitQuiz()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Next") {
                            currentQuestionIndex += 1
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle(quiz?.title ?? "Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showResults) {
                QuizResultsView(quizId: quizId)
            }
            .task {
                AnalyticsService.shared.trackScreen("quiz", properties: [
                    "quiz_id": quizId
                ])
                await loadQuiz()
                startTimer()
            }
        }
    }
    
    private func loadQuiz() async {
        do {
            quiz = try await quizService.loadQuiz(quizId: quizId)
        } catch {
            // Handle error
        }
    }
    
    private func startTimer() {
        // Start timer if quiz is timed
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
    
    private func submitQuiz() {
        Task {
            do {
                guard let quiz = quiz else { return }
                let result = try await quizService.submitQuiz(quizId: quiz.id, answers: answers)
                quizResult = result
                showResults = true
            } catch {
                // Handle error
            }
        }
    }
}

struct QuestionInputView: View {
    let question: QuizQuestion
    @Binding var answer: String
    
    var body: some View {
        switch question.type {
        case "multiple_choice":
            MultipleChoiceView(question: question, answer: $answer)
        case "true_false":
            TrueFalseView(question: question, answer: $answer)
        case "fill_blank", "short_answer":
            TextField("Your answer", text: $answer)
                .textFieldStyle(.roundedBorder)
        case "essay":
            TextEditor(text: $answer)
                .frame(height: 200)
                .border(Color.gray.opacity(0.3))
        default:
            TextField("Your answer", text: $answer)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct MultipleChoiceView: View {
    let question: QuizQuestion
    @Binding var answer: String
    
    var body: some View {
        VStack(spacing: 12) {
            if let options = question.options {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        answer = option
                    }) {
                        HStack {
                            Text(option)
                                .foregroundColor(.primary)
                            Spacer()
                            if answer == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(answer == option ? Color.blue.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct TrueFalseView: View {
    let question: QuizQuestion
    @Binding var answer: String
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { answer = "true" }) {
                HStack {
                    Text("True")
                        .foregroundColor(.primary)
                    Spacer()
                    if answer == "true" {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(answer == "true" ? Color.blue.opacity(0.1) : Color(.systemGray6))
                .cornerRadius(12)
            }
            
            Button(action: { answer = "false" }) {
                HStack {
                    Text("False")
                        .foregroundColor(.primary)
                    Spacer()
                    if answer == "false" {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(answer == "false" ? Color.blue.opacity(0.1) : Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

struct QuizResultsView: View {
    let quizId: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Quiz Complete!")
                    .font(.title)
                Button("Close") {
                    dismiss()
                }
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    QuizView(quizId: "1")
}
