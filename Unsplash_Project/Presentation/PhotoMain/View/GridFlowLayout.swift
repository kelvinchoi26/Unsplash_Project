//
//  GridFlowLayout.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/12.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    
    init(numberOfColumns: Int) {
        super.init()
        
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        let width = UIScreen.main.bounds.width / CGFloat(numberOfColumns)
        itemSize = CGSize(width: width, height: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
