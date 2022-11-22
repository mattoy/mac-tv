//
//  VideoStore.swift
//  mac-tv
//
//  Created by Marcel Braith on 07.04.21.
//

import Foundation
import FeedKit

class VideoStore {
    func fetchVideos() -> [Video] {
        let feedURL = URL(string: "https://www.mac-tv.de/RSS_Podcast_HD.lasso")!
        let parser = FeedParser(URL: feedURL)
        let result = parser.parse()
        let rssFeed = try? result.get().rssFeed
        let items = rssFeed!.items!
        
        let videos = items.map { item -> Video in
            let videoURL = secureURL(from: item.enclosure!.attributes!.url!)
            let imageURL = secureURL(from: item.iTunes!.iTunesImage!.attributes!.href!)
            
            let id = extractID(item.link!)
            
            let video = Video(id: id,
                              title: item.title!,
                              description: item.description!,
                              url: videoURL,
                              duration: item.iTunes!.iTunesDuration!,
                              published: item.pubDate!,
                              imageURL: imageURL)
            return video
        }
        
        return videos
    }
    
    private func extractID(_ url: String) -> Int {
        Int(url.match("JumpID=([0-9]+)").first![1])!
    }
    
    var freeVideos: [Video] {
        let fetchedVideos = fetchVideos()
        
        var mergedVideos = storedVideos
        fetchedVideos.forEach { fetchedVideo in
            if !mergedVideos.contains(where: { $0.id == fetchedVideo.id }) {
                mergedVideos.append(fetchedVideo)
            }
        }
		let sortedVideos = mergedVideos.sorted(by: { $0.published > $1.published }) // sort by newest first
        
        storedVideos = sortedVideos
        
        return mergedVideos
    }
    
    var storedVideos: [Video] {
        get {
            let store = UserDefaults.standard
            guard let arrayData = store.value(forKey: "freeVideos") as? Data else {
                return []
            }
            let videoArray = try! JSONDecoder().decode([Video].self, from: arrayData)
            return videoArray //?? []
        }
        set {
            let store = UserDefaults.standard
            /*if*/ let encoded = try! JSONEncoder().encode(newValue) //{
                store.set(encoded, forKey: "freeVideos")
            //}
        }
    }
    
    var videosInProgress: [Video] {
        freeVideos.filter {
            if case .inProgress = $0.progress { return true } else { return false }
        }
    }
    
    private func secureURL(from stringURL: String) -> URL {
        let insecureURL = URL(string: stringURL)!
        var components = URLComponents(url: insecureURL, resolvingAgainstBaseURL: false)!
        components.scheme = "https"
        let secureURL = components.url!
        return secureURL
    }
}

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
    
    public func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }
    
    func matchFirst(_ regex: String) -> String? {
        capturedGroups(withRegex: regex).first
    }
}
