//
//  Usecase.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine

class UseCase: UseCaseProtocol {
    static let shared = UseCase()
    private init () {}
    func fetchData() -> AnyPublisher<[Users], Never> {
        guard let url = URL(string: "https://api.github.com/users") else {
            return Just([])
                .eraseToAnyPublisher()
        }
        let puplisher = URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [Users].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        return puplisher
    }
}
