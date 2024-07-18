/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The representable as AVPlayerViewController.
 */

import SwiftUI
import AVKit

struct VideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
