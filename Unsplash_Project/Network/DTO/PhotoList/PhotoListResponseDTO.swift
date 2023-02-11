//
//  PhotoListResponseDTO.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/11.
//

import Foundation

struct PhotoListResponseDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLs
}

extension PhotoListResponseDTO {
    func returnPhoto() -> Photo {
        return Photo(id: id, url: URL(string: urls.small)!)
    }
}
