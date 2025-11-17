//
//  IMDocumentContentView.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/11.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import UIKit
import BSCommon
import SwiftEventBus
//import M80AttributedLabel

class IMDocumentContentView: NIMSessionMessageContentView {

    let backView = UIView()
    let titleLabel = UILabel()
    var bean = DocumentBean()
    
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
        
        titleLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        titleLabel.textColor = UIUtils.getLightBlueColor()
        titleLabel.numberOfLines = 0
        
        backView.addSubview(titleLabel)
    }
    
    override func refresh(_ model: NIMMessageModel?) {
        super.refresh(model)
        let customObject = model?.message.messageObject as? NIMCustomObject
        if let attachment = customObject?.attachment as? IMDocumentAttachment{
            let attribtDic = [
                NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
                NSAttributedString.Key.baselineOffset : NSNumber(0)]
            var attribtStr = NSMutableAttributedString(string: attachment.title, attributes: attribtDic)
            
            titleLabel.attributedText = attribtStr
            //ImageUtils.display(headImageView, path: attachment.imageUrl)
            self.bean = attachment.bean
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let contentInsets: UIEdgeInsets = model.contentViewInsets
        backView.snp.makeConstraints {[unowned self] (make) in
            make.top.bottom.left.right.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints {[unowned self] (make) in
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(backView).offset(5)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-5)
        }
       
    }
    
    override func onTouchUpInside(_ sender: Any!) {
        self.goDetail()
    }
    
    func goDetail(){
        SwiftEventBus.post(BSCommon.Event.System.openUrl.rawValue, userInfo: ["title":self.bean.title, "url": self.bean.link])
//        let webView = WebViewController()
//        webView.title = self.bean.title
//        webView.url = self.bean.link
//        UIUtils.getCurrentVC()?.navigationController?.pushViewController(webView, animated: true)
    }
    
}

