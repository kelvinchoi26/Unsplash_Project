//
//  PhotoService.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/09.
//

import Foundation
import Alamofire

final class UnsplashService {
    
    // Singleton Pattern
    static let shared = UnsplashService()
    
    private init() {}
    
    func fetchPhotoList(
        with request: PhotoListRequestDTO,
        completion: @escaping (Result<[PhotoListResponseDTO], NetworkError>) -> Void
    ) {
        let urlPath = URLPath.baseURL + EndpointPath.photoList.path
        guard let parameter = try? request.toDictionary() else { return }
        let headers: HTTPHeaders = ["Authorization": "Client-ID 7rTmBJz__MBYAh7KyK-XKGyEbQPb3o5ui-cuR3U-toA"]
        
        AF.request(urlPath, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200...299)
            .responseDecodable(of: [PhotoListResponseDTO].self) { result in
                switch result.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure:
                    completion(.failure(.decodeError))
                }
            }
    }
    
}
