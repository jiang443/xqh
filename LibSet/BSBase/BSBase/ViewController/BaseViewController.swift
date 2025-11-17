//
//  ViewController.swift
//  Rent
//
//  Created by jiang on 19/3/10.
//  Copyright © 2019年 tmpName. All rights reserved.

import MJRefresh
import BSCommon

open class BaseViewController: UIViewController{
    open var isEmbeded = false
    open var isFirstLoad = true
    open var isOnShow = false
    open var pageSize = 50
    open var titleLabel = UILabel()
    open var emptyView = UIView()
    open var rightButton = UIButton()
    open var isLoading = false
    open var isRoot = false
    open var hideTitle = false
    open var emptyViewOffSet = CGPoint.zero
    open var touchPoint:CGPoint = CGPoint.zero
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)  //白色字体
        self.view.backgroundColor = UIColor.white
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
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
        YYLog("🔸MemoryWarning")
    }
    
    fileprivate func initViews(){
        let size = UIScreen.main.bounds
        emptyView.frame = size
        emptyView.isHidden = true
        emptyView.layer.zPosition = 999
        self.view.addSubview(emptyView)
        let defaultImageView = UIImageView()
        defaultImageView.tag = 100
        defaultImageView.frame = CGRect(x: 0, y: 0,
                                        width: size.width*0.3,
                                        height: size.width*0.54)
        defaultImageView.image = UIImage(named: "icon_empty")
        defaultImageView.center = CGPoint(x: self.view.center.x + emptyViewOffSet.x, y: self.view.center.y - 160 + emptyViewOffSet.y)
        emptyView.addSubview(defaultImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(refreshData))
        gesture.numberOfTapsRequired = 1
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(gesture)
        //YYHUD.showStatus("正在加载")
    }
    
    /*
     初始化各种参数
     */
    open func initSettings(){
        
    }
    
    /*
    初始化各种界面的
    */
    open func initUI(){
        
    }
    
    /*
    加载页面数据的函数
    */
    open func initData(){
        
    }
    
    /*
    初始化各种事件的函数
    */
    open func initEvent(){
        
    }
    
//    open func getUser() -> UserInfoModel{
//        return UserInfoManager.shareManager().getUserInfo()
//    }
    
    @objc open func refreshData(){
        self.initData()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.viewControllers.count > 1{
            self.tabBarController?.tabBar.isHidden = true
        }
        else{
            self.tabBarController?.tabBar.isHidden = false
        }
        self.edgesForExtendedLayout = .bottom
        //MobClick.beginLogPageView("\(self.classForCoder)")
        self.isOnShow = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isFirstLoad = false
        //MobClick.endLogPageView("\(self.classForCoder)")
        //YYHUD.dismiss()
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: StringUtils.NOTIFICATION_USER_REFRESH), object: nil)
        self.isOnShow = false
    }
    
    
    open func showModalViewController(_ vc: UIViewController, animated: Bool) {
        let nav = UINavigationController(rootViewController: vc)
        if vc.isKind(of: BaseViewController.self){
            (vc as! BaseViewController) .setModalNavTheme()
        }
        else if vc.isKind(of: BaseTableViewController.self){
            (vc as! BaseTableViewController) .setModalNavTheme()
        }
        self.present(nav, animated: animated, completion: nil)
    }
    
    open func pushStoryboardViewController(_ fileName:String,animated:Bool){
        let storyBoard = UIStoryboard(name: fileName, bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController()! as UIViewController
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    open func setModalNavTheme(){
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(handleModalBack), for: .touchUpInside)
        backButton.setTitle("取消", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        //backButton.setBackgroundImage(ImageUtils.getImageHighlighted(), forState: UIControlState.Highlighted)
        
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
    
    open override func handleBack(){
        self.view.endEditing(true)
        if isEmbeded{
            self.parent?.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc open func handleModalBack(){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    open func enableAutoEditSwitch(_ view:UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        gesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    @objc fileprivate func endEditing(_ sender:UITapGestureRecognizer){
        sender.view!.endEditing(true)
    }
    
    open func getMJHeader() -> MJRefreshNormalHeader{
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header?.setTitle("下拉刷新", for: MJRefreshState.idle)
        header?.setTitle("松开刷新", for: MJRefreshState.pulling)
        header?.setTitle("加载中...", for: MJRefreshState.refreshing)
        header?.stateLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        header?.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_SMALL)
        header?.stateLabel.textColor = UIColor.darkGray
        header?.lastUpdatedTimeLabel.textColor = UIColor.lightGray
        header?.backgroundColor = UIUtils.getBackgroundColor()
        header?.lastUpdatedTimeKey = "\(self.classForCoder)"
        
        return header!
    }
    

    // MARK: - Keyboard Notification
//    open func addKeyboardNotify() {
//        //注册观察键盘的变化
//        NotificationCenter.default.addObserver(self, selector: #selector(self.transformView(_:)), name: NSNotification.Name.UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//    
//    //移动UIView
//    @objc open func transformView(_ aNSNotification: Notification?) {
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
//        
//        if touchPoint.y - (UIUtils.getScreenHeight() - endRect.origin.y) - 64 < 0{
//            return
//        }
//        
//        //获取键盘位置变化前后纵坐标Y的变化值
//        let deltaY: CGFloat = endRect.origin.y - beginRect.origin.y
//        if self.view.frame.origin.y + deltaY > 100{
//            return
//        }
//        print("看看这个变化的Y值:\(deltaY)")
//        //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + deltaY, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        })
//    }
    

    
}
