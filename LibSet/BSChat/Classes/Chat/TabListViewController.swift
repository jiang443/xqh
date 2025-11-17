//
//  TabListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/9/22.
//

import UIKit
import BSCommon

class TabListViewController: UIViewController{
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 45 + 12, width: ScreenWidth, height: ScreenHeight - NavHeight - 45 - 12 - TabBarBottomHeight))
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()

    // 按钮栏
    lazy var btnView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 下划线
    lazy var line: UIView = {
        let view = UIView(frame: CGRect(x: 28, y: 43, width: 18, height: 2))
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIUtils.getThemeColor()
        return view
    }()
    
    var lastClickBtn = UIButton()   // 上一次点击的按钮
    var assistBadge = 0
    var comDirectorBadge = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "常用联系人"
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.setupChildVc()
        self.setupScrollView()
        self.setupTitleView()
        
        ThreadUtils.delay(0.3) {
            self.setBadge(count: self.assistBadge, index: 0)
            self.setBadge(count: self.comDirectorBadge, index: 1)
        }
    }
    
    /// 添加子控制器
    func setupChildVc() {
        // 百千万
        let leftList = ComDirectorAssistListViewController()
        leftList.parentVc = self
        leftList.type = 0
        self.addChild(leftList)
        
        // 社区
        let rightList = ComDirectorAssistListViewController()
        rightList.parentVc = self
        rightList.type = 1
        self.addChild(rightList)
    }
    
    /// scrollView
    func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.contentSize = CGSize(width: CGFloat(self.children.count) * ScreenWidth, height: 0)
    }
    
    /// 标题栏
    func setupTitleView() {
        self.view.addSubview(self.btnView)
        
        self.setupButton()
        
        self.btnView.addSubview(self.line)
        
        // 默认选中第一个
        self.btnClicked(self.btnView.subviews[0] as! UIButton)
    }
    
    // 设置按钮
    func setupButton() {
        
        let btnArray = ["百千万行动","社区中心"]
        
        let buttonW = ScreenWidth / CGFloat(btnArray.count)
        
        for index in 0..<btnArray.count {
            let button = UIButton(frame: CGRect(x: buttonW * CGFloat(index), y: 0, width: buttonW, height: 43))
            button.setTitle(btnArray[index], for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.setTitleColor(UIUtils.getThemeColor(), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
            button.tag = 800 + index
            self.btnView.addSubview(button)
        }
    }
    
    /// Action
    @objc func btnClicked(_ sender: UIButton) {
        if self.lastClickBtn == sender {
            return
        }
        self.lastClickBtn.isSelected = false
        sender.isSelected = true
        self.lastClickBtn = sender
        
        let tag = sender.tag - 800
        
        UIView.animate(withDuration: 0.25, animations: {
            self.line.center.x = sender.center.x
            self.scrollView.contentOffset = CGPoint(x: CGFloat(tag) * ScreenWidth, y: self.scrollView.contentOffset.y)
        }) { (finished) in
            let childView = self.children[tag].view
            childView?.frame = CGRect(x: CGFloat(tag) * ScreenWidth, y: 0, width: ScreenWidth, height: self.scrollView.frame.height)
            YYLog(childView)
            //childView?.backgroundColor = RandomColor
            self.scrollView.addSubview(childView!)
        }
        
        // 当点击状态栏的时候，把当前显示的tableView滑动到顶部，只要设置scrollView的scrollsToTop为yes即可，但前提是只有一个scrollView设置为yes，其他都设置为no
        for index in 0..<self.children.count {
            let childVc = self.children[index]
            // 如果控制器的view还没加载，则不需要处理
            if !childVc.isViewLoaded {
                continue
            }
            
            let mainView = childVc.view
            for subView in mainView!.subviews {
                if !subView.isKind(of: UIScrollView.self) {
                    continue
                }
                let scrollV = subView as! UIScrollView
                scrollV.scrollsToTop = (index == tag)
            }
        }
    }
    
    func setBadge(count:Int, index:Int){
        if let button = self.btnView.viewWithTag(800 + index){
            var offset = 40
            let size = CGSize(width: -offset, height: 15)
            if count > 0{
                button.setBadge(badgeValue: "\(count)", offset: size)
            }
            else{
                button.setBadge(badgeValue: nil, offset: size)
            }
        }
    }
}

extension TabListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = self.scrollView.contentOffset.x / ScreenWidth
        self.btnClicked(self.btnView.subviews[Int(index)] as! UIButton)
    }
}


