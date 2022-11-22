//
//  SwiftUIView.swift
//  mac-tv
//
//  Created by Marcel Braith on 20.02.21.
//

import SwiftUI
import AVKit

struct VideoDetails<BookletType: BookletProtocol>: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var booklet: BookletType
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let image = booklet.cover {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
    
            HStack(alignment: .top, spacing: 0) {
                VStack {
                    NavigationLink(destination: videoPlayer, label: {
                        Label("Wiedergeben", systemImage: "play.fill")
                    })
                    Button {
                        print("bookmarked")
                    } label: {
                        Label("Merken", systemImage: "bookmark")
                        Spacer()
                    }
                    
                }
                .padding()
                .fixedSize(horizontal: true, vertical: true)
                .layoutPriority(20)

                
                VStack(alignment: .leading) {
                    Text(booklet.description)
                        .foregroundColor(.primary)
                    HStack {
                        Text("Category")
                            .fontWeight(.semibold)
                        Text(booklet.publishedDate)
                            .fontWeight(.semibold)
                        Text(booklet.duration)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical)
                    .foregroundColor(.secondary)
                }
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 80.0)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
//            .background(Blur().mask(gradientMask))
            .background(Material.thin)
            .mask(gradientMask)
        }.ignoresSafeArea(.all)
        
    }
    
    var gradientMask: some View {
        LinearGradient(gradient: Gradient(stops: [.init(color: .black, location: 0.80),
                                                  .init(color: .clear, location: 1.0)]),
                       startPoint: .bottom,
                       endPoint: .top)
    }
    
    fileprivate var videoPlayer: some View {
        PlayerView(videoURL: booklet.videoURL,
                   onTimeChange: booklet.updatePlayingPosition)
            .onAppear {
                Projector.shared.play(from: booklet.playingPosition)
            }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let booklet = DesignTimeBooklet(//cover: <#T##UIImage?#>,
                                        title: "Coffee Run",
                                        description: "Coffee Run was directed by Hjalti Hjalmarsson and produced by the team at Blender Animation Studio. Fueled by caffeine, a young woman runs through the bittersweet memories of her past relationship."
                                        //publishedDate: <#T##String#>,
                                        //duration: <#T##String#>,
                                        //progress: <#T##Double?#>,
                                        //wasWatched: <#T##Bool#>,
                                        //player: <#T##AVPlayer#>
        )
		VideoDetails(booklet: booklet)
    }
}
