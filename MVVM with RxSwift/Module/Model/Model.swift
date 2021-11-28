//
//  Model.swift
//  MVVM with RxSwift
//
//  Created by Ali Fayed on 28/11/2021.
//

import Foundation

struct Users {
    let userName: String?
    
    enum PostCodingKeys: String, CodingKey {
        case userName = "login"
    }
}
//MARK: - Decodable init
extension Users: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
    }
}
