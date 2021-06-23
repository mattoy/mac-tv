//
//  Projector.swift
//  mac-tv
//
//  Created by Marcel Braith on 11.04.21.
//

import AVKit
import Combine

class Projector: ObservableObject {
    static var shared = Projector()
    
    let player: AVPlayer
    let playerObserver: PlayerObserver
    
    var timeSubscription: AnyCancellable?
    
    var onTimeChange: (TimeInterval) -> () = { _ in }
    
    private init() {
        let globalPlayer = AVPlayer()
        self.player = globalPlayer
        self.playerObserver = PlayerObserver(player: globalPlayer)
    }
        
    func insert(videoURL: URL) {
        let itemToPlay = AVPlayerItem(url: videoURL)
        if player.currentItem != itemToPlay {
            player.replaceCurrentItem(with: itemToPlay)
        }
    }
    
    // MARK: TODO Seek after Obeserver sends status ready
    func play(from time: TimeInterval = 0) {
        player.play()
        player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
    }
    
    func pause() {
        player.pause()
    }
    
    func sendPlayerTime() {
        let currentTime = player.currentTime().seconds
        onTimeChange(currentTime)
    }
    
}
