//
//  PlayerView.swift
//  mac-tv
//
//  Created by Marcel Braith on 15.04.21.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    var projector = Projector.shared
    let videoURL: URL
    let onTimeChange: (TimeInterval) -> ()
        
    internal init(videoURL: URL, onTimeChange: @escaping (TimeInterval) -> ()) {
        self.onTimeChange = onTimeChange
        self.videoURL = videoURL
    }
        
    var body: some View {
        //VideoPlayer(player: projector.player)
        VideoPlayerController(player: projector.player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                projector.insert(videoURL: videoURL)
                projector.onTimeChange = self.onTimeChange
            }
            .onDisappear {
                projector.pause()
                projector.sendPlayerTime()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static func videoURL() -> URL {
        URL(fileURLWithPath: Bundle.main.path(forResource: "Coffee Run", ofType:"mp4")!)
    }
    
    static var previews: some View {
        return PlayerView(videoURL: Self.videoURL(), onTimeChange: { print("time changed to \($0)") })
    }
}
