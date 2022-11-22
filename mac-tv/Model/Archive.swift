import SwiftSoup
import Foundation

struct Archive {
    struct DummyVideo: Codable {
        let id: Int
        let title: String
        let category: String
    }
    
    private var rawArchive: Element
    
    init?() {
        guard let rawArchive = try? URL(string: "https://www.mac-tv.de/Filmarchiv.html#")
            .map(String.init)
            .map(parse)?
            .body()?
            .getElementById("Filmarchiv")
        else { return nil }
        
        self.rawArchive = rawArchive
    }
    
    var categories: [String] {
        let names = try? rawCategories()?
            .compactMap {
                try $0.attr("id")
            }
        return names ?? []
    }
    
    private func rawCategories() -> Elements? {
        return try? rawArchive.getElementsByClass("FilmseiteRubrikContainer")
    }
    
    var videos: [DummyVideo] {
        let videos = rawCategories()?
            .flatMap { categoryElement -> [DummyVideo] in
                guard
                    let categoryName = try? categoryElement.attr("id"),
                    let linkElements = try? categoryElement.getElementsByTag("a")
                else { return [] }
                
                return linkElements.compactMap { linkElement in
                    guard
                        let title = try? linkElement.text(),
                        let href = try? linkElements.attr("href"),
                        let match = href.matchFirst("JumpID=([0-9]+)"),
                        let id = Int(match)
                    else { return nil }
                    
                    return DummyVideo(id: id, title: title, category: categoryName)
                }
            }
        return videos ?? []
    }
}
