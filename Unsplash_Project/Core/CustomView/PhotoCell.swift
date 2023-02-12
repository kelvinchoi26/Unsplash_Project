//
//  PhotoCell.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/12.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    // Load Image to Cell
    func configure(imagePath: String) {
        let url = URL(string: imagePath)
        
        // decode 에러 발생하는 경우 do-try문으로 방지
        do {
            let data = try Data(contentsOf: url!)
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        } catch {
            print("Error reading data: \(error)")
        }
        
    }
}
