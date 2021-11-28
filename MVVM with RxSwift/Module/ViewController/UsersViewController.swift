//
//  UsersViewController.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    //MARK: - Props
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var viewModel = UsersViewModel()
    private let bag = DisposeBag()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUsers()
        bindDataToTableView()
        tableViewRefreshControl()
        subscribeToTableViewCellSelection()
        subscribeToErrorBehaviour()
        subsribeToLoadingBehaviour()
    }
    //MARK: - TableView
    func bindDataToTableView() {
        viewModel.usersListObservable.bind(to: tableView.rx.items(dataSource: viewModel.tableViewDataSource()))
            .disposed(by: bag)
    }
    func subscribeToTableViewCellSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Users.self))
            .bind { [weak self] indexPath, users in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                print(users)
            }.disposed(by: bag)
    }
    func tableViewRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func didPullToRefresh() {
        self.viewModel.fetchUsers()
        self.refreshControl.endRefreshing()
    }
    //MARK: - Loading
    func subsribeToLoadingBehaviour() {
        viewModel.states.loadingState.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            isLoading ? self.showIndicator(withTitle: "Loading", and: "") : self.hideIndicator()
        }).disposed(by: bag)
    }
    //MARK: - Error
    func subscribeToErrorBehaviour() {
        viewModel.states.errorState.subscribe(onNext: { [weak self] (error) in
            guard let self = self else { return }
            let ifResponseFailed = error.0
            let errorMessage = error.1
            if ifResponseFailed {
                self.alertWithOneAction(title: "Error", msg: errorMessage, btnTitle: "Ok")
            }
        }).disposed(by: bag)
    }
}
