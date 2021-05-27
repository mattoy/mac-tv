//
//  PlayerView.swift
//  mac-tv
//
//  Created by Marcel Braith on 15.04.21.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @State var player: AVPlayer = AVPlayer()
    var video: URL
    
    var body: some View {
        VideoPlayer(player: player /*, videoOverlay: overlay*/)
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                player = AVPlayer(url: video)
                player.play()
            }
            .onDisappear() {
                player.pause()
            }
    }
    
    func overlay() -> OverlayView {
        OverlayView()
    }
}

struct OverlayView: View {
    var body: some View {
        HStack {
            Button("Vote A") {}
                .buttonStyle(CardButtonStyle())
            Button("Vote B") {}
            Button("Vote C") {}
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static func videoURL() -> URL {
        URL(fileURLWithPath: Bundle.main.path(forResource: "Coffee Run", ofType:"mp4")!)
    }
    
    static var previews: some View {
        return PlayerView(video: Self.videoURL())
    }
}
