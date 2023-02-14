//
//  PhotoListRequestDTO.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/11.
//

import Foundation
import RxSwift

struct PhotoListRequestDTO: Encodable {
    var page: Int
    var perPage: Int = 20
    var orderBy: OrderBy = .latest
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case orderBy = "order_by"
    }
}

enum OrderBy: String, Encodable {
    case latest
    case oldest
    case popular
}

extension PhotoListRequestDTO {
    // 인코딩한 RequestDTO 객체를 JSON 데이터로 변환!
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
