//
//  Result.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation

struct PhotoList: Codable {
    let id: String
    let urls: URLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
}
