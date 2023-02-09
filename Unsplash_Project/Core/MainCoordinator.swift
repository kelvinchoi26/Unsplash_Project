//
//  MainCoordinator.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/08.
//

import UIKit

// Coordinator 추상화, AnyObject을 상속받아 class만 채택할 수 있게 제한
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    // 화면 전환 로직 역할 수행
    func start()
}

class MainCoordinator: Coordinator {
    // MARK: - Properties
    let window: UIWindow
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initializers
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    // MARK: - Methods
    func start() {
        let rootViewController = MainViewController()
        let navigationRootViewController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationRootViewController
        window.makeKeyAndVisible()
    }
}
