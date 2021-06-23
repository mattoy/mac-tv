//
//  VideoPlayerController.swift
//  mac-tv
//
//  Created by Marcel Braith on 15.06.21.
//

import SwiftUI
import AVKit

struct VideoPlayerController: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Add Custom UI for voting buttons
//        let voteA = UIAction(title: "Vote A") { (action) in
//            print("Voted A")
//        }
//        let voteB = UIAction(title: "Vote B") { (action) in
//            print("Voted B")
//        }
//        
//        playerViewController.contextualActions = [voteA, voteB]
         
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
