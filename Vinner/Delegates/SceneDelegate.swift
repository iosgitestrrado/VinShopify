//
//  SceneDelegate.swift
//  Vinner
//
//  Created by softnotions on 17/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
 @available(iOS 13.0,*)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let sharedData = SharedDefault()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

//        if sharedData.getLoginStatus() == false
//        {
//            //initialPage = mainStoryboard.instantiateViewController(withIdentifier: "MerchantHomeVC") as! MerchantHomeVC
//            var initialPage = UIViewController()
//            //initialPage = mainStoryboard.instantiateViewController(withIdentifier: "CustomNavigation") as! CustomNavigation
//            initialPage = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let navigationController = UINavigationController(rootViewController: initialPage)
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//
////
////             let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
////            let navigationController = UINavigationController(rootViewController: rootVC)
////            UIApplication.shared.windows.first?.rootViewController = navigationController
////            UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//        }
//        else
//        {
            var initialPage = UIViewController()
            initialPage = mainStoryboard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
            let navigationController = UINavigationController(rootViewController: initialPage)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()

//        }
        
        //self.getVersion()
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
