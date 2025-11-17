//
//  BaseChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/4/22.
//

import SwiftEventBus
import Moya
import BSCommon

class BaseChatListViewController: NIMSessionListViewController{
    
    var cellId = "cellId"
    var account = UserInfoModel()
    var user = UserInfoModel()
    var canBeDeleted = true
    
    lazy var viewModel: BSChatViewModel = {
        return BSChatViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.setNavTheme()
        self.navigationItem.leftBarButtonItem = nil
        self.user = UserInfoManager.shareManager().getUserInfo()
        self.addObserver()
        self.initData()
        self.refresh()
        
        if !UserInfoManager.shareManager().isLogin(){
            SwiftEventBus.post(Event.System.logout.rawValue)
            return
        }
        self.tableView.tableHeaderView = getHeaderView()
        //self.hidesBottomBarWhenPushed = true    //TabBar隐藏最快
        
        //self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    func addObserver(){
        SwiftEventBus.onMainThread(self, name: Event.Chat.setStatusTip.rawValue) { (notification) in
            if let dict = notification?.userInfo as? [String:Any]{
                let tips = dict.stringValue(key: "text")
                if self.navigationController?.viewControllers.count == 1{
                    if tips.isEmpty{
                        self.navigationItem.title = "消息"
                    }
                    else{
                        self.navigationItem.title = "消息(\(tips))"
                    }
                }
            }
        }
    }
    
    func initData(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.account = UserInfoManager.shareManager().getUserInfo()
        MainManager.getInstance().getMessageUnreadCount()
        IMMainManager.getInstance().refreshRecentUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //如果在WillAppear中控制，会在前面一个页面WillDisappear前执行，控制无效
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: UIUtils.getScreenHeight() - UIUtils.getTabBarHeight() - UIUtils.getTopHeight())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func getUser() -> UserInfoModel{
        return UserInfoManager.shareManager().getUserInfo()
    }
    
    override func refresh() {
        super.refresh()
    }
    
    override func onSelectedRecent(_ recent: NIMRecentSession!, at indexPath: IndexPath!) {
        var userId = ""
        var userType = 0
        let dict = IMMainManager.getInstance().getUserCard(accId: recent.session!.sessionId)
        if dict.count > 0{
            userId = dict.stringValue(key: "userId")
            userType = dict.intValue(key: "userType")
        }
        if userId.isEmpty{
            return
        }
        //SessionManager.getInstance().openSession(recent.session!)
        if let vc = ChatViewController(session: recent.session!){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NIMSessionListCell
        cell.badgeView.badgeValue = cell.badgeView.badgeValue?.intValue().getBadge()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "删除", handler: {[unowned self] action, indexPath in
            if let recentSession = self.recentSessions[indexPath.row] as? NIMRecentSession{
                NIMSDK.shared().conversationManager.delete(recentSession)
            }
            tableView.setEditing(false, animated: true)
        })
        
        return [delete]
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, sourceView, completionHandler) in
            if let recentSession = self.recentSessions[indexPath.row] as? NIMRecentSession{
                NIMSDK.shared().conversationManager.delete(recentSession)
            }
            tableView.setEditing(false, animated: true)
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    override func content(for recent: NIMRecentSession!) -> NSAttributedString! {
        var text = ""
        if recent.lastMessage?.messageType == NIMMessageType.custom{
            if let object = recent.lastMessage?.messageObject as? NIMCustomObject{
                if (object.attachment as? IMDocumentAttachment) != nil{
                    text = "[链接]"
                }
                else if (object.attachment as? IMNutritionAttachment) != nil{
                    text = "[员工建议]"
                }
                else if (object.attachment as? IMProductAttachment) != nil{
                    text = "[产品推荐]"
                }
            }
            return NSMutableAttributedString(string: text)
        }
        return super.content(for: recent)
    }
    
    func getHeaderView() -> UIView{
        return UIView()
    }
    
    ///更新HeaderView
    func refreshHeader(){
        ///
    }
    
    override func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        //清理本地数据
        let index = self.recentSessions.index(of: recentSession)
        if recentSessions.count > index {
            recentSessions.remove(index)
            //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
            if self.autoRemoveRemoteSession && recentSession.session != nil{
                NIMSDK.shared().conversationManager.deleteRemoteSessions([recentSession.session!], completion: nil)
            }
            self.recentSessions = customSortRecents(recentSessions)
            self.refresh()
        } else {
            print("💥💥会话列表：数组越界，已做拦截处理")
        }

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canBeDeleted
    }

    struct LatestItem {
        var unreadCount = 0
        var latestTime = TimeInterval(exactly: 0)
        var latestTimeStr = ""
        var latestMsg = NSAttributedString(string: "暂无未读消息")
    }
    
}
