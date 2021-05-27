//
//  VideoManager.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.02.21.
//
import AVKit
import Combine

class VideoLibrary: ObservableObject {
    @Published var booklets: [VideoBooklet]
    
    var videosInProgress: [VideoBooklet] {
        booklets.filter {
            $0.progress != nil
        }
    }
        
    init() {
        self.booklets = VideoStore().freeVideos.map {
            VideoBooklet(video: $0)
        }
        print("init VideoLib")
    }
}
