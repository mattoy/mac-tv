//
//  Projector.swift
//  mac-tv
//
//  Created by Marcel Braith on 11.04.21.
//

import AVKit

class Projector {
    static var shared = Projector()
    
    let player: AVPlayer
    let playerObserver: PlayerObserver
    
    var video: Video?
    
    init() {
        let globalPlayer = AVPlayer()
        self.player = globalPlayer
        self.playerObserver = PlayerObserver(player: globalPlayer)
    }
        
    func insert(video: Video) -> AVPlayer {
        self.video = video
        let itemToPlay = AVPlayerItem(url: URL(string: video.url)!)
        player.replaceCurrentItem(with: itemToPlay)
        return player
    }
}
    
    

