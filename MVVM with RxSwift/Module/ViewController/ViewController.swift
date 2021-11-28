//
//  ViewController.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import UIKit
import Combine
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    //MARK: - Props
    @IBOutlet weak var tableView: UITableView!
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var viewModel = ViewModel()
    private var observer: AnyCancellable?
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        bindDataToTableView()
        tableViewRefreshControl()
        subscribeToTableViewCellSelection()
        subscribeToErrorBehaviour()
        subsribeToLoadingBehaviour()
    }
    //MARK: - TableView
    func bindDataToTableView() {
        viewModel.usersListObservable.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] row, users, cell in
            guard let self = self else { return }
            cell.textLabel?.text = self.viewModel.newsList[row].userName
        }.disposed(by: bag)
    }
    func subscribeToTableViewCellSelection() {
        /// didSelectRow
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
        viewModel.fetchData()
        refreshControl.endRefreshing()
    }
    //MARK: - Loading
    func subsribeToLoadingBehaviour() {
        viewModel.loadingBehaviour.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.tableView.isHidden = true
                    self.showIndicator(withTitle: "Loading", and: "")
                } else {
                    self.tableView.isHidden = false
                    self.hideIndicator()
                }
            }
        }).disposed(by: bag)
    }
    //MARK: - Error
    func subscribeToErrorBehaviour() {
        viewModel.errorBehaviour.subscribe(onNext: { [weak self] (isResponseFailed) in
            guard let self = self else { return }
                if isResponseFailed {
                    self.alertWithOneAction(title: "Error", msg: self.viewModel.errorString, btnTitle: "Ok") { _ in
                        self.viewModel.fetchData()
                    }
                }
        }).disposed(by: bag)
    }
}
