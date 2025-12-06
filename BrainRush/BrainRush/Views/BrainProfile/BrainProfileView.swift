//
//  BrainProfileView.swift
//  BrainRush
//
//  Brain Profile view
//

import SwiftUI

struct BrainProfileView: View {
    @StateObject private var brainProfileService = BrainProfileService.shared
    @State private var showAssessment = false
    
    private var brainProfile: BrainProfile? {
        brainProfileService.brainProfile
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let profile = brainProfile {
                    VStack(spacing: 24) {
                        // Radar Chart
                        BrainProfileRadarChart(scores: profile.scores)
                            .frame(height: 300)
                        
                        // Insights
                        if let insights = profile.insights {
                            BrainProfileInsightsView(insights: insights)
                        }
                        
                        // Recommendations
                        if let recommendations = profile.recommendations {
                            BrainProfileRecommendationsView(recommendations: recommendations)
                        }
                        
                        Button("Retake Assessment") {
                            showAssessment = true
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    }
                    .padding()
                } else {
                    VStack(spacing: 24) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Complete Your Brain Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Take our assessment to discover your learning style and get personalized recommendations")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Start Assessment") {
                            showAssessment = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("Brain Profile")
            .sheet(isPresented: $showAssessment) {
                BrainProfileAssessmentView()
            }
            .task {
                await loadBrainProfile()
            }
        }
    }
    
    private func loadBrainProfile() async {
        await brainProfileService.loadBrainProfile()
    }
}

struct BrainProfileRadarChart: View {
    let scores: BrainDomainScores
    
    var body: some View {
        VStack {
            // Simple radar chart visualization
            ZStack {
                // Draw radar chart
                Text("Radar Chart")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Domain Labels
            HStack {
                DomainLabel(name: "Analytical", score: scores.analytical)
                DomainLabel(name: "Creative", score: scores.creative)
                DomainLabel(name: "Practical", score: scores.practical)
            }
            
            HStack {
                DomainLabel(name: "Theoretical", score: scores.theoretical)
                DomainLabel(name: "Intuitive", score: scores.intuitive)
                DomainLabel(name: "Structured", score: scores.structured)
            }
        }
    }
}

struct DomainLabel: View {
    let name: String
    let score: Double
    
    var body: some View {
        VStack {
            Text(name)
                .font(.caption)
            Text("\(Int(score * 100))%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BrainProfileInsightsView: View {
    let insights: BrainProfileInsights
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Learning Insights")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Learning Style: \(insights.learningStyle)")
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Strengths")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(insights.strengths, id: \.self) { strength in
                        Text("• \(strength)")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Growth Areas")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    ForEach(insights.growthAreas, id: \.self) { area in
                        Text("• \(area)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct BrainProfileRecommendationsView: View {
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personalized Recommendations")
                .font(.headline)
            
            ForEach(recommendations, id: \.self) { recommendation in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(recommendation)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct BrainProfileAssessmentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion = 0
    @State private var answers: [Int: Int] = [:]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                ProgressView(value: Double(currentQuestion + 1), total: 30)
                    .progressViewStyle(.linear)
                
                Text("Question \(currentQuestion + 1) of 30")
                    .font(.headline)
                
                // Question would go here
                Text("Sample question text")
                    .font(.body)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button("Previous") {
                        if currentQuestion > 0 {
                            currentQuestion -= 1
                        }
                    }
                    .disabled(currentQuestion == 0)
                    
                    Spacer()
                    
                    if currentQuestion < 29 {
                        Button("Next") {
                            currentQuestion += 1
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Complete") {
                            // Submit assessment
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("Brain Profile Assessment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BrainProfileView()
}
