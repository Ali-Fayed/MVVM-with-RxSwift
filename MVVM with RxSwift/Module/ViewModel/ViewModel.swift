//
//  ViewModel.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

class ViewModel {
    var observer: AnyCancellable?
    let useCase: UseCaseProtocol
    var newsList = [Users]()
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    var errorBehaviour = BehaviorRelay<Bool>(value: false)
    private let usersListSubjet = PublishSubject<[Users]>()
    var usersListObservable: Observable<[Users]> {
        return usersListSubjet
    }
    init(useCase: UseCaseProtocol = UseCase.shared) {
        self.useCase = useCase
    }
    func fetchData () {
        loadingBehaviour.accept(true)
        observer = useCase.fetchData()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    guard let self = self else {return}
                    self.loadingBehaviour.accept(false)
                    if self.newsList.isEmpty {
                        self.errorBehaviour.accept(true)
                    } else {
                        self.errorBehaviour.accept(false)
                    }
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] model in
                guard let self = self else {return}
                self.newsList.append(contentsOf: model)
                self.usersListSubjet.onNext(self.newsList)
            })
    }
}
