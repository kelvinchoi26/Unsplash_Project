//
//  Urls.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/11.
//

import Foundation

struct URLs: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
