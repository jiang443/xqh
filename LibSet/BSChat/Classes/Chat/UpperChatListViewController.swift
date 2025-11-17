//
//  UpperChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/5/12.
//

import BSCommon

class UpperChatListViewController: AssistChatListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "上级员工"
        self.setNavTheme()
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                var unreadCount = 0
                var latestTime = ""
                let ids = SettingUserDefault.getUpperAccIds().components(separatedBy: ",")
                for item:NIMRecentSession in convs{     //只显示上级
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    //只取员工的会话
                    if dict.intValue(key: "userType") == 1 && dict.intValue(key: "isDeleted") != 1{
                        //是否在助手列表中
                        if ids.contains(where: { $0 == item.session!.sessionId }){
                            self.recentSessions.add(item)
                        }
                    }
                } //end of for
            }
        }
        self.tableView?.reloadData()
    }

}
