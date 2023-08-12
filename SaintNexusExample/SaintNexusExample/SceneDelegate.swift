//
//  SceneDelegate.swift
//  SaintNexusExample
//
//  Created by Gyuni on 2022/04/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.tintColor = .systemPurple

        let featureViewController = FeatureHostingController(rootView: FeatureListView())
        featureViewController.title = "Feature"
        
        let manuallyInputViewController = ManuallyInputViewController()
        manuallyInputViewController.title = "Manually Input"
        let manuallyInputNavigationController = UINavigationController(rootViewController: manuallyInputViewController)
        manuallyInputNavigationController.navigationBar.prefersLargeTitles = true

        let userDataInputViewController = UserDataInputViewController()
        userDataInputViewController.title = "UserData"
        let userDataInputNavigationController = UINavigationController(rootViewController: userDataInputViewController)
        userDataInputNavigationController.navigationBar.prefersLargeTitles = true

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([
            featureViewController,
            manuallyInputNavigationController,
            userDataInputNavigationController,
        ], animated: true)

        tabBarController.selectedIndex = 1

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}


