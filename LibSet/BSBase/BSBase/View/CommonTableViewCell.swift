//
//  CommonTableViewCell.swift
//  BSMDoctor
//
//  Created by jiang on 2018/12/17.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon

public class CommonTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let textField = UITextField()
  
    override public func layout(){
        super.layout()
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(infoLabel)
        mainView.addSubview(textField)

        UIUtils.setLabel(titleLabel)
        UIUtils.setLabel(infoLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_MIDDLE)
        infoLabel.textColor = UIColor.lightGray
        titleLabel.text = ""
        titleLabel.numberOfLines = 0
        infoLabel.text = ""
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        textField.textColor = UIColor.lightGray
        textField.layer.zPosition = 100
        textField.textAlignment = .right
        textField.isHidden = true
        textField.inputView = nil
        
        titleLabel.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(mainView).offset(5)
            make.bottom.equalTo(mainView).offset(-5)
            make.left.equalTo(self.mainView).offset(10)
            make.height.greaterThanOrEqualTo(20)
            make.width.greaterThanOrEqualTo(80)
            //make.centerY.equalTo(self.mainView)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(5)
            make.bottom.equalTo(mainView).offset(-5)
            make.right.equalTo(mainView).offset(-8)
            make.left.equalTo(titleLabel.snp.right)
            make.height.greaterThanOrEqualTo(20)
            //make.centerY.equalTo(mainView)
        }
        
        textField.snp.makeConstraints { (make) in
            make.right.equalTo(mainView).offset(-8)
            make.left.equalTo(titleLabel.snp.right)
            make.width.greaterThanOrEqualTo(mainView).multipliedBy(0.5)
            make.height.equalTo(20)
            make.centerY.equalTo(mainView)
        }
       
        self.selectionStyle = .none
    }

    
}
