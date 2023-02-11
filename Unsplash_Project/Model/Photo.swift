//
//  Photo.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation

struct Photo: Hashable {
    let id: String
    let url: URL
    
    init(id: String, url: URL) {
        self.id = id
        self.url = url
    }
}
