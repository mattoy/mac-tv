//
//  ContentView.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.02.21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject var videoLibrary = VideoLibrary()
    
    var body: some View {
        RibbonView(videoLibrary: videoLibrary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
