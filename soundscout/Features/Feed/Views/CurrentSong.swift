//
//  CurrentSong.swift
//  soundscout
//
//  Created by Sam Davies on 06/08/2024.
//

import CoreHaptics
import MarqueeText
import MusicKit
import SwiftUI

struct CurrentSong: View {
    
    let song: Track
    @EnvironmentObject private var viewModel: FeedViewModel
    
    var body: some View {
        ZStack {
            background
            VStack {
                HStack(alignment:.top ,spacing: 16) {
                    artwork
                    VStack(alignment: .leading, spacing: 8) {
                        details
                    }
                    .frame(height: 88)
                }
            }
            .padding(24)
        }
        .frame(width: 366, height: 137)
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    @ViewBuilder private var background: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(AppColor.black)
            .blur(radius: 4)
        RoundedRectangle(cornerRadius: 20)
            .modifier(ClearBackground())
    }
    
    @ViewBuilder private var artwork: some View {
        if let artwork = song.artwork {
            AsyncImage(url: artwork.url(width: 88, height: 88))
        } else {
            DefaultImage(shape: .rectangle)
                .frame(width: 88, height: 88)
        }
    }

    @ViewBuilder private var details: some View {
        MarqueeText(text: song.title, font: Font.getUIFont(for: "Inter-Bold", ofSize: 18), leftFade: 4, rightFade: 4, startDelay: 3)
            .foregroundStyle(AppColor.white)
            .frame(height: 14)
        MarqueeText(text: viewModel.getSongDetails(for: song), font: Font.getUIFont(for: "Inter-Medium", ofSize: 14), leftFade: 4, rightFade: 4, startDelay: 3)
            .foregroundStyle(AppColor.gray)
            .frame(height: 12)
    }
}
