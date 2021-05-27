//
//  PlayerTimeObserver.swift
//  mac-tv
//
//  Created by Marcel Braith on 08.04.21.
//

import Combine
import AVFoundation

class PlayerObserver: NSObject {
    let playerTimePublisher = PassthroughSubject<TimeInterval, Never>()
    var playerStatusPublisher: KeyValueObservingPublisher<AVPlayer, AVPlayer.Status> {
        get {
            KeyValueObservingPublisher(object: player, keyPath: \.status, options: [.new, .initial])
        }
    }
    private var timeObservation: Any?
    private let player: AVPlayer

    init(player: AVPlayer) {
        self.player = player
        super.init()
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.playerTimePublisher.send(time.seconds)
        }
        
        print("init Observer")
    }
}
