//
//  UsersSectionModel.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import RxDataSources

struct UsersSectionModel {
    var header: String
    var items: [Users]
}
extension UsersSectionModel: SectionModelType {
    init(original: UsersSectionModel, items: [Users]) {
        self = original
        self.items = items
    }
}
