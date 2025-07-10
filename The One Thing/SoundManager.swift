//
//  SoundManager.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playTaskComplete() {
        playSystemSound(.success)
    }
    
    func playTimerComplete() {
        playSystemSound(.timerEnd)
    }
    
    func playButtonTap() {
        playSystemSound(.buttonTap)
    }
    
    private func playSystemSound(_ sound: SystemSound) {
        switch sound {
        case .success:
            // Play a subtle success sound
            AudioServicesPlaySystemSound(1057) // System sound for success
        case .timerEnd:
            // Play timer completion sound
            AudioServicesPlaySystemSound(1005) // System sound for timer
        case .buttonTap:
            // Play button tap sound
            AudioServicesPlaySystemSound(1104) // System sound for button tap
        }
    }
    
    private enum SystemSound {
        case success
        case timerEnd
        case buttonTap
    }
}