//
//  BookletProtocol.swift
//  mac-tv
//
//  Created by Marcel Braith on 26.05.21.
//

import SwiftUI
import AVKit

protocol BookletProtocol: ObservableObject, Identifiable {  
    var cover: UIImage? { get }
    var title: String { get }
    var description: String { get }
    var publishedDate: String { get }
    var duration: String { get }
    
    var progress: Double? { get }
    var wasWatched: Bool { get }
    
    var player: AVPlayer { get }
    
    func loadImage()
}
