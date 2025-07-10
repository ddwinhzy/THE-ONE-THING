//
//  SettingsView.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    @State private var focusDurationMinutes: Double = 25
    @State private var breakDurationMinutes: Double = 5
    @State private var longBreakDurationMinutes: Double = 15
    
    var body: some View {
        NavigationView {
            Form {
                Section("Pomodoro Timer") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Focus Duration")
                            .font(.headline)
                        
                        HStack {
                            Slider(value: $focusDurationMinutes, in: 5...60, step: 5) {
                                Text("Focus Duration")
                            }
                            .onChange(of: focusDurationMinutes) { _, newValue in
                                appState.pomodoroSettings.focusDuration = newValue * 60
                            }
                            
                            Text("\(Int(focusDurationMinutes)) min")
                                .foregroundColor(.secondary)
                                .frame(width: 60)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Break Duration")
                            .font(.headline)
                        
                        HStack {
                            Slider(value: $breakDurationMinutes, in: 2...30, step: 1) {
                                Text("Break Duration")
                            }
                            .onChange(of: breakDurationMinutes) { _, newValue in
                                appState.pomodoroSettings.breakDuration = newValue * 60
                            }
                            
                            Text("\(Int(breakDurationMinutes)) min")
                                .foregroundColor(.secondary)
                                .frame(width: 60)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Long Break Duration")
                            .font(.headline)
                        
                        HStack {
                            Slider(value: $longBreakDurationMinutes, in: 10...60, step: 5) {
                                Text("Long Break Duration")
                            }
                            .onChange(of: longBreakDurationMinutes) { _, newValue in
                                appState.pomodoroSettings.longBreakDuration = newValue * 60
                            }
                            
                            Text("\(Int(longBreakDurationMinutes)) min")
                                .foregroundColor(.secondary)
                                .frame(width: 60)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("The One Thing")
                            .font(.headline)
                        
                        Text("Version 1.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Focus on what matters most. One task at a time.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            focusDurationMinutes = appState.pomodoroSettings.focusDuration / 60
            breakDurationMinutes = appState.pomodoroSettings.breakDuration / 60
            longBreakDurationMinutes = appState.pomodoroSettings.longBreakDuration / 60
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}