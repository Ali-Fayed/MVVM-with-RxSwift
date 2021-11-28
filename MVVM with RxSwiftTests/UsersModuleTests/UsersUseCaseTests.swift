//
//  UsersUseCaseTests.swift
//  MVVM with RxSwiftTests
//
//  Created by Ali Fayed on 28/11/2021.
//

import XCTest
import Combine
@testable import MVVM_with_RxSwift

class UsersUseCaseTests: XCTestCase {
    // sut = system under test
    var sut: UsersUseCase!
    let stubRequest = StubRequests.shared
    let jsonMock = JSONMocking.shared
    var observer: AnyCancellable?
    override func setUp() {
        super.setUp()
        sut = UsersUseCase.shared
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    func testFetchNewsList() {
        let exception = self.expectation(description: "Fetch Users Failed")
        var expectedResults: [Users] = []
        stubRequest.stubJSONrespone(jsonObject: [jsonMock.fakeJSON], header: nil, statusCode: 200, absoluteStringWord: "/users")
        observer = sut.fetchUsers()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertNotNil(error.localizedDescription)
                }
            }, receiveValue: { model in
                expectedResults = model
                exception.fulfill()
            })
        XCTAssertNotNil(expectedResults)
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}
