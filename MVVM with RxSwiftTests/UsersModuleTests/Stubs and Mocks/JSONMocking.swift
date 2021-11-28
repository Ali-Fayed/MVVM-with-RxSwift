//
//  fakeJSON.swift
//  MVVM with RxSwiftTests
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation

class JSONMocking {
    static let shared = JSONMocking()
    private init() {}
    let fakeJSON: [String: Any] = [
        "login" : "mojombo"
    ]
}
