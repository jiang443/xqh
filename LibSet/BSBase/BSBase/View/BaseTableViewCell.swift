//
//  BaseTableViewCell.swift
//  XQH
//
//  Created by jiang on 2019/6/2.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import UIKit
import SnapKit

public class BaseTableViewCell: UITableViewCell {
    var mainView = UIView()

    //代码创建
    override public init(style:UITableViewCell.CellStyle,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    /**
     在Xib中创建，被实例化时调用
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     在Xib中创建，当.nib文件被加载时调用
     */
    public override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    public func layout(){
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        mainView.backgroundColor = UIColor.clear
        mainView.removeFromSuperview()
        self.contentView.addSubview(mainView)
        
        mainView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }

}
