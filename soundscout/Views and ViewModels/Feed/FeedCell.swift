//
//  FeedCell.swift
//  Workspace 2
//
//  Created by Sam Davies on 11/09/2024.
//

import AVKit
import MusicKit
import SwiftUI

struct FeedCell: View {
    
    @EnvironmentObject private var viewModel: FeedViewModel
    
    let song: Track
    let url: URL
    let player: AVPlayer
    
    var body: some View {
        ZStack {
            AudioPlayer(player: player)
            Rectangle()
                .ignoresSafeArea()
            if let artwork = song.artwork {
                AsyncImage(url: artwork.url(width: Int(UIScreen.main.bounds.height), height: Int(UIScreen.main.bounds.height)))
                    .ignoresSafeArea()
            }
            VStack {
                Spacer()
                CurrentSong(song: song)
                    .environmentObject(viewModel)
                    .padding(.bottom, 32)
            }
        }
        .onTapGesture {
            withAnimation {
                viewModel.togglePlayback()
            }
        }
        .overlay {
            playIcon
        }
    }
    
    @ViewBuilder private var playIcon: some View {
        if viewModel.isPaused {
            Image("play")
        }
    }
    
}
