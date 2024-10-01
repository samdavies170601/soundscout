//
//  FeedViewModelTests.swift
//  soundscoutTests
//
//  Created by Sam Davies on 26/09/2024.
//

import XCTest
@testable import soundscout

final class FeedViewModelTests: XCTestCase {

    func testLoadingFeedContent() async {
        let viewModel = FeedViewModel()
        await viewModel.getContent()
        XCTAssert(viewModel.content.count > 0, "Expected at least one item in the content collection.")
    }

}
