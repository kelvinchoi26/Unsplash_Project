//
//  SceneDelegate.swift
//  Unsplash_Project
//
//  Created by 최형민 on 2023/02/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        let mainViewController = MainViewController()
        let navigationMainViewController = UINavigationController(rootViewController: mainViewController)
        let coordinator = MainCoordinator(navigationController: navigationMainViewController, window: self.window!)
        coordinator.start()
    }

}
