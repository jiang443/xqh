//
//  ComNurseChatListViewController.swift
//  Alamofire
//
//  Created by jiang on 2019/8/27.
//

import BSCommon
import SwiftEventBus

class ComNurseChatListViewController: BaseChatListViewController{
    let completeDataCell = ChatListCell()
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
                    if dict.intValue(key: "userType") == 2 && dict.intValue(key: "isDeleted") != 1{   //用户
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
        //SessionManager.getInstance().openSession(recent.session!)
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
        
        completeDataCell.frame = CGRect(x: 0, y: 0, width: rect.width, height: cellHeight)
        completeDataCell.avatarImageView.image = ImageCenter.bundleImage("chat_complete_data", with: self.classForCoder)
        completeDataCell.avatarImageView.backgroundColor = UIUtils.getThemeColor()
        completeDataCell.nameLabel.text = "完善资料任务"
        completeDataCell.messageLabel.text = "暂无未完成任务"
        completeDataCell.timeLabel.text = ""
        completeDataCell.badgeView.isHidden = true
        view.addSubview(completeDataCell)
        completeDataCell.addLine()
        
        assistCell.frame = CGRect(x: 0, y: cellHeight, width: rect.width, height: cellHeight)
        assistCell.nameLabel.text = "常用联系人"
        assistCell.messageLabel.text = "暂无未完成任务"
        assistCell.timeLabel.text = ""
        assistCell.avatarImageView.image = ImageCenter.bundleImage("assistant", with: self.classForCoder)
        assistCell.avatarImageView.backgroundColor = UIUtils.getDarkGreenColor()
        assistCell.badgeView.isHidden = true
        view.addSubview(assistCell)
        
        let lineView3 = UIView()
        lineView3.frame = CGRect(x: 15, y: assistCell.frame.height-1, width: rect.width-15, height: 0.5)
        lineView3.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        assistCell.addSubview(lineView3)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(goCompleteData))
        gesture1.numberOfTapsRequired = 1
        completeDataCell.isUserInteractionEnabled = true
        completeDataCell.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(goAssist))
        gesture2.numberOfTapsRequired = 1
        assistCell.isUserInteractionEnabled = true
        assistCell.addGestureRecognizer(gesture2)
        
        return view
    }
    
    @objc func goCompleteData(){
        SwiftEventBus.post(Event.Message.completeData.rawValue)
    }
    
    @objc func goAssist(){
        self.navigationController?.pushViewController(assistListVc, animated: true)
    }
    
    func updateCompleteDataBadge(_ badge:Int, time:String) {
        let cell = self.completeDataCell
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
