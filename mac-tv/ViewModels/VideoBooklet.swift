//
//  VideoBooklet.swift
//  mac-tv
//
//  Created by Marcel Braith on 20.02.21.
//

import Foundation
import AVKit
import Combine

class VideoBooklet: ObservableObject, BookletProtocol {
    private let video: Video
    
    let delegate: LibraryDelegate
    var subscriptions = Set<AnyCancellable>()
    
    init(video: Video, delegate: LibraryDelegate) {
        self.video = video
        self.delegate = delegate
        print("Booklet init \(video.id)")
    }
    
    @Published var cover: UIImage?
    
    func loadImage() async -> UIImage {
        print("load image \(video.id)")
        let request = URLRequest(url: video.imageURL, cachePolicy: .returnCacheDataElseLoad)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return UIImage(data: data) ?? UIImage(systemName: "exclamationmark.icloud.fill")!
        } catch {
            return UIImage(systemName: "exclamationmark.icloud.fill")!
        }
    }
    
//    private func save(playingPosition: TimeInterval) {
//        let store = UserDefaults.standard
//
//        if store.dictionary(forKey: "playingPositions") as? [String: Double] == nil {
//            store.setValue([String: Double](), forKey: "playingPositions")
//        }
//
//        if var playingPositions = store.dictionary(forKey: "playingPositions") as? [String: Double] {
//            let key = self.video.id.description
//            playingPositions[key] = playingPosition
//            store.setValue(playingPositions, forKey: "playingPositions")
//        }
//    }
}

// MARK: - Identifiable

extension VideoBooklet: Identifiable {
    var id: Int { video.id }
}

// MARK: - Getters

extension VideoBooklet {
    var title: String {
        video.title
    }
    
    var description: String {
        video.description
    }
    
    var publishedDate: String {
        video.published.formatted(date: .long, time: .omitted)
    }
    
    var duration: String {        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "de_DE")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [ .hour, .minute ]
        return formatter.string(from: video.duration)!
    }
    
    var progress: Double? {
        switch video.progress {
            case .inProgress(let percent):
                return percent
            default:
                return nil
        }
    }
 
    var wasWatched: Bool {
        if case .watched = video.progress { return true } else { return false }
    }
    
    var videoURL: URL {
        video.url
    }
    
    var playingPosition: TimeInterval {
        video.playingPosition
    }
}

// MARK: - Intents
extension VideoBooklet {
    func markAsWatched() {
        var newVideo = self.video
        newVideo.playingPosition = video.duration
        delegate.replace(self.video, with: newVideo)
    }
    
    func markAsUnwatched() {
        var newVideo = self.video
        newVideo.playingPosition = 0
        delegate.replace(self.video, with: newVideo)
    }
    
    func updatePlayingPosition(to time: TimeInterval) {
        var newVideo = self.video
        newVideo.playingPosition = time
        delegate.replace(self.video, with: newVideo)
    }
}

protocol LibraryDelegate {
    func replace(_ video: Video, with newVideo: Video)
}
