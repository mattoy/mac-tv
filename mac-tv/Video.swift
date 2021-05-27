//
//  Film.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.02.21.
//

import Foundation
import FeedKit
import SwiftUI

class Video: Identifiable, Codable {
    
    // MARK: - Properties
    
    var id: Int
    
    let title: String
    let description: String
    let url: String
    let duration: TimeInterval
    let published: Date
    let imageURL: String
    var playingPosition: TimeInterval = 0
    
    init(id: Int, title: String, description: String, url: String, duration: TimeInterval, published: Date, imageURL: String, playingPosition: TimeInterval = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.url = url
        self.duration = duration
        self.published = published
        self.imageURL = imageURL
        self.playingPosition = playingPosition
    }
}


/* MARK: - Video Progress */
extension Video {
    private static let thresholdStarted = 30.0 // When the user is 30s in the video it is considered started
    private static let thresholdFinished = 60.0  // When there are 60s or less remaining it is considered finished
    
    var playingProgress: Double {
        playingPosition / duration
    }
    
    var progress: VideoProgress {
        switch playingPosition {
            case 0 ..< Video.thresholdStarted:
                return .unwatched
            case Video.thresholdStarted ..< (duration - Video.thresholdFinished):
                return .inProgress(playingProgress)
            case (duration - Video.thresholdFinished) ... duration:
                return .watched
            default:
                return .watched
        }
    }
    
    enum VideoProgress {
        case watched
        case inProgress(Double)
        case unwatched
    }
}

extension Video: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(url)
        hasher.combine(duration)
        hasher.combine(published)
        hasher.combine(imageURL)
        hasher.combine(playingPosition)
    }
}

extension Video: Equatable {
    static func == (lhs: Video, rhs: Video) -> Bool {
        return (lhs.url == rhs.url &&
                lhs.title == rhs.title &&
                lhs.description == rhs.description &&
                lhs.duration == rhs.duration &&
                lhs.published == rhs.published &&
                lhs.imageURL == rhs.imageURL &&
                lhs.playingPosition == rhs.playingPosition)
        
    }
}
