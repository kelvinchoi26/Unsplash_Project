//
//  URLPath.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation

struct URLPath {
    static var baseURL: String { return "https://api.unsplash.com" }
}

enum EndpointPath {
    case photoList
    case searchPhoto
    
    var path: String {
        switch self {
        case .photoList:
            return "/photos"
        case .searchPhoto:
            return "/search/photos?query="
        }
    }
}

