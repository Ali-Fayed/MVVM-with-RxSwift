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
import RxDataSources

class UsersViewModel {
    var observer: AnyCancellable?
    let useCase: UsersUseCaseProtocol
    let states = States()
    private var usersSectionModel = [UsersSectionModel]()
    private let usersListSubjet = PublishSubject<[UsersSectionModel]>()
    var usersListObservable: Observable<[UsersSectionModel]> {
        return usersListSubjet
    }
    //MARK: - Initialization
    init(useCase: UsersUseCaseProtocol = UsersUseCase.shared) {
        self.useCase = useCase
    }
    //MARK: - Methods
    func fetchUsers() {
        states.loadingState.accept(true)
        observer = useCase.fetchUsers()?
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    self.states.loadingState.accept(false)
                case .failure(let error):
                    self.states.errorState.accept((true, error.localizedDescription))
                }
            }, receiveValue: { [weak self] users in
                guard let self = self else {return}
                self.usersSectionModel.append(UsersSectionModel(header: "TopUsers", items: users.dropLast(25)))
                self.usersSectionModel.append(UsersSectionModel(header: "MiddleUsers", items: users.dropLast(28).reversed()))
                self.usersSectionModel.append(UsersSectionModel(header: "LastUsers", items: users.dropLast(26).reversed()))
                self.usersListSubjet.onNext(self.usersSectionModel)
                self.usersListSubjet.onCompleted()
            })
    }
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<UsersSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<UsersSectionModel>(
            configureCell: { (_, tableView, indexPath, items) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = items.userName
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )
        return dataSource
    }
}
