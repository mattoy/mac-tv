//
//  VideosStrip.swift
//  mac-tv
//
//  Created by Marcel Braith on 17.04.21.
//

import SwiftUI

struct VideosStrip<BookletType: BookletProtocol>: View {
    let headline: String
    let videos: [BookletType]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(headline)
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 40) {
                    ForEach(videos) { (booklet: BookletType) in
                        VStack {
                            VideoCardView(booklet: booklet,
                                          destination: VideoDetails(booklet: booklet))
                                .frame(width: 410)
                        }
                    }
                }
            }.padding(.vertical)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct VideosStrip_Previews: PreviewProvider {
    static var previews: some View {
        let videos = [DesignTimeBooklet(),
                      DesignTimeBooklet(),
                      DesignTimeBooklet(),
                      DesignTimeBooklet(),
                      DesignTimeBooklet()]
        Group {
            VideosStrip(headline: "Blender Cloud Videos", videos: videos)
            VideosStrip(headline: "Blender Cloud Videos", videos: videos)
                .preferredColorScheme(.light)
        }
    }
}
