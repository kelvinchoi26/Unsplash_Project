//
//  MainViewController.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/08.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MainViewController: BaseViewController {
    
    //MARK: - Properties
    private let viewModel = PhotoListViewModel()
    private let mainView = MainView()
    
    // MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Attributes
    override func setAttributes() {
        self.do {
            $0.navigationController?.navigationBar.prefersLargeTitles = true
            $0.navigationController?.navigationBar.tintColor = .black
        }
    }
    
    // MARK: - Bind
    override func bind() {
        super.bind()
        
        let input = PhotoListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.photos
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.collectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)) { row, element, cell in
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: element.url)
            }
            .disposed(by: disposeBag)
        
        output.navigationTitle
            .drive(self.rx.title)
            .disposed(by: disposeBag)
    }

}
