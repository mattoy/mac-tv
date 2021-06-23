//
//  VideoCardView.swift
//  mac-tv
//
//  Created by Marcel Braith on 10.04.21.
//

import SwiftUI
import Foundation

struct VideoCardView<Destination, BookletType: BookletProtocol>: View where Destination: View {
    @ObservedObject var booklet: BookletType
    let destination: Destination
    
    @State private var showingActionSheet = false
    @FocusState private var isFocused: Bool
    
    @State private var image: UIImage?
    
    internal init(booklet: BookletType, destination: Destination) {
        self.booklet = booklet
        self.destination = destination
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                GeometryReader { geometry in
                    NavigationLink(destination: destination) {
                        ZStack(alignment: .bottom) {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(16/9, contentMode: .fill)
                            } else {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 100))
                                    .foregroundColor(.secondary)
                            }

                            if let progress = booklet.progress {
                                ProgressView(value: progress)
                                    .shadow(radius: 8)
                                    .padding()
                            }
                            if booklet.wasWatched {
                                HStack {
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.white)
                                        .shadow(radius: 8)
                                        .padding()
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .focused($isFocused)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            Text(booklet.title)
                .font(.body)
                .foregroundColor(Color.white)
                .lineLimit(1)
                .opacity(isFocused ? 1 : 0)
        }
        .buttonStyle(.card)
        .task {
            self.image = await booklet.loadImage()
        }
    }
}

struct VideoCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run"),
                          destination: EmptyView())

            VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run",
                                                     progress: 0.5),
                          destination: EmptyView())
            VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run",
                                                     wasWatched: true),
                          destination: EmptyView())
            Group {
                VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run"),
                              destination: EmptyView())
                VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run",
                                                         progress: 0.5),
                              destination: EmptyView())
                VideoCardView(booklet: DesignTimeBooklet(title: "Coffee Run Coffee Run Coffee Run Coffee Run",
                                                         wasWatched: true),
                              destination: EmptyView())
            }
            .preferredColorScheme(.light)
        }
        .padding(10)
        .previewLayout(.fixed(width: 410, height: 300))
    }
}
