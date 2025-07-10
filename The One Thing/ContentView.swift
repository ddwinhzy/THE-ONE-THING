//
//  ContentView.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        Group {
            if appState.showOnboarding {
                OnboardingView()
            } else if appState.isInFocusMode {
                FocusModeView()
            } else {
                TaskQueueView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isInFocusMode)
        .animation(.easeInOut(duration: 0.5), value: appState.showOnboarding)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
        .modelContainer(for: Task.self, inMemory: true)
}
