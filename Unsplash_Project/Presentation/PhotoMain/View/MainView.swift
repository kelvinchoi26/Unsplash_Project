//
//  MainView.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/12.
//

import UIKit

final class MainView: BaseView {
    
    // MARK: - Properties
    /// <SectionIdentifierType, ItemIdentifierType>
    /// <Section, Row에 들어갈 아이템>
    /// Model 기반
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    // MARK: - Attributes
    override func setAttributes() {
        super.setAttributes()
        
        self.do {
            $0.backgroundColor = .systemBackground
        }
        
        collectionView.do {
            $0.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        }
        
        self.addSubview(collectionView)
    }
    
    // MARK: - Constraints
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension MainView {
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
    
//    func configureDataSource(collectionView: UICollectionView) {
//        let diffableDataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//            // Configure the cell
//            return cell
//        }
//        collectionView.dataSource = diffableDataSource
//    }
    
//    func applySnapshot(collectionView: UICollectionView) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(Array(0..<5))
//        diffableDataSource.apply(snapshot, animatingDifferences: false)
//    }
    
    enum Section {
        case main
    }
}
