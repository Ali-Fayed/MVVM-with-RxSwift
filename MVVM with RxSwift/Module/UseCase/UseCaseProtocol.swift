//
//  UsecaseProtocol.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine

protocol UseCaseProtocol {
    func fetchData() -> AnyPublisher<[Users], Error>
}
