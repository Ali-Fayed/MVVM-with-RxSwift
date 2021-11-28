//
//  States.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation
import RxCocoa
import RxSwift

class States {
    var loadingState = BehaviorRelay<Bool>(value: false)
    var errorState = BehaviorRelay<(Bool, String)>(value: (false, ""))
}
