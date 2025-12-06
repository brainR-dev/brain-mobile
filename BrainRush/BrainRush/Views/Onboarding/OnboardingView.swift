//
//  OnboardingView.swift
//  BrainRush
//
//  Onboarding flow
//

import SwiftUI

enum OnboardingStep {
    case welcome
    case goalSelection
    case brainProfile
    case profileSetup
    case complete
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: OnboardingStep = .welcome
    @State private var selectedGoal: String?
    @State private var hasCompletedBrainProfile = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            TabView(selection: $currentStep) {
                WelcomeStepView(onContinue: {
                    withAnimation {
                        currentStep = .goalSelection
                    }
                })
                .tag(OnboardingStep.welcome)
                
                GoalSelectionStepView(selectedGoal: $selectedGoal, onContinue: {
                    withAnimation {
                        currentStep = .brainProfile
                    }
                })
                .tag(OnboardingStep.goalSelection)
                
                BrainProfileStepView(onComplete: {
                    hasCompletedBrainProfile = true
                    withAnimation {
                        currentStep = .profileSetup
                    }
                })
                .tag(OnboardingStep.brainProfile)
                
                ProfileSetupStepView(onComplete: {
                    withAnimation {
                        currentStep = .complete
                    }
                })
                .tag(OnboardingStep.profileSetup)
                
                OnboardingCompleteView(onContinue: {
                    dismiss()
                })
                .tag(OnboardingStep.complete)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

// MARK: - Welcome Step

struct WelcomeStepView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Animated brain icon
            Image(systemName: "brain.head.profile")
                .font(.system(size: 120))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.pulse, options: .repeating)
            
            VStack(spacing: 16) {
                Text("Welcome to BrainRush!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Turn learning into a game.\nEarn XP, level up, and unlock achievements.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

// MARK: - Goal Selection Step

struct GoalSelectionStepView: View {
    @Binding var selectedGoal: String?
    let onContinue: () -> Void
    
    let goals = [
        ("career-change", "Career Change", "landscape.fill", "Switch to a new career"),
        ("skill-building", "Skill Building", "hammer.fill", "Learn new skills"),
        ("degree", "Degree Program", "graduationcap.fill", "Complete a degree"),
        ("personal-growth", "Personal Growth", "heart.fill", "Grow personally")
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Text("What's your goal?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose what you want to achieve")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            VStack(spacing: 16) {
                ForEach(goals, id: \.0) { goal in
                    GoalCard(
                        id: goal.0,
                        title: goal.1,
                        icon: goal.2,
                        description: goal.3,
                        isSelected: selectedGoal == goal.0
                    ) {
                        selectedGoal = goal.0
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedGoal == nil)
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

struct GoalCard: View {
    let id: String
    let title: String
    let icon: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Brain Profile Step

struct BrainProfileStepView: View {
    let onComplete: () -> Void
    
    @State private var currentQuestion = 0
    @State private var answers: [Int: Int] = [:]
    @State private var isComplete = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("Brain Profile Assessment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Help us understand your learning style")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            // Progress indicator
            ProgressView(value: Double(currentQuestion + 1), total: 10)
                .progressViewStyle(.linear)
                .padding(.horizontal, 32)
            
            // Question card would go here
            // For now, show a placeholder
            VStack(spacing: 24) {
                Text("Question \(currentQuestion + 1) of 10")
                    .font(.headline)
                
                Text("Sample question text would appear here")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 300)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button("Skip") {
                    onComplete()
                }
                .buttonStyle(.bordered)
                
                Button("Continue") {
                    if currentQuestion < 9 {
                        currentQuestion += 1
                    } else {
                        isComplete = true
                        onComplete()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

// MARK: - Profile Setup Step

struct ProfileSetupStepView: View {
    let onComplete: () -> Void
    
    @State private var name = ""
    @State private var selectedAvatar: String?
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Text("Complete Your Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Add your details (optional)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            VStack(spacing: 24) {
                // Avatar selection placeholder
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                    )
                
                TextField("Your Name (Optional)", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: onComplete) {
                Text("Complete Setup")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

// MARK: - Complete Step

struct OnboardingCompleteView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Celebration animation
            Image(systemName: "party.popper.fill")
                .font(.system(size: 120))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.bounce, value: UUID())
            
            VStack(spacing: 16) {
                Text("You're All Set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Ready to start learning and earning?")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Let's Go!")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    OnboardingView()
}
