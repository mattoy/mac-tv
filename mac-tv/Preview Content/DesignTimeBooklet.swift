//
//  DesignTimeBooklet.swift
//  mac-tv
//
//  Created by Marcel Braith on 26.05.21.
//

import Foundation
import SwiftUI
import AVKit

class DesignTimeBooklet: BookletProtocol {
    
    internal init(cover: UIImage? = UIImage(named: "Dummy Preview"), title: String = "Coffee Run", description: String = "", publishedDate: String = "21.05.2021", duration: String = "45min", progress: Double? = nil, wasWatched: Bool = false, player: AVPlayer = AVPlayer()) {
        self.cover = cover
        self.title = title
        self.description = description
        self.publishedDate = publishedDate
        self.duration = duration
        self.progress = progress
        self.wasWatched = wasWatched
        self.player = player
        self.videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Coffee Run", ofType:"mp4")!)
    }
    
    var id = UUID()
    
    var cover: UIImage?
    var title: String
    var description: String
    var publishedDate: String
    var duration: String
    var videoURL: URL
    
    var progress: Double?
    var wasWatched: Bool
    
    var playingPosition: TimeInterval = 0
    
    var player: AVPlayer
    
    func loadImage() async -> UIImage { UIImage(named: "Dummy Preview")! }
    
    func updatePlayingPosition(to time: TimeInterval) {    }
    
    func markAsWatched() {
        
    }
    
    func markAsUnwatched() {
        
    }
}
