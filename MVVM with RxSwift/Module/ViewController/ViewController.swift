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
    let bag = DisposeBag()
    var viewModel = ViewModel()
    var observer: AnyCancellable?
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        bindDataToTableView()
        subscribeToErrorBehaviour()
        subsribeToLoadingBehaviour()
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
                    self.alertWithOneAction(title: "Error", msg: "ServerError", btnTitle: "Ok")
                }
        }).disposed(by: bag)
    }
    //MARK: - TableView
    func bindDataToTableView () {
        viewModel.usersListObservable.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] row, users, cell in
            guard let self = self else { return }
            cell.textLabel?.text = self.viewModel.newsList[row].userName
        }.disposed(by: bag)
    }
}
