//
//  SceneDelegate.swift
//  MyBook
//
//  Created by imhs on 5/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 검색 화면(SearchBookViewController)과 내 책 리스트 화면(MyBookListViewController)을 UINavigationController에 넣음
        let searchBookViewController = UINavigationController(rootViewController: SearchBookViewController())
        let myBookListViewController = UINavigationController(rootViewController: MyBookListViewController())
                  
        // 탭 바 컨트롤러(UITabBarController)를 생성하고 검색 화면과 내 책 리스트 화면을 설정
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([searchBookViewController, myBookListViewController], animated: true)
        
        // 탭 바 아이템(TabBarItem) 설정
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")      //선택했을때 이미지
            items[0].image = UIImage(systemName: "magnifyingglass.circle")                //선택하지않았을때 이미지
            items[0].title = "검색 탭"
            
            items[1].selectedImage = UIImage(systemName: "heart.fill")
            items[1].image = UIImage(systemName: "heart")
            items[1].title = "담은 책 리스트"
        }
        // 윈도우의 루트 뷰 컨트롤러(rootViewController)를 탭 바 컨트롤러로 설정
        window?.rootViewController = tabBarController
        // 윈도우를 화면에 표시
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

