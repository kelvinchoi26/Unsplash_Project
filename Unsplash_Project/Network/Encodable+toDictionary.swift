//
//  Encodable+toDictionary.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/14.
//

import Foundation

extension Encodable {
    // 인코딩한 RequestDTO 객체를 JSON 데이터로 변환!
    // 모든 encodable 객체에 사용 가능, ex. requestDTO
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
