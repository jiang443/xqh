//
//  ChatListCell.swift
//  XQH
//
//  Created by jiang on 2019/5/2.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import UIKit
import JSBadgeView
import BSCommon

class ChatListCell: NIMSessionListCell {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.timeLabel.textAlignment = .right
        self.avatarImageView.snp.makeConstraints {[unowned self] (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.width.height.equalTo(45)
        }
        
        self.messageLabel.snp.makeConstraints {[unowned self] (make) in
            make.left.height.equalTo(self.nameLabel)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        self.timeLabel.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(avatarImageView)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        self.nameLabel.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(avatarImageView)
            make.left.equalTo(self).offset(70)
            make.right.equalTo(timeLabel.snp.left)
            make.height.equalTo(20)
        }
//        self.badgeView.nim_left         = self.avatarImageView.nim_right - 10;
//        self.badgeView.nim_bottom        = self.avatarImageView.nim_top + 12;
        self.badgeView.nim_right = self.nim_width - 10
        self.badgeView.nim_bottom = self.nim_height - 10
        if NIMKit.shared()?.config.avatarType == .rounded{
            self.avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
            self.avatarImageView.layer.masksToBounds = true
        }
    }
    
}

extension NIMSessionListCell{
    
    override open func layoutSubviews() {
        //self.avatarImageView.cornerRadius = 3
        
        self.nameLabel.sizeToFit()
        self.messageLabel.sizeToFit()
        self.timeLabel.sizeToFit()
        self.timeLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_SMALL)
        
        self.avatarImageView.nim_left    = 15;
        self.avatarImageView.nim_centerY = self.nim_height * 0.5
        self.nameLabel.nim_top           = 10;
        self.nameLabel.nim_left          = self.avatarImageView.nim_right + 15
        self.messageLabel.nim_left       = self.avatarImageView.nim_right + 15
        self.messageLabel.nim_bottom     = self.nim_height - 10
        self.messageLabel.nim_width      = self.nim_width - avatarImageView.frame.maxX - 30
        self.timeLabel.nim_right         = self.nim_width - 15
        self.timeLabel.nim_top           = 10
        self.timeLabel.nim_height        = 20
//        self.badgeView.nim_left         = self.avatarImageView.nim_right - 10;
//        self.badgeView.nim_bottom        = self.avatarImageView.nim_top + 12;
        self.badgeView.nim_right = self.nim_width - 10
        self.badgeView.nim_bottom = self.nim_height - 5
        self.addLine()
    }
}
