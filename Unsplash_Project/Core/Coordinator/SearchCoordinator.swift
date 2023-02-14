//
//  SearchCoordinator.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/15.
//

import UIKit

class SearchCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // retain cycle을 피하기 위해 weak 참조로 선언
    weak var parentCoordinator: MainCoordinator?
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        let photoSearchVC = PhotoSearchViewController()
        navigationController.pushViewController(photoSearchVC, animated: true)
    }
}
