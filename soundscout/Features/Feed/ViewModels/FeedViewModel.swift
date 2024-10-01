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
    
    /// Store tuples consisting of `Track` and the `URL` of a `PreviewAsset` of the track's audio.
    @Published var content = [(Track, URL)]()
    
    @Published var fetchNextPlaylist = false
    
    /// Collection of `MRecommendationItem`.
    private var defaultRecommendations: MRecommendations?
    
    /// Single recommendation item.
    private var defaultRecommendationItem: MRecommendationItem?
    
    private var currentPlaylistID: String?
    
    /// Load the `defaultRecommendations` collection.
    ///
    ///
    /// This function fetches a collection of default recommendation items and sets `defaultRecommendationItem` to the first item of this collection.
    private func loadDefaultRecommendations() async {
        do {
            defaultRecommendations = try await MRecommendation.default(limit: 1)
            getInitialDefaultRecommendationItem()
        } catch {
            print(error)
        }
    }
    
    /// Set the `defaultRecommendationItem` to the first item in the `defaultRecommendations` collection.
    private func getInitialDefaultRecommendationItem() {
        defaultRecommendationItem = defaultRecommendations?.first
    }
    
    /// Get the next batch of recommendation items.
    private func nextDefaultRecommendationItem() async {
        do {
            defaultRecommendations = try await defaultRecommendations?.nextBatch(limit: 1)
        } catch {
            print(error)
        }
    }
    
    ///
//    private func nextPlaylist() {
//        let currentPlaylistIndex =
//    }
    
    /// Get recommended songs from the `currentRecommendation` item.
    ///
    ///
    /// This method returns a collection of `Tracks` from the track list of each `Playlist` in the current recommendation item in the `defaultRecommendations` collection.
    private func getRecommendations() async -> Tracks {
        var recommendations = Tracks()
        guard let defaultRecommendationItem = defaultRecommendationItem else { return recommendations }
        
        for playlist in defaultRecommendationItem.playlists {
            if let tracks = await getTrackListing(from: playlist) {
                recommendations += tracks
            }
        }
        return recommendations
    }
    
    /// Get the collection of tracks from a playlist.
    /// - Parameter playlist: The playlist to get the tracks from.
    /// - Returns: The collection of tracks.
    private func getTrackListing(from playlist: Playlist) async -> Tracks? {
        let detailedPlaylist = try? await playlist.with(.tracks)
        if let tracks = detailedPlaylist?.tracks {
            return tracks
        }
        return nil
    }
    
//    /// Get the `URL` for the `MusicVideo` preview, if it exists.
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
    
    /// Get the `URL` for preview asset relating to the track.
    /// - Parameter track: The track to get the preview asset for.
    /// - Returns: Returns either the `URL` for the preview asset or `nil`.
    private func getPreviewURL(from track: Track) -> URL? {
        guard let previewURL = track.previewAssets?.first?.url else { return nil }
        
        // `Track` can either represent a `Song` (the URL for a song ends in ".m4a") or `MusicVideo` (the URL for a song ends in ".m4v")
        let urlString = previewURL.absoluteString
        if urlString.last == "a" {
            return previewURL
        } else {
            return nil
        }
    }
    
    /// Get the content for the feed.
    ///
    ///
    /// This is used to make the initial call to populate the `content` collection.
    @MainActor func getContent() async {
        await loadDefaultRecommendations()
        let recommendations = await getRecommendations()
        for track in recommendations {
            if let previewURL = getPreviewURL(from: track) {
                content.append((track, previewURL))
            }
        }
        //logger.info("\(self.content)")
    }
    
    @MainActor func moreContent() async {
        guard let defaultRecommendationItem = defaultRecommendationItem else { return }
        
        
    }
    
    // MARK: - Controlling Playback
    
    /// The current song that the user is on.
    @Published var currentSongID: String?
    
    @Published var currentSongDuration = 3000.0
    
    @Published var isPaused = false
    
    /// The single `AVPayer` for the feed.
    let player = AVPlayer()
    
    /// Use to begin playback for the initial song in the feed.
    func initiatePlayback() {
        guard currentSongID == nil,
              let firstSong = content.first,
              player.currentItem == nil else { return }
        
        let playerItem = AVPlayerItem(url: firstSong.1)
        player.replaceCurrentItem(with: playerItem)
    }
    
    /// Use to toggle the state of playback.
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
    
    /// Use to initiate playback of the current song.
    /// - Parameter id: The identifier of the current song.
    ///
    /// The function gets the tuple `(Song, URL)` for the current song, empties `player`, then initiates playback using the `URL` of the current song.
    func play(using id: String?) {
        guard let currentSong = content.first(where: { $0.0.id.rawValue == id }) else { return }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: currentSong.1)
        player.replaceCurrentItem(with: playerItem)
    }
    
    /// Call `play()` on the player.
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error)
        }
        player.play()
    }
    
    /// Call `pause()` on the player.
    func pause() {
        player.pause()
    }
    
    /// Get the duration of the current song.
    @MainActor func getCurrentSongDuration() async {
        let duration = try? await player.currentItem?.asset.load(.duration)
        if let duration = duration {
            currentSongDuration = duration.seconds * 100
        } else {
            currentSongDuration = 3000.0
        }
        logger.info("\(self.currentSongDuration)")
    }
    
    /// Get the details for a passed song.
    /// - Parameter song: The song to get details for.
    /// - Returns: The song details.
    func getSongDetails(for song: Track) -> String {
        if let albumTitle = song.albumTitle {
            return "\(song.artistName) · \(albumTitle)"
        } else {
            return song.artistName
        }
    }
    
    // MARK: - Managing Feed State
    
    /// UserDefaults key to store the last viewed track.
    private let key = "lastViewedTrackID"
    
    /// Get more content for the feed.
    ///
    ///
    /// This is called in the `.onChange()` modifier relating to the change in scroll position. When the user has reached the third-last song in the feed, generate more content.
    func trackFeedProgress() {
        let contentSize = content.count
        let currentTrackIndex = content.firstIndex { $0.0.id.rawValue == currentSongID }
        if currentTrackIndex == (contentSize - 2) {
            //moreContent()
        }
    }
    
    /// Save the last viewed track to UserDefaults.
    func saveFeedProgress() {
        // TODO: This is not a great looking line of code.
        let lastViewedTrackID = content.first { $0.0.id.rawValue == currentSongID }?.0.id.rawValue
        UserDefaults.standard.set(lastViewedTrackID, forKey: key)
        
        logger.info("Progress saved at \(lastViewedTrackID ?? "nil")")
    }
    
    /// Resume progress from the last viewed track.
    ///
    ///
    /// This function fetches `lastViewedTrackID` stored in UserDefaults, removes all the tracks in `content` before and including this last track.
    func resumeFeedProgress() {
        let lastViewedTrackID = UserDefaults.standard.string(forKey: key)
        logger.info("Fetched track \(lastViewedTrackID ?? "nil") from UserDefaults")
        let lastViewedTrackIndex = content.firstIndex { $0.0.id.rawValue == lastViewedTrackID }
        guard let lastViewedTrackIndex = lastViewedTrackIndex else { return }
        
        content.removeSubrange(0...lastViewedTrackIndex)
    }
    
}
