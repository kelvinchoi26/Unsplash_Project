//
//  Result.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation

struct Result: Decodable {
    let id: String
    let urls: [String : String]
    
    init(id: String, urls: [String : String]) {
        self.id = id
        self.urls = urls
    }
}
