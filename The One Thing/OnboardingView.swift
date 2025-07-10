//
//  OnboardingView.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var currentPage = 0
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Page content
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    oneThingPage.tag(1)
                    focusPage.tag(2)
                    getStartedPage.tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                Spacer()
                
                // Page indicators and navigation
                VStack(spacing: 30) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.primary : Color.primary.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Navigation buttons
                    HStack {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if currentPage < totalPages - 1 {
                            Button("Next") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button("Get Started") {
                                completeOnboarding()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private var welcomePage: some View {
        OnboardingPageView(
            systemImage: "target",
            title: "Welcome to\nThe One Thing",
            description: "Focus on what matters most. One task at a time.",
            backgroundColor: .blue
        )
    }
    
    private var oneThingPage: some View {
        OnboardingPageView(
            systemImage: "1.circle.fill",
            title: "What's Your\nOne Thing?",
            description: "Choose your most important task and give it your complete attention.",
            backgroundColor: .purple
        )
    }
    
    private var focusPage: some View {
        OnboardingPageView(
            systemImage: "eye.slash",
            title: "Everything Else\nis a Distraction",
            description: "We'll hide all other tasks so you can focus on what matters most.",
            backgroundColor: .indigo
        )
    }
    
    private var getStartedPage: some View {
        OnboardingPageView(
            systemImage: "timer",
            title: "Ready to\nFocus?",
            description: "Use the built-in Pomodoro timer to structure your focus sessions.",
            backgroundColor: .teal
        )
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            appState.showOnboarding = false
        }
    }
}

struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let description: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 40) {
            // Icon with morphing animation
            ZStack {
                Circle()
                    .fill(backgroundColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(backgroundColor)
            }
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: backgroundColor)
            
            // Title
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            // Description
            Text(description)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
}