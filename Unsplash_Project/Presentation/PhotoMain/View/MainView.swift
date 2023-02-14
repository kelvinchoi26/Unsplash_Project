//
//  MainView.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/12.
//

//import UIKit
//
//final class MainView: BaseView {
//
//    // MARK: - Properties
//    /// <SectionIdentifierType, ItemIdentifierType>
//    /// <Section, Row에 들어갈 아이템>
//    /// Model 기반
//    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Photo>?
//
//    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
//
//    // MARK: - Attributes
//    override func setAttributes() {
//        super.setAttributes()
//
//        self.do {
//            $0.backgroundColor = .systemBackground
//        }
//
//        collectionView.do {
//            $0.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
//        }
//
//        self.addSubview(collectionView)
//    }
//
//    // MARK: - Constraints
//    override func setConstraints() {
//        super.setConstraints()
//
//        collectionView.snp.makeConstraints {
//            $0.edges.equalTo(self.safeAreaLayoutGuide)
//        }
//    }
//}

