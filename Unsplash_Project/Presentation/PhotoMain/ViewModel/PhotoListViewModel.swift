//
//  PhotoMainViewModel.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/11.
//

import Foundation
import RxSwift
import RxCocoa

final class PhotoListViewModel: ViewModelType {

    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var currentPage = 0
    private var perPage = 10
    
    struct Input { }
    
    struct Output {
        let photos: Driver<[Photo]>
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let photos = PublishSubject<[Photo]>()
        
        fetchPhotos()
            .subscribe { value in
                photos.onNext(value)
            } onFailure: { error in
                photos.onError(error)
            }
            .disposed(by: disposeBag)
        
        return Output(photos: photos.asDriver(onErrorJustReturn: []))
    }
    
    // traits -> main thread에서 실행됨, error 이벤트 없음
    func fetchPhotos() -> Single<[Photo]> {
        return Single<[Photo]>.create { observer in
            let photoRequestDTO = PhotoListRequestDTO(page: self.currentPage, perPage: self.perPage)
            
            UnsplashService.shared.fetchPhotoList(with: photoRequestDTO) { result in
                switch result {
                case .success(let data):
                    let photos = data.map { $0.returnPhoto() }
                    observer(.success(photos))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
}
