//
//  Alerts+Ext.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import UIKit

extension UIViewController {
    typealias ActionCompletion = ((UIAlertAction) -> Void)?
    func alertWithOneAction(title: String, msg: String, btnTitle: String, completion: ActionCompletion = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default, handler: completion)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
