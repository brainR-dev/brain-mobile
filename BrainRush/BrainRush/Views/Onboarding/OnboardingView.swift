//
//  OnboardingView.swift
//  BrainRush
//
//  Onboarding view
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthService
    @State private var currentStep = 0
    @State private var selectedGoals: Set<String> = []
    @State private var showBrainProfile = false
    
    let onboardingSteps = [
        OnboardingStep(title: "Welcome to BrainRush!", description: "Your personalized learning journey starts here", icon: "brain.head.profile"),
        OnboardingStep(title: "Set Your Goals", description: "What do you want to achieve?", icon: "target"),
        OnboardingStep(title: "Discover Your Learning Style", description: "Take the Brain Profile assessment", icon: "chart.bar.fill")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressView(value: Double(currentStep + 1), total: Double(onboardingSteps.count))
                .progressViewStyle(.linear)
                .padding()
            
            // Content
            TabView(selection: $currentStep) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    OnboardingStepView(step: onboardingSteps[index], index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Action buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                
                Button(currentStep == onboardingSteps.count - 1 ? "Get Started" : "Next") {
                    if currentStep == onboardingSteps.count - 1 {
                        completeOnboarding()
                    } else {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .task {
            AnalyticsService.shared.trackScreen("onboarding", properties: [
                "step": currentStep
            ])
        }
        .onChange(of: currentStep) { newStep in
            AnalyticsService.shared.trackScreen("onboarding", properties: [
                "step": newStep
            ])
        }
        .sheet(isPresented: $showBrainProfile) {
            BrainProfileAssessmentView()
        }
    }
    
    private func completeOnboarding() {
        Task {
            AnalyticsService.shared.track("onboarding_completed", properties: [
                "goals_selected": Array(selectedGoals),
                "steps_completed": onboardingSteps.count
            ])
            
            // Mark onboarding as complete
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            
            // Navigate to dashboard
            // This will be handled by RootView
        }
    }
}

struct OnboardingStep {
    let title: String
    let description: String
    let icon: String
}

struct OnboardingStepView: View {
    let step: OnboardingStep
    let index: Int
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: step.icon)
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(step.description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthService.shared)
}
