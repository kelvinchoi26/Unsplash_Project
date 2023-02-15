//
//  PhotoSearchViewController.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/14.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class PhotoSearchViewController: BaseViewController {
    
    //MARK: - Properties
    private let viewModel = PhotoSearchViewModel()
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.createLayout()
    )
    private let searchBar = UISearchBar()
    
    weak var coordinator: SearchCoordinator?
    
    // true인 경우: page 끝까지 scroll시 pagination 구현
    private var isFetchingMore = false
    
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
        
        [searchBar, collectionView, loadingView].forEach {
            self.view.addSubview($0)
        }
    }
    
    // MARK: - Constraints
    override func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    override func bind() {
        viewModel.photos
            .withUnretained(self)
            .bind { vc, photos in
                self.loadingView.stopAnimating() // 로딩 애니메이션 종료
                
                var snapshot = vc.diffableDataSource?.snapshot()

                if snapshot == nil {
                    snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
                    snapshot?.appendSections([0])
                }
                
                snapshot?.appendItems(photos)
                vc.diffableDataSource?.apply(snapshot ?? NSDiffableDataSourceSnapshot<Int, Photo>(), animatingDifferences: true)
                self.isFetchingMore = false // pagination를 위한 flag
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] query in
                self?.viewModel.fetchSearchedPhotos(query: query, page: self?.viewModel.page ?? 0)
            }
            .disposed(by: disposeBag)
        
        viewModel.navigationTitle
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 로딩 애니메이션 시작
        loadingView.startAnimating()
    }
}

extension PhotoSearchViewController {
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
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        initialSnapshot.appendSections([0])
        diffableDataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}

extension PhotoSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            if !isFetchingMore {
                isFetchingMore = true
                viewModel.fetchNextPageOfPhotos(query: searchBar.text ?? "")
            }
        }
    }
}
