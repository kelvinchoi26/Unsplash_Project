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
    var currentPage = BehaviorSubject<Int>(value: 0)
    var perPage = 20
    
    struct Input {
        // 검색 버튼 클릭 이벤트
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        // 이벤트 처리
        let searchButtonTap: ControlEvent<Void>
        
        let navigationTitle: Driver<String>
        let photos: Driver<[Photo]>
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let navigationTitle = BehaviorRelay(value: "How's your day?").asDriver()
        let photos = PublishSubject<[Photo]>()
        
        currentPage
            .flatMapLatest { page -> Single<[Photo]> in
                self.fetchPhotos(page: page)
            }
            .subscribe(onNext: { value in
                photos.onNext(value)
            }, onError: { error in
                photos.onError(error)
            })
            .disposed(by: disposeBag)
        
        return Output(searchButtonTap: input.searchButtonTap, navigationTitle: navigationTitle, photos: photos.asDriver(onErrorJustReturn: []))
    }
    
    // traits -> main thread에서 실행됨, error 이벤트 없음
    func fetchPhotos(page: Int) -> Single<[Photo]> {
        return Single<[Photo]>.create { observer in
            let photoRequestDTO = PhotoListRequestDTO(page: page, perPage: self.perPage)

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
