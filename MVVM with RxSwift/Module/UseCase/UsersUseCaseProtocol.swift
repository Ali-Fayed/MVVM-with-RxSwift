//
//  UsersUseCaseProtocol.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine

protocol UsersUseCaseProtocol {
    func fetchUsers() -> AnyPublisher<[Users], Error>?
}
