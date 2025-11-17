//
//  BSTabBarController.swift
//  Rent
//
//  Created by jiang 2019/2/25.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import MGJRouter
import BSBase

class BSTabBarController: UITabBarController {
//    var messageVc = MessageViewController()
    var homeVc = BSBaseViewController()
    var productsVc = CategoryViewController()
    var messageVc = BSBaseViewController()
    var mineVc = MineViewController()
    var publishVc = PublishViewController()
    var centerVc = BSBaseViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iOS12.1 UINavigationController + UITabBarController（ UITabBar 磨砂），在 系统的 popViewControllerAnimated 会遇到tabbar布局错乱的问题，所以需添加以下方法。
        self.tabBar.isTranslucent = false
        self.delegate = self
        setupAllChildViewController()
    }
    
    func setupAllChildViewController() {
        //messageVc = MGJRouter.object(forURL: "bsm://chatList") as! UIViewController
        setupOneChildViewController(vc: homeVc, image: UIImage(named: "tabbar_home")!, selectedImage: UIImage(named: "tabbar_home_selected")!, title: "首页")
        setupOneChildViewController(vc: productsVc, image: UIImage(named: "tabbar_branch")!, selectedImage: UIImage(named: "tabbar_branch_selected")!, title: "分类")
        setupOneChildViewController(vc: centerVc, image: UIImage(named: "tabbar_publish")!,
            selectedImage: UIImage(named: "tabbar_publish")!, title: "发布")
        setupOneChildViewController(vc: messageVc, image: UIImage(named: "tabbar_message")!,
                                    selectedImage: UIImage(named: "tabbar_message_selected")!, title: "消息")
        setupOneChildViewController(vc: mineVc, image: UIImage(named: "tabbar_me")!, selectedImage: UIImage(named: "tabbar_me_selected")!, title: "我的")
        self.tabBar.tintColor = UIUtils.getLightBlueColor()
    }

    func setupOneChildViewController(vc: UIViewController, image: UIImage, selectedImage: UIImage, title: String) {
        vc.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage
        let nav = UINavigationController(rootViewController:vc)
        addChild(nav)
    }
}

extension BSTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let title = tabBarController.tabBar.selectedItem?.title{
            if title == "发布"{
                let nav = YLNavigationController(rootViewController: self.publishVc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
