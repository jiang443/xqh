//
//  BSBaseViewController.swift
//  Rent
//
//  Created by jiang 2019/2/25.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit
import MJRefresh
import BSCommon

open class BSBaseViewController: BaseViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        setupNavAppearance()
    }
    
    // 设置导航栏
    func setupNavAppearance() {

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
    
    /// 设置状态栏背景颜色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    open func mj_refreshHeader(action: Selector) -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: action)
        header?.stateLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        header?.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_SMALL)
        header?.stateLabel.textColor = UIColor.darkGray
        header?.lastUpdatedTimeLabel.textColor = UIColor.lightGray
        header?.backgroundColor = UIUtils.getBackgroundColor()
        return header!
    }
    
    open func mj_refreshFooter(action: Selector) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: action)
        footer?.stateLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        footer?.stateLabel.textColor = UIColor.darkGray
//        footer?.backgroundColor = UIUtils.getBackgroundColor()
        footer?.backgroundColor = UIColor.white
        return footer!
    }
}
