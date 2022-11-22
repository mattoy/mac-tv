//
//  PlayerTimeObserver.swift
//  mac-tv
//
//  Created by Marcel Braith on 08.04.21.
//

import Combine
import AVFoundation

/// Observes the playback of a Player, and publishes time and status changes
class PlayerObserver: NSObject {
	/// Publisher that publishes the playback position every 5 seconds
    let playerTimePublisher = PassthroughSubject<TimeInterval, Never>()
	/// Publisher that fires once a Player is ready to play
    var playerStatusPublisher: KeyValueObservingPublisher<AVPlayer, AVPlayer.Status> {
        get {
            KeyValueObservingPublisher(object: player, keyPath: \.status, options: [.new, .initial])
        }
    }
	
    private var timeObservation: Any?
    private let player: AVPlayer

	/// Creates an Observer for a player
	/// - Parameters:
	/// 	- player: Player to observe
    init(player: AVPlayer) {
        self.player = player
        super.init()
        
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.playerTimePublisher.send(time.seconds)
        }
	}
}
