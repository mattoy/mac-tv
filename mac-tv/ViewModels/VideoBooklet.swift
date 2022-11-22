//
//  VideoBooklet.swift
//  mac-tv
//
//  Created by Marcel Braith on 20.02.21.
//

import Foundation
import AVKit
import Combine

class VideoBooklet: ObservableObject, BookletProtocol {
    private let video: Video
    
    let delegate: LibraryDelegate
    var subscriptions = Set<AnyCancellable>()
    
    init(video: Video, delegate: LibraryDelegate) {
        self.video = video
        self.delegate = delegate
        print("Booklet init \(video.id)")
    }
    
    @Published var cover: UIImage?
    
    func loadImage() async -> UIImage {
        print("load image \(video.id)")
        let request = URLRequest(url: video.imageURL, cachePolicy: .returnCacheDataElseLoad)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request) // TODO check response for error code
			guard let httpResponse = response as? HTTPURLResponse else {
				throw MyError.runtimeError("none")
			}
			guard (200...299) ~= httpResponse.statusCode else {
				throw HTTPError(integerLiteral: httpResponse.statusCode)
			}
            return UIImage(data: data) ?? UIImage(systemName: "exclamationmark.icloud.fill")!
        } catch {
            return UIImage(systemName: "exclamationmark.icloud.fill")!
        }
    }
    
//    private func save(playingPosition: TimeInterval) {
//        let store = UserDefaults.standard
//
//        if store.dictionary(forKey: "playingPositions") as? [String: Double] == nil {
//            store.setValue([String: Double](), forKey: "playingPositions")
//        }
//
//        if var playingPositions = store.dictionary(forKey: "playingPositions") as? [String: Double] {
//            let key = self.video.id.description
//            playingPositions[key] = playingPosition
//            store.setValue(playingPositions, forKey: "playingPositions")
//        }
//    }
}

// MARK: - Identifiable

extension VideoBooklet: Identifiable {
    var id: Int { video.id }
}

// MARK: - Getters

extension VideoBooklet {
    var title: String {
        video.title
    }
    
    var description: String {
        video.description
    }
    
    var publishedDate: String {
        video.published.formatted(date: .long, time: .omitted)
    }
    
	private var durationFormatter: DateComponentsFormatter {
		var calendar = Calendar.current
		calendar.locale = Locale(identifier: "de_DE")
		let formatter = DateComponentsFormatter()
		formatter.calendar = calendar
		formatter.unitsStyle = .brief
		formatter.allowedUnits = [ .hour, .minute ]
		return formatter
	}
	
    var duration: String {
		durationFormatter.string(from: video.duration)!
    }
    
    var progress: Double? {
        switch video.progress {
            case .inProgress(let percent):
                return percent
            default:
                return nil
        }
    }
 
    var wasWatched: Bool {
        if case .watched = video.progress { return true } else { return false }
    }
    
    var videoURL: URL {
        video.url
    }
    
    var playingPosition: TimeInterval {
        video.playingPosition
    }
}

// MARK: - Intents
extension VideoBooklet {
    func markAsWatched() {
        var newVideo = self.video
        newVideo.playingPosition = video.duration
        delegate.replace(self.video, with: newVideo)
    }
    
    func markAsUnwatched() {
        var newVideo = self.video
        newVideo.playingPosition = 0
        delegate.replace(self.video, with: newVideo)
    }
    
    func updatePlayingPosition(to time: TimeInterval) {
        var newVideo = self.video
        newVideo.playingPosition = time
        delegate.replace(self.video, with: newVideo)
    }
}

protocol LibraryDelegate {
    func replace(_ video: Video, with newVideo: Video)
}


// MARK: - Errors

enum MyError: Error {
	case runtimeError(String)
}

public enum HTTPError: Error, ExpressibleByIntegerLiteral {

	case badRequest(description: String?)
	case unauthorized(description: String?)
	case notFound(description: String?)
	case serverError(description: String?)
	case unprocessableRequest(description: String?)
	case unknown(description: String?)

}

// MARK: - ExpressibleByIntegerLiteral
public extension HTTPError {

	init(integerLiteral value: Int) {
		self = .init(code: value, description: nil)
	}

}

// MARK: - Init
extension HTTPError {

	init(code: Int, description: String?) {
		switch code {
		case 400:
			self = .badRequest(description: description)
		case 401:
			self = .unauthorized(description: description)
		case 404:
			self = .notFound(description: description)
		case 422:
			self = .unprocessableRequest(description: description)
		case 500:
			self = .serverError(description: description)
		default:
			self = .unknown(description: description)
		}
	}

}
