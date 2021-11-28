//
//  LoadingIndicator+Ext.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import UIKit
import MBProgressHUD

extension UIViewController {
   func showIndicator(withTitle title: String, and Description:String) {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      Indicator.isUserInteractionEnabled = false
      Indicator.detailsLabel.text = Description
      Indicator.show(animated: true)
      self.view.isUserInteractionEnabled = false
   }
   func hideIndicator() {
      MBProgressHUD.hide(for: self.view, animated: true)
      self.view.isUserInteractionEnabled = true
   }
}
