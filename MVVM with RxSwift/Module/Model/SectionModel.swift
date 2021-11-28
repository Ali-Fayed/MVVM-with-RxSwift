//
//  SectionModel.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import RxDataSources

struct SectionModel {
    var header: String
    var items: [Users]
}
extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Users]) {
        self = original
        self.items = items
    }
}
