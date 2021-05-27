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
    
    fileprivate func extractedFunc() -> some View {
        return VideoPlayer(player: booklet.player)
            .edgesIgnoringSafeArea(.all)
            .onAppear() { booklet.player.play() }
            .onDisappear() { booklet.player.pause() }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let image = booklet.cover {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
                
            HStack(alignment: .top) {
                NavigationLink(destination:
                                extractedFunc()
                , label: {
                    Label("Wiedergeben", systemImage: "play.fill")
                })
                    .padding()
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
//                    .foregroundColor(Color.gray)
                    
                }.padding()
            }
            .padding(.top, 80.0)
            .frame(maxWidth: .infinity)
            .background(Blur().mask(gradientMask))
        }.ignoresSafeArea(.all)
        
    }
    
    var gradientMask: some View {
        LinearGradient(gradient: Gradient(stops: [.init(color: .black, location: 0.70),
                                                  .init(color: .clear, location: 1.0)]),
                       startPoint: .bottom,
                       endPoint: .top)
    }
}

struct Blur: UIViewRepresentable {
    // style: colorScheme == .dark ? .extraDark : .extraLight
    var style: UIBlurEffect.Style = .regular
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
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
        Group {
            VideoDetails(booklet: booklet)
            VideoDetails(booklet: booklet)
                .preferredColorScheme(.light)
        }
    }
}
