/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The video store.
 */

import Foundation
import AVKit
import Combine

@Observable
final class VideoStore {
    private let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    var currentTime: Double = 0.0
    var totalDuration: Double = 0.1
    var bufferedValue: Double = 0.0
    
    var isPlaying = false
    var isSeeking = false
    var isFinishedPlaying = false
    
    var totalDurationText: String {
        return totalDuration.toTimecodeString()
    }
    
    var currentTimeText: String {
        return currentTime.toTimecodeString()
    }
    
    init() {
        setupVideoPlayer()
    }
    
    private func setupVideoPlayer() {
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        bindObservers()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private func bindObservers() {
        // Observing the ready-to-play status to update the total duration.
        playerItem?.publisher(for: \.status)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.totalDuration = self?.playerItem?.duration.seconds ?? 0.0
                }
            }
            .store(in: &cancellables)
        
        // Ovserving the loaded time ranges to update the buffered value.
        playerItem?.publisher(for: \.loadedTimeRanges)
            .sink { [weak self] timeRanges in
                guard let self = self, let timeRange = timeRanges.first?.timeRangeValue else { return }
                self.bufferedValue = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
            }
            .store(in: &cancellables)
        
        // Observing the periodic time to update the current value.
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            let current = self.player?.currentTime().seconds ?? 0.0
            if !isSeeking {
                // Changes the current time only when not in the seeking state.
                self.currentTime = current
            }
            
            if !isFinishedPlaying {
                guard let currentTime = playerItem?.currentTime().seconds,
                      let totalDuration = playerItem?.duration.seconds else { return }
                // Updates the isFinishedPlaying flag when the playback progress reaches completion.
                if currentTime / totalDuration == 1 {
                    isFinishedPlaying = true
                    isPlaying = false
                }
            }
        }
    }
    
    func togglePlayVideo() {
        if isFinishedPlaying {
            isFinishedPlaying = false
            player?.seek(to: .zero)
        }
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func seek(to duration: Double) {
        player?.seek(to: CMTime(seconds: duration, preferredTimescale: 1))
    }
    
    func resetVideo() {
        player?.pause()
        player?.seek(to: .zero)
        isPlaying = false
        isFinishedPlaying = false
    }
}
