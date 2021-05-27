//
//  BookletTests.swift
//  mac-tv
//
//  Created by Marcel Braith on 19.04.21.
//

import XCTest
@testable import mac_tv

class BookletTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBookletProperties() throws {
        let video = Video(title: "Coffee Run",
                          description: "Fueled by caffeine, a young woman runs through the bittersweet memories of her past relationship.",
                          url: URL(fileURLWithPath: Bundle.main.path(forResource: "Coffee Run", ofType:"mp4")!).absoluteString ,
                          duration: 184,
                          published: Date(),
                          imageURL: "https://ddz4ak4pa3d19.cloudfront.net/cache/d1/e2/d1e23ccf3bdfa77b34ff2404c9403513.jpg")
        let booklet = VideoBooklet(video: video)
        
        XCTAssertEqual(booklet.title, "Coffee Run")
        XCTAssertEqual(booklet.description, "Fueled by caffeine, a young woman runs through the bittersweet memories of her past relationship.")
        XCTAssertEqual(booklet.duration, "3min")
    }

}
