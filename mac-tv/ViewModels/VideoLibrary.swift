//
//  VideoManager.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.02.21.
//
import AVKit
import Combine

class VideoLibrary: ObservableObject {
    @Published var videos: [Video]
    var booklets: [VideoBooklet] {
        videos.map {
            VideoBooklet(video: $0, delegate: self)
        }
    }
    
    var videosInProgress: [VideoBooklet] {
        videos.filter {
            switch $0.progress {
                case .inProgress(_):
                    return true
                default:
                    return false
            }
        }
        .map {
            VideoBooklet(video: $0, delegate: self)
        }
    }
        
    var videosSubscription: AnyCancellable?
    
    init() {
        self.videos = VideoStore().freeVideos
        
        self.videosSubscription = self.$videos
            .dropFirst()
            .sink {
                VideoStore().storedVideos = $0
            }
    }
}

extension VideoLibrary: LibraryDelegate {
    func replace(_ video: Video, with newVideo: Video) {
        if let index = videos.firstIndex(where: { $0.id == video.id }) {
            videos[index] = newVideo
        }
        print("New video #\(newVideo.id) '\(newVideo.title)': \(newVideo.playingPosition), progress: \(newVideo.progress)")
    }
}
