//
//  PIChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/4/22.
//

import BSCommon
import SwiftEventBus

class PIChatListViewController: BaseChatListViewController{
    let researchPlanCell = ChatListCell()
    let assistCell = ChatListCell()
    let assistListVc = AssistChatListViewController()
    
    override func initData() {
        
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                var unreadCount = 0
                var latestTime = TimeInterval(exactly: 0)
                var latestTimeStr = ""
                var latestMsg = NSAttributedString(string: "暂无未读消息")
                let assistIds = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
                for item:NIMRecentSession in convs{     //只显示用户
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    if dict.intValue(key: "businessRoleId") == 5 && dict.intValue(key: "isDeleted") != 1{   //只显示成员员工
                        self.recentSessions.add(item)
                    }
                    else if assistIds.contains(where: { $0 == item.session!.sessionId }){
                        self.assistCell.messageLabel.attributedText = self.content(for: item)
                        //self.assistCell.nameLabel.text = self.name(for: item)
                        //self.assistCell.avatarImageView.setAvatarBy(item.session)
                        unreadCount = unreadCount + item.unreadCount
                        if latestTime == 0{
                            latestTime = item.lastMessage?.timestamp
                            latestTimeStr = self.timestampDescription(for: item)
                            latestMsg = self.content(for: item)
                        }
                        else if latestTime < item.lastMessage?.timestamp{
                            latestTime = item.lastMessage?.timestamp
                            latestTimeStr = self.timestampDescription(for: item)
                            latestMsg = self.content(for: item)
                        }
                    }
                } //end of for
                self.assistCell.messageLabel.attributedText = latestMsg
                if latestTimeStr.hasPrefix("1970"){
                    self.assistCell.timeLabel.text = ""
                }
                else{
                    self.assistCell.timeLabel.text = latestTimeStr
                }
                if unreadCount > 0{
                    self.assistCell.badgeView.isHidden = false
                    self.assistCell.badgeView.badgeValue = unreadCount.getBadge()
                }
                else{
                    self.assistCell.badgeView.isHidden = true
                }
            }
        }
        self.tableView?.reloadData()
        MainManager.getInstance().updateHomeBadge()
    }
    
    override func onSelectedRecent(_ recent: NIMRecentSession!, at indexPath: IndexPath!) {
//        SessionManager.getInstance().openSession(recent.session!)
        if let vc = ChatViewController(session: recent.session!){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func getHeaderView() -> UIView{
        let cellHeight:CGFloat = 60
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cellHeight*2)
        let view = UIView()
        view.frame = rect
        view.backgroundColor = UIColor.white
        
        researchPlanCell.frame = CGRect(x: 0, y: 0, width: rect.width, height: cellHeight)
        researchPlanCell.avatarImageView.image = ImageCenter.bundleImage("chat_complete_data", with: self.classForCoder)
        researchPlanCell.avatarImageView.backgroundColor = UIUtils.getThemeColor()
        researchPlanCell.nameLabel.text = "随访方案核查"
        researchPlanCell.messageLabel.text = "暂无未完成任务"
        researchPlanCell.timeLabel.text = ""
        researchPlanCell.badgeView.isHidden = true
        view.addSubview(researchPlanCell)
        researchPlanCell.addLine()
        
        assistCell.frame = CGRect(x: 0, y: cellHeight, width: rect.width, height: cellHeight)
        assistCell.nameLabel.text = "常用联系人"
        assistCell.messageLabel.text = "暂无未完成任务"
        assistCell.timeLabel.text = ""
        assistCell.avatarImageView.image = ImageCenter.bundleImage("assistant", with: self.classForCoder)
        assistCell.avatarImageView.backgroundColor = UIUtils.getDarkGreenColor()
        assistCell.badgeView.isHidden = true
        view.addSubview(assistCell)
        assistCell.addLine()
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(goCheckPlan))
        gesture1.numberOfTapsRequired = 1
        researchPlanCell.isUserInteractionEnabled = true
        researchPlanCell.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(goAssist))
        gesture2.numberOfTapsRequired = 1
        assistCell.isUserInteractionEnabled = true
        assistCell.addGestureRecognizer(gesture2)
        
        return view
    }
    
    @objc func goCheckPlan(){
        SwiftEventBus.post(Event.Message.researchPlan.rawValue)
    }
    
    @objc func goAssist(){
        self.navigationController?.pushViewController(assistListVc, animated: true)
    }
    
    func updateResearchPlanBadge(_ badge:Int, time:String) {
        let cell = self.researchPlanCell
        cell.badgeView.badgeValue = badge.getBadge()
        if badge > 0 {
            cell.badgeView.isHidden = false
            cell.messageLabel.text = "\(badge)个未完成任务"
            cell.timeLabel.text = time
        }
        else {
            cell.messageLabel.text = "暂无未完成任务"
            cell.badgeView.badgeValue = ""
            cell.badgeView.isHidden = true
        }
    }
    
}
