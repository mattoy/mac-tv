//
//  VideoBooklet.swift
//  mac-tv
//
//  Created by Marcel Braith on 20.02.21.
//

import Foundation
import AVKit
import Combine

class VideoBooklet: ObservableObject, Identifiable, BookletProtocol {
    var id: Int { video.id }
    
    private let video: Video
    
    init(video: Video) {
        self.video = video
    }
    
    private var _player: AVPlayer?
    
    var player: AVPlayer {
        if let player = _player {
            return player
        } else {
            self._player = Projector.shared.insert(video: self.video)
            subscribeToPlayerTime()
            subscribeToPlayerStatus()

            return _player!
        }
    }
    
    @Published var cover: UIImage?
    
    func loadImage() {
        print("Fetch Image")
        
        guard let url = URL(string: video.imageURL) else {
            print("Invalid Image URL")
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        URLSession.shared.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .replaceError(with: UIImage(systemName: "exclamationmark.icloud.fill"))
            .receive(on: RunLoop.main)
            .assign(to: \.cover, on: self)
            .store(in: &subscriptions)
    }
    
    func subscribeToPlayerTime() {
        print("subscribed to player time")
        Projector.shared.playerObserver.playerTimePublisher
            .sink(receiveValue: { playingPosition in
                print("Playing time updated \(playingPosition)")
                self.video.playingPosition = playingPosition
                self.save(playingPosition: playingPosition)
                
                self.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }
    
    private func save(playingPosition: TimeInterval) {
        let store = UserDefaults.standard
        
        if store.dictionary(forKey: "playingPositions") as? [String: Double] == nil {
            store.setValue([String: Double](), forKey: "playingPositions")
        }
        
        if var playingPositions = store.dictionary(forKey: "playingPositions") as? [String: Double] {
            let key = self.video.id.description
            playingPositions[key] = playingPosition
            store.setValue(playingPositions, forKey: "playingPositions")
        }
    }
    
    func subscribeToPlayerStatus() {
        print("subscribed to player status")
        Projector.shared.playerObserver.playerStatusPublisher
            .filter { status in
                status == .readyToPlay
            }
            .sink { status in
                print("status \(status.rawValue.description)")
                print("Seek to \(self.video.playingPosition)")
                self.player.seek(to: CMTime(seconds: self.video.playingPosition, preferredTimescale: 600) )
            }
            .store(in: &subscriptions)
    }
    
    var subscriptions = Set<AnyCancellable>()
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
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: video.published)
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
    
//    var playingProgress: Double {
//        video.playingProgress
//    }
//    
//    var isInProgress: Bool {
//        if case .inProgress(_) = video.progress { return true } else { return false }
//    }
//    
    var wasWatched: Bool {
        if case .watched = video.progress { return true } else { return false }
    }
}

// MARK: - Intents
extension VideoBooklet {
    func markAsWatched() {
        video.playingPosition = video.duration
    }
    
    func markAsUnwatched() {
        video.playingPosition = 0
    }
}
