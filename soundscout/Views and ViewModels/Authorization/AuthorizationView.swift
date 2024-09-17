//
//  AuthorizationView.swift
//  soundscout
//
//  Created by Sam Davies on 10/09/2024.
//

import MusicKit
import SwiftUI

struct AuthorizationView: View {
    
    @EnvironmentObject private var authorizer: Authorizer
    let soundscoutLogoURL = "soundscout-logo"
    
    var body: some View {
        ZStack {
            AppColor.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Image(soundscoutLogoURL)
                    .frame(height: 22)
                    .padding(.bottom, 16)
                if let text = text {
                    text
                        .font(.interRegular14)
                        .foregroundStyle(AppColor.white)
                        .frame(maxWidth: 318)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)
                        
                }
                button
            }
        }
        
    }
    
    @ViewBuilder private var button: some View {
        switch authorizer.currentStatus {
            case .notDetermined:
                AuthorizationButton(prompt: "Link Apple Music") {
                    Task {
                        let status = await authorizer.requestMusicKitAuthorization()
                        if status == .authorized {
                            authorizer.isAuthorized = true
                        }
                    }
                }
                .buttonStyle(PrimaryButton())
            case .denied:
                AuthorizationButton(prompt: "Open Settings") {
                    Task {
                        await authorizer.openSettings()
                    }
                }
                .buttonStyle(SecondaryButton())
            case .authorized, .restricted:
                EmptyView()
            @unknown default:
                EmptyView()
        }
    }
    
    private var text: Text? {
        switch authorizer.currentStatus {
            case .notDetermined:
                return Text("Welcome to soundscout! Please grant soundscout access to Apple Music. This is REQUIRED to use the app.")
            case .denied:
                return Text("soundscout REQUIRES access to Apple Music. Please grant soundscout access using the prompt.")
            case .restricted:
                return Text("soundscout is not supported on the current device.")
            case .authorized:
                return nil
            @unknown default:
                return nil
        }
    }
    
}

#Preview {
    AuthorizationView()
        .environmentObject(Authorizer())
}
