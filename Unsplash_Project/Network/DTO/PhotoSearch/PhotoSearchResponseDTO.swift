//
//  PhotoSearchResponseDTO.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation

struct PhotoSearchResponseDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    struct Result: Decodable {
        let id: String
        let urls: Urls

        struct Urls: Decodable {
            let small: String
        }
    }
}

extension PhotoSearchResponseDTO {
    func returnSearchedPhotos() -> [Photo] {
        return results.map {
            Photo(id: $0.id, url: URL(string: $0.urls.small)!)
        }
    }
}
