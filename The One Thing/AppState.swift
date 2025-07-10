//
//  AppState.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import Foundation
import SwiftUI

@Observable
class AppState {
    var currentTask: Task?
    var isInFocusMode: Bool = false
    var showOnboarding: Bool = true
    var pomodoroTimeRemaining: TimeInterval = 25 * 60 // 25 minutes
    var isTimerRunning: Bool = false
    var isOnBreak: Bool = false
    var pomodoroSettings = PomodoroSettings()
    
    func startFocusMode(with task: Task) {
        self.currentTask = task
        self.isInFocusMode = true
        self.pomodoroTimeRemaining = pomodoroSettings.focusDuration
    }
    
    func exitFocusMode() {
        self.isInFocusMode = false
        self.currentTask = nil
        self.isTimerRunning = false
        self.pomodoroTimeRemaining = pomodoroSettings.focusDuration
    }
    
    func completeCurrentTask() {
        currentTask?.complete()
        exitFocusMode()
    }
    
    func startTimer() {
        isTimerRunning = true
    }
    
    func pauseTimer() {
        isTimerRunning = false
    }
    
    func resetTimer() {
        isTimerRunning = false
        pomodoroTimeRemaining = isOnBreak ? pomodoroSettings.breakDuration : pomodoroSettings.focusDuration
    }
}

struct PomodoroSettings {
    var focusDuration: TimeInterval = 25 * 60 // 25 minutes
    var breakDuration: TimeInterval = 5 * 60 // 5 minutes
    var longBreakDuration: TimeInterval = 15 * 60 // 15 minutes
}