//
//  BaseCollectionViewCell.swift
//  BSMDoctor
//
//  Created by jiang on 2018/12/20.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit
import SnapKit

public class BaseCollectionViewCell: UICollectionViewCell {

    var mainView = UIView()
    
    //代码创建
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    /**
     在Xib中创建，被实例化时调用
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     在Xib中创建，当.nib文件被加载时调用
     */
    override public func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }
    
    
    func layout(){
        self.backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor.clear
        mainView.removeFromSuperview()
        self.contentView.addSubview(mainView)
        
//        let screenWdith = UIUtils.getScreenWidth()
//        self.contentView.snp.makeConstraints { (make) in
//            make.left.top.equalTo(0)
//            make.width.lessThanOrEqualTo(screenWdith)
//            make.height.greaterThanOrEqualTo(20)
//        }
        
        mainView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
    
    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        setNeedsLayout()
        layoutIfNeeded()
        let size: CGSize = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var cellFrame: CGRect = layoutAttributes.frame
        cellFrame.size.height = size.height
        layoutAttributes.frame = cellFrame
        return layoutAttributes
    }
    
    
}
