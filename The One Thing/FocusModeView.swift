//
//  FocusModeView.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import SwiftUI

struct FocusModeView: View {
    @Environment(AppState.self) private var appState
    @State private var showingCompletionConfirmation = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Exit button
                HStack {
                    Button(action: exitFocusMode) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Current task
                VStack(spacing: 20) {
                    Text("Your One Thing")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(appState.currentTask?.title ?? "")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Timer component
                PomodoroTimerView()
                
                Spacer()
                
                // Complete button
                Button(action: {
                    showingCompletionConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Complete")
                    }
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .confirmationDialog(
                    "Mark as Complete?",
                    isPresented: $showingCompletionConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Complete Task") {
                        completeTask()
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            .padding(.vertical)
        }
        .preferredColorScheme(.dark)
    }
    
    private func exitFocusMode() {
        withAnimation(.easeInOut(duration: 0.5)) {
            appState.exitFocusMode()
        }
    }
    
    private func completeTask() {
        HapticManager.shared.playTaskComplete()
        SoundManager.shared.playTaskComplete()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            appState.completeCurrentTask()
        }
    }
}

struct PomodoroTimerView: View {
    @Environment(AppState.self) private var appState
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            // Timer display
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                
                VStack {
                    Text(timeString)
                        .font(.system(size: 36, weight: .light, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text(appState.isOnBreak ? "Break" : "Focus")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Timer controls
            HStack(spacing: 30) {
                Button(action: toggleTimer) {
                    Image(systemName: appState.isTimerRunning ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Button(action: resetTimer) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
        .onAppear {
            startTimerIfNeeded()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var progress: Double {
        let totalTime = appState.isOnBreak ? appState.pomodoroSettings.breakDuration : appState.pomodoroSettings.focusDuration
        return 1.0 - (appState.pomodoroTimeRemaining / totalTime)
    }
    
    private var timeString: String {
        let minutes = Int(appState.pomodoroTimeRemaining) / 60
        let seconds = Int(appState.pomodoroTimeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        if appState.isTimerRunning {
            appState.pauseTimer()
            stopTimer()
            NotificationManager.shared.cancelAllNotifications()
            updateLiveActivity()
        } else {
            HapticManager.shared.playTimerStart()
            SoundManager.shared.playButtonTap()
            appState.startTimer()
            startTimerIfNeeded()
            
            // Schedule notification for timer completion
            NotificationManager.shared.scheduleTimerCompleteNotification(
                for: appState.pomodoroTimeRemaining,
                isBreak: appState.isOnBreak
            )
            
            // Start or update Live Activity
            startOrUpdateLiveActivity()
        }
    }
    
    private func resetTimer() {
        appState.resetTimer()
        stopTimer()
        NotificationManager.shared.cancelAllNotifications()
        LiveActivityManager.shared.endLiveActivity()
    }
    
    private func startTimerIfNeeded() {
        guard appState.isTimerRunning && timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if appState.pomodoroTimeRemaining > 0 {
                appState.pomodoroTimeRemaining -= 1
                // Update Live Activity every 30 seconds to preserve battery
                if Int(appState.pomodoroTimeRemaining) % 30 == 0 {
                    updateLiveActivity()
                }
            } else {
                // Timer completed
                HapticManager.shared.playSuccess()
                SoundManager.shared.playTimerComplete()
                
                appState.isTimerRunning = false
                appState.isOnBreak.toggle()
                appState.pomodoroTimeRemaining = appState.isOnBreak ? 
                    appState.pomodoroSettings.breakDuration : 
                    appState.pomodoroSettings.focusDuration
                stopTimer()
                
                // End current Live Activity when timer completes
                LiveActivityManager.shared.endLiveActivity()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startOrUpdateLiveActivity() {
        guard let taskTitle = appState.currentTask?.title else { return }
        
        LiveActivityManager.shared.startLiveActivity(
            taskTitle: taskTitle,
            timeRemaining: appState.pomodoroTimeRemaining,
            isRunning: appState.isTimerRunning,
            isOnBreak: appState.isOnBreak
        )
    }
    
    private func updateLiveActivity() {
        LiveActivityManager.shared.updateLiveActivity(
            timeRemaining: appState.pomodoroTimeRemaining,
            isRunning: appState.isTimerRunning,
            isOnBreak: appState.isOnBreak
        )
    }
}

#Preview {
    FocusModeView()
        .environment({
            let appState = AppState()
            appState.currentTask = Task(title: "Complete the mobile app prototype")
            appState.isInFocusMode = true
            return appState
        }())
}