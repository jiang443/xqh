//
//  CommonCollectionViewCell.swift
//  BSMDoctor
//
//  Created by jiang on 2018/12/20.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import BSCommon

public class CommonCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
    override func layout(){
        super.layout()
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(infoLabel)
        
        UIUtils.setLabel(titleLabel)
        UIUtils.setLabel(infoLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: StringUtils.FONT_MIDDLE)
        infoLabel.textColor = UIColor.lightGray
        titleLabel.text = ""
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        infoLabel.text = ""
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        
        
        titleLabel.snp.makeConstraints {[unowned self] (make) in
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
            make.centerX.equalTo(self.mainView)
            make.bottom.equalTo(mainView.snp.centerY)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(20)
            make.centerX.equalTo(mainView)
            make.top.equalTo(mainView.snp.centerY)
        }
    }
    
    
}
