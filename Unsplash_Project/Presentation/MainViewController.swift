//
//  MainViewController.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/08.
//

import UIKit
import RxSwift
import Alamofire

final class MainViewController: BaseViewController {
    
    //MARK: Properties
    private let viewModel = PhotoSearchViewModel()
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Configures
    override func setAttributes() {
        super.setAttributes()
        
        view.backgroundColor = .red
    }
    
}
