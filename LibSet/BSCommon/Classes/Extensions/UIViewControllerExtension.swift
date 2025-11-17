//
//  UIViewControllerExtensiion.swift
//  AfterDoctor
//
//  Created by jiang on 2018/8/21.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

extension UIViewController{
    
    open func setNavTheme(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "icon_back"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        //let width = UIUtils.getScreenWidth()
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem

        // 导航栏标题字体颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        self.navigationController?.navigationBar.isTranslucent = false
         // 导航栏背景颜色
        self.navigationController?.navigationBar.barTintColor = UIUtils.getThemeColor()
        self.navigationController?.navigationBar.backgroundColor = UIUtils.getThemeColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: StringUtils.FONT_LARGE)]
    }
    
    @objc open func handleBack(){
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    open func setRightItem(_ title:String, action:Selector){
        self.setRightItem(title, action: action, width: 50)
    }
    
    open func setRightItem(_ title:String, action:Selector, width:CGFloat){
        let rightButton = UIButton()
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        rightButton.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        rightButton.addTarget(self, action: action, for: .touchUpInside)
        let rightitem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightitem
    }
    
    /// 查找导航栈中前一个ViewController
    open var backViewController:UIViewController?{
        get{
            if let vcs = self.navigationController?.viewControllers{
                for idx in 0..<vcs.count{
                    let backIdx = vcs.count - 1 - idx //倒序查找，提高成功率
                    if vcs[backIdx] == self && backIdx > 0{
                        return vcs[backIdx - 1]
                    }
                }
            }
            return nil
        }
    }
    

}
