//
//  FeedViewModel.swift
//  soundscout
//
//  Created by Sam Davies on 13/09/2024.
//

import AVKit
import Foundation
import MusadoraKit
import MusicKit
import OSLog
import SwiftUI

fileprivate let logger = Logger(subsystem: "com.SamDavies.soundscout", category: "FeedViewModel")

final class FeedViewModel: ObservableObject {
    
    // MARK: - Generating Feed Content
    
    /// Stores tuples consisting of `Song` and the `URL` of a `PreviewAsset` of either the songs `MusicVideo` or audio.
    @Published var content = [(Song, URL)]()
    
//    func getDefaultRecommendations() async -> Playlist? {
//        do {
//            let recommendations = try await MRecommendation.default(limit: 1)
//            guard let playlist = recommendations.first?.playlists.first else { return nil }
//        
//            return await getDetailedPlaylist(for: playlist)
//        } catch {
//            print(error)
//        }
//        return nil
//    }
    
//    private func getDetailedPlaylist(for playlist: Playlist) async -> Playlist {
//        do {
//            let detailedPlaylist = try await playlist.with(.entries)
//        } catch {
//            print(error)
//        }
//    }
    
    private func getSuggestedSongs() async -> MusicItemCollection<Song> {
        do {
            let request = MusicCatalogSearchRequest(term: "Snoop Dogg", types: [Song.self])
            let response = try await request.response()
            
            return response.songs
        } catch {
            print(error)
            fatalError("Could not generate suggested content for the feed.")
        }
    }
    
//    /// Gets the `URL` for the `MusicVideo` preview, if it exists.
//    /// - Parameter song: The `Song` to get the `URL` for.
//    /// - Returns: Returns either the `URL` for the `PreviewAsset` or `nil`.
//    private func getPreviewMusicVideoURL(from song: Song) async -> URL? {
//        do {
//            let detailedSong = try await song.with(.musicVideos)
//            guard let previewMusicVideoURL = detailedSong.musicVideos?.first?.previewAssets?.first?.url else { return nil }
//            return previewMusicVideoURL
//        } catch {
//            print(error)
//            return nil
//        }
//    }
    
    /// Gets the `URL` for the audio preview, if it exists.
    /// - Parameter song: The `Song` to get the `URL` for.
    /// - Returns: Returns either the `URL` for the `PreviewAsset` or `nil`.
    private func getPreviewAudioURL(from song: Song) -> URL? {
        guard let previewAudioURL = song.previewAssets?.first?.url else { return nil }
        return previewAudioURL
    }
    
    /// Gets the content for the feed.
    @MainActor func getFeedContent() async {
        let suggestedSongs = await getSuggestedSongs()
        for song in suggestedSongs {
            if let previewAudioURL = getPreviewAudioURL(from: song) {
                content.append((song, previewAudioURL))
            }
        }
        logger.info("\(self.content)")
    }
    
//    @MainActor func getContent() async {
//        let playlist = await getDefaultRecommendations()
//        guard let playlist = playlist else { return }
//        
//        for entry in playlist.entries ?? [] {
//            let song = entry.item as?
//            
//            
//            if let song = entry.item as Song {
//                let song = item as? Song
//                if let song = song {
//                    
//                }
//            }
//            
//            
//            let song = entry.item as? Song?
//            if let previewAudioURL = getPreviewAudioURL(from: song) {
//                content.append(entry, )
//            }
//        }
//    }
    
    // MARK: - Playback Control
    
    /// The current song that the user is on.
    @Published var currentSongID: String?
    
    @Published var currentSongDuration = 3000.0
    
    @Published var isPaused = false
    
    /// The single `AVPayer` for the feed.
    let player = AVPlayer()
    
    /// Used to begin playback for the initial song in the feed.
    func initiatePlayback() {
        guard currentSongID == nil,
              let firstSong = content.first,
              player.currentItem == nil else { return }
        
        let playerItem = AVPlayerItem(url: firstSong.1)
        player.replaceCurrentItem(with: playerItem)
    }
    
    /// Used to toggle the state of playback.
    func togglePlayback() {
        switch player.timeControlStatus {
            case .paused:
                play()
                isPaused = false
            case .waitingToPlayAtSpecifiedRate:
                break
            case .playing:
                pause()
                isPaused = true
            @unknown default:
                break
        }
    }
    
    /// Used to initiate playback of the current song.
    /// - Parameter id: The identifier of the current song.
    ///
    /// The function gets the tuple `(Song, URL)` for the current song, empties `player`, then initiates playback using the `URL` of the current song.
    func play(using id: String?) {
        guard let currentSong = content.first(where: { $0.0.id.rawValue == id }) else { return }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: currentSong.1)
        player.replaceCurrentItem(with: playerItem)
    }
    
    /// Calls `play()` on the player.
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error)
        }
        player.play()
    }
    
    /// Calls `pause()` on the player.
    func pause() {
        player.pause()
    }
    
    /// Gets the duration of the current song.
    @MainActor func getCurrentSongDuration() async {
        let duration = try? await player.currentItem?.asset.load(.duration)
        if let duration = duration {
            currentSongDuration = duration.seconds * 100
        } else {
            currentSongDuration = 3000.0
        }
        logger.info("\(self.currentSongDuration)")
    }
    
    /// Gets the details for a passed song.
    /// - Parameter song: The song to get details for.
    /// - Returns: The song details.
    func getSongDetails(for song: Song) -> String {
        if let albumTitle = song.albumTitle {
            return "\(song.artistName) · \(albumTitle)"
        } else {
            return song.artistName
        }
    }
    
}
