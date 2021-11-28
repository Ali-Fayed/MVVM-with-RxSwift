//
//  UsersUseCase.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine

class UsersUseCase: UsersUseCaseProtocol {
    static let shared = UsersUseCase()
    private init () {}
    func fetchUsers() -> AnyPublisher<[Users], Error>? {
        let url = URL(string: "https://api.github.com/users")
        return URLSession.shared.dataTaskPublisher(for: url!)
            .map({$0.data})
            .decode(type: [Users].self, decoder: JSONDecoder())
            .mapError({ error in
                switch error {
                case is Swift.DecodingError:
                    return error
                default:
                    return error
                }
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
