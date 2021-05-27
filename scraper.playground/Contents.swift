import SwiftSoup
import Foundation
import PlaygroundSupport

import SwiftUI

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}

struct DummyVideo: Codable {
    let id: Int
    let title: String
    let category: String
}


let url = Bundle.main.url(forResource: "mactv", withExtension: "html")! // URL(string: "https://www.mac-tv.de/Filmarchiv.html#")!

let content = try String(contentsOf: url)
let doc = try SwiftSoup.parse(content)

let element = doc.body()

let filmarchiv = try element?.getElementById("Filmarchiv")

let categories = try filmarchiv?.getElementsByClass("FilmseiteRubrikContainer")

let categorieNames = categories?.compactMap { rubrik in
    try? rubrik.attr("id")
}

let dummies: [DummyVideo] = categories!.compactMap { categoryElement -> [DummyVideo]? in
    guard let categoryName = try? categoryElement.attr("id") else { return nil }
    guard let linkElements = try? categoryElement.getElementsByTag("a") else { return nil }
    guard let id = try? Int(linkElements.attr("href").match("JumpID=([0-9]+)").first![1]) else { return nil }

    let videos = linkElements.compactMap { linkElement -> DummyVideo? in
        guard let title = try? linkElement.text() else { return nil }
        return DummyVideo(id: id, title: title, category: categoryName)
    }

    return videos
}.flatMap { $0 }


let json = try JSONEncoder().encode(dummies)
let jsonString = String(data: json, encoding: String.Encoding.utf8)

let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("export.json")
try jsonString!.write(to: file, atomically: false, encoding: .utf8)

let tablerow = try filmarchiv?.select("tr").first()!
let gratistable = tablerow?.child(1)

let idElements = try gratistable?.getElementsByClass("Filmliste_klein")
let ids: [String] = try idElements!.array().map { element in
    let onclick = try element.attr("onclick")
    let id = onclick.match(",([0-9]+),").first![1]
    return id
}
