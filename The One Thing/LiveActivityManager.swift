//
//  LiveActivityManager.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import Foundation

// Placeholder for Live Activities - will be implemented in future version
class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    
    private init() {}
    
    func startLiveActivity(taskTitle: String, timeRemaining: TimeInterval, isRunning: Bool, isOnBreak: Bool) {
        // Live Activities not implemented yet
        print("Live Activity would start for: \(taskTitle)")
    }
    
    func updateLiveActivity(timeRemaining: TimeInterval, isRunning: Bool, isOnBreak: Bool) {
        // Live Activities not implemented yet
        print("Live Activity would update with time: \(timeRemaining)")
    }
    
    func endLiveActivity() {
        // Live Activities not implemented yet
        print("Live Activity would end")
    }
}