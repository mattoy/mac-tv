//
//  ContentView.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.02.21.
//

import SwiftUI
import AVKit

// MARK: LIVE https://tagesschau-lh.akamaihd.net/i/tagesschau_1@119231/master.m3u8

struct RibbonView: View {
    @ObservedObject var videoLibrary: VideoLibrary
    
    @State private var showingActionSheet = false
    
    init(videoLibrary: VideoLibrary) {
        self.videoLibrary = videoLibrary
        print("init RibbonView")
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 100) {
//                VideoCardView(destination: PlayerView(video: URL(string: "https://tagesschau-lh.akamaihd.net/i/tagesschau_1@119231/master.m3u8")!),
//                              image: UIImage(named: "Live Preview")!,
//                              title: "Livestream")
                
                if videoLibrary.videosInProgress.count > 0 {
                    VideosStrip(headline: "Weiterschauen",
                                videos: videoLibrary.videosInProgress)
                }
                
                VideosStrip(headline: "Kostenlose Filme",
                            videos: videoLibrary.booklets)
                    
            }
        }
    }
}

struct RibbonView_Previews: PreviewProvider {
    static var previews: some View {
        RibbonView(videoLibrary: VideoLibrary())
    }
}

