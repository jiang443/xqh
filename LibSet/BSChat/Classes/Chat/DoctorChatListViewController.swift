//
//  ChatViewController.swift
//  XQH
//
//  Created by jiang on 2019/4/28.
//  Copyright © 2020年 tmpName. All rights reserved.
//


import SwiftEventBus
import Moya
import BSCommon


class DoctorChatListViewController:  BaseChatListViewController{
    
    let alarmCell = ChatListCell()
//    let systemMessageCell = ChatListCell()
    let assistCell = ChatListCell()
    let taskCenterCell = ChatListCell()
    let upperCell = ChatListCell()
    let assistListVc = AssistChatListViewController()
    let upperListVc = UpperChatListViewController()
    var isLoad = false
    var headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoad = true
        SwiftEventBus.post(Event.System.refresUserInfo.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoad{
            self.viewModel.upperList(callBack: { list in
                SettingUserDefault.setHasUpperDoctor(list.count > 0)
                self.refreshHeader()
            }, failureCallBack: { msg, code in
                YYHUD.showToast(msg)
            })
        }
    }
    
    override func refreshHeader(){
        self.tableView.modifyHeaderView( animated:false, configBlock:{ headerView in
            if SettingUserDefault.getUpperAccIds().isEmpty{
                headerView?.frame.size.height = 180
                self.upperCell.isHidden = true
            }
            else{
                headerView?.frame.size.height = 240
                self.upperCell.isHidden = false
            }
        })
    }

    override func refresh() {
        if let convs = NIMSDK.shared().conversationManager.allRecentSessions(){
            if self.recentSessions != nil{
                self.recentSessions.removeAllObjects()
                var assistItem = LatestItem()
                var upperItem = LatestItem()
                let assistIds = SettingUserDefault.getAssistAccIds().components(separatedBy: ",")
                let upperIds = SettingUserDefault.getUpperAccIds().components(separatedBy: ",")
                for item:NIMRecentSession in convs{     //只显示用户
                    let dict = IMMainManager.getInstance().getUserCard(accId: item.session!.sessionId)
                    if dict.intValue(key: "userType") == 2 && dict.intValue(key: "isDeleted") != 1{   //用户
                         self.recentSessions.add(item)
                    }
                    else if assistIds.contains(where: { $0 == item.session!.sessionId }){
                        //self.assistCell.nameLabel.text = self.name(for: item)
                        //self.assistCell.avatarImageView.setAvatarBy(item.session)
                        assistItem.unreadCount = assistItem.unreadCount + item.unreadCount
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
                    else if upperIds.contains(where: { $0 == item.session!.sessionId }){
                        upperItem.unreadCount = upperItem.unreadCount + item.unreadCount
                        if upperItem.latestTime == 0{
                            upperItem.latestTime = item.lastMessage?.timestamp
                            upperItem.latestTimeStr = self.timestampDescription(for: item)
                            upperItem.latestMsg = self.content(for: item)
                        }
                        else if upperItem.latestTime < item.lastMessage?.timestamp{
                            upperItem.latestTime = item.lastMessage?.timestamp
                            upperItem.latestTimeStr = self.timestampDescription(for: item)
                            upperItem.latestMsg = self.content(for: item)
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
                self.upperCell.messageLabel.attributedText = upperItem.latestMsg
                if upperItem.latestTimeStr.hasPrefix("1970"){
                    self.upperCell.timeLabel.text = ""
                }
                else{
                    self.upperCell.timeLabel.text = upperItem.latestTimeStr
                }
                if upperItem.unreadCount > 0{
                    self.upperCell.badgeView.isHidden = false
                    self.upperCell.badgeView.badgeValue = upperItem.unreadCount.getBadge()
                }
                else{
                    self.upperCell.badgeView.isHidden = true
                }
                self.tableView?.reloadData()
                MainManager.getInstance().updateHomeBadge()
            }
        }
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
        
//        SessionManager.getInstance().openSession(recent.session!)
        if let vc = ChatViewController(session: recent.session!){
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    override func getHeaderView() -> UIView{
        let cellHeight:CGFloat = 60
        var rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cellHeight*3)
        if !SettingUserDefault.getUpperAccIds().isEmpty{
            rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: cellHeight*4)
        }
        let view = self.headerView
        view.frame = rect
        view.backgroundColor = UIColor.white
        
        alarmCell.frame = CGRect(x: 0, y: 0, width: rect.width, height: cellHeight)
        alarmCell.avatarImageView.image = ImageCenter.bundleImage("alert", with: self.classForCoder)
        alarmCell.avatarImageView.backgroundColor = UIColor.orange
        alarmCell.nameLabel.text = "报警"
        alarmCell.messageLabel.text = "暂无未完成任务"
        alarmCell.timeLabel.text = ""
        alarmCell.badgeView.isHidden = true
        view.addSubview(alarmCell)
        alarmCell.addLine()
        
        taskCenterCell.frame = CGRect(x: 0, y: cellHeight, width: rect.width, height: cellHeight)
        taskCenterCell.avatarImageView.image = ImageCenter.bundleImage("task_center", with: self.classForCoder)
        taskCenterCell.avatarImageView.backgroundColor = UIColor.color(hex: "#4DBCC3")
        taskCenterCell.nameLabel.text = "任务中心"
        taskCenterCell.messageLabel.text = "查看任务"
        taskCenterCell.timeLabel.text = ""
        taskCenterCell.badgeView.isHidden = true
        view.addSubview(taskCenterCell)
        taskCenterCell.addLine()
        
//        systemMessageCell.frame = CGRect(x: 0, y: cellHeight*2, width: rect.width, height: cellHeight)
//        systemMessageCell.nameLabel.text = "系统消息"
//        systemMessageCell.messageLabel.text = "暂无未完成任务"
//        systemMessageCell.timeLabel.text = ""
//        systemMessageCell.avatarImageView.image = ImageCenter.bundleImage("system", with: self.classForCoder)
//        systemMessageCell.avatarImageView.backgroundColor = UIUtils.getLightBlueColor()
//        systemMessageCell.badgeView.isHidden = true
//        view.addSubview(systemMessageCell)
//        systemMessageCell.addLine()
        
        assistCell.frame = CGRect(x: 0, y: cellHeight*2, width: rect.width, height: cellHeight)
        assistCell.nameLabel.text = "我的助理"
        assistCell.messageLabel.text = "暂无未完成任务"
        assistCell.timeLabel.text = ""
        assistCell.avatarImageView.image = ImageCenter.bundleImage("assistant", with: self.classForCoder)
        assistCell.avatarImageView.backgroundColor = UIUtils.getGreenColor()
        assistCell.badgeView.isHidden = true
        view.addSubview(assistCell)
        assistCell.addLine()
        
        upperCell.frame = CGRect(x: 0, y: cellHeight*3, width: rect.width, height: cellHeight)
        upperCell.nameLabel.text = "上级员工"
        upperCell.messageLabel.text = "暂无未完成任务"
        upperCell.timeLabel.text = ""
        upperCell.avatarImageView.image = UIImage(named:"icon_用户动态")
        upperCell.avatarImageView.backgroundColor = UIUtils.getGreenColor()
        upperCell.badgeView.isHidden = true
        upperCell.isHidden = false
        view.addSubview(upperCell)
        upperCell.addLine()
        if SettingUserDefault.getUpperAccIds().isEmpty{
            upperCell.isHidden = true
        }
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.goAlarm))
        gesture1.numberOfTapsRequired = 1
        alarmCell.isUserInteractionEnabled = true
        alarmCell.addGestureRecognizer(gesture1)
        
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.goSystemMessage))
//        gesture2.numberOfTapsRequired = 1
//        systemMessageCell.isUserInteractionEnabled = true
//        systemMessageCell.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.goAssist))
        gesture3.numberOfTapsRequired = 1
        assistCell.isUserInteractionEnabled = true
        assistCell.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(self.goTaskCenter))
        gesture4.numberOfTapsRequired = 1
        taskCenterCell.isUserInteractionEnabled = true
        taskCenterCell.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(self.goUpper))
        gesture5.numberOfTapsRequired = 1
        upperCell.isUserInteractionEnabled = true
        upperCell.addGestureRecognizer(gesture5)
        
        return view
    }
    
    @objc func goAlarm(){
        SwiftEventBus.post(Event.Message.bsAlert.rawValue, userInfo: ["key":0])
    }
    
    @objc func goTaskCenter(){
        SwiftEventBus.post(Event.Message.task.rawValue)
    }
    
    @objc func goSystemMessage(){
        SwiftEventBus.post(Event.Message.sysMsg.rawValue, userInfo: ["key":0])
    }
    
    @objc func goAssist(){
        self.navigationController?.pushViewController(assistListVc, animated: true)
    }
    
    @objc func goUpper(){
        self.navigationController?.pushViewController(upperListVc, animated: true)
    }
    
    
//    func updateSystemBadge(_ badge:String, time:String) {
//        let cell = self.systemMessageCell
//        cell.badgeView.badgeValue = badge
//        if (badge == "0") || (badge == "") {
//            cell.messageLabel.text = "暂无未读消息"
//            cell.badgeView.badgeValue = ""
//            cell.badgeView.isHidden = true
//            cell.timeLabel.text = ""
//        }
//        else {
//            cell.badgeView.isHidden = false
//            cell.messageLabel.text = "\(badge)条未读消息"
//            let interval = TimeUtils.getTimeInterval(dataStr: time, format: "yyyy-MM-dd HH:mm:ss")
//            let timeStr = NIMKitUtil.showTime(Double(interval), showDetail: false)
//            cell.timeLabel.text = timeStr
//        }
//    }
    
    //任务数量
    func updateTaskBadge(_ badge:Int, time:String) {
        let cell = self.taskCenterCell
        cell.badgeView.badgeValue = badge.getBadge()
        if badge > 0 {
            cell.badgeView.isHidden = false
            cell.messageLabel.text = "\(badge)个未完成任务"
            let interval = TimeUtils.getTimeInterval(dataStr: time, format: "yyyy-MM-dd HH:mm:ss")
            let timeStr = NIMKitUtil.showTime(Double(interval), showDetail: false)
            cell.timeLabel.text = timeStr
        }
        else {
            cell.messageLabel.text = "暂无未完成任务"
            cell.badgeView.badgeValue = ""
            cell.badgeView.isHidden = true
            cell.timeLabel.text = ""
        }
    }
    
    func updateAlarmBadge(_ badge: Int, time: String) {
        let cell = self.alarmCell
        cell.badgeView.badgeValue = badge.getBadge()
        if badge > 0 {
            cell.badgeView.isHidden = false
            cell.messageLabel.text = "\(badge)条未读消息"
            let interval = TimeUtils.getTimeInterval(dataStr: time, format: "yyyy-MM-dd HH:mm:ss")
            let timeStr = NIMKitUtil.showTime(Double(interval), showDetail: false)
            cell.timeLabel.text = timeStr
        }
        else {
            cell.messageLabel.text = "暂无未读消息"
            cell.badgeView.badgeValue = ""
            cell.badgeView.isHidden = true
            cell.timeLabel.text = ""
        }
    }
    
    
    
    

    
    
}
