//
//  GuidePageCell.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class GuidePageCell: UICollectionViewCell {
    
    // 定义block
    typealias finishBlock = () -> ()
    
    var finishCallBack: finishBlock?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var finishBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(finishBtnClicked), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.contentView.addSubview(self.finishBtn)
        var bottomSpace: CGFloat = -20
        if UI_IS_IPHONEX {
            bottomSpace = (-25 - TabBarBottomHeight)
        } else if UI_IS_IPHONEXR {
            bottomSpace = (-35 - TabBarBottomHeight)
        } else if UI_IS_IPHONEPLUS {
            bottomSpace = -30
        }
        self.finishBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().offset(bottomSpace)
        }
    }
    
    var image: UIImage? {
        didSet {
            if let pic = image {
                self.imageView.image = pic
            }
        }
    }
    
    var isShowBtn: Bool? {
        didSet {
            if let isShow = isShowBtn {
                self.finishBtn.isHidden = !isShow
            }
        }
    }
    
    @objc func finishBtnClicked() {
        if let _ = finishCallBack {
            finishCallBack!()
        }
    }
}


