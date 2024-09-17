//
//  AudioPlayer.swift
//  Workspace 2
//
//  Created by Sam Davies on 11/09/2024.
//

import SwiftUI
import AVKit

struct AudioPlayer: UIViewControllerRepresentable {
    
    private var player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.exitsFullScreenWhenPlaybackEnds = true
        controller.allowsPictureInPicturePlayback = true
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
