//
//  PhotoSearchViewModel.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/10.
//

import Foundation
import RxSwift

class PhotoSearchViewModel {
    private let query = BehaviorSubject<String>(value: "")
    private let service = UnsplashService.shared
    
    var photos: Observable<[Photo]> {
        return query.flatMapLatest { query in
            self.service.searchPhotos(with: query)
        }
    }
    
    func search(query: String) {
        self.query.onNext(query)
    }
    
}
