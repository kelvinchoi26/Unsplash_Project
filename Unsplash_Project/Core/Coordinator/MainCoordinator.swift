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
    
    var childCoordinators = [Coordinator]()
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
    
    // parent와 child coordinator 관계 설정
    func searchSubscription() {
        let child = SearchCoordinator(navigationController: navigationController)
        
        // SearchCoordiantor의 parent coordinator로 MainCoordinator 설정
        child.parentCoordinator = self
        
        // child coordinator 을 저장하는 배열에 저장
        childCoordinators.append(child)
        
        // PhotoSearchViewController 로 화면전환
        child.start()
    }
}
