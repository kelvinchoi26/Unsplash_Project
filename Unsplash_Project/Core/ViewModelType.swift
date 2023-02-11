//
//  ViewModelType.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/11.
//

import Foundation

protocol ViewModelType {
    
    // MARK: - Properties
    
    // MARK: - Input/Output
    associatedtype Input
    associatedtype Output
    
    // MARK: - Transform
    func transform(input: Input) -> Output
}
