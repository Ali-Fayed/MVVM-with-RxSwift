//
//  UsersViewModelTests.swift
//  MVVM with RxSwiftTests
//
//  Created by Ali Fayed on 28/11/2021.
//

import XCTest
@testable import MVVM_with_RxSwift
class UsersViewModelTests: XCTestCase {
    var sut: UsersViewModel!
    var usersUseCaseMock = UsersUseCaseMock()
    override func setUp() {
        sut = UsersViewModel(useCase: usersUseCaseMock)
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    func testRequstData() throws {
        // when
        sut.fetchUsers()
        // then
        XCTAssertTrue(usersUseCaseMock.fetchUsersComplete, "Users fetch request called successfully")
    }
}
