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
    var tableSectionModel = [SectionModel]()
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    var errorBehaviour = BehaviorRelay<Bool>(value: false)
    var errorString = ""
    private let usersListSubjet = PublishSubject<[SectionModel]>()
    var usersListObservable: Observable<[SectionModel]> {
        return usersListSubjet
    }
    init(useCase: UseCaseProtocol = UseCase.shared) {
        self.useCase = useCase
    }
    func fetchData () {
        loadingBehaviour.accept(true)
        observer = useCase.fetchData()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    self.loadingBehaviour.accept(false)
                case .failure(let error):
                    self.errorString = error.localizedDescription
                    self.errorBehaviour.accept(true)
                }
            }, receiveValue: { [weak self] model in
                guard let self = self else {return}
                self.newsList.append(contentsOf: model)
                self.tableSectionModel.append(SectionModel(header: "Users", items: self.newsList))
                self.usersListSubjet.onNext(self.tableSectionModel)
            })
    }
}
