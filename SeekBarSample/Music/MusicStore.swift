/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The music store.
 */

import Foundation
import AVKit

@Observable
final class MusicStore {
    private let fileName = "FindingHappiness"
    private let fileExtension = "mp3"
    
    private var player: AVAudioPlayer?
    var currentTime: TimeInterval = 0.0
    var totalDuration: TimeInterval = 0.0
    var isPlaying = false
    
    var totalDurationText: String {
        return totalDuration.toTimecodeString()
    }
    
    var currentTimeText: String {
        return currentTime.toTimecodeString()
    }
    
    init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: fileExtension
        ) else {
            fatalError("Failed to find audio file: \(fileName).\(fileExtension)")
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalDuration = player?.duration ?? 0.0
        } catch {
            fatalError("Failed to initialize AVAudioPlayer: \(error.localizedDescription)")
        }
    }
    
    func togglePlayMusic() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func seek(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    func updateProgress() -> Bool {
        guard let player = player else { return false }
        currentTime = player.currentTime
        let tolerance = 0.1
        if currentTime >= totalDuration - tolerance {
            player.currentTime = 0.0
            player.stop()
            return true
        }
        return false
    }
}
