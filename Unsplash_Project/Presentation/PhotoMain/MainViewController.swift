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
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
    }
    
    // MARK: - Attributes
    override func setAttributes() {
        self.do {
            $0.view.backgroundColor = .systemBackground
            $0.navigationController?.navigationBar.prefersLargeTitles = true
            $0.navigationController?.navigationBar.tintColor = .black
        }
        
        collectionView.do {
            $0.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        }
        
        loadingView.do {
            $0.color = .gray
            $0.hidesWhenStopped = true
        }
        
        [collectionView, loadingView].forEach {
            self.view.addSubview($0)
        }
    }
    
    // MARK: - Constraints
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    override func bind() {
        super.bind()
        
        let input = PhotoListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.photos
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] photos in
                guard let self = self else { return }
                self.loadingView.stopAnimating() // 로딩 애니메이션 종료
                var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
                snapshot.appendSections([0])
                snapshot.appendItems(photos)
                self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        // 로딩 애니메이션 시작
        loadingView.startAnimating()
        
        output.navigationTitle
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
    }

}

extension MainViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let itemSpacing: CGFloat = 5
        item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
        
        let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 2)
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 3)
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1000))
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // cellForRowAt 역할
    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photo: Photo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: photo.url)
            return cell
        }
    }
}
