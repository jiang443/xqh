//
//  YYBageView.swift
//  BSMDoctor
//
//  Created by jiang on 2018/12/10.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import JSBadgeView

public class YYBageView: UIView {
    
    fileprivate var badgeView = JSBadgeView()
    
    var badgeText:String?{
        didSet{
            if badgeText == nil{
                badgeView.badgeText = ""
                if let view = parentView.viewWithTag(15069){
                    view.removeFromSuperview()
                }
                badgeView.removeFromSuperview()
                self.removeFromSuperview()
                self.isHidden = true
            }
            else if badgeText == ""{
                self.addPoint()
            }
            else{
                addJsBadgeView()
            }
        }
    }
    
    var parentView = UIView(){
        didSet{
            self.addPoint()
        }
    }
    
    ///添加一个红点
    func addPoint(){
        if let view = parentView.viewWithTag(15069){
            view.removeFromSuperview()
        }
        badgeView.removeFromSuperview()
        
        self.isHidden = false
        parentView.addSubview(self)
        //let rect = parentView.frame
        //self.frame = CGRect.init(x: rect.maxX-5, y: -5, width: 10, height: 10)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(parentView.snp.right).offset(-5)
            make.top.equalTo(parentView).offset(-5)
            make.width.height.equalTo(10)
        }
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.red
    }
    
    ///添加一个数字
    func addJsBadgeView(){
        self.isHidden = true
        badgeView.badgeText = ""
        if let view = parentView.viewWithTag(15069){
            view.removeFromSuperview()
        }
        badgeView.removeFromSuperview()
        badgeView = JSBadgeView(parentView: parentView, alignment: .topRight)
        badgeView.tag = 15069
        badgeView.badgeBackgroundColor = UIUtils.getRedColor()
        badgeView.badgeStrokeColor = UIUtils.getRedColor()
        badgeView.badgeText = self.badgeText
    }
}
