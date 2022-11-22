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
    
    let columnCount: ColumnCount
    
    @State private var quickActionsShowing = false
    @State private var quickActionBooklet: BookletType?
    
    init(headline: String, videos: [BookletType], columnCount: ColumnCount = .fourColumn) {
        self.headline = headline
        self.videos = videos
        self.columnCount = columnCount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(headline)
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 40) {
                    ForEach(videos) { (booklet: BookletType) in
                        VStack {
                            VideoCardView(booklet: booklet,
                                          destination: VideoDetails(booklet: booklet))
                                .frame(width: columnCount.rawValue)
                                .onLongPressGesture {
                                    quickActionBooklet = booklet
                                    quickActionsShowing = true
                                }
                        }
                    }
                }
                .padding(.vertical, 20.0)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .confirmationDialog("",
                            isPresented: $quickActionsShowing,
                            presenting: quickActionBooklet) { booklet in
            Button("Als ungespielt markieren", action: booklet.markAsUnwatched)
            Button("Als gespielt markieren", action: booklet.markAsWatched)
            Button("Cancel", role: .cancel) {
                quickActionsShowing = false
            }
        } message: { booklet in
            Text(booklet.title)
        }
    }
    
    enum ColumnCount: CGFloat {
        case twoColumn = 860
        case threeColumn = 560
        case fourColumn = 410
        case fiveColumn = 320
        case sixColumn = 260
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
				.previewDisplayName("Default")
            VideosStrip(headline: "Blender Cloud Videos", videos: videos, columnCount: .twoColumn)
				.previewDisplayName("Two Column")
            VideosStrip(headline: "Blender Cloud Videos", videos: videos, columnCount: .threeColumn)
				.previewDisplayName("Three Column")
            VideosStrip(headline: "Blender Cloud Videos", videos: videos, columnCount: .fiveColumn)
				.previewDisplayName("Four Column")
            VideosStrip(headline: "Blender Cloud Videos", videos: videos, columnCount: .sixColumn)
				.previewDisplayName("Five Column")
        }
    }
}
