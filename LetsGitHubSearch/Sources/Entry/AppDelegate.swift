//
//  AppDelegate.swift
//  LetsGitHubSearch
//
//  Created by Suyeol Jeon on 03/11/2018.
//  Copyright © 2018 Suyeol Jeon. All rights reserved.
//

import UIKit
import Alamofire

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    if let rootViewController = self.rootViewController() {
        let repositoryService = RepositoryService(
            sessionManager: SessionManager.default
        )
        rootViewController.repositoryService = repositoryService
    }
    
    return true
  }
    
    private func rootViewController() -> SearchRepositoryViewController? {
        guard let navigationController = self.window?.rootViewController as? UINavigationController else { return nil }
        
        return navigationController.viewControllers.first as? SearchRepositoryViewController
    }
}

