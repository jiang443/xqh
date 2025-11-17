//
//  ComDirectorAssistListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/9/22.
//

import BSCommon

class ComDirectorAssistListViewController: AssistChatListViewController {
    
    var type = 0    //0:百千万  1：社区
    
    weak var parentVc:TabListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = ""
        self.setNavTheme()
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                let ids = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
                let comIds = SettingUserDefault.getComContactIds().components(separatedBy: ",")
                var badgeCount = 0
                for item:NIMRecentSession in convs{     //只显示联络官
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    //只取员工的会话
                    if dict.intValue(key: "userType") == 1 && dict.intValue(key: "isDeleted") != 1{
                        //是否在助手列表中
                        if self.type == 0 && ids.contains(where: { $0 == item.session!.sessionId }){
                            self.recentSessions.add(item)
                            badgeCount = badgeCount + item.unreadCount
                        }
                        else if self.type == 1 && comIds.contains(dict.stringValue(key: "userId")){
                            self.recentSessions.add(item)
                            badgeCount = badgeCount + item.unreadCount
                        }
                    }
                } //end of for
                self.parentVc?.setBadge(count: badgeCount, index:self.type)
            }
        }
        self.tableView?.reloadData()
    }
    
}
