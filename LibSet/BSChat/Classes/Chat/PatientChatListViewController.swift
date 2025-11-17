//
//  PatientChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/9/19.
//

import BSCommon

class PatientChatListViewController: AssistChatListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户会话"
        self.setNavTheme()
        self.canBeDeleted = true
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                var unreadCount = 0
                var latestTime = ""
                for item:NIMRecentSession in convs{     //只显示上级
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    //只取用户的会话
                    if dict.intValue(key: "userType") == 2 && dict.intValue(key: "isDeleted") != 1{
                        self.recentSessions.add(item)
                    }
                } //end of for
            }
        }
        self.tableView?.reloadData()
    }
    
}
