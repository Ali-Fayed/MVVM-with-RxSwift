//
//  UsersUseCaseMock.swift
//  MVVM with RxSwiftTests
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine
@testable import MVVM_with_RxSwift
class UsersUseCaseMock: UsersUseCaseProtocol {
    var fetchUsersComplete = false
    func fetchUsers() -> AnyPublisher<[Users], Error>? {
        fetchUsersComplete = true
        return nil
    }
}
