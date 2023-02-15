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
    var page: Int = 0
    
    var navigationTitle = BehaviorRelay(value: "오늘의 기분을 검색하세요")
    
    var photos = BehaviorRelay<[Photo]>(value: [])
    
    // MARK: - Methods
    func fetchSearchedPhotos(query: String, page: Int) {
        let request = PhotoSearchRequestDTO(query: query, page: page)
        
        self.query = query
        self.page = page

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
    
    func fetchNextPageOfPhotos(query: String) {
        page += 1
        fetchSearchedPhotos(query: query, page: page)
    }
}
