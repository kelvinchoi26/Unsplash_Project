//
//  PhotoService.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/09.
//

import Foundation
import Alamofire
import RxSwift

final class UnsplashService {
    
    // Singleton Pattern
    static let shared = UnsplashService()
    
    private init() {}
    
    func searchPhotos(with query: String) -> Observable<PhotoSearchRequestDTO> {
        return Observable.create { observer in
            guard let url = URL(string: URLPath.baseURL + query) else { return }
            let header: HTTPHeaders = ["Authorization": "Client-ID " + APIKey.accessKey]
            let request = AF.request(url, headers: header)
            
            request.responseDecodable(of: PhotoSearchResponseDTO.self) { response in
                switch response.result {
                case .success(let result):
                    observer.onNext(result.results)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                // Request 취소
                request.cancel()
            }
        }
        
    }
    
}
