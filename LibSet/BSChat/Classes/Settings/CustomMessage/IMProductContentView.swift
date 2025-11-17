//
//  IMProductContentView.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/14.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit
import BSCommon

class IMProductContentView: NIMSessionMessageContentView {
    
    let headImageView = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let backView = UIView()
    let lineView = UIView()
    let tipLabel = UILabel()
    var attachment = IMProductAttachment()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init!(sessionMessageContentView: ()) {
        super.init(sessionMessageContentView: ())
        self.initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI(){
        self.bubbleImageView.isHidden = true
        self.backView.backgroundColor = UIColor.white
        self.backView.layer.cornerRadius = 3
        self.backView.layer.borderColor = UIColor.lightGray.cgColor
        self.backView.layer.borderWidth = 0.5
        self.backView.layer.masksToBounds = true
        self.backView.isUserInteractionEnabled = false
        self.addSubview(backView)
        
        headImageView.frame = CGRect.zero
        headImageView.clipsToBounds = true
        headImageView.contentMode = .scaleAspectFill
        backView.addSubview(headImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: StringUtils.FONT_NORMAL)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.text = "(产品推荐)"
        titleLabel.sizeToFit()
        backView.addSubview(titleLabel)
        
        infoLabel.frame = CGRect.zero
        infoLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        infoLabel.textColor = UIColor.lightGray
        infoLabel.numberOfLines = 0
        infoLabel.text = ""
        infoLabel.sizeToFit()
        self.addSubview(infoLabel)
        
        lineView.backgroundColor = UIColor.darkGray
        backView.addSubview(lineView)
        
        tipLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        tipLabel.textColor = UIColor.lightGray
        tipLabel.textAlignment = .center
        tipLabel.text = "点击查看详情 >"
        tipLabel.sizeToFit()
        backView.addSubview(tipLabel)
    }
    
    override func refresh(_ model: NIMMessageModel?) {
        super.refresh(model)
        let customObject = model?.message.messageObject as? NIMCustomObject
        if let attachment = customObject?.attachment as? IMProductAttachment{
            self.attachment = attachment
            infoLabel.text = attachment.text
            titleLabel.text = attachment.title
            ImageCenter.display(headImageView, path: attachment.imageUrl)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let contentInsets: UIEdgeInsets = model.contentViewInsets
        backView.snp.makeConstraints {[unowned self] (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        headImageView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.backView).offset(30)
            make.right.equalTo(self.backView).offset(-10)
            make.width.height.equalTo(45)
        }
        titleLabel.snp.makeConstraints {[unowned self] (make) in
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(backView).offset(8)
            make.left.equalTo(self).offset(10)
            make.height.equalTo(20)
        }
        infoLabel.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.equalTo(headImageView.snp.left)
            make.bottom.equalTo(lineView.snp.top)
        }
        
        lineView.snp.makeConstraints {[unowned self] (make) in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(headImageView.snp.right)
            make.bottom.equalTo(self).offset(-26)
            make.height.equalTo(0.5)
        }
        tipLabel.snp.makeConstraints {[unowned self] (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(25)
        }
    }
    
    override func onTouchUpInside(_ sender: Any!) {
        self.goDetail()
    }
    
    func goDetail(){
//        if self.attachment.model.list.count > 0{
//            let detailVc = WebViewController()
//            detailVc.title = "产品详情"
//            detailVc.url = self.attachment.model.list[0].url + "&nowx=1"
//            UIUtils.getCurrentVC().navigationController?.pushViewController(detailVc, animated: true)
//        }
    }
    
}
