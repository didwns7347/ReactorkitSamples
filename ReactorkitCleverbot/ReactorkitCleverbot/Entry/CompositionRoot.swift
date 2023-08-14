//
//  CompositionRoot.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

enum CompositionRoot {
    static func resolve() -> AppDependency {
        //service
        let cleverbotService = CleverBotService()
        
        //root vc
        let chatViewReactor = ChatViewReactor(cleverbotService: cleverbotService)
        let chatViewController = ChatViewController(reactor: chatViewReactor)
        let navigationController = UINavigationController(rootViewController: chatViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return AppDependency(window: window)
    }
}
