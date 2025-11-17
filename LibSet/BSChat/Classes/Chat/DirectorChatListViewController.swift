//
//  DirectorChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/4/22.
//

import BSCommon
import SwiftEventBus

class DirectorChatListViewController: BaseChatListViewController{
    let researchPlanCell = ChatListCell()
    let assistCell = ChatListCell()
    //let assistListVc = AssistChatListViewController()
    let patientListVc = PatientChatListViewController()
    let patientCell = ChatListCell()    //用户会话
    let unusualCell = ChatListCell()    //异常用户任务
    let tabListVc = TabListViewController()
    var assistBadge = 0
    var comDirectorBadge = 0
    
    override func initData() {
        
    }
    
    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                var assistItem = LatestItem()
                var patientItem = LatestItem()
                
                self.comDirectorBadge = 0
                self.assistBadge = 0
                let assistIds = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
                let comIds = SettingUserDefault.getComContactIds().components(separatedBy: ",")
                for item:NIMRecentSession in convs{
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    if dict.intValue(key: "businessRoleId") == 5 && dict.intValue(key: "isDeleted") != 1{   //只显示成员员工
                        self.recentSessions.add(item)
                    }
                    else if assistIds.contains(where: { $0 == item.session!.sessionId }) || comIds.contains(dict.stringValue(key: "userId")){
                        //self.assistCell.nameLabel.text = self.name(for: item)
                        //self.assistCell.avatarImageView.setAvatarBy(item.session)
                        assistItem.unreadCount = assistItem.unreadCount + item.unreadCount
                        if comIds.contains(dict.stringValue(key: "userId")){
                            comDirectorBadge = comDirectorBadge + item.unreadCount
                        }
                        else{
                            assistBadge = assistBadge + item.unreadCount
                        }
                        if assistItem.latestTime == 0{
                            assistItem.latestTime = item.lastMessage?.timestamp
                            assistItem.latestTimeStr = self.timestampDescription(for: item)
                            assistItem.latestMsg = self.content(for: item)
                        }
                        else if assistItem.latestTime < item.lastMessage?.timestamp{
                            assistItem.latestTime = item.lastMessage?.timestamp
                            assistItem.latestTimeStr = self.timestampDescription(for: item)
                            assistItem.latestMsg = self.content(for: item)
                        }
                    }
                    else if dict.intValue(key: "userType") == 2{
                        patientItem.unreadCount = patientItem.unreadCount + item.unreadCount
                        if patientItem.latestTime == 0{
                            patientItem.latestTime = item.lastMessage?.timestamp
                            patientItem.latestTimeStr = self.timestampDescription(for: item)
                            patientItem.latestMsg = self.content(for: item)
                        }
                        else if patientItem.latestTime < item.lastMessage?.timestamp{
                            patientItem.latestTime = item.lastMessage?.timestamp
                            patientItem.latestTimeStr = self.timestampDescription(for: item)
                            patientItem.latestMsg = self.content(for: item)
                        }
                    }
                } //end of for
                self.assistCell.messageLabel.attributedText = assistItem.latestMsg
                if assistItem.latestTimeStr.hasPrefix("1970"){
                    self.assistCell.timeLabel.text = ""
                }
                else{
                    self.assistCell.timeLabel.text = assistItem.latestTimeStr
                }
                if assistItem.unreadCount > 0{
                    self.assistCell.badgeView.isHidden = false
                    self.assistCell.badgeView.badgeValue = assistItem.unreadCount.getBadge()
                }
                else{
                    self.assistCell.badgeView.isHidden = true
                }
                //---------------------
                self.patientCell.messageLabel.attributedText = patientItem.latestMsg
                if patientItem.latestTimeStr.hasPrefix("1970"){
                    self.patientCell.timeLabel.text = ""
                }
                else{
                    self.patientCell.timeLabel.text = patientItem.latestTimeStr
                }
                if patientItem.unreadCount > 0{
                    self.patientCell.badgeView.isHidden = false
                    self.patientCell.badgeView.badgeValue = patientItem.unreadCount.getBadge()
                }
                else{
                    self.patientCell.badgeView.isHidden = true
                }
            }
        }
        self.tableView?.reloadData()
        MainManager.getInstance().updateHomeBadge()
    }
    
    override func onSelectedRecent(_ recent: NIMRecentSession!, at indexPath: IndexPath!) {
        //SessionManager.getInstance().openSession(recent.session!)
        if let vc = ChatViewController(session: recent.session!){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func getHeaderView() -> UIView{
        let cellHeight:CGFloat = 60
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cellHeight*4)
        let view = UIView()
        view.frame = rect
        view.backgroundColor = UIColor.white
        
        researchPlanCell.frame = CGRect(x: 0, y: 0, width: rect.width, height: cellHeight)
        researchPlanCell.avatarImageView.image = ImageCenter.bundleImage("head_plan_check", with: self.classForCoder)
        researchPlanCell.avatarImageView.backgroundColor = UIUtils.getThemeColor()
        researchPlanCell.nameLabel.text = "随访方案终审"
        researchPlanCell.messageLabel.text = "暂无未完成任务"
        researchPlanCell.timeLabel.text = ""
        researchPlanCell.badgeView.isHidden = true
        view.addSubview(researchPlanCell)
        researchPlanCell.addLine()
        
        patientCell.frame = CGRect(x: 0, y: cellHeight, width: rect.width, height: cellHeight)
        patientCell.nameLabel.text = "用户会话"
        patientCell.messageLabel.text = "暂无未读消息"
        patientCell.timeLabel.text = ""
        patientCell.avatarImageView.image = ImageCenter.bundleImage("head_patient_convs", with: self.classForCoder)
        patientCell.avatarImageView.backgroundColor = UIUtils.getDarkGreenColor()
        patientCell.badgeView.isHidden = true
        view.addSubview(patientCell)
        patientCell.addLine()
        
        assistCell.frame = CGRect(x: 0, y: cellHeight*2, width: rect.width, height: cellHeight)
        assistCell.nameLabel.text = "常用联系人"
        assistCell.messageLabel.text = "暂无未完成任务"
        assistCell.timeLabel.text = ""
        assistCell.avatarImageView.image = ImageCenter.bundleImage("assistant", with: self.classForCoder)
        assistCell.avatarImageView.backgroundColor = UIUtils.getDarkGreenColor()
        assistCell.badgeView.isHidden = true
        view.addSubview(assistCell)
        assistCell.addLine()
        
        unusualCell.frame = CGRect(x: 0, y: cellHeight*3, width: rect.width, height: cellHeight)
        unusualCell.nameLabel.text = "异常用户指导任务"
        unusualCell.messageLabel.text = "暂无未完成任务"
        unusualCell.timeLabel.text = ""
        unusualCell.avatarImageView.image = ImageCenter.bundleImage("head_alert", with: self.classForCoder)
        unusualCell.avatarImageView.backgroundColor = UIUtils.getDarkGreenColor()
        unusualCell.badgeView.isHidden = true
        view.addSubview(unusualCell)
        unusualCell.addLine()
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(goCheckPlan))
        gesture1.numberOfTapsRequired = 1
        researchPlanCell.isUserInteractionEnabled = true
        researchPlanCell.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(goAssist))
        gesture2.numberOfTapsRequired = 1
        assistCell.isUserInteractionEnabled = true
        assistCell.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(goPatientConvs))
        gesture3.numberOfTapsRequired = 1
        patientCell.isUserInteractionEnabled = true
        patientCell.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(goUnusualTasks))
        gesture4.numberOfTapsRequired = 1
        unusualCell.isUserInteractionEnabled = true
        unusualCell.addGestureRecognizer(gesture4)
        
        return view
    }
    
    @objc func goCheckPlan(){
        SwiftEventBus.post(Event.Message.researchPlan.rawValue)
    }
    
    @objc func goAssist(){
        self.tabListVc.assistBadge = self.assistBadge
        self.tabListVc.comDirectorBadge = self.comDirectorBadge
        self.navigationController?.pushViewController(tabListVc, animated: true)
    }
    
    @objc func goPatientConvs(){
        self.navigationController?.pushViewController(patientListVc, animated: true)
    }
    
    @objc func goUnusualTasks(){
        SwiftEventBus.post(Event.Message.unusual.rawValue)
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
    
    func updateUnusualTaskBadge(_ badge:Int, time:String) {
        let cell = self.unusualCell
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
