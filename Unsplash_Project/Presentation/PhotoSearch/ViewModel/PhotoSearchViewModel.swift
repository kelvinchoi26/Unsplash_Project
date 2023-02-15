//
//  PhotoSearchViewModel.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation
import RxSwift
import RxCocoa

final class PhotoSearchViewModel {
    
    // MARK: - Properties
    private var query = ""
    private let service = UnsplashService.shared
    private var page: Int = 0
    
    var navigationTitle = BehaviorRelay(value: "오늘의 기분을 검색하세요")
    
    var photos = BehaviorRelay<[Photo]>(value: [])
    
    // MARK: - Methods
    func fetchSearchedPhotos(query: String) {
        print(query)
        
        let request = PhotoSearchRequestDTO(query: query, page: page)
        print(request)
        UnsplashService.shared.fetchSearchedPhoto(with: request) { result in
            switch result {
            case .success(let data):
                let photos = data.returnSearchedPhotos()
                self.photos.accept(photos)
            case .failure(let error):
                print("Error fetching searched photos: \(error.localizedDescription)")
            }
        }
    }
    
}
