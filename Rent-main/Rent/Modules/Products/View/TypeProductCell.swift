//
//  TypeProductCell.swift
//  Rent
//
//  Created by jiang on 2020/1/19.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit

class TypeProductCell: UICollectionViewCell {
    
    lazy var backView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = UIColor.darkGray
        label.font = TextFont_14
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = TextFont_13
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(self.backView)
        self.backView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.backView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(iconImageView.snp.width)
        }
        
        self.backView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom)
        }
        
        self.backView.addSubview(self.badgeLabel)
        self.badgeLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerX.equalTo(iconImageView.snp.right)
            make.centerY.equalTo(iconImageView.snp.top)
        }
    }
    
    /// Data
    var model = CategoryModel() {
        didSet {
            self.titleLabel.text = model.categoryName
            ImageUtils.display(self.iconImageView, path: model.categoryPic)
        }
    }
}
