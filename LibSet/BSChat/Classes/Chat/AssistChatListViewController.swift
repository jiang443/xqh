//
//版权所属：jiang
//文件名称：AssistChatListViewController.swift
//代码描述：***
//编程记录：
//[创建][2018/5/21][jiang]:新增文件

import UIKit
import BSCommon

class AssistChatListViewController : BaseChatListViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.canBeDeleted = false
        if UserInfoManager.shareManager().getType() == .doctor{
            self.title = "我的助理"
        }
        else{
            self.title = "常用联系人"
        }
        self.setNavTheme()
    }
    
    override func initData(){
//        if self.viewModel.assistList.count == 0{
//            ChatMainManager.getInstance().createAssistConvs()
//        }
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                let ids = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
                for item:NIMRecentSession in convs{     //只显示联络官
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let thisCell = cell as? NIMSessionListCell{
            if (self.recentSessions[indexPath.row] as! NIMRecentSession).lastMessage?.timestamp < 1000{
                thisCell.timeLabel.text = ""
            }
            return thisCell
        }
        return cell
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
    
    

}

