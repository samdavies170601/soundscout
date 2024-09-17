//
//  FeedView.swift
//  soundscout
//
//  Created by Sam Davies on 13/09/2024.
//

import AVKit
import MusicKit
import SwiftUI

struct FeedView: View {
    
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.content, id: \.0.id) { song, url in
                    FeedCell(song: song, url: url, player: viewModel.player)
                        .environmentObject(viewModel)
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(song.id.rawValue)
                        .onAppear {
                            viewModel.initiatePlayback()
                            Task {
                                await viewModel.getCurrentSongDuration()
                            }
                        }
                }
            }
            .scrollTargetLayout()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .scrollPosition(id: $viewModel.currentSongID)
        .scrollTargetBehavior(.paging)
        
        .onAppear {
            Task {
                await viewModel.getFeedContent()
            }
            viewModel.play()
            loopAudio()
        }
        .onChange(of: viewModel.currentSongID) { _, newValue in
            viewModel.play(using: newValue)
        }
        .overlay(alignment: .top) {
            FeedHeader()
                .ignoresSafeArea()
        }
        .background {
            AppColor.background
                .ignoresSafeArea()
        }
    }
    
    /// Loops the audio of the feed's `AVPlayer`.
    private func loopAudio() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            viewModel.player.seek(to: CMTime.zero)
            viewModel.player.play()
        }
    }
    
}

