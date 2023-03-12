//
//  SceneDelegate.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var viewModel = UserViewModel()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootVC = LoginVC()
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        window.makeKeyAndVisible()

        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        LogUtil.d(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        LogUtil.d(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        LogUtil.d(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        viewModel.input.request.send(.token)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LogUtil.d(scene)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
       if let url = URLContexts.first?.url {
           if (AuthApi.isKakaoTalkLoginUrl(url)) {
               _ = AuthController.handleOpenUrl(url: url)
           }
       }
   }

}

