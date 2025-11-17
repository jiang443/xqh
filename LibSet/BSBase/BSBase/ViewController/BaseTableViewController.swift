//
//  BaseTableViewController.swift
//  XQH
//
//  Created by jiang on 2019/6/21.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import UIKit
import MJRefresh
import BSCommon
import SnapKit

public class BaseTableViewController: UITableViewController,UIGestureRecognizerDelegate,UIAlertViewDelegate{
    public var isEmbeded = false
    public var isFirstLoad = true
    public var isOnShow = false
    public var pageSize = 50
    public var isBackGestureOn = true
    public var titleLabel = UILabel()
    public var emptyView = UIView()
    public var rightButton = UIButton()
    public var isLoading = false
    public var endFooterView = UIView()
    public var emptyViewOffSet = CGPoint.zero
    public var touchPoint:CGPoint = CGPoint.zero
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)  //白色字体
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationItem.leftBarButtonItem = nil
        self.isOnShow = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.barTintColor = UIColor(white: 0.97, alpha: 1)
        
        initSettings()
        initData()
        initViews()
        initUI()
        initEvent()
    }

    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    fileprivate func initViews(){
        let size = UIScreen.main.bounds
        emptyView.frame = size
        emptyView.isHidden = true
        emptyView.layer.zPosition = 9999
        self.view.addSubview(emptyView)
        
        let defaultImageView = UIImageView()
        defaultImageView.frame = CGRect(x: 0, y: 0,
                                        width: size.width*0.3,
                                        height: size.width*0.54)
        defaultImageView.image = UIImage(named: "icon_empty")
        defaultImageView.center = CGPoint(x: self.view.center.x + emptyViewOffSet.x, y: self.view.center.y - 60 + emptyViewOffSet.y)
        emptyView.addSubview(defaultImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        gesture.numberOfTapsRequired = 1
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(gesture)
        endFooterView = getEndFooterView()
        
        //YYHUD.showStatus("正在加载")
    }
    
    /*
     初始化各种参数
     */
    public func initSettings(){
        
    }
    
    
    /*
     初始化各种界面的
     */
    public func initUI(){
        
    }
    
    /*
     加载页面数据的函数
     */
    public func initData(){
        
    }
    
    /*
     初始化各种事件的函数
     */
    public func initEvent(){
        
    }
    
    public func getUser() -> UserInfoModel{
        return UserInfoManager.shareManager().getUserInfo()
    }
    
    @objc public func refreshData(){
        if self.isLoading{
            return
        }
        self.initData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.viewControllers.count > 1{
            self.tabBarController?.tabBar.isHidden = true
        }
        else{
            self.tabBarController?.tabBar.isHidden = false
        }
        self.edgesForExtendedLayout = .bottom
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: StringUtils.NOTIFICATION_USER_REFRESH), object: nil)
        self.isOnShow = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        YYHUD.dismiss()
        super.viewWillDisappear(animated)
        self.isFirstLoad = false
        self.tabBarController?.tabBar.isHidden = false
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: StringUtils.NOTIFICATION_USER_REFRESH), object: nil)
        
        self.isOnShow = false
    }
    
    
    public func pushStoryboardViewController(_ fileName:String,animated:Bool){
        let storyBoard = UIStoryboard(name: fileName, bundle: nil)
        let viewController: UIViewController = storyBoard.instantiateInitialViewController()! as UIViewController
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func showModalViewController(_ vc: UIViewController, animated: Bool) {
        let nav = UINavigationController(rootViewController: vc)
        if let baseVc = vc as? BaseViewController{
            baseVc.setModalNavTheme()
        }
        self.present(nav, animated: animated, completion: nil)
    }
    
    public func setModalNavTheme(){
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(handleModalBack), for: .touchUpInside)
        backButton.setTitle("取消", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)]
        
        self.navigationController?.navigationBar.barTintColor = UIUtils.getThemeColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        rightButton.setTitle("", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        let rightitem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightitem
    }
    
    public override func handleBack(){
        self.view.endEditing(true)
        if isEmbeded{
            self.parent?.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc public func handleModalBack(){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isBackGestureOn
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    public func enableAutoEditSwitch(_ view:UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        gesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func endEditing(_ sender:UITapGestureRecognizer){
        sender.view!.endEditing(true)
    }
    
    public func getMJHeader() -> MJRefreshNormalHeader{
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header?.setTitle("下拉刷新", for: MJRefreshState.idle)
        header?.setTitle("松开刷新", for: MJRefreshState.pulling)
        header?.setTitle("加载中...", for: MJRefreshState.refreshing)
        header?.stateLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        header?.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_SMALL)
        header?.stateLabel.textColor = UIColor.darkGray
        header?.lastUpdatedTimeLabel.textColor = UIColor.lightGray
        
        return header!
    }
    
    public func getEndFooterView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIUtils.getScreenWidth(), height: 40)
        view.backgroundColor = UIColor.white
        let tipLabel = UILabel()
        UIUtils.setLabel(tipLabel)
        tipLabel.textColor = UIColor.lightGray
        tipLabel.textAlignment = .center
        tipLabel.text = "没有数据了"
        tipLabel.frame = view.frame
        view.addSubview(tipLabel)
        return view
    }
    
    public func addTableViewTouchEnd(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesturedAction(_:)))
        // 需要遵守协议：UIGestureRecognizerDelegate
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
    }
    
    @objc private func tapGesturedAction(_ gesture: UIGestureRecognizer?) {
        tableView.endEditing(true)
    }
    
    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if ("\(touch.view!.classForCoder)" == "UITableViewCellContentView" ) {
//            //如果当前是tableViewCell，忽略手势
//            return false
//        }
//        return true
//    }
//
//
//    // MARK: - Keyboard Notification
//    public func addKeyboardNotify() {
//        //注册观察键盘的变化
//        NotificationCenter.default.addObserver(self, selector: #selector(self.transformView(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
//    }
//    
//    //移动UIView
//    @objc public func transformView(_ aNSNotification: Notification?) {
//        //获取键盘弹出前的Rect
//        var beginRect = CGRect.zero
//        if let keyBoardBeginBounds = aNSNotification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]{
//            beginRect = (keyBoardBeginBounds as AnyObject).cgRectValue
//        }
//        //获取键盘弹出后的Rect
//        var endRect = CGRect.zero
//        if let keyBoardEndBounds = aNSNotification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]{
//            endRect = (keyBoardEndBounds as AnyObject).cgRectValue
//        }
//        //获取键盘位置变化前后纵坐标Y的变化值
//        let deltaY: CGFloat = endRect.origin.y - beginRect.origin.y
//        print("看看这个变化的Y值:\(deltaY)")
//        //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + deltaY, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        })
//    }
    
    
    
}
