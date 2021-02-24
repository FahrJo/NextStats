//
//  SceneDelegate.swift
//  NextStats
//
//  Created by Jon Alaniz on 1/10/20.
//  Copyright © 2020 Jon Alaniz. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {
    var coordinator: MainCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Grab the windowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize a SplitViewController and Coordinator
        let splitViewController = UISplitViewController()
        coordinator = MainCoordinator(splitViewController: splitViewController)
        coordinator?.start()
        
        // Setup our SplitViewController
        splitViewController.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        splitViewController.primaryBackgroundStyle = .sidebar
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        
        // Set the window to the SplitViewController
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splitViewController
        window.makeKeyAndVisible()
        self.window = window
            
        #if targetEnvironment(macCatalyst)
        // Set minimum windows size
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            let size = CGSize(width: 800, height: 600)
            
            windowScene.sizeRestrictions?.minimumSize = size
        }
        
        // Remove titlebar
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
        #endif
        
        window.tintColor = UIColor(red: 142 / 255, green: 154 / 255, blue: 255 / 255, alpha: 1.0)
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

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {

        return true
    }
    
}

