//
//  VideoStore.swift
//  mac-tv
//
//  Created by Marcel Braith on 07.04.21.
//

import Foundation
import FeedKit
import Cache

struct VideoStore {
    let cache: Storage<String, [Video]>
    
    init() {
        let diskConfig = DiskConfig(name: "VideoCache")
        let memoryConfig = MemoryConfig(expiry: .seconds(3600), countLimit: 10, totalCostLimit: 10)
        
        self.cache = try! Storage<String, [Video]>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [Video].self)
        )
        
        print("init Store")
    }

    fileprivate func fetchVideos() -> [Video] {
        let feedURL = URL(string: "https://www.mac-tv.de/RSS_Podcast_HD.lasso")!
        let parser = FeedParser(URL: feedURL)
        let result = parser.parse()
        
        let rssFeed = try? result.get().rssFeed
        
        let items = rssFeed!.items!
        
        let videos = items.map { item -> Video in
            
            let insecureURL = URL(string: item.enclosure!.attributes!.url!)!
            let secureURL = self.secureURL(from: insecureURL).absoluteString
            
            let insecureImageURL = URL(string: item.iTunes!.iTunesImage!.attributes!.href!)!
            let secureImageURL = self.secureURL(from: insecureImageURL).absoluteString
            
            let id = extractID(item.link!)
            
            let video = Video(id: id,
                              title: item.title!,
                              description: item.description!,
                              url: secureURL,
                              duration: item.iTunes!.iTunesDuration!,
                              published: item.pubDate!,
                              imageURL: secureImageURL)
            
            video.playingPosition = playingPosition(for: video)
            
            return video
        }
        
        try! cache.setObject(videos, forKey: "videos", expiry: .seconds(3600))
        
        return videos
    }
    
    private func extractID(_ url: String) -> Int {
        Int(url.match("JumpID=([0-9]+)").first![1])!
    }
    
    var freeVideos: [Video] {
        get {
            let videosFromCache = try? cache.object(forKey: "videos")
            let videos = videosFromCache ?? fetchVideos()
            for video in videos {
                video.playingPosition = self.playingPosition(for: video)
            }
            return videos
        }
    }
    
    var videosInProgress: [Video] {
        freeVideos.filter {
            if case .inProgress = $0.progress { return true } else { return false }
        }
    }
    
    func secureURL(from url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.scheme = "https"
        let secureURL = components.url!
        return secureURL
    }
    
    func playingPosition(for video: Video) -> TimeInterval {
        let key = video.id.description
        var position: TimeInterval = 0
        
        let store = UserDefaults.standard
        if let playingPositions = store.dictionary(forKey: "playingPositions") as? [String: Double],
           let positionInVideo = playingPositions[key] {
            position = positionInVideo
        }
        
        return position
    }
}

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}
